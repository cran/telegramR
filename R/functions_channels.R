#  @title CheckSearchPostsFloodRequest
#  @description Represents a request to check search posts flood.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name CheckSearchPostsFloodRequest_from_reader
#
# @param reader The reader object.
# @return An instance of CheckSearchPostsFloodRequest.
CheckSearchPostsFloodRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  query <- if ((flags && 1) != 0) reader$tgread_string() else NULL
  CheckSearchPostsFloodRequest$new(query = query)
}

#  @title CheckUsernameRequest
#  @description Represents a request to check a username in a channel.
#  @export
#  @noRd
#  @noRd
CheckUsernameRequest <- R6::R6Class(
  "CheckUsernameRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x10e6bd2c,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field channel Field.
    channel = NULL,
    #  @field username Field.
    username = NULL,

    #  @description Initialize the CheckUsernameRequest.
    #  @param channel The input channel.
    #  @param username The username.
    initialize = function(channel, username) {
      self$channel <- channel
      self$username <- username
    },

    #  @description Resolve the channel entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      if (inherits(self$channel, "InputChannel")) {
        return(invisible(NULL))
      }
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "CheckUsernameRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        username = self$username
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x2c, 0xbd, 0xe6, 0x10)),
        self$channel$bytes(),
        self$serialize_bytes(self$username)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Deserialize from a reader.
# @name CheckUsernameRequest_from_reader
# @param reader The reader object.
# @return An instance of CheckUsernameRequest.
CheckUsernameRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  username <- reader$tgread_string()
  CheckUsernameRequest$new(channel = channel, username = username)
}

#  @title ConvertToGigagroupRequest
#  @description Represents a request to convert a channel to a gigagroup.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name ConvertToGigagroupRequest_from_reader
#
# @param reader The reader object.
# @return An instance of ConvertToGigagroupRequest.
ConvertToGigagroupRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  ConvertToGigagroupRequest$new(channel = channel)
}

#  @title CreateChannelRequest
#  @description Represents a request to create a new channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name CreateChannelRequest_from_reader
# @param reader The reader object.
# @return An instance of CreateChannelRequest.
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


#  @title CreateForumTopicRequest
#  @description Represents a request to create a forum topic in a channel.
#  @export
#  @noRd
#  @noRd
CreateForumTopicRequest <- R6::R6Class(
  "CreateForumTopicRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xf40c0224,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field title Field.
    title = NULL,
    #  @field icon_color Field.
    icon_color = NULL,
    #  @field icon_emoji_id Field.
    icon_emoji_id = NULL,
    #  @field random_id Field.
    random_id = NULL,
    #  @field send_as Field.
    send_as = NULL,

    #  @description Initialize the CreateForumTopicRequest.
    #  @param channel The input channel.
    #  @param title The title of the topic.
    #  @param icon_color The icon color (optional).
    #  @param icon_emoji_id The icon emoji ID (optional).
    #  @param random_id The random ID (optional).
    #  @param send_as The send as peer (optional).
    initialize = function(channel, title, icon_color = NULL, icon_emoji_id = NULL, random_id = NULL, send_as = NULL) {
      self$channel <- channel
      self$title <- title
      self$icon_color <- icon_color
      self$icon_emoji_id <- icon_emoji_id
      self$random_id <- if (is.null(random_id)) as.integer(runif(1) * 2^32) else random_id # Simplified random generation for 32-bit; adjust for 64-bit if needed
      self$send_as <- send_as
    },

    #  @description Resolve the channel and send_as entities.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$channel <- utils$get_input_channel(client$get_input_entity(self$channel))
      if (!is.null(self$send_as)) {
        self$send_as <- utils$get_input_peer(client$get_input_entity(self$send_as))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "CreateForumTopicRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        title = self$title,
        icon_color = self$icon_color,
        icon_emoji_id = self$icon_emoji_id,
        random_id = self$random_id,
        send_as = if (inherits(self$send_as, "TLObject")) self$send_as$to_dict() else self$send_as
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$icon_color) || !self$icon_color) 0 else 1) |
        (if (is.null(self$icon_emoji_id) || !self$icon_emoji_id) 0 else 8) |
        (if (is.null(self$send_as) || !self$send_as) 0 else 4)
      c(
        as.raw(c(0x24, 0x02, 0x0c, 0xf4)),
        pack("<I", flags),
        self$channel$bytes(),
        self$serialize_bytes(self$title),
        if (!is.null(self$icon_color) && self$icon_color) pack("<i", self$icon_color) else raw(0),
        if (!is.null(self$icon_emoji_id) && self$icon_emoji_id) pack("<q", self$icon_emoji_id) else raw(0),
        pack("<q", self$random_id),
        if (!is.null(self$send_as) && self$send_as) self$send_as$bytes() else raw(0)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Deserialize from a reader.
# @name CreateForumTopicRequest_from_reader
#
# @param reader The reader object.
# @return An instance of CreateForumTopicRequest.
CreateForumTopicRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  channel <- reader$tgread_object()
  title <- reader$tgread_string()
  icon_color <- if ((flags && 1) != 0) reader$read_int() else NULL
  icon_emoji_id <- if ((flags && 8) != 0) reader$read_long() else NULL
  random_id <- reader$read_long()
  send_as <- if ((flags && 4) != 0) reader$tgread_object() else NULL
  CreateForumTopicRequest$new(channel = channel, title = title, icon_color = icon_color, icon_emoji_id = icon_emoji_id, random_id = random_id, send_as = send_as)
}

#  @title DeactivateAllUsernamesRequest
#  @description Represents a request to deactivate all usernames in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name DeactivateAllUsernamesRequest_from_reader
#
# @param reader The reader object.
# @return An instance of DeactivateAllUsernamesRequest.
DeactivateAllUsernamesRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  DeactivateAllUsernamesRequest$new(channel = channel)
}

