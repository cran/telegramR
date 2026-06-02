#  BinaryReader Class
# 
# 
#  @details
#  Provides methods to read various data types and handle stream positions.
# 
#  @title BinaryReader
#  @description Telegram API type BinaryReader
#  @export
#  @noRd
#  @noRd
BinaryReader <- R6::R6Class(
  "BinaryReader",
  public = list(
    #  @description
    #  Initializes the BinaryReader with the given binary data.
    #  @param data A raw vector representing the binary data to read.
    initialize = function(data) {
      private$stream <- NULL
      private$.last <- NULL
      private$.data <- data
      private$.pos <- 0L
    },

    #  @description
    #  Reads a single byte value.
    #  @return A single byte as an integer.
    read_byte = function() {
      return(as.integer(self$read(1L)[1]))
    },

    #  @description
    #  Reads a 4-byte integer value.
    #  @param signed A logical indicating whether the integer is signed.
    #  @return An integer value.
    read_int = function(signed = TRUE) {
      bytes <- self$read(4)
      return(self$bytes_to_int(bytes, signed))
    },

    #  @description
    #  Reads an 8-byte long integer value.
    #  @param signed A logical indicating whether the integer is signed.
    #  @return A long integer value.
    read_long = function(signed = TRUE) {
      bytes <- self$read(8)
      return(self$bytes_to_int(bytes, signed))
    },

    #  @description
    #  Reads a 4-byte floating-point value.
    #  @return A numeric value.
    read_float = function() {
      bytes <- self$read(4L)
      con <- rawConnection(bytes, "rb")
      on.exit(close(con))
      val <- readBin(con, what = "numeric", n = 1L, size = 4L, endian = "little")
      return(val)
    },

    #  @description
    #  Reads an 8-byte floating-point value.
    #  @return A numeric value.
    read_double = function() {
      bytes <- self$read(8L)
      con <- rawConnection(bytes, "rb")
      on.exit(close(con))
      val <- readBin(con, what = "numeric", n = 1L, size = 8L, endian = "little")
      return(val)
    },

    #  @description
    #  Reads a specified number of bytes.
    #  @param length An integer specifying the number of bytes to read.
    #  @return A raw vector of the read bytes.
    read = function(length = -1) {
      if (length == 0) {
        result <- raw(0)
        private$.last <- result
        return(result)
      }
      if (length < 0) {
        result <- private$.data[(private$.pos + 1L):length(private$.data)]
        private$.pos <- length(private$.data)
        private$.last <- result
        return(result)
      }
      start <- private$.pos + 1L
      end <- private$.pos + length
      if (start > length(private$.data)) {
        result <- raw(0)
      } else {
        end <- min(end, length(private$.data))
        result <- private$.data[start:end]
      }
      if (length >= 0 && length(result) != length) {
        stop(sprintf(
          "No more data left to read (need %d, got %d); last read: %s",
          length, length(result), paste(private$.last, collapse = " ")
        ))
      }
      private$.last <- result
      private$.pos <- private$.pos + length
      return(result)
    },

    #  @description
    #  Gets the byte array representing the current buffer as a whole.
    #  @return A raw vector of the entire buffer.
    get_bytes = function() {
      return(private$.data)
    },

    #  @description
    #  Closes the reader, freeing the raw connection.
    close = function() {
      invisible(NULL)
    },


    #  @description
    #  Tells the current position in the stream.
    #  @return An integer representing the current position.
    tell_position = function() {
      return(private$.pos)
    },

    #  @description
    #  Sets the current position in the stream.
    #  @param position An integer specifying the position to set.
    set_position = function(position) {
      private$.pos <- as.integer(position)
    },

    #  @description
    #  Seeks the stream position by a given offset.
    #  @param offset An integer specifying the offset to seek.
    seek = function(offset) {
      private$.pos <- private$.pos + as.integer(offset)
    },

    #  @description
    #  Converts a byte vector to an integer.
    #  @param bytes A raw vector representing the bytes.
    #  @param signed A logical indicating whether the integer is signed.
    #  @return An integer value.
    bytes_to_int = function(bytes, signed = TRUE) {
      if (length(bytes) > 4) {
        # Use big integer arithmetic to preserve full 64-bit precision.
        val <- gmp::as.bigz(paste0("0x", bytes_to_hex_be_cpp(bytes)))
        if (signed) {
          max_val <- gmp::pow.bigz(2, 8 * length(bytes))
          if (val >= max_val / 2) val <- val - max_val
        }
        return(val)
      } else {
        bytes_to_int32_cpp(bytes, isTRUE(signed))
      }
    },

    #  @description
    #  Reads a large integer (128, 256, etc bits).
    #  @param bits Number of bits to read.
    #  @return A bigz value.
    read_large_int = function(bits) {
      bytes <- self$read(bits / 8)
      return(gmp::as.bigz(paste0("0x", bytes_to_hex_be_cpp(bytes))))
    },

    #  @description
    #  Reads a Telegram-encoded byte array.
    #  @return A raw vector.
    tgread_bytes = function() {
      first_byte <- as.integer(self$read(1))
      if (first_byte == 254) {
        length <- self$bytes_to_int(self$read(3), signed = FALSE)
      } else {
        length <- first_byte
      }
      data <- self$read(length)

      # Padding
      padding <- if (first_byte == 254) length %% 4 else (length + 1) %% 4
      if (padding > 0) {
        self$read(4 - padding)
      }

      return(data)
    },

    #  @description
    #  Alias for tgread_bytes (some generated code uses this name).
    #  @return A raw vector.
    tgreadbytes = function() {
      self$tgread_bytes()
    },

    #  @description
    #  Reads a Telegram-encoded string.
    #  @return A character string.
    tgread_string = function() {
      return(rawToChar(self$tgread_bytes()))
    },

    #  @description
    #  Reads a 32-bit Unix timestamp and returns it as a POSIXct datetime.
    #  @return A POSIXct datetime or NULL if the timestamp is 0.
    tgread_date = function() {
      value <- self$read_int(signed = FALSE)
      if (is.null(value) || value == 0) {
        return(NULL)
      }
      as.POSIXct(as.numeric(value), origin = "1970-01-01", tz = "UTC")
    },

    #  @description
    #  Reads a TL object.
    #  @return A TL object or raw bytes if type unknown.
    tgread_object = function() {
      constructor_id <- self$read_int(signed = FALSE)
      if (isTRUE(getOption("telegramR.trace_parse", FALSE))) {
        message(sprintf(
          "[trace] tgread_object ctor=%s pos=%s rem=%s",
          as.character(constructor_id),
          as.character(self$tell_position()),
          as.character(length(private$.data) - self$tell_position())
        ))
      }
      if (!is.null(constructor_id) &&
        identical(.telegramR_norm_ctor_id(constructor_id), .telegramR_norm_ctor_id(0x3072cfa1))) {
        # GzipPacked: decompress and parse inner object
        packed <- self$tgread_bytes()
        inner <- tryCatch(memDecompress(packed, type = "gzip"), error = function(e) NULL)
        if (is.null(inner)) {
          return(list(CONSTRUCTOR_ID = constructor_id, data = packed))
        }
        inner_reader <- BinaryReader$new(inner)
        on.exit(tryCatch(inner_reader$close(), error = function(e) NULL), add = TRUE)
        return(inner_reader$tgread_object())
      }
      if (!is.null(constructor_id) && constructor_id == 481674261) { # Vector (0x1cb5c415)
        count <- self$read_int()
        if (isTRUE(getOption("telegramR.trace_parse", FALSE))) {
          message(sprintf(
            "[trace] tgread_object vector count=%s rem=%s",
            as.character(count),
            as.character(length(private$.data) - self$tell_position())
          ))
        }
        max_possible <- floor((length(private$.data) - self$tell_position()) / 4)
        if (is.null(count) || count < 0 || count > max_possible) {
          cur <- self$tell_position()
          remaining <- length(private$.data) - cur
          return(list(CONSTRUCTOR_ID = constructor_id, data = if (remaining > 0) self$read(remaining) else raw(0)))
        }
        res <- list()
        if (count > 0) {
          for (i in seq_len(count)) {
            res[[i]] <- self$tgread_object()
          }
        }
        return(res)
      }
      # Special-case User constructor (newer layer) to avoid parse failures
      if (!is.null(constructor_id) &&
        identical(.telegramR_norm_ctor_id(constructor_id), .telegramR_norm_ctor_id(34280482))) {
        return(.telegramR_read_user(self))
      }
      # Special-case contacts.ResolvedPeer (newer layer) to avoid parse failures
      if (!isTRUE(getOption("telegramR.disable_contacts_resolved_peer")) &&
        !is.null(constructor_id) &&
        identical(.telegramR_norm_ctor_id(constructor_id), .telegramR_norm_ctor_id(2131196633))) {
        return(.telegramR_read_contacts_resolved_peer(self))
      }
      # Special-case messages.ChannelMessages to ensure messages parse correctly
      if (!is.null(constructor_id) &&
        identical(.telegramR_norm_ctor_id(constructor_id), .telegramR_norm_ctor_id(3346446926))) {
        return(.telegramR_read_channel_messages(self))
      }
      # Special-case messages.Messages
      if (!is.null(constructor_id) &&
        identical(.telegramR_norm_ctor_id(constructor_id), .telegramR_norm_ctor_id(494135274))) {
        return(.telegramR_read_messages(self))
      }
      # Special-case messages.MessagesSlice
      if (!is.null(constructor_id) &&
        identical(.telegramR_norm_ctor_id(constructor_id), .telegramR_norm_ctor_id(1595959062))) {
        return(.telegramR_read_messages_slice(self))
      }
      # Special-case messages.MessagesNotModified
      if (!is.null(constructor_id) &&
        identical(.telegramR_norm_ctor_id(constructor_id), .telegramR_norm_ctor_id(1951620897))) {
        return(.telegramR_read_messages_not_modified(self))
      }
      # Special-case MessageService to avoid stale R6 from_reader
      if (!is.null(constructor_id) &&
        identical(.telegramR_norm_ctor_id(constructor_id), .telegramR_norm_ctor_id(0x7a800e0a))) {
        return(.telegramR_read_message_service(self))
      }
      # Special-case ChannelFull
      if (!is.null(constructor_id) &&
        identical(.telegramR_norm_ctor_id(constructor_id), .telegramR_norm_ctor_id(0xe4e0b29d))) {
        return(.telegramR_read_channel_full(self))
      }
      # Special-case Channel to avoid parse failures on newer flags
      if (!is.null(constructor_id) &&
        identical(.telegramR_norm_ctor_id(constructor_id), .telegramR_norm_ctor_id(0xfe685355))) {
        return(.telegramR_read_channel(self))
      }
      # Special-case messages.ChatFull (used by channels.getFullChannel)
      if (!is.null(constructor_id) &&
        identical(.telegramR_norm_ctor_id(constructor_id), .telegramR_norm_ctor_id(0xe5d7d19c))) {
        return(.telegramR_read_messages_chat_full(self))
      }
      ctor_key <- .telegramR_norm_ctor_id(constructor_id)
      ctor_map <- .telegramR_get_ctor_map()
      cls <- ctor_map[[ctor_key]]
      if (isTRUE(getOption("telegramR.trace_parse", FALSE))) {
        message(sprintf(
          "[trace] tgread_object ctor=%s class=%s pos=%s rem=%s",
          as.character(constructor_id),
          if (!is.null(cls) && !is.null(cls$classname)) cls$classname else "NULL",
          as.character(self$tell_position()),
          as.character(length(private$.data) - self$tell_position())
        ))
      }

      if (is.null(cls)) {
        if (isTRUE(getOption("telegramR.debug_parse"))) {
          message(sprintf(
            "[tgread_object] unknown ctor=%s at pos=%s",
            as.character(constructor_id),
            as.character(self$tell_position())
          ))
        }
        if (isTRUE(getOption("telegramR.trace_parse", FALSE))) {
          message(sprintf(
            "[trace] unknown ctor=%s pos=%s rem=%s",
            as.character(constructor_id),
            as.character(self$tell_position()),
            as.character(length(private$.data) - self$tell_position())
          ))
        }
        cur <- self$tell_position()
        remaining <- length(private$.data) - cur
        if (remaining <= 0) {
          if (isTRUE(getOption("telegramR.trace_parse", FALSE))) {
            message(sprintf("[trace] unknown ctor=%s return empty", as.character(constructor_id)))
          }
          return(list(CONSTRUCTOR_ID = constructor_id, data = raw(0)))
        }
        data <- self$read(remaining)
        if (isTRUE(getOption("telegramR.trace_parse", FALSE))) {
          message(sprintf("[trace] unknown ctor=%s read remaining=%d", as.character(constructor_id), length(data)))
        }
        return(list(CONSTRUCTOR_ID = constructor_id, data = data))
      }

      # Save position right after reading constructor_id so we can rewind
      # on from_reader failure (it may have consumed bytes before failing).
      pos_after_ctor <- self$tell_position()

      # Most generated classes expose parser as private$from_reader.
      # Try to instantiate; if the constructor requires args, create with
      # a zero-arg tryCatch and fall back to using the class generator directly.
      obj <- tryCatch(cls$new(), error = function(e) NULL)

      # Prefer class-level from_reader to avoid relying on instance methods
      # (some classes lack a working self$new on instances).
      from_reader_fn <- NULL
      if (!is.null(cls$private_methods) && is.function(cls$private_methods$from_reader)) {
        from_reader_fn <- cls$private_methods$from_reader
        # Fix the function's environment so it can find the class it needs
        # to construct (e.g. BadServerSalt$new inside from_reader).
        # The extracted function's enclosing env may not have the class in scope.
        fn_env <- new.env(parent = environment(from_reader_fn))
        fn_env[[cls$classname]] <- cls
        # Provide a `self` proxy so from_reader methods that call
        # self$initialize(...) or self$new(...) work correctly outside R6 context.
        # The proxy delegates these calls to cls$new(...).
        self_proxy <- new.env(parent = emptyenv())
        self_proxy$initialize <- function(...) cls$new(...)
        self_proxy$new <- function(...) cls$new(...)
        fn_env$self <- self_proxy
        environment(from_reader_fn) <- fn_env
      } else if (!is.null(obj)) {
        private_env <- obj$.__enclos_env__$private
        if (is.environment(private_env) && is.function(private_env$from_reader)) {
          from_reader_fn <- private_env$from_reader
        }
      }

      if (!is.null(from_reader_fn)) {
        if (isTRUE(getOption("telegramR.trace_parse", FALSE))) {
          message(sprintf(
            "[trace] from_reader start ctor=%s class=%s pos=%s",
            as.character(constructor_id),
            if (!is.null(cls) && !is.null(cls$classname)) cls$classname else "unknown",
            as.character(self$tell_position())
          ))
        }
        parsed <- tryCatch(from_reader_fn(self), error = function(e) {
          if (isTRUE(getOption("telegramR.debug_parse"))) {
            msg <- sprintf(
              "[tgread_object] from_reader failed for ctor=%s class=%s at pos=%s: %s",
              as.character(constructor_id),
              if (!is.null(cls$classname)) cls$classname else "unknown",
              as.character(self$tell_position()),
              conditionMessage(e)
            )
            message(msg)
          }
          if (isTRUE(getOption("telegramR.trace_parse", FALSE))) {
            message(sprintf(
              "[trace] from_reader error ctor=%s class=%s pos=%s: %s",
              as.character(constructor_id),
              if (!is.null(cls$classname)) cls$classname else "unknown",
              as.character(self$tell_position()),
              conditionMessage(e)
            ))
          }
          # Rewind reader to position right after constructor_id so the
          # fallback data contains ALL the object bytes.
          tryCatch(self$set_position(pos_after_ctor), error = function(e2) NULL)
          cur <- self$tell_position()
          remaining <- length(private$.data) - cur
          if (remaining > 0) {
            list(CONSTRUCTOR_ID = constructor_id, data = self$read(remaining))
          } else {
            list(CONSTRUCTOR_ID = constructor_id, data = raw(0))
          }
        })
        if (isTRUE(getOption("telegramR.trace_parse", FALSE))) {
          message(sprintf(
            "[trace] from_reader done ctor=%s class=%s pos=%s",
            as.character(constructor_id),
            if (!is.null(cls) && !is.null(cls$classname)) cls$classname else "unknown",
            as.character(self$tell_position())
          ))
        }
        if (inherits(parsed, "R6")) {
          return(parsed)
        }
        if (inherits(parsed, class(cls$classname)[1]) || inherits(parsed, cls$classname)) {
          return(parsed)
        }
        if (is.list(parsed)) {
          result <- tryCatch(do.call(cls$new, parsed), error = function(e) parsed)
          return(result)
        }
        if (!is.null(parsed)) {
          return(parsed)
        }
      }

      # Fallback: return blank object or raw data
      if (!is.null(obj)) {
        return(obj)
      }
      tryCatch(self$set_position(pos_after_ctor), error = function(e2) NULL)
      cur <- self$tell_position()
      remaining <- length(private$.data) - cur
      if (remaining > 0) {
        list(CONSTRUCTOR_ID = constructor_id, data = self$read(remaining))
      } else {
        list(CONSTRUCTOR_ID = constructor_id, data = raw(0))
      }
    }
  ),
  private = list(
    finalize = function() {
      invisible(NULL)
    },
    stream = NULL,
    .last = NULL,
    .data = NULL,
    .pos = 0L
  )
)

