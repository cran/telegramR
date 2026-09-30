#  Import required packages
NULL

#  Constants
.MAX_CHUNK_SIZE <- 100

#' Helper function to get dialog message key
#' @param peer The peer object
#' @param message_id The message ID
#' @return A list containing the channel ID and message ID
#' @noRd
dialog_message_key <- function(peer, message_id) {
  # Get the key to get messages from a dialog.
  #
  # We cannot just use the message ID because channels share message IDs,
  # and the peer ID is required to distinguish between them. But it is not
  # necessary in small group chats and private chats.

  channel_id <- if (inherits(peer, "PeerChannel")) peer$channel_id else NULL
  return(list(channel_id = channel_id, message_id = message_id))
}

#' DialogsIter class
#'
#'
#' @details
#' This class is used to iterate over Telegram dialogs (open conversations/subscribed channels).
#' The order is the same as the one seen in official applications (first pinned, then from those with the most recent message to those with the oldest message).
#'
#' @title DialogsIter
#' @description Telegram API type DialogsIter
#' Marked peer id (Telethon convention: users positive, chats -id,
#' channels -100xxxxxxxxxx) for entities, hand-parsed chats and Peer objects.
#' @noRd
.telegramR_marked_id <- function(x) {
  num <- function(v) as.numeric(as.character(v))
  if (inherits(x, "PeerUser")) return(num(x$user_id))
  if (inherits(x, "PeerChat")) return(-num(x$chat_id))
  if (inherits(x, "PeerChannel")) return(-(1e12 + num(x$channel_id)))
  if (inherits(x, c("User", "UserEmpty"))) return(num(x$id))
  if (inherits(x, c("Chat", "ChatEmpty", "ChatForbidden"))) return(-num(x$id))
  if (inherits(x, c("Channel", "ChannelForbidden"))) return(-(1e12 + num(x$id)))
  tryCatch(as.numeric(get_peer_id(x)), error = function(e) NULL)
}

DialogsIter <- R6::R6Class("DialogsIter",
  inherit = RequestIter,
  public = list(
    request = NULL,
    seen = NULL,
    offset_date = NULL,
    ignore_migrated = NULL,
    exhausted = FALSE,

    initialize = function(client, limit, offset_date = NULL, offset_id = 0,
                          offset_peer = InputPeerEmpty$new(), ignore_pinned = FALSE,
                          ignore_migrated = FALSE, folder = NULL) {
      super$initialize(client, limit)
      self$request <- GetDialogsRequest$new(
        offsetDate = offset_date,
        offsetId = as.integer(offset_id %||% 0),
        offsetPeer = offset_peer %||% InputPeerEmpty$new(),
        limit = 1L,
        hash = 0,
        excludePinned = isTRUE(ignore_pinned),
        folderId = folder
      )
      self$seen <- character(0)
      self$buffer <- list()
      self$offset_date <- offset_date
      self$ignore_migrated <- isTRUE(ignore_migrated)
    },

    # Kept for API compatibility: initialisation is synchronous now.
    get_init_future = function() {
      future::future(NULL)
    },

    async_init = function(...) {
      if (self$limit <= 0) {
        r <- private$invoke(self$request)
        self$total <- r$count %||% length(r$dialogs)
        return(TRUE)
      }
      FALSE
    },

    # Loads one page of dialogs into self$buffer. Returns TRUE on the last page.
    load_next_chunk = function() {
      if (self$exhausted) {
        return(TRUE)
      }
      self$request$limit <- as.integer(min(self$left, .MAX_CHUNK_SIZE))
      r <- private$invoke(self$request)
      if (is.null(r$dialogs)) {
        self$exhausted <- TRUE
        return(TRUE)
      }
      self$total <- r$count %||% length(r$dialogs)

      entities <- list()
      for (x in c(r$users, r$chats)) {
        if (inherits(x, c("UserEmpty", "ChatEmpty"))) next
        id <- .telegramR_marked_id(x)
        if (!is.null(id)) entities[[sprintf("%.0f", id)]] <- x
      }
      cache <- tryCatch(self$client$.__enclos_env__$private$mb_entity_cache, error = function(e) NULL)
      if (!is.null(cache) && is.function(cache$extend)) {
        tryCatch(cache$extend(r$users, r$chats), error = function(e) NULL)
      }

      messages <- list()
      for (m in r$messages) {
        pid <- .telegramR_marked_id(m$peer_id)
        mid <- tryCatch(m$id, error = function(e) NULL)
        if (!is.null(pid) && !is.null(mid)) messages[[sprintf("%.0f_%s", pid, mid)]] <- m
      }

      added <- 0L
      last_message <- NULL
      for (d in r$dialogs) {
        pid <- .telegramR_marked_id(d$peer)
        if (is.null(pid)) next
        message <- messages[[sprintf("%.0f_%s", pid, d$top_message)]]
        if (!is.null(message)) last_message <- message
        if (!is.null(self$offset_date)) {
          mdate <- tryCatch(as.numeric(message$date), error = function(e) NULL)
          if (is.null(mdate) || mdate > as.numeric(as.POSIXct(self$offset_date))) next
        }
        key <- sprintf("%.0f", pid)
        if (key %in% self$seen) next
        self$seen <- c(self$seen, key)
        entity <- entities[[key]]
        if (is.null(entity)) next
        if (self$ignore_migrated && !is.null(tryCatch(entity$migrated_to, error = function(e) NULL))) next
        self$buffer <- c(self$buffer, list(.telegramR_make_dialog(d, entity, message)))
        added <- added + 1L
      }

      # Telegram may return more dialogs than requested (pinned ones are
      # added on top); never hand back more than the caller's limit.
      if (is.finite(self$left) && length(self$buffer) > self$left) {
        self$buffer <- self$buffer[seq_len(self$left)]
        self$exhausted <- TRUE
        return(TRUE)
      }

      if (added == 0L || length(r$dialogs) < self$request$limit || !inherits(r, "messages.DialogsSlice")) {
        self$exhausted <- TRUE
        return(TRUE)
      }

      # Prepare the next page from the last dialog/message we saw.
      self$request$excludePinned <- TRUE
      self$request$offsetId <- as.integer(if (!is.null(last_message)) last_message$id else 0L)
      self$request$offsetDate <- if (!is.null(last_message)) last_message$date else NULL
      last <- self$buffer[[length(self$buffer)]]
      self$request$offsetPeer <- last$input_entity %||% InputPeerEmpty$new()
      NULL
    }
  ),
  private = list(
    invoke = function(req) {
      res <- if (is.function(self$client$invoke)) self$client$invoke(req) else self$client$call(req)
      await(res)
    }
  )
)

