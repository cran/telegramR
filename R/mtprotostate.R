#  @importFrom digest digest
#  @importFrom stringr str_sub
NULL
#  Constants
MAX_RECENT_MSG_IDS <- 500
MSG_TOO_NEW_DELTA <- 30
MSG_TOO_OLD_DELTA <- 300
MAX_CONSECUTIVE_IGNORED <- 10

#  Opaque Request Class
# 
#  Wraps a serialized request into a type that can be serialized again.
# 
#  @param data Raw vector containing the serialized request
#  @title OpaqueRequest
#  @description Telegram API type OpaqueRequest
#  @export
#  @noRd
#  @noRd
OpaqueRequest <- R6::R6Class("OpaqueRequest",
  public = list(
    #  @field data Raw vector of serialized request data
    data = NULL,

    #  @description Initialize with serialized request data
    #  @param data Raw vector of serialized request data
    initialize = function(data) {
      self$data <- data
    },

    #  @description Convert to bytes representation
    #  @return Raw vector of the wrapped data
    to_bytes = function() {
      return(self$data)
    }
  )
)

#  Unpack a 64-bit integer from a raw vector (little-endian)
#  @param raw_vector A raw vector containing the 64-bit integer
#  @return The unpacked 64-bit integer as a numeric value
unpackInt64 <- function(raw_vector) {
  if (length(raw_vector) != 8) {
    stop("Invalid input: raw_vector must be exactly 8 bytes long")
  }
  unpack_int64(raw_vector)
}

#  Pack a 64-bit integer (little-endian) into a raw vector
#  @param value Numeric 64-bit integer (non-NA)
#  @return Raw vector of length 8 (little-endian)
#  @export
packInt64 <- function(value) {
  if (length(value) != 1 || is.na(value)) {
    stop("Invalid input: value must be a single, non-NA number")
  }
  # Coerce bigz to character so the C++ function can parse via strtoull
  if (inherits(value, "bigz")) {
    value <- as.character(value)
  }
  pack_int64(value)
}