.telegramR_norm_ctor_id <- function(x) {
  v <- as.numeric(x)[1]
  if (is.na(v)) {
    return(NA_character_)
  }
  if (v < 0) v <- v + 2^32
  sprintf("%.0f", v)
}

.telegramR_get_ctor_map <- function() {
  cache <- getOption("telegramR.ctor_map")
  if (!isTRUE(getOption("telegramR.debug_parse")) &&
    is.list(cache) && length(cache) > 0) {
    return(cache)
  }

  # Search multiple environments to handle both installed package and
  # devtools::load_all() / source() workflows.
  envs_to_search <- list()
  tryCatch(
    {
      pkg_name <- utils::packageName()
      if (!is.null(pkg_name) && nzchar(pkg_name)) {
        envs_to_search <- c(envs_to_search, list(asNamespace(pkg_name)))
      }
    },
    error = function(e) NULL
  )
  tryCatch(
    {
      ns <- asNamespace("telegramR")
      if (!any(vapply(envs_to_search, identical, logical(1), ns))) {
        envs_to_search <- c(envs_to_search, list(ns))
      }
    },
    error = function(e) NULL
  )
  # Also search the global environment (for source()'d code)
  envs_to_search <- c(envs_to_search, list(.GlobalEnv))
  if (isTRUE(getOption("telegramR.debug_parse"))) {
    # Prefer freshly loaded classes in the global environment
    envs_to_search <- c(list(.GlobalEnv), envs_to_search)
  }

  out <- list()
  seen_names <- character(0)
  for (env in envs_to_search) {
    for (nm in ls(envir = env, all.names = TRUE)) {
      if (nm %in% seen_names) next
      seen_names <- c(seen_names, nm)
      obj <- tryCatch(get(nm, envir = env, inherits = FALSE), error = function(e) NULL)
      if (!inherits(obj, "R6ClassGenerator")) next
      cid <- NULL
      pf <- obj$public_fields
      if (!is.null(pf) && !is.null(pf$CONSTRUCTOR_ID)) {
        cid <- tryCatch(
          {
            v <- pf$CONSTRUCTOR_ID
            if (is.function(v)) v <- v()
            v
          },
          error = function(e) NULL
        )
      }
      if (is.null(cid)) {
        af <- obj$active
        if (!is.null(af) && !is.null(af$CONSTRUCTOR_ID) && is.function(af$CONSTRUCTOR_ID)) {
          cid <- tryCatch(af$CONSTRUCTOR_ID(), error = function(e) {
            tryCatch(
              {
                inst <- obj$new()
                inst$CONSTRUCTOR_ID
              },
              error = function(e2) NULL
            )
          })
        }
      }
      if (is.null(cid)) next

      key <- .telegramR_norm_ctor_id(cid)
      if (is.na(key)) next
      out[[key]] <- obj
    }
  }

  # Map newer User constructor ID (seen in Telegram layer) to existing User class
  if (!is.null(out) && is.null(out[[.telegramR_norm_ctor_id(34280482)]])) {
    user_cls <- out[[.telegramR_norm_ctor_id(0x57258a18)]]
    if (inherits(user_cls, "R6ClassGenerator")) {
      out[[.telegramR_norm_ctor_id(34280482)]] <- user_cls
    }
  }

  # Map newer contacts.ResolvedPeer constructor ID to existing class if needed
  if (!is.null(out) && is.null(out[[.telegramR_norm_ctor_id(2131196633)]])) {
    crp_cls <- out[[.telegramR_norm_ctor_id(0x7f077ad9)]]
    if (inherits(crp_cls, "R6ClassGenerator")) {
      out[[.telegramR_norm_ctor_id(2131196633)]] <- crp_cls
    }
  }


  # Only cache if we found at least some classes; otherwise retry next time
  if (length(out) > 0) {
    options(telegramR.ctor_map = out)
  }
  out
}

