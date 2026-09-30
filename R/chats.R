#  @include types.R
NULL

.MAX_PARTICIPANTS_CHUNK_SIZE <- 200
.MAX_ADMIN_LOG_CHUNK_SIZE <- 100
.MAX_PROFILE_PHOTO_CHUNK_SIZE <- 100

#' _ChatAction R6 Class
#'
#' A context manager-like class for representing a "chat action" in Telegram,
#' such as "user is typing" or uploading a file with progress.
#' This class handles sending the appropriate action to the chat and optionally
#' cancelling it when done. It is designed to be used synchronously in R.
#' @noRd
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


#' _ParticipantsIter R6 Class
#'
#' An iterator over the participants belonging to the specified chat.
#' The order is unspecified.
#' Inherits from RequestIter.
#' @noRd
.ParticipantsIter <- R6::R6Class(
  "_ParticipantsIter",
  inherit = RequestIter,
  public = list(
    filter_entity = NULL,
    requests = NULL,
    seen = NULL,
    entity = NULL,
    filter = NULL,
    search = "",
    initialize = function(client, limit = Inf, entity, filter = NULL, search = "") {
      super$initialize(client = client, limit = limit)
      if (!is.null(filter) && is.function(filter)) {
        if (inherits(filter, "ChannelParticipantsBanned") ||
          inherits(filter, "ChannelParticipantsKicked") ||
          inherits(filter, "ChannelParticipantsSearch") ||
          inherits(filter, "ChannelParticipantsContacts")) {
          filter <- filter("")
        } else {
          filter <- filter()
        }
      }
      self$filter <- filter
      self$search <- search %||% ""
      self$seen <- character(0)
      self$buffer <- list()
      self$filter_entity <- function(ent) TRUE

      # Resolve the entity to an input entity; support both an R6 client
      # and a plain callable client (used by tests).
      resolver <- NULL
      if (is.function(client)) {
        resolver <- attr(client, "get_input_entity")
      } else if (is.function(client$get_input_entity)) {
        resolver <- client$get_input_entity
      }
      if (is.function(resolver)) {
        entity <- await(resolver(entity))
      }
      self$entity <- entity

      ty <- entity_type(entity)
      search <- self$search
      if (nchar(search) > 0 && (!is.null(filter) || ty != EntityType$CHANNEL)) {
        search <- tolower(search)
        self$filter_entity <- function(ent) {
          display_name <- tolower(utils$get_display_name(ent))
          username <- tolower(getattr(ent, "username", "") %||% "")
          grepl(search, display_name, fixed = TRUE) || grepl(search, username, fixed = TRUE)
        }
      }

      # Channels are paged through channels.getParticipants; building the
      # request needs no network access so it is done here.
      if (ty == EntityType$CHANNEL && self$limit > 0) {
        input_channel <- tryCatch(utils$get_input_channel(entity), error = function(e) entity)
        self$requests <- GetParticipantsRequest$new(
          channel = input_channel,
          filter = filter %||% ChannelParticipantsSearch$new(q = search),
          offset = 0L,
          limit = .MAX_PARTICIPANTS_CHUNK_SIZE,
          hash = 0
        )
      }
    },

    # Called once by RequestIter$.next() before the first chunk. Returns TRUE
    # when the buffer is already complete (no further chunks needed).
    async_init = function(...) {
      entity <- self$entity
      ty <- entity_type(entity)

      if (ty == EntityType$CHANNEL) {
        if (self$limit <= 0) {
          input_channel <- tryCatch(utils$get_input_channel(entity), error = function(e) entity)
          full_channel <- private$invoke(GetFullChannelRequest$new(channel = input_channel))
          self$total <- full_channel$full_chat$participants_count
          return(TRUE)
        }
        return(FALSE)
      }

      if (ty == EntityType$CHAT) {
        full <- private$invoke(GetFullChatRequest$new(chat_id = entity$chat_id))
        parts <- full$full_chat$participants
        if (!inherits(parts, "ChatParticipants")) {
          self$total <- 0
          return(TRUE)
        }
        self$total <- length(parts$participants)
        users <- private$index_users(full$users)
        for (participant in parts$participants) {
          if (inherits(participant, "ChannelParticipantLeft")) next
          user_id <- if (inherits(participant, "ChannelParticipantBanned")) participant$peer$user_id else participant$user_id
          user <- users[[as.character(user_id)]]
          if (is.null(user) || !self$filter_entity(user)) next
          self$buffer <- c(self$buffer, list(private$with_participant(user, participant)))
        }
        return(TRUE)
      }

      # A single user
      self$total <- 1
      if (self$limit != 0) {
        user <- if (is.function(self$client)) entity else await(self$client$get_entity(entity))
        if (self$filter_entity(user)) {
          self$buffer <- c(self$buffer, list(private$with_participant(user, NULL)))
        }
      }
      TRUE
    },

    # Loads the next page into self$buffer. Returns TRUE when this was the
    # last page (RequestIter semantics), NULL otherwise.
    load_next_chunk = function() {
      if (is.null(self$requests)) {
        return(TRUE)
      }

      self$requests$limit <- as.integer(min(self$left, .MAX_PARTICIPANTS_CHUNK_SIZE))
      if (self$requests$offset > self$limit) {
        return(TRUE)
      }

      if (is.null(self$total)) {
        f <- self$requests$filter
        if (!inherits(f, "ChannelParticipantsRecent") &&
          (!inherits(f, "ChannelParticipantsSearch") || nchar(f$q %||% "") > 0)) {
          count_res <- tryCatch(private$invoke(GetParticipantsRequest$new(
            channel = self$requests$channel,
            filter = ChannelParticipantsRecent$new(),
            offset = 0L,
            limit = 1L,
            hash = 0
          )), error = function(e) NULL)
          self$total <- count_res$count
        }
      }

      participants <- private$invoke(self$requests)
      if (is.null(self$total)) {
        self$total <- participants$count
      }
      if (length(participants$users) == 0) {
        self$requests <- NULL
        return(TRUE)
      }

      self$requests$offset <- self$requests$offset + length(participants$participants)
      users <- private$index_users(participants$users)
      for (participant in participants$participants) {
        if (inherits(participant, "ChannelParticipantLeft")) next
        if (inherits(participant, "ChannelParticipantBanned")) {
          if (!inherits(participant$peer, "PeerUser")) next
          user_id <- participant$peer$user_id
        } else {
          user_id <- participant$user_id
        }
        key <- as.character(user_id)
        user <- users[[key]]
        if (is.null(user) || !self$filter_entity(user) || key %in% self$seen) next
        self$seen <- c(self$seen, key)
        self$buffer <- c(self$buffer, list(private$with_participant(user, participant)))
      }
      NULL
    }
  ),
  private = list(
    # Invoke a request through either an R6 client or a callable client.
    invoke = function(req) {
      if (is.function(self$client)) {
        return(self$client(req))
      }
      res <- if (is.function(self$client$invoke)) self$client$invoke(req) else self$client$call(req)
      await(res)
    },
    index_users = function(users) {
      out <- list()
      for (u in users) {
        uid <- tryCatch(u$id, error = function(e) NULL)
        if (!is.null(uid)) out[[as.character(uid)]] <- u
      }
      out
    },
    # Attach the participant info to the user; generated TL classes are
    # locked so fall back to a plain list carrying the user's fields.
    with_participant = function(user, participant) {
      ok <- tryCatch({ user$participant <- participant; TRUE }, error = function(e) FALSE)
      if (ok) return(user)
      fields <- tryCatch(user$to_dict(), error = function(e) NULL)
      if (is.null(fields)) fields <- as.list(user)
      fields$participant <- participant
      fields
    }
  )
)