# A plain, printable summary of one dialog (the counterpart of Telethon's
# custom.Dialog): the raw Dialog, the resolved entity and its last message.
.telegramR_make_dialog <- function(dialog, entity, message = NULL) {
  is_user <- inherits(entity, "User")
  is_channel <- inherits(entity, c("Channel", "ChannelForbidden"))
  is_group <- inherits(entity, c("Chat", "ChatForbidden")) ||
    (is_channel && isTRUE(tryCatch(entity$megagroup, error = function(e) FALSE)))
  name <- tryCatch(get_display_name(entity), error = function(e) NULL)
  if (is.null(name) || !nzchar(name)) {
    name <- entity$title %||% paste(c(entity$first_name, entity$last_name), collapse = " ")
  }
  structure(list(
    name = name,
    id = .telegramR_marked_id(entity) %||% NA,
    entity = entity,
    input_entity = tryCatch(get_input_peer(entity), error = function(e) NULL),
    message = message,
    date = tryCatch(as.POSIXct(as.numeric(message$date), origin = "1970-01-01", tz = "UTC"), error = function(e) as.POSIXct(NA)),
    unread_count = dialog$unread_count,
    unread_mentions_count = dialog$unread_mentions_count,
    pinned = isTRUE(dialog$pinned),
    is_user = is_user,
    is_group = is_group,
    is_channel = is_channel && !is_group,
    dialog = dialog
  ), class = c("telegramR_dialog", "list"))
}

#' @export
print.telegramR_dialog <- function(x, ...) {
  kind <- if (x$is_user) "user" else if (x$is_group) "group" else "channel"
  cat(sprintf("<Dialog %s (%s) id=%s unread=%s>\n", x$name, kind, sprintf("%.0f", as.numeric(x$id)), format(x$unread_count)))
  invisible(x)
}

#' DraftsIter class
#' @title DraftsIter
#' @description Telegram API type DraftsIter
#' @noRd
DraftsIter <- R6::R6Class("DraftsIter",
  inherit = RequestIter,
  public = list(
    entities = NULL,
    initialize = function(client, limit, entities = NULL) {
      super$initialize(client, limit %||% Inf)
      self$entities <- entities
    },

    async_init = function(...) FALSE,

    load_next_chunk = function() {
      if (is.null(self$entities)) {
        r <- private$invoke(GetAllDraftsRequest$new())
        items <- r$updates %||% list()
      } else {
        peers <- list()
        for (entity in self$entities) {
          input_entity <- private$resolve_input(entity)
          peers <- c(peers, list(InputDialogPeer$new(peer = input_entity)))
        }
        r <- private$invoke(GetPeerDialogsRequest$new(peers = peers))
        items <- r$dialogs %||% list()
      }
      entities_dict <- list()
      for (x in c(r$users, r$chats)) {
        id <- tryCatch(get_peer_id(x), error = function(e) NULL)
        if (!is.null(id)) entities_dict[[as.character(id)]] <- x
      }
      for (d in items) {
        peer <- tryCatch(d$peer, error = function(e) NULL)
        draft <- tryCatch(d$draft, error = function(e) NULL)
        ent <- if (!is.null(peer)) entities_dict[[as.character(tryCatch(get_peer_id(peer), error = function(e) NA))]] else NULL
        self$buffer <- c(self$buffer, list(structure(
          list(entity = ent, peer = peer, draft = draft,
               text = tryCatch(draft$message, error = function(e) NULL)),
          class = c("telegramR_draft", "list")
        )))
      }
      TRUE
    },

    # Retained for API compatibility with get_drafts().
    get_init_future = function() future::future(NULL)
  ),
  private = list(
    resolve_input = function(x) {
      r <- if (is.function(self$client$get_input_entity)) self$client$get_input_entity(x) else x
      if (inherits(r, c("Future", "promise"))) r <- await(r)
      r
    },
    invoke = function(req) {
      res <- if (is.function(self$client$invoke)) self$client$invoke(req) else self$client$call(req)
      await(res)
    }
  )
)

#' @export
print.telegramR_draft <- function(x, ...) {
  nm <- tryCatch(get_display_name(x$entity), error = function(e) "")
  cat(sprintf("<Draft to %s: %s>\n", if (nzchar(nm)) nm else "?", substr(x$text %||% "", 1, 60)))
  invisible(x)
}

