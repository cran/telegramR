#' @title CheckSearchPostsFloodRequest
#' @description Telegram API request \code{channels.checkSearchPostsFlood} (constructor \code{#22567115}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
CheckSearchPostsFloodRequest <- R6::R6Class(
  "CheckSearchPostsFloodRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x22567115,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xc2c0ccc1,
    #  @field query Field.
    query = NULL,

    #  @description Initialize the CheckSearchPostsFloodRequest.
    #  @param query The query string (optional).
    initialize = function(query = NULL) {
      self$query <- query
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "CheckSearchPostsFloodRequest",
        query = self$query
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$query) || !self$query) 0 else 1
      c(
        as.raw(c(0x15, 0x71, 0x56, 0x22)),
        pack("<I", flags),
        if (!is.null(self$query) && self$query) self$serialize_bytes(self$query) else raw(0)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name CheckSearchPostsFloodRequest_from_reader
#'
#' @param reader The reader object.
#' @return An instance of CheckSearchPostsFloodRequest.
#' @noRd
CheckSearchPostsFloodRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  query <- if ((flags && 1) != 0) reader$tgread_string() else NULL
  CheckSearchPostsFloodRequest$new(query = query)
}

#' @title CheckUsernameRequest
#' @description Telegram API request \code{channels.checkUsername} (constructor \code{#10e6bd2c}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
CheckUsernameRequest <- R6::R6Class("CheckUsernameRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0x10e6bd2c,
    SUBCLASS_OF_ID = 0xf5b399ac,
    channel = NULL,
    username = NULL,
    initialize = function(channel, username) {
      self$channel <- channel
      self$username <- username
    },
    resolve = function(client, utils) {
      if (!is.null(self$channel)) self$channel <- tryCatch(utils$get_input_channel(client$get_input_entity(self$channel)), error = function(e) self$channel)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "CheckUsernameRequest",
        "channel" = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        "username" = if (inherits(self$username, "TLObject")) self$username$to_dict() else self$username
      )
    },
    to_list = function() {
      list(
        `_` = "CheckUsernameRequest",
        "channel" = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        "username" = if (inherits(self$username, "TLObject")) self$username$to_dict() else self$username
      )
    },
    bytes = function() {
      c(
        as.raw(c(0x2c, 0xbd, 0xe6, 0x10)),
        self$channel$bytes(),
        serialize_bytes(self$username)
      )
    },
    serialize = function() self$bytes()
  ),
  private = list(
    from_reader = function(reader) {
      self$channel <- reader$tgread_object()
      self$username <- reader$tgread_string()
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title ConvertToGigagroupRequest
#' @description Telegram API request \code{channels.convertToGigagroup} (constructor \code{#0b290c69}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ConvertToGigagroupRequest <- R6::R6Class(
  "ConvertToGigagroupRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xb290c69,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,

    #  @description Initialize the ConvertToGigagroupRequest.
    #  @param channel The input channel.
    initialize = function(channel) {
      self$channel <- channel
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ConvertToGigagroupRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x69, 0x0c, 0x29, 0x0b)),
        self$channel$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name ConvertToGigagroupRequest_from_reader
#'
#' @param reader The reader object.
#' @return An instance of ConvertToGigagroupRequest.
#' @noRd
ConvertToGigagroupRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  ConvertToGigagroupRequest$new(channel = channel)
}

#' @title CreateChannelRequest
#' @description Telegram API request \code{channels.createChannel} (constructor \code{#91006707}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
CreateChannelRequest <- R6::R6Class(
  "CreateChannelRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x91006707,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field title Field.
    title = NULL,
    #  @field about Field.
    about = NULL,
    #  @field broadcast Field.
    broadcast = NULL,
    #  @field megagroup Field.
    megagroup = NULL,
    #  @field for_import Field.
    for_import = NULL,
    #  @field forum Field.
    forum = NULL,
    #  @field geo_point Field.
    geo_point = NULL,
    #  @field address Field.
    address = NULL,
    #  @field ttl_period Field.
    ttl_period = NULL,

    #  @description Initialize the CreateChannelRequest.
    #  @param title The title of the channel.
    #  @param about The description of the channel.
    #  @param broadcast Whether the channel is a broadcast channel.
    #  @param megagroup Whether the channel is a megagroup.
    #  @param for_import Whether the channel is for import.
    #  @param forum Whether the channel is a forum.
    #  @param geo_point The geo point for the channel.
    #  @param address The address for the channel.
    #  @param ttl_period The TTL period for the channel.
    initialize = function(title, about, broadcast = NULL, megagroup = NULL, for_import = NULL, forum = NULL, geo_point = NULL, address = NULL, ttl_period = NULL) {
      self$title <- title
      self$about <- about
      self$broadcast <- broadcast
      self$megagroup <- megagroup
      self$for_import <- for_import
      self$forum <- forum
      self$geo_point <- geo_point
      self$address <- address
      self$ttl_period <- ttl_period
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "CreateChannelRequest",
        title = self$title,
        about = self$about,
        broadcast = self$broadcast,
        megagroup = self$megagroup,
        for_import = self$for_import,
        forum = self$forum,
        geo_point = if (inherits(self$geo_point, "TLObject")) self$geo_point$to_dict() else self$geo_point,
        address = self$address,
        ttl_period = self$ttl_period
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$broadcast) || !self$broadcast) 0 else 1) |
        (if (is.null(self$megagroup) || !self$megagroup) 0 else 2) |
        (if (is.null(self$for_import) || !self$for_import) 0 else 8) |
        (if (is.null(self$forum) || !self$forum) 0 else 32) |
        (if (is.null(self$geo_point) || !self$geo_point) 0 else 4) |
        (if (is.null(self$address) || !self$address) 0 else 4) |
        (if (is.null(self$ttl_period) || !self$ttl_period) 0 else 16)
      c(
        as.raw(c(0x07, 0x67, 0x00, 0x91)),
        pack("<I", flags),
        self$serialize_bytes(self$title),
        self$serialize_bytes(self$about),
        if (!is.null(self$geo_point) && self$geo_point) self$geo_point$bytes() else raw(0),
        if (!is.null(self$address) && self$address) self$serialize_bytes(self$address) else raw(0),
        if (!is.null(self$ttl_period) && self$ttl_period) pack("<i", self$ttl_period) else raw(0)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name CreateChannelRequest_from_reader
#' @param reader The reader object.
#' @return An instance of CreateChannelRequest.
#' @noRd
CreateChannelRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  broadcast <- (flags & 1) != 0
  megagroup <- (flags & 2) != 0
  for_import <- (flags & 8) != 0
  forum <- (flags & 32) != 0
  title <- reader$tgread_string()
  about <- reader$tgread_string()
  geo_point <- if ((flags && 4) != 0) reader$tgread_object() else NULL
  address <- if ((flags && 4) != 0) reader$tgread_string() else NULL
  ttl_period <- if ((flags && 16) != 0) reader$read_int() else NULL
  CreateChannelRequest$new(title = title, about = about, broadcast = broadcast, megagroup = megagroup, for_import = for_import, forum = forum, geo_point = geo_point, address = address, ttl_period = ttl_period)
}