#  @title DeleteChannelRequest
#  @description Represents a request to delete a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name DeleteChannelRequest_from_reader
#
# @param reader The reader object.
# @return An instance of DeleteChannelRequest.
DeleteChannelRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  DeleteChannelRequest$new(channel = channel)
}


#  @title DeleteHistoryRequest
#  @description Represents a request to delete the history of a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name DeleteHistoryRequest_from_reader
#
# @param reader The reader object.
# @return An instance of DeleteHistoryRequest.
DeleteHistoryRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  for_everyone <- (flags & 1) != 0
  channel <- reader$tgread_object()
  max_id <- reader$read_int()
  DeleteHistoryRequest$new(channel = channel, max_id = max_id, for_everyone = for_everyone)
}

#  @title DeleteMessagesRequest
#  @description Represents a request to delete messages in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name DeleteMessagesRequest_from_reader
#
# @param reader The reader object.
# @return An instance of DeleteMessagesRequest.
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

#  @title DeleteParticipantHistoryRequest
#  @description Represents a request to delete the history of a participant in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name DeleteParticipantHistoryRequest_from_reader
#
# @param reader The reader object.
# @return An instance of DeleteParticipantHistoryRequest.
DeleteParticipantHistoryRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  participant <- reader$tgread_object()
  DeleteParticipantHistoryRequest$new(channel = channel, participant = participant)
}


#  @title DeleteTopicHistoryRequest
#  @description Represents a request to delete the history of a topic in a channel.
#  @export
#  @noRd
#  @noRd
DeleteTopicHistoryRequest <- R6::R6Class(
  "DeleteTopicHistoryRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x34435f2d,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x2c49c116,
    #  @field channel Field.
    channel = NULL,
    #  @field top_msg_id Field.
    top_msg_id = NULL,

    #  @description Initialize the DeleteTopicHistoryRequest.
    #  @param channel The input channel.
    #  @param top_msg_id The top message ID.
    initialize = function(channel, top_msg_id) {
      self$channel <- channel
      self$top_msg_id <- top_msg_id
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
        "_" = "DeleteTopicHistoryRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        top_msg_id = self$top_msg_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x2d, 0x5f, 0x43, 0x34)),
        self$channel$bytes(),
        pack("<i", self$top_msg_id)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Deserialize from a reader.
# @name DeleteTopicHistoryRequest_from_reader
#
# @param reader The reader object.
# @return An instance of DeleteTopicHistoryRequest.
DeleteTopicHistoryRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  top_msg_id <- reader$read_int()
  DeleteTopicHistoryRequest$new(channel = channel, top_msg_id = top_msg_id)
}

#  @title EditAdminRequest
#  @description Represents a request to edit admin rights for a user in a channel.
#  @export
#  @noRd
#  @noRd
EditAdminRequest <- R6::R6Class(
  "EditAdminRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xd33c8902,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field user_id Field.
    user_id = NULL,
    #  @field admin_rights Field.
    admin_rights = NULL,
    #  @field rank Field.
    rank = NULL,

    #  @description Initialize the EditAdminRequest.
    #  @param channel The input channel.
    #  @param user_id The input user ID.
    #  @param admin_rights The chat admin rights.
    #  @param rank The rank string.
    initialize = function(channel, user_id, admin_rights, rank) {
      self$channel <- channel
      self$user_id <- user_id
      self$admin_rights <- admin_rights
      self$rank <- rank
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
        "_" = "EditAdminRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        user_id = if (inherits(self$user_id, "TLObject")) self$user_id$to_dict() else self$user_id,
        admin_rights = if (inherits(self$admin_rights, "TLObject")) self$admin_rights$to_dict() else self$admin_rights,
        rank = self$rank
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x02, 0x89, 0x3c, 0xd3)),
        self$channel$bytes(),
        self$user_id$bytes(),
        self$admin_rights$bytes(),
        self$serialize_bytes(self$rank)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Deserialize from a reader.
# @name EditAdminRequest_from_reader
# @param reader The reader object.
# @return An instance of EditAdminRequest.
EditAdminRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  user_id <- reader$tgread_object()
  admin_rights <- reader$tgread_object()
  rank <- reader$tgread_string()
  EditAdminRequest$new(channel = channel, user_id = user_id, admin_rights = admin_rights, rank = rank)
}

#  @title EditBannedRequest
#  @description Represents a request to edit banned rights for a participant in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name EditBannedRequest_from_reader
# @param reader The reader object.
# @return An instance of EditBannedRequest.
EditBannedRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  participant <- reader$tgread_object()
  banned_rights <- reader$tgread_object()
  EditBannedRequest$new(channel = channel, participant = participant, banned_rights = banned_rights)
}


#  @title EditCreatorRequest
#  @description Represents a request to edit the creator of a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name EditCreatorRequest_from_reader
# @param reader The reader object.
# @return An instance of EditCreatorRequest.
EditCreatorRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  user_id <- reader$tgread_object()
  password <- reader$tgread_object()
  EditCreatorRequest$new(channel = channel, user_id = user_id, password = password)
}