.telegramR_read_user_profile_photo <- function(reader) {
  ctor <- reader$read_int(signed = FALSE)
  ctor_key <- .telegramR_norm_ctor_id(ctor)
  up_key <- .telegramR_norm_ctor_id(UserProfilePhoto$public_fields$CONSTRUCTOR_ID)
  upe_key <- .telegramR_norm_ctor_id(UserProfilePhotoEmpty$public_fields$CONSTRUCTOR_ID)

  if (identical(ctor_key, up_key)) {
    flags <- reader$read_int()
    has_video <- bitwAnd(flags, 1) != 0
    personal <- bitwAnd(flags, 4) != 0
    photo_id <- reader$read_long()
    stripped_thumb <- if (bitwAnd(flags, 2) != 0) reader$tgread_bytes() else NULL
    dc_id <- reader$read_int()
    return(UserProfilePhoto$new(
      photo_id = photo_id, dc_id = dc_id,
      has_video = has_video, personal = personal,
      stripped_thumb = stripped_thumb
    ))
  }
  if (identical(ctor_key, upe_key)) {
    return(UserProfilePhotoEmpty$new())
  }

  # Fallback: rewind and parse generically
  reader$set_position(reader$tell_position() - 4)
  reader$tgread_object()
}

.telegramR_read_peer <- function(reader) {
  start_pos <- reader$tell_position()
  ctor <- reader$read_int(signed = FALSE)
  ctor_key <- .telegramR_norm_ctor_id(ctor)
  # PeerUser
  if (identical(ctor_key, .telegramR_norm_ctor_id(PeerUser$public_fields$CONSTRUCTOR_ID))) {
    user_id <- reader$read_long()
    return(PeerUser$new(user_id = user_id))
  }
  # PeerChat
  if (identical(ctor_key, .telegramR_norm_ctor_id(PeerChat$public_fields$CONSTRUCTOR_ID))) {
    chat_id <- reader$read_long()
    return(PeerChat$new(chat_id = chat_id))
  }
  # PeerChannel
  if (identical(ctor_key, .telegramR_norm_ctor_id(PeerChannel$public_fields$CONSTRUCTOR_ID))) {
    channel_id <- reader$read_long()
    return(PeerChannel$new(channel_id = channel_id))
  }
  # Fallback: rewind and let tgread_object handle it
  tryCatch(reader$set_position(start_pos), error = function(e) NULL)
  reader$tgread_object()
}

