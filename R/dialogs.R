#  Import required packages
NULL

#  Constants
.MAX_CHUNK_SIZE <- 100

#  Helper function to get dialog message key
#  @param peer The peer object
#  @param message_id The message ID
#  @return A list containing the channel ID and message ID
#  @export
dialog_message_key <- function(peer, message_id) {
  # Get the key to get messages from a dialog.
  #
  # We cannot just use the message ID because channels share message IDs,
  # and the peer ID is required to distinguish between them. But it is not
  # necessary in small group chats and private chats.

  channel_id <- if (inherits(peer, "PeerChannel")) peer$channel_id else NULL
  return(list(channel_id = channel_id, message_id = message_id))
}

#  DialogsIter class
# 
# 
#  @details
#  This class is used to iterate over Telegram dialogs (open conversations/subscribed channels).
#  The order is the same as the one seen in official applications (first pinned, then from those with the most recent message to those with the oldest message).
# 
#  @title DialogsIter
#  @description Telegram API type DialogsIter
#  @export
#  @noRd
#  @noRd
DialogsIter <- R6::R6Class("DialogsIter",
  inherit = RequestIter,
  public = list(
    # Added fields to avoid adding bindings at runtime
    #  @field request Field.
    request = NULL,
    #  @field seen Field.
    seen = NULL,
    #  @field offset_date Field.
    offset_date = NULL,
    #  @field ignore_migrated Field.
    ignore_migrated = NULL,

    #  @description
    #  Constructor for the DialogsIter class.
    #  @param client The Telegram client.
    #  @param limit The maximum number of dialogs to retrieve.
    #  @param offset_date The offset date to be used.
    #  @param offset_id The message ID to be used as an offset.
    #  @param offset_peer The peer to be used as an offset.
    #  @param ignore_pinned Whether pinned dialogs should be ignored or not.
    #  @param ignore_migrated Whether Chat that have "migrated_to" a Channel should be included or not.
    #  @param folder The folder from which the dialogs should be retrieved.
    #  @return A new DialogsIter object.
    #  @export
    initialize = function(client, limit, offset_date = NULL, offset_id = 0,
                          offset_peer = new("InputPeerEmpty"), ignore_pinned = FALSE,
                          ignore_migrated = FALSE, folder = NULL) {
      super$initialize(client, limit)

      # Using a Future (avoid %<-% to bypass global inspection issues)
      private$init_future <- future(
        {
          self$request <- GetDialogsRequest$new(
            offset_date = offset_date,
            offset_id = offset_id,
            offset_peer = offset_peer,
            #  @field limit Field.
            limit = 1,
            #  @field hash Field.
            hash = 0,
            exclude_pinned = ignore_pinned,
            folder_id = folder
          )

          if (self$limit <= 0) {
            # Special case, get a single dialog and determine count
            dialogs <- await(self$client(self$request))
            self$total <- if (!is.null(dialogs$count)) dialogs$count else length(dialogs$dialogs)
            stop("StopAsyncIteration")
          }

          self$seen <- set()
          self$offset_date <- offset_date
          self$ignore_migrated <- ignore_migrated
        },
        globals = FALSE
      )
    },

    #  @description
    #  Loads the next chunk of dialogs.
    #  @return A future that resolves to a list of dialogs.
    load_next_chunk = function() {
      return(
        future({
          self$request$limit <- min(self$left, .MAX_CHUNK_SIZE)
          r <- await(self$client(self$request))

          self$total <- if (!is.null(r$count)) r$count else length(r$dialogs)

          entities <- list()
          all_entities <- c(r$users, r$chats)
          for (x in all_entities) {
            if (!inherits(x, c("UserEmpty", "ChatEmpty"))) {
              entities[[as.character(get_peer_id(x))]] <- x
            }
          }

          self$client$mb_entity_cache$extend(r$users, r$chats)

          messages <- list()
          for (m in r$messages) {
            m$finish_init(self$client, entities, NULL)
            key <- paste0(
              dialog_message_key(m$peer_id, m$id)$channel_id, "_",
              dialog_message_key(m$peer_id, m$id)$message_id
            )
            messages[[key]] <- m
          }

          for (d in r$dialogs) {
            # We check the offset date here because Telegram may ignore it
            key <- paste0(
              dialog_message_key(d$peer, d$top_message)$channel_id, "_",
              dialog_message_key(d$peer, d$top_message)$message_id
            )
            message <- messages[[key]]
            if (!is.null(self$offset_date)) {
              date <- if (!is.null(message)) message$date else NULL
              if (is.null(date) || date$timestamp() > self$offset_date$timestamp()) {
                next
              }
            }

            peer_id <- get_peer_id(d$peer)
            if (!is.element(peer_id, self$seen)) {
              self$seen <- c(self$seen, peer_id)
              if (!is.element(as.character(peer_id), names(entities))) {
                # > In which case can a UserEmpty appear in the list of banned members?
                # > In a very rare cases. This is possible but isn't an expected behavior.
                # Real world example: https://t.me/TelethonChat/271471
                next
              }

              cd <- custom$Dialog(self$client, d, entities, message)
              if (!is.null(cd$dialog$pts)) {
                self$client$message_box$try_set_channel_state(
                  get_peer_id(d$peer, add_mark = FALSE), cd$dialog$pts
                )
              }

              if (!self$ignore_migrated || is.null(cd$entity$migrated_to)) {
                self$buffer <- c(self$buffer, list(cd))
              }
            }
          }

          if (length(self$buffer) == 0 || length(r$dialogs) < self$request$limit ||
            !inherits(r, "messages.DialogsSlice")) {
            # Buffer being empty means all returned dialogs were skipped (due to offsets).
            # Less than we requested means we reached the end, or
            # we didn't get a DialogsSlice which means we got all.
            return(TRUE)
          }

          # We can't use `messages[-1]` as the offset ID / date.
          # Why? Because pinned dialogs will mess with the order
          # in this list. Instead, we find the last dialog which
          # has a message, and use it as an offset.
          reversed_dialogs <- rev(r$dialogs)
          last_message <- NULL

          for (d in reversed_dialogs) {
            key <- paste0(
              dialog_message_key(d$peer, d$top_message)$channel_id, "_",
              dialog_message_key(d$peer, d$top_message)$message_id
            )
            if (!is.null(messages[[key]])) {
              last_message <- messages[[key]]
              break
            }
          }

          self$request$exclude_pinned <- TRUE
          self$request$offset_id <- if (!is.null(last_message)) last_message$id else 0
          self$request$offset_date <- if (!is.null(last_message)) last_message$date else NULL
          self$request$offset_peer <- self$buffer[[length(self$buffer)]]$input_entity

          return(FALSE)
        })
      )
    },

    #  @description
    #  Gets the initialization future.
    #  @return A future that resolves to the initialization result.
    get_init_future = function() {
      return(private$init_future)
    }
  ),
  private = list(
    init_future = NULL
  )
)