#  @title EditForumTopicRequest
#  @description Represents a request to edit a forum topic in a channel.
#  @export
#  @noRd
#  @noRd
EditForumTopicRequest <- R6::R6Class(
  "EditForumTopicRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xf4dfa185,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field topic_id Field.
    topic_id = NULL,
    #  @field title Field.
    title = NULL,
    #  @field icon_emoji_id Field.
    icon_emoji_id = NULL,
    #  @field closed Field.
    closed = NULL,
    #  @field hidden Field.
    hidden = NULL,

    #  @description Initialize the EditForumTopicRequest.
    #  @param channel The input channel.
    #  @param topic_id The topic ID.
    #  @param title The title (optional).
    #  @param icon_emoji_id The icon emoji ID (optional).
    #  @param closed Whether the topic is closed (optional).
    #  @param hidden Whether the topic is hidden (optional).
    initialize = function(channel, topic_id, title = NULL, icon_emoji_id = NULL, closed = NULL, hidden = NULL) {
      self$channel <- channel
      self$topic_id <- topic_id
      self$title <- title
      self$icon_emoji_id <- icon_emoji_id
      self$closed <- closed
      self$hidden <- hidden
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
        "_" = "EditForumTopicRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        topic_id = self$topic_id,
        title = self$title,
        icon_emoji_id = self$icon_emoji_id,
        closed = self$closed,
        hidden = self$hidden
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$title) || !self$title) 0 else 1) |
        (if (is.null(self$icon_emoji_id) || !self$icon_emoji_id) 0 else 2) |
        (if (is.null(self$closed)) 0 else 4) |
        (if (is.null(self$hidden)) 0 else 8)
      c(
        as.raw(c(0x85, 0xa1, 0xdf, 0xf4)),
        pack("<I", flags),
        self$channel$bytes(),
        pack("<i", self$topic_id),
        if (!is.null(self$title) && self$title) self$serialize_bytes(self$title) else raw(0),
        if (!is.null(self$icon_emoji_id) && self$icon_emoji_id) pack("<q", self$icon_emoji_id) else raw(0),
        if (!is.null(self$closed)) (if (self$closed) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))) else raw(0),
        if (!is.null(self$hidden)) (if (self$hidden) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))) else raw(0)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Deserialize from a reader.
# @name EditForumTopicRequest_from_reader
# @param reader The reader object.
# @return An instance of EditForumTopicRequest.
EditForumTopicRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  channel <- reader$tgread_object()
  topic_id <- reader$read_int()
  title <- if ((flags && 1) != 0) reader$tgread_string() else NULL
  icon_emoji_id <- if ((flags && 2) != 0) reader$read_long() else NULL
  closed <- if ((flags && 4) != 0) reader$tgread_bool() else NULL
  hidden <- if ((flags && 8) != 0) reader$tgread_bool() else NULL
  EditForumTopicRequest$new(channel = channel, topic_id = topic_id, title = title, icon_emoji_id = icon_emoji_id, closed = closed, hidden = hidden)
}

#  @title EditLocationRequest
#  @description Represents a request to edit the location of a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name EditLocationRequest_from_reader
# @param reader The reader object.
# @return An instance of EditLocationRequest.
EditLocationRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  geo_point <- reader$tgread_object()
  address <- reader$tgread_string()
  EditLocationRequest$new(channel = channel, geo_point = geo_point, address = address)
}


#  @title EditPhotoRequest
#  @description Represents a request to edit the photo of a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name EditPhotoRequest_from_reader
# @param reader The reader object.
# @return An instance of EditPhotoRequest.
EditPhotoRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  photo <- reader$tgread_object()
  EditPhotoRequest$new(channel = channel, photo = photo)
}

#  @title EditTitleRequest
#  @description Represents a request to edit the title of a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name EditTitleRequest_from_reader
# @param reader The reader object.
# @return An instance of EditTitleRequest.
EditTitleRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  title <- reader$tgread_string()
  EditTitleRequest$new(channel = channel, title = title)
}

#  @title ExportMessageLinkRequest
#  @description Represents a request to export a message link from a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name ExportMessageLinkRequest_from_reader
# @param reader The reader object.
# @return An instance of ExportMessageLinkRequest.
ExportMessageLinkRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  grouped <- (flags & 1) != 0
  thread <- (flags & 2) != 0
  channel <- reader$tgread_object()
  id <- reader$read_int()
  ExportMessageLinkRequest$new(channel = channel, id = id, grouped = grouped, thread = thread)
}


#  @title GetAdminLogRequest
#  @description Represents a request to get the admin log for a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name GetAdminLogRequest_from_reader
# @param reader The reader object.
# @return An instance of GetAdminLogRequest.
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

#  @title GetAdminedPublicChannelsRequest
#  @description Represents a request to get admined public channels.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name GetAdminedPublicChannelsRequest_from_reader
# @param reader The reader object.
# @return An instance of GetAdminedPublicChannelsRequest.
GetAdminedPublicChannelsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  by_location <- (flags & 1) != 0
  check_limit <- (flags & 2) != 0
  for_personal <- (flags & 4) != 0
  GetAdminedPublicChannelsRequest$new(by_location = by_location, check_limit = check_limit, for_personal = for_personal)
}

#  @title GetChannelRecommendationsRequest
#  @description Represents a request to get channel recommendations.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name GetChannelRecommendationsRequest_from_reader
# @param reader The reader object.
# @return An instance of GetChannelRecommendationsRequest.
GetChannelRecommendationsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  channel <- if ((flags && 1) != 0) reader$tgread_object() else NULL
  GetChannelRecommendationsRequest$new(channel = channel)
}


#  @title GetChannelsRequest
#  @description Represents a request to get channels by their IDs.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name GetChannelsRequest_from_reader
# @param reader The reader object.
# @return An instance of GetChannelsRequest.
GetChannelsRequest$from_reader <- function(reader) {
  reader$read_int()
  id <- list()
  for (i in seq_len(reader$read_int())) {
    x <- reader$tgread_object()
    id <- c(id, x)
  }
  GetChannelsRequest$new(id = id)
}

