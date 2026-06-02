# Compatibility helper used across generated TL types.
as.integer64 <- function(x) {
  as.numeric(x)
}

# CRC-32 helper for packet codecs.
crc32 <- function(x) {
  hex <- digest::digest(x, algo = "crc32", serialize = FALSE)
  unsigned <- as.numeric(gmp::as.bigz(paste0("0x", hex)))
  if (unsigned > (2^31 - 1)) {
    unsigned <- unsigned - 2^32
  }
  as.integer(unsigned)
}

# 
#  @details
#  The classes defined in this file include:
#  - `Exception`: A base class for all exceptions.
#  - `ReadCancelledError`: Raised when a read operation is cancelled.
#  - `TypeNotFoundError`: Raised when a type is not found.
#  - `InvalidChecksumError`: Raised when a checksum is invalid.
#  - `InvalidBufferError`: Raised when a buffer is invalid.
#  - `AuthKeyNotFound`: Raised when an authorization key is not found.
#  - `SecurityError`: Raised when a security check fails.
#  - `CdnFileTamperedError`: Raised when a CDN file is tampered with.
#  - `AlreadyInConversationError`: Raised when another exclusive conversation is opened in the same chat.
#  - `BadMessageError`: Raised when handling a bad message notification.
#  - `MultiError`: A container for multiple exceptions.
# 
#  @title Exception
#  @description Telegram API type Exception
#  @export
#  @noRd
#  @noRd
Exception <- R6::R6Class(
  "Exception",
  public = list(
    #  @field message \code{character} The error message.
    message = NULL,

    #  @description
    #  Constructor for the Exception class.
    #  @param message \code{character} The error message.
    #  @return None.
    initialize = function(message = "An error occurred.") {
      self$message <- message
    }
  )
)

#  ReadCancelledError
# 
#  @title ReadCancelledError
#  @description Telegram API type ReadCancelledError
#  @export
#  @noRd
#  @noRd
ReadCancelledError <- R6::R6Class(
  "ReadCancelledError",
  inherit = Exception,
  public = list(
    #  @description
    #  Constructor for the ReadCancelledError class.
    #  @param message \code{character} The error message.
    #  @return None.
    initialize = function() {
      super$initialize("The read operation was cancelled.")
    }
  )
)

#  TypeNotFoundError
# 
#  @title TypeNotFoundError
#  @description Telegram API type TypeNotFoundError
#  @export
#  @noRd
#  @noRd
TypeNotFoundError <- R6::R6Class(
  "TypeNotFoundError",
  inherit = Exception,
  public = list(
    #  @field invalid_constructor_id \code{numeric} The invalid constructor ID.
    invalid_constructor_id = NULL,

    #  @field remaining \code{character} The remaining bytes in the buffer.
    remaining = NULL,

    #  @description
    #  Constructor for the TypeNotFoundError class.
    #  @param invalid_constructor_id \code{numeric} The invalid constructor ID.
    #  @param remaining \code{character} The remaining bytes in the buffer.
    #  @return None.
    initialize = function(invalid_constructor_id, remaining) {
      self$invalid_constructor_id <- invalid_constructor_id
      self$remaining <- remaining
      super$initialize(
        sprintf(
          "Could not find a matching Constructor ID for the TLObject that was supposed to be read with ID %08x. See the FAQ for more details. Remaining bytes: %s",
          invalid_constructor_id, remaining
        )
      )
    }
  )
)

#  InvalidChecksumError
# 
#  @title InvalidChecksumError
#  @description Telegram API type InvalidChecksumError
#  @export
#  @noRd
#  @noRd
InvalidChecksumError <- R6::R6Class(
  "InvalidChecksumError",
  inherit = Exception,
  public = list(
    #  @field checksum \code{numeric} The received checksum.
    checksum = NULL,

    #  @field valid_checksum \code{numeric} The expected checksum.
    valid_checksum = NULL,

    #  @description
    #  Constructor for the InvalidChecksumError class.
    #  @param checksum \code{numeric} The received checksum.
    #  @param valid_checksum \code{numeric} The expected checksum.
    #  @return None.
    initialize = function(checksum, valid_checksum) {
      self$checksum <- checksum
      self$valid_checksum <- valid_checksum
      super$initialize(
        sprintf(
          "Invalid checksum (%s when %s was expected). This packet should be skipped.",
          checksum, valid_checksum
        )
      )
    }
  )
)

