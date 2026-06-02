#  @include types.R
NULL

.MAX_PARTICIPANTS_CHUNK_SIZE <- 200
.MAX_ADMIN_LOG_CHUNK_SIZE <- 100
.MAX_PROFILE_PHOTO_CHUNK_SIZE <- 100

#  _ChatAction R6 Class
# 
#  A context manager-like class for representing a "chat action" in Telegram,
#  such as "user is typing" or uploading a file with progress.
#  This class handles sending the appropriate action to the chat and optionally
#  cancelling it when done. It is designed to be used synchronously in R.
# 
#  @export
#  @noRd
#  @noRd
.ChatAction <- R6::R6Class(
  "_ChatAction",
  public = list(
    #  @field client Client instance.
    client = NULL,
    #  @field chat Chat entity.
    chat = NULL,
    #  @field action Action object or string.
    action = NULL,
    #  @field delay Delay seconds.
    delay = NULL,
    #  @field auto_cancel Auto-cancel on exit.
    auto_cancel = NULL,
    #  @field request Last request.
    request = NULL,
    #  @field running Whether action is running.
    running = FALSE,
    #  @description Initialize the _ChatAction object.
    #  @param client The TelegramClient instance.
    #  @param chat The chat entity.
    #  @param action The action to show (string or SendMessageAction object).
    #  @param delay The delay in seconds (reserved for future async implementation).
    #  @param auto_cancel Whether to auto-cancel on exit.
    initialize = function(client, chat, action, delay = 4, auto_cancel = TRUE) {
      self$client <- client
      self$chat <- chat
      self$action <- action
      self$delay <- delay
      self$auto_cancel <- auto_cancel
      self$request <- NULL
      self$running <- FALSE
    },

    #  @description Enter the context (start the action).
    #  Sends the initial action request to the chat.
    enter = function() {
      get_input_entity <- NULL
      if (is.list(self$client) && is.function(self$client$get_input_entity)) {
        get_input_entity <- self$client$get_input_entity
      } else {
        get_input_entity <- tryCatch(get_input_entity, error = function(e) NULL)
      }
      if (is.function(get_input_entity)) {
        self$chat <- get_input_entity(self$chat)
      }
      self$request <- SetTypingRequest(self$chat, self$action)
      self$running <- TRUE
      # Send the action once (synchronous version; no looping as in async Python)
      self$client(self$request)
    },

    #  @description Exit the context (stop the action).
    #  Cancels the action if auto_cancel is TRUE.
    #  @param ... Ignored (for compatibility with context managers).
    exit = function(...) {
      self$running <- FALSE
      if (self$auto_cancel) {
        cancel_request <- SetTypingRequest(self$chat, SendMessageCancelAction())
        self$client(cancel_request)
      }
    },

    #  @description Update the progress of the action (for upload actions).
    #  @param current The current progress value.
    #  @param total The total progress value.
    progress = function(current, total) {
      if ("progress" %in% names(self$action)) {
        self$action$progress <- 100 * round(current / total)
      }
    }
  ),
  private = list(
    #  @field _str_mapping A named list mapping string action names to SendMessageAction objects.
    .str_mapping = list(
      "typing" = SendMessageTypingAction$new(),
      "contact" = SendMessageChooseContactAction$new(),
      "game" = SendMessageGamePlayAction$new(),
      "location" = SendMessageGeoLocationAction$new(),
      "sticker" = SendMessageChooseStickerAction$new(),
      "record-audio" = SendMessageRecordAudioAction$new(),
      "record-voice" = SendMessageRecordAudioAction$new(), # alias
      "record-round" = SendMessageRecordRoundAction$new(),
      "record-video" = SendMessageRecordVideoAction$new(),
      "audio" = SendMessageUploadAudioAction$new(1),
      "voice" = SendMessageUploadAudioAction$new(1), # alias
      "song" = SendMessageUploadAudioAction$new(1), # alias
      "round" = SendMessageUploadRoundAction$new(1),
      "video" = SendMessageUploadVideoAction$new(1),
      "photo" = SendMessageUploadPhotoAction$new(1),
      "document" = SendMessageUploadDocumentAction$new(1),
      "file" = SendMessageUploadDocumentAction$new(1), # alias
      "cancel" = SendMessageCancelAction$new()
    )
  )
)