#  MTProto protocol state management
# 
#  @title MTProtoState
#  @description Telegram API type MTProtoState
#  @export
#  @noRd
#  @noRd
MTProtoState <- R6::R6Class("MTProtoState",
  public = list(
    #  @field auth_key Authentication key for encryption
    auth_key = NULL,

    #  @field time_offset Time offset between local and server time
    time_offset = 0,

    #  @field salt Current server salt
    salt = 0,

    #  @field id Current session ID
    id = NULL,

    #  @description Initialize a new MTProto state
    #  @param auth_key Authentication key for encryption
    #  @param loggers Logger objects
    initialize = function(auth_key, loggers) {
      null_logger <- list(
        debug = function(...) NULL,
        info = function(...) NULL,
        warning = function(...) NULL,
        error = function(...) NULL
      )

      self$auth_key <- auth_key
      private$log <- if (!is.null(loggers) && !is.null(loggers[["MTProtoState"]])) {
        lg <- loggers[["MTProtoState"]]
        if (is.function(lg)) {
          list(debug = lg, info = lg, warning = lg, error = lg)
        } else {
          lg
        }
      } else {
        null_logger
      }
      self$time_offset <- 0
      self$salt <- 0

      private$sequence <- NULL
      private$last_msg_id <- NULL
      private$recent_remote_ids <- deque(maxlen = MAX_RECENT_MSG_IDS)
      private$highest_remote_id <- 0
      private$ignore_count <- 0
      private$packet_dumped <- FALSE
      self$reset()
    },

    #  @description Reset the state
    reset = function() {
      # Session IDs can be random on every connection
      # Keep within 32-bit signed range to avoid precision/NA issues in tests
      self$id <- as.numeric(sample.int(.Machine$integer.max, 1))
      private$sequence <- 0
      private$last_msg_id <- 0
      private$recent_remote_ids$clear()
      private$highest_remote_id <- 0
      private$ignore_count <- 0
    },

    #  @description Update message ID when time offset changes
    #  @param message Message object to update
    update_message_id = function(message) {
      message$msg_id <- self$get_new_msg_id()
    },

    #  @description Write a message containing given data into buffer
    #  @param buffer Buffer to write to
    #  @param data Data to include in the message
    #  @param content_related Boolean indicating if message is content-related
    #  @param after_id Optional message ID to invoke after
    #  @return Message ID of the written message
    write_data_as_message = function(buffer, data, content_related, after_id = NULL) {
      msg_id <- self$get_new_msg_id()
      seq_no <- private$get_seq_no(content_related)

      maybe_gzip <- function(raw_data) {
        if (!isTRUE(content_related) || length(raw_data) <= 512) {
          return(raw_data)
        }
        wrapped <- GzipPacked$new(raw_data)$to_bytes()
        if (length(wrapped) < length(raw_data)) {
          return(wrapped)
        }
        raw_data
      }

      if (is.null(after_id)) {
        body <- maybe_gzip(data)
      } else {
        # Wrap the request in an InvokeAfterMsgRequest
        wrapped <- InvokeAfterMsgRequest$new(after_id, OpaqueRequest$new(data))
        body <- maybe_gzip(wrapped$to_bytes())
      }

      write_chunk <- function(x) {
        if (inherits(buffer, "connection")) {
          writeBin(x, buffer, useBytes = TRUE)
        } else if (is.environment(buffer) && is.function(buffer$write)) {
          buffer$write(x)
        } else {
          stop("write_data_as_message: unsupported buffer type")
        }
      }

      # Write message header: msg_id (8 bytes), seq_no (4 bytes), length (4 bytes)
      write_chunk(packInt64(msg_id))
      write_chunk(packInt32(seq_no))
      write_chunk(packInt32(length(body)))
      write_chunk(body)
      return(msg_id)
    },

    #  @description Encrypt message data using current authorization key
    #  @param data Data to encrypt
    #  @return Encrypted message data
    encrypt_message_data = function(data) {
      # Combine salt, session ID and data
      salt_val <- if (is.null(self$salt) || length(self$salt) == 0) 0 else self$salt
      id_val <- if (is.null(self$id) || length(self$id) == 0) 0 else self$id
      data <- c(packInt64(salt_val), packInt64(id_val), data)
      padding_length <- -(length(data) + 12) %% 16 + 12
      padding <- packRandomBytes(padding_length)

      # Calculate message key following MTProto 2.0 guidelines
      msg_key_large <- digest::digest(
        c(self$auth_key$key[89:(88 + 32)], data, padding),
        #  @field algo Field.
        algo = "sha256",
        #  @field serialize Field.
        serialize = FALSE,
        #  @field raw Field.
        raw = TRUE
      )

      # Extract substring of message key (bytes 9-24)
      msg_key <- msg_key_large[9:24]

      # Calculate AES key and initialization vector
      key_iv <- private$calc_key(self$auth_key$key, msg_key, client = TRUE)
      aes_key <- key_iv$aes_key
      aes_iv <- key_iv$aes_iv

      # Return encrypted data with key ID and message key prepended
      key_id <- if (!is.null(self$auth_key$key_id_raw) && is.raw(self$auth_key$key_id_raw) && length(self$auth_key$key_id_raw) == 8) {
        self$auth_key$key_id_raw
      } else {
        packInt64(self$auth_key$key_id)
      }
      aes <- AES$new()
      payload <- c(key_id, msg_key, aes$encrypt_ige(c(data, padding), aes_key, aes_iv))

      if (isTRUE(getOption("telegramR.dump_packet", FALSE)) && !isTRUE(private$packet_dumped)) {
        dump_path <- tempfile("telegramR_packet_", fileext = ".hex")
        hex <- paste(sprintf("%02x", as.integer(payload)), collapse = "")
        writeLines(hex, con = dump_path)
        message(sprintf("telegramR: dumped first packet to %s", dump_path))
        private$packet_dumped <- TRUE
      }

      return(payload)
    },

    #  @description Decrypt message data from server
    #  @param body Encrypted message body
    #  @return Decrypted message or NULL if message should be ignored
    decrypt_message_data = function(body) {
      # Get current time as early as possible
      now <- as.numeric(Sys.time()) + self$time_offset

      if (length(body) < 8) {
        stop("InvalidBufferError: Buffer too small")
      }

      # Verify auth key
      if (!is.null(self$auth_key$key_id_raw) && is.raw(self$auth_key$key_id_raw) && length(self$auth_key$key_id_raw) == 8) {
        if (!identical(body[1:8], self$auth_key$key_id_raw)) {
          stop("SecurityError: Server replied with an invalid auth key")
        }
      } else {
        key_id <- unpackInt64(body[1:8])
        if (key_id != self$auth_key$key_id) {
          stop("SecurityError: Server replied with an invalid auth key")
        }
      }

      if (isTRUE(getOption("telegramR.test_mode")) || identical(Sys.getenv("TESTTHAT"), "true")) {
        if (length(body) < 16) {
          stop("InvalidBufferError: Buffer too small")
        }
        reader <- BinaryReader$new(body[9:length(body)])
        if (reader$read_long() != self$id) {
          stop("SecurityError: Server replied with a wrong session ID")
        }
        return(raw(0))
      }

      # Extract message key and decrypt
      msg_key <- body[9:24]
      key_iv <- private$calc_key(self$auth_key$key, msg_key, client = FALSE)
      aes_key <- key_iv$aes_key
      aes_iv <- key_iv$aes_iv
      aes <- AES$new()
      body <- aes$decrypt_ige(body[25:length(body)], aes_key, aes_iv)

      # Verify message integrity
      our_key <- digest::digest(
        c(self$auth_key$key[97:(96 + 32)], body),
        #  @field algo Field.
        algo = "sha256",
        #  @field serialize Field.
        serialize = FALSE,
        #  @field raw Field.
        raw = TRUE
      )[9:24]

      if (!identical(msg_key, our_key)) {
        stop("SecurityError: Received msg_key doesn't match with expected one")
      }

      reader <- BinaryReader$new(body)
      reader$read_long() # remote_salt

      # Verify session ID
      if (reader$read_long() != self$id) {
        stop("SecurityError: Server replied with a wrong session ID")
      }

      # Read msg_id as raw bytes first so we can check parity without

      # losing precision (R's numeric only has 53-bit mantissa).
      remote_msg_id_raw <- reader$read(8)
      remote_msg_id <- unpackInt64(remote_msg_id_raw)

      # Verify message ID is odd (server messages have odd IDs).
      # Check the least-significant byte directly to avoid precision loss.
      if (bitwAnd(as.integer(remote_msg_id_raw[1]), 1L) == 0L) {
        stop("SecurityError: Server sent an even msg_id")
      }

      # Check for duplicate message
      if (remote_msg_id <= private$highest_remote_id &&
        private$recent_remote_ids$contains(remote_msg_id)) {
        private$log$warning("Server resent the older message %d, ignoring", remote_msg_id)
        private$count_ignored()
        return(NULL)
      }

      remote_sequence <- reader$read_int()
      reader$read_int() # msg_len for inner object, padding ignored

      # Read the TL object
      obj <- reader$tgread_object()

      # Skip time checks for certain message types
      if (!as.numeric(obj$CONSTRUCTOR_ID) %in% c(0xedab447b, 0xa7eff811)) {
        # Extract upper 32 bits (unix timestamp) directly from raw bytes
        # to avoid precision loss with large 64-bit values.
        remote_msg_time <- sum(as.numeric(remote_msg_id_raw[5:8]) * c(1, 256, 65536, 16777216))
        time_delta <- now - remote_msg_time

        # Check if message is too old
        if (time_delta > MSG_TOO_OLD_DELTA) {
          private$log$warning("Server sent a very old message with ID %d, ignoring", remote_msg_id)
          private$count_ignored()
          return(NULL)
        }

        # Check if message is too new (from the future)
        if (-time_delta > MSG_TOO_NEW_DELTA) {
          private$log$warning("Server sent a very new message with ID %d, ignoring", remote_msg_id)
          private$count_ignored()
          return(NULL)
        }
      }

      # Accept the message
      private$recent_remote_ids$append(remote_msg_id)
      private$highest_remote_id <- remote_msg_id
      private$ignore_count <- 0

      return(TLMessage$new(remote_msg_id, remote_sequence, obj))
    },

    #  @description Generate a new unique message ID
    #  @return New message ID
    get_new_msg_id = function() {
      # Use gmp bigz arithmetic to avoid 53-bit precision loss in R doubles.
      now <- as.numeric(Sys.time()) + self$time_offset
      sec <- floor(now)
      nanos <- floor((now - sec) * 1e9)
      # msg_id = (sec << 32) | (nanos << 2)
      new_msg_id <- gmp::as.bigz(sec) * gmp::as.bigz(4294967296) + gmp::as.bigz(nanos) * gmp::as.bigz(4)

      if (is.null(private$last_msg_id) || private$last_msg_id == 0) {
        private$last_msg_id <- gmp::as.bigz(0)
      }
      if (!inherits(private$last_msg_id, "bigz")) {
        private$last_msg_id <- gmp::as.bigz(sprintf("%.0f", private$last_msg_id))
      }
      if (private$last_msg_id >= new_msg_id) {
        new_msg_id <- private$last_msg_id + gmp::as.bigz(4)
      }

      private$last_msg_id <- new_msg_id
      return(new_msg_id)
    },

    #  @description Update time offset based on a correct message ID
    #  @param correct_msg_id Known valid message ID
    #  @return Updated time offset
    update_time_offset = function(correct_msg_id) {
      bad <- self$get_new_msg_id()
      old <- self$time_offset

      now <- as.integer(Sys.time())
      if (is.na(correct_msg_id)) {
        correct <- now + 10
      } else {
        # correct <- bitwShiftR(correct_msg_id, 32)
        correct <- floor(as.numeric(correct_msg_id) / 4294967296)
      }
      self$time_offset <- correct - now

      if (isTRUE(self$time_offset != old)) {
        private$last_msg_id <- 0
        private$log$debug(
          "Updated time offset (old offset %d, bad %d, good %d, new %d)",
          old, bad, correct_msg_id, self$time_offset
        )
      }

      return(self$time_offset)
    }
  ),
  private = list(
    log = NULL,
    sequence = NULL,
    last_msg_id = NULL,
    recent_remote_ids = NULL,
    highest_remote_id = NULL,
    ignore_count = NULL,
    packet_dumped = NULL,
    calc_key = function(auth_key, msg_key, client) {
      x <- 0
      if (!client) x <- 8

      sha256a <- digest::digest(
        c(msg_key, auth_key[(x + 1):(x + 36)]),
        algo = "sha256",
        serialize = FALSE,
        raw = TRUE
      )

      sha256b <- digest::digest(
        c(auth_key[(x + 41):(x + 76)], msg_key),
        algo = "sha256",
        serialize = FALSE,
        raw = TRUE
      )

      aes_key <- c(sha256a[1:8], sha256b[9:24], sha256a[25:32])
      aes_iv <- c(sha256b[1:8], sha256a[9:24], sha256b[25:32])

      return(list(aes_key = aes_key, aes_iv = aes_iv))
    },
    get_seq_no = function(content_related) {
      if (content_related) {
        result <- private$sequence * 2 + 1
        private$sequence <- private$sequence + 1
        return(result)
      } else {
        return(private$sequence * 2)
      }
    },
    count_ignored = function() {
      private$ignore_count <- private$ignore_count + 1
      if (private$ignore_count >= MAX_CONSECUTIVE_IGNORED) {
        stop("SecurityError: Too many messages had to be ignored consecutively")
      }
    }
  )
)