.telegramR_read_contacts_resolved_peer <- function(reader) {
  peer <- .telegramR_read_peer(reader)
  # Vector<User>
  vec_ctor <- reader$read_int(signed = FALSE)
  if (!identical(.telegramR_norm_ctor_id(vec_ctor), .telegramR_norm_ctor_id(481674261))) {
    # Not a vector; rewind 4 bytes and try generic parsing
    tryCatch(reader$set_position(reader$tell_position() - 4), error = function(e) NULL)
    return(list(peer = peer, users = list(), chats = list()))
  }
  n_users <- reader$read_int()
  users <- if (n_users > 0) lapply(seq_len(n_users), function(i) reader$tgread_object()) else list()
  # Vector<Chat>
  vec_ctor2 <- reader$read_int(signed = FALSE)
  if (!identical(.telegramR_norm_ctor_id(vec_ctor2), .telegramR_norm_ctor_id(481674261))) {
    tryCatch(reader$set_position(reader$tell_position() - 4), error = function(e) NULL)
    return(ContactsResolvedPeer$new(peer = peer, users = users, chats = list()))
  }
  n_chats <- reader$read_int()
  chats <- if (n_chats > 0) lapply(seq_len(n_chats), function(i) reader$tgread_object()) else list()
  ContactsResolvedPeer$new(peer = peer, users = users, chats = chats)
}

.telegramR_read_channel_messages <- function(reader) {
  flags <- reader$read_int()
  inexact <- bitwAnd(flags, 2) != 0
  pts <- reader$read_int()
  count <- reader$read_int()
  offset_id_offset <- if (bitwAnd(flags, 4) != 0) reader$read_int() else NULL

  # Vector<Message>
  vec_ctor <- reader$read_int() # vector ctor
  n_messages <- reader$read_int()
  if (isTRUE(getOption("telegramR.debug_parse"))) {
    message(sprintf(
      "[channel_messages] flags=%s pts=%s count=%s offset_id_offset=%s vec_ctor=%s n_messages=%s",
      as.character(flags), as.character(pts), as.character(count),
      if (is.null(offset_id_offset)) "NULL" else as.character(offset_id_offset),
      as.character(vec_ctor), as.character(n_messages)
    ))
  }
  messages <- list()
  if (n_messages > 0) {
    for (i in seq_len(n_messages)) {
      if (isTRUE(getOption("telegramR.debug_parse"))) {
        pos <- tryCatch(reader$tell_position(), error = function(e) NA)
        ctor <- tryCatch({
          peek_pos <- reader$tell_position()
          v <- reader$read_int(signed = FALSE)
          reader$set_position(peek_pos)
          v
        }, error = function(e) NA)
        message(sprintf("[channel_messages] message[%d] pos=%s ctor=%s", i, as.character(pos), as.character(ctor)))
      }
      obj <- tryCatch(
        reader$tgread_object(),
        error = function(e) {
          if (isTRUE(getOption("telegramR.debug_parse"))) {
            message(sprintf(
              "[channel_messages] message[%d] parse error: %s",
              i, conditionMessage(e)
            ))
          }
          NULL
        }
      )
      if (is.null(obj)) break
      messages[[length(messages) + 1L]] <- obj
    }
  }

  # Vector<ForumTopic>
  topics <- list()
  topics_ok <- TRUE
  tryCatch({
    reader$read_int()
    n_topics <- reader$read_int()
    if (n_topics > 0) {
      topics <- lapply(seq_len(n_topics), function(i) reader$tgread_object())
    }
  }, error = function(e) {
    topics_ok <<- FALSE
  })
  if (!topics_ok) {
    return(list(
      pts = pts,
      count = count,
      messages = messages,
      topics = topics,
      chats = list(),
      users = list(),
      inexact = inexact,
      offset_id_offset = offset_id_offset
    ))
  }

  # Vector<Chat>
  chats <- list()
  chats_ok <- TRUE
  tryCatch({
    reader$read_int()
    n_chats <- reader$read_int()
    if (n_chats > 0) {
      chats <- lapply(seq_len(n_chats), function(i) reader$tgread_object())
    }
  }, error = function(e) {
    chats_ok <<- FALSE
  })
  if (!chats_ok) {
    return(list(
      pts = pts,
      count = count,
      messages = messages,
      topics = topics,
      chats = chats,
      users = list(),
      inexact = inexact,
      offset_id_offset = offset_id_offset
    ))
  }

  # Vector<User>
  users <- list()
  tryCatch({
    reader$read_int()
    n_users <- reader$read_int()
    if (n_users > 0) {
      users <- lapply(seq_len(n_users), function(i) reader$tgread_object())
    }
  }, error = function(e) {
    users <- list()
  })

  list(
    pts = pts,
    count = count,
    messages = messages,
    topics = topics,
    chats = chats,
    users = users,
    inexact = inexact,
    offset_id_offset = offset_id_offset
  )
}

.telegramR_read_messages <- function(reader) {
  # Vector<Message>
  reader$read_int()
  n_messages <- reader$read_int()
  messages <- if (n_messages > 0) lapply(seq_len(n_messages), function(i) reader$tgread_object()) else list()

  # Vector<ForumTopic>
  reader$read_int()
  n_topics <- reader$read_int()
  topics <- if (n_topics > 0) lapply(seq_len(n_topics), function(i) reader$tgread_object()) else list()

  # Vector<Chat>
  reader$read_int()
  n_chats <- reader$read_int()
  chats <- if (n_chats > 0) lapply(seq_len(n_chats), function(i) reader$tgread_object()) else list()

  # Vector<User>
  reader$read_int()
  n_users <- reader$read_int()
  users <- if (n_users > 0) lapply(seq_len(n_users), function(i) reader$tgread_object()) else list()

  list(
    messages = messages,
    topics = topics,
    chats = chats,
    users = users
  )
}

