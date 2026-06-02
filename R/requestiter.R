#  @title RequestIter
#  @description
#  Helper class to deal with requests that need offsets to iterate.
#  Provides facilities such as sleeping between requests and handling limits.
#  @export
#  @noRd
#  @noRd
RequestIter <- R6::R6Class(
  "RequestIter",
  public = list(
    #  @field client The client instance used for making requests.
    client = NULL,

    #  @field reverse Whether to reverse the iteration order.
    reverse = FALSE,

    #  @field wait_time Time to wait between requests (in seconds).
    wait_time = NULL,

    #  @field kwargs Additional arguments passed to the iterator.
    kwargs = list(),

    #  @field limit The total number of items to return (default is Inf).
    limit = Inf,

    #  @field left The number of items left to fetch.
    left = Inf,

    #  @field buffer A temporary storage for fetched items.
    buffer = NULL,

    #  @field index The current index in the buffer.
    index = 0,

    #  @field total The total number of items fetched (if applicable).
    total = NULL,

    #  @field last_load The timestamp of the last data load.
    last_load = 0,

    #  @description
    #  Initializes the RequestIter object.
    #  @param client The client instance.
    #  @param limit The total number of items to return (default is Inf).
    #  @param reverse Whether to reverse the iteration order (default is FALSE).
    #  @param wait_time Time to wait between requests (in seconds, default is NULL).
    #  @param ... Additional arguments passed to the iterator.
    initialize = function(client, limit = Inf, reverse = FALSE, wait_time = NULL, ...) {
      self$client <- client
      self$reverse <- reverse
      self$wait_time <- wait_time
      self$kwargs <- list(...)
      self$limit <- max(ifelse(is.null(limit), Inf, limit), 0)
      self$left <- self$limit
    },

    #  @description
    #  Asynchronous initialization (to be overridden by subclasses).
    #  @param ... Additional arguments passed to the initialization.
    #  @return TRUE if this is the last iteration, FALSE otherwise.
    async_init = function(...) {
      stop("async_init must be implemented in a subclass")
    },

    #  @description
    #  Loads the next chunk of data (to be overridden by subclasses).
    #  @return TRUE if this is the last chunk, FALSE otherwise.
    load_next_chunk = function() {
      stop("load_next_chunk must be implemented in a subclass")
    },

    #  @description
    #  Collects all items into a list asynchronously.
    #  @return A list of all items collected.
    collect = function() {
      result <- list()
      while (TRUE) {
        item <- tryCatch(
          {
            self$.next()
          },
          error = function(e) {
            if (inherits(e, "StopIteration") || identical(conditionMessage(e), "StopIteration")) {
              return(NULL)
            }
            stop(e)
          }
        )
        if (is.null(item)) {
          break
        }
        result <- c(result, item)
      }
      return(result)
    },

    #  @description
    #  Returns the next item in the iteration asynchronously.
    #  @return The next item in the iteration.
    .next = function() {
      async_mode <- isTRUE(getOption("telegramR.async", FALSE))
      if (is.null(self$buffer)) {
        self$buffer <- list()
        if (async_mode) {
          future::future({
            if (self$async_init(self$kwargs)) {
              self$left <- length(self$buffer)
            }
          }) %...>% identity()
        } else {
          if (self$async_init(self$kwargs)) {
            self$left <- length(self$buffer)
          }
        }
      }

      if (self$left <= 0) {
        stop(structure(list(message = "StopIteration"), class = c("StopIteration", "error", "condition")))
      }

      if (self$index == length(self$buffer)) {
        if (!is.null(self$wait_time)) {
          Sys.sleep(max(0, self$wait_time - (Sys.time() - self$last_load)))
          self$last_load <- Sys.time()
        }

        self$index <- 0
        self$buffer <- list()
        if (async_mode) {
          future::future({
            if (self$load_next_chunk()) {
              self$left <- length(self$buffer)
            }
          }) %...>% identity()
        } else {
          ok <- tryCatch(
            self$load_next_chunk(),
            error = function(e) {
              if (identical(conditionMessage(e), "load_next_chunk must be implemented in a subclass")) {
                stop(structure(list(message = "StopIteration"), class = c("StopIteration", "error", "condition")))
              }
              stop(e)
            }
          )
          if (isTRUE(ok)) {
            self$left <- length(self$buffer)
          }
        }
      }

      if (length(self$buffer) == 0) {
        self$left <- 0
        return(NULL)
      }

      if (self$index < 0 || (self$index + 1) > length(self$buffer)) {
        stop(sprintf("Iterator buffer index out of range: index=%d buffer_len=%d", self$index, length(self$buffer)))
      }
      if (self$index < 0 || (self$index + 1) > length(self$buffer)) {
        stop(sprintf("Iterator buffer index out of range: index=%d buffer_len=%d", self$index, length(self$buffer)))
      }
      result <- self$buffer[[self$index + 1]]
      self$left <- self$left - 1
      self$index <- self$index + 1
      return(result)
    },

    #  @description
    #  Resets the iterator to its initial state.
    reset = function() {
      self$buffer <- NULL
      self$index <- 0
      self$last_load <- 0
      self$left <- self$limit
    }
  )
)