#' @title CreateForumTopicRequest
#' @description Telegram API request \code{messages.createForumTopic} (constructor \code{#2f98c3d5}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
CreateForumTopicRequest <- R6::R6Class("CreateForumTopicRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0x2f98c3d5,
    SUBCLASS_OF_ID = 0x8af52aac,
    title_missing = NULL,
    peer = NULL,
    title = NULL,
    icon_color = NULL,
    icon_emoji_id = NULL,
    random_id = NULL,
    send_as = NULL,
    initialize = function(title_missing = NULL, peer, title, icon_color = NULL, icon_emoji_id = NULL, random_id, send_as = NULL) {
      self$title_missing <- title_missing
      self$peer <- peer
      self$title <- title
      self$icon_color <- icon_color
      self$icon_emoji_id <- icon_emoji_id
      self$random_id <- random_id
      self$send_as <- send_as
    },
    resolve = function(client, utils) {
      if (!is.null(self$peer)) self$peer <- tryCatch(utils$get_input_peer(client$get_input_entity(self$peer)), error = function(e) self$peer)
      if (!is.null(self$send_as)) self$send_as <- tryCatch(utils$get_input_peer(client$get_input_entity(self$send_as)), error = function(e) self$send_as)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "CreateForumTopicRequest",
        "title_missing" = if (inherits(self$title_missing, "TLObject")) self$title_missing$to_dict() else self$title_missing,
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "title" = if (inherits(self$title, "TLObject")) self$title$to_dict() else self$title,
        "icon_color" = if (inherits(self$icon_color, "TLObject")) self$icon_color$to_dict() else self$icon_color,
        "icon_emoji_id" = if (inherits(self$icon_emoji_id, "TLObject")) self$icon_emoji_id$to_dict() else self$icon_emoji_id,
        "random_id" = if (inherits(self$random_id, "TLObject")) self$random_id$to_dict() else self$random_id,
        "send_as" = if (inherits(self$send_as, "TLObject")) self$send_as$to_dict() else self$send_as
      )
    },
    to_list = function() {
      list(
        `_` = "CreateForumTopicRequest",
        "title_missing" = if (inherits(self$title_missing, "TLObject")) self$title_missing$to_dict() else self$title_missing,
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "title" = if (inherits(self$title, "TLObject")) self$title$to_dict() else self$title,
        "icon_color" = if (inherits(self$icon_color, "TLObject")) self$icon_color$to_dict() else self$icon_color,
        "icon_emoji_id" = if (inherits(self$icon_emoji_id, "TLObject")) self$icon_emoji_id$to_dict() else self$icon_emoji_id,
        "random_id" = if (inherits(self$random_id, "TLObject")) self$random_id$to_dict() else self$random_id,
        "send_as" = if (inherits(self$send_as, "TLObject")) self$send_as$to_dict() else self$send_as
      )
    },
    bytes = function() {
      flags <- 0L
      if (isTRUE(self$title_missing)) flags <- bitwOr(flags, 16L)
      if (!is.null(self$icon_color)) flags <- bitwOr(flags, 1L)
      if (!is.null(self$icon_emoji_id)) flags <- bitwOr(flags, 8L)
      if (!is.null(self$send_as)) flags <- bitwOr(flags, 4L)
      c(
        as.raw(c(0xd5, 0xc3, 0x98, 0x2f)),
        pack("<I", flags),
        self$peer$bytes(),
        serialize_bytes(self$title),
        if (!is.null(self$icon_color)) pack("<i", self$icon_color) else raw(0),
        if (!is.null(self$icon_emoji_id)) packInt64(self$icon_emoji_id) else raw(0),
        packInt64(self$random_id),
        if (!is.null(self$send_as)) self$send_as$bytes() else raw(0)
      )
    },
    serialize = function() self$bytes()
  ),
  private = list(
    from_reader = function(reader) {
      flags <- reader$read_int()
      self$title_missing <- bitwAnd(flags, 16L) != 0
      self$peer <- reader$tgread_object()
      self$title <- reader$tgread_string()
      self$icon_color <- if (bitwAnd(flags, 1L) != 0) reader$read_int() else NULL
      self$icon_emoji_id <- if (bitwAnd(flags, 8L) != 0) reader$read_long() else NULL
      self$random_id <- reader$read_long()
      self$send_as <- if (bitwAnd(flags, 4L) != 0) reader$tgread_object() else NULL
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title DeactivateAllUsernamesRequest
#' @description Telegram API request \code{channels.deactivateAllUsernames} (constructor \code{#0a245dd3}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
DeactivateAllUsernamesRequest <- R6::R6Class(
  "DeactivateAllUsernamesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xa245dd3,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field channel Field.
    channel = NULL,

    #  @description Initialize the DeactivateAllUsernamesRequest.
    #  @param channel The input channel.
    initialize = function(channel) {
      self$channel <- channel
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "DeactivateAllUsernamesRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xd3, 0x5d, 0x24, 0x0a)),
        self$channel$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name DeactivateAllUsernamesRequest_from_reader
#'
#' @param reader The reader object.
#' @return An instance of DeactivateAllUsernamesRequest.
#' @noRd
DeactivateAllUsernamesRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  DeactivateAllUsernamesRequest$new(channel = channel)
}

#' @title DeleteChannelRequest
#' @description Telegram API request \code{channels.deleteChannel} (constructor \code{#c0111fe3}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
DeleteChannelRequest <- R6::R6Class(
  "DeleteChannelRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xc0111fe3,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,

    #  @description Initialize the DeleteChannelRequest.
    #  @param channel The input channel.
    initialize = function(channel) {
      self$channel <- channel
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "DeleteChannelRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xe3, 0x1f, 0x11, 0xc0)),
        self$channel$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name DeleteChannelRequest_from_reader
#'
#' @param reader The reader object.
#' @return An instance of DeleteChannelRequest.
#' @noRd
DeleteChannelRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  DeleteChannelRequest$new(channel = channel)
}


#' @title DeleteHistoryRequest
#' @description Telegram API request \code{channels.deleteHistory} (constructor \code{#9baa9647}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
DeleteHistoryRequest <- R6::R6Class(
  "DeleteHistoryRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x9baa9647,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field max_id Field.
    max_id = NULL,
    #  @field for_everyone Field.
    for_everyone = NULL,

    #  @description Initialize the DeleteHistoryRequest.
    #  @param channel The input channel.
    #  @param max_id The maximum message ID to delete up to.
    #  @param for_everyone Whether to delete for everyone.
    initialize = function(channel, max_id, for_everyone = NULL) {
      self$channel <- channel
      self$max_id <- max_id
      self$for_everyone <- for_everyone
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "DeleteHistoryRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        max_id = self$max_id,
        for_everyone = self$for_everyone
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$for_everyone) || !self$for_everyone) 0 else 1
      c(
        as.raw(c(0x47, 0x96, 0xaa, 0x9b)),
        pack("<I", flags),
        self$channel$bytes(),
        pack("<i", self$max_id)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name DeleteHistoryRequest_from_reader
#'
#' @param reader The reader object.
#' @return An instance of DeleteHistoryRequest.
#' @noRd
DeleteHistoryRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  for_everyone <- (flags & 1) != 0
  channel <- reader$tgread_object()
  max_id <- reader$read_int()
  DeleteHistoryRequest$new(channel = channel, max_id = max_id, for_everyone = for_everyone)
}

#' @title DeleteMessagesRequest
#' @description Telegram API request \code{channels.deleteMessages} (constructor \code{#84c1fd4e}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
DeleteMessagesRequest <- R6::R6Class(
  "DeleteMessagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x84c1fd4e,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xced3c06e,
    #  @field channel Field.
    channel = NULL,
    #  @field id Field.
    id = NULL,

    #  @description Initialize the DeleteMessagesRequest.
    #  @param channel The input channel.
    #  @param id The list of message IDs to delete.
    initialize = function(channel, id) {
      self$channel <- channel
      self$id <- id
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "DeleteMessagesRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        id = if (is.null(self$id)) list() else self$id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x4e, 0xfd, 0xc1, 0x84)),
        self$channel$bytes(),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        pack("<i", length(self$id)),
        do.call(c, lapply(self$id, function(x) pack("<i", x)))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name DeleteMessagesRequest_from_reader
#'
#' @param reader The reader object.
#' @return An instance of DeleteMessagesRequest.
#' @noRd
DeleteMessagesRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  reader$read_int()
  id <- list()
  for (i in seq_len(reader$read_int())) {
    x <- reader$read_int()
    id <- c(id, x)
  }
  DeleteMessagesRequest$new(channel = channel, id = id)
}

#' @title DeleteParticipantHistoryRequest
#' @description Telegram API request \code{channels.deleteParticipantHistory} (constructor \code{#367544db}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
DeleteParticipantHistoryRequest <- R6::R6Class(
  "DeleteParticipantHistoryRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x367544db,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x2c49c116,
    #  @field channel Field.
    channel = NULL,
    #  @field participant Field.
    participant = NULL,

    #  @description Initialize the DeleteParticipantHistoryRequest.
    #  @param channel The input channel.
    #  @param participant The input participant.
    initialize = function(channel, participant) {
      self$channel <- channel
      self$participant <- participant
    },

    #  @description Resolve the channel and participant entities.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
      self$participant <- utils$get_input_peer(client$get_input_entity(self$participant))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "DeleteParticipantHistoryRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        participant = if (inherits(self$participant, "TLObject")) self$participant$to_dict() else self$participant
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xdb, 0x44, 0x75, 0x36)),
        self$channel$bytes(),
        self$participant$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name DeleteParticipantHistoryRequest_from_reader
#'
#' @param reader The reader object.
#' @return An instance of DeleteParticipantHistoryRequest.
#' @noRd
DeleteParticipantHistoryRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  participant <- reader$tgread_object()
  DeleteParticipantHistoryRequest$new(channel = channel, participant = participant)
}


#' @title DeleteTopicHistoryRequest
#' @description Telegram API request \code{messages.deleteTopicHistory} (constructor \code{#d2816f10}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
DeleteTopicHistoryRequest <- R6::R6Class("DeleteTopicHistoryRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0xd2816f10,
    SUBCLASS_OF_ID = 0x2c49c116,
    peer = NULL,
    top_msg_id = NULL,
    initialize = function(peer, top_msg_id) {
      self$peer <- peer
      self$top_msg_id <- top_msg_id
    },
    resolve = function(client, utils) {
      if (!is.null(self$peer)) self$peer <- tryCatch(utils$get_input_peer(client$get_input_entity(self$peer)), error = function(e) self$peer)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "DeleteTopicHistoryRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "top_msg_id" = if (inherits(self$top_msg_id, "TLObject")) self$top_msg_id$to_dict() else self$top_msg_id
      )
    },
    to_list = function() {
      list(
        `_` = "DeleteTopicHistoryRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "top_msg_id" = if (inherits(self$top_msg_id, "TLObject")) self$top_msg_id$to_dict() else self$top_msg_id
      )
    },
    bytes = function() {
      c(
        as.raw(c(0x10, 0x6f, 0x81, 0xd2)),
        self$peer$bytes(),
        pack("<i", self$top_msg_id)
      )
    },
    serialize = function() self$bytes()
  ),
  private = list(
    from_reader = function(reader) {
      self$peer <- reader$tgread_object()
      self$top_msg_id <- reader$read_int()
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title EditAdminRequest
#' @description Telegram API request \code{channels.editAdmin} (constructor \code{#9a98ad68}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
EditAdminRequest <- R6::R6Class("EditAdminRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0x9a98ad68,
    SUBCLASS_OF_ID = 0x8af52aac,
    channel = NULL,
    user_id = NULL,
    admin_rights = NULL,
    rank = NULL,
    initialize = function(channel, user_id, admin_rights, rank = NULL) {
      self$channel <- channel
      self$user_id <- user_id
      self$admin_rights <- admin_rights
      self$rank <- rank
    },
    resolve = function(client, utils) {
      if (!is.null(self$channel)) self$channel <- tryCatch(utils$get_input_channel(client$get_input_entity(self$channel)), error = function(e) self$channel)
      if (!is.null(self$user_id)) self$user_id <- tryCatch(utils$get_input_user(client$get_input_entity(self$user_id)), error = function(e) self$user_id)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "EditAdminRequest",
        "channel" = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        "user_id" = if (inherits(self$user_id, "TLObject")) self$user_id$to_dict() else self$user_id,
        "admin_rights" = if (inherits(self$admin_rights, "TLObject")) self$admin_rights$to_dict() else self$admin_rights,
        "rank" = if (inherits(self$rank, "TLObject")) self$rank$to_dict() else self$rank
      )
    },
    to_list = function() {
      list(
        `_` = "EditAdminRequest",
        "channel" = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        "user_id" = if (inherits(self$user_id, "TLObject")) self$user_id$to_dict() else self$user_id,
        "admin_rights" = if (inherits(self$admin_rights, "TLObject")) self$admin_rights$to_dict() else self$admin_rights,
        "rank" = if (inherits(self$rank, "TLObject")) self$rank$to_dict() else self$rank
      )
    },
    bytes = function() {
      flags <- 0L
      if (!is.null(self$rank)) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x68, 0xad, 0x98, 0x9a)),
        pack("<I", flags),
        self$channel$bytes(),
        self$user_id$bytes(),
        self$admin_rights$bytes(),
        if (!is.null(self$rank)) serialize_bytes(self$rank) else raw(0)
      )
    },
    serialize = function() self$bytes()
  ),
  private = list(
    from_reader = function(reader) {
      flags <- reader$read_int()
      self$channel <- reader$tgread_object()
      self$user_id <- reader$tgread_object()
      self$admin_rights <- reader$tgread_object()
      self$rank <- if (bitwAnd(flags, 1L) != 0) reader$tgread_string() else NULL
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title EditBannedRequest
#' @description Telegram API request \code{channels.editBanned} (constructor \code{#96e6cd81}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
EditBannedRequest <- R6::R6Class(
  "EditBannedRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x96e6cd81,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field participant Field.
    participant = NULL,
    #  @field banned_rights Field.
    banned_rights = NULL,

    #  @description Initialize the EditBannedRequest.
    #  @param channel The input channel.
    #  @param participant The input participant.
    #  @param banned_rights The chat banned rights.
    initialize = function(channel, participant, banned_rights) {
      self$channel <- channel
      self$participant <- participant
      self$banned_rights <- banned_rights
    },

    #  @description Resolve the channel and participant entities.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
      self$participant <- utils$get_input_peer(client$get_input_entity(self$participant))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "EditBannedRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        participant = if (inherits(self$participant, "TLObject")) self$participant$to_dict() else self$participant,
        banned_rights = if (inherits(self$banned_rights, "TLObject")) self$banned_rights$to_dict() else self$banned_rights
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x81, 0xcd, 0xe6, 0x96)),
        self$channel$bytes(),
        self$participant$bytes(),
        self$banned_rights$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name EditBannedRequest_from_reader
#' @param reader The reader object.
#' @return An instance of EditBannedRequest.
#' @noRd
EditBannedRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  participant <- reader$tgread_object()
  banned_rights <- reader$tgread_object()
  EditBannedRequest$new(channel = channel, participant = participant, banned_rights = banned_rights)
}


#' @title EditCreatorRequest
#' @description Represents a request to edit the creator of a channel.
#' @noRd
EditCreatorRequest <- R6::R6Class(
  "EditCreatorRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x8f38cd1f,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field user_id Field.
    user_id = NULL,
    #  @field password Field.
    password = NULL,

    #  @description Initialize the EditCreatorRequest.
    #  @param channel The input channel.
    #  @param user_id The input user ID.
    #  @param password The input check password SRP.
    initialize = function(channel, user_id, password) {
      self$channel <- channel
      self$user_id <- user_id
      self$password <- password
    },

    #  @description Resolve the channel and user_id entities.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
      self$user_id <- utils$get_input_user(client$get_input_entity(self$user_id))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "EditCreatorRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        user_id = if (inherits(self$user_id, "TLObject")) self$user_id$to_dict() else self$user_id,
        password = if (inherits(self$password, "TLObject")) self$password$to_dict() else self$password
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x1f, 0xcd, 0x38, 0x8f)),
        self$channel$bytes(),
        self$user_id$bytes(),
        self$password$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name EditCreatorRequest_from_reader
#' @param reader The reader object.
#' @return An instance of EditCreatorRequest.
#' @noRd
EditCreatorRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  user_id <- reader$tgread_object()
  password <- reader$tgread_object()
  EditCreatorRequest$new(channel = channel, user_id = user_id, password = password)
}

