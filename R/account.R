#  @title Account Methods
#  @description This file contains the `AccountMethods` class and the `TakeoutClient` class, which are used to manage account-related operations in the Telegram API.
#  @details The `AccountMethods` class provides methods for managing account-related operations, including takeout sessions.
#  The `TakeoutClient` class is used to handle the takeout session and its associated requests.
#  @export
#  @noRd
#  @noRd
AccountMethods <- R6::R6Class(
  "AccountMethods",
  public = list(
    #  @field client The client instance backing these methods.
    client = NULL,

    #  @description Initialize a new AccountMethods wrapper.
    #  @param client The TelegramClient instance.
    initialize = function(client) {
      self$client <- client
    }
  )
)

#  @title TakeoutClient
#  @description Telegram API type TakeoutClient
#  @export
#  @noRd
#  @noRd
TakeoutClient <- R6::R6Class(
  "TakeoutClient",
  public = list(
    #  @field finalize A logical indicating whether to finalize the takeout session.
    finalize = NULL,

    #  @field client An instance of the client to use for the takeout session.
    client = NULL,

    #  @field request An optional request object for the takeout session.
    request = NULL,

    #  @field success A logical indicating whether the takeout session was successful.
    success = NULL,

    #  @description Initialize a new `TakeoutClient` object.
    #  @param finalize A logical indicating whether to finalize the takeout session.
    #  @param client An instance of the client to use for the takeout session.
    #  @param request An optional request object for the takeout session.
    #  @return A new `TakeoutClient` object.
    initialize = function(finalize, client, request) {
      self$finalize <- finalize
      self$client <- client
      self$request <- request
      self$success <- NULL
    },

    #  @description Get the success status of the takeout session.
    #  @return A logical indicating whether the takeout session was successful.
    get_success = function() {
      self$success
    },

    #  @description Set the success status of the takeout session.
    #  @param value A logical indicating whether the takeout session was successful.
    #  @return None.
    set_success = function(value) {
      self$success <- value
    },

    #  @description Enter the takeout session context.
    #  @return The current instance of the `TakeoutClient`.
    aenter = function() {
      client <- self$client
      if (is.null(client$session$takeout_id)) {
        client$session$takeout_id <- client$invoke(self$request)$id
      } else if (!is.null(self$request)) {
        stop("Can't send a takeout request while another takeout for the current session is still not finished.")
      }
      return(self)
    },

    #  @description Exit the takeout session context.
    #  @param exc_type The type of exception raised, if any.
    #  @param exc_value The value of the exception raised, if any.
    #  @param traceback The traceback of the exception raised, if any.
    #  @return None.
    aexit = function(exc_type, exc_value, traceback) {
      if (is.null(self$success) && self$finalize) {
        self$success <- is.null(exc_type)
      }

      if (!is.null(self$success)) {
        finish_req <- NULL
        if (exists("FinishTakeoutSessionRequest", inherits = TRUE) && is.function(FinishTakeoutSessionRequest)) {
          finish_req <- FinishTakeoutSessionRequest(self$success)
        } else if (exists("FinishTakeoutSessionRequest", inherits = TRUE) && is.function(FinishTakeoutSessionRequest$new)) {
          finish_req <- FinishTakeoutSessionRequest$new(success = self$success)
        } else {
          stop("FinishTakeoutSessionRequest not available")
        }
        result <- self$client$invoke(finish_req)
        if (!result) {
          stop("Failed to finish the takeout.")
        }
        self$client$session$takeout_id <- NULL
      }
    },

    #  @description Make a request to the Telegram API using the takeout session.
    #  @param request The request object to send.
    #  @param ordered A logical indicating whether the request should be ordered.
    #  @return The result of the request.
    call = function(request, ordered = FALSE) {
      takeout_id <- self$client$session$takeout_id
      if (is.null(takeout_id)) {
        stop("Takeout mode has not been initialized (are you calling outside of 'with'?)")
      }

      single <- !is_list_like(request)
      requests <- if (single) list(request) else request
      wrapped <- lapply(requests, function(r) {
        if (!inherits(r, "TLRequest")) {
          stop("_NOT_A_REQUEST")
        }
        r$resolve(self, utils)
        if (exists("InvokeWithTakeoutRequest", inherits = TRUE) && is.function(InvokeWithTakeoutRequest)) {
          InvokeWithTakeoutRequest(takeout_id, r)
        } else if (exists("InvokeWithTakeoutRequest", inherits = TRUE) && is.function(InvokeWithTakeoutRequest$new)) {
          InvokeWithTakeoutRequest$new(takeout_id = takeout_id, query = r)
        } else {
          stop("InvokeWithTakeoutRequest not available")
        }
      })

      self$client$invoke(if (single) wrapped[[1]] else wrapped, ordered = ordered)
    },

    #  @description Get the result of the request.
    #  @param name The name of the attribute to get.
    #  @return The result of the request.
    get_attribute = function(name) {
      if (startsWith(name, "__") && !(name %in% self$PROXY_INTERFACE)) {
        stop("AttributeError")
      }
      super$get_attribute(name)
    },

    #  @description Get the attribute of the request.
    #  @param name The name of the attribute to get.
    #  @return The value of the attribute.
    get_attr = function(name) {
      value <- self$client$get_attr(name)
      if (is.function(value)) {
        function(...) value(self, ...)
      } else {
        value
      }
    },

    #  @description Set the attribute of the request.
    #  @param name The name of the attribute to set.
    #  @param value The value to set for the attribute.
    #  @return None.
    set_attr = function(name, value) {
      if (startsWith(name, paste0("_", class(self)[1], "__"))) {
        super$set_attr(name, value)
      } else {
        self$client$set_attr(name, value)
      }
    }
  )
)