#  @title GetForumTopicsRequest
#  @description Represents a request to get forum topics from a channel.
#  @export
#  @noRd
#  @noRd
GetForumTopicsRequest <- R6::R6Class(
  "GetForumTopicsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xde560d1,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8e1d3e1e,
    #  @field channel Field.
    channel = NULL,
    #  @field offset_date Field.
    offset_date = NULL,
    #  @field offset_id Field.
    offset_id = NULL,
    #  @field offset_topic Field.
    offset_topic = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field q Field.
    q = NULL,

    #  @description Initialize the GetForumTopicsRequest.
    #  @param channel The input channel.
    #  @param offset_date The offset date for pagination.
    #  @param offset_id The offset ID for pagination.
    #  @param offset_topic The offset topic for pagination.
    #  @param limit The limit on the number of results.
    #  @param q The query string (optional).
    initialize = function(channel, offset_date, offset_id, offset_topic, limit, q = NULL) {
      self$channel <- channel
      self$offset_date <- offset_date
      self$offset_id <- offset_id
      self$offset_topic <- offset_topic
      self$limit <- limit
      self$q <- q
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
        "_" = "GetForumTopicsRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        offset_date = self$offset_date,
        offset_id = self$offset_id,
        offset_topic = self$offset_topic,
        limit = self$limit,
        q = self$q
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$q) || !self$q) 0 else 1
      c(
        as.raw(c(0xd1, 0x60, 0xe5, 0x0d)),
        pack("<I", flags),
        self$channel$bytes(),
        if (!is.null(self$q) && self$q) self$serialize_bytes(self$q) else raw(0),
        self$serialize_datetime(self$offset_date),
        pack("<i", self$offset_id),
        pack("<i", self$offset_topic),
        pack("<i", self$limit)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Deserialize from a reader.
# @name GetForumTopicsRequest_from_reader
# @param reader The reader object.
# @return An instance of GetForumTopicsRequest.
GetForumTopicsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  channel <- reader$tgread_object()
  q <- if ((flags && 1) != 0) reader$tgread_string() else NULL
  offset_date <- reader$tgread_date()
  offset_id <- reader$read_int()
  offset_topic <- reader$read_int()
  limit <- reader$read_int()
  GetForumTopicsRequest$new(channel = channel, offset_date = offset_date, offset_id = offset_id, offset_topic = offset_topic, limit = limit, q = q)
}

#  @title GetForumTopicsByIDRequest
#  @description Represents a request to get forum topics by their IDs from a channel.
#  @export
#  @noRd
#  @noRd
GetForumTopicsByIDRequest <- R6::R6Class(
  "GetForumTopicsByIDRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xb0831eb9,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8e1d3e1e,
    #  @field channel Field.
    channel = NULL,
    #  @field topics Field.
    topics = NULL,

    #  @description Initialize the GetForumTopicsByIDRequest.
    #  @param channel The input channel.
    #  @param topics The list of topic IDs.
    initialize = function(channel, topics) {
      self$channel <- channel
      self$topics <- topics
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
        "_" = "GetForumTopicsByIDRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        topics = if (is.null(self$topics)) list() else self$topics
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xb9, 0x1e, 0x83, 0xb0)),
        self$channel$bytes(),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        pack("<i", length(self$topics)),
        do.call(c, lapply(self$topics, function(x) pack("<i", x)))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Deserialize from a reader.
# @name GetForumTopicsByIDRequest_from_reader
# @param reader The reader object.
# @return An instance of GetForumTopicsByIDRequest.
GetForumTopicsByIDRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  reader$read_int()
  topics <- list()
  for (i in seq_len(reader$read_int())) {
    x <- reader$read_int()
    topics <- c(topics, x)
  }
  GetForumTopicsByIDRequest$new(channel = channel, topics = topics)
}


#  @title GetFullChannelRequest
#  @description Represents a request to get full information about a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name GetFullChannelRequest_from_reader
# @param reader The reader object.
# @return An instance of GetFullChannelRequest.
GetFullChannelRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  GetFullChannelRequest$new(channel = channel)
}

#  @title GetGroupsForDiscussionRequest
#  @description Represents a request to get groups available for discussion.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name GetGroupsForDiscussionRequest_from_reader
# @param reader The reader object.
# @return An instance of GetGroupsForDiscussionRequest.
GetGroupsForDiscussionRequest$from_reader <- function(reader) {
  GetGroupsForDiscussionRequest$new()
}

#  @title GetInactiveChannelsRequest
#  @description Represents a request to get inactive channels.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name GetInactiveChannelsRequest_from_reader
# @param reader The reader object.
# @return An instance of GetInactiveChannelsRequest.
GetInactiveChannelsRequest$from_reader <- function(reader) {
  GetInactiveChannelsRequest$new()
}


#  @title GetLeftChannelsRequest
#  @description Represents a request to get left channels with an offset.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name GetLeftChannelsRequest_from_reader
# @param reader The reader object.
# @return An instance of GetLeftChannelsRequest.
GetLeftChannelsRequest$from_reader <- function(reader) {
  offset <- reader$read_int()
  GetLeftChannelsRequest$new(offset = offset)
}

#  @title GetMessageAuthorRequest
#  @description Represents a request to get the author of a message in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name GetMessageAuthorRequest_from_reader
# @param reader The reader object.
# @return An instance of GetMessageAuthorRequest.
GetMessageAuthorRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  id <- reader$read_int()
  GetMessageAuthorRequest$new(channel = channel, id = id)
}

#  @title GetMessagesRequest
#  @description Represents a request to get messages from a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name GetMessagesRequest_from_reader
# @param reader The reader object.
# @return An instance of GetMessagesRequest.
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


#  @title GetParticipantRequest
#  @description Represents a request to get a participant from a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name GetParticipantRequest_from_reader
# @param reader The reader object.
# @return An instance of GetParticipantRequest.
GetParticipantRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  participant <- reader$tgread_object()
  GetParticipantRequest$new(channel = channel, participant = participant)
}

#  @title GetParticipantsRequest
#  @description Represents a request to get participants from a channel with filtering.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name GetParticipantsRequest_from_reader
# @param reader The reader object.
# @return An instance of GetParticipantsRequest.
GetParticipantsRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  filter <- reader$tgread_object()
  offset <- reader$read_int()
  limit <- reader$read_int()
  hash <- reader$read_long()
  GetParticipantsRequest$new(channel = channel, filter = filter, offset = offset, limit = limit, hash = hash)
}