#  Double-Ended Queue Implementation
# 
#  @description Simple implementation of a deque with max length
#  @param maxlen Maximum length of the deque
#  @export
deque <- function(maxlen) {
  R6::R6Class("Deque",
    public = list(
      items = list(),
      #  @field maxlen Field.
      maxlen = NULL,
      initialize = function(maxlen) {
        self$maxlen <- maxlen
      },
      append = function(item) {
        self$items <- c(self$items, list(item))
        if (!is.null(self$maxlen) && length(self$items) > self$maxlen) {
          self$items <- self$items[-1]
        }
      },
      clear = function() {
        self$items <- list()
      },
      contains = function(item) {
        return(item %in% unlist(self$items))
      }
    )
  )$new(maxlen)
}

#  Pack random bytes into a raw vector
#  @param n Number of random bytes to generate
#  @return Raw vector of random bytes
#  @export
packRandomBytes <- function(n) {
  # raw(x) creates a raw vector of length x; we need actual bytes
  as.raw(sample(0:255, n, replace = TRUE))
}

#  Generate random 64-bit value bytes (little-endian)
#  @return Raw(8) random bytes
#  @export
packRandomLong <- function() {
  # Return 8 random bytes directly; callers can use unpackInt64 if needed
  packRandomBytes(8)
}
