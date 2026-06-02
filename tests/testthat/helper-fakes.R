make_fake_iter <- function(items) {
  i <- 0L
  list(
    .next = function() {
      i <<- i + 1L
      if (i > length(items)) return(NULL)
      items[[i]]
    }
  )
}

# An iterator that throws an error on specific call numbers.
# throw_on: integer vector of .next() call indices that should stop() instead of returning an item.
# Items are consumed only on non-throwing calls.
make_error_iter <- function(items, throw_on = integer(0),
                            error_msg = "ReadTimeoutError: timed out after 30.0 seconds") {
  call_n  <- 0L
  item_i  <- 0L
  list(
    .next = function() {
      call_n <<- call_n + 1L
      if (call_n %in% throw_on) stop(error_msg)
      item_i <<- item_i + 1L
      if (item_i > length(items)) return(NULL)
      items[[item_i]]
    }
  )
}

# A client whose iter_messages returns a custom iterator and optionally records
# the arguments it was called with (for testing min_id / offset_id pass-through).
make_capturing_client <- function(iter_fn, channel,
                                  full_chat = list(about = "", participants_count = 0,
                                                   linked_chat_id = NA)) {
  env <- new.env(parent = emptyenv())
  env$iter_calls <- list()   # all calls recorded; last is env$iter_calls[[length(env$iter_calls)]]
  client <- list(
    get_entity = function(username) channel,
    get_input_entity = function(ent) ent,
    iter_messages = function(entity, limit = Inf, ...) {
      args <- c(list(entity = entity, limit = limit), list(...))
      env$iter_calls[[length(env$iter_calls) + 1L]] <<- args
      iter_fn()
    },
    iter_participants = function(entity, limit = Inf, ...) make_fake_iter(list()),
    collect = function(it) {
      out <- list()
      repeat { x <- it$.next(); if (is.null(x)) break; out[[length(out) + 1L]] <- x }
      out
    },
    invoke = function(req) list(full_chat = full_chat, chats = list(), users = list()),
    call = function(req) list(peer = PeerChannel$new(channel$id),
                              chats = list(channel), users = list()),
    connect    = function(...) invisible(NULL),
    disconnect = function(...) invisible(NULL),
    .env = env
  )
  class(client) <- "FakeClient"
  client
}

make_fake_client <- function(messages, channel, full_chat = NULL, replies_by_id = NULL, participants = NULL) {
  if (is.null(full_chat)) {
    full_chat <- list(about = "About text", participants_count = 123, linked_chat_id = 456)
  }
  client <- list(
    get_entity = function(username) {
      if (is.numeric(username)) return(channel)
      if (inherits(username, "PeerChannel")) return(channel)
      channel
    },
    get_input_entity = function(ent) ent,
    iter_messages = function(entity, limit = Inf, reply_to = NULL, ...) {
      items <- messages
      if (!is.null(reply_to) && !is.null(replies_by_id)) {
        items <- replies_by_id[[as.character(reply_to)]] %||% list()
      }
      if (is.finite(limit)) {
        items <- items[seq_len(min(length(items), as.integer(limit)))]
      }
      make_fake_iter(items)
    },
    iter_participants = function(entity, limit = Inf, search = "", filter = NULL, aggressive = FALSE) {
      items <- participants %||% list()
      if (is.finite(limit)) {
        items <- items[seq_len(min(length(items), as.integer(limit)))]
      }
      make_fake_iter(items)
    },
    collect = function(it) {
      out <- list()
      repeat {
        x <- it$.next()
        if (is.null(x)) break
        out[[length(out) + 1L]] <- x
      }
      out
    },
    invoke = function(req) {
      list(full_chat = full_chat, chats = list(), users = list())
    },
    call = function(req) {
      # Mock response for ResolveUsernameRequest: return the channel entity
      list(
        peer  = PeerChannel$new(channel$id),
        chats = list(channel),
        users = list()
      )
    },
    connect = function(...) invisible(NULL),
    disconnect = function(...) invisible(NULL)
  )
  class(client) <- "FakeClient"
  client
}
