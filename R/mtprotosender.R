#  Check if an object is list-like (list, vector, etc.)
# 
#  Determines whether an object can be treated like a list or collection
#  in the context of MTProto requests.
# 
#  @param obj The object to check
#  @param allow_data_frames Whether to consider data frames as list-like (default: FALSE)
#  @return TRUE if the object is list-like, FALSE otherwise
#  @export
is_list_like <- function(obj, allow_data_frames = FALSE) {
  # NULL is not list-like
  if (is.null(obj)) {
    return(FALSE)
  }

  # Check if it's a list
  if (is.list(obj)) {
    # Data frames are technically lists, but we might want to exclude them
    if (!allow_data_frames && is.data.frame(obj)) {
      return(FALSE)
    }
    return(TRUE)
  }

  # Check if it's an atomic vector with length > 1
  if (is.atomic(obj) && length(obj) > 1) {
    return(TRUE)
  }

  # Check for other iterable types (but not R6 objects, which are environments)
  if (inherits(obj, "R6") || (is.environment(obj) && !is.null(obj$.__enclos_env__))) {
    return(FALSE)
  }
  if (inherits(obj, c("environment", "pairlist"))) {
    return(TRUE)
  }

  return(FALSE)
}

#  Generate a sequence for retry attempts
# 
#  Creates a sequence from 1 to n for retry attempts with optional forcing of at least one retry
# 
#  @param n Number of retries to perform
#  @param force_retry Whether to force at least one retry attempt even if n is 0 (default: FALSE)
#  @return An integer sequence to iterate over for retry attempts
#  @export
retry_range <- function(n, force_retry = FALSE) {
  # Ensure n is a non-negative integer
  n <- as.integer(n)
  if (is.na(n) || n < 0) {
    stop("Number of retries must be a non-negative integer")
  }

  # If force_retry is TRUE, ensure at least one attempt
  if (force_retry && n == 0) {
    return(1)
  }

  # Return sequence from 1 to n
  return(seq_len(max(1, n)))
}

#  Normalize a message ID to a consistent string key.
# 
#  Handles bigz, numeric (double), and character inputs to always produce
#  the same decimal string representation for the same underlying value.
# 
#  @param msg_id Message ID (bigz, numeric, or character)
#  @return Character string key
#  @keywords internal
msg_id_key <- function(msg_id) {
  # Always normalize to sprintf("%.0f", numeric) so that both bigz (from

  # get_new_msg_id) and double (from read_long / bytes_to_int) produce the
  # same key.  Both suffer the same double-precision rounding, making the
  # keys consistent.
  if (is.null(msg_id) || length(msg_id) == 0) {
    return("0")
  }
  sprintf("%.0f", as.numeric(msg_id))
}

#  Synchronously resolve a promise by pumping the later event loop.
# 
#  R promises schedule their callbacks via `later::later()`.  When running
#  inside a tight synchronous loop (no Shiny / httpuv reactor) those callbacks
#  never fire unless we explicitly call `later::run_now()`.  This helper does
#  exactly that: it installs fulfillment/rejection handlers and then pumps
#  `later::run_now()` in a busy-wait until the promise settles.
# 
#  If the input is NOT a promise it is returned as-is, so this is safe to call
#  on any value.
# 
#  @param p A promise (or plain value).
#  @param timeout Maximum seconds to wait before raising an error.
#  @return The fulfilled value, or stops with the rejection reason.
#  @keywords internal
await_promise <- function(p, timeout = 30) {
  if (!inherits(p, "promise")) {
    return(p)
  }

  result <- NULL
  error <- NULL
  resolved <- FALSE

  promises::then(p,
    onFulfilled = function(value) {
      result <<- value
      resolved <<- TRUE
    },
    onRejected = function(err) {
      error <<- err
      resolved <<- TRUE
    }
  )

  # Block until the promise resolves, using later::run_now() with a 1-second
  # timeout per iteration. This avoids the tight 50ms busy-wait that was
  # burning CPU and leaking R's protection stack on long runs.
  started <- proc.time()[["elapsed"]]
  while (!resolved) {
    remaining <- timeout - (proc.time()[["elapsed"]] - started)
    if (remaining <= 0) {
      stop(sprintf("ReadTimeoutError: timed out after %.1f seconds waiting for promise", timeout))
    }
    later::run_now(timeoutSecs = min(remaining, 1.0))
  }

  if (!is.null(error)) {
    if (inherits(error, "error")) stop(error)
    stop(simpleError(as.character(error)))
  }
  result
}

#  Cancel futures if they are not resolved
# 
#  @param log Logger object for logging messages
#  @param ... Named future objects to cancel
#  @export
cancel_futures <- function(log, ...) {
  # Get named arguments
  futures <- list(...)

  # Cancel each future if it exists
  for (name in names(futures)) {
    future <- futures[[name]]
    if (!is.null(future) && !future::resolved(future)) {
      tryCatch(
        {
          log$debug("Cancelling future: %s", name)
          future$cancel()
        },
        error = function(e) {
          log$warning("Error cancelling future %s: %s", name, e$message)
        }
      )
    }
  }
}

#  Extract traceback information from an error
# 
#  Formats an error's traceback into a readable string for logging
# 
#  @param error The error object to extract the traceback from
#  @return A formatted string containing the traceback
#  @export
get_traceback <- function(error) {
  # Get the traceback if available
  tb <- if (inherits(error, "error") && !is.null(attr(error, "traceback"))) {
    attr(error, "traceback")
  } else if (!is.null(traceback <- tryCatch(base::sys.calls(), error = function(e) NULL))) {
    paste(format(traceback), collapse = "\n")
  } else {
    "No traceback available"
  }

  # Format the error with its message and traceback
  return(paste0(
    "Error: ", error$message, "\n",
    "Traceback:\n",
    paste(tb, collapse = "\n")
  ))
}

#  Clone an error object
# 
#  Creates a copy of an error object preserving its class, message and other attributes
# 
#  @param error The error object to clone
#  @return A new error object with the same properties
#  @export
clone_error <- function(error) {
  if (!inherits(error, "error")) {
    stop("Input must be an error object")
  }

  # Create a new error with the same message
  new_error <- simpleError(conditionMessage(error))

  # Copy class from original error
  class(new_error) <- class(error)

  # Copy attributes from original error (except 'class')
  original_attrs <- attributes(error)
  for (attr_name in names(original_attrs)) {
    if (attr_name != "class") {
      attr(new_error, attr_name) <- original_attrs[[attr_name]]
    }
  }

  return(new_error)
}

