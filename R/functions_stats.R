#' @title GetBroadcastStatsRequest
#' @description Telegram API request \code{stats.getBroadcastStats} (constructor \code{#ab42441a}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetBroadcastStatsRequest <- R6::R6Class(
  "GetBroadcastStatsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xab42441a,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x7ff25428,
    #  @field channel Field.
    channel = NULL,
    #  @field dark Field.
    dark = NULL,

    #  @description Initializes a new GetBroadcastStatsRequest.
    #  @param channel input channel object
    #  @param dark logical; optional dark flag
    initialize = function(channel, dark = NULL) {
      self$channel <- channel
      self$dark <- dark
    },

    #  @description Resolve input entities (expects client and utils helpers to exist)
    #  @param client The client instance to resolve entities.
    resolve = function(client) {
      self$channel <- get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert to a plain list (like to_dict)
    #  @return A list representing the request.
    to_list = function() {
      list(
        `_` = "GetBroadcastStatsRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_list() else self$channel,
        dark = self$dark
      )
    },

    #  @description Serialize to raw bytes (relies on channel$to_bytes() and helper utils in parent)
    #  @return A raw vector representing the serialized request.
    to_bytes = function() {
      con <- rawConnection(raw(), "r+")
      on.exit(close(con))
      # constructor bytes (little-endian): 0x1a 0x44 0x42 0xab
      writeBin(as.raw(c(0x1a, 0x44, 0x42, 0xab)), con)
      flags <- as.integer(ifelse(is.null(self$dark) || identical(self$dark, FALSE), 0L, 1L))
      writeBin(flags, con, size = 4, endian = "little")
      # channel assumed to implement to_bytes()
      writeBin(self$channel$to_bytes(), con)
      rawConnectionValue(con)
    },

    #  @description Create instance from a reader object (reader must provide read_int, tgread_object)
    #  @param reader A reader object to read the serialized data.
    #  @return A new instance of GetBroadcastStatsRequest.
    from_reader = function(reader) {
      flagsVal <- reader$read_int()
      darkFlag <- as.logical(bitwAnd(flagsVal, 1L))
      channelObj <- reader$tgread_object()
      GetBroadcastStatsRequest$new(channel = channelObj, dark = darkFlag)
    }
  )
)


#' @title GetMegagroupStatsRequest
#' @description Telegram API request \code{stats.getMegagroupStats} (constructor \code{#dcdf8607}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetMegagroupStatsRequest <- R6::R6Class(
  "GetMegagroupStatsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xdcdf8607,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x5b59be8d,
    #  @field channel Field.
    channel = NULL,
    #  @field dark Field.
    dark = NULL,

    #  @description Initializes a new GetMegagroupStatsRequest.
    #  @param channel input channel object
    #  @param dark logical; optional dark flag
    initialize = function(channel, dark = NULL) {
      self$channel <- channel
      self$dark <- dark
    },

    #  @description Resolve input entities (expects client and utils helpers to exist)
    #  @param client The client instance to resolve entities.
    resolve = function(client) {
      self$channel <- get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert to a plain list (like to_dict)
    #  @return A list representing the request.
    to_list = function() {
      list(
        `_` = "GetMegagroupStatsRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_list() else self$channel,
        dark = self$dark
      )
    },

    #  @description Serialize to raw bytes (relies on channel$to_bytes() and helper utils in parent)
    #  @return A raw vector representing the serialized request.
    to_bytes = function() {
      con <- rawConnection(raw(), "r+")
      on.exit(close(con))
      # constructor bytes (little-endian): 0x07 0x86 0xdf 0xdc
      writeBin(as.raw(c(0x07, 0x86, 0xdf, 0xdc)), con)
      flags <- as.integer(ifelse(is.null(self$dark) || identical(self$dark, FALSE), 0L, 1L))
      writeBin(flags, con, size = 4, endian = "little")
      # channel assumed to implement to_bytes()
      writeBin(self$channel$to_bytes(), con)
      rawConnectionValue(con)
    },

    #  @description Create instance from a reader object (reader must provide read_int, tgread_object)
    #  @param reader A reader object to read the serialized data.
    #  @return A new instance of GetMegagroupStatsRequest.
    from_reader = function(reader) {
      flagsVal <- reader$read_int()
      darkFlag <- as.logical(bitwAnd(flagsVal, 1L))
      channelObj <- reader$tgread_object()
      GetMegagroupStatsRequest$new(channel = channelObj, dark = darkFlag)
    }
  )
)