#  DraftsIter class
#  @title DraftsIter
#  @description Telegram API type DraftsIter
#  @export
#  @noRd
#  @noRd
DraftsIter <- R6::R6Class("DraftsIter",
  inherit = RequestIter,
  public = list(
    #  @description
    #  Constructor for the DraftsIter class.
    #  @param client The Telegram client.
    #  @param limit The maximum number of drafts to retrieve.
    #  @param entities The list of entities for which to fetch the drafts.
    #  @return A new DraftsIter object.
    initialize = function(client, limit, entities = NULL) {
      super$initialize(client, limit)

      # Using a Future (avoid %<-% to bypass global inspection issues)
      private$init_future <- future(
        {
          if (is.null(entities)) {
            r <- await(self$client(GetAllDraftsRequest$new()))
            items <- r$updates
          } else {
            peers <- list()
            for (entity in entities) {
              input_entity <- await(self$client$get_input_entity(entity))
              peers <- c(peers, list(InputDialogPeer$new(input_entity)))
            }

            r <- await(self$client(GetPeerDialogsRequest$new(peers)))
            items <- r$dialogs
          }

          # Create entities dictionary
          entities_dict <- list()
          all_entities <- c(r$users, r$chats)
          for (x in all_entities) {
            entities_dict[[as.character(get_peer_id(x))]] <- x
          }

          # Extend buffer with drafts
          for (d in items) {
            entity <- entities_dict[[as.character(get_peer_id(d$peer))]]
            draft_obj <- custom$Draft(self$client, entity, d$draft)
            self$buffer <- c(self$buffer, list(draft_obj))
          }
        },
        globals = FALSE
      )
    },

    #  @description
    #  Loads the next chunk of drafts.
    #  @return A future that resolves to a list of drafts.
    load_next_chunk = function() {
      return(future({
        return(list())
      }))
    },

    #  @description
    #  Gets the initialization future.
    #  @return A future that resolves to the initialization result.
    get_init_future = function() {
      return(private$init_future)
    }
  ),
  private = list(
    init_future = NULL
  )
)
