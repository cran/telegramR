.MAX_CHUNK_SIZE <- 100


#  MessagesIter R6 class
# 
#  Iterator over messages with support for search, filters, reply threads,
#  scheduled history, ranges (min_id/max_id), and reverse iteration.
#  This is a translation of the original async RequestIter-based logic into R6.
#  It delegates fetching to the provided client via iter_messages().
# 
#  @title MessagesIter
#  @description Telegram API type MessagesIter
#  @export
#  @noRd
#  @noRd
MessagesIter <- R6::R6Class(
  "MessagesIter",
  public = list(
    #  @field client Client used to perform requests
    client = NULL,
    #  @field entity_input Input entity (resolved via client get_input_entity if available)
    entity_input = NULL,
    #  @field is_global Whether this is a global search (entity is NULL)
    is_global = FALSE,
    #  @field reverse Whether to iterate in reverse
    reverse = FALSE,
    #  @field limit Hard limit of messages to retrieve
    limit = Inf,
    #  @field left Remaining messages to retrieve
    left = Inf,
    #  @field wait_time Optional per-request wait time (seconds)
    wait_time = NULL,
    #  @field add_offset Add offset used by server requests
    add_offset = 0L,
    #  @field max_id Upper bound for message id (exclusive)
    max_id = Inf,
    #  @field min_id Lower bound for message id (exclusive)
    min_id = 0L,
    #  @field last_id Last seen message id (used to avoid duplicates/order issues)
    last_id = Inf,
    #  @field total Total messages reported by the server (when available)
    total = 0L,
    #  @field request Request parameters tracked between chunks
    request = NULL,
    #  @field buffer Internal buffer of fetched messages
    buffer = list(),
    #  @field exhausted Exhausted flag
    exhausted = FALSE,
    #  @field from_id From-user peer id for local filtering when needed
    from_id = NULL,
    #  @field search Optional search query
    search = NULL,
    #  @field filter Optional filter object
    filter = NULL,
    #  @field reply_to Optional reply thread id
    reply_to = NULL,
    #  @field offset_date Optional offset date
    offset_date = NULL,

    #  @description Initialize the iterator with query parameters.
    # 
    #  @param client Telegram client object that provides iter_messages(), collect(), collect_one().
    #  @param entity Optional entity to iterate (NULL for global search).
    #  @param offset_id Integer offset id start.
    #  @param min_id Integer minimum id (exclusive).
    #  @param max_id Integer maximum id (exclusive).
    #  @param from_user Optional user entity to filter from.
    #  @param offset_date POSIXct or Date to offset by date.
    #  @param add_offset Integer additional offset.
    #  @param filter Optional filter object or constructor.
    #  @param search Optional text query.
    #  @param reply_to Optional message id to iterate replies to.
    #  @param scheduled Logical; if TRUE, scheduled messages history is used.
    #  @param reverse Logical; if TRUE, oldest to newest.
    #  @param wait_time Optional per-request sleep in seconds.
    #  @param limit Integer or Inf, maximum messages to yield.
    initialize = function(client,
                          #  @field entity Field.
                          entity = NULL,
                          offset_id = 0L,
                          min_id = 0L,
                          max_id = 0L,
                          #  @field from_user Field.
                          from_user = NULL,
                          #  @field offset_date Field.
                          offset_date = NULL,
                          add_offset = 0L,
                          #  @field filter Field.
                          filter = NULL,
                          #  @field search Field.
                          search = NULL,
                          #  @field reply_to Field.
                          reply_to = NULL,
                          #  @field scheduled Field.
                          scheduled = FALSE,
                          #  @field reverse Field.
                          reverse = FALSE,
                          #  @field wait_time Field.
                          wait_time = NULL,
                          limit = Inf) {
      self$client <- client
      self$reverse <- isTRUE(reverse)
      self$limit <- if (is.null(limit)) Inf else limit
      self$left <- self$limit
      self$add_offset <- as.integer(add_offset)
      self$min_id <- as.integer(min_id %||% 0L)
      self$max_id <- if (is.null(max_id) || max_id == 0L) Inf else as.integer(max_id)
      self$offset_date <- offset_date
      self$search <- search
      self$filter <- if (is.null(filter)) NULL else filter
      self$reply_to <- reply_to

      resolve_future <- function(x) {
        if (inherits(x, "Future")) {
          return(future::value(x))
        }
        x
      }

      # Resolve input entity if provided
      if (!is.null(entity) && !is.null(self$client) && !is.null(self$client$get_input_entity)) {
        self$entity_input <- resolve_future(self$client$get_input_entity(entity))
        self$is_global <- FALSE
      } else {
        self$entity_input <- NULL
        self$is_global <- is.null(entity)
      }

      if (self$is_global && self$reverse) {
        stop("Cannot reverse global search")
      }

      off_id <- as.integer(offset_id %||% 0L)

      # Emulate Telethon min/max id quirks locally
      if (self$reverse) {
        off_id <- max(off_id, self$min_id)
      }
      if (off_id != 0L && is.finite(self$max_id)) {
        if ((self$max_id - off_id) <= 1L) {
          self$exhausted <- TRUE
        } else {
          off_id <- max(off_id, self$max_id)
        }
      } else if (!is.finite(self$max_id)) {
        # leave off_id as-is
      }

      if (off_id != 0L && self$min_id != 0L) {
        if ((off_id - self$min_id) <= 1L) {
          self$exhausted <- TRUE
        }
      }

      if (self$reverse) {
        if (off_id != 0L) {
          off_id <- off_id + 1L
        }
      } else if (is.null(self$offset_date)) {
        # offset_id has priority over offset_date
        # Keep 0 to let Telegram return the latest messages.
      }

      # Resolve from_user -> from_id for local validation if needed
      local_from_user <- from_user
      if (!is.null(from_user) && !is.null(self$client) && !is.null(self$client$get_input_entity)) {
        local_from_user <- self$client$get_input_entity(from_user)
      }
      if (!is.null(local_from_user) && !is.null(self$client) && !is.null(self$client$get_peer_id)) {
        self$from_id <- resolve_future(self$client$get_peer_id(local_from_user))
      } else {
        self$from_id <- NULL
      }

      # When global + from_user, treat entity as empty peer (server-side quirk); we emulate via flags
      if (self$is_global && !is.null(local_from_user)) {
        # nothing special needed here beyond tracking flags
      }

      # Determine entity type to decide local vs server-side from_user filtering
      # In private chats, server ignores from_id; keep local filter instead.
      if (!is.null(self$entity_input)) {
        ty <- tryCatch(entity_type(self$entity_input), error = function(e) NULL)
        if (!is.null(ty) && identical(ty, EntityType$USER)) {
          # keep self$from_id for local check, but do not send from_user to server
          local_from_user <- NULL
        } else {
          # let server filter by from_user; disable local check
          if (!is.null(from_user)) self$from_id <- NULL
        }
      }

      # Build "request" parameters we will reuse on each chunk
      self$request <- list(
        type = private$select_request_type(self$is_global, scheduled, !is.null(self$reply_to), !is.null(self$search) || !is.null(self$filter) || !is.null(local_from_user)),
        peer = self$entity_input,
        q = self$search %||% "",
        filter = self$filter,
        max_date = self$offset_date, # for search global
        offset_date = self$offset_date, # for history/replies
        offset_id = off_id,
        add_offset = self$add_offset,
        limit = 1L,
        from_user = local_from_user,
        msg_id = self$reply_to
      )

      # If user asked for 0 items, still try to learn total and finish
      if (is.finite(self$limit) && self$limit <= 0) {
        private$prime_total_count()
        self$exhausted <- TRUE
      }

      # Heuristic wait to avoid flood waits
      if (is.null(wait_time)) {
        self$wait_time <- if (is.finite(self$limit) && self$limit > 3000) 1 else 0
      } else {
        self$wait_time <- wait_time
      }

      # Reverse iteration needs negative add_offset in Telethon; emulate by shifting
      if (self$reverse) {
        self$request$add_offset <- self$request$add_offset - private$max_chunk_size
      }

      self$last_id <- if (self$reverse) 0L else Inf
    },

    #  Load next chunk
    # 
    #  Fetches the next chunk of messages and appends them to the internal buffer.
    # 
    #  @return A list of messages for this chunk or NULL if exhausted.
    load_next_chunk = function() {
      if (self$exhausted) {
        return(NULL)
      }
      if (!is.null(self$wait_time) && self$wait_time > 0) Sys.sleep(self$wait_time)

      n <- if (is.finite(self$left)) min(self$left, private$max_chunk_size) else private$max_chunk_size
      if (n <= 0) {
        self$exhausted <- TRUE
        return(NULL)
      }

      # Adjust add_offset for reverse if the last request had a smaller limit
      req_add_offset <- self$request$add_offset
      if (self$reverse && n != private$max_chunk_size) {
        req_add_offset <- self$add_offset - n
      }

      # Delegate fetching to client$iter_messages_page() when available,
      # otherwise fall back to client$iter_messages() + collect().
      res <- NULL
      if (!is.null(self$client) && !is.null(self$client$iter_messages_page)) {
        res <- tryCatch(
          self$client$iter_messages_page(
            entity = self$entity_input,
            limit = n,
            offset_date = self$request$offset_date,
            offset_id = self$request$offset_id,
            max_id = if (is.finite(self$max_id)) self$max_id else 0L,
            min_id = if (self$min_id > 0L) self$min_id else 0L,
            add_offset = req_add_offset,
            search = self$search,
            filter = self$filter,
            from_user = self$request$from_user,
            reverse = self$reverse,
            reply_to = self$reply_to,
            scheduled = (!is.null(self$request$type) && self$request$type == "scheduled")
          ),
          error = function(e) e
        )
      } else if (!is.null(self$client) && !is.null(self$client$iter_messages) && !is.null(self$client$collect)) {
        it <- self$client$iter_messages(
          entity = self$entity_input,
          limit = n,
          offset_date = self$request$offset_date,
          offset_id = self$request$offset_id,
          max_id = if (is.finite(self$max_id)) self$max_id else 0L,
          min_id = if (self$min_id > 0L) self$min_id else 0L,
          add_offset = req_add_offset,
          search = self$search,
          filter = self$filter,
          from_user = self$request$from_user,
          ids = NULL,
          reverse = self$reverse,
          reply_to = self$reply_to,
          scheduled = (!is.null(self$request$type) && self$request$type == "scheduled")
        )
        res <- tryCatch(self$client$collect(it), error = function(e) e)
      } else {
        stop("Client must provide iter_messages_page() or iter_messages()+collect() to use MessagesIter.")
      }
      if (inherits(res, "error")) {
        # On errors, mark exhausted to avoid loops
        self$exhausted <- TRUE
        return(NULL)
      }

      msgs <- res
      if (!length(msgs)) {
        self$exhausted <- TRUE
        return(NULL)
      }

      out <- list()
      for (m in msgs) {
        # Skip empties and enforce from_id locally when needed
        mid <- tryCatch(m$id, error = function(e) NULL)
        if (is.null(mid)) next

        sender_id <- tryCatch(m$sender_id, error = function(e) NULL)
        if (!is.null(self$from_id) && !is.null(sender_id) && !identical(sender_id, self$from_id)) {
          next
        }

        if (!private$message_in_range(m)) {
          # Stop iteration when leaving the range
          self$exhausted <- TRUE
          break
        }

        self$last_id <- mid
        out[[length(out) + 1L]] <- m
      }

      if (!length(out)) {
        self$exhausted <- TRUE
        return(NULL)
      }

      # Update offsets for next request
      private$update_offset(out[[length(out)]])

      # Update counters
      if (is.finite(self$left)) {
        self$left <- max(0, self$left - length(out))
        if (self$left == 0) self$exhausted <- TRUE
      }
      self$buffer <- c(self$buffer, out)
      out
    },

    #  Check if there are more items to retrieve
    # 
    #  @return logical indicating whether there are more items to fetch or buffered.
    has_next = function() {
      if (length(self$buffer) > 0) {
        return(TRUE)
      }
      if (!self$exhausted) {
        return(TRUE)
      }
      FALSE
    },

    #  Collect all remaining messages into a list.
    collect = function() {
      out <- list()
      repeat {
        item <- self$.next()
        if (is.null(item)) break
        out[[length(out) + 1L]] <- item
      }
      out
    },

    #  Get the next item, fetching more if needed
    # 
    #  @return A single message object or NULL if exhausted.
    .next = function() {
      if (length(self$buffer) == 0) {
        chunk <- self$load_next_chunk()
        if (is.null(chunk) || length(chunk) == 0) {
          return(NULL)
        }
      }
      item <- self$buffer[[1]]
      if (length(self$buffer) > 1) {
        self$buffer <- self$buffer[-1]
      } else {
        self$buffer <- list()
      }
      item
    }
  ),
  private = list(
    max_chunk_size = 100L,
    select_request_type = function(is_global, scheduled, is_replies, is_search_like) {
      if (is_global) {
        return("search_global")
      }
      if (isTRUE(scheduled)) {
        return("scheduled")
      }
      if (isTRUE(is_replies)) {
        return("replies")
      }
      if (isTRUE(is_search_like)) {
        return("search")
      }
      "history"
    },
    prime_total_count = function() {
      # Best effort: try to fetch 1 item to learn total via client
      if (self$exhausted) {
        return(invisible(NULL))
      }
      if (is.null(self$client) || is.null(self$client$iter_messages) || is.null(self$client$collect)) {
        return(invisible(NULL))
      }
      it <- self$client$iter_messages(
        entity = self$entity_input,
        limit = 1L,
        offset_date = self$request$offset_date,
        offset_id = self$request$offset_id,
        max_id = if (is.finite(self$max_id)) self$max_id else 0L,
        min_id = if (self$min_id > 0L) self$min_id else 0L,
        add_offset = self$request$add_offset,
        search = self$search,
        filter = self$filter,
        from_user = self$request$from_user,
        ids = NULL,
        reverse = self$reverse,
        reply_to = self$reply_to,
        scheduled = (!is.null(self$request$type) && self$request$type == "scheduled")
      )
      res <- tryCatch(self$client$collect(it), error = function(e) NULL)
      if (is.list(res)) {
        self$total <- length(res)
      }
      invisible(NULL)
    },
    message_in_range = function(message) {
      mid <- tryCatch(message$id, error = function(e) NULL)
      if (is.null(mid)) {
        return(FALSE)
      }

      if (!is.null(self$entity_input)) {
        if (self$reverse) {
          if (mid <= self$last_id || mid >= self$max_id) {
            return(FALSE)
          }
        } else {
          if (mid >= self$last_id || mid <= self$min_id) {
            return(FALSE)
          }
        }
      }
      TRUE
    },
    update_offset = function(last_message) {
      mid <- tryCatch(last_message$id, error = function(e) NULL)
      if (is.null(mid)) {
        return(invisible(NULL))
      }

      self$request$offset_id <- mid
      if (self$reverse) {
        # Skip the one we already have
        self$request$offset_id <- self$request$offset_id + 1L
      }

      # When using date offsets, keep them updated if available
      ldate <- tryCatch(last_message$date, error = function(e) NULL)
      if (!is.null(ldate)) {
        if (!is.null(self$request) && !is.null(self$request$type)) {
          if (self$request$type %in% c("history", "search_global", "replies")) {
            self$request$offset_date <- ldate
            # For search requests that might have used max_date, clear it after first page
            self$request$max_date <- NULL
          }
        }
      }
      invisible(NULL)
    }
  )
)