.telegramR_read_messages_slice <- function(reader) {
  flags <- reader$read_int()
  inexact <- bitwAnd(flags, 2) != 0
  count <- reader$read_int()
  next_rate <- if (bitwAnd(flags, 1) != 0) reader$read_int() else NULL
  offset_id_offset <- if (bitwAnd(flags, 4) != 0) reader$read_int() else NULL
  search_flood <- if (bitwAnd(flags, 8) != 0) reader$tgread_object() else NULL

  # Vector<Message>
  reader$read_int()
  n_messages <- reader$read_int()
  messages <- if (n_messages > 0) lapply(seq_len(n_messages), function(i) reader$tgread_object()) else list()

  # Vector<ForumTopic>
  reader$read_int()
  n_topics <- reader$read_int()
  topics <- if (n_topics > 0) lapply(seq_len(n_topics), function(i) reader$tgread_object()) else list()

  # Vector<Chat>
  reader$read_int()
  n_chats <- reader$read_int()
  chats <- if (n_chats > 0) lapply(seq_len(n_chats), function(i) reader$tgread_object()) else list()

  # Vector<User>
  reader$read_int()
  n_users <- reader$read_int()
  users <- if (n_users > 0) lapply(seq_len(n_users), function(i) reader$tgread_object()) else list()

  list(
    count = count,
    messages = messages,
    topics = topics,
    chats = chats,
    users = users,
    inexact = inexact,
    next_rate = next_rate,
    offset_id_offset = offset_id_offset,
    search_flood = search_flood
  )
}

.telegramR_read_messages_not_modified <- function(reader) {
  count <- reader$read_int()
  list(CONSTRUCTOR_ID = 1951620897, `_` = "MessagesNotModified", count = count)
}

.telegramR_read_message_service <- function(reader) {
  remaining <- function() length(reader$get_bytes()) - reader$tell_position()
  dbg <- isTRUE(getOption("telegramR.debug_parse"))
  flags <- reader$read_int()

  out <- bitwAnd(flags, 2) != 0
  mentioned <- bitwAnd(flags, 16) != 0
  media_unread <- bitwAnd(flags, 32) != 0
  reactions_are_possible <- bitwAnd(flags, 512) != 0
  silent <- bitwAnd(flags, 8192) != 0
  post <- bitwAnd(flags, 16384) != 0
  legacy <- bitwAnd(flags, 524288) != 0

  if (dbg) message(sprintf("[message_service] flags=%s rem=%s", as.character(flags), as.character(remaining())))
  id <- reader$read_int()
  if (dbg) message(sprintf("[message_service] id=%s rem=%s", as.character(id), as.character(remaining())))
  from_id <- if (bitwAnd(flags, 256) != 0 && remaining() >= 4) reader$tgread_object() else NULL
  if (dbg) message(sprintf("[message_service] from_id=%s rem=%s", if (is.null(from_id)) "NULL" else class(from_id)[1], as.character(remaining())))
  peer_id <- if (remaining() >= 4) reader$tgread_object() else NULL
  if (dbg) message(sprintf("[message_service] peer_id=%s rem=%s", if (is.null(peer_id)) "NULL" else class(peer_id)[1], as.character(remaining())))
  savedpeer_id <- if (bitwAnd(flags, 268435456) != 0 && remaining() >= 4) reader$tgread_object() else NULL
  if (dbg) message(sprintf("[message_service] savedpeer_id=%s rem=%s", if (is.null(savedpeer_id)) "NULL" else class(savedpeer_id)[1], as.character(remaining())))
  reply_to <- if (bitwAnd(flags, 8) != 0 && remaining() >= 4) reader$tgread_object() else NULL
  if (dbg) message(sprintf("[message_service] reply_to=%s rem=%s", if (is.null(reply_to)) "NULL" else class(reply_to)[1], as.character(remaining())))
  date <- if (remaining() >= 4) reader$tgread_date() else NULL
  if (dbg) message(sprintf("[message_service] date=%s rem=%s", if (is.null(date)) "NULL" else as.character(date), as.character(remaining())))
  action <- if (remaining() >= 4) reader$tgread_object() else NULL
  if (dbg) message(sprintf("[message_service] action=%s rem=%s", if (is.null(action)) "NULL" else class(action)[1], as.character(remaining())))
  reactions <- if (bitwAnd(flags, 1048576) != 0 && remaining() >= 4) reader$tgread_object() else NULL
  ttl_period <- if (bitwAnd(flags, 33554432) != 0 && remaining() >= 4) reader$read_int() else NULL

  list(
    "_" = "MessageService",
    id = id,
    peer_id = peer_id,
    date = date,
    action = action,
    out = out,
    mentioned = mentioned,
    media_unread = media_unread,
    reactions_are_possible = reactions_are_possible,
    silent = silent,
    post = post,
    legacy = legacy,
    from_id = from_id,
    savedpeer_id = savedpeer_id,
    reply_to = reply_to,
    reactions = reactions,
    ttl_period = ttl_period
  )
}

.telegramR_read_messages_chat_full <- function(reader) {
  # messages.ChatFull = { full_chat:ChatFull, chats:Vector<Chat>, users:Vector<User> }
  rem <- function() length(reader$get_bytes()) - reader$tell_position()
  safe_read_int <- function(signed = TRUE) {
    if (rem() < 4) return(NULL)
    reader$read_int(signed = signed)
  }
  safe_read_object <- function() {
    if (rem() < 4) return(NULL)
    tryCatch(reader$tgread_object(), error = function(e) NULL)
  }

  full_chat <- safe_read_object()

  chats <- list()
  users <- list()
  tryCatch({
    vec_ctor <- safe_read_int(signed = FALSE)
    n_chats <- safe_read_int()
    if (isTRUE(getOption("telegramR.trace_parse", FALSE))) {
      message(sprintf("[trace] messages.ChatFull n_chats=%s rem=%s",
                      as.character(n_chats),
                      as.character(rem())))
    }
    max_chats <- floor(rem() / 4)
    if (is.null(n_chats) || n_chats < 0 || n_chats > max_chats) {
      stop("invalid chats vector length")
    }
    if (n_chats > 0) {
      chats <- lapply(seq_len(n_chats), function(i) safe_read_object())
    }

    vec_ctor2 <- safe_read_int(signed = FALSE)
    n_users <- safe_read_int()
    if (isTRUE(getOption("telegramR.trace_parse", FALSE))) {
      message(sprintf("[trace] messages.ChatFull n_users=%s rem=%s",
                      as.character(n_users),
                      as.character(rem())))
    }
    max_users <- floor(rem() / 4)
    if (is.null(n_users) || n_users < 0 || n_users > max_users) {
      stop("invalid users vector length")
    }
    if (n_users > 0) {
      users <- lapply(seq_len(n_users), function(i) safe_read_object())
    }
  }, error = function(e) {
    # Return partial if parsing failed mid-way
    NULL
  })

  list(
    "_" = "messages.ChatFull",
    full_chat = full_chat,
    chats = chats,
    users = users
  )
}

