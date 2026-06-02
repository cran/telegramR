#  This module contains the class used to communicate with Telegram's servers
#  in plain text, when no authorization key has been created yet.
#  @title MTProtoPlainSender
#  @description Telegram API type MTProtoPlainSender
#  @export
#  @noRd
#  @noRd
MTProtoPlainSender <- R6::R6Class("MTProtoPlainSender",
  public = list(
    #  @description Initializes the MTProto plain sender.
    #  @param connection the Connection to be used.
    #  @param loggers Optional loggers map.
    initialize = function(connection, loggers = NULL) {
      private$state <- MTProtoState$new(auth_key = NULL, loggers = NULL)
      private$connection <- connection
      private$loggers <- loggers
    },

    #  @description Sends and receives the result for the given request.
    #  @param request The request to send.
    #  @return The response object.
    send = function(request) {
      promise(function(resolve, reject) {
        tryCatch(
          {
            resolve_maybe <- function(x) {
              if (inherits(x, "promise") || inherits(x, "Future")) {
                return(future::value(x))
              }
              x
            }

            serialize_request <- function(req) {
              if (is.raw(req)) {
                return(req)
              }
              if (is.character(req)) {
                return(charToRaw(req))
              }
              if (is.list(req) && inherits(req, "ReqPqMultiRequest")) {
                return(ReqPqMultiRequest$new(nonce = req$nonce)$to_bytes())
              }
              if (is.list(req) && inherits(req, "ReqDHParamsRequest")) {
                return(ReqDHParamsRequest$new(
                  nonce = req$nonce,
                  server_nonce = req$server_nonce,
                  p = req$p,
                  q = req$q,
                  public_key_fingerprint = req$public_key_fingerprint,
                  encrypted_data = req$encrypted_data
                )$to_bytes())
              }
              if (is.list(req) && inherits(req, "SetClientDHParamsRequest")) {
                return(SetClientDHParamsRequest$new(
                  nonce = req$nonce,
                  server_nonce = req$server_nonce,
                  encrypted_data = req$encrypted_data
                )$to_bytes())
              }
              if (is.function(req$to_bytes)) {
                return(req$to_bytes())
              }
              if (is.function(req$bytes)) {
                return(req$bytes())
              }
              if (is.function(req$to_raw)) {
                return(req$to_raw())
              }
              stop("Unsupported request type for MTProtoPlainSender")
            }

            body <- serialize_request(request)
            msg_id <- private$state$get_new_msg_id()

            # Pack data: <qqi format in Python struct is 8 bytes + 8 bytes + 4 bytes
            header <- packInt64(0) # auth_key_id (0 for plain messages)
            header <- c(header, packInt64(msg_id))
            header <- c(header, packInt32(length(body)))

            resolve_maybe(private$connection$send(c(header, body)))

            body <- resolve_maybe(private$connection$recv())
            if (length(body) < 8) {
              stop("InvalidBufferError: Buffer too small")
            }

            reader <- BinaryReader$new(body)
            auth_key_id <- reader$read_long()
            if (auth_key_id != 0) {
              stop("Bad auth_key_id")
            }

            msg_id <- reader$read_long()
            if (msg_id == 0) {
              stop("Bad msg_id")
            }

            length <- reader$read_int()
            if (length <= 0) {
              stop("Bad length")
            }
            if ((reader$tell_position() + length) > length(body)) {
              stop("Bad length")
            }
            resolve(reader$read(length))
          },
          error = function(e) reject(e)
        )
      })
    }
  ),
  private = list(
    state = NULL,
    connection = NULL,
    loggers = NULL
  )
)

#  Pack a 64-bit integer into a raw vector (little-endian)
#  @param value The integer value to pack
#  @return A raw vector representation of the integer
#  @export
packInt64 <- function(value) {
  if (is.raw(value)) {
    if (length(value) == 8) return(value)
    if (length(value) < 8) return(c(value, raw(8 - length(value))))
    return(value[1:8])
  }
  if (inherits(value, "bigz")) value <- as.character(value)
  pack_int64(value)
}

#  Pack a 32-bit integer into a raw vector (little-endian)
#  @param value The integer value to pack
#  @return A raw vector representation of the integer
#  @export
packInt32 <- function(value) {
  if (length(value) != 1 || is.na(value)) {
    stop("Invalid input: value must be a single, non-NA number")
  }
  pack_int32_cpp(as.numeric(value))
}