#' @title GetMessagePublicForwardsRequest
#' @description Telegram API request \code{stats.getMessagePublicForwards} (constructor \code{#5f150144}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetMessagePublicForwardsRequest <- R6::R6Class(
  "GetMessagePublicForwardsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x5f150144,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xa7283211,
    #  @field channel Field.
    channel = NULL,
    #  @field msg_id Field.
    msg_id = NULL,
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,

    #  @description Initializes a new GetMessagePublicForwardsRequest.
    #  @param channel input channel object
    #  @param msg_id integer message id
    #  @param offset character offset string
    #  @param limit integer limit
    initialize = function(channel, msg_id, offset, limit) {
      self$channel <- channel
      self$msg_id <- as.integer(msg_id)
      self$offset <- as.character(offset)
      self$limit <- as.integer(limit)
    },

    #  @description Resolve input entities (expects client and utils helpers to exist)
    #  @param client The client instance to resolve entities.
    resolve = function(client) {
      self$channel <- get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert to a plain list (like to_dict)
    #  @return A list representing the request.
    to_list = function() {
      list(
        `_` = "GetMessagePublicForwardsRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_list() else self$channel,
        msg_id = self$msg_id,
        offset = self$offset,
        limit = self$limit
      )
    },

    #  @description Serialize to raw bytes (relies on channel$to_bytes() and helper utils in parent)
    #  @return A raw vector representing the serialized request.
    to_bytes = function() {
      con <- rawConnection(raw(), "r+")
      on.exit(close(con))
      # constructor bytes (little-endian): 0x44 0x01 0x15 0x5f
      writeBin(as.raw(c(0x44, 0x01, 0x15, 0x5f)), con)
      # channel assumed to implement to_bytes()
      writeBin(self$channel$to_bytes(), con)
      writeBin(as.integer(self$msg_id), con, size = 4, endian = "little")
      # serialize offset using parent helper serialize_bytes if available
      if (!is.null(self$serialize_bytes)) {
        writeBin(self$serialize_bytes(self$offset), con)
      } else {
        offset_raw <- charToRaw(enc2utf8(self$offset))
        writeBin(as.integer(length(offset_raw)), con, size = 4, endian = "little")
        writeBin(offset_raw, con)
      }
      writeBin(as.integer(self$limit), con, size = 4, endian = "little")
      rawConnectionValue(con)
    },

    #  @description Create instance from a reader object (reader must provide tgread_object, read_int, tgread_string)
    #  @param reader A reader object to read the serialized data.
    #  @return A new instance of GetMessagePublicForwardsRequest.
    from_reader = function(reader) {
      channelObj <- reader$tgread_object()
      msgId <- reader$read_int()
      offsetVal <- reader$tgread_string()
      limitVal <- reader$read_int()
      GetMessagePublicForwardsRequest$new(channel = channelObj, msg_id = msgId, offset = offsetVal, limit = limitVal)
    }
  )
)