#  _ParticipantsIter R6 Class
# 
#  An iterator over the participants belonging to the specified chat.
#  The order is unspecified.
#  Inherits from RequestIter.
# 
#  @export
#  @noRd
#  @noRd
.ParticipantsIter <- R6::R6Class(
  "_ParticipantsIter",
  inherit = RequestIter,
  public = list(
    #  @field filter_entity Optional local filter function.
    filter_entity = NULL,
    #  @field requests Internal requests holder.
    requests = NULL,
    #  @field seen Internal seen cache.
    seen = NULL,
    #  @description Initialize the iterator.
    #  @param entity The entity from which to retrieve the participants list.
    #  @param filter The filter to be used, if you want e.g. only admins. Default is NULL.
    #  @param search Look for participants with this string in name/username. Default is ''.
    initialize = function(client, limit = Inf, entity, filter = NULL, search = "") {
      super$initialize(client = client, limit = limit)
      if (!is.null(filter) && is.function(filter)) {
        if (inherits(filter, "ChannelParticipantsBanned") ||
          inherits(filter, "ChannelParticipantsKicked") ||
          inherits(filter, "ChannelParticipantsSearch") ||
          inherits(filter, "ChannelParticipantsContacts")) {
          # These require a `q` parameter (support types for convenience)
          filter <- filter("")
        } else {
          filter <- filter()
        }
      }

      get_input_entity <- NULL
      if (is.list(self$client) && is.function(self$client$get_input_entity)) {
        get_input_entity <- self$client$get_input_entity
      } else {
        get_input_entity <- tryCatch(get_input_entity, error = function(e) NULL)
      }
      if (is.function(get_input_entity)) {
        entity <- get_input_entity(entity)
      }
      ty <- helpers$`_entity_type`(entity)
      if (nchar(search) > 0 && (!is.null(filter) || ty != helpers$`_EntityType`$CHANNEL)) {
        # We need to 'search' ourselves unless we have a PeerChannel
        search <- tolower(search)
        self$filter_entity <- function(ent) {
          display_name <- tolower(utils$get_display_name(ent))
          username <- tolower(getattr(ent, "username", "") %||% "")
          return(grepl(search, display_name) || grepl(search, username))
        }
      } else {
        self$filter_entity <- function(ent) TRUE
      }

      # Only used for channels, but we should always set the attribute
      # Called `requests` even though it's just one for legacy purposes.
      self$requests <- NULL

      if (ty == helpers$`_EntityType`$CHANNEL) {
        if (self$limit <= 0) {
          # May not have access to the channel, but getFull can get the .total.
          full_channel <- self$client(GetFullChannelRequest(entity))
          self$total <- full_channel$full_chat$participants_count
          stop("StopIteration")
        }

        self$seen <- list()
        req_cls <- get0("GetParticipantsRequest", envir = asNamespace("telegramR"))
        if (is.null(req_cls) || !is.function(req_cls$new)) {
          stop("GetParticipantsRequest not available in namespace")
        }
        cps_cls <- get0("ChannelParticipantsSearch", envir = asNamespace("telegramR"))
        if (is.null(cps_cls) || !is.function(cps_cls$new)) {
          stop("ChannelParticipantsSearch not available in namespace")
        }
        self$requests <- req_cls$new(
          channel = entity,
          filter = filter %||% cps_cls$new(search),
          #  @field offset Field.
          offset = 0,
          limit = .MAX_PARTICIPANTS_CHUNK_SIZE,
          #  @field hash Field.
          hash = 0
        )
      } else if (ty == helpers$`_EntityType`$CHAT) {
        full <- self$client(GetFullChatRequest(entity$chat_id))
        if (!inherits(full$full_chat$participants, "ChatParticipants")) {
          # ChatParticipantsForbidden won't have ``.participants``
          self$total <- 0
          stop("StopIteration")
        }

        self$total <- length(full$full_chat$participants$participants)

        users <- setNames(full$users, sapply(full$users, function(u) u$id))
        for (participant in full$full_chat$participants$participants) {
          if (inherits(participant, "ChannelParticipantLeft")) {
            # See issue #3231 to learn why this is ignored.
            next
          } else if (inherits(participant, "ChannelParticipantBanned")) {
            user_id <- participant$peer$user_id
          } else {
            user_id <- participant$user_id
          }
          user <- users[[as.character(user_id)]]
          if (!self$filter_entity(user)) {
            next
          }

          user$participant <- participant
          self$buffer <- c(self$buffer, user)
        }

        return(TRUE)
      } else {
        self$total <- 1
        if (self$limit != 0) {
          user <- self$client$get_entity(entity)
          if (self$filter_entity(user)) {
            user$participant <- NULL
            self$buffer <- c(self$buffer, user)
          }
        }

        return(TRUE)
      }
    },

    #  @description Load the next chunk of participants.
    .load_next_chunk = function() {
      if (is.null(self$requests)) {
        return(TRUE)
      }

      self$requests$limit <- min(self$left, .MAX_PARTICIPANTS_CHUNK_SIZE)

      if (self$requests$offset > self$limit) {
        return(TRUE)
      }

      if (is.null(self$total)) {
        f <- self$requests$filter
        if (!inherits(f, "ChannelParticipantsRecent") &&
          (!inherits(f, "ChannelParticipantsSearch") || nchar(f$q) > 0)) {
          # Only do an additional getParticipants here to get the total
          # if there's a filter which would reduce the real total number.
          # getParticipants is cheaper than getFull.
          self$total <- self$client(GetParticipantsRequest(
            channel = self$requests$channel,
            filter = ChannelParticipantsRecent(),
            #  @field offset Field.
            offset = 0,
            #  @field limit Field.
            limit = 1,
            #  @field hash Field.
            hash = 0
          ))$count
        }
      }

      participants <- self$client(self$requests)
      if (is.null(self$total)) {
        # Will only get here if there was one request with a filter that matched all users.
        self$total <- participants$count
      }
      if (length(participants$users) == 0) {
        self$requests <- NULL
        return(TRUE)
      }

      self$requests$offset <- self$requests$offset + length(participants$participants)
      users <- setNames(participants$users, sapply(participants$users, function(u) u$id))
      for (participant in participants$participants) {
        if (inherits(participant, "ChannelParticipantLeft")) {
          # See issue #3231 to learn why this is ignored.
          next
        } else if (inherits(participant, "ChannelParticipantBanned")) {
          if (!inherits(participant$peer, "PeerUser")) {
            # May have the entire channel banned. See #3105.
            next
          }
          user_id <- participant$peer$user_id
        } else {
          user_id <- participant$user_id
        }

        user <- users[[as.character(user_id)]]
        if (!self$filter_entity(user) || user$id %in% self$seen) {
          next
        }
        self$seen <- c(self$seen, user_id)
        user$participant <- participant
        self$buffer <- c(self$buffer, user)
      }
    }
  )
)