#  MTProto Mobile Protocol sender
# 
#  This class is responsible for wrapping requests into TLMessage objects,
#  sending them over the network and receiving them in a safe manner.
#  Automatic reconnection due to temporary network issues is handled by this class,
#  including retry of messages that could not be sent successfully.
#  A new authorization key will be generated on connection if no other key exists yet.
#  @importFrom R6 R6Class
#  @importFrom future plan multisession resolved value
#  @title MTProtoSender
#  @description Telegram API type MTProtoSender
#  @export
#  @noRd
#  @noRd
MTProtoSender <- R6::R6Class("MTProtoSender",
  public = list(
    #  @field auth_key Authentication key
    auth_key = NULL,

    #  @field time_offset Time offset with server
    time_offset = NULL,

    # disconnected = future::future(NULL, seed = TRUE),

    #  @description
    #  Initialize a new MTProtoSender
    #  @param auth_key Authentication key
    #  @param retries Number of retries for failed operations
    #  @param delay Delay between retries in seconds
    #  @param auto_reconnect Whether to automatically reconnect
    #  @param connect_timeout Connection timeout in seconds
    #  @param auth_key_callback Callback for auth key updates
    #  @param updates_queue Queue for updates
    #  @param auto_reconnect_callback Callback after reconnection
    initialize = function(auth_key = NULL,
                          retries = 5, delay = 1, auto_reconnect = TRUE,
                          connect_timeout = NULL, auth_key_callback = NULL,
                          updates_queue = NULL, auto_reconnect_callback = NULL) {
      # Invalidate cached ctor_map so it rebuilds with current environment
      options(telegramR.ctor_map = NULL)

      null_logger <- list(
        debug = function(...) NULL,
        info = function(...) NULL,
        warning = function(...) NULL,
        error = function(...) NULL
      )

      private$connection <- NULL
      private$retries <- retries
      private$delay <- delay
      private$auto_reconnect <- auto_reconnect
      private$connect_timeout <- connect_timeout
      private$auth_key_callback <- auth_key_callback
      private$updates_queue <- updates_queue
      private$auto_reconnect_callback <- auto_reconnect_callback
      private$connect_lock <- {
        lock <- NULL
        list(lock = function() {
          lock <<- TRUE
        }, unlock = function() {
          lock <<- NULL
        })
      }
      private$ping <- NULL

      # Connection state
      private$user_connected <- FALSE
      private$reconnecting <- FALSE
      if (isTRUE(getOption("telegramR.skip_background", FALSE)) || isTRUE(getOption("telegramR.test_mode", FALSE))) {
        private$disconnected_future <- NULL
      } else {
        private$disconnected_future <- future::future(NULL, seed = NULL)
      }

      # Loop handles
      private$send_loop_handle <- NULL
      private$recv_loop_handle <- NULL

      # Preserve auth_key reference
      self$auth_key <- auth_key %||% AuthKey$new(NULL)
      self$time_offset <- 0
      private$last_msg_id <- 0
      private$sequence <- 0
      private$log <- if (!is.null(private$loggers) && !is.null(private$loggers[["MTProtoSender"]])) {
        lg <- private$loggers[["MTProtoSender"]]
        if (is.function(lg)) {
          list(debug = lg, info = lg, warning = lg, error = lg)
        } else {
          lg
        }
      } else {
        null_logger
      }
      private$state <- MTProtoState$new(self$auth_key, loggers = private$loggers)

      # Outgoing message queue
      private$send_queue <- MessagePacker$new(private$state, loggers = private$loggers)

      # Track sent states
      private$pending_state <- list()

      # Responses to acknowledge (simple set with add/clear/length support)
      private$pending_ack <- local({
        items <- list()
        list(
          add = function(x) {
            items[[length(items) + 1]] <<- x
          },
          clear = function() {
            items <<- list()
          },
          length = function() base::length(items),
          as_list = function() items
        )
      })
      class(private$pending_ack) <- "PendingAckSet"

      # Last acknowledgments
      private$last_acks <- deque(10)

      # Jump table from constructor ID to handler method.
      # Helper to safely get a constructor ID and normalize it as a character key.
      ctor_key <- function(cls_name) {
        cls <- tryCatch(get(cls_name, inherits = TRUE), error = function(e) NULL)
        if (is.null(cls)) {
          return(NULL)
        }
        cid <- NULL
        if (inherits(cls, "R6ClassGenerator")) {
          # Try active bindings first (no instantiation needed)
          af <- cls$active
          if (!is.null(af) && is.function(af$CONSTRUCTOR_ID)) {
            cid <- tryCatch(af$CONSTRUCTOR_ID(), error = function(e) NULL)
          }
          # Try public fields
          if (is.null(cid)) {
            pf <- cls$public_fields
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
          }
          # Last resort: try instantiation
          if (is.null(cid)) {
            inst <- tryCatch(cls$new(), error = function(e) NULL)
            if (!is.null(inst)) cid <- tryCatch(inst$CONSTRUCTOR_ID, error = function(e) NULL)
          }
        }
        if (is.null(cid)) {
          return(NULL)
        }
        v <- as.numeric(cid)
        if (is.na(v)) {
          return(NULL)
        }
        if (v < 0) v <- v + 2^32
        sprintf("%.0f", v)
      }

      handler_defs <- list(
        list("RpcResult", private$handle_rpc_result),
        list("MessageContainer", private$handle_container),
        list("GzipPacked", private$handle_gzip_packed),
        list("Pong", private$handle_pong),
        list("BadServerSalt", private$handle_bad_server_salt),
        list("BadMsgNotification", private$handle_bad_notification),
        list("MsgDetailedInfo", private$handle_detailed_info),
        list("MsgNewDetailedInfo", private$handle_new_detailed_info),
        list("NewSessionCreated", private$handle_new_session_created),
        list("MsgsAck", private$handle_ack),
        list("FutureSalts", private$handle_future_salts),
        list("MsgsStateReq", private$handle_state_forgotten),
        list("MsgResendReq", private$handle_state_forgotten),
        list("MsgsAllInfo", private$handle_msg_all),
        list("DestroySessionOk", private$handle_destroy_session),
        list("DestroySessionNone", private$handle_destroy_session),
        list("DestroyAuthKeyOk", private$handle_destroy_auth_key),
        list("DestroyAuthKeyNone", private$handle_destroy_auth_key),
        list("DestroyAuthKeyFail", private$handle_destroy_auth_key)
      )
      private$handlers <- list()
      for (def in handler_defs) {
        key <- ctor_key(def[[1]])
        if (!is.null(key)) {
          private$handlers[[key]] <- def[[2]]
        }
      }
    },

    #  @description
    #  Connects to the specified given connection using the given auth key.
    #  @param connection Connection object to use
    #  @return TRUE if connected successfully, FALSE otherwise
    connect = function(connection) {
      if (private$._is_test_mode()) {
        private$connection <- connection
        res <- tryCatch(
          private$._resolve(private$connection$connect(timeout = private$connect_timeout)),
          error = function(e) e
        )
        if (inherits(res, "error") || !isTRUE(res)) {
          stop(sprintf(
            "ConnectionError: Connection to Telegram failed %d time(s)",
            private$retries
          ))
        }
        private$user_connected <- TRUE
        return(future::future(TRUE))
      }

      private$connect_lock$lock()
      on.exit(private$connect_lock$unlock())

      if (private$user_connected) {
        private$log$info("User is already connected!")
        return(FALSE)
      }

      private$connection <- connection
      private$.connect()
      private$user_connected <- TRUE
      return(TRUE)
    },

    #  @description
    #  Check if user is connected
    #  @return TRUE if connected, FALSE otherwise
    is_connected = function() {
      return(private$user_connected)
    },

    #  @description
    #  Check if transport layer is connected
    #  @return TRUE if transport connected, FALSE otherwise
    transport_connected = function() {
      return(
        !private$reconnecting &&
          !is.null(private$connection) &&
          private$connection$connected
      )
    },

    #  @description
    #  Cleanly disconnects the instance from the network, cancels
    #  all pending requests, and closes the send and receive loops.
    disconnect = function() {
      if (isTRUE(getOption("telegramR.test_mode")) || identical(Sys.getenv("TESTTHAT"), "true")) {
        private$user_connected <- FALSE
        return(future::future(NULL))
      }
      result <- future(private$disconnect())
      return(result)
    },

    #  @description
    #  Enqueues the given request to be sent. Its send state will
    #  be saved until a response arrives, and a future that will be
    #  resolved when the response arrives will be returned.
    # 
    #  @param request Request or list of requests to send
    #  @param ordered Whether requests should be executed in order
    #  @return Future or list of futures that will resolve with the response
    send = function(request, ordered = FALSE) {
      if (!private$user_connected) {
        stop("ConnectionError: Cannot send requests while disconnected")
      }

      if (!is_list_like(request)) {
        tryCatch(
          {
            state <- RequestState$new(request)
          },
          error = function(e) {
            private$log$error("Request caused error: %s: %s", e$message, request)
            stop(e)
          }
        )

        private$send_queue$append(state)
        private$pump_io_until(list(state))
        return(state$future)
      } else {
        states <- list()
        futures <- list()
        state <- NULL

        for (req in request) {
          tryCatch(
            {
              state <- RequestState$new(req, after = ordered && !is.null(state))
            },
            error = function(e) {
              private$log$error("Request caused error: %s: %s", e$message, request)
              stop(e)
            }
          )

          states <- append(states, state)
          futures <- append(futures, state$future)
        }

        private$send_queue$extend(states)
        private$pump_io_until(states)
        return(futures)
      }
    },

    #  @description
    #  Get future that resolves when connection to Telegram ends
    #  @return Future that resolves on disconnection
    disconnected = function() {
      if (is.null(private$disconnected_future)) {
        return(promises::promise_resolve(NULL))
      }
      return(future::future_promise(private$disconnected_future))
    },

    #  @description
    #  Generate a new unique message ID
    #  @return New message ID
    get_new_msg_id = function() {
      now <- as.numeric(Sys.time()) + self$time_offset
      sec <- floor(now)
      nanos <- floor((now - sec) * 1e9)
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

    #  @description
    #  Set the callback invoked when the auth key changes
    #  @param callback Function accepting an AuthKey object
    set_auth_key_callback = function(callback) {
      private$auth_key_callback <- callback
    },

    #  @description
    #  Set the callback invoked when updates are received
    #  @param callback Function accepting an update object
    set_update_callback = function(callback) {
      private$update_callback <- callback
    },

    #  @description
    #  Update time offset based on a correct message ID
    #  @param correct_msg_id Known valid message ID
    #  @return Updated time offset
    update_time_offset = function(correct_msg_id) {
      bad <- self$get_new_msg_id()
      old <- self$time_offset

      now <- as.integer(Sys.time())
      if (is.na(correct_msg_id)) {
        correct <- now + 10
      } else {
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
    connection = NULL,
    loggers = NULL,
    log = NULL,
    retries = NULL,
    delay = NULL,
    auto_reconnect = NULL,
    connect_timeout = NULL,
    auth_key_callback = NULL,
    update_callback = NULL,
    updates_queue = NULL,
    auto_reconnect_callback = NULL,
    connect_lock = NULL,
    ping = NULL,
    user_connected = NULL,
    reconnecting = NULL,
    send_loop_handle = NULL,
    recv_loop_handle = NULL,
    state = NULL,
    send_queue = NULL,
    pending_state = NULL,
    pending_ack = NULL,
    last_acks = NULL,
    handlers = NULL,
    last_msg_id = NULL,
    sequence = NULL,
    disconnected_future = NULL,
    future_salts = list(),   # list of FutureSalt objects, sorted valid_since asc
    ._resolve = function(x) {
      if (inherits(x, "promise")) {
        t <- getOption("telegramR.promise_timeout", NULL)
        if (is.numeric(t) && is.finite(t) && t > 0) {
          return(await_promise(x, timeout = t))
        }
        return(await_promise(x))
      }
      if (inherits(x, "Future")) {
        t <- getOption("telegramR.promise_timeout", NULL)
        if (is.numeric(t) && is.finite(t) && t > 0) {
          return(future::value(x, timeout = t))
        }
        return(future::value(x))
      }
      x
    },
    ._err_text = function(e, fallback = "unknown error") {
      msg_txt <- tryCatch(conditionMessage(e), error = function(...) "")
      if (!nzchar(msg_txt)) {
        msg_txt <- tryCatch(e$message, error = function(...) "")
      }
      if (!nzchar(msg_txt)) {
        msg_txt <- tryCatch(paste(capture.output(str(e, give.attr = FALSE, vec.len = 3)), collapse = " "), error = function(...) "")
      }
      if (!nzchar(msg_txt)) fallback else msg_txt
    },
    ._is_test_mode = function() {
      isTRUE(getOption("telegramR.test_mode")) || identical(Sys.getenv("TESTTHAT"), "true")
    },
    # Convert a fallback list (with CONSTRUCTOR_ID + raw data) into a proper
    # R6 object for critical MTProto types that handlers depend on.
    ._parse_fallback_obj = function(obj) {
      dbg_parse <- isTRUE(getOption("telegramR.debug_parse", FALSE))
      log_parse <- function(fmt, ...) if (dbg_parse) message(sprintf(fmt, ...))
      ctor <- as.numeric(obj$CONSTRUCTOR_ID)
      if (is.na(ctor)) {
        return(obj)
      }
      if (ctor < 0) ctor <- ctor + 2^32
      data <- obj$data
      if (is.null(data) || length(data) == 0) {
        return(obj)
      }

      reader <- tryCatch(BinaryReader$new(data), error = function(e) NULL)
      if (is.null(reader)) {
        return(obj)
      }

      log_parse(
        "[parse_fallback] ctor=%.0f, class=%s, data_len=%d",
        ctor, class(ctor), length(data)
      )

      # Use plain lists with the correct field names to avoid R6 inheritance
      # conflicts (TLObject defines CONSTRUCTOR_ID as a public field, but some
      # subclasses like BadServerSalt override it with an active binding).
      parsed <- tryCatch(
        {
          # BadServerSalt  0xedab447b = 3987424379
          if (isTRUE(abs(ctor - 3987424379) < 1)) {
            bad_msg_id <- reader$read_long(signed = FALSE)
            bad_msg_seqno <- reader$read_int()
            error_code <- reader$read_int()
            new_server_salt <- reader$read_long(signed = FALSE)
            log_parse(
              "[parse_fallback] BadServerSalt: bad_msg_id=%s, error=%s, new_salt=%s",
              as.character(bad_msg_id), as.character(error_code),
              as.character(new_server_salt)
            )
            list(
              CONSTRUCTOR_ID = ctor, bad_msg_id = bad_msg_id,
              bad_msg_seqno = bad_msg_seqno, error_code = error_code,
              new_server_salt = new_server_salt
            )

            # RpcResult  0xf35c6d01 = 4082920705
          } else if (isTRUE(abs(ctor - 4082920705) < 1)) {
            msg_id <- reader$read_long()
            inner_code <- reader$read_int(signed = FALSE)
            rpc_error_ctor <- as.numeric(0x2144ca19)
            gzip_ctor <- as.numeric(0x3072cfa1)
            if (isTRUE(abs(as.numeric(inner_code) - rpc_error_ctor) < 1)) {
              error_code <- reader$read_int()
              error_message <- reader$tgread_string()
              log_parse("[parse_fallback] RpcResult error: %d %s", error_code, error_message)
              list(
                CONSTRUCTOR_ID = ctor, req_msg_id = msg_id, body = NULL,
                error = list(error_code = error_code, error_message = error_message)
              )
            } else if (isTRUE(abs(as.numeric(inner_code) - gzip_ctor) < 1)) {
              decompressed <- memDecompress(reader$tgread_bytes(), type = "gzip")
              list(CONSTRUCTOR_ID = ctor, req_msg_id = msg_id, body = decompressed, error = NULL)
            } else {
              # Seek back 4 bytes to include inner constructor ID in body
              cur_pos <- reader$tell_position()
              remaining <- length(data) - cur_pos + 4 # +4 for the inner_code we already read
              reader$set_position(cur_pos - 4)
              body_bytes <- reader$read(remaining)
              list(CONSTRUCTOR_ID = ctor, req_msg_id = msg_id, body = body_bytes, error = NULL)
            }

            # NewSessionCreated  0x9ec20908 = 2663516424
          } else if (isTRUE(abs(ctor - 2663516424) < 1)) {
            first_msg_id <- reader$read_long()
            unique_id <- reader$read_long()
            server_salt <- reader$read_long(signed = FALSE)
            log_parse("[parse_fallback] NewSessionCreated: salt=%s", as.character(server_salt))
            list(
              CONSTRUCTOR_ID = ctor, first_msg_id = first_msg_id,
              unique_id = unique_id, server_salt = server_salt
            )

            # GzipPacked  0x3072cfa1 = 812830625
          } else if (isTRUE(abs(ctor - 812830625) < 1)) {
            list(
              CONSTRUCTOR_ID = ctor,
              data = memDecompress(reader$tgread_bytes(), type = "gzip")
            )

            # MessageContainer  0x73f1f8dc = 1945237724
          } else if (isTRUE(abs(ctor - 1945237724) < 1)) {
            count <- reader$read_int()
            messages <- list()
            for (i in seq_len(count)) {
              msg_id <- reader$read_long()
              seq_no <- reader$read_int()
              len <- reader$read_int()
              before <- reader$tell_position()
              inner_obj <- reader$tgread_object()
              reader$set_position(before + len)
              # Use plain list instead of TLMessage$new() to avoid R6 inheritance conflict
              messages[[i]] <- list(msg_id = msg_id, seq_no = seq_no, obj = inner_obj)
            }
            # Return plain list with messages field (handle_container accesses $messages)
            list(CONSTRUCTOR_ID = ctor, messages = messages)

            # BadMsgNotification  0xa7eff811 = 2817521681
          } else if (isTRUE(abs(ctor - 2817521681) < 1)) {
            bad_msg_id <- reader$read_long()
            bad_msg_seqno <- reader$read_int()
            error_code <- reader$read_int()
            list(
              CONSTRUCTOR_ID = ctor, bad_msg_id = bad_msg_id,
              bad_msg_seqno = bad_msg_seqno, error_code = error_code
            )

            # Pong  0x347773c5 = 880243653
          } else if (isTRUE(abs(ctor - 880243653) < 1)) {
            msg_id <- reader$read_long()
            ping_id <- reader$read_long()
            list(CONSTRUCTOR_ID = ctor, msg_id = msg_id, ping_id = ping_id)

            # MsgsAck  0x62d6b459 = 1658238041
          } else if (isTRUE(abs(ctor - 1658238041) < 1)) {
            vec_ctor <- reader$read_int(signed = FALSE) # vector constructor
            count <- reader$read_int()
            msg_ids <- list()
            for (i in seq_len(count)) {
              msg_ids[[i]] <- reader$read_long()
            }
            list(CONSTRUCTOR_ID = ctor, msg_ids = msg_ids)
          } else {
            obj
          }
        },
        error = function(e) {
          log_parse("[parse_fallback] ERROR parsing ctor %.0f: %s", ctor, conditionMessage(e))
          obj
        }
      )

      tryCatch(reader$close(), error = function(e) NULL)
      parsed
    },
    ._ensure_transport_connected = function() {
      if (is.null(private$connection)) {
        stop("ConnectionError: No active transport")
      }
      connected <- TRUE
      if (is.function(private$connection$is_connected)) {
        connected <- isTRUE(private$connection$is_connected())
      }
      if (!connected) {
        private$log$warning("Transport was disconnected, reconnecting...")
        res <- private$._resolve(private$connection$connect(timeout = private$connect_timeout))
        if (!isTRUE(res)) {
          stop("ConnectionError: transport reconnect failed")
        }
      }
      invisible(TRUE)
    },
    .connect = function() {
      private$log$info("Connecting to %s...", private$connection$to_string())

      connected <- FALSE
      last_connect_error <- NULL

      for (attempt in retry_range(private$retries)) {
        if (!connected) {
          connect_res <- private$._resolve(private$try_connect(attempt))
          connected <- isTRUE(connect_res)
          if (inherits(connect_res, "connect_failed")) {
            last_connect_error <- attr(connect_res, "message")
          }
          if (!connected) {
            next # Skip auth key generation until connected
          }
        }

        if (is.null(self$auth_key$key)) {
          tryCatch(
            {
              gen_res <- future::value(private$try_gen_auth_key(attempt))
              if (inherits(gen_res, "auth_gen_failed")) {
                last_connect_error <- attr(gen_res, "message")
              }
              if (!isTRUE(gen_res) && is.null(last_connect_error)) {
                last_connect_error <- "auth key generation returned FALSE without exception"
              }
              if (!isTRUE(gen_res)) {
                next # Keep retrying until we have the auth key
              }
            },
            error = function(e) {
              last_connect_error <<- e$message
              # Sometimes Telegram may close the connection during auth_key generation
              private$log$warning(
                "Connection error %d during auth_key gen: %s: %s",
                attempt, class(e)[1], e$message
              )

              # Disconnect for clean reconnection
              await_promise(private$connection$disconnect())
              connected <- FALSE
              Sys.sleep(private$delay)
            }
          )
        }

        break # All steps done, break retry loop
      }

      if (!connected) {
        if (!is.null(last_connect_error)) {
          stop(sprintf(
            "ConnectionError: Connection to Telegram failed %d time(s). Last error: %s",
            private$retries, last_connect_error
          ))
        } else {
          stop(sprintf(
            "ConnectionError: Connection to Telegram failed %d time(s)",
            private$retries
          ))
        }
      }

      if (is.null(self$auth_key$key)) {
        if (!is.null(last_connect_error) && nzchar(last_connect_error)) {
          e <- simpleError(sprintf(
            "ConnectionError: auth_key generation failed %d time(s). Last error: %s",
            private$retries, last_connect_error
          ))
        } else {
          e <- simpleError(sprintf(
            "ConnectionError: auth_key generation failed %d time(s)",
            private$retries
          ))
        }
        private$.disconnect(error = e)
        stop(e)
      }

      # Keep sender IO in-process to avoid cross-process state divergence.
      private$send_loop_handle <- NULL
      private$recv_loop_handle <- NULL
      private$log$debug("Sender IO mode: in-process synchronous pumping")

      # Reset disconnected future if already completed
      if (!is.null(private$disconnected_future) && future::resolved(private$disconnected_future)) {
        if (isTRUE(getOption("telegramR.skip_background", FALSE)) || isTRUE(getOption("telegramR.test_mode", FALSE))) {
          private$disconnected_future <- NULL
        } else {
          private$disconnected_future <- future::future(NULL, seed = NULL)
        }
      }

      private$log$info("Connection to %s complete!", private$connection$to_string())
    },
    try_connect = function(attempt) {
      tryCatch(
        {
          private$log$debug("Connection attempt %d...", attempt)
          res <- private$._resolve(private$connection$connect(timeout = private$connect_timeout))
          if (!isTRUE(res)) {
            stop("Connection returned FALSE")
          }
          private$log$debug("Connection success!")
          return(TRUE)
        },
        error = function(e) {
          msg_txt <- tryCatch(conditionMessage(e), error = function(...) as.character(e))
          call_txt <- tryCatch(paste(deparse(conditionCall(e)), collapse = " "), error = function(...) "")
          private$log$warning(
            "Attempt %d at connecting failed: %s: %s",
            attempt, class(e)[1], msg_txt
          )
          Sys.sleep(private$delay)
          structure(FALSE, class = c("connect_failed", "logical"), message = paste(msg_txt, call_txt))
        }
      )
    },
    try_gen_auth_key = function(attempt) {
      plain <- MTProtoPlainSender$new(private$connection, loggers = private$loggers)
      tryCatch(
        {
          private$log$debug("New auth_key attempt %d...", attempt)
          result <- private$._resolve(do_authentication(plain))

          auth_key_value <- result$auth_key
          if (inherits(auth_key_value, "AuthKey")) {
            auth_key_value <- auth_key_value$key
          } else if (is.list(auth_key_value) && !is.null(auth_key_value$key)) {
            auth_key_value <- auth_key_value$key
          }
          self$auth_key$key <- auth_key_value
          private$state$time_offset <- result$time_offset

          # Notify about auth key change if callback provided
          if (!is.null(private$auth_key_callback)) {
            private$auth_key_callback(self$auth_key)
          }

          private$log$debug("auth_key generation success!")
          return(TRUE)
        },
        error = function(e) {
          if (inherits(e, c("SecurityError", "AssertionError"))) {
            msg_txt <- private$._err_text(e, fallback = "unknown security/assertion error")
            private$log$warning("Attempt %d at new auth_key failed: %s", attempt, msg_txt)
            Sys.sleep(private$delay)
            return(structure(FALSE, class = c("auth_gen_failed", "logical"), message = msg_txt))
          } else {
            msg_txt <- private$._err_text(e, fallback = "unknown auth_key error")
            private$log$warning("Attempt %d at new auth_key failed: %s: %s", attempt, class(e)[1], msg_txt)
            stop(simpleError(msg_txt))
          }
        }
      )
    },
    .disconnect = function(error = NULL) {
      if (is.null(private$connection)) {
        private$log$info("Not disconnecting (already have no connection)")
        return(NULL)
      }

      private$log$info("Disconnecting from %s...", private$connection$to_string())
      private$user_connected <- FALSE

      tryCatch({
        private$log$debug("Closing current connection...")
        await_promise(private$connection$disconnect())
      }, finally = {
        private$log$debug("Cancelling %d pending message(s)...", length(private$pending_state))

        for (state in private$pending_state) {
          if (!is.null(error) && !future::resolved(state$future)) {
            state$future$set_exception(error)
          } else {
            state$future$cancel()
          }
        }

        private$pending_state <- list()
        cancel_futures(
          private$log,
          send_loop_handle = private$send_loop_handle,
          recv_loop_handle = private$recv_loop_handle
        )

        private$log$info("Disconnection from %s complete!", private$connection$to_string())
        private$connection <- NULL
      })

      if (!is.null(private$disconnected_future) && !future::resolved(private$disconnected_future)) {
        # Keep this as a plain future marker; base Future objects do not
        # expose set_result/set_exception APIs.
        if (isTRUE(getOption("telegramR.skip_background", FALSE)) || isTRUE(getOption("telegramR.test_mode", FALSE))) {
          private$disconnected_future <- NULL
        } else {
          private$disconnected_future <- future::future(NULL, seed = NULL)
        }
      }
    },
    .reconnect = function(last_error) {
      private$log$info("Closing current connection to begin reconnect...")
      await_promise(private$connection$disconnect())

      cancel_futures(
        private$log,
        send_loop_handle = private$send_loop_handle,
        recv_loop_handle = private$recv_loop_handle
      )

      private$reconnecting <- FALSE

      # Start with clean state to avoid old messages
      private$state$reset()

      retries <- if (private$auto_reconnect) private$retries else 0

      attempt <- 0
      ok <- TRUE

      # Try reconnection
      for (attempt in retry_range(retries, force_retry = FALSE)) {
        tryCatch(
          {
            private$connect()
          },
          error = function(e) {
            if (inherits(e, c("IOError", "TimeoutError"))) {
              last_error <- e
              private$log$info(
                "Failed reconnection attempt %d with %s",
                attempt, class(e)[1]
              )
              Sys.sleep(private$delay)
            } else if (inherits(e, "InvalidBufferError") && e$code == 404) {
              private$log$info("Server does not know about the current auth key; the session may need to be recreated")
              last_error <- AuthKeyNotFound$new()
              ok <- FALSE
              return(FALSE) # Break the loop
            } else if (inherits(e, "BufferError")) {
              private$log$warning("Invalid buffer %s", e$message)
            } else {
              last_error <- e
              private$log$error(
                "Unexpected exception reconnecting on attempt %d: %s",
                attempt, e$message
              )
              private$log$error(get_traceback(e))
              Sys.sleep(private$delay)
            }
          }
        )

        # If we made it here without error, reconnection was successful
        if (ok) {
          # Requeue pending requests
          private$send_queue$extend(private$pending_state)
          private$pending_state <- list()

          # Call callback if defined
          if (!is.null(private$auto_reconnect_callback)) {
            future({
              tryCatch(
                private$auto_reconnect_callback(),
                error = function(e) private$log$error("Error in reconnect callback: %s", e$message)
              )
            })
          }

          break
        }
      }

      if (!ok) {
        private$log$error("Automatic reconnection failed %d time(s)", attempt)
        # Use the last error encountered or NULL if none
        error <- if (!is.null(last_error)) clone_error(last_error) else NULL
        future::value(private$disconnect(error = error))
      }
    },
    start_reconnect = function(error) {
      if (private$user_connected && !private$reconnecting) {
        # Set reconnecting flag to avoid race conditions
        private$reconnecting <- TRUE
        future({
          tryCatch(
            private$reconnect(error),
            error = function(e) private$log$error("Error in reconnect: %s", e$message)
          )
        })
      }
    },
    pump_io_until = function(states) {
      if (length(states) == 0) {
        return(invisible(NULL))
      }

      dbg <- isTRUE(getOption("telegramR.debug_pump", FALSE))
      log_pump <- function(fmt, ...) if (dbg) message(sprintf(fmt, ...))
      log_pump_raw <- function(msg) if (dbg) message(msg)
      trace_on <- isTRUE(getOption("telegramR.trace_hang", FALSE))
      trace_log <- function(msg) {
        if (trace_on) {
          message(sprintf("[trace] %s", msg))
        }
      }
      safe_msg <- function(e) {
        tryCatch(as.character(conditionMessage(e)), error = function(e2) "")
      }

      private$._ensure_transport_connected()

      timeout_sec <- as.numeric(getOption("telegramR.promise_timeout", 30))
      if (!is.finite(timeout_sec) || timeout_sec <= 0) {
        timeout_sec <- 30
      }
      started_at <- proc.time()[["elapsed"]]
      state_done <- function(s) isTRUE(future::resolved(s$future))

      # First, flush the send queue: send all pending items
      while (length(private$send_queue$deque) > 0) {
        if (private$pending_ack$length() > 0) {
          ack <- RequestState$new(MsgsAck$new(private$pending_ack$as_list()))
          private$send_queue$append(ack)
          private$last_acks$append(ack)
          private$pending_ack$clear()
        }

        result <- private$send_queue$get()
        batch <- result$batch
        data <- result$data

        if (!is.null(data) && length(data) > 0) {
          private$update_salt_if_needed()
          data <- private$state$encrypt_message_data(data)

          for (st in batch) {
            if (!is.list(st)) {
              key <- msg_id_key(st$msg_id)
              log_pump(
                "[pump] batch item: class=%s, msg_id_key=%s",
                paste(class(st$request), collapse = ","), key
              )
              private$pending_state[[key]] <- st
            } else {
              for (s in st) {
                private$pending_state[[msg_id_key(s$msg_id)]] <- s
              }
            }
          }

          log_pump(
            "[pump] Sending %d encrypted bytes, pending_keys=%s",
            length(data), paste(names(private$pending_state), collapse = ",")
          )
          tryCatch(
            {
              await_promise(private$connection$send(data), timeout = timeout_sec)
              log_pump_raw("[pump] Send completed OK")
            },
            error = function(e) {
              msg <- safe_msg(e)
              log_pump("[pump] Send error: %s", msg)
              stop(e)
            }
          )
        }
      }

      # Now receive responses until all states are resolved
      log_pump(
        "[pump] Entering recv loop, %d state(s) to resolve, pending_state keys: %s",
        length(states), paste(names(private$pending_state), collapse = ",")
      )
      while (!all(vapply(states, state_done, logical(1)))) {
        elapsed <- proc.time()[["elapsed"]] - started_at
        remaining <- timeout_sec - elapsed
        if (is.finite(timeout_sec) && timeout_sec > 0 && remaining <= 0) {
          stop(sprintf("PromiseTimeoutError: timed out after %.1f seconds", timeout_sec))
        }

        # Send any pending acks
        if (private$pending_ack$length() > 0) {
          ack <- RequestState$new(MsgsAck$new(private$pending_ack$as_list()))
          private$send_queue$append(ack)
          private$last_acks$append(ack)
          private$pending_ack$clear()
        }

        # Flush any items in the send queue (re-queued requests, acks, etc.)
        while (length(private$send_queue$deque) > 0) {
          result <- private$send_queue$get()
          batch <- result$batch
          data <- result$data
          if (!is.null(data) && length(data) > 0) {
            private$update_salt_if_needed()
            data <- private$state$encrypt_message_data(data)
            for (st in batch) {
              if (!is.list(st)) {
                key <- msg_id_key(st$msg_id)
                log_pump(
                  "[pump] re-queue batch item: class=%s, msg_id_key=%s",
                  paste(class(st$request), collapse = ","), key
                )
                private$pending_state[[key]] <- st
              } else {
                for (s in st) {
                  private$pending_state[[msg_id_key(s$msg_id)]] <- s
                }
              }
            }
            log_pump(
              "[pump] Re-sending %d encrypted bytes (%d items), pending_keys=%s",
              length(data), length(batch),
              paste(names(private$pending_state), collapse = ",")
            )
            tryCatch(
              await_promise(private$connection$send(data), timeout = remaining),
              error = function(e) {
                msg <- safe_msg(e)
                log_pump("[pump] Re-send error: %s", msg)
                stop(e)
              }
            )
          }
        }

        trace_log(sprintf("recv wait (remaining=%.1f)", remaining))
        poll_sec <- getOption("telegramR.recv_poll_sec", 5)
        if (!is.numeric(poll_sec) || !is.finite(poll_sec) || poll_sec <= 0) {
          poll_sec <- 5
        }
        poll_timeout <- min(remaining, poll_sec)
        body <- tryCatch(
          {
            await_promise(private$connection$recv(), timeout = poll_timeout)
          },
          error = function(e) {
            msg <- safe_msg(e)
            log_pump("[pump] recv error: %s", msg)

            # A short poll timeout is expected while we wait for the matching RPC.
            # Do not reconnect on every idle poll; that slows downloads down and can
            # make long iterators look stuck.
            if (grepl("ReadTimeoutError", msg, fixed = TRUE) ||
              grepl("PromiseTimeoutError", msg, fixed = TRUE)) {
              return(NULL)
            }

            stop(e)
          }
        )
        if (is.null(body)) {
          trace_log("recv returned NULL")
          next
        }
        trace_log(sprintf("recv bytes=%d", length(body)))
        log_pump("[pump] Received %d bytes", length(body))

        tryCatch(
          {
            trace_log("decrypt start")
            message <- private$state$decrypt_message_data(body)
            trace_log("decrypt done")
            if (!is.null(message)) {
              log_pump(
                "[pump] Decrypted OK, obj class: %s, CTOR: %s",
                paste(class(message$obj), collapse = ","),
                as.character(message$obj$CONSTRUCTOR_ID)
              )
              trace_log("process_message start")
              private$process_message(message)
              trace_log("process_message done")
            } else {
              log_pump_raw("[pump] decrypt returned NULL")
            }
          },
          error = function(e) {
            log_pump("[pump] Decrypt/process error: %s", safe_msg(e))
          }
        )
      }

      invisible(NULL)
    },
    keepalive_ping = function(rnd_id) {
      # If no ping is in progress, send one
      if (is.null(private$ping)) {
        private$ping <- rnd_id
        self$send(PingRequest$new(rnd_id))
      } else {
        # Start reconnection if we didn't get a response
        private$start_reconnect(NULL)
      }
    },

    # Main processing loops

    send_loop = function() {
      while (private$user_connected && !private$reconnecting) {
        # Handle pending acknowledgments
        if (private$pending_ack$length() > 0) {
          ack <- RequestState$new(MsgsAck$new(private$pending_ack$as_list()))
          private$send_queue$append(ack)
          private$last_acks$append(ack)
          private$pending_ack$clear()
        }

        private$log$debug("Waiting for messages to send...")

        # Get batch from queue (with timeout)
        result <- future::value(private$send_queue$get())
        batch <- result$batch
        data <- result$data

        if (is.null(data) || length(data) == 0) {
          next
        }

        private$log$debug(
          "Encrypting %d message(s) in %d bytes for sending",
          length(batch), length(data)
        )

        # Rotate to a valid future salt if one is available.
        private$update_salt_if_needed()
        # Encrypt the message data
        data <- private$state$encrypt_message_data(data)

        # Track pending states
        for (state in batch) {
          if (!is.list(state)) {
            private$pending_state[[msg_id_key(state$msg_id)]] <- state
          } else {
            for (s in state) {
              private$pending_state[[msg_id_key(s$msg_id)]] <- s
            }
          }
        }

        # Send the data
        tryCatch(
          {
            future::value(private$connection$send(data))
          },
          error = function(e) {
            private$log$info("Connection closed while sending data: %s", e$message)
            private$start_reconnect(e)
            return(FALSE) # Exit loop
          }
        )

        private$log$debug("Encrypted messages sent")
      }
    },
    recv_loop = function() {
      while (private$user_connected && !private$reconnecting) {
        private$log$debug("Receiving items from the network...")

        # Receive data
        body <- NULL
        tryCatch(
          {
            body <- future::value(private$connection$recv())
          },
          error = function(e) {
            if (inherits(e, c("IOError", "IncompleteReadError"))) {
              private$log$info("Connection closed while receiving data: %s", e$message)
              private$start_reconnect(e)
              return(FALSE) # Exit loop
            } else if (inherits(e, "InvalidBufferError")) {
              if (e$code == 429) {
                private$log$warning("Server indicated flood error at transport level: %s", e$message)
                future::value(private$disconnect(error = e))
              } else {
                private$log$error("Server sent invalid buffer: %s", e$message)
                private$start_reconnect(e)
              }
              return(FALSE) # Exit loop
            } else {
              private$log$error("Unhandled error while receiving data: %s", e$message)
              private$log$error(get_traceback(e))
              private$start_reconnect(e)
              return(FALSE) # Exit loop
            }
          }
        )

        if (is.null(body)) next

        # Decrypt the message
        message <- NULL
        tryCatch(
          {
            message <- private$state$decrypt_message_data(body)
            if (is.null(message)) {
              next # Message to be ignored
            }
          },
          error = function(e) {
            if (inherits(e, "TypeNotFoundError")) {
              # Unknown object type
              private$log$info(
                "Type %08x not found, remaining data %r",
                e$invalid_constructor_id, e$remaining
              )
            } else if (inherits(e, "SecurityError")) {
              # Decoding error, ignore the message
              private$log$warning("Security error while unpacking a received message: %s", e$message)
            } else if (inherits(e, "InvalidBufferError") && e$code == 404) {
              private$log$info("Server does not know about the current auth key; the session may need to be recreated")
              future::value(private$disconnect(error = AuthKeyNotFound$new()))
              return(FALSE) # Exit loop
            } else if (inherits(e, "BufferError")) {
              private$log$warning("Invalid buffer: %s", e$message)
              private$start_reconnect(e)
              return(FALSE) # Exit loop
            } else {
              private$log$error("Unhandled error while decrypting data: %s", e$message)
              private$log$error(get_traceback(e))
              private$start_reconnect(e)
              return(FALSE) # Exit loop
            }
          }
        )

        if (is.null(message)) next

        # Process the message
        tryCatch(
          {
            private$process_message(message)
          },
          error = function(e) {
            private$log$error("Unhandled error while processing message: %s", e$message)
            private$log$error(get_traceback(e))
          }
        )
      }
    },

    # Message handlers

    process_message = function(message) {
      dbg <- isTRUE(getOption("telegramR.debug_process", FALSE))
      log_proc <- function(fmt, ...) if (dbg) message(sprintf(fmt, ...))
      trace_on <- isTRUE(getOption("telegramR.trace_hang", FALSE))
      trace_log <- function(msg) {
        if (trace_on) {
          message(sprintf("[trace] %s", msg))
        }
      }
      trace_log("process_message enter")
      # Add to pending acknowledgments
      private$pending_ack$add(message$msg_id)

      is_fallback <- is.list(message$obj) && !inherits(message$obj, "R6") &&
        !is.null(message$obj$CONSTRUCTOR_ID) && !is.null(message$obj$data) &&
        length(names(message$obj)) == 2 # raw fallback has exactly CONSTRUCTOR_ID + data

      # If obj is a fallback list (from tgread_object failing to find the class),
      # try to convert it to a proper R6 object for critical MTProto types.
      if (is_fallback) {
        log_proc(
          "[process] Got fallback list, CTOR=%.0f, data_len=%d, attempting parse",
          as.numeric(message$obj$CONSTRUCTOR_ID), length(message$obj$data)
        )
        message$obj <- private$._parse_fallback_obj(message$obj)
        log_proc("[process] After parse: obj_class=%s", paste(class(message$obj), collapse = ","))
      }

      # Find appropriate handler using normalized constructor ID key
      constructor_id <- message$obj$CONSTRUCTOR_ID
      v <- as.numeric(constructor_id)
      if (!is.na(v) && v < 0) v <- v + 2^32
      ctor_str <- sprintf("%.0f", v)
      handler <- private$handlers[[ctor_str]]

      log_proc(
        "[process] ctor_id=%s, handler_found=%s, obj_class=%s",
        ctor_str, !is.null(handler),
        paste(class(message$obj), collapse = ",")
      )

      # Default to update handler if not found
      if (is.null(handler)) {
        handler <- private$handle_update
      }

      # Execute the handler
      tryCatch(
        {
          trace_log(sprintf("handler start: %s", if (is.null(handler)) "NULL" else "ok"))
          handler(message)
          trace_log("handler done")
        },
        error = function(e) {
          log_proc("[process] Handler error: %s", conditionMessage(e))
        }
      )
      trace_log("process_message exit")
    },
    pop_states = function(msg_id) {
      # Look for exact match
      msg_id_str <- msg_id_key(msg_id)
      state <- private$pending_state[[msg_id_str]]
      if (!is.null(state)) {
        private$pending_state[[msg_id_str]] <- NULL
        return(list(state))
      }

      # Look for container ID match
      to_pop <- character(0)
      for (id in names(private$pending_state)) {
        if (identical(msg_id_key(private$pending_state[[id]]$container_id), msg_id_key(msg_id))) {
          to_pop <- c(to_pop, id)
        }
      }

      if (length(to_pop) > 0) {
        states <- list()
        for (id in to_pop) {
          states <- append(states, private$pending_state[[id]])
          private$pending_state[[id]] <- NULL
        }
        return(states)
      }

      # Check last acknowledgments
      for (ack in private$last_acks$items) {
        if (!is.null(ack$msg_id) && length(ack$msg_id) > 0 &&
          identical(msg_id_key(ack$msg_id), msg_id_str)) {
          return(list(ack))
        }
      }

      return(list())
    },
    handle_rpc_result = function(message) {
      dbg <- isTRUE(getOption("telegramR.debug_process", FALSE))
      log_proc <- function(fmt, ...) if (dbg) message(sprintf(fmt, ...))
      trace_on <- isTRUE(getOption("telegramR.trace_hang", FALSE))
      trace_log <- function(msg) {
        if (trace_on) {
          message(sprintf("[trace] %s", msg))
        }
      }
      rpc_result <- message$obj
      req_key <- msg_id_key(rpc_result$req_msg_id)
      log_proc(
        "[handle_rpc_result] req_msg_id=%s, key=%s, pending_keys=%s, has_error=%s",
        as.character(rpc_result$req_msg_id), req_key,
        paste(names(private$pending_state), collapse = ","),
        !is.null(rpc_result$error)
      )
      trace_log(sprintf("handle_rpc_result start key=%s has_error=%s", req_key, !is.null(rpc_result$error)))
      state <- private$pending_state[[req_key]]
      private$pending_state[[req_key]] <- NULL

      if (is.null(state)) {
        # Handle response without parent request
        if (!is.null(rpc_result$error)) {
          private$log$info("Received error without parent request: %s", rpc_result$error)
        } else {
          tryCatch(
            {
              reader <- BinaryReader$new(rpc_result$body)
              obj <- reader$tgread_object()
              if (!inherits(obj, "upload.File")) {
                private$log$info("Received response without parent request: %s", rpc_result$body)
              }
            },
            error = function(e) {
              private$log$info("Received response without parent request: %s", rpc_result$body)
            }
          )
        }
        trace_log("handle_rpc_result done (no state)")
        return(NULL)
      }

      # Handle error or result
      if (!is.null(rpc_result$error)) {
        error <- rpc_message_to_error(rpc_result$error, state$request)
        private$send_queue$append(
          RequestState$new(MsgsAck$new(list(state$msg_id)))
        )

        if (!future::resolved(state$future)) {
          state$future$set_exception(error)
        }
        trace_log("handle_rpc_result done (error)")
      } else {
        tryCatch(
          {
            trace_log("handle_rpc_result parse start")
            reader <- BinaryReader$new(rpc_result$body)
            # Some generated request classes currently do not inherit TLRequest
            # and may miss read_result(); fall back to generic TL object parsing.
            if (is.function(state$request$read_result)) {
              result <- state$request$read_result(reader)
            } else {
              result <- reader$tgread_object()
            }
            trace_log(sprintf(
              "handle_rpc_result got result class=%s",
              paste(class(result), collapse = ",")
            ))

            # Check for updates in the result
            trace_log("handle_rpc_result store_own_updates start")
            private$store_own_updates(result)
            trace_log("handle_rpc_result store_own_updates done")

            if (!future::resolved(state$future)) {
              trace_log("handle_rpc_result set_result start")
              state$future$set_result(result)
              trace_log("handle_rpc_result set_result done")
            }
            trace_log("handle_rpc_result parse done")
          },
          error = function(e) {
            if (!future::resolved(state$future)) {
              state$future$set_exception(e)
            }
            trace_log(sprintf("handle_rpc_result parse error: %s", conditionMessage(e)))
          }
        )
      }
      trace_log("handle_rpc_result exit")
    },
    handle_container = function(message) {
      private$log$debug("Handling container")
      for (inner_message in message$obj$messages) {
        private$process_message(inner_message)
      }
    },
    handle_gzip_packed = function(message) {
      private$log$debug("Handling gzipped data")
      reader <- BinaryReader$new(message$obj$data)
      message$obj <- reader$tgread_object()
      private$process_message(message)
    },
    handle_update = function(message) {
      tryCatch(
        {
          if (message$obj$SUBCLASS_OF_ID != 0x8af52aac) { # crc32(b'Updates')
            private$log$warning(
              "Note: %s is not an update, not dispatching it %s",
              class(message$obj)[1],
              message$obj
            )
            return(NULL)
          }

          private$log$debug("Handling update %s", class(message$obj)[1])
          private$updates_queue$put_nowait(message$obj)
        },
        error = function(e) {
          private$log$error("Error handling update: %s", e$message)
        }
      )
    },
    store_own_updates = function(obj) {
      # Guard entire method: many Update* and messages.* classes may not exist yet.
      tryCatch(
        {
          ctor <- obj$CONSTRUCTOR_ID
          if (is.null(ctor)) {
            return(invisible(NULL))
          }

          update_ids <- tryCatch(c(
            UpdateShortMessage$CONSTRUCTOR_ID,
            UpdateShortChatMessage$CONSTRUCTOR_ID,
            UpdateShort$CONSTRUCTOR_ID,
            UpdatesCombined$CONSTRUCTOR_ID,
            Updates$CONSTRUCTOR_ID,
            UpdateShortSentMessage$CONSTRUCTOR_ID
          ), error = function(e) numeric(0))

          if (as.numeric(ctor) %in% as.numeric(update_ids)) {
            obj$.self_outgoing <- TRUE
            private$updates_queue$put_nowait(obj)
            return(invisible(NULL))
          }
        },
        error = function(e) {
          # Ignore -- update classes not available
        }
      )
      invisible(NULL)
    },
    handle_pong = function(message) {
      pong <- message$obj
      private$log$debug("Handling pong for message %d", pong$msg_id)
      if (identical(private$ping, pong$ping_id)) {
        private$ping <- NULL
      }

      state <- private$pending_state[[msg_id_key(pong$msg_id)]]
      private$pending_state[[msg_id_key(pong$msg_id)]] <- NULL

      if (!is.null(state)) {
        state$future$set_result(pong)
      }
    },
    handle_bad_server_salt = function(message) {
      dbg_parse <- isTRUE(getOption("telegramR.debug_parse", FALSE))
      log_parse <- function(fmt, ...) if (dbg_parse) message(sprintf(fmt, ...))
      bad_salt <- message$obj
      log_parse(
        "[handle_bad_salt] bad_msg_id=%s, new_salt=%s, pending_keys=%s",
        as.character(bad_salt$bad_msg_id),
        as.character(bad_salt$new_server_salt),
        paste(names(private$pending_state), collapse = ",")
      )
      private$state$salt <- bad_salt$new_server_salt
      states <- private$pop_states(bad_salt$bad_msg_id)
      log_parse("[handle_bad_salt] popped %d state(s)", length(states))
      private$send_queue$extend(states)
    },
    handle_bad_notification = function(message) {
      bad_msg <- message$obj
      message(sprintf(
        "[handle_bad_notification] bad_msg_id=%s, error_code=%s, pending_keys=%s",
        as.character(bad_msg$bad_msg_id),
        as.character(bad_msg$error_code),
        paste(names(private$pending_state), collapse = ",")
      ))
      states <- private$pop_states(bad_msg$bad_msg_id)
      if (bad_msg$error_code %in% c(16, 17)) {
        # Sent msg_id too low or too high (respectively).
        # Use the current msg_id to determine the right time offset.
        to <- private$state$update_time_offset(correct_msg_id = message$msg_id)
        private$log$info("System clock is wrong, set time offset to %ds", to)
      } else if (bad_msg$error_code == 32) {
        # msg_seqno too low, so just pump it up by some "large" amount
        # TODO A better fix would be to start with a new fresh session ID
        private$state$sequence <- private$state$sequence + 64
      } else if (bad_msg$error_code == 33) {
        # msg_seqno too high never seems to happen but just in case
        private$state$sequence <- private$state$sequence - 16
      } else {
        for (state in states) {
          state$future$set_exception(
            BadMessageError$new(state$request, bad_msg$error_code)
          )
        }
        return(NULL)
      }

      # Messages are to be re-sent once we've corrected the issue
      private$send_queue$extend(states)
      private$log$debug("%d messages will be resent due to bad msg", length(states))
    },
    handle_detailed_info = function(message) {
      msg_id <- message$obj$answer_msg_id
      private$log$debug("Handling detailed info for message %d", msg_id)
      private$pending_ack$add(msg_id)
    },
    handle_new_detailed_info = function(message) {
      msg_id <- message$obj$answer_msg_id
      private$log$debug("Handling new detailed info for message %d", msg_id)
      private$pending_ack$add(msg_id)
    },
    handle_new_session_created = function(message) {
      message(sprintf("[handle_new_session] server_salt=%s", as.character(message$obj$server_salt)))
      new_salt <- message$obj$server_salt
      if (!is.null(new_salt) && length(new_salt) >= 1) {
        private$state$salt <- new_salt
      }
    },
    handle_ack = function(message) {
      ack <- message$obj
      private$log$debug("Handling acknowledge for %s", paste(ack$msg_ids, collapse = ", "))
      for (msg_id in ack$msg_ids) {
        state <- private$pending_state[[msg_id_key(msg_id)]]
        if (!is.null(state) && inherits(state$request, "LogOutRequest")) {
          private$pending_state[[msg_id_key(msg_id)]] <- NULL
          if (!future::resolved(state$future)) {
            state$future$set_result(TRUE)
          }
        }
      }
    },

    #  Handle future salts -- store them for proactive salt rotation.
    handle_future_salts = function(message) {
      private$log$debug("Handling future salts for message %d", message$msg_id)

      fs <- message$obj   # FutureSalts R6 object
      if (inherits(fs, "FutureSalts") && is.list(fs$salts) && length(fs$salts) > 0) {
        # Sort salts by valid_since so we can pick the right one efficiently.
        private$future_salts <- fs$salts[order(vapply(
          fs$salts,
          function(s) as.numeric(s$valid_since %||% 0),
          numeric(1)
        ))]
        private$log$debug(
          "Stored %d future salt(s); first valid_since=%s",
          length(private$future_salts),
          as.character(private$future_salts[[1]]$valid_since %||% NA)
        )
        # Apply an immediately-valid salt right now if available.
        private$update_salt_if_needed()
      }

      # Resolve any pending GetFutureSalts request.
      state <- private$pending_state[[msg_id_key(message$msg_id)]]
      private$pending_state[[msg_id_key(message$msg_id)]] <- NULL
      if (!is.null(state)) {
        state$future$set_result(fs)
      }
    },

    #  Rotate private$state$salt to the best currently-valid future salt.
    #  Called before every encrypt_message_data so expired salts are evicted
    #  before the server has to reject them with BadServerSalt.
    update_salt_if_needed = function() {
      if (length(private$future_salts) == 0) return(invisible(NULL))
      # Approximate server time using the locally-tracked offset.
      server_now <- as.numeric(Sys.time()) + (private$state$time_offset %||% 0)
      best <- NULL
      keep <- list()
      for (s in private$future_salts) {
        vs <- as.numeric(s$valid_since  %||% 0)
        vu <- as.numeric(s$valid_until  %||% Inf)
        if (vs <= server_now && server_now <= vu) {
          best <- s
          keep[[length(keep) + 1L]] <- s
        } else if (vs > server_now) {
          # Not yet valid but still in the future -- keep for later.
          keep[[length(keep) + 1L]] <- s
        }
        # Salts whose valid_until is already past are silently discarded.
      }
      private$future_salts <- keep

      if (!is.null(best) && !is.null(best$salt)) {
        new_salt <- best$salt
        if (!identical(private$state$salt, new_salt)) {
          private$log$debug(
            "Salt rotated to future salt %s (valid %s to %s)",
            as.character(new_salt),
            as.character(best$valid_since),
            as.character(best$valid_until)
          )
          private$state$salt <- new_salt
        }
      }
      invisible(NULL)
    },

    #  Handle state forgotten (MsgsStateReq and MsgResendReq)
    handle_state_forgotten = function(message) {
      private$send_queue$append(
        RequestState$new(
          MsgsStateInfo$new(
            req_msg_id = message$msg_id,
            info = paste0(rep("1", length(message$obj$msg_ids)), collapse = "")
          )
        )
      )
    },

    #  Handle MsgsAllInfo
    handle_msg_all = function(message) {
      # Currently does nothing
    },

    #  Handle destroy session responses
    handle_destroy_session = function(message) {
      msg_id <- NULL
      state <- NULL

      for (id in names(private$pending_state)) {
        s <- private$pending_state[[id]]
        if (inherits(s$request, "DestroySessionRequest") &&
          s$request$session_id == message$obj$session_id) {
          msg_id <- id
          state <- s
          break
        }
      }

      if (is.null(msg_id)) {
        return(NULL)
      }

      private$pending_state[[msg_id]] <- NULL
      if (!future::resolved(state$future)) {
        state$future$set_result(message$obj)
      }
    },

    #  Handle destroy auth key responses
    handle_destroy_auth_key = function(message) {
      private$log$debug("Handling destroy auth key %s", message$obj)

      ids_to_process <- character(0)
      for (id in names(private$pending_state)) {
        state <- private$pending_state[[id]]
        if (inherits(state$request, "DestroyAuthKeyRequest")) {
          ids_to_process <- c(ids_to_process, id)
        }
      }

      for (id in ids_to_process) {
        state <- private$pending_state[[id]]
        private$pending_state[[id]] <- NULL
        if (!future::resolved(state$future)) {
          state$future$set_result(message$obj)
        }
      }

      # If the auth key has been destroyed, that pretty much means the
      # library can't continue as our auth key will no longer be found
      # on the server.
      # Even if the library didn't disconnect, the server would (and then
      # the library would reconnect and learn about auth key being invalid).
      if (inherits(message$obj, "DestroyAuthKeyOk")) {
        future::value(private$disconnect(error = AuthKeyNotFound$new()))
      }
    }
  )
)