.telegramR_read_channel_full <- function(reader) {
  rem <- function() length(reader$get_bytes()) - reader$tell_position()
  safe_read_int <- function(signed = TRUE) {
    if (rem() < 4) return(NULL)
    reader$read_int(signed = signed)
  }
  safe_read_long <- function(signed = TRUE) {
    if (rem() < 8) return(NULL)
    reader$read_long(signed = signed)
  }
  safe_read_date <- function() {
    if (rem() < 4) return(NULL)
    reader$tgread_date()
  }
  safe_read_object <- function() {
    if (rem() < 4) return(NULL)
    reader$tgread_object()
  }
  safe_read_string <- function() {
    if (rem() < 1) return(NULL)
    reader$tgread_string()
  }

  # Defaults for partial parse on error
  id <- about <- read_inbox_max_id <- read_outbox_max_id <- unread_count <- NULL
  participants_count <- admins_count <- kicked_count <- banned_count <- online_count <- NULL
  linked_chat_id <- NULL

  tryCatch({
    flags <- safe_read_int(signed = FALSE)
    flags2 <- safe_read_int(signed = FALSE)
    if (is.null(flags) || is.null(flags2)) stop("insufficient data for flags")

    can_view_participants <- bitwAnd(flags, 8) != 0
    can_set_username <- bitwAnd(flags, 64) != 0
    can_set_stickers <- bitwAnd(flags, 128) != 0
    hidden_prehistory <- bitwAnd(flags, 1024) != 0
    can_set_location <- bitwAnd(flags, 65536) != 0
    has_scheduled <- bitwAnd(flags, 524288) != 0
    can_view_stats <- bitwAnd(flags, 1048576) != 0
    blocked <- bitwAnd(flags, 4194304) != 0

    can_delete_channel <- bitwAnd(flags2, 1) != 0
    antispam <- bitwAnd(flags2, 2) != 0
    participants_hidden <- bitwAnd(flags2, 4) != 0
    translations_disabled <- bitwAnd(flags2, 8) != 0
    stories_pinned_available <- bitwAnd(flags2, 32) != 0
    view_forum_as_messages <- bitwAnd(flags2, 64) != 0
    restricted_sponsored <- bitwAnd(flags2, 2048) != 0
    can_view_revenue <- bitwAnd(flags2, 4096) != 0
    paid_media_allowed <- bitwAnd(flags2, 16384) != 0
    can_view_stars_revenue <- bitwAnd(flags2, 32768) != 0
    paid_reactions_available <- bitwAnd(flags2, 65536) != 0
    stargifts_available <- bitwAnd(flags2, 524288) != 0
    paid_messages_available <- bitwAnd(flags2, 1048576) != 0

    id <- safe_read_long()
    about <- safe_read_string()

    participants_count <- if (bitwAnd(flags, 1) != 0) safe_read_int() else NULL
    admins_count <- if (bitwAnd(flags, 2) != 0) safe_read_int() else NULL
    kicked_count <- if (bitwAnd(flags, 4) != 0) safe_read_int() else NULL
    banned_count <- if (bitwAnd(flags, 4) != 0) safe_read_int() else NULL
    online_count <- if (bitwAnd(flags, 8192) != 0) safe_read_int() else NULL

    read_inbox_max_id <- safe_read_int()
    read_outbox_max_id <- safe_read_int()
    unread_count <- safe_read_int()
    chat_photo <- safe_read_object()
    notify_settings <- safe_read_object()
    exported_invite <- if (bitwAnd(flags, 8388608) != 0) safe_read_object() else NULL

    # bot_info vector
    vec_ctor <- safe_read_int(signed = FALSE)
    n_bot <- safe_read_int()
    max_bot <- floor(rem() / 4)
    if (!is.null(n_bot) && (n_bot < 0 || n_bot > max_bot)) {
      stop("invalid bot_info vector length")
    }
    bot_info <- if (!is.null(n_bot) && n_bot > 0) lapply(seq_len(n_bot), function(i) safe_read_object()) else list()

    migrated_from_chat_id <- if (bitwAnd(flags, 16) != 0) safe_read_long() else NULL
    migrated_from_max_id <- if (bitwAnd(flags, 16) != 0) safe_read_int() else NULL
    pinned_msg_id <- if (bitwAnd(flags, 32) != 0) safe_read_int() else NULL
    stickerset <- if (bitwAnd(flags, 256) != 0) safe_read_object() else NULL
    available_min_id <- if (bitwAnd(flags, 512) != 0) safe_read_int() else NULL
    folder_id <- if (bitwAnd(flags, 2048) != 0) safe_read_int() else NULL
    linked_chat_id <- if (bitwAnd(flags, 16384) != 0) safe_read_long() else NULL
    location <- if (bitwAnd(flags, 32768) != 0) safe_read_object() else NULL
    slowmode_seconds <- if (bitwAnd(flags, 131072) != 0) safe_read_int() else NULL
    slowmode_next_send_date <- if (bitwAnd(flags, 262144) != 0) safe_read_date() else NULL
    stats_dc <- if (bitwAnd(flags, 4096) != 0) safe_read_int() else NULL
    pts <- safe_read_int()
    call <- if (bitwAnd(flags, 2097152) != 0) safe_read_object() else NULL
    ttl_period <- if (bitwAnd(flags, 16777216) != 0) safe_read_int() else NULL

    pending_suggestions <- NULL
    if (bitwAnd(flags, 33554432) != 0) {
      safe_read_int(signed = FALSE) # vector constructor
      n <- safe_read_int()
      max_sugg <- rem()
      if (!is.null(n) && (n < 0 || n > max_sugg)) {
        stop("invalid pending_suggestions length")
      }
      pending_suggestions <- if (!is.null(n) && n > 0) lapply(seq_len(n), function(i) safe_read_string()) else list()
    }

    groupcall_default_join_as <- if (bitwAnd(flags, 67108864) != 0) safe_read_object() else NULL
    theme_emoticon <- if (bitwAnd(flags, 134217728) != 0) safe_read_string() else NULL
    requests_pending <- if (bitwAnd(flags, 268435456) != 0) safe_read_int() else NULL

    recent_requesters <- NULL
    if (bitwAnd(flags, 268435456) != 0) {
      safe_read_int(signed = FALSE) # vector constructor
      n <- safe_read_int()
      max_req <- floor(rem() / 8)
      if (!is.null(n) && (n < 0 || n > max_req)) {
        stop("invalid recent_requesters length")
      }
      recent_requesters <- if (!is.null(n) && n > 0) lapply(seq_len(n), function(i) safe_read_long()) else list()
    }

    default_send_as <- if (bitwAnd(flags, 536870912) != 0) safe_read_object() else NULL
    available_reactions <- if (bitwAnd(flags, 1073741824) != 0) safe_read_object() else NULL
    reactions_limit <- if (bitwAnd(flags2, 8192) != 0) safe_read_int() else NULL
    stories <- if (bitwAnd(flags2, 16) != 0) safe_read_object() else NULL
    wallpaper <- if (bitwAnd(flags2, 128) != 0) safe_read_object() else NULL
    boosts_applied <- if (bitwAnd(flags2, 256) != 0) safe_read_int() else NULL
    boosts_unrestrict <- if (bitwAnd(flags2, 512) != 0) safe_read_int() else NULL
    emojiset <- if (bitwAnd(flags2, 1024) != 0) safe_read_object() else NULL
    bot_verification <- if (bitwAnd(flags2, 131072) != 0) safe_read_object() else NULL
    stargifts_count <- if (bitwAnd(flags2, 262144) != 0) safe_read_int() else NULL
    send_paid_messages_stars <- if (bitwAnd(flags2, 2097152) != 0) safe_read_long() else NULL
    main_tab <- if (bitwAnd(flags2, 4194304) != 0) safe_read_object() else NULL

    ChannelFull$new(
    id = id,
    about = about,
    read_inbox_max_id = read_inbox_max_id,
    read_outbox_max_id = read_outbox_max_id,
    unread_count = unread_count,
    chat_photo = chat_photo,
    notify_settings = notify_settings,
    bot_info = bot_info,
    pts = pts,
    can_view_participants = can_view_participants,
    can_set_username = can_set_username,
    can_set_stickers = can_set_stickers,
    hidden_prehistory = hidden_prehistory,
    can_set_location = can_set_location,
    has_scheduled = has_scheduled,
    can_view_stats = can_view_stats,
    blocked = blocked,
    can_delete_channel = can_delete_channel,
    antispam = antispam,
    participants_hidden = participants_hidden,
    translations_disabled = translations_disabled,
    stories_pinned_available = stories_pinned_available,
    view_forum_as_messages = view_forum_as_messages,
    restricted_sponsored = restricted_sponsored,
    can_view_revenue = can_view_revenue,
    paid_media_allowed = paid_media_allowed,
    can_view_stars_revenue = can_view_stars_revenue,
    paid_reactions_available = paid_reactions_available,
    stargifts_available = stargifts_available,
    paid_messages_available = paid_messages_available,
    participants_count = participants_count,
    admins_count = admins_count,
    kicked_count = kicked_count,
    banned_count = banned_count,
    online_count = online_count,
    exported_invite = exported_invite,
    migrated_from_chat_id = migrated_from_chat_id,
    migrated_from_max_id = migrated_from_max_id,
    pinned_msg_id = pinned_msg_id,
    stickerset = stickerset,
    available_min_id = available_min_id,
    folder_id = folder_id,
    linked_chat_id = linked_chat_id,
    location = location,
    slowmode_seconds = slowmode_seconds,
    slowmode_next_send_date = slowmode_next_send_date,
    stats_dc = stats_dc,
    call = call,
    ttl_period = ttl_period,
    pending_suggestions = pending_suggestions,
    groupcall_default_join_as = groupcall_default_join_as,
    theme_emoticon = theme_emoticon,
    requests_pending = requests_pending,
    recent_requesters = recent_requesters,
    default_send_as = default_send_as,
    available_reactions = available_reactions,
    reactions_limit = reactions_limit,
    stories = stories,
    wallpaper = wallpaper,
    boosts_applied = boosts_applied,
    boosts_unrestrict = boosts_unrestrict,
    emojiset = emojiset,
    bot_verification = bot_verification,
    stargifts_count = stargifts_count,
    send_paid_messages_stars = send_paid_messages_stars,
    main_tab = main_tab
    )
  }, error = function(e) {
    if (rem() > 0) {
      tryCatch(reader$read(rem()), error = function(e2) NULL)
    }
    ChannelFull$new(
      id = id,
      about = about %||% NA_character_,
      read_inbox_max_id = read_inbox_max_id,
      read_outbox_max_id = read_outbox_max_id,
      unread_count = unread_count,
      chat_photo = NULL,
      notify_settings = NULL,
      bot_info = list(),
      pts = NULL,
      participants_count = participants_count,
      admins_count = admins_count,
      kicked_count = kicked_count,
      banned_count = banned_count,
      online_count = online_count,
      linked_chat_id = linked_chat_id
    )
  })
}