#  _AdminLogIter R6 Class
# 
#  An iterator over the admin log for the specified channel.
#  The default order is from the most recent event to the oldest.
#  Inherits from RequestIter.
# 
#  @export
#  @noRd
#  @noRd
.AdminLogIter <- R6::R6Class(
  "_AdminLogIter",
  inherit = RequestIter,
  public = list(
    #  @description Initialize the iterator.
    #  @param entity The channel entity from which to get its admin log.
    #  @param admins If present, filter by these admins. Default is NULL.
    #  @param search The string to be used as a search query. Default is NULL.
    #  @param min_id All events with a lower (older) ID or equal to this will be excluded. Default is 0.
    #  @param max_id All events with a higher (newer) ID or equal to this will be excluded. Default is 0.
    #  @param join If TRUE, events for when a user joined will be returned. Default is NULL.
    #  @param leave If TRUE, events for when a user leaves will be returned. Default is NULL.
    #  @param invite If TRUE, events for when a user joins through an invite link will be returned. Default is NULL.
    #  @param restrict If TRUE, events with partial restrictions will be returned. Default is NULL.
    #  @param unrestrict If TRUE, events removing restrictions will be returned. Default is NULL.
    #  @param ban If TRUE, events applying or removing all restrictions will be returned. Default is NULL.
    #  @param unban If TRUE, events removing all restrictions will be returned. Default is NULL.
    #  @param promote If TRUE, events with admin promotions will be returned. Default is NULL.
    #  @param demote If TRUE, events with admin demotions will be returned. Default is NULL.
    #  @param info If TRUE, events changing the group info will be returned. Default is NULL.
    #  @param settings If TRUE, events changing the group settings will be returned. Default is NULL.
    #  @param pinned If TRUE, events of new pinned messages will be returned. Default is NULL.
    #  @param edit If TRUE, events of message edits will be returned. Default is NULL.
    #  @param delete If TRUE, events of message deletions will be returned. Default is NULL.
    #  @param group_call If TRUE, events related to group calls will be returned. Default is NULL.
    .init = function(entity, admins = NULL, search = NULL, min_id = 0, max_id = 0,
                     join = NULL, leave = NULL, invite = NULL, restrict = NULL, unrestrict = NULL,
                     ban = NULL, unban = NULL, promote = NULL, demote = NULL, info = NULL,
                     settings = NULL, pinned = NULL, edit = NULL, delete = NULL, group_call = NULL) {
      if (any(c(
        join, leave, invite, restrict, unrestrict, ban, unban,
        promote, demote, info, settings, pinned, edit, delete,
        group_call
      ))) {
        events_filter <- ChannelAdminLogEventsFilter(
          join = join, leave = leave, invite = invite, ban = restrict,
          unban = unrestrict, kick = ban, unkick = unban, promote = promote,
          demote = demote, info = info, settings = settings, pinned = pinned,
          edit = edit, delete = delete, group_call = group_call
        )
      } else {
        events_filter <- NULL
      }

      self$entity <- self$client$get_input_entity(entity)

      admin_list <- list()
      if (!is.null(admins)) {
        if (!utils$is_list_like(admins)) {
          admins <- list(admins)
        }
        for (admin in admins) {
          admin_list <- c(admin_list, self$client$get_input_entity(admin))
        }
      }

      self$request <- GetAdminLogRequest(
        self$entity,
        q = search %||% "", min_id = min_id, max_id = max_id,
        limit = 0, events_filter = events_filter, admins = if (length(admin_list) > 0) admin_list else NULL
      )
    },

    #  @description Load the next chunk of admin log events.
    .load_next_chunk = function() {
      self$request$limit <- min(self$left, .MAX_ADMIN_LOG_CHUNK_SIZE)
      r <- self$client(self$request)
      entities <- list()
      for (x in c(r$users, r$chats)) {
        entities[[utils$get_peer_id(x)]] <- x
      }

      self$request$max_id <- if (length(r$events) > 0) min(sapply(r$events, function(e) e$id)) else 0
      for (ev in r$events) {
        if (inherits(ev$action, "ChannelAdminLogEventActionEditMessage")) {
          ev$action$prev_message$`_finish_init`(self$client, entities, self$entity)
          ev$action$new_message$`_finish_init`(self$client, entities, self$entity)
        } else if (inherits(ev$action, "ChannelAdminLogEventActionDeleteMessage")) {
          ev$action$message$`_finish_init`(self$client, entities, self$entity)
        }
        self$buffer <- c(self$buffer, custom$AdminLogEvent(ev, entities))
      }

      if (length(r$events) < self$request$limit) {
        return(TRUE)
      }
    }
  )
)