#  @title GetSendAsRequest
#  @description Represents a request to get send-as peers for a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name GetSendAsRequest_from_reader
# @param reader The reader object.
# @return An instance of GetSendAsRequest.
GetSendAsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  for_paid_reactions <- (flags & 1) != 0
  peer <- reader$tgread_object()
  GetSendAsRequest$new(peer = peer, for_paid_reactions = for_paid_reactions)
}


#  @title InviteToChannelRequest
#  @description Represents a request to invite users to a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name InviteToChannelRequest_from_reader
# @param reader The reader object.
# @return An instance of InviteToChannelRequest.
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

#  @title JoinChannelRequest
#  @description Represents a request to join a channel.
#  @export
#  @noRd
#  @noRd
JoinChannelRequest <- R6::R6Class(
  "JoinChannelRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x24b524c5,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,

    #  @description Initialize the JoinChannelRequest.
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
        "_" = "JoinChannelRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xc5, 0x24, 0xb5, 0x24)),
        self$channel$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Deserialize from a reader.
# @name JoinChannelRequest_from_reader
# @param reader The reader object.
# @return An instance of JoinChannelRequest.
JoinChannelRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  JoinChannelRequest$new(channel = channel)
}

#  @title LeaveChannelRequest
#  @description Represents a request to leave a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name LeaveChannelRequest_from_reader
# @param reader The reader object.
# @return An instance of LeaveChannelRequest.
LeaveChannelRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  LeaveChannelRequest$new(channel = channel)
}


#  @title ReadHistoryRequest
#  @description Represents a request to read the history of a channel up to a maximum ID.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name ReadHistoryRequest_from_reader
# @param reader The reader object.
# @return An instance of ReadHistoryRequest.
ReadHistoryRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  max_id <- reader$read_int()
  ReadHistoryRequest$new(channel = channel, max_id = max_id)
}

#  @title ReadMessageContentsRequest
#  @description Represents a request to read the contents of specific messages in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name ReadMessageContentsRequest_from_reader
# @param reader The reader object.
# @return An instance of ReadMessageContentsRequest.
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


#  @title ReorderPinnedForumTopicsRequest
#  @description Represents a request to reorder pinned forum topics in a channel.
#  @export
#  @noRd
#  @noRd
ReorderPinnedForumTopicsRequest <- R6::R6Class(
  "ReorderPinnedForumTopicsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x2950a18f,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field order Field.
    order = NULL,
    #  @field force Field.
    force = NULL,

    #  @description Initialize the ReorderPinnedForumTopicsRequest.
    #  @param channel The input channel.
    #  @param order The list of topic IDs in the new order.
    #  @param force Whether to force the reorder.
    initialize = function(channel, order, force = NULL) {
      self$channel <- channel
      self$order <- order
      self$force <- force
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
        "_" = "ReorderPinnedForumTopicsRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        order = if (is.null(self$order)) list() else self$order,
        force = self$force
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$force) || !self$force) 0 else 1
      c(
        as.raw(c(0x8f, 0xa1, 0x50, 0x29)),
        pack("<I", flags),
        self$channel$bytes(),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        pack("<i", length(self$order)),
        do.call(c, lapply(self$order, function(x) pack("<i", x)))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Deserialize from a reader.
# @name ReorderPinnedForumTopicsRequest_from_reader
# @param reader The reader object.
# @return An instance of ReorderPinnedForumTopicsRequest.
ReorderPinnedForumTopicsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  force <- (flags & 1) != 0
  channel <- reader$tgread_object()
  reader$read_int()
  order <- list()
  for (i in seq_len(reader$read_int())) {
    x <- reader$read_int()
    order <- c(order, x)
  }
  ReorderPinnedForumTopicsRequest$new(channel = channel, order = order, force = force)
}

#  @title ReorderUsernamesRequest
#  @description Represents a request to reorder usernames in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name ReorderUsernamesRequest_from_reader
# @param reader The reader object.
# @return An instance of ReorderUsernamesRequest.
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

#  @title ReportAntiSpamFalsePositiveRequest
#  @description Represents a request to report an anti-spam false positive in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name ReportAntiSpamFalsePositiveRequest_from_reader
# @param reader The reader object.
# @return An instance of ReportAntiSpamFalsePositiveRequest.
ReportAntiSpamFalsePositiveRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  msg_id <- reader$read_int()
  ReportAntiSpamFalsePositiveRequest$new(channel = channel, msg_id = msg_id)
}


#  @title ReportSpamRequest
#  @description Represents a request to report spam in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name ReportSpamRequest_from_reader
# @param reader The reader object.
# @return An instance of ReportSpamRequest.
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

#  @title RestrictSponsoredMessagesRequest
#  @description Represents a request to restrict sponsored messages in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name RestrictSponsoredMessagesRequest_from_reader
# @param reader The reader object.
# @return An instance of RestrictSponsoredMessagesRequest.
RestrictSponsoredMessagesRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  restricted <- reader$tgread_bool()
  RestrictSponsoredMessagesRequest$new(channel = channel, restricted = restricted)
}