#' _AdminLogIter R6 Class
#'
#' An iterator over the admin log for the specified channel.
#' The default order is from the most recent event to the oldest.
#' Inherits from RequestIter.
#' @noRd
.AdminLogIter <- R6::R6Class(
  "_AdminLogIter",
  inherit = RequestIter,
  public = list(
    request = NULL,
    entity = NULL,
    initialize = function(client, limit = Inf, entity, admins = NULL, search = NULL,
                          min_id = 0, max_id = 0, join = NULL, leave = NULL, invite = NULL,
                          restrict = NULL, unrestrict = NULL, ban = NULL, unban = NULL,
                          promote = NULL, demote = NULL, info = NULL, settings = NULL,
                          pinned = NULL, edit = NULL, delete = NULL, group_call = NULL) {
      super$initialize(client = client, limit = limit)
      flag <- function(x) isTRUE(x)
      any_filter <- any(vapply(list(join, leave, invite, restrict, unrestrict, ban, unban,
        promote, demote, info, settings, pinned, edit, delete, group_call), flag, logical(1)))
      events_filter <- if (any_filter) {
        ChannelAdminLogEventsFilter$new(
          join = flag(join), leave = flag(leave), invite = flag(invite),
          ban = flag(restrict), unban = flag(unrestrict), kick = flag(ban),
          unkick = flag(unban), promote = flag(promote), demote = flag(demote),
          info = flag(info), settings = flag(settings), pinned = flag(pinned),
          edit = flag(edit), delete = flag(delete), group_call = flag(group_call)
        )
      } else NULL

      self$entity <- private$resolve_input(entity)
      admin_list <- list()
      if (!is.null(admins)) {
        if (!is_list_like(admins)) admins <- list(admins)
        for (admin in admins) admin_list <- c(admin_list, list(private$resolve_input(admin)))
      }
      self$request <- GetAdminLogRequest$new(
        channel = self$entity, q = search %||% "", min_id = as.integer(min_id),
        max_id = as.integer(max_id), limit = 0L, events_filter = events_filter,
        admins = if (length(admin_list) > 0) admin_list else NULL
      )
    },

    async_init = function(...) FALSE,

    load_next_chunk = function() {
      self$request$limit <- as.integer(min(self$left, .MAX_ADMIN_LOG_CHUNK_SIZE))
      r <- private$invoke(self$request)
      events <- r$events %||% list()
      if (length(events) == 0) return(TRUE)
      self$request$max_id <- min(vapply(events, function(e) as.numeric(e$id), numeric(1)))
      for (ev in events) self$buffer <- c(self$buffer, list(ev))
      if (length(events) < self$request$limit) return(TRUE)
      NULL
    }
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


.ProfilePhotoIter <- R6::R6Class(
  "_ProfilePhotoIter",
  inherit = RequestIter,
  public = list(
    request = NULL,
    is_user = FALSE,
    initialize = function(client, limit = Inf, entity, offset = 0, max_id = 0) {
      super$initialize(client = client, limit = limit)
      ent <- private$resolve_input(entity)
      ty <- entity_type(ent)
      if (ty == EntityType$USER) {
        self$is_user <- TRUE
        input_user <- tryCatch(utils$get_input_user(ent), error = function(e) ent)
        self$request <- GetUserPhotosRequest$new(
          user_id = input_user, offset = as.integer(offset),
          max_id = max_id, limit = 1L
        )
      } else {
        self$request <- SearchRequest$new(
          peer = ent, q = "", filter = InputMessagesFilterChatPhotos$new(),
          min_date = NULL, max_date = NULL, offset_id = 0L, add_offset = as.integer(offset),
          limit = 1L, max_id = max_id, min_id = 0L, hash = 0
        )
      }
    },

    async_init = function(...) FALSE,

    load_next_chunk = function() {
      self$request$limit <- as.integer(min(self$left, .MAX_PROFILE_PHOTO_CHUNK_SIZE))
      result <- private$invoke(self$request)
      photos <- list(); last <- TRUE
      if (inherits(result, c("Photos", "photos.Photos"))) {
        photos <- result$photos %||% list()
      } else if (inherits(result, c("PhotosSlice", "photos.PhotosSlice"))) {
        photos <- result$photos %||% list()
        self$total <- result$count
        if (length(photos) >= self$request$limit) {
          self$request$offset <- (self$request$offset %||% 0) + length(photos); last <- FALSE
        }
      } else if (inherits(result, c("Messages", "ChannelMessages", "messages.Messages", "messages.ChannelMessages"))) {
        msgs <- result$messages %||% list()
        for (m in msgs) {
          act <- tryCatch(m$action, error = function(e) NULL)
          if (inherits(act, "MessageActionChatEditPhoto") && !is.null(act$photo)) {
            photos <- c(photos, list(act$photo))
          }
        }
        if (length(msgs) >= self$request$limit && length(msgs) > 0) {
          self$request$add_offset <- 0L
          self$request$offset_id <- msgs[[length(msgs)]]$id; last <- FALSE
        }
      }
      for (ph in photos) self$buffer <- c(self$buffer, list(ph))
      if (last) return(TRUE)
      NULL
    }
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