#' @title EditForumTopicRequest
#' @description Telegram API request \code{messages.editForumTopic} (constructor \code{#cecc1134}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
EditForumTopicRequest <- R6::R6Class("EditForumTopicRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0xcecc1134,
    SUBCLASS_OF_ID = 0x8af52aac,
    peer = NULL,
    topic_id = NULL,
    title = NULL,
    icon_emoji_id = NULL,
    closed = NULL,
    hidden = NULL,
    initialize = function(peer, topic_id, title = NULL, icon_emoji_id = NULL, closed = NULL, hidden = NULL) {
      self$peer <- peer
      self$topic_id <- topic_id
      self$title <- title
      self$icon_emoji_id <- icon_emoji_id
      self$closed <- closed
      self$hidden <- hidden
    },
    resolve = function(client, utils) {
      if (!is.null(self$peer)) self$peer <- tryCatch(utils$get_input_peer(client$get_input_entity(self$peer)), error = function(e) self$peer)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "EditForumTopicRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "topic_id" = if (inherits(self$topic_id, "TLObject")) self$topic_id$to_dict() else self$topic_id,
        "title" = if (inherits(self$title, "TLObject")) self$title$to_dict() else self$title,
        "icon_emoji_id" = if (inherits(self$icon_emoji_id, "TLObject")) self$icon_emoji_id$to_dict() else self$icon_emoji_id,
        "closed" = if (inherits(self$closed, "TLObject")) self$closed$to_dict() else self$closed,
        "hidden" = if (inherits(self$hidden, "TLObject")) self$hidden$to_dict() else self$hidden
      )
    },
    to_list = function() {
      list(
        `_` = "EditForumTopicRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "topic_id" = if (inherits(self$topic_id, "TLObject")) self$topic_id$to_dict() else self$topic_id,
        "title" = if (inherits(self$title, "TLObject")) self$title$to_dict() else self$title,
        "icon_emoji_id" = if (inherits(self$icon_emoji_id, "TLObject")) self$icon_emoji_id$to_dict() else self$icon_emoji_id,
        "closed" = if (inherits(self$closed, "TLObject")) self$closed$to_dict() else self$closed,
        "hidden" = if (inherits(self$hidden, "TLObject")) self$hidden$to_dict() else self$hidden
      )
    },
    bytes = function() {
      flags <- 0L
      if (!is.null(self$title)) flags <- bitwOr(flags, 1L)
      if (!is.null(self$icon_emoji_id)) flags <- bitwOr(flags, 2L)
      if (!is.null(self$closed)) flags <- bitwOr(flags, 4L)
      if (!is.null(self$hidden)) flags <- bitwOr(flags, 8L)
      c(
        as.raw(c(0x34, 0x11, 0xcc, 0xce)),
        pack("<I", flags),
        self$peer$bytes(),
        pack("<i", self$topic_id),
        if (!is.null(self$title)) serialize_bytes(self$title) else raw(0),
        if (!is.null(self$icon_emoji_id)) packInt64(self$icon_emoji_id) else raw(0),
        if (!is.null(self$closed)) if (isTRUE(self$closed)) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc)) else raw(0),
        if (!is.null(self$hidden)) if (isTRUE(self$hidden)) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc)) else raw(0)
      )
    },
    serialize = function() self$bytes()
  ),
  private = list(
    from_reader = function(reader) {
      flags <- reader$read_int()
      self$peer <- reader$tgread_object()
      self$topic_id <- reader$read_int()
      self$title <- if (bitwAnd(flags, 1L) != 0) reader$tgread_string() else NULL
      self$icon_emoji_id <- if (bitwAnd(flags, 2L) != 0) reader$read_long() else NULL
      self$closed <- if (bitwAnd(flags, 4L) != 0) reader$tgread_bool() else NULL
      self$hidden <- if (bitwAnd(flags, 8L) != 0) reader$tgread_bool() else NULL
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title EditLocationRequest
#' @description Telegram API request \code{channels.editLocation} (constructor \code{#58e63f6d}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
EditLocationRequest <- R6::R6Class(
  "EditLocationRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x58e63f6d,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field channel Field.
    channel = NULL,
    #  @field geo_point Field.
    geo_point = NULL,
    #  @field address Field.
    address = NULL,

    #  @description Initialize the EditLocationRequest.
    #  @param channel The input channel.
    #  @param geo_point The input geo point.
    #  @param address The address.
    initialize = function(channel, geo_point, address) {
      self$channel <- channel
      self$geo_point <- geo_point
      self$address <- address
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "EditLocationRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        geo_point = if (inherits(self$geo_point, "TLObject")) self$geo_point$to_dict() else self$geo_point,
        address = self$address
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x6d, 0x3f, 0xe6, 0x58)),
        self$channel$bytes(),
        self$geo_point$bytes(),
        self$serialize_bytes(self$address)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name EditLocationRequest_from_reader
#' @param reader The reader object.
#' @return An instance of EditLocationRequest.
#' @noRd
EditLocationRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  geo_point <- reader$tgread_object()
  address <- reader$tgread_string()
  EditLocationRequest$new(channel = channel, geo_point = geo_point, address = address)
}


#' @title EditPhotoRequest
#' @description Telegram API request \code{channels.editPhoto} (constructor \code{#f12e57c9}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
EditPhotoRequest <- R6::R6Class(
  "EditPhotoRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xf12e57c9,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field photo Field.
    photo = NULL,

    #  @description Initialize the EditPhotoRequest.
    #  @param channel The input channel.
    #  @param photo The input chat photo.
    initialize = function(channel, photo) {
      self$channel <- channel
      self$photo <- photo
    },

    #  @description Resolve the channel and photo entities.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
      self$photo <- utils$get_input_chat_photo(self$photo)
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "EditPhotoRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        photo = if (inherits(self$photo, "TLObject")) self$photo$to_dict() else self$photo
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xc9, 0x57, 0x2e, 0xf1)),
        self$channel$bytes(),
        self$photo$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name EditPhotoRequest_from_reader
#' @param reader The reader object.
#' @return An instance of EditPhotoRequest.
#' @noRd
EditPhotoRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  photo <- reader$tgread_object()
  EditPhotoRequest$new(channel = channel, photo = photo)
}

#' @title EditTitleRequest
#' @description Telegram API request \code{channels.editTitle} (constructor \code{#566decd0}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
EditTitleRequest <- R6::R6Class(
  "EditTitleRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x566decd0,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field title Field.
    title = NULL,

    #  @description Initialize the EditTitleRequest.
    #  @param channel The input channel.
    #  @param title The new title.
    initialize = function(channel, title) {
      self$channel <- channel
      self$title <- title
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "EditTitleRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        title = self$title
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xd0, 0xec, 0x6d, 0x56)),
        self$channel$bytes(),
        self$serialize_bytes(self$title)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name EditTitleRequest_from_reader
#' @param reader The reader object.
#' @return An instance of EditTitleRequest.
#' @noRd
EditTitleRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  title <- reader$tgread_string()
  EditTitleRequest$new(channel = channel, title = title)
}

#' @title ExportMessageLinkRequest
#' @description Telegram API request \code{channels.exportMessageLink} (constructor \code{#e63fadeb}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ExportMessageLinkRequest <- R6::R6Class(
  "ExportMessageLinkRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xe63fadeb,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xdee644cc,
    #  @field channel Field.
    channel = NULL,
    #  @field id Field.
    id = NULL,
    #  @field grouped Field.
    grouped = NULL,
    #  @field thread Field.
    thread = NULL,

    #  @description Initialize the ExportMessageLinkRequest.
    #  @param channel The input channel.
    #  @param id The message ID.
    #  @param grouped Whether to include grouped messages.
    #  @param thread Whether to include thread.
    initialize = function(channel, id, grouped = NULL, thread = NULL) {
      self$channel <- channel
      self$id <- id
      self$grouped <- grouped
      self$thread <- thread
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ExportMessageLinkRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        id = self$id,
        grouped = self$grouped,
        thread = self$thread
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$grouped) || !self$grouped) 0 else 1) |
        (if (is.null(self$thread) || !self$thread) 0 else 2)
      c(
        as.raw(c(0xeb, 0xad, 0x3f, 0xe6)),
        pack("<I", flags),
        self$channel$bytes(),
        pack("<i", self$id)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name ExportMessageLinkRequest_from_reader
#' @param reader The reader object.
#' @return An instance of ExportMessageLinkRequest.
#' @noRd
ExportMessageLinkRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  grouped <- (flags & 1) != 0
  thread <- (flags & 2) != 0
  channel <- reader$tgread_object()
  id <- reader$read_int()
  ExportMessageLinkRequest$new(channel = channel, id = id, grouped = grouped, thread = thread)
}


#' @title GetAdminLogRequest
#' @description Telegram API request \code{channels.getAdminLog} (constructor \code{#33ddf480}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetAdminLogRequest <- R6::R6Class(
  "GetAdminLogRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x33ddf480,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x51f076bc,
    #  @field channel Field.
    channel = NULL,
    #  @field q Field.
    q = NULL,
    #  @field max_id Field.
    max_id = NULL,
    #  @field min_id Field.
    min_id = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field events_filter Field.
    events_filter = NULL,
    #  @field admins Field.
    admins = NULL,

    #  @description Initialize the GetAdminLogRequest.
    #  @param channel The input channel.
    #  @param q The query string.
    #  @param max_id The maximum ID.
    #  @param min_id The minimum ID.
    #  @param limit The limit on the number of results.
    #  @param events_filter The events filter (optional).
    #  @param admins The list of admin users (optional).
    initialize = function(channel, q, max_id, min_id, limit, events_filter = NULL, admins = NULL) {
      self$channel <- channel
      self$q <- q
      self$max_id <- max_id
      self$min_id <- min_id
      self$limit <- limit
      self$events_filter <- events_filter
      self$admins <- admins
    },

    #  @description Resolve the channel and admins entities.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
      if (!is.null(self$admins)) {
        tmp <- list()
        for (x in self$admins) {
          tmp <- c(tmp, utils$get_input_user(client$get_input_entity(x)))
        }
        self$admins <- tmp
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "GetAdminLogRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        q = self$q,
        max_id = self$max_id,
        min_id = self$min_id,
        limit = self$limit,
        events_filter = if (inherits(self$events_filter, "TLObject")) self$events_filter$to_dict() else self$events_filter,
        admins = if (is.null(self$admins)) list() else lapply(self$admins, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$events_filter) || !self$events_filter) 0 else 1) |
        (if (is.null(self$admins) || !self$admins) 0 else 2)
      c(
        as.raw(c(0x80, 0xf4, 0xdd, 0x33)),
        pack("<I", flags),
        self$channel$bytes(),
        self$serialize_bytes(self$q),
        if (!is.null(self$events_filter) && self$events_filter) self$events_filter$bytes() else raw(0),
        if (!is.null(self$admins) && self$admins) c(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$admins)), do.call(c, lapply(self$admins, function(x) x$bytes()))) else raw(0),
        pack("<q", self$max_id),
        pack("<q", self$min_id),
        pack("<i", self$limit)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name GetAdminLogRequest_from_reader
#' @param reader The reader object.
#' @return An instance of GetAdminLogRequest.
#' @noRd
GetAdminLogRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  channel <- reader$tgread_object()
  q <- reader$tgread_string()
  events_filter <- if ((flags & 1) != 0) reader$tgread_object() else NULL
  admins <- if ((flags & 2) != 0) {
    reader$read_int()
    tmp <- list()
    for (i in seq_len(reader$read_int())) {
      x <- reader$tgread_object()
      tmp <- c(tmp, x)
    }
    tmp
  } else {
    NULL
  }
  max_id <- reader$read_long()
  min_id <- reader$read_long()
  limit <- reader$read_int()
  GetAdminLogRequest$new(channel = channel, q = q, max_id = max_id, min_id = min_id, limit = limit, events_filter = events_filter, admins = admins)
}

#' @title GetAdminedPublicChannelsRequest
#' @description Telegram API request \code{channels.getAdminedPublicChannels} (constructor \code{#f8b036af}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetAdminedPublicChannelsRequest <- R6::R6Class(
  "GetAdminedPublicChannelsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xf8b036af,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x99d5cb14,
    #  @field by_location Field.
    by_location = NULL,
    #  @field check_limit Field.
    check_limit = NULL,
    #  @field for_personal Field.
    for_personal = NULL,

    #  @description Initialize the GetAdminedPublicChannelsRequest.
    #  @param by_location Whether to filter by location.
    #  @param check_limit Whether to check the limit.
    #  @param for_personal Whether for personal use.
    initialize = function(by_location = NULL, check_limit = NULL, for_personal = NULL) {
      self$by_location <- by_location
      self$check_limit <- check_limit
      self$for_personal <- for_personal
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "GetAdminedPublicChannelsRequest",
        by_location = self$by_location,
        check_limit = self$check_limit,
        for_personal = self$for_personal
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$by_location) || !self$by_location) 0 else 1) |
        (if (is.null(self$check_limit) || !self$check_limit) 0 else 2) |
        (if (is.null(self$for_personal) || !self$for_personal) 0 else 4)
      c(
        as.raw(c(0xaf, 0x36, 0xb0, 0xf8)),
        pack("<I", flags)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name GetAdminedPublicChannelsRequest_from_reader
#' @param reader The reader object.
#' @return An instance of GetAdminedPublicChannelsRequest.
#' @noRd
GetAdminedPublicChannelsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  by_location <- (flags & 1) != 0
  check_limit <- (flags & 2) != 0
  for_personal <- (flags & 4) != 0
  GetAdminedPublicChannelsRequest$new(by_location = by_location, check_limit = check_limit, for_personal = for_personal)
}