#  @title SearchPostsRequest
#  @description Represents a request to search for posts with specified parameters.
#  @export
#  @noRd
#  @noRd
SearchPostsRequest <- R6::R6Class(
  "SearchPostsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xf2c4f24d,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xd4b40b5e,
    #  @field offset_rate Field.
    offset_rate = NULL,
    #  @field offset_peer Field.
    offset_peer = NULL,
    #  @field offset_id Field.
    offset_id = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field hashtag Field.
    hashtag = NULL,
    #  @field query Field.
    query = NULL,
    #  @field allow_paid_stars Field.
    allow_paid_stars = NULL,

    #  @description Initialize the SearchPostsRequest.
    #  @param offset_rate The offset rate for pagination.
    #  @param offset_peer The offset peer for pagination.
    #  @param offset_id The offset ID for pagination.
    #  @param limit The limit on the number of results.
    #  @param hashtag The hashtag to search for (optional).
    #  @param query The query string to search for (optional).
    #  @param allow_paid_stars The number of allowed paid stars (optional).
    initialize = function(offset_rate, offset_peer, offset_id, limit, hashtag = NULL, query = NULL, allow_paid_stars = NULL) {
      self$offset_rate <- offset_rate
      self$offset_peer <- offset_peer
      self$offset_id <- offset_id
      self$limit <- limit
      self$hashtag <- hashtag
      self$query <- query
      self$allow_paid_stars <- allow_paid_stars
    },

    #  @description Resolve the offset_peer entity.
    #  @param client The client object.
    #  @param utils The utilities object.
    resolve = function(client, utils) {
      self$offset_peer <- utils$get_input_peer(client$get_input_entity(self$offset_peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SearchPostsRequest",
        offset_rate = self$offset_rate,
        offset_peer = if (inherits(self$offset_peer, "TLObject")) self$offset_peer$to_dict() else self$offset_peer,
        offset_id = self$offset_id,
        limit = self$limit,
        hashtag = self$hashtag,
        query = self$query,
        allow_paid_stars = self$allow_paid_stars
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$hashtag) || !self$hashtag) 0 else 1) |
        (if (is.null(self$query) || !self$query) 0 else 2) |
        (if (is.null(self$allow_paid_stars) || !self$allow_paid_stars) 0 else 4)
      c(
        as.raw(c(0x4d, 0xf2, 0xc4, 0xf2)),
        pack("<I", flags),
        if (!is.null(self$hashtag) && self$hashtag) self$serialize_bytes(self$hashtag) else raw(0),
        if (!is.null(self$query) && self$query) self$serialize_bytes(self$query) else raw(0),
        pack("<i", self$offset_rate),
        self$offset_peer$bytes(),
        pack("<i", self$offset_id),
        pack("<i", self$limit),
        if (!is.null(self$allow_paid_stars) && self$allow_paid_stars) pack("<q", self$allow_paid_stars) else raw(0)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Deserialize from a reader.
# @name SearchPostsRequest_from_reader
# @param reader The reader object.
# @return An instance of SearchPostsRequest.
SearchPostsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  hashtag <- if ((flags && 1) != 0) reader$tgread_string() else NULL
  query <- if ((flags && 2) != 0) reader$tgread_string() else NULL
  offset_rate <- reader$read_int()
  offset_peer <- reader$tgread_object()
  offset_id <- reader$read_int()
  limit <- reader$read_int()
  allow_paid_stars <- if ((flags && 4) != 0) reader$read_long() else NULL
  SearchPostsRequest$new(offset_rate = offset_rate, offset_peer = offset_peer, offset_id = offset_id, limit = limit, hashtag = hashtag, query = query, allow_paid_stars = allow_paid_stars)
}

#  @title SetBoostsToUnblockRestrictionsRequest
#  @description Represents a request to set the number of boosts to unblock restrictions in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name SetBoostsToUnblockRestrictionsRequest_from_reader
# @param reader The reader object.
# @return An instance of SetBoostsToUnblockRestrictionsRequest.
SetBoostsToUnblockRestrictionsRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  boosts <- reader$read_int()
  SetBoostsToUnblockRestrictionsRequest$new(channel = channel, boosts = boosts)
}


#  @title SetDiscussionGroupRequest
#  @description Represents a request to set the discussion group for a broadcast channel.
#  @export
#  @noRd
#  @noRd
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
        as.raw(c(0xb2, 0x5b, 0x58, 0x40)),
        self$broadcast$bytes(),
        self$group$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Deserialize from a reader.
# @name SetDiscussionGroupRequest_from_reader
# @param reader The reader object.
# @return An instance of SetDiscussionGroupRequest.
SetDiscussionGroupRequest$from_reader <- function(reader) {
  broadcast <- reader$tgread_object()
  group <- reader$tgread_object()
  SetDiscussionGroupRequest$new(broadcast = broadcast, group = group)
}

#  @title SetEmojiStickersRequest
#  @description Represents a request to set emoji stickers for a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name SetEmojiStickersRequest_from_reader
# @param reader The reader object.
# @return An instance of SetEmojiStickersRequest.
SetEmojiStickersRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  stickerset <- reader$tgread_object()
  SetEmojiStickersRequest$new(channel = channel, stickerset = stickerset)
}

#  @title SetMainProfileTabRequest
#  @description Represents a request to set the main profile tab for a channel.
#  @export
#  @noRd
#  @noRd
SetMainProfileTabRequest <- R6::R6Class(
  "SetMainProfileTabRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x3583fcb1,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field channel Field.
    channel = NULL,
    #  @field tab Field.
    tab = NULL,

    #  @description Initialize the SetMainProfileTabRequest.
    #  @param channel The input channel.
    #  @param tab The profile tab.
    initialize = function(channel, tab) {
      self$channel <- channel
      self$tab <- tab
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
        "_" = "SetMainProfileTabRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        tab = if (inherits(self$tab, "TLObject")) self$tab$to_dict() else self$tab
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xb1, 0xfc, 0x83, 0x35)),
        self$channel$bytes(),
        self$tab$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Deserialize from a reader.
# @name SetMainProfileTabRequest_from_reader
# @param reader The reader object.
# @return An instance of SetMainProfileTabRequest.
SetMainProfileTabRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  tab <- reader$tgread_object()
  SetMainProfileTabRequest$new(channel = channel, tab = tab)
}


#  @title SetStickersRequest
#  @description Represents a request to set stickers for a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name SetStickersRequest_from_reader
# @param reader The reader object.
# @return An instance of SetStickersRequest.
SetStickersRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  stickerset <- reader$tgread_object()
  SetStickersRequest$new(channel = channel, stickerset = stickerset)
}