`%||%` <- function(a, b) if (is.null(a)) b else a


#  IDsIter R6 class
# 
#  Iterator over explicit message IDs, fetching results in chunks.
#  It optionally validates that returned messages belong to a given entity.
# 
#  @section Initialization:
#  it <- IDsIter$new(client, entity = NULL, ids, reverse = FALSE, wait_time = NULL, limit = Inf)
# 
#  @title IDsIter
#  @description Telegram API type IDsIter
#  @export
#  @noRd
#  @noRd
IDsIter <- R6::R6Class(
  "IDsIter",
  public = list(
    #  @field client Client used to perform requests
    client = NULL,
    #  @field entity_input Input entity (resolved via client get_input_entity if available)
    entity_input = NULL,
    #  @field entity_type Entity type as reported by the client (e.g., CHANNEL)
    entity_type = NULL,
    #  @field ids Vector of IDs to fetch (possibly reversed)
    ids = NULL,
    #  @field offset Current offset over ids
    offset = 0L,
    #  @field reverse Whether to iterate in reverse order
    reverse = FALSE,
    #  @field wait_time Optional per-request wait time in seconds
    wait_time = NULL,
    #  @field limit Hard limit on how many items to consider
    limit = Inf,
    #  @field total Total number of requested ids
    total = 0L,
    #  @field buffer Internal buffer of fetched items aligned with requested ids
    buffer = list(),

    #  @description Initialize the iterator
    # 
    #  @param client Telegram client object.
    #  @param entity Optional entity to validate messages against (can be NULL).
    #  @param ids Integer vector of message IDs to fetch.
    #  @param reverse logical. If TRUE, process ids in reverse order.
    #  @param wait_time numeric or NULL. If NULL, set heuristically based on limit.
    #  @param limit integer or Inf. Used only for wait_time heuristic here.
    initialize = function(client, entity = NULL, ids, reverse = FALSE, wait_time = NULL, limit = Inf) {
      self$client <- client
      self$reverse <- isTRUE(reverse)
      self$ids <- if (self$reverse) rev(as.integer(ids)) else as.integer(ids)
      self$total <- length(self$ids)
      self$offset <- 0L
      self$limit <- limit

      resolve_future <- function(x) {
        if (inherits(x, "Future")) {
          return(future::value(x))
        }
        x
      }

      # Resolve input entity if provided
      if (!is.null(entity) && !is.null(self$client) && !is.null(self$client$get_input_entity)) {
        self$entity_input <- resolve_future(self$client$get_input_entity(entity))
      } else {
        self$entity_input <- entity
      }

      # Determine entity type if possible
      if (!is.null(self$entity_input)) {
        self$entity_type <- tryCatch(entity_type(self$entity_input), error = function(e) NULL)
      }

      # 30s flood wait every 300 messages (3 requests of 100 each, 30 of 10, etc.)
      if (is.null(wait_time)) {
        self$wait_time <- if (is.finite(self$limit) && self$limit > 300) 10 else 0
      } else {
        self$wait_time <- wait_time
      }
    },

    #  Load the next chunk of results into the buffer
    # 
    #  Fetches up to the internal chunk size worth of messages for the next slice of ids.
    # 
    #  @return A list of messages or NULLs aligned with the requested chunk of ids;
    #          NULL if there are no more ids to process.
    load_next_chunk = function() {
      if (self$offset >= length(self$ids)) {
        return(NULL)
      }

      idx_from <- self$offset + 1L
      idx_to <- min(length(self$ids), self$offset + private$max_chunk_size)
      ids_chunk <- self$ids[idx_from:idx_to]
      if (length(ids_chunk) == 0L) {
        return(NULL)
      }
      self$offset <- self$offset + private$max_chunk_size

      # Decide whether to use channel-specific retrieval
      is_channel <- !is.null(self$entity_type) && identical(self$entity_type, EntityType$CHANNEL)

      res <- NULL
      # Try channel-specific method first when applicable
      if (is_channel && !is.null(self$client) && !is.null(self$client$channels_get_messages)) {
        res <- tryCatch(
          self$client$channels_get_messages(self$entity_input, ids_chunk),
          error = function(e) e
        )
      } else if (!is.null(self$client) && !is.null(self$client$get_messages)) {
        res <- tryCatch(
          self$client$get_messages(ids = ids_chunk),
          error = function(e) e
        )
      } else {
        stop("No suitable client method to get messages by ids.")
      }

      # If request failed or returned an error-like object, fill with NULLs
      if (inherits(res, "error")) {
        out <- as.list(rep(NA, length(ids_chunk)))
        out[] <- list(NULL)
        self$buffer <- c(self$buffer, out)
        return(out)
      }

      # Optional "from_id" validation if client can provide a peer for the entity
      from_id <- NULL
      if (!is.null(self$entity_input) && !is.null(self$client) && !is.null(self$client$get_peer)) {
        from_id <- self$client$get_peer(self$entity_input)
      }

      # Extract messages collection from result
      messages <- NULL
      if (is.list(res) && !is.null(res$messages)) {
        messages <- res$messages
      } else {
        messages <- res
      }

      # Build index by id for quick lookup; keep as list for R idioms
      by_id <- new.env(hash = TRUE, parent = emptyenv())
      if (length(messages)) {
        for (msg in messages) {
          msg_id <- tryCatch(msg$id, error = function(e) NULL)
          if (!is.null(msg_id)) {
            assign(as.character(msg_id), msg, envir = by_id)
          }
        }
      }

      out <- vector("list", length(ids_chunk))
      for (i in seq_along(ids_chunk)) {
        k <- as.character(ids_chunk[[i]])
        msg <- if (exists(k, envir = by_id, inherits = FALSE)) get(k, envir = by_id) else NULL

        # Validate that the message belongs to the requested entity if from_id is known
        if (!is.null(from_id) && !is.null(msg)) {
          peer_id <- tryCatch(msg$peer_id, error = function(e) NULL)
          if (!is.null(peer_id) && !identical(peer_id, from_id)) {
            msg <- NULL
          }
        }

        out[[i]] <- msg
      }

      self$buffer <- c(self$buffer, out)
      out
    },

    #  Check if there are more items to retrieve
    # 
    #  @return logical indicating whether there are more items to fetch or buffered.
    has_next = function() {
      length(self$buffer) > 0 || (self$offset < length(self$ids))
    },

    #  Collect all remaining messages into a list.
    collect = function() {
      out <- list()
      repeat {
        item <- self$.next()
        if (is.null(item)) break
        out[[length(out) + 1L]] <- item
      }
      out
    },

    #  Get the next item, fetching more if needed
    # 
    #  @return A single message object or NULL if exhausted.
    .next = function() {
      if (length(self$buffer) == 0) {
        chunk <- self$load_next_chunk()
        if (is.null(chunk) || length(chunk) == 0) {
          return(NULL)
        }
      }
      item <- self$buffer[[1]]
      if (length(self$buffer) > 1) {
        self$buffer <- self$buffer[-1]
      } else {
        self$buffer <- list()
      }
      item
    }
  ),
  private = list(
    # Max messages per chunk/request
    max_chunk_size = 100L
  )
)