#' @title GetChannelRecommendationsRequest
#' @description Telegram API request \code{channels.getChannelRecommendations} (constructor \code{#25a71742}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetChannelRecommendationsRequest <- R6::R6Class(
  "GetChannelRecommendationsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x25a71742,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x99d5cb14,
    #  @field channel Field.
    channel = NULL,

    #  @description Initialize the GetChannelRecommendationsRequest.
    #  @param channel The input channel (optional).
    initialize = function(channel = NULL) {
      self$channel <- channel
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      if (!is.null(self$channel)) {
        self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "GetChannelRecommendationsRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$channel) || !self$channel) 0 else 1
      c(
        as.raw(c(0x42, 0x17, 0xa7, 0x25)),
        pack("<I", flags),
        if (!is.null(self$channel) && self$channel) self$channel$bytes() else raw(0)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name GetChannelRecommendationsRequest_from_reader
#' @param reader The reader object.
#' @return An instance of GetChannelRecommendationsRequest.
#' @noRd
GetChannelRecommendationsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  channel <- if ((flags && 1) != 0) reader$tgread_object() else NULL
  GetChannelRecommendationsRequest$new(channel = channel)
}


#' @title GetChannelsRequest
#' @description Telegram API request \code{channels.getChannels} (constructor \code{#0a7f6bbb}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetChannelsRequest <- R6::R6Class(
  "GetChannelsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xa7f6bbb,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x99d5cb14,
    #  @field id Field.
    id = NULL,

    #  @description Initialize the GetChannelsRequest.
    #  @param id The list of input channels.
    initialize = function(id) {
      self$id <- id
    },

    #  @description Resolve the channel entities.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      tmp <- list()
      for (x in self$id) {
        tmp <- c(tmp, utils$get_input_channel(client$get_input_entity(x)))
      }
      self$id <- tmp
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "GetChannelsRequest",
        id = if (is.null(self$id)) list() else lapply(self$id, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xbb, 0x6b, 0x7f, 0x0a)),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        pack("<i", length(self$id)),
        do.call(c, lapply(self$id, function(x) x$bytes()))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name GetChannelsRequest_from_reader
#' @param reader The reader object.
#' @return An instance of GetChannelsRequest.
#' @noRd
GetChannelsRequest$from_reader <- function(reader) {
  reader$read_int()
  id <- list()
  for (i in seq_len(reader$read_int())) {
    x <- reader$tgread_object()
    id <- c(id, x)
  }
  GetChannelsRequest$new(id = id)
}

#' @title GetForumTopicsRequest
#' @description Telegram API request \code{messages.getForumTopics} (constructor \code{#3ba47bff}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetForumTopicsRequest <- R6::R6Class("GetForumTopicsRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0x3ba47bff,
    SUBCLASS_OF_ID = 0x8e1d3e1e,
    peer = NULL,
    q = NULL,
    offset_date = NULL,
    offset_id = NULL,
    offset_topic = NULL,
    limit = NULL,
    initialize = function(peer, q = NULL, offset_date, offset_id, offset_topic, limit) {
      self$peer <- peer
      self$q <- q
      self$offset_date <- offset_date
      self$offset_id <- offset_id
      self$offset_topic <- offset_topic
      self$limit <- limit
    },
    resolve = function(client, utils) {
      if (!is.null(self$peer)) self$peer <- tryCatch(utils$get_input_peer(client$get_input_entity(self$peer)), error = function(e) self$peer)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "GetForumTopicsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "q" = if (inherits(self$q, "TLObject")) self$q$to_dict() else self$q,
        "offset_date" = if (inherits(self$offset_date, "TLObject")) self$offset_date$to_dict() else self$offset_date,
        "offset_id" = if (inherits(self$offset_id, "TLObject")) self$offset_id$to_dict() else self$offset_id,
        "offset_topic" = if (inherits(self$offset_topic, "TLObject")) self$offset_topic$to_dict() else self$offset_topic,
        "limit" = if (inherits(self$limit, "TLObject")) self$limit$to_dict() else self$limit
      )
    },
    to_list = function() {
      list(
        `_` = "GetForumTopicsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "q" = if (inherits(self$q, "TLObject")) self$q$to_dict() else self$q,
        "offset_date" = if (inherits(self$offset_date, "TLObject")) self$offset_date$to_dict() else self$offset_date,
        "offset_id" = if (inherits(self$offset_id, "TLObject")) self$offset_id$to_dict() else self$offset_id,
        "offset_topic" = if (inherits(self$offset_topic, "TLObject")) self$offset_topic$to_dict() else self$offset_topic,
        "limit" = if (inherits(self$limit, "TLObject")) self$limit$to_dict() else self$limit
      )
    },
    bytes = function() {
      flags <- 0L
      if (!is.null(self$q)) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0xff, 0x7b, 0xa4, 0x3b)),
        pack("<I", flags),
        self$peer$bytes(),
        if (!is.null(self$q)) serialize_bytes(self$q) else raw(0),
        pack("<i", self$offset_date),
        pack("<i", self$offset_id),
        pack("<i", self$offset_topic),
        pack("<i", self$limit)
      )
    },
    serialize = function() self$bytes()
  ),
  private = list(
    from_reader = function(reader) {
      flags <- reader$read_int()
      self$peer <- reader$tgread_object()
      self$q <- if (bitwAnd(flags, 1L) != 0) reader$tgread_string() else NULL
      self$offset_date <- reader$read_int()
      self$offset_id <- reader$read_int()
      self$offset_topic <- reader$read_int()
      self$limit <- reader$read_int()
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title GetForumTopicsByIDRequest
#' @description Telegram API request \code{messages.getForumTopicsByID} (constructor \code{#af0a4a08}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetForumTopicsByIDRequest <- R6::R6Class("GetForumTopicsByIDRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0xaf0a4a08,
    SUBCLASS_OF_ID = 0x8e1d3e1e,
    peer = NULL,
    topics = NULL,
    initialize = function(peer, topics) {
      self$peer <- peer
      self$topics <- topics
    },
    resolve = function(client, utils) {
      if (!is.null(self$peer)) self$peer <- tryCatch(utils$get_input_peer(client$get_input_entity(self$peer)), error = function(e) self$peer)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "GetForumTopicsByIDRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "topics" = if (inherits(self$topics, "TLObject")) self$topics$to_dict() else self$topics
      )
    },
    to_list = function() {
      list(
        `_` = "GetForumTopicsByIDRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "topics" = if (inherits(self$topics, "TLObject")) self$topics$to_dict() else self$topics
      )
    },
    bytes = function() {
      c(
        as.raw(c(0x08, 0x4a, 0x0a, 0xaf)),
        self$peer$bytes(),
        c(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$topics)), if (length(self$topics) > 0) do.call(c, lapply(self$topics, function(x) pack("<i", x))) else raw(0))
      )
    },
    serialize = function() self$bytes()
  ),
  private = list(
    from_reader = function(reader) {
      self$peer <- reader$tgread_object()
      self$topics <- { reader$read_int(); n_ <- reader$read_int(); if (n_ > 0) lapply(seq_len(n_), function(.i) reader$read_int()) else list() }
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title GetFullChannelRequest
#' @description Telegram API request \code{channels.getFullChannel} (constructor \code{#08736a09}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetFullChannelRequest <- R6::R6Class(
  "GetFullChannelRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x8736a09,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x225a5109,
    #  @field channel Field.
    channel = NULL,

    #  @description Initialize the GetFullChannelRequest.
    #  @param channel The input channel.
    initialize = function(channel) {
      self$channel <- channel
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "GetFullChannelRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x09, 0x6a, 0x73, 0x08)),
        self$channel$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name GetFullChannelRequest_from_reader
#' @param reader The reader object.
#' @return An instance of GetFullChannelRequest.
#' @noRd
GetFullChannelRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  GetFullChannelRequest$new(channel = channel)
}

#' @title GetGroupsForDiscussionRequest
#' @description Telegram API request \code{channels.getGroupsForDiscussion} (constructor \code{#f5dad378}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetGroupsForDiscussionRequest <- R6::R6Class(
  "GetGroupsForDiscussionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xf5dad378,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x99d5cb14,

    #  @description Initialize the GetGroupsForDiscussionRequest.
    initialize = function() {
      # No parameters
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "GetGroupsForDiscussionRequest"
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      as.raw(c(0x78, 0xd3, 0xda, 0xf5))
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name GetGroupsForDiscussionRequest_from_reader
#' @param reader The reader object.
#' @return An instance of GetGroupsForDiscussionRequest.
#' @noRd
GetGroupsForDiscussionRequest$from_reader <- function(reader) {
  GetGroupsForDiscussionRequest$new()
}

#' @title GetInactiveChannelsRequest
#' @description Telegram API request \code{channels.getInactiveChannels} (constructor \code{#11e831ee}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetInactiveChannelsRequest <- R6::R6Class(
  "GetInactiveChannelsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x11e831ee,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8bf3d7d4,

    #  @description Initialize the GetInactiveChannelsRequest.
    initialize = function() {
      # No parameters
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "GetInactiveChannelsRequest"
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      as.raw(c(0xee, 0x31, 0xe8, 0x11))
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name GetInactiveChannelsRequest_from_reader
#' @param reader The reader object.
#' @return An instance of GetInactiveChannelsRequest.
#' @noRd
GetInactiveChannelsRequest$from_reader <- function(reader) {
  GetInactiveChannelsRequest$new()
}


#' @title GetLeftChannelsRequest
#' @description Telegram API request \code{channels.getLeftChannels} (constructor \code{#8341ecc0}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetLeftChannelsRequest <- R6::R6Class(
  "GetLeftChannelsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x8341ecc0,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x99d5cb14,
    #  @field offset Field.
    offset = NULL,

    #  @description Initialize the GetLeftChannelsRequest.
    #  @param offset The offset for pagination.
    initialize = function(offset) {
      self$offset <- offset
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "GetLeftChannelsRequest",
        offset = self$offset
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xc0, 0xec, 0x41, 0x83)),
        pack("<i", self$offset)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name GetLeftChannelsRequest_from_reader
#' @param reader The reader object.
#' @return An instance of GetLeftChannelsRequest.
#' @noRd
GetLeftChannelsRequest$from_reader <- function(reader) {
  offset <- reader$read_int()
  GetLeftChannelsRequest$new(offset = offset)
}

#' @title GetMessageAuthorRequest
#' @description Telegram API request \code{channels.getMessageAuthor} (constructor \code{#ece2a0e6}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetMessageAuthorRequest <- R6::R6Class(
  "GetMessageAuthorRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xece2a0e6,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x2da17977,
    #  @field channel Field.
    channel = NULL,
    #  @field id Field.
    id = NULL,

    #  @description Initialize the GetMessageAuthorRequest.
    #  @param channel The input channel.
    #  @param id The message ID.
    initialize = function(channel, id) {
      self$channel <- channel
      self$id <- id
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "GetMessageAuthorRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        id = self$id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xe6, 0xa0, 0xe2, 0xec)),
        self$channel$bytes(),
        pack("<I", self$id)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name GetMessageAuthorRequest_from_reader
#' @param reader The reader object.
#' @return An instance of GetMessageAuthorRequest.
#' @noRd
GetMessageAuthorRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  id <- reader$read_int()
  GetMessageAuthorRequest$new(channel = channel, id = id)
}

#' @title GetMessagesRequest
#' @description Telegram API request \code{channels.getMessages} (constructor \code{#ad8c9a23}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetMessagesRequest <- R6::R6Class(
  "GetMessagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xad8c9a23,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xd4b40b5e,
    #  @field channel Field.
    channel = NULL,
    #  @field id Field.
    id = NULL,

    #  @description Initialize the GetMessagesRequest.
    #  @param channel The input channel.
    #  @param id The list of input messages.
    initialize = function(channel, id) {
      self$channel <- channel
      self$id <- id
    },

    #  @description Resolve the channel and messages entities.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
      tmp <- list()
      for (x in self$id) {
        tmp <- c(tmp, utils$get_input_message(x))
      }
      self$id <- tmp
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "GetMessagesRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        id = if (is.null(self$id)) list() else lapply(self$id, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x23, 0x9a, 0x8c, 0xad)),
        self$channel$bytes(),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        pack("<i", length(self$id)),
        do.call(c, lapply(self$id, function(x) x$bytes()))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Preserve channel-specific GetMessagesRequest under a distinct name to avoid
# collisions with messages.GetMessagesRequest defined later.
ChannelsGetMessagesRequest <- GetMessagesRequest

#' Deserialize from a reader.
#' @name GetMessagesRequest_from_reader
#' @param reader The reader object.
#' @return An instance of GetMessagesRequest.
#' @noRd
GetMessagesRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  reader$read_int()
  id <- list()
  for (i in seq_len(reader$read_int())) {
    x <- reader$tgread_object()
    id <- c(id, x)
  }
  GetMessagesRequest$new(channel = channel, id = id)
}


#' @title GetParticipantRequest
#' @description Telegram API request \code{channels.getParticipant} (constructor \code{#a0ab6cc6}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetParticipantRequest <- R6::R6Class(
  "GetParticipantRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xa0ab6cc6,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x6658151a,
    #  @field channel Field.
    channel = NULL,
    #  @field participant Field.
    participant = NULL,

    #  @description Initialize the GetParticipantRequest.
    #  @param channel The input channel.
    #  @param participant The input participant.
    initialize = function(channel, participant) {
      self$channel <- channel
      self$participant <- participant
    },

    #  @description Resolve the channel and participant entities.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
      self$participant <- utils$get_input_peer(client$get_input_entity(self$participant))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "GetParticipantRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        participant = if (inherits(self$participant, "TLObject")) self$participant$to_dict() else self$participant
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xc6, 0x6c, 0xab, 0xa0)),
        self$channel$bytes(),
        self$participant$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name GetParticipantRequest_from_reader