#  @title ToggleAntiSpamRequest
#  @description Represents a request to toggle anti-spam in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name ToggleAntiSpamRequest_from_reader
# @param reader The reader object.
# @return An instance of ToggleAntiSpamRequest.
ToggleAntiSpamRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  enabled <- reader$tgread_bool()
  ToggleAntiSpamRequest$new(channel = channel, enabled = enabled)
}

#  @title ToggleAutotranslationRequest
#  @description Represents a request to toggle autotranslation in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name ToggleAutotranslationRequest_from_reader
# @param reader The reader object.
# @return An instance of ToggleAutotranslationRequest.
ToggleAutotranslationRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  enabled <- reader$tgread_bool()
  ToggleAutotranslationRequest$new(channel = channel, enabled = enabled)
}


#  @title ToggleForumRequest
#  @description Represents a request to toggle the forum feature in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name ToggleForumRequest_from_reader
# @param reader The reader object.
# @return An instance of ToggleForumRequest.
ToggleForumRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  enabled <- reader$tgread_bool()
  tabs <- reader$tgread_bool()
  ToggleForumRequest$new(channel = channel, enabled = enabled, tabs = tabs)
}

#  @title ToggleJoinRequestRequest
#  @description Represents a request to toggle join requests in a channel.
#  @export
#  @noRd
#  @noRd
ToggleJoinRequestRequest <- R6::R6Class(
  "ToggleJoinRequestRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x4c2985b6,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field enabled Field.
    enabled = NULL,

    #  @description Initialize the ToggleJoinRequestRequest.
    #  @param channel The input channel.
    #  @param enabled Whether join requests are enabled.
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
        "_" = "ToggleJoinRequestRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        enabled = self$enabled
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xb6, 0x85, 0x29, 0x4c)),
        self$channel$bytes(),
        if (self$enabled) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Deserialize from a reader.
# @name ToggleJoinRequestRequest_from_reader
# @param reader The reader object.
# @return An instance of ToggleJoinRequestRequest.
ToggleJoinRequestRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  enabled <- reader$tgread_bool()
  ToggleJoinRequestRequest$new(channel = channel, enabled = enabled)
}

#  @title ToggleJoinToSendRequest
#  @description Represents a request to toggle join to send in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name ToggleJoinToSendRequest_from_reader
# @param reader The reader object.
# @return An instance of ToggleJoinToSendRequest.
ToggleJoinToSendRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  enabled <- reader$tgread_bool()
  ToggleJoinToSendRequest$new(channel = channel, enabled = enabled)
}


#  @title ToggleParticipantsHiddenRequest
#  @description Represents a request to toggle the hidden status of participants in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name ToggleParticipantsHiddenRequest_from_reader
# @param reader The reader object.
# @return An instance of ToggleParticipantsHiddenRequest.
ToggleParticipantsHiddenRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  enabled <- reader$tgread_bool()
  ToggleParticipantsHiddenRequest$new(channel = channel, enabled = enabled)
}

#  @title TogglePreHistoryHiddenRequest
#  @description Represents a request to toggle the hidden status of pre-history in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name TogglePreHistoryHiddenRequest_from_reader
# @param reader The reader object.
# @return An instance of TogglePreHistoryHiddenRequest.
TogglePreHistoryHiddenRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  enabled <- reader$tgread_bool()
  TogglePreHistoryHiddenRequest$new(channel = channel, enabled = enabled)
}

#  @title ToggleSignaturesRequest
#  @description Represents a request to toggle signatures in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name ToggleSignaturesRequest_from_reader
# @param reader The reader object.
# @return An instance of ToggleSignaturesRequest.
ToggleSignaturesRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  signatures_enabled <- (flags & 1) != 0
  profiles_enabled <- (flags & 2) != 0
  channel <- reader$tgread_object()
  ToggleSignaturesRequest$new(channel = channel, signatures_enabled = signatures_enabled, profiles_enabled = profiles_enabled)
}


#  @title ToggleSlowModeRequest
#  @description Represents a request to toggle slow mode in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name ToggleSlowModeRequest_from_reader
# @param reader The reader object.
# @return An instance of ToggleSlowModeRequest.
ToggleSlowModeRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  seconds <- reader$read_int()
  ToggleSlowModeRequest$new(channel = channel, seconds = seconds)
}

#  @title ToggleUsernameRequest
#  @description Represents a request to toggle the active status of a username in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name ToggleUsernameRequest_from_reader
# @param reader The reader object.
# @return An instance of ToggleUsernameRequest.
ToggleUsernameRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  username <- reader$tgread_string()
  active <- reader$tgread_bool()
  ToggleUsernameRequest$new(channel = channel, username = username, active = active)
}

#  @title ToggleViewForumAsMessagesRequest
#  @description Represents a request to toggle viewing a forum as messages in a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name ToggleViewForumAsMessagesRequest_from_reader
# @param reader The reader object.
# @return An instance of ToggleViewForumAsMessagesRequest.
ToggleViewForumAsMessagesRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  enabled <- reader$tgread_bool()
  ToggleViewForumAsMessagesRequest$new(channel = channel, enabled = enabled)
}