#' @title GetMessageStatsRequest
#' @description Telegram API request \code{stats.getMessageStats} (constructor \code{#b6e0a3f5}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetMessageStatsRequest <- R6::R6Class(
  "GetMessageStatsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xb6e0a3f5,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x9604a322,
    #  @field channel Field.
    channel = NULL,
    #  @field msg_id Field.
    msg_id = NULL,
    #  @field dark Field.
    dark = NULL,

    #  @description Initializes a new GetMessageStatsRequest.
    #  @param channel input channel object
    #  @param msg_id integer message id
    #  @param dark logical; optional dark flag
    initialize = function(channel, msg_id, dark = NULL) {
      self$channel <- channel
      self$msg_id <- as.integer(msg_id)
      self$dark <- dark
    },

    #  @description Resolve input entities (expects client and utils helpers to exist)
    #  @param client The client instance to resolve entities.
    resolve = function(client) {
      self$channel <- get_input_channel(client$get_input_entity(self$channel))
    },

    #  @description Convert to a plain list (like to_dict)
    #  @return A list representing the request.
    to_list = function() {
      list(
        `_` = "GetMessageStatsRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$to_list() else self$channel,
        msg_id = self$msg_id,
        dark = self$dark
      )
    },

    #  @description Serialize to raw bytes (relies on channel$to_bytes() and helper utils in parent)
    #  @return A raw vector representing the serialized request.
    to_bytes = function() {
      con <- rawConnection(raw(), "r+")
      on.exit(close(con))
      # constructor bytes (little-endian): 0xf5 0xa3 0xe0 0xb6
      writeBin(as.raw(c(0xf5, 0xa3, 0xe0, 0xb6)), con)
      flags <- as.integer(ifelse(is.null(self$dark) || identical(self$dark, FALSE), 0L, 1L))
      writeBin(flags, con, size = 4, endian = "little")
      # channel assumed to implement to_bytes()
      writeBin(self$channel$to_bytes(), con)
      writeBin(as.integer(self$msg_id), con, size = 4, endian = "little")
      rawConnectionValue(con)
    },

    #  @description Create instance from a reader object (reader must provide read_int, tgread_object, read_int)
    #  @param reader A reader object to read the serialized data.
    #  @return A raw vector representing the serialized request.
    from_reader = function(reader) {
      flagsVal <- reader$read_int()
      darkFlag <- as.logical(bitwAnd(flagsVal, 1L))
      channelObj <- reader$tgread_object()
      msgId <- reader$read_int()
      GetMessageStatsRequest$new(channel = channelObj, msg_id = msgId, dark = darkFlag)
    }
  )
)

#' @title GetStoryPublicForwardsRequest
#' @description Telegram API request \code{stats.getStoryPublicForwards} (constructor \code{#a6437ef6}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetStoryPublicForwardsRequest <- R6::R6Class(
  "GetStoryPublicForwardsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xa6437ef6,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xa7283211,
    #  @field peer Field.
    peer = NULL,
    #  @field id Field.
    id = NULL,
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,

    #  @description Initializes a new GetStoryPublicForwardsRequest.
    #  @param peer input peer object
    #  @param id integer story id
    #  @param offset character offset string
    #  @param limit integer limit
    initialize = function(peer, id, offset, limit) {
      self$peer <- peer
      self$id <- as.integer(id)
      self$offset <- as.character(offset)
      self$limit <- as.integer(limit)
    },

    #  @description Resolve input entities (expects client and utils helpers to exist)
    #  @param client The client instance to resolve entities.
    resolve = function(client) {
      self$peer <- get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert to a plain list (like to_dict)
    #  @return List representing the request.
    to_list = function() {
      list(
        `_` = "GetStoryPublicForwardsRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_list() else self$peer,
        id = self$id,
        offset = self$offset,
        limit = self$limit
      )
    },

    #  @description Serialize to raw bytes (relies on peer$to_bytes() and helper utils in parent)
    #  @return A raw vector representing the serialized request.
    to_bytes = function() {
      con <- rawConnection(raw(), "r+")
      on.exit(close(con))
      # constructor bytes (little-endian): 0xf6 0x7e 0x43 0xa6
      writeBin(as.raw(c(0xf6, 0x7e, 0x43, 0xa6)), con)
      # peer assumed to implement to_bytes()
      writeBin(self$peer$to_bytes(), con)
      writeBin(as.integer(self$id), con, size = 4, endian = "little")
      # serialize offset using parent helper serialize_bytes if available
      if (!is.null(self$serialize_bytes)) {
        writeBin(self$serialize_bytes(self$offset), con)
      } else {
        offset_raw <- charToRaw(enc2utf8(self$offset))
        writeBin(as.integer(length(offset_raw)), con, size = 4, endian = "little")
        writeBin(offset_raw, con)
      }
      writeBin(as.integer(self$limit), con, size = 4, endian = "little")
      rawConnectionValue(con)
    },

    #  @description Create instance from a reader object (reader must provide tgread_object, read_int, tgread_string)
    #  @param reader A reader object to read the serialized data.
    #  @return A new instance of GetStoryPublicForwardsRequest.
    from_reader = function(reader) {
      peerObj <- reader$tgread_object()
      idVal <- reader$read_int()
      offsetVal <- reader$tgread_string()
      limitVal <- reader$read_int()
      GetStoryPublicForwardsRequest$new(peer = peerObj, id = idVal, offset = offsetVal, limit = limitVal)
    }
  )
)


