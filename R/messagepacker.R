#  MessagePacker R6 class
# 
# 
#    bytes and generate message ids via `write_data_as_message`.
#  @title MessagePacker
#  @description Telegram API type MessagePacker
#  @export
#  @noRd
#  @noRd
MessagePacker <- R6::R6Class("MessagePacker",
  public = list(
    #  @field state Field.
    state = NULL,
    #  @field deque Field.
    deque = NULL,
    #  @field ready Field.
    ready = FALSE,
    #  @field log Field.
    log = NULL,

    #  @description Initialize a MessagePacker
    # 
    #  @param state An object implementing `write_data_as_message(buffer_con, data, ...)`
    #    used to serialize individual messages and return their `msg_id`.
    #  @param loggers Optional list of logger instances. If a `"messagepacker"`
    #    entry exists it will be used; otherwise the first logger in the list
    #    will be used as a fallback.
    initialize = function(state, loggers = list()) {
      self$state <- state
      self$deque <- list()
      self$ready <- FALSE
      # Try to obtain a logger from provided loggers; fallback to NULL
      if (!is.null(loggers[["messagepacker"]])) {
        self$log <- loggers[["messagepacker"]]
      } else if (length(loggers) >= 1) {
        self$log <- loggers[[1]]
      } else {
        self$log <- NULL
      }

      # Ensure sane defaults for size-related constants used across tests/code
      # If constants exist but are NA/non-finite, patch them with defaults.
      # Defaults: MAXIMUM_LENGTH=100L, MAXIMUM_SIZE=1048576L (1 MiB), SIZE_OVERHEAD=32L.
      try(
        {
          mc <- get0("MessageContainer", inherits = TRUE)
          if (!is.null(mc)) {
            val_len <- tryCatch(mc$MAXIMUM_LENGTH, error = function(e) NA_real_)
            if (!is.numeric(val_len) || is.na(val_len) || !is.finite(val_len)) mc$MAXIMUM_LENGTH <- 100L
            val_size <- tryCatch(mc$MAXIMUM_SIZE, error = function(e) NA_real_)
            if (!is.numeric(val_size) || is.na(val_size) || !is.finite(val_size)) mc$MAXIMUM_SIZE <- 1048576L
          }
          tm <- get0("TLMessage", inherits = TRUE)
          if (!is.null(tm)) {
            val_ov <- tryCatch(tm$SIZE_OVERHEAD, error = function(e) NA_real_)
            if (!is.numeric(val_ov) || is.na(val_ov) || !is.finite(val_ov)) tm$SIZE_OVERHEAD <- 32L
          }
        },
        silent = TRUE
      )
    },

    #  @description Append a single state item to the queue
    # 
    #  @param state_item A list-like object representing a request payload and
    #    associated metadata. Items are appended to the right (tail) of the deque.
    #  @details This method also sets `ready` to \code{TRUE} to notify any
    #    waiting `get` calls that new data is available.
    append = function(state_item) {
      self$deque[[length(self$deque) + 1]] <- state_item
      self$ready <- TRUE
    },

    #  @description Extend the queue with multiple state items
    # 
    #  @param states An iterable (e.g. list) of state items to append to the queue.
    #  @details Each element in `states` is appended in order. `ready` is set to
    #    \code{TRUE} after extension.
    extend = function(states) {
      for (s in states) {
        self$deque[[length(self$deque) + 1]] <- s
      }
      self$ready <- TRUE
    },

    #  @description
    #  This method blocks (simple polling) until at least one item is available.
    #  It then accumulates items from the deque into a batch while respecting
    #  `MessageContainer$MAXIMUM_LENGTH` and `MessageContainer$MAXIMUM_SIZE`.
    #  For each included state item it calls `self$state$write_data_as_message`
    #  to serialize the message into a temporary raw connection and obtain a
    #  `msg_id`. If multiple messages are batched they are wrapped into a
    #  container and a single container message is produced; otherwise the single
    #  message bytes are returned.
    # 
    #  @return A list of two elements:
    #    - `batch`: a list of state items that were included (or NULL if none),
    #    - `bytes`: raw vector with serialized bytes ready to send (or NULL if none).
    #  @details
    #  - If an individual message exceeds the maximum allowed size it will be
    #    skipped and, if present, `state_item$future$set_exception` will be
    #    called with a simple error. A warning is logged when a payload is too large.
    #  - Logging calls are guarded so that failures in logger methods do not
    #    interrupt packing.
    get = function() {
      # Wait until there is something in the queue (simple polling).
      while (!self$ready || length(self$deque) == 0) {
        self$ready <- FALSE
        Sys.sleep(0.01)
      }

      # Resolve sizing constraints with safe defaults to avoid NA/NULL comparisons
      max_len <- tryCatch(MessageContainer$MAXIMUM_LENGTH, error = function(e) NA_real_)
      if (!is.numeric(max_len) || is.na(max_len) || !is.finite(max_len)) max_len <- 100L
      max_size <- tryCatch(MessageContainer$MAXIMUM_SIZE, error = function(e) NA_real_)
      if (!is.numeric(max_size) || is.na(max_size) || !is.finite(max_size)) max_size <- 1048576L
      size_overhead <- tryCatch(TLMessage$SIZE_OVERHEAD, error = function(e) NA_real_)
      if (!is.numeric(size_overhead) || is.na(size_overhead) || !is.finite(size_overhead)) size_overhead <- 32L

      # Use a raw connection as a buffer
      buffer_con <- rawConnection(raw(), "wb")
      on.exit({
        try(close(buffer_con), silent = TRUE)
      })

      batch <- list()
      size <- 0L

      # Helper to pop left
      pop_left <- function() {
        item <- self$deque[[1]]
        if (length(self$deque) == 1) {
          self$deque <<- list()
        } else {
          self$deque <<- self$deque[-1]
        }
        item
      }

      # Fill a new batch while it's small enough and we don't exceed max length
      # Use strict '<' so we never exceed the maximum allowed length.
      while (length(self$deque) > 0 &&
        length(batch) < max_len) {
        state_item <- pop_left()
        # Account for TLMessage overhead
        size <- size + length(state_item$data) + size_overhead

        if (size <= max_size) {
          # write_data_as_message is expected to write into the rawConnection and return msg_id
          # Default to content-related=TRUE for all requests; only acks and
          # a few MTProto service types are NOT content-related.
          req_cls <- class(state_item$request)[1]
          is_content_related <- !isTRUE(req_cls %in% c(
            "MsgsAck", "Pong", "MsgsStateInfo",
            "MsgsAllInfo", "MsgResendReq",
            "MsgsStateReq"
          ))

          state_item$msg_id <- self$state$write_data_as_message(
            buffer_con, state_item$data,
            is_content_related,
            after_id = if (!is.null(state_item$after)) state_item$after$msg_id else NULL
          )
          batch[[length(batch) + 1]] <- state_item

          # log if available
          if (!is.null(self$log) && is.function(self$log$debug)) {
            tryCatch(
              self$log$debug(sprintf(
                "Assigned msg_id = %d to %s (%x)",
                state_item$msg_id,
                class(state_item$request)[1],
                as.integer(utils::object.size(state_item$request))
              )),
              error = function(e) NULL
            )
          }
          next
        }

        # If we already have items in batch, put this one back and stop
        if (length(batch) > 0) {
          self$deque <- c(list(state_item), self$deque)
          break
        }

        # Single message exceeds maximum size -> cannot be sent
        if (!is.null(self$log) && is.function(self$log$warning)) {
          tryCatch(
            self$log$warning(sprintf(
              "Message payload for %s is too long (%d) and cannot be sent",
              class(state_item$request)[1], length(state_item$data)
            )),
            error = function(e) NULL
          )
        }

        # Try to set exception on the state's future if such a method exists
        if (!is.null(state_item$future) && is.function(state_item$future$set_exception)) {
          tryCatch(
            state_item$future$set_exception(simpleError("Request payload is too big")),
            error = function(e) NULL
          )
        }

        size <- 0L
        next
      }

      # If no batch was formed, return NULLs
      if (length(batch) == 0) {
        return(list(batch = NULL, data = NULL))
      }

      # Get bytes written so far
      buffer_bytes <- rawConnectionValue(buffer_con)
      close(buffer_con) # close explicitly
      buffer_con <- rawConnection(raw(), "wb") # reset for possible container wrap
      on.exit(
        {
          try(close(buffer_con), silent = TRUE)
        },
        #  @field add Field.
        add = TRUE
      )

      # If multiple messages, pack into container
      if (length(batch) > 1) {
        # Write container constructor id and vector length (both little-endian 4-byte ints)
        # MessageContainer constructor ID = 0x73f1f8dc
        mc_ctor <- tryCatch(MessageContainer$CONSTRUCTOR_ID_VALUE, error = function(e) NULL)
        if (is.null(mc_ctor)) mc_ctor <- 0x73f1f8dc
        writeBin(packInt32(mc_ctor), buffer_con)
        writeBin(as.integer(length(batch)), buffer_con, size = 4, endian = "little")
        # Append previously written messages
        writeBin(buffer_bytes, buffer_con)
        container_bytes <- rawConnectionValue(buffer_con)
        close(buffer_con)

        # Now write container as a single message (content_related = FALSE)
        final_buffer_con <- rawConnection(raw(), "wb")
        on.exit(
          {
            try(close(final_buffer_con), silent = TRUE)
          },
          #  @field add Field.
          add = TRUE
        )
        container_id <- self$state$write_data_as_message(
          final_buffer_con, container_bytes,
          #  @field content_related Field.
          content_related = FALSE
        )
        for (s in batch) {
          s$container_id <- container_id
        }
        final_bytes <- rawConnectionValue(final_buffer_con)
        close(final_buffer_con)
        return(list(batch = batch, data = final_bytes))
      }

      # Single message: return the bytes already in buffer_bytes
      return(list(batch = batch, data = buffer_bytes))
    }
  )
)