.telegramR_read_channel <- function(reader) {
  rem <- function() length(reader$get_bytes()) - reader$tell_position()
  safe_read_int <- function(signed = TRUE) {
    if (rem() < 4) return(NULL)
    reader$read_int(signed = signed)
  }
  safe_read_long <- function(signed = TRUE) {
    if (rem() < 8) return(NULL)
    reader$read_long(signed = signed)
  }
  safe_read_date <- function() {
    if (rem() < 4) return(NULL)
    reader$tgread_date()
  }
  safe_read_object <- function() {
    if (rem() < 4) return(NULL)
    tryCatch(reader$tgread_object(), error = function(e) NULL)
  }
  safe_read_string <- function() {
    if (rem() < 1) return(NULL)
    tryCatch(reader$tgread_string(), error = function(e) NA_character_)
  }

  tryCatch({
    flags <- safe_read_int()
    flags2 <- safe_read_int()
    if (is.null(flags) || is.null(flags2)) stop("insufficient data for flags")

    creator <- bitwAnd(flags, 1) != 0
    left <- bitwAnd(flags, 4) != 0
    broadcast <- bitwAnd(flags, 32) != 0
    verified <- bitwAnd(flags, 128) != 0
    megagroup <- bitwAnd(flags, 256) != 0
    restricted <- bitwAnd(flags, 512) != 0
    signatures <- bitwAnd(flags, 2048) != 0
    min <- bitwAnd(flags, 4096) != 0
    scam <- bitwAnd(flags, 524288) != 0
    has_link <- bitwAnd(flags, 1048576) != 0
    has_geo <- bitwAnd(flags, 2097152) != 0
    slowmode_enabled <- bitwAnd(flags, 4194304) != 0
    call_active <- bitwAnd(flags, 8388608) != 0
    call_not_empty <- bitwAnd(flags, 16777216) != 0
    fake <- bitwAnd(flags, 33554432) != 0
    gigagroup <- bitwAnd(flags, 67108864) != 0
    noforwards <- bitwAnd(flags, 134217728) != 0
    join_to_send <- bitwAnd(flags, 268435456) != 0
    join_request <- bitwAnd(flags, 536870912) != 0
    forum <- bitwAnd(flags, 1073741824) != 0

    stories_hidden <- bitwAnd(flags2, 2) != 0
    stories_hidden_min <- bitwAnd(flags2, 4) != 0
    stories_unavailable <- bitwAnd(flags2, 8) != 0
    signature_profiles <- bitwAnd(flags2, 4096) != 0
    autotranslation <- bitwAnd(flags2, 32768) != 0
    broadcast_messages_allowed <- bitwAnd(flags2, 65536) != 0
    monoforum <- bitwAnd(flags2, 131072) != 0
    forum_tabs <- bitwAnd(flags2, 524288) != 0

    id <- safe_read_long()
    access_hash <- if (bitwAnd(flags, 8192) != 0) safe_read_long() else NULL
    title <- safe_read_string()
    username <- if (bitwAnd(flags, 64) != 0) safe_read_string() else NULL
    photo <- safe_read_object()
    date <- safe_read_date()

    restriction_reason <- if (bitwAnd(flags, 512) != 0) {
      safe_read_int(signed = FALSE) # vector ctor
      n <- safe_read_int()
      if (!is.null(n) && n > 0) lapply(seq_len(n), function(i) safe_read_object()) else list()
    } else {
      NULL
    }

    admin_rights <- if (bitwAnd(flags, 16384) != 0) safe_read_object() else NULL
    banned_rights <- if (bitwAnd(flags, 32768) != 0) safe_read_object() else NULL
    default_banned_rights <- if (bitwAnd(flags, 262144) != 0) safe_read_object() else NULL
    participants_count <- if (bitwAnd(flags, 131072) != 0) safe_read_int() else NULL

    usernames <- if (bitwAnd(flags2, 1) != 0) {
      safe_read_int(signed = FALSE)
      n <- safe_read_int()
      if (!is.null(n) && n > 0) lapply(seq_len(n), function(i) safe_read_object()) else list()
    } else {
      NULL
    }

    stories_max_id <- if (bitwAnd(flags2, 16) != 0) safe_read_int() else NULL
    color <- if (bitwAnd(flags2, 128) != 0) safe_read_object() else NULL
    profile_color <- if (bitwAnd(flags2, 256) != 0) safe_read_object() else NULL
    emoji_status <- if (bitwAnd(flags2, 512) != 0) safe_read_object() else NULL
    level <- if (bitwAnd(flags2, 1024) != 0) safe_read_int() else NULL
    subscription_until_date <- if (bitwAnd(flags2, 2048) != 0) safe_read_date() else NULL
    bot_verification_icon <- if (bitwAnd(flags2, 8192) != 0) safe_read_long() else NULL
    send_paid_messages_stars <- if (bitwAnd(flags2, 16384) != 0) safe_read_long() else NULL
    linked_monoforum_id <- if (bitwAnd(flags2, 262144) != 0) safe_read_long() else NULL

    Channel$new(
      id = id,
      title = title,
      photo = photo,
      date = date,
      creator = creator,
      left = left,
      broadcast = broadcast,
      verified = verified,
      megagroup = megagroup,
      restricted = restricted,
      signatures = signatures,
      min = min,
      scam = scam,
      has_link = has_link,
      has_geo = has_geo,
      slowmode_enabled = slowmode_enabled,
      call_active = call_active,
      call_not_empty = call_not_empty,
      fake = fake,
      gigagroup = gigagroup,
      noforwards = noforwards,
      join_to_send = join_to_send,
      join_request = join_request,
      forum = forum,
      stories_hidden = stories_hidden,
      stories_hidden_min = stories_hidden_min,
      stories_unavailable = stories_unavailable,
      signature_profiles = signature_profiles,
      autotranslation = autotranslation,
      broadcast_messages_allowed = broadcast_messages_allowed,
      monoforum = monoforum,
      forum_tabs = forum_tabs,
      access_hash = access_hash,
      username = username,
      restriction_reason = restriction_reason,
      admin_rights = admin_rights,
      banned_rights = banned_rights,
      default_banned_rights = default_banned_rights,
      participants_count = participants_count,
      usernames = usernames,
      stories_max_id = stories_max_id,
      color = color,
      profile_color = profile_color,
      emoji_status = emoji_status,
      level = level,
      subscription_until_date = subscription_until_date,
      bot_verification_icon = bot_verification_icon,
      send_paid_messages_stars = send_paid_messages_stars,
      linked_monoforum_id = linked_monoforum_id
    )
  }, error = function(e) {
    if (rem() > 0) {
      tryCatch(reader$read(rem()), error = function(e2) NULL)
    }
    Channel$new(
      id = NA,
      title = NA_character_,
      photo = NULL,
      date = NULL
    )
  })
}