#' @title GetStoryStatsRequest
#' @description Telegram API request \code{stats.getStoryStats} (constructor \code{#374fef40}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetStoryStatsRequest <- R6::R6Class(
  "GetStoryStatsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x374fef40,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8b4d43d4,
    #  @field peer Field.
    peer = NULL,
    #  @field id Field.
    id = NULL,
    #  @field dark Field.
    dark = NULL,

    #  @description Initializes a new GetStoryStatsRequest.
    #  @param peer input peer object
    #  @param id integer story id
    #  @param dark logical; optional dark flag
    initialize = function(peer, id, dark = NULL) {
      self$peer <- peer
      self$id <- as.integer(id)
      self$dark <- dark
    },

    #  @description Resolve input entities (expects client and utils helpers to exist)
    #  @param client The client instance to resolve entities.
    resolve = function(client) {
      self$peer <- get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert to a plain list (like to_dict)
    #  @return List representing the request.
    to_list = function() {
      list(
        `_` = "GetStoryStatsRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_list() else self$peer,
        id = self$id,
        dark = self$dark
      )
    },

    #  @description Serialize to raw bytes (relies on peer$to_bytes() and helper utils in parent)
    #  @return List representing the request.
    to_bytes = function() {
      con <- rawConnection(raw(), "r+")
      on.exit(close(con))
      # constructor bytes: 0x40 0xef 0x4f 0x37
      writeBin(as.raw(c(0x40, 0xef, 0x4f, 0x37)), con)
      flags <- as.integer(ifelse(is.null(self$dark) || identical(self$dark, FALSE), 0L, 1L))
      writeBin(flags, con, size = 4, endian = "little")
      # peer assumed to implement to_bytes()
      writeBin(self$peer$to_bytes(), con)
      writeBin(as.integer(self$id), con, size = 4, endian = "little")
      rawConnectionValue(con)
    },

    #  @description Create instance from a reader object (reader must provide read_int, tgread_object, read_int)
    #  @param reader A reader object to read the serialized data.
    #  @return A raw vector representing the serialized request.
    from_reader = function(reader) {
      flags <- reader$read_int()
      darkFlag <- as.logical(bitwAnd(flags, 1L))
      peer_obj <- reader$tgread_object()
      id_val <- reader$read_int()
      GetStoryStatsRequest$new(peer = peer_obj, id = id_val, dark = darkFlag)
    }
  )
)

#' @title LoadAsyncGraphRequest
#' @description Telegram API request \code{stats.loadAsyncGraph} (constructor \code{#621d5fa0}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
LoadAsyncGraphRequest <- R6::R6Class("LoadAsyncGraphRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0x621d5fa0,
    SUBCLASS_OF_ID = 0x9b903153,
    token = NULL,
    x = NULL,
    initialize = function(token, x = NULL) {
      self$token <- token
      self$x <- x
    },
    to_dict = function() {
      list(
        `_` = "LoadAsyncGraphRequest",
        "token" = if (inherits(self$token, "TLObject")) self$token$to_dict() else self$token,
        "x" = if (inherits(self$x, "TLObject")) self$x$to_dict() else self$x
      )
    },
    to_list = function() {
      list(
        `_` = "LoadAsyncGraphRequest",
        "token" = if (inherits(self$token, "TLObject")) self$token$to_dict() else self$token,
        "x" = if (inherits(self$x, "TLObject")) self$x$to_dict() else self$x
      )
    },
    to_bytes = function() {
      flags <- 0L
      if (!is.null(self$x)) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0xa0, 0x5f, 0x1d, 0x62)),
        pack("<I", flags),
        serialize_bytes(self$token),
        if (!is.null(self$x)) packInt64(self$x) else raw(0)
      )
    },
    serialize = function() self$to_bytes()
  ),
  private = list(
    from_reader = function(reader) {
      flags <- reader$read_int()
      self$token <- reader$tgread_string()
      self$x <- if (bitwAnd(flags, 1L) != 0) reader$read_long() else NULL
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