#' @param reader The reader object.
#' @return An instance of GetParticipantRequest.
#' @noRd
GetParticipantRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  participant <- reader$tgread_object()
  GetParticipantRequest$new(channel = channel, participant = participant)
}

#' @title GetParticipantsRequest
#' @description Telegram API request \code{channels.getParticipants} (constructor \code{#77ced9d0}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetParticipantsRequest <- R6::R6Class(
  "GetParticipantsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x77ced9d0,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xe60a6e64,
    #  @field channel Field.
    channel = NULL,
    #  @field filter Field.
    filter = NULL,
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field hash Field.
    hash = NULL,

    #  @description Initialize the GetParticipantsRequest.
    #  @param channel The input channel.
    #  @param filter The filter for participants.
    #  @param offset The offset for pagination.
    #  @param limit The limit on the number of results.
    #  @param hash The hash for caching.
    initialize = function(channel, filter, offset, limit, hash) {
      self$channel <- channel
      self$filter <- filter
      self$offset <- offset
      self$limit <- limit
      self$hash <- hash
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "GetParticipantsRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        filter = if (inherits(self$filter, "TLObject")) self$filter$to_dict() else self$filter,
        offset = self$offset,
        limit = self$limit,
        hash = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xd0, 0xd9, 0xce, 0x77)),
        self$channel$bytes(),
        self$filter$bytes(),
        pack("<i", self$offset),
        pack("<i", self$limit),
        pack("<q", self$hash)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name GetParticipantsRequest_from_reader
#' @param reader The reader object.
#' @return An instance of GetParticipantsRequest.
#' @noRd
GetParticipantsRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  filter <- reader$tgread_object()
  offset <- reader$read_int()
  limit <- reader$read_int()
  hash <- reader$read_long()
  GetParticipantsRequest$new(channel = channel, filter = filter, offset = offset, limit = limit, hash = hash)
}

#' @title GetSendAsRequest
#' @description Telegram API request \code{channels.getSendAs} (constructor \code{#e785a43f}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetSendAsRequest <- R6::R6Class(
  "GetSendAsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xe785a43f,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x38cb8d21,
    #  @field peer Field.
    peer = NULL,
    #  @field for_paid_reactions Field.
    for_paid_reactions = NULL,

    #  @description Initialize the GetSendAsRequest.
    #  @param peer The input peer.
    #  @param for_paid_reactions Whether for paid reactions.
    initialize = function(peer, for_paid_reactions = NULL) {
      self$peer <- peer
      self$for_paid_reactions <- for_paid_reactions
    },

    #  @description Resolve the peer entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "GetSendAsRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        for_paid_reactions = self$for_paid_reactions
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$for_paid_reactions) || !self$for_paid_reactions) 0 else 1
      c(
        as.raw(c(0x3f, 0xa4, 0x85, 0xe7)),
        pack("<I", flags),
        self$peer$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name GetSendAsRequest_from_reader
#' @param reader The reader object.
#' @return An instance of GetSendAsRequest.
#' @noRd
GetSendAsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  for_paid_reactions <- (flags & 1) != 0
  peer <- reader$tgread_object()
  GetSendAsRequest$new(peer = peer, for_paid_reactions = for_paid_reactions)
}


#' @title InviteToChannelRequest
#' @description Telegram API request \code{channels.inviteToChannel} (constructor \code{#c9e33d54}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
InviteToChannelRequest <- R6::R6Class(
  "InviteToChannelRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xc9e33d54,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x3dbe90a1,
    #  @field channel Field.
    channel = NULL,
    #  @field users Field.
    users = NULL,

    #  @description Initialize the InviteToChannelRequest.
    #  @param channel The input channel.
    #  @param users The list of input users to invite.
    initialize = function(channel, users) {
      self$channel <- channel
      self$users <- users
    },

    #  @description Resolve the channel and users entities.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
      tmp <- list()
      for (x in self$users) {
        tmp <- c(tmp, utils$get_input_user(client$get_input_entity(x)))
      }
      self$users <- tmp
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "InviteToChannelRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        users = if (is.null(self$users)) list() else lapply(self$users, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x54, 0x3d, 0xe3, 0xc9)),
        self$channel$bytes(),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        pack("<i", length(self$users)),
        do.call(c, lapply(self$users, function(x) x$bytes()))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name InviteToChannelRequest_from_reader
#' @param reader The reader object.
#' @return An instance of InviteToChannelRequest.
#' @noRd
InviteToChannelRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  reader$read_int()
  users <- list()
  for (i in seq_len(reader$read_int())) {
    x <- reader$tgread_object()
    users <- c(users, x)
  }
  InviteToChannelRequest$new(channel = channel, users = users)
}

#' @title JoinChannelRequest
#' @description Telegram API request \code{channels.joinChannel} (constructor \code{#7f6a1e22}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
JoinChannelRequest <- R6::R6Class("JoinChannelRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0x7f6a1e22,
    SUBCLASS_OF_ID = 0x5d0ff992,
    channel = NULL,
    initialize = function(channel) {
      self$channel <- channel
    },
    resolve = function(client, utils) {
      if (!is.null(self$channel)) self$channel <- tryCatch(utils$get_input_channel(client$get_input_entity(self$channel)), error = function(e) self$channel)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "JoinChannelRequest",
        "channel" = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel
      )
    },
    to_list = function() {
      list(
        `_` = "JoinChannelRequest",
        "channel" = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel
      )
    },
    bytes = function() {
      c(
        as.raw(c(0x22, 0x1e, 0x6a, 0x7f)),
        self$channel$bytes()
      )
    },
    serialize = function() self$bytes()
  ),
  private = list(
    from_reader = function(reader) {
      self$channel <- reader$tgread_object()
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title LeaveChannelRequest
#' @description Telegram API request \code{channels.leaveChannel} (constructor \code{#f836aa95}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
LeaveChannelRequest <- R6::R6Class(
  "LeaveChannelRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xf836aa95,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,

    #  @description Initialize the LeaveChannelRequest.
    #  @param channel The input channel.
    initialize = function(channel) {
      self$channel <- channel
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "LeaveChannelRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x95, 0xaa, 0x36, 0xf8)),
        self$channel$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name LeaveChannelRequest_from_reader
#' @param reader The reader object.
#' @return An instance of LeaveChannelRequest.
#' @noRd
LeaveChannelRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  LeaveChannelRequest$new(channel = channel)
}


#' @title ReadHistoryRequest
#' @description Telegram API request \code{channels.readHistory} (constructor \code{#cc104937}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ReadHistoryRequest <- R6::R6Class(
  "ReadHistoryRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xcc104937,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field channel Field.
    channel = NULL,
    #  @field max_id Field.
    max_id = NULL,

    #  @description Initialize the ReadHistoryRequest.
    #  @param channel The input channel.
    #  @param max_id The maximum message ID to read up to.
    initialize = function(channel, max_id) {
      self$channel <- channel
      self$max_id <- max_id
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ReadHistoryRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        max_id = self$max_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x37, 0x49, 0x10, 0xcc)),
        self$channel$bytes(),
        pack("<i", self$max_id)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name ReadHistoryRequest_from_reader
#' @param reader The reader object.
#' @return An instance of ReadHistoryRequest.
#' @noRd
ReadHistoryRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  max_id <- reader$read_int()
  ReadHistoryRequest$new(channel = channel, max_id = max_id)
}

#' @title ReadMessageContentsRequest
#' @description Telegram API request \code{channels.readMessageContents} (constructor \code{#eab5dc38}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ReadMessageContentsRequest <- R6::R6Class(
  "ReadMessageContentsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xeab5dc38,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field channel Field.
    channel = NULL,
    #  @field id Field.
    id = NULL,

    #  @description Initialize the ReadMessageContentsRequest.
    #  @param channel The input channel.
    #  @param id The list of message IDs to read.
    initialize = function(channel, id) {
      self$channel <- channel
      self$id <- id
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ReadMessageContentsRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        id = if (is.null(self$id)) list() else self$id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x38, 0xdc, 0xb5, 0xea)),
        self$channel$bytes(),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        pack("<i", length(self$id)),
        do.call(c, lapply(self$id, function(x) pack("<i", x)))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name ReadMessageContentsRequest_from_reader
#' @param reader The reader object.
#' @return An instance of ReadMessageContentsRequest.
#' @noRd
ReadMessageContentsRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  reader$read_int()
  id <- list()
  for (i in seq_len(reader$read_int())) {
    x <- reader$read_int()
    id <- c(id, x)
  }
  ReadMessageContentsRequest$new(channel = channel, id = id)
}


#' @title ReorderPinnedForumTopicsRequest
#' @description Telegram API request \code{messages.reorderPinnedForumTopics} (constructor \code{#0e7841f0}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ReorderPinnedForumTopicsRequest <- R6::R6Class("ReorderPinnedForumTopicsRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0x0e7841f0,
    SUBCLASS_OF_ID = 0x8af52aac,
    force = NULL,
    peer = NULL,
    order = NULL,
    initialize = function(force = NULL, peer, order) {
      self$force <- force
      self$peer <- peer
      self$order <- order
    },
    resolve = function(client, utils) {
      if (!is.null(self$peer)) self$peer <- tryCatch(utils$get_input_peer(client$get_input_entity(self$peer)), error = function(e) self$peer)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "ReorderPinnedForumTopicsRequest",
        "force" = if (inherits(self$force, "TLObject")) self$force$to_dict() else self$force,
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "order" = if (inherits(self$order, "TLObject")) self$order$to_dict() else self$order
      )
    },
    to_list = function() {
      list(
        `_` = "ReorderPinnedForumTopicsRequest",
        "force" = if (inherits(self$force, "TLObject")) self$force$to_dict() else self$force,
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "order" = if (inherits(self$order, "TLObject")) self$order$to_dict() else self$order
      )
    },
    bytes = function() {
      flags <- 0L
      if (isTRUE(self$force)) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0xf0, 0x41, 0x78, 0x0e)),
        pack("<I", flags),
        self$peer$bytes(),
        c(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$order)), if (length(self$order) > 0) do.call(c, lapply(self$order, function(x) pack("<i", x))) else raw(0))
      )
    },
    serialize = function() self$bytes()
  ),
  private = list(
    from_reader = function(reader) {
      flags <- reader$read_int()
      self$force <- bitwAnd(flags, 1L) != 0
      self$peer <- reader$tgread_object()
      self$order <- { reader$read_int(); n_ <- reader$read_int(); if (n_ > 0) lapply(seq_len(n_), function(.i) reader$read_int()) else list() }
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title ReorderUsernamesRequest
#' @description Telegram API request \code{channels.reorderUsernames} (constructor \code{#b45ced1d}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ReorderUsernamesRequest <- R6::R6Class(
  "ReorderUsernamesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xb45ced1d,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field channel Field.
    channel = NULL,
    #  @field order Field.
    order = NULL,

    #  @description Initialize the ReorderUsernamesRequest.
    #  @param channel The input channel.
    #  @param order The list of usernames in the new order.
    initialize = function(channel, order) {
      self$channel <- channel
      self$order <- order
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ReorderUsernamesRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        order = if (is.null(self$order)) list() else self$order
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x1d, 0xed, 0x5c, 0xb4)),
        self$channel$bytes(),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        pack("<i", length(self$order)),
        do.call(c, lapply(self$order, function(x) self$serialize_bytes(x)))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name ReorderUsernamesRequest_from_reader
#' @param reader The reader object.
#' @return An instance of ReorderUsernamesRequest.
#' @noRd
ReorderUsernamesRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  reader$read_int()
  order <- list()
  for (i in seq_len(reader$read_int())) {
    x <- reader$tgread_string()
    order <- c(order, x)
  }
  ReorderUsernamesRequest$new(channel = channel, order = order)
}