#  _ProfilePhotoIter R6 Class
# 
#  An iterator over a user's profile photos or a chat's photos.
#  The order is from the most recent photo to the oldest.
#  Inherits from RequestIter.
# 
#  @export
#  @noRd
#  @noRd
.ProfilePhotoIter <- R6::R6Class(
  "_ProfilePhotoIter",
  inherit = RequestIter,
  public = list(
    #  @description Initialize the iterator.
    #  @param entity The entity from which to get the profile or chat photos.
    #  @param offset How many photos should be skipped before returning the first one.
    #  @param max_id The maximum ID allowed when fetching photos.
    .init = function(entity, offset, max_id) {
      entity <- self$client$get_input_entity(entity)
      ty <- helpers$`_entity_type`(entity)
      if (ty == helpers$`_EntityType`$USER) {
        self$request <- functions$photos$GetUserPhotosRequest(
          entity,
          offset = offset,
          max_id = max_id,
          #  @field limit Field.
          limit = 1
        )
      } else {
        self$request <- SearchRequest(
          peer = entity,
          q = "",
          filter = InputMessagesFilterChatPhotos(),
          #  @field min_date Field.
          min_date = NULL,
          #  @field max_date Field.
          max_date = NULL,
          #  @field offset_id Field.
          offset_id = 0,
          add_offset = offset,
          #  @field limit Field.
          limit = 1,
          max_id = max_id,
          #  @field min_id Field.
          min_id = 0,
          #  @field hash Field.
          hash = 0
        )
      }
      if (self$limit == 0) {
        self$request$limit <- 1
      }
      result <- self$client(self$request)
      if (inherits(result, "Photos")) {
        self$total <- length(result$photos)
      } else if (inherits(result, "Messages")) {
        self$total <- length(result$messages)
      } else {
        # Luckily both PhotosSlice and Messages have a count for total
        self$total <- result$count
      }
    },

    #  @description Load the next chunk of photos.
    .load_next_chunk = function() {
      self$request$limit <- min(self$left, .MAX_PROFILE_PHOTO_CHUNK_SIZE)
      result <- self$client(self$request)
      if (inherits(result, "Photos")) {
        self$buffer <- result$photos
        self$left <- length(self$buffer)
        self$total <- length(self$buffer)
      } else if (inherits(result, "Messages")) {
        self$buffer <- lapply(result$messages, function(x) {
          if (inherits(x$action, "MessageActionChatEditPhoto")) x$action$photo else NULL
        })
        self$buffer <- self$buffer[!sapply(self$buffer, is.null)]
        self$left <- length(self$buffer)
        self$total <- length(self$buffer)
      } else if (inherits(result, "PhotosSlice")) {
        self$buffer <- result$photos
        self$total <- result$count
        if (length(self$buffer) < self$request$limit) {
          self$left <- length(self$buffer)
        } else {
          self$request$offset <- self$request$offset + length(result$photos)
        }
      } else {
        # Some broadcast channels have a photo that this request doesn't
        # retrieve for whatever random reason the Telegram server feels.
        #
        # This means the `total` count may be wrong but there's not much
        # that can be done around it (perhaps there are too many photos
        # and this is only a partial result so it's not possible to just
        # use the len of the result).
        self$total <- result$count
      }
      # Unconditionally fetch the full channel to obtain this photo and
      # yield it with the rest (unless it's a duplicate).
      seen_id <- NULL
      if (inherits(result, "ChannelMessages")) {
        channel <- self$client(GetFullChannelRequest(self$request$peer))
        photo <- channel$full_chat$chat_photo
        if (inherits(photo, "Photo")) {
          self$buffer <- c(self$buffer, photo)
          seen_id <- photo$id
        }
        additional <- lapply(result$messages, function(x) {
          if (inherits(x$action, "MessageActionChatEditPhoto") && x$action$photo$id != seen_id) x$action$photo else NULL
        })
        additional <- additional[!sapply(additional, is.null)]
        self$buffer <- c(self$buffer, additional)
        if (length(result$messages) < self$request$limit) {
          self$left <- length(self$buffer)
        } else if (length(result$messages) > 0) {
          self$request$add_offset <- 0
          self$request$offset_id <- result$messages[[length(result$messages)]]$id
        }
      }
    }
  )
)