.telegramR_read_user <- function(reader) {
  flags <- reader$read_int()
  flags2 <- reader$read_int()

  is_self <- bitwAnd(flags, 1024) != 0
  contact <- bitwAnd(flags, 2048) != 0
  mutual_contact <- bitwAnd(flags, 4096) != 0
  deleted <- bitwAnd(flags, 8192) != 0
  bot <- bitwAnd(flags, 16384) != 0
  bot_chat_history <- bitwAnd(flags, 32768) != 0
  bot_nochats <- bitwAnd(flags, 65536) != 0
  verified <- bitwAnd(flags, 131072) != 0
  restricted <- bitwAnd(flags, 262144) != 0
  min <- bitwAnd(flags, 1048576) != 0
  bot_inline_geo <- bitwAnd(flags, 2097152) != 0
  support <- bitwAnd(flags, 8388608) != 0
  scam <- bitwAnd(flags, 16777216) != 0
  apply_min_photo <- bitwAnd(flags, 33554432) != 0
  fake <- bitwAnd(flags, 67108864) != 0
  bot_attach_menu <- bitwAnd(flags, 134217728) != 0
  premium <- bitwAnd(flags, 268435456) != 0
  attach_menu_enabled <- bitwAnd(flags, 536870912) != 0

  bot_can_edit <- bitwAnd(flags2, 2) != 0
  close_friend <- bitwAnd(flags2, 4) != 0
  stories_hidden <- bitwAnd(flags2, 8) != 0
  stories_unavailable <- bitwAnd(flags2, 16) != 0
  contact_require_premium <- bitwAnd(flags2, 1024) != 0
  bot_business <- bitwAnd(flags2, 2048) != 0
  bot_has_main_app <- bitwAnd(flags2, 8192) != 0
  bot_forum_view <- bitwAnd(flags2, 65536) != 0

  id <- reader$read_long()
  access_hash <- if (bitwAnd(flags, 1) != 0) reader$read_long() else NULL
  first_name <- if (bitwAnd(flags, 2) != 0) reader$tgread_string() else NULL
  last_name <- if (bitwAnd(flags, 4) != 0) reader$tgread_string() else NULL
  username <- if (bitwAnd(flags, 8) != 0) reader$tgread_string() else NULL
  phone <- if (bitwAnd(flags, 16) != 0) reader$tgread_string() else NULL
  photo <- if (bitwAnd(flags, 32) != 0) .telegramR_read_user_profile_photo(reader) else NULL
  status <- if (bitwAnd(flags, 64) != 0) reader$tgread_object() else NULL
  bot_info_version <- if (bitwAnd(flags, 16384) != 0) reader$read_int() else NULL

  restriction_reason <- if (bitwAnd(flags, 262144) != 0) {
    reader$read_int()
    n <- reader$read_int()
    lapply(seq_len(n), function(i) reader$tgread_object())
  } else {
    NULL
  }

  bot_inline_placeholder <- if (bitwAnd(flags, 524288) != 0) reader$tgread_string() else NULL
  lang_code <- if (bitwAnd(flags, 4194304) != 0) reader$tgread_string() else NULL
  emoji_status <- if (bitwAnd(flags, 1073741824) != 0) reader$tgread_object() else NULL

  usernames <- if (bitwAnd(flags2, 1) != 0) {
    reader$read_int()
    n <- reader$read_int()
    lapply(seq_len(n), function(i) reader$tgread_object())
  } else {
    NULL
  }

  stories_max_id <- if (bitwAnd(flags2, 32) != 0) reader$read_int() else NULL
  color <- if (bitwAnd(flags2, 256) != 0) reader$tgread_object() else NULL
  profile_color <- if (bitwAnd(flags2, 512) != 0) reader$tgread_object() else NULL
  bot_active_users <- if (bitwAnd(flags2, 4096) != 0) reader$read_int() else NULL
  bot_verification_icon <- if (bitwAnd(flags2, 16384) != 0) reader$read_long() else NULL
  send_paid_messages_stars <- if (bitwAnd(flags2, 32768) != 0) reader$read_long() else NULL

  User$new(
    id = id, is_self = is_self, contact = contact, mutual_contact = mutual_contact,
    deleted = deleted, bot = bot, bot_chat_history = bot_chat_history,
    bot_nochats = bot_nochats, verified = verified, restricted = restricted,
    min = min, bot_inline_geo = bot_inline_geo, support = support, scam = scam,
    apply_min_photo = apply_min_photo, fake = fake, bot_attach_menu = bot_attach_menu,
    premium = premium, attach_menu_enabled = attach_menu_enabled,
    bot_can_edit = bot_can_edit, close_friend = close_friend,
    stories_hidden = stories_hidden, stories_unavailable = stories_unavailable,
    contact_require_premium = contact_require_premium, bot_business = bot_business,
    bot_has_main_app = bot_has_main_app, bot_forum_view = bot_forum_view,
    access_hash = access_hash, first_name = first_name, last_name = last_name,
    username = username, phone = phone, photo = photo, status = status,
    bot_info_version = bot_info_version, restriction_reason = restriction_reason,
    bot_inline_placeholder = bot_inline_placeholder, lang_code = lang_code,
    emoji_status = emoji_status, usernames = usernames, stories_max_id = stories_max_id,
    color = color, profile_color = profile_color, bot_active_users = bot_active_users,
    bot_verification_icon = bot_verification_icon, send_paid_messages_stars = send_paid_messages_stars
  )
}