#' @title ReportAntiSpamFalsePositiveRequest
#' @description Telegram API request \code{channels.reportAntiSpamFalsePositive} (constructor \code{#a850a693}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ReportAntiSpamFalsePositiveRequest <- R6::R6Class(
  "ReportAntiSpamFalsePositiveRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xa850a693,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field channel Field.
    channel = NULL,
    #  @field msg_id Field.
    msg_id = NULL,

    #  @description Initialize the ReportAntiSpamFalsePositiveRequest.
    #  @param channel The input channel.
    #  @param msg_id The message ID.
    initialize = function(channel, msg_id) {
      self$channel <- channel
      self$msg_id <- msg_id
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ReportAntiSpamFalsePositiveRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        msg_id = self$msg_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x93, 0xa6, 0x50, 0xa8)),
        self$channel$bytes(),
        pack("<i", self$msg_id)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name ReportAntiSpamFalsePositiveRequest_from_reader
#' @param reader The reader object.
#' @return An instance of ReportAntiSpamFalsePositiveRequest.
#' @noRd
ReportAntiSpamFalsePositiveRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  msg_id <- reader$read_int()
  ReportAntiSpamFalsePositiveRequest$new(channel = channel, msg_id = msg_id)
}


#' @title ReportSpamRequest
#' @description Telegram API request \code{channels.reportSpam} (constructor \code{#f44a8315}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ReportSpamRequest <- R6::R6Class(
  "ReportSpamRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xf44a8315,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field channel Field.
    channel = NULL,
    #  @field participant Field.
    participant = NULL,
    #  @field id Field.
    id = NULL,

    #  @description Initialize the ReportSpamRequest.
    #  @param channel The input channel.
    #  @param participant The input participant.
    #  @param id The list of message IDs.
    initialize = function(channel, participant, id) {
      self$channel <- channel
      self$participant <- participant
      self$id <- id
    },

    #  @description Resolve the channel and participant entities.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
      self$participant <- utils$get_input_peer(client$get_input_entity(self$participant))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ReportSpamRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        participant = if (inherits(self$participant, "TLObject")) self$participant$to_dict() else self$participant,
        id = if (is.null(self$id)) list() else self$id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x15, 0x83, 0x4a, 0xf4)),
        self$channel$bytes(),
        self$participant$bytes(),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        pack("<i", length(self$id)),
        do.call(c, lapply(self$id, function(x) pack("<i", x)))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name ReportSpamRequest_from_reader
#' @param reader The reader object.
#' @return An instance of ReportSpamRequest.
#' @noRd
ReportSpamRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  participant <- reader$tgread_object()
  reader$read_int()
  id <- list()
  for (i in seq_len(reader$read_int())) {
    x <- reader$read_int()
    id <- c(id, x)
  }
  ReportSpamRequest$new(channel = channel, participant = participant, id = id)
}

#' @title RestrictSponsoredMessagesRequest
#' @description Telegram API request \code{channels.restrictSponsoredMessages} (constructor \code{#9ae91519}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
RestrictSponsoredMessagesRequest <- R6::R6Class(
  "RestrictSponsoredMessagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x9ae91519,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field restricted Field.
    restricted = NULL,

    #  @description Initialize the RestrictSponsoredMessagesRequest.
    #  @param channel The input channel.
    #  @param restricted Whether sponsored messages are restricted.
    initialize = function(channel, restricted) {
      self$channel <- channel
      self$restricted <- restricted
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "RestrictSponsoredMessagesRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        restricted = self$restricted
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x19, 0x15, 0xe9, 0x9a)),
        self$channel$bytes(),
        if (self$restricted) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name RestrictSponsoredMessagesRequest_from_reader
#' @param reader The reader object.
#' @return An instance of RestrictSponsoredMessagesRequest.
#' @noRd
RestrictSponsoredMessagesRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  restricted <- reader$tgread_bool()
  RestrictSponsoredMessagesRequest$new(channel = channel, restricted = restricted)
}


#' @title SearchPostsRequest
#' @description Telegram API request \code{channels.searchPosts} (constructor \code{#f2c4f24d}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
SearchPostsRequest <- R6::R6Class("SearchPostsRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0xf2c4f24d,
    SUBCLASS_OF_ID = 0xd4b40b5e,
    hashtag = NULL,
    query = NULL,
    offset_rate = NULL,
    offset_peer = NULL,
    offset_id = NULL,
    limit = NULL,
    allow_paid_stars = NULL,
    initialize = function(hashtag = NULL, query = NULL, offset_rate, offset_peer, offset_id, limit, allow_paid_stars = NULL) {
      self$hashtag <- hashtag
      self$query <- query
      self$offset_rate <- offset_rate
      self$offset_peer <- offset_peer
      self$offset_id <- offset_id
      self$limit <- limit
      self$allow_paid_stars <- allow_paid_stars
    },
    resolve = function(client, utils) {
      if (!is.null(self$offset_peer)) self$offset_peer <- tryCatch(utils$get_input_peer(client$get_input_entity(self$offset_peer)), error = function(e) self$offset_peer)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "SearchPostsRequest",
        "hashtag" = if (inherits(self$hashtag, "TLObject")) self$hashtag$to_dict() else self$hashtag,
        "query" = if (inherits(self$query, "TLObject")) self$query$to_dict() else self$query,
        "offset_rate" = if (inherits(self$offset_rate, "TLObject")) self$offset_rate$to_dict() else self$offset_rate,
        "offset_peer" = if (inherits(self$offset_peer, "TLObject")) self$offset_peer$to_dict() else self$offset_peer,
        "offset_id" = if (inherits(self$offset_id, "TLObject")) self$offset_id$to_dict() else self$offset_id,
        "limit" = if (inherits(self$limit, "TLObject")) self$limit$to_dict() else self$limit,
        "allow_paid_stars" = if (inherits(self$allow_paid_stars, "TLObject")) self$allow_paid_stars$to_dict() else self$allow_paid_stars
      )
    },
    to_list = function() {
      list(
        `_` = "SearchPostsRequest",
        "hashtag" = if (inherits(self$hashtag, "TLObject")) self$hashtag$to_dict() else self$hashtag,
        "query" = if (inherits(self$query, "TLObject")) self$query$to_dict() else self$query,
        "offset_rate" = if (inherits(self$offset_rate, "TLObject")) self$offset_rate$to_dict() else self$offset_rate,
        "offset_peer" = if (inherits(self$offset_peer, "TLObject")) self$offset_peer$to_dict() else self$offset_peer,
        "offset_id" = if (inherits(self$offset_id, "TLObject")) self$offset_id$to_dict() else self$offset_id,
        "limit" = if (inherits(self$limit, "TLObject")) self$limit$to_dict() else self$limit,
        "allow_paid_stars" = if (inherits(self$allow_paid_stars, "TLObject")) self$allow_paid_stars$to_dict() else self$allow_paid_stars
      )
    },
    bytes = function() {
      flags <- 0L
      if (!is.null(self$hashtag)) flags <- bitwOr(flags, 1L)
      if (!is.null(self$query)) flags <- bitwOr(flags, 2L)
      if (!is.null(self$allow_paid_stars)) flags <- bitwOr(flags, 4L)
      c(
        as.raw(c(0x4d, 0xf2, 0xc4, 0xf2)),
        pack("<I", flags),
        if (!is.null(self$hashtag)) serialize_bytes(self$hashtag) else raw(0),
        if (!is.null(self$query)) serialize_bytes(self$query) else raw(0),
        pack("<i", self$offset_rate),
        self$offset_peer$bytes(),
        pack("<i", self$offset_id),
        pack("<i", self$limit),
        if (!is.null(self$allow_paid_stars)) packInt64(self$allow_paid_stars) else raw(0)
      )
    },
    serialize = function() self$bytes()
  ),
  private = list(
    from_reader = function(reader) {
      flags <- reader$read_int()
      self$hashtag <- if (bitwAnd(flags, 1L) != 0) reader$tgread_string() else NULL
      self$query <- if (bitwAnd(flags, 2L) != 0) reader$tgread_string() else NULL
      self$offset_rate <- reader$read_int()
      self$offset_peer <- reader$tgread_object()
      self$offset_id <- reader$read_int()
      self$limit <- reader$read_int()
      self$allow_paid_stars <- if (bitwAnd(flags, 4L) != 0) reader$read_long() else NULL
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title SetBoostsToUnblockRestrictionsRequest
#' @description Telegram API request \code{channels.setBoostsToUnblockRestrictions} (constructor \code{#ad399cee}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
SetBoostsToUnblockRestrictionsRequest <- R6::R6Class(
  "SetBoostsToUnblockRestrictionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xad399cee,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field boosts Field.
    boosts = NULL,

    #  @description Initialize the SetBoostsToUnblockRestrictionsRequest.
    #  @param channel The input channel.
    #  @param boosts The number of boosts.
    initialize = function(channel, boosts) {
      self$channel <- channel
      self$boosts <- boosts
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetBoostsToUnblockRestrictionsRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        boosts = self$boosts
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xee, 0x9c, 0x39, 0xad)),
        self$channel$bytes(),
        pack("<i", self$boosts)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name SetBoostsToUnblockRestrictionsRequest_from_reader
#' @param reader The reader object.
#' @return An instance of SetBoostsToUnblockRestrictionsRequest.
#' @noRd
SetBoostsToUnblockRestrictionsRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  boosts <- reader$read_int()
  SetBoostsToUnblockRestrictionsRequest$new(channel = channel, boosts = boosts)
}


#' @title SetDiscussionGroupRequest
#' @description Telegram API request \code{channels.setDiscussionGroup} (constructor \code{#40582bb2}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
SetDiscussionGroupRequest <- R6::R6Class(
  "SetDiscussionGroupRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x40582bb2,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field broadcast Field.
    broadcast = NULL,
    #  @field group Field.
    group = NULL,

    #  @description Initialize the SetDiscussionGroupRequest.
    #  @param broadcast The input broadcast channel.
    #  @param group The input group channel.
    initialize = function(broadcast, group) {
      self$broadcast <- broadcast
      self$group <- group
    },

    #  @description Resolve the broadcast and group entities.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$broadcast <- utils$get_input_channel(client$get_input_entity(self$broadcast))
      self$group <- utils$get_input_channel(client$get_input_entity(self$group))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetDiscussionGroupRequest",
        broadcast = if (inherits(self$broadcast, "TLObject")) self$broadcast$to_dict() else self$broadcast,
        group = if (inherits(self$group, "TLObject")) self$group$to_dict() else self$group
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xb2, 0x2b, 0x58, 0x40)),
        self$broadcast$bytes(),
        self$group$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name SetDiscussionGroupRequest_from_reader
#' @param reader The reader object.
#' @return An instance of SetDiscussionGroupRequest.
#' @noRd
SetDiscussionGroupRequest$from_reader <- function(reader) {
  broadcast <- reader$tgread_object()
  group <- reader$tgread_object()
  SetDiscussionGroupRequest$new(broadcast = broadcast, group = group)
}

#' @title SetEmojiStickersRequest
#' @description Telegram API request \code{channels.setEmojiStickers} (constructor \code{#3cd930b7}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
SetEmojiStickersRequest <- R6::R6Class(
  "SetEmojiStickersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x3cd930b7,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field channel Field.
    channel = NULL,
    #  @field stickerset Field.
    stickerset = NULL,

    #  @description Initialize the SetEmojiStickersRequest.
    #  @param channel The input channel.
    #  @param stickerset The input sticker set.
    initialize = function(channel, stickerset) {
      self$channel <- channel
      self$stickerset <- stickerset
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetEmojiStickersRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        stickerset = if (inherits(self$stickerset, "TLObject")) self$stickerset$to_dict() else self$stickerset
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xb7, 0x30, 0xd9, 0x3c)),
        self$channel$bytes(),
        self$stickerset$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name SetEmojiStickersRequest_from_reader
#' @param reader The reader object.
#' @return An instance of SetEmojiStickersRequest.
#' @noRd
SetEmojiStickersRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  stickerset <- reader$tgread_object()
  SetEmojiStickersRequest$new(channel = channel, stickerset = stickerset)
}

