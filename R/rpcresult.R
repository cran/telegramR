#  RpcResult Class
# 
# 
#  @details
#  The `RpcResult` class encapsulates the response of an RPC call, including the request message ID, the body of the response, and any error that occurred.
# 
# 
#  @title RpcResult
#  @description Telegram API type RpcResult
#  @export
#  @noRd
#  @noRd
RpcResult <- R6::R6Class(
  "RpcResult",
  inherit = TLObject,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for RpcResult (0xf35c6d01).
    CONSTRUCTOR_ID = 0xf35c6d01,
    #  @field SUBCLASS_OF_ID The subclass ID for RpcResult.
    SUBCLASS_OF_ID = 0xf35c6d01,

    #  @field req_msg_id Field.
    req_msg_id = NULL,
    #  @field body Field.
    body = NULL,
    #  @field error Field.
    error = NULL,

    #  @description
    #  Initializes the `RpcResult` object with the given request message ID, body, and error.
    #  @param req_msg_id \code{numeric} The ID of the request message.
    #  @param body \code{ANY} The body of the RPC result.
    #  @param error \code{ANY} The error object, if any.
    #  @return A new `RpcResult` object.
    initialize = function(req_msg_id = NULL, body = NULL, error = NULL) {
      self$req_msg_id <- req_msg_id
      self$body <- body
      self$error <- error
    },

    #  @description
    #  Converts the `RpcResult` object to a dictionary representation.
    #  @return A named list representing the `RpcResult` object.
    to_dict = function() {
      return(
        list(
          "_" = "RpcResult",
          "req_msg_id" = self$req_msg_id,
          "body" = self$body,
          "error" = self$error
        )
      )
    }
  ),
  private = list(
    from_reader = function(reader) {
      msg_id <- reader$read_long()
      inner_code <- reader$read_int(signed = FALSE)
      rpc_error_ctor <- tryCatch(RpcError$new()$CONSTRUCTOR_ID, error = function(e) 0x2144ca19)
      gzip_ctor <- 0x3072cfa1
      if (identical(as.numeric(inner_code), as.numeric(rpc_error_ctor))) {
        error_code <- reader$read_int()
        error_message <- reader$tgread_string()
        return(RpcResult$new(
          req_msg_id = msg_id, body = NULL,
          error = list(error_code = error_code, error_message = error_message)
        ))
      }
      if (identical(as.numeric(inner_code), as.numeric(gzip_ctor))) {
        decompressed <- memDecompress(reader$tgread_bytes(), type = "gzip")
        return(RpcResult$new(req_msg_id = msg_id, body = decompressed, error = NULL))
      }
      reader$seek(-4)
      return(RpcResult$new(req_msg_id = msg_id, body = reader$read(), error = NULL))
    }
  )
)