#  InvalidBufferError
# 
#  @title InvalidBufferError
#  @description Telegram API type InvalidBufferError
#  @export
#  @noRd
#  @noRd
InvalidBufferError <- R6::R6Class(
  "InvalidBufferError",
  inherit = Exception,
  public = list(
    #  @field payload \code{raw} The invalid buffer payload.
    payload = NULL,

    #  @field code \code{numeric} The HTTP error code.
    code = NULL,

    #  @description
    #  Constructor for the InvalidBufferError class.
    #  @param payload \code{raw} The invalid buffer payload.
    #  @return None.
    initialize = function(payload) {
      self$payload <- payload
      if (length(payload) == 4) {
        self$code <- -as.integer(payload)
        super$initialize(sprintf("Invalid response buffer (HTTP code %d)", self$code))
      } else {
        self$code <- NULL
        super$initialize(sprintf("Invalid response buffer (too short %s)", payload))
      }
    }
  )
)

#  AuthKeyNotFound
# 
#  @title AuthKeyNotFound
#  @description Telegram API type AuthKeyNotFound
#  @export
#  @noRd
#  @noRd
AuthKeyNotFound <- R6::R6Class(
  "AuthKeyNotFound",
  inherit = Exception,
  public = list(
    #  @description
    #  Constructor for the AuthKeyNotFound class.
    #  @param message \code{character} The error message.
    #  @return None.
    initialize = function() {
      super$initialize(
        "The server claims it doesn't know about the authorization key. If the issue persists, you may need to recreate the session file and login again."
      )
    }
  )
)

#  SecurityError
# 
#  @title SecurityError
#  @description Telegram API type SecurityError
#  @export
#  @noRd
#  @noRd
SecurityError <- R6::R6Class(
  "SecurityError",
  inherit = Exception,
  public = list(
    #  @description
    #  Constructor for the SecurityError class.
    #  @param message \code{character} The error message.
    #  @return None.
    initialize = function(message = "A security check failed.") {
      super$initialize(message)
    }
  )
)

#  CdnFileTamperedError
# 
#  @title CdnFileTamperedError
#  @description Telegram API type CdnFileTamperedError
#  @export
#  @noRd
#  @noRd
CdnFileTamperedError <- R6::R6Class(
  "CdnFileTamperedError",
  inherit = SecurityError,
  public = list(
    #  @description
    #  Constructor for the CdnFileTamperedError class.
    initialize = function() {
      super$initialize("The CDN file has been altered and its download cancelled.")
    }
  )
)

#  AlreadyInConversationError
# 
#  @title AlreadyInConversationError
#  @description Telegram API type AlreadyInConversationError
#  @export
#  @noRd
#  @noRd
AlreadyInConversationError <- R6::R6Class(
  "AlreadyInConversationError",
  inherit = Exception,
  public = list(
    #  @description
    #  Constructor for the AlreadyInConversationError class.
    #  @param message \code{character} The error message.
    #  @return None.
    initialize = function() {
      super$initialize(
        "Cannot open exclusive conversation in a chat that already has one open conversation."
      )
    }
  )
)

#  BadMessageError
# 
#  @title BadMessageError
#  @description Telegram API type BadMessageError
#  @export
#  @noRd
#  @noRd
BadMessageError <- R6::R6Class(
  "BadMessageError",
  inherit = Exception,
  public = list(
    #  @field request \code{TLRequest} The request that caused the error.
    request = NULL,

    #  @field code \code{numeric} The error code.
    code = NULL,

    #  @field ErrorMessages \code{list} A list of error messages corresponding to the error codes.
    ErrorMessages = list(
      `16` = "msg_id too low (most likely, client time is wrong).",
      `17` = "msg_id too high (client time needs synchronization).",
      `18` = "Incorrect two lower order msg_id bits.",
      `19` = "Container msg_id is the same as a previously received message.",
      `20` = "Message too old.",
      `32` = "msg_seqno too low.",
      `33` = "msg_seqno too high.",
      `34` = "An even msg_seqno expected, but odd received.",
      `35` = "Odd msg_seqno expected, but even received.",
      `48` = "Incorrect server salt.",
      `64` = "Invalid container."
    ),

    #  @description
    #  Constructor for the BadMessageError class.
    #  @param request \code{TLRequest} The request that caused the error.
    #  @param code \code{numeric} The error code.
    #  @return None.
    initialize = function(request, code) {
      self$request <- request
      self$code <- code
      super$initialize(
        sprintf(
          "Bad message error: %s",
          self$ErrorMessages[[as.character(code)]] %||% sprintf("Unknown error code: %d", code)
        )
      )
    }
  )
)