#' @title SetMainProfileTabRequest
#' @description Telegram API request \code{channels.setMainProfileTab} (constructor \code{#3583fcb1}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
SetMainProfileTabRequest <- R6::R6Class("SetMainProfileTabRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0x3583fcb1,
    SUBCLASS_OF_ID = 0xf5b399ac,
    channel = NULL,
    tab = NULL,
    initialize = function(channel, tab) {
      self$channel <- channel
      self$tab <- tab
    },
    resolve = function(client, utils) {
      if (!is.null(self$channel)) self$channel <- tryCatch(utils$get_input_channel(client$get_input_entity(self$channel)), error = function(e) self$channel)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "SetMainProfileTabRequest",
        "channel" = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        "tab" = if (inherits(self$tab, "TLObject")) self$tab$to_dict() else self$tab
      )
    },
    to_list = function() {
      list(
        `_` = "SetMainProfileTabRequest",
        "channel" = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        "tab" = if (inherits(self$tab, "TLObject")) self$tab$to_dict() else self$tab
      )
    },
    bytes = function() {
      c(
        as.raw(c(0xb1, 0xfc, 0x83, 0x35)),
        self$channel$bytes(),
        self$tab$bytes()
      )
    },
    serialize = function() self$bytes()
  ),
  private = list(
    from_reader = function(reader) {
      self$channel <- reader$tgread_object()
      self$tab <- reader$tgread_object()
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title SetStickersRequest
#' @description Telegram API request \code{channels.setStickers} (constructor \code{#ea8ca4f9}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
SetStickersRequest <- R6::R6Class(
  "SetStickersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xea8ca4f9,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field channel Field.
    channel = NULL,
    #  @field stickerset Field.
    stickerset = NULL,

    #  @description Initialize the SetStickersRequest.
    #  @param channel The input channel.
    #  @param stickerset The input sticker set.
    initialize = function(channel, stickerset) {
      self$channel <- channel
      self$stickerset <- stickerset
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetStickersRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        stickerset = if (inherits(self$stickerset, "TLObject")) self$stickerset$to_dict() else self$stickerset
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xf9, 0xa4, 0x8c, 0xea)),
        self$channel$bytes(),
        self$stickerset$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name SetStickersRequest_from_reader
#' @param reader The reader object.
#' @return An instance of SetStickersRequest.
#' @noRd
SetStickersRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  stickerset <- reader$tgread_object()
  SetStickersRequest$new(channel = channel, stickerset = stickerset)
}

#' @title ToggleAntiSpamRequest
#' @description Telegram API request \code{channels.toggleAntiSpam} (constructor \code{#68f3e4eb}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ToggleAntiSpamRequest <- R6::R6Class(
  "ToggleAntiSpamRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x68f3e4eb,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field enabled Field.
    enabled = NULL,

    #  @description Initialize the ToggleAntiSpamRequest.
    #  @param channel The input channel.
    #  @param enabled Whether anti-spam is enabled.
    initialize = function(channel, enabled) {
      self$channel <- channel
      self$enabled <- enabled
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ToggleAntiSpamRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        enabled = self$enabled
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xeb, 0xe4, 0xf3, 0x68)),
        self$channel$bytes(),
        if (self$enabled) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name ToggleAntiSpamRequest_from_reader
#' @param reader The reader object.
#' @return An instance of ToggleAntiSpamRequest.
#' @noRd
ToggleAntiSpamRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  enabled <- reader$tgread_bool()
  ToggleAntiSpamRequest$new(channel = channel, enabled = enabled)
}

#' @title ToggleAutotranslationRequest
#' @description Telegram API request \code{channels.toggleAutotranslation} (constructor \code{#167fc0a1}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ToggleAutotranslationRequest <- R6::R6Class(
  "ToggleAutotranslationRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x167fc0a1,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field enabled Field.
    enabled = NULL,

    #  @description Initialize the ToggleAutotranslationRequest.
    #  @param channel The input channel.
    #  @param enabled Whether autotranslation is enabled.
    initialize = function(channel, enabled) {
      self$channel <- channel
      self$enabled <- enabled
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ToggleAutotranslationRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        enabled = self$enabled
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xa1, 0xc0, 0x7f, 0x16)),
        self$channel$bytes(),
        if (self$enabled) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name ToggleAutotranslationRequest_from_reader
#' @param reader The reader object.
#' @return An instance of ToggleAutotranslationRequest.
#' @noRd
ToggleAutotranslationRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  enabled <- reader$tgread_bool()
  ToggleAutotranslationRequest$new(channel = channel, enabled = enabled)
}


#' @title ToggleForumRequest
#' @description Telegram API request \code{channels.toggleForum} (constructor \code{#3ff75734}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ToggleForumRequest <- R6::R6Class(
  "ToggleForumRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x3ff75734,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field enabled Field.
    enabled = NULL,
    #  @field tabs Field.
    tabs = NULL,

    #  @description Initialize the ToggleForumRequest.
    #  @param channel The input channel.
    #  @param enabled Whether the forum is enabled.
    #  @param tabs Whether tabs are enabled.
    initialize = function(channel, enabled, tabs) {
      self$channel <- channel
      self$enabled <- enabled
      self$tabs <- tabs
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ToggleForumRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        enabled = self$enabled,
        tabs = self$tabs
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x34, 0x57, 0xf7, 0x3f)),
        self$channel$bytes(),
        if (self$enabled) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc)),
        if (self$tabs) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name ToggleForumRequest_from_reader
#' @param reader The reader object.
#' @return An instance of ToggleForumRequest.
#' @noRd
ToggleForumRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  enabled <- reader$tgread_bool()
  tabs <- reader$tgread_bool()
  ToggleForumRequest$new(channel = channel, enabled = enabled, tabs = tabs)
}

#' @title ToggleJoinRequestRequest
#' @description Telegram API request \code{channels.toggleJoinRequest} (constructor \code{#0ecc2618}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ToggleJoinRequestRequest <- R6::R6Class("ToggleJoinRequestRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0x0ecc2618,
    SUBCLASS_OF_ID = 0x8af52aac,
    apply_to_invites = NULL,
    channel = NULL,
    enabled = NULL,
    guard_bot = NULL,
    initialize = function(apply_to_invites = NULL, channel, enabled, guard_bot = NULL) {
      self$apply_to_invites <- apply_to_invites
      self$channel <- channel
      self$enabled <- enabled
      self$guard_bot <- guard_bot
    },
    resolve = function(client, utils) {
      if (!is.null(self$channel)) self$channel <- tryCatch(utils$get_input_channel(client$get_input_entity(self$channel)), error = function(e) self$channel)
      if (!is.null(self$guard_bot)) self$guard_bot <- tryCatch(utils$get_input_user(client$get_input_entity(self$guard_bot)), error = function(e) self$guard_bot)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "ToggleJoinRequestRequest",
        "apply_to_invites" = if (inherits(self$apply_to_invites, "TLObject")) self$apply_to_invites$to_dict() else self$apply_to_invites,
        "channel" = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        "enabled" = if (inherits(self$enabled, "TLObject")) self$enabled$to_dict() else self$enabled,
        "guard_bot" = if (inherits(self$guard_bot, "TLObject")) self$guard_bot$to_dict() else self$guard_bot
      )
    },
    to_list = function() {
      list(
        `_` = "ToggleJoinRequestRequest",
        "apply_to_invites" = if (inherits(self$apply_to_invites, "TLObject")) self$apply_to_invites$to_dict() else self$apply_to_invites,
        "channel" = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        "enabled" = if (inherits(self$enabled, "TLObject")) self$enabled$to_dict() else self$enabled,
        "guard_bot" = if (inherits(self$guard_bot, "TLObject")) self$guard_bot$to_dict() else self$guard_bot
      )
    },
    bytes = function() {
      flags <- 0L
      if (isTRUE(self$apply_to_invites)) flags <- bitwOr(flags, 2L)
      if (!is.null(self$guard_bot)) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x18, 0x26, 0xcc, 0x0e)),
        pack("<I", flags),
        self$channel$bytes(),
        if (isTRUE(self$enabled)) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc)),
        if (!is.null(self$guard_bot)) self$guard_bot$bytes() else raw(0)
      )
    },
    serialize = function() self$bytes()
  ),
  private = list(
    from_reader = function(reader) {
      flags <- reader$read_int()
      self$apply_to_invites <- bitwAnd(flags, 2L) != 0
      self$channel <- reader$tgread_object()
      self$enabled <- reader$tgread_bool()
      self$guard_bot <- if (bitwAnd(flags, 1L) != 0) reader$tgread_object() else NULL
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title ToggleJoinToSendRequest
#' @description Telegram API request \code{channels.toggleJoinToSend} (constructor \code{#e4cb9580}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ToggleJoinToSendRequest <- R6::R6Class(
  "ToggleJoinToSendRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xe4cb9580,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field enabled Field.
    enabled = NULL,

    #  @description Initialize the ToggleJoinToSendRequest.
    #  @param channel The input channel.
    #  @param enabled Whether join to send is enabled.
    initialize = function(channel, enabled) {
      self$channel <- channel
      self$enabled <- enabled
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ToggleJoinToSendRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        enabled = self$enabled
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x80, 0x95, 0xcb, 0xe4)),
        self$channel$bytes(),
        if (self$enabled) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name ToggleJoinToSendRequest_from_reader
#' @param reader The reader object.
#' @return An instance of ToggleJoinToSendRequest.
#' @noRd
ToggleJoinToSendRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  enabled <- reader$tgread_bool()
  ToggleJoinToSendRequest$new(channel = channel, enabled = enabled)
}


#' @title ToggleParticipantsHiddenRequest
#' @description Telegram API request \code{channels.toggleParticipantsHidden} (constructor \code{#6a6e7854}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ToggleParticipantsHiddenRequest <- R6::R6Class(
  "ToggleParticipantsHiddenRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x6a6e7854,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field enabled Field.
    enabled = NULL,

    #  @description Initialize the ToggleParticipantsHiddenRequest.
    #  @param channel The input channel.
    #  @param enabled Whether the feature is enabled.
    initialize = function(channel, enabled) {
      self$channel <- channel
      self$enabled <- enabled
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ToggleParticipantsHiddenRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        enabled = self$enabled
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x54, 0x78, 0x6e, 0x6a)),
        self$channel$bytes(),
        if (self$enabled) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name ToggleParticipantsHiddenRequest_from_reader
#' @param reader The reader object.
#' @return An instance of ToggleParticipantsHiddenRequest.
#' @noRd
ToggleParticipantsHiddenRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  enabled <- reader$tgread_bool()
  ToggleParticipantsHiddenRequest$new(channel = channel, enabled = enabled)
}

#' @title TogglePreHistoryHiddenRequest
#' @description Telegram API request \code{channels.togglePreHistoryHidden} (constructor \code{#eabbb94c}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
TogglePreHistoryHiddenRequest <- R6::R6Class(
  "TogglePreHistoryHiddenRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xeabbb94c,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field enabled Field.
    enabled = NULL,

    #  @description Initialize the TogglePreHistoryHiddenRequest.
    #  @param channel The input channel.
    #  @param enabled Whether the feature is enabled.
    initialize = function(channel, enabled) {
      self$channel <- channel
      self$enabled <- enabled
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "TogglePreHistoryHiddenRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        enabled = self$enabled
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x4c, 0xb9, 0xbb, 0xea)),
        self$channel$bytes(),
        if (self$enabled) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name TogglePreHistoryHiddenRequest_from_reader
#' @param reader The reader object.
#' @return An instance of TogglePreHistoryHiddenRequest.
#' @noRd
TogglePreHistoryHiddenRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  enabled <- reader$tgread_bool()
  TogglePreHistoryHiddenRequest$new(channel = channel, enabled = enabled)
}

#' @title ToggleSignaturesRequest
#' @description Telegram API request \code{channels.toggleSignatures} (constructor \code{#418d549c}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ToggleSignaturesRequest <- R6::R6Class(
  "ToggleSignaturesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x418d549c,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field signatures_enabled Field.
    signatures_enabled = NULL,
    #  @field profiles_enabled Field.
    profiles_enabled = NULL,

    #  @description Initialize the ToggleSignaturesRequest.
    #  @param channel The input channel.
    #  @param signatures_enabled Whether signatures are enabled.
    #  @param profiles_enabled Whether profiles are enabled.
    initialize = function(channel, signatures_enabled = NULL, profiles_enabled = NULL) {
      self$channel <- channel
      self$signatures_enabled <- signatures_enabled
      self$profiles_enabled <- profiles_enabled
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ToggleSignaturesRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        signatures_enabled = self$signatures_enabled,
        profiles_enabled = self$profiles_enabled
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$signatures_enabled) || !self$signatures_enabled) 0 else 1) |
        (if (is.null(self$profiles_enabled) || !self$profiles_enabled) 0 else 2)
      c(
        as.raw(c(0x9c, 0x54, 0x8d, 0x41)),
        pack("<I", flags),
        self$channel$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name ToggleSignaturesRequest_from_reader
#' @param reader The reader object.
#' @return An instance of ToggleSignaturesRequest.
#' @noRd
ToggleSignaturesRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  signatures_enabled <- (flags & 1) != 0
  profiles_enabled <- (flags & 2) != 0
  channel <- reader$tgread_object()
  ToggleSignaturesRequest$new(channel = channel, signatures_enabled = signatures_enabled, profiles_enabled = profiles_enabled)
}