#  @title UpdateColorRequest
#  @description Represents a request to update the color settings of a channel.
#  @export
#  @noRd
#  @noRd
UpdateColorRequest <- R6::R6Class(
  "UpdateColorRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xd8aa3671,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field for_profile Field.
    for_profile = NULL,
    #  @field color Field.
    color = NULL,
    #  @field background_emoji_id Field.
    background_emoji_id = NULL,

    #  @description Initialize the UpdateColorRequest.
    #  @param channel The input channel.
    #  @param for_profile Whether the color is for the profile.
    #  @param color The color value.
    #  @param background_emoji_id The background emoji ID.
    initialize = function(channel, for_profile = NULL, color = NULL, background_emoji_id = NULL) {
      self$channel <- channel
      self$for_profile <- for_profile
      self$color <- color
      self$background_emoji_id <- background_emoji_id
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
        "_" = "UpdateColorRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        for_profile = self$for_profile,
        color = self$color,
        background_emoji_id = self$background_emoji_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$for_profile) || !self$for_profile) 0 else 2) |
        (if (is.null(self$color) || !self$color) 0 else 4) |
        (if (is.null(self$background_emoji_id) || !self$background_emoji_id) 0 else 1)
      c(
        as.raw(c(0x71, 0x36, 0xaa, 0xd8)),
        pack("<I", flags),
        self$channel$bytes(),
        if (!is.null(self$color) && self$color) pack("<i", self$color) else raw(0),
        if (!is.null(self$background_emoji_id) && self$background_emoji_id) pack("<q", self$background_emoji_id) else raw(0)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Deserialize from a reader.
# @name UpdateColorRequest_from_reader
# @param reader The reader object.
# @return An instance of UpdateColorRequest.
UpdateColorRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  for_profile <- (flags & 2) != 0
  channel <- reader$tgread_object()
  color <- if ((flags && 4) != 0) reader$read_int() else NULL
  background_emoji_id <- if ((flags && 1) != 0) reader$read_long() else NULL
  UpdateColorRequest$new(channel = channel, for_profile = for_profile, color = color, background_emoji_id = background_emoji_id)
}

#  @title UpdateEmojiStatusRequest
#  @description Represents a request to update the emoji status of a channel.
#  @export
#  @noRd
#  @noRd
UpdateEmojiStatusRequest <- R6::R6Class(
  "UpdateEmojiStatusRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xf0d3e6a8,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field emoji_status Field.
    emoji_status = NULL,

    #  @description Initialize the UpdateEmojiStatusRequest.
    #  @param channel The input channel.
    #  @param emoji_status The emoji status.
    initialize = function(channel, emoji_status) {
      self$channel <- channel
      self$emoji_status <- emoji_status
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
        "_" = "UpdateEmojiStatusRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        emoji_status = if (inherits(self$emoji_status, "TLObject")) self$emoji_status$to_dict() else self$emoji_status
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xa8, 0xe6, 0xd3, 0xf0)),
        self$channel$bytes(),
        self$emoji_status$bytes()
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Deserialize from a reader.
# @name UpdateEmojiStatusRequest_from_reader
# @param reader The reader object.
# @return An instance of UpdateEmojiStatusRequest.
UpdateEmojiStatusRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  emoji_status <- reader$tgread_object()
  UpdateEmojiStatusRequest$new(channel = channel, emoji_status = emoji_status)
}

#  @title UpdatePaidMessagesPriceRequest
#  @description Represents a request to update the paid messages price for a channel.
#  @export
#  @noRd
#  @noRd
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

# Deserialize from a reader.
# @name UpdatePaidMessagesPriceRequest_from_reader
# @param reader The reader object.
# @return An instance of UpdatePaidMessagesPriceRequest.
UpdatePaidMessagesPriceRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  broadcast_messages_allowed <- (flags & 1) != 0
  channel <- reader$tgread_object()
  send_paid_messages_stars <- reader$read_long()
  UpdatePaidMessagesPriceRequest$new(channel = channel, send_paid_messages_stars = send_paid_messages_stars, broadcast_messages_allowed = broadcast_messages_allowed)
}


#  @title UpdatePinnedForumTopicRequest
#  @description Represents a request to update the pinned status of a forum topic in a channel.
#  @export
#  @noRd
#  @noRd
UpdatePinnedForumTopicRequest <- R6::R6Class(
  "UpdatePinnedForumTopicRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x6c2d9026,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field channel Field.
    channel = NULL,
    #  @field topic_id Field.
    topic_id = NULL,
    #  @field pinned Field.
    pinned = NULL,

    #  @description Initialize the UpdatePinnedForumTopicRequest.
    #  @param channel The input channel.
    #  @param topic_id The ID of the topic.
    #  @param pinned Whether the topic is pinned.
    initialize = function(channel, topic_id, pinned) {
      self$channel <- channel
      self$topic_id <- topic_id
      self$pinned <- pinned
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
        "_" = "UpdatePinnedForumTopicRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        topic_id = self$topic_id,
        pinned = self$pinned
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x26, 0x90, 0x2d, 0x6c)),
        self$channel$bytes(),
        pack("<i", self$topic_id),
        if (self$pinned) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Deserialize from a reader.
# @name UpdatePinnedForumTopicRequest_from_reader
# @param reader The reader object.
# @return An instance of UpdatePinnedForumTopicRequest.
UpdatePinnedForumTopicRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  topic_id <- reader$read_int()
  pinned <- reader$tgread_bool()
  UpdatePinnedForumTopicRequest$new(channel = channel, topic_id = topic_id, pinned = pinned)
}

#  @title UpdateUsernameRequest
#  @description Represents a request to update the username of a channel.
#  @export
#  @noRd
#  @noRd
UpdateUsernameRequest <- R6::R6Class(
  "UpdateUsernameRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x3514b3de,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field channel Field.
    channel = NULL,
    #  @field username Field.
    username = NULL,

    #  @description Initialize the UpdateUsernameRequest.
    #  @param channel The input channel.
    #  @param username The new username.
    initialize = function(channel, username) {
      self$channel <- channel
      self$username <- username
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
        "_" = "UpdateUsernameRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_dict() else self$channel,
        username = self$username
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xde, 0xb3, 0x14, 0x35)),
        self$channel$bytes(),
        self$serialize_bytes(self$username)
      )
    }
  ),
  #  @field class Field.
  class = TRUE
)

# Deserialize from a reader.
# @name UpdateUsernameRequest_from_reader
# @param reader The reader object.
# @return An instance of UpdateUsernameRequest.
UpdateUsernameRequest$from_reader <- function(reader) {
  channel <- reader$tgread_object()
  username <- reader$tgread_string()
  UpdateUsernameRequest$new(channel = channel, username = username)
}
