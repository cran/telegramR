#  @title RequestState
#  @description Holds information relevant to sent messages, including the message ID assigned to the request,
#  the container ID to which it belongs, the request itself, the request as raw bytes, and a future result.
#  @export
#  @noRd
#  @noRd
RequestState <- R6::R6Class("RequestState",
  public = list(
    #  @field container_id Field.
    container_id = NULL,
    #  @field msg_id Field.
    msg_id = NULL,
    #  @field request Field.
    request = NULL,
    #  @field data Field.
    data = NULL,
    #  @field future Field.
    future = NULL,
    #  @field after Field.
    after = NULL,

    #  @description Creates a new RequestState instance.
    #  @param request The request object.
    #  @param after Optional additional parameter. Defaults to NULL.
    initialize = function(request, after = NULL) {
      if (is.null(request)) {
        stop("argument \"request\" is missing, with no default")
      }
      self$container_id <- NULL
      self$msg_id <- NULL
      self$request <- request
      if (is.character(request)) {
        self$data <- charToRaw(request)
      } else if (is.raw(request)) {
        self$data <- request
      } else {
        # Serialize TL objects using available binary methods, tolerating
        # partially generated classes where one method exists but fails.
        serializers <- list(
          function(x) if (is.function(x$to_raw)) x$to_raw() else NULL,
          function(x) if (is.function(x$to_bytes)) x$to_bytes() else NULL,
          function(x) if (is.function(x$bytes)) x$bytes() else NULL,
          function(x) if (is.function(x$.bytes)) x$.bytes() else NULL
        )

        raw_out <- NULL
        last_err <- NULL
        for (fn in serializers) {
          candidate <- tryCatch(fn(request), error = function(e) {
            last_err <<- e
            NULL
          })
          if (is.raw(candidate) && length(candidate) > 0) {
            raw_out <- candidate
            break
          }
        }

        if (is.null(raw_out)) {
          # If this looks like a TL object/request, do not fall back to R serialize(),
          # which can produce oversized payloads that Telegram rejects.
          is_tl <- inherits(request, "TLObject") ||
            !is.null(request$CONSTRUCTOR_ID) ||
            isTRUE(grepl("Request$", class(request)[1]))
          if (is_tl && !is.null(last_err)) {
            stop(last_err)
          }
          # Keep backward compatibility for arbitrary objects stored as requests.
          raw_out <- serialize(request, NULL)
        }
        self$data <- raw_out
      }
      # Create a lightweight future-like holder without spawning futures.
      f <- new.env(parent = emptyenv())
      f$.__req_done__ <- FALSE
      f$.__req_value__ <- NULL
      f$.__req_error__ <- NULL
      f$set_result <- function(value) {
        f$.__req_value__ <<- value
        f$.__req_error__ <<- NULL
        f$.__req_done__ <<- TRUE
        promises::promise_resolve(TRUE)
      }
      f$set_exception <- function(error) {
        f$.__req_error__ <<- error
        f$.__req_done__ <<- TRUE
        promises::promise_resolve(TRUE)
      }
      f$cancel <- function() {
        f$.__req_error__ <<- simpleError("Cancelled")
        f$.__req_done__ <<- TRUE
        promises::promise_resolve(TRUE)
      }
      class(f) <- "RequestFuture"
      self$future <- f
      self$after <- after
    }
  )
)

#  @exportS3Method future::value
value.RequestFuture <- function(x, ...) {
  done <- isTRUE(x$.__req_done__)
  started_at <- proc.time()[["elapsed"]]
  timeout_sec <- as.numeric(getOption("telegramR.promise_timeout", 30))

  while (!done) {
    elapsed <- proc.time()[["elapsed"]] - started_at
    if (is.finite(timeout_sec) && timeout_sec > 0 && elapsed > timeout_sec) {
      stop(sprintf("PromiseTimeoutError: timed out after %.1f seconds", timeout_sec))
    }
    if (requireNamespace("later", quietly = TRUE)) {
      later::run_now(timeout = 0.05)
    } else {
      Sys.sleep(0.05)
    }
    done <- isTRUE(x$.__req_done__)
  }

  if (!is.null(x$.__req_error__)) {
    stop(x$.__req_error__)
  }
  x$.__req_value__
}

#' @exportS3Method future::resolved
resolved.RequestFuture <- function(x, ...) {
  isTRUE(x$.__req_done__)
}