#' @title ToggleSlowModeRequest
#' @description Telegram API request \code{channels.toggleSlowMode} (constructor \code{#edd49ef0}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ToggleSlowModeRequest <- R6::R6Class(
  "ToggleSlowModeRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xedd49ef0,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field seconds Field.
    seconds = NULL,

    #  @description Initialize the ToggleSlowModeRequest.
    #  @param channel The input channel.
    #  @param seconds The number of seconds for slow mode.
    initialize = function(channel, seconds) {
      self$channel <- channel
      self$seconds <- seconds
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ToggleSlowModeRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        seconds = self$seconds
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xf0, 0x9e, 0xd4, 0xed)),
        self$channel$bytes(),
        pack("<i", self$seconds)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name ToggleSlowModeRequest_from_reader
#' @param reader The reader object.
#' @return An instance of ToggleSlowModeRequest.
#' @noRd
ToggleSlowModeRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  seconds <- reader$read_int()
  ToggleSlowModeRequest$new(channel = channel, seconds = seconds)
}

#' @title ToggleUsernameRequest
#' @description Telegram API request \code{channels.toggleUsername} (constructor \code{#50f24105}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ToggleUsernameRequest <- R6::R6Class(
  "ToggleUsernameRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x50f24105,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field channel Field.
    channel = NULL,
    #  @field username Field.
    username = NULL,
    #  @field active Field.
    active = NULL,

    #  @description Initialize the ToggleUsernameRequest.
    #  @param channel The input channel.
    #  @param username The username.
    #  @param active Whether the username is active.
    initialize = function(channel, username, active) {
      self$channel <- channel
      self$username <- username
      self$active <- active
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ToggleUsernameRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        username = self$username,
        active = self$active
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x05, 0x41, 0xf2, 0x50)),
        self$channel$bytes(),
        self$serialize_bytes(self$username),
        if (self$active) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name ToggleUsernameRequest_from_reader
#' @param reader The reader object.
#' @return An instance of ToggleUsernameRequest.
#' @noRd
ToggleUsernameRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  username <- reader$tgread_string()
  active <- reader$tgread_bool()
  ToggleUsernameRequest$new(channel = channel, username = username, active = active)
}

#' @title ToggleViewForumAsMessagesRequest
#' @description Telegram API request \code{channels.toggleViewForumAsMessages} (constructor \code{#9738bb15}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ToggleViewForumAsMessagesRequest <- R6::R6Class(
  "ToggleViewForumAsMessagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x9738bb15,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field enabled Field.
    enabled = NULL,

    #  @description Initialize the ToggleViewForumAsMessagesRequest.
    #  @param channel The input channel.
    #  @param enabled Whether the feature is enabled.
    initialize = function(channel, enabled) {
      self$channel <- channel
      self$enabled <- enabled
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ToggleViewForumAsMessagesRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        enabled = self$enabled
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x15, 0xbb, 0x38, 0x97)),
        self$channel$bytes(),
        if (self$enabled) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name ToggleViewForumAsMessagesRequest_from_reader
#' @param reader The reader object.
#' @return An instance of ToggleViewForumAsMessagesRequest.
#' @noRd
ToggleViewForumAsMessagesRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  enabled <- reader$tgread_bool()
  ToggleViewForumAsMessagesRequest$new(channel = channel, enabled = enabled)
}


#' @title UpdateColorRequest
#' @description Telegram API request \code{channels.updateColor} (constructor \code{#d8aa3671}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
UpdateColorRequest <- R6::R6Class("UpdateColorRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0xd8aa3671,
    SUBCLASS_OF_ID = 0x8af52aac,
    for_profile = NULL,
    channel = NULL,
    color = NULL,
    background_emoji_id = NULL,
    initialize = function(for_profile = NULL, channel, color = NULL, background_emoji_id = NULL) {
      self$for_profile <- for_profile
      self$channel <- channel
      self$color <- color
      self$background_emoji_id <- background_emoji_id
    },
    resolve = function(client, utils) {
      if (!is.null(self$channel)) self$channel <- tryCatch(utils$get_input_channel(client$get_input_entity(self$channel)), error = function(e) self$channel)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "UpdateColorRequest",
        "for_profile" = if (inherits(self$for_profile, "TLObject")) self$for_profile$to_dict() else self$for_profile,
        "channel" = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        "color" = if (inherits(self$color, "TLObject")) self$color$to_dict() else self$color,
        "background_emoji_id" = if (inherits(self$background_emoji_id, "TLObject")) self$background_emoji_id$to_dict() else self$background_emoji_id
      )
    },
    to_list = function() {
      list(
        `_` = "UpdateColorRequest",
        "for_profile" = if (inherits(self$for_profile, "TLObject")) self$for_profile$to_dict() else self$for_profile,
        "channel" = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        "color" = if (inherits(self$color, "TLObject")) self$color$to_dict() else self$color,
        "background_emoji_id" = if (inherits(self$background_emoji_id, "TLObject")) self$background_emoji_id$to_dict() else self$background_emoji_id
      )
    },
    bytes = function() {
      flags <- 0L
      if (isTRUE(self$for_profile)) flags <- bitwOr(flags, 2L)
      if (!is.null(self$color)) flags <- bitwOr(flags, 4L)
      if (!is.null(self$background_emoji_id)) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x71, 0x36, 0xaa, 0xd8)),
        pack("<I", flags),
        self$channel$bytes(),
        if (!is.null(self$color)) pack("<i", self$color) else raw(0),
        if (!is.null(self$background_emoji_id)) packInt64(self$background_emoji_id) else raw(0)
      )
    },
    serialize = function() self$bytes()
  ),
  private = list(
    from_reader = function(reader) {
      flags <- reader$read_int()
      self$for_profile <- bitwAnd(flags, 2L) != 0
      self$channel <- reader$tgread_object()
      self$color <- if (bitwAnd(flags, 4L) != 0) reader$read_int() else NULL
      self$background_emoji_id <- if (bitwAnd(flags, 1L) != 0) reader$read_long() else NULL
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title UpdateEmojiStatusRequest
#' @description Telegram API request \code{channels.updateEmojiStatus} (constructor \code{#f0d3e6a8}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
UpdateEmojiStatusRequest <- R6::R6Class("UpdateEmojiStatusRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0xf0d3e6a8,
    SUBCLASS_OF_ID = 0x8af52aac,
    channel = NULL,
    emoji_status = NULL,
    initialize = function(channel, emoji_status) {
      self$channel <- channel
      self$emoji_status <- emoji_status
    },
    resolve = function(client, utils) {
      if (!is.null(self$channel)) self$channel <- tryCatch(utils$get_input_channel(client$get_input_entity(self$channel)), error = function(e) self$channel)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "UpdateEmojiStatusRequest",
        "channel" = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        "emoji_status" = if (inherits(self$emoji_status, "TLObject")) self$emoji_status$to_dict() else self$emoji_status
      )
    },
    to_list = function() {
      list(
        `_` = "UpdateEmojiStatusRequest",
        "channel" = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        "emoji_status" = if (inherits(self$emoji_status, "TLObject")) self$emoji_status$to_dict() else self$emoji_status
      )
    },
    bytes = function() {
      c(
        as.raw(c(0xa8, 0xe6, 0xd3, 0xf0)),
        self$channel$bytes(),
        self$emoji_status$bytes()
      )
    },
    serialize = function() self$bytes()
  ),
  private = list(
    from_reader = function(reader) {
      self$channel <- reader$tgread_object()
      self$emoji_status <- reader$tgread_object()
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title UpdatePaidMessagesPriceRequest
#' @description Telegram API request \code{channels.updatePaidMessagesPrice} (constructor \code{#4b12327b}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
UpdatePaidMessagesPriceRequest <- R6::R6Class(
  "UpdatePaidMessagesPriceRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x4b12327b,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field send_paid_messages_stars Field.
    send_paid_messages_stars = NULL,
    #  @field broadcast_messages_allowed Field.
    broadcast_messages_allowed = NULL,

    #  @description Initialize the UpdatePaidMessagesPriceRequest.
    #  @param channel The input channel.
    #  @param send_paid_messages_stars The number of stars for paid messages.
    #  @param broadcast_messages_allowed Whether broadcast messages are allowed.
    initialize = function(channel, send_paid_messages_stars, broadcast_messages_allowed = NULL) {
      self$channel <- channel
      self$send_paid_messages_stars <- send_paid_messages_stars
      self$broadcast_messages_allowed <- broadcast_messages_allowed
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "UpdatePaidMessagesPriceRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        send_paid_messages_stars = self$send_paid_messages_stars,
        broadcast_messages_allowed = self$broadcast_messages_allowed
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$broadcast_messages_allowed) || !self$broadcast_messages_allowed) 0 else 1
      c(
        as.raw(c(0x7b, 0x32, 0x12, 0x4b)),
        pack("<I", flags),
        self$channel$bytes(),
        pack("<q", self$send_paid_messages_stars)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

#' Deserialize from a reader.
#' @name UpdatePaidMessagesPriceRequest_from_reader
#' @param reader The reader object.
#' @return An instance of UpdatePaidMessagesPriceRequest.
#' @noRd
UpdatePaidMessagesPriceRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  broadcast_messages_allowed <- (flags & 1) != 0
  channel <- reader$tgread_object()
  send_paid_messages_stars <- reader$read_long()
  UpdatePaidMessagesPriceRequest$new(channel = channel, send_paid_messages_stars = send_paid_messages_stars, broadcast_messages_allowed = broadcast_messages_allowed)
}


#' @title UpdatePinnedForumTopicRequest
#' @description Telegram API request \code{messages.updatePinnedForumTopic} (constructor \code{#175df251}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
UpdatePinnedForumTopicRequest <- R6::R6Class("UpdatePinnedForumTopicRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0x175df251,
    SUBCLASS_OF_ID = 0x8af52aac,
    peer = NULL,
    topic_id = NULL,
    pinned = NULL,
    initialize = function(peer, topic_id, pinned) {
      self$peer <- peer
      self$topic_id <- topic_id
      self$pinned <- pinned
    },
    resolve = function(client, utils) {
      if (!is.null(self$peer)) self$peer <- tryCatch(utils$get_input_peer(client$get_input_entity(self$peer)), error = function(e) self$peer)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "UpdatePinnedForumTopicRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "topic_id" = if (inherits(self$topic_id, "TLObject")) self$topic_id$to_dict() else self$topic_id,
        "pinned" = if (inherits(self$pinned, "TLObject")) self$pinned$to_dict() else self$pinned
      )
    },
    to_list = function() {
      list(
        `_` = "UpdatePinnedForumTopicRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "topic_id" = if (inherits(self$topic_id, "TLObject")) self$topic_id$to_dict() else self$topic_id,
        "pinned" = if (inherits(self$pinned, "TLObject")) self$pinned$to_dict() else self$pinned
      )
    },
    bytes = function() {
      c(
        as.raw(c(0x51, 0xf2, 0x5d, 0x17)),
        self$peer$bytes(),
        pack("<i", self$topic_id),
        if (isTRUE(self$pinned)) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    },
    serialize = function() self$bytes()
  ),
  private = list(
    from_reader = function(reader) {
      self$peer <- reader$tgread_object()
      self$topic_id <- reader$read_int()
      self$pinned <- reader$tgread_bool()
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title UpdateUsernameRequest
#' @description Telegram API request \code{channels.updateUsername} (constructor \code{#3514b3de}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
UpdateUsernameRequest <- R6::R6Class("UpdateUsernameRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0x3514b3de,
    SUBCLASS_OF_ID = 0xf5b399ac,
    channel = NULL,
    username = NULL,
    initialize = function(channel, username) {
      self$channel <- channel
      self$username <- username
    },
    resolve = function(client, utils) {
      if (!is.null(self$channel)) self$channel <- tryCatch(utils$get_input_channel(client$get_input_entity(self$channel)), error = function(e) self$channel)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "UpdateUsernameRequest",
        "channel" = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        "username" = if (inherits(self$username, "TLObject")) self$username$to_dict() else self$username
      )
    },
    to_list = function() {
      list(
        `_` = "UpdateUsernameRequest",
        "channel" = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        "username" = if (inherits(self$username, "TLObject")) self$username$to_dict() else self$username
      )
    },
    bytes = function() {
      c(
        as.raw(c(0xde, 0xb3, 0x14, 0x35)),
        self$channel$bytes(),
        serialize_bytes(self$username)
      )
    },
    serialize = function() self$bytes()
  ),
  private = list(
    from_reader = function(reader) {
      self$channel <- reader$tgread_object()
      self$username <- reader$tgread_string()
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