#  MultiError
# 
#  @title MultiError
#  @description Telegram API type MultiError
#  @export
#  @noRd
#  @noRd
MultiError <- R6::R6Class(
  "MultiError",
  inherit = Exception,
  public = list(
    #  @field exceptions \code{list} A list of exceptions.
    exceptions = NULL,

    #  @field results \code{list} A list of results.
    results = NULL,

    #  @field requests \code{list} A list of requests.
    requests = NULL,

    #  @description
    #  Constructor for the MultiError class.
    #  @param exceptions \code{list} A list of exceptions.
    #  @param results \code{list} A list of results.
    #  @param requests \code{list} A list of requests.
    #  @return None.
    initialize = function(exceptions, results, requests) {
      if (length(results) != length(exceptions) || length(exceptions) != length(requests)) {
        stop("Need result, exception, and request for each error.")
      }
      for (e in exceptions) {
        if (!inherits(e, "error") && !is.null(e)) {
          stop(sprintf("Expected an exception object, not '%s'", e))
        }
      }
      for (req in requests) {
        if (!inherits(req, "TLRequest")) {
          stop(sprintf("Expected TLRequest object, not '%s'", req))
        }
      }
      self$exceptions <- exceptions
      self$results <- results
      self$requests <- requests
    }
  )
)

#  Convert an RPC error to an R condition
#  @param rpc_error A list or R6 object with error_code and error_message fields
#  @param request The request that caused the error
#  @return A condition object
#  @keywords internal
rpc_message_to_error <- function(rpc_error, request) {
  code <- rpc_error$error_code
  msg <- rpc_error$error_message
  if (is.null(msg)) msg <- "Unknown RPC error"
  if (is.null(code)) code <- 0L
  # FLOOD_WAIT — return a typed condition so call_internal can auto-sleep and retry
  if (is.character(msg) && grepl("^FLOOD_WAIT_\\d+$", msg)) {
    wait_sec <- as.integer(sub("^FLOOD_WAIT_", "", msg))
    if (!is.na(wait_sec)) {
      return(structure(
        class = c("FloodWaitError", "RPCError", "error", "condition"),
        list(
          message  = sprintf(
            "RPCError %d: %s. Flood wait: %d seconds (~%.1f min).",
            code, msg, wait_sec, wait_sec / 60
          ),
          error_code    = code,
          error_message = msg,
          request       = request,
          seconds       = wait_sec
        )
      ))
    }
  }
  # Handle DC migration errors
  if (is.character(msg) && grepl("^(PHONE|NETWORK|USER)_MIGRATE_\\d+$", msg)) {
    dc_id <- as.integer(sub("^(PHONE|NETWORK|USER)_MIGRATE_", "", msg))
    cls <- if (grepl("^PHONE_", msg)) {
      "PhoneMigrateError"
    } else if (grepl("^NETWORK_", msg)) {
      "NetworkMigrateError"
    } else {
      "UserMigrateError"
    }
    return(structure(
      class = c(cls, "RPCError", "error", "condition"),
      list(
        message = sprintf("RPCError %d: %s", code, msg),
        error_code = code,
        error_message = msg,
        request = request,
        new_dc = dc_id
      )
    ))
  }
  if (is.character(msg) && msg == "AUTH_KEY_UNREGISTERED") {
    msg <- paste0(
      msg,
      ". Your auth key is invalid or expired. Reconnect and re-authenticate (client$connect(); client$start())."
    )
  }
  err <- structure(
    class = c("RPCError", "error", "condition"),
    list(
      message = sprintf("RPCError %d: %s", code, msg),
      error_code = code,
      error_message = msg,
      request = request
    )
  )
  err
}
