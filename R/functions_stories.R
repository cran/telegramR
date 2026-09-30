#' @title ActivateStealthModeRequest
#' @description Telegram API request \code{stories.activateStealthMode} (constructor \code{#57bbd166}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ActivateStealthModeRequest <- R6::R6Class(
  "ActivateStealthModeRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x57bbd166,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @field past Field.
    past = NULL,
    #  @field future Field.
    future = NULL,

    #  @description Initialize ActivateStealthModeRequest
    # 
    #  @param past logical or NULL
    #  @param future logical or NULL
    #  @return invisible self
    initialize = function(past = NULL, future = NULL) {
      self$past <- if (!is.null(past)) as.logical(past) else NULL
      self$future <- if (!is.null(future)) as.logical(future) else NULL
      invisible(self)
    },

    #  @description Convert to list
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "ActivateStealthModeRequest",
        past = self$past,
        future = self$future
      )
    },

    #  @description Serialize to raw TL bytes
    # 
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes little-endian for 0x57bbd166 -> 0x66 0xd1 0xbb 0x57
      parts[[1]] <- as.raw(c(0x66, 0xd1, 0xbb, 0x57))

      # flags: bit 0 = past, bit 1 = future
      flagsVal <- 0L
      if (!is.null(self$past) && isTRUE(self$past)) flagsVal <- bitwOr(flagsVal, 1L)
      if (!is.null(self$future) && isTRUE(self$future)) flagsVal <- bitwOr(flagsVal, 2L)

      parts[[length(parts) + 1]] <- writeBin(as.integer(flagsVal), raw(), size = 4, endian = "little")

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read an ActivateStealthModeRequest instance from a reader
    # 
    #  reader expected to implement: read_int()
    #  @param reader reader object
    #  @return ActivateStealthModeRequest
    from_reader = function(reader) {
      flagsVal <- reader$read_int()
      pastFlag <- bitwAnd(flagsVal, 1L) != 0L
      futureFlag <- bitwAnd(flagsVal, 2L) != 0L

      ActivateStealthModeRequest$new(
        past = if (pastFlag) TRUE else NULL,
        future = if (futureFlag) TRUE else NULL
      )
    }
  )
)


#' @title CanSendStoryRequest
#' @description Telegram API request \code{stories.canSendStory} (constructor \code{#30eb63f0}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
CanSendStoryRequest <- R6::R6Class(
  "CanSendStoryRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x30eb63f0,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xcb53a298,

    #  @field peer Field.
    peer = NULL,

    #  @description Initialize CanSendStoryRequest
    # 
    #  @param peer TypeInputPeer
    #  @return invisible self
    initialize = function(peer) {
      self$peer <- peer
      invisible(self)
    },

    #  @description Resolve peer references
    # 
    #  Convert high-level peer reference to an input peer using client/utils.
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "CanSendStoryRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer
      )
    },

    #  @description Serialize to raw TL bytes
    # 
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes little-endian for 0x30eb63f0 -> f0 63 eb 30
      parts[[1]] <- as.raw(c(0xf0, 0x63, 0xeb, 0x30))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a CanSendStoryRequest instance from a reader
    # 
    #  reader expected to implement: tgread_object()
    #  @param reader reader object
    #  @return CanSendStoryRequest
    from_reader = function(reader) {
      peerObj <- reader$tgread_object()
      CanSendStoryRequest$new(peer = peerObj)
    }
  )
)


#' @title CreateAlbumRequest
#' @description Telegram API request \code{stories.createAlbum} (constructor \code{#a36396e5}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
CreateAlbumRequest <- R6::R6Class(
  "CreateAlbumRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xa36396e5,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x7c8c5ea2,

    #  @field peer Field.
    peer = NULL,
    #  @field title Field.
    title = NULL,
    #  @field stories Field.
    stories = NULL,

    #  @description Initialize CreateAlbumRequest
    # 
    #  @param peer TypeInputPeer
    #  @param title character
    #  @param stories integer vector
    #  @return invisible self
    initialize = function(peer, title, stories) {
      self$peer <- peer
      self$title <- as.character(title)
      self$stories <- if (!is.null(stories)) as.integer(stories) else integer(0)
      invisible(self)
    },

    #  @description Resolve peer references
    # 
    #  Convert high-level peer reference to an input peer using client/utils.
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "CreateAlbumRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        title = self$title,
        stories = if (is.null(self$stories)) integer(0) else as.integer(self$stories)
      )
    },

    #  @description Serialize to raw TL bytes
    # 
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes little-endian for 0xa36396e5 -> e5 96 63 a3
      parts[[1]] <- as.raw(c(0xe5, 0x96, 0x63, 0xa3))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # title string (prefer serialize_bytes if available)
      if (is.function(self$serialize_bytes)) {
        parts[[length(parts) + 1]] <- self$serialize_bytes(self$title)
      } else {
        title_raw <- charToRaw(enc2utf8(self$title))
        # simple TL string fallback (length as 1 byte when <254)
        parts[[length(parts) + 1]] <- writeBin(as.integer(length(title_raw)), raw(), size = 1, endian = "little")
        parts[[length(parts) + 1]] <- title_raw
      }

      # stories vector: vec tag + length + ints
      vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
      parts[[length(parts) + 1]] <- vec_tag
      parts[[length(parts) + 1]] <- writeBin(as.integer(length(self$stories)), raw(), size = 4, endian = "little")
      if (length(self$stories) > 0) {
        for (v in self$stories) {
          parts[[length(parts) + 1]] <- writeBin(as.integer(v), raw(), size = 4, endian = "little")
        }
      }

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a CreateAlbumRequest instance from a reader
    # 
    #  reader expected to implement: tgread_object(), tgread_string(), read_int()
    #  @param reader reader object
    #  @return CreateAlbumRequest
    from_reader = function(reader) {
      peerObj <- reader$tgread_object()
      titleVal <- reader$tgread_string()

      # read vector constructor id (ignored) then length and ints
      nVal <- reader$read_int()
      if (nVal <= 0) {
        storiesVec <- integer(0)
      } else {
        storiesVec <- integer(nVal)
        for (i in seq_len(nVal)) storiesVec[i] <- reader$read_int()
      }

      CreateAlbumRequest$new(peer = peerObj, title = titleVal, stories = storiesVec)
    }
  )
)


#' @title DeleteAlbumRequest
#' @description Telegram API request \code{stories.deleteAlbum} (constructor \code{#8d3456d0}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
DeleteAlbumRequest <- R6::R6Class(
  "DeleteAlbumRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x8d3456d0,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @field peer Field.
    peer = NULL,
    #  @field album_id Field.
    album_id = NULL,

    #  @description Initialize DeleteAlbumRequest
    # 
    #  @param peer TypeInputPeer
    #  @param album_id integer
    initialize = function(peer, album_id) {
      self$peer <- peer
      self$album_id <- as.integer(album_id)
      invisible(self)
    },

    #  @description Resolve peer references
    # 
    #  Convert a high-level peer reference to an input peer using client/utils.
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "DeleteAlbumRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        album_id = self$album_id
      )
    },

    #  @description Serialize to raw TL bytes
    # 
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes little-endian for 0x8d3456d0 -> d0 56 34 8d
      parts[[1]] <- as.raw(c(0xd0, 0x56, 0x34, 0x8d))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # album_id int32 little-endian
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$album_id), raw(), size = 4, endian = "little")

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a DeleteAlbumRequest instance from a reader
    # 
    #  reader expected to implement: tgread_object(), read_int()
    #  @param reader reader object
    #  @return DeleteAlbumRequest
    from_reader = function(reader) {
      peer_obj <- reader$tgread_object()
      album_id_val <- reader$read_int()
      DeleteAlbumRequest$new(peer = peer_obj, album_id = album_id_val)
    }
  )
)


#' @title DeleteStoriesRequest
#' @description Telegram API request \code{stories.deleteStories} (constructor \code{#ae59db5f}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
DeleteStoriesRequest <- R6::R6Class(
  "DeleteStoriesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xae59db5f,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x5026710f,

    #  @field peer Field.
    peer = NULL,
    #  @field id Field.
    id = NULL,

    #  @description Initialize DeleteStoriesRequest
    # 
    #  @param peer TypeInputPeer
    #  @param id integer vector of story ids
    initialize = function(peer, id) {
      self$peer <- peer
      self$id <- if (!is.null(id)) as.integer(id) else integer(0)
      invisible(self)
    },

    #  @description Resolve peer references
    # 
    #  Convert a high-level peer reference to an input peer using client/utils.
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "DeleteStoriesRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        id = if (is.null(self$id)) integer(0) else as.integer(self$id)
      )
    },

    #  @description Serialize to raw TL bytes
    # 
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes little-endian for 0xae59db5f -> 5f db 59 ae
      parts[[1]] <- as.raw(c(0x5f, 0xdb, 0x59, 0xae))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # id vector: vector tag + length + ints
      vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
      parts[[length(parts) + 1]] <- vec_tag
      parts[[length(parts) + 1]] <- writeBin(as.integer(length(self$id)), raw(), size = 4, endian = "little")
      if (length(self$id) > 0) {
        for (v in self$id) {
          parts[[length(parts) + 1]] <- writeBin(as.integer(v), raw(), size = 4, endian = "little")
        }
      }

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a DeleteStoriesRequest instance from a reader
    # 
    #  reader expected to implement: tgread_object(), read_int()
    #  @param reader reader object
    #  @return DeleteStoriesRequest
    from_reader = function(reader) {
      peer_obj <- reader$tgread_object()

      # read vector constructor id (ignored) then length then ints
      .vec_tag <- reader$read_int()
      n_val <- reader$read_int()
      if (n_val <= 0) {
        ids_vec <- integer(0)
      } else {
        ids_vec <- integer(n_val)
        for (i in seq_len(n_val)) ids_vec[i] <- reader$read_int()
      }

      DeleteStoriesRequest$new(peer = peer_obj, id = ids_vec)
    },

    #  @description Read result (Vector<int>) from reader
    # 
    #  @param reader reader with read_int method
    #  @return integer vector
    read_result = function(reader) {
      # read vector constructor id (ignored)
      n_val <- reader$read_int()
      if (n_val <= 0) {
        return(integer(0))
      }
      out <- integer(n_val)
      for (i in seq_len(n_val)) out[i] <- reader$read_int()
      out
    }
  )
)


#' @title EditStoryRequest
#' @description Telegram API request \code{stories.editStory} (constructor \code{#2c63a72b}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
EditStoryRequest <- R6::R6Class("EditStoryRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0x2c63a72b,
    SUBCLASS_OF_ID = 0x8af52aac,
    peer = NULL,
    id = NULL,
    media = NULL,
    media_areas = NULL,
    caption = NULL,
    entities = NULL,
    privacy_rules = NULL,
    music = NULL,
    initialize = function(peer, id, media = NULL, media_areas = NULL, caption = NULL, entities = NULL, privacy_rules = NULL, music = NULL) {
      self$peer <- peer
      self$id <- id
      self$media <- media
      self$media_areas <- media_areas
      self$caption <- caption
      self$entities <- entities
      self$privacy_rules <- privacy_rules
      self$music <- music
    },
    resolve = function(client, utils) {
      if (!is.null(self$peer)) self$peer <- tryCatch(utils$get_input_peer(client$get_input_entity(self$peer)), error = function(e) self$peer)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "EditStoryRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "id" = if (inherits(self$id, "TLObject")) self$id$to_dict() else self$id,
        "media" = if (inherits(self$media, "TLObject")) self$media$to_dict() else self$media,
        "media_areas" = if (inherits(self$media_areas, "TLObject")) self$media_areas$to_dict() else self$media_areas,
        "caption" = if (inherits(self$caption, "TLObject")) self$caption$to_dict() else self$caption,
        "entities" = if (inherits(self$entities, "TLObject")) self$entities$to_dict() else self$entities,
        "privacy_rules" = if (inherits(self$privacy_rules, "TLObject")) self$privacy_rules$to_dict() else self$privacy_rules,
        "music" = if (inherits(self$music, "TLObject")) self$music$to_dict() else self$music
      )
    },
    to_list = function() {
      list(
        `_` = "EditStoryRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "id" = if (inherits(self$id, "TLObject")) self$id$to_dict() else self$id,
        "media" = if (inherits(self$media, "TLObject")) self$media$to_dict() else self$media,
        "media_areas" = if (inherits(self$media_areas, "TLObject")) self$media_areas$to_dict() else self$media_areas,
        "caption" = if (inherits(self$caption, "TLObject")) self$caption$to_dict() else self$caption,
        "entities" = if (inherits(self$entities, "TLObject")) self$entities$to_dict() else self$entities,
        "privacy_rules" = if (inherits(self$privacy_rules, "TLObject")) self$privacy_rules$to_dict() else self$privacy_rules,
        "music" = if (inherits(self$music, "TLObject")) self$music$to_dict() else self$music
      )
    },
    to_bytes = function() {
      flags <- 0L
      if (!is.null(self$media)) flags <- bitwOr(flags, 1L)
      if (!is.null(self$media_areas)) flags <- bitwOr(flags, 8L)
      if (!is.null(self$caption)) flags <- bitwOr(flags, 2L)
      if (!is.null(self$entities)) flags <- bitwOr(flags, 2L)
      if (!is.null(self$privacy_rules)) flags <- bitwOr(flags, 4L)
      if (!is.null(self$music)) flags <- bitwOr(flags, 16L)
      c(
        as.raw(c(0x2b, 0xa7, 0x63, 0x2c)),
        pack("<I", flags),
        self$peer$bytes(),
        pack("<i", self$id),
        if (!is.null(self$media)) self$media$bytes() else raw(0),
        if (!is.null(self$media_areas)) .telegramR_tl_vector(self$media_areas) else raw(0),
        if (!is.null(self$caption)) serialize_bytes(self$caption) else raw(0),
        if (!is.null(self$entities)) .telegramR_tl_vector(self$entities) else raw(0),
        if (!is.null(self$privacy_rules)) .telegramR_tl_vector(self$privacy_rules) else raw(0),
        if (!is.null(self$music)) self$music$bytes() else raw(0)
      )
    },
    serialize = function() self$to_bytes()
  ),
  private = list(
    from_reader = function(reader) {
      flags <- reader$read_int()
      self$peer <- reader$tgread_object()
      self$id <- reader$read_int()
      self$media <- if (bitwAnd(flags, 1L) != 0) reader$tgread_object() else NULL
      self$media_areas <- if (bitwAnd(flags, 8L) != 0) reader$tgread_vector() else NULL
      self$caption <- if (bitwAnd(flags, 2L) != 0) reader$tgread_string() else NULL
      self$entities <- if (bitwAnd(flags, 2L) != 0) reader$tgread_vector() else NULL
      self$privacy_rules <- if (bitwAnd(flags, 4L) != 0) reader$tgread_vector() else NULL
      self$music <- if (bitwAnd(flags, 16L) != 0) reader$tgread_object() else NULL
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title ExportStoryLinkRequest
#' @description Telegram API request \code{stories.exportStoryLink} (constructor \code{#7b8def20}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ExportStoryLinkRequest <- R6::R6Class(
  "ExportStoryLinkRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x7b8def20,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x0fc541a6,

    #  @field peer Field.
    peer = NULL,
    #  @field id Field.
    id = NULL,

    #  @description Initialize ExportStoryLinkRequest
    # 
    #  @param peer TypeInputPeer
    #  @param id integer story id
    initialize = function(peer, id) {
      self$peer <- peer
      self$id <- as.integer(id)
      invisible(self)
    },

    #  @description Resolve peer references
    # 
    #  Convert high-level peer reference to input peer using client/utils.
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "ExportStoryLinkRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        id = self$id
      )
    },

    #  @description Serialize to raw TL bytes
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes little-endian for 0x7b8def20 -> 0x20 0xef 0x8d 0x7b
      parts[[1]] <- as.raw(c(0x20, 0xef, 0x8d, 0x7b))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # id int32 little-endian
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$id), raw(), size = 4, endian = "little")

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read an ExportStoryLinkRequest instance from a reader
    # 
    #  reader expected to implement: tgread_object(), read_int()
    #  @param reader reader object
    #  @return ExportStoryLinkRequest
    from_reader = function(reader) {
      peerObj <- reader$tgread_object()
      idVal <- reader$read_int()
      ExportStoryLinkRequest$new(peer = peerObj, id = idVal)
    }
  )
)


#' @title GetAlbumStoriesRequest
#' @description Telegram API request \code{stories.getAlbumStories} (constructor \code{#ac806d61}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetAlbumStoriesRequest <- R6::R6Class(
  "GetAlbumStoriesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xac806d61,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x251c0c2c,

    #  @field peer Field.
    peer = NULL,
    #  @field album_id Field.
    album_id = NULL,
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,

    #  @description Initialize GetAlbumStoriesRequest
    # 
    #  @param peer TypeInputPeer
    #  @param album_id integer
    #  @param offset integer
    #  @param limit integer
    initialize = function(peer, album_id, offset, limit) {
      self$peer <- peer
      self$album_id <- as.integer(album_id)
      self$offset <- as.integer(offset)
      self$limit <- as.integer(limit)
      invisible(self)
    },

    #  @description Resolve peer references
    # 
    #  Convert high-level peer reference to input peer using client/utils.
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "GetAlbumStoriesRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        album_id = self$album_id,
        offset = self$offset,
        limit = self$limit
      )
    },

    #  @description Serialize to raw TL bytes
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes little-endian for 0xac806d61 -> 0x61 0x6d 0x80 0xac
      parts[[1]] <- as.raw(c(0x61, 0x6d, 0x80, 0xac))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # album_id, offset, limit int32 little-endian
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$album_id), raw(), size = 4, endian = "little")
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$offset), raw(), size = 4, endian = "little")
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$limit), raw(), size = 4, endian = "little")

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a GetAlbumStoriesRequest instance from a reader
    # 
    #  reader expected to implement: tgread_object(), read_int()
    #  @param reader reader object
    #  @return GetAlbumStoriesRequest
    from_reader = function(reader) {
      peerObj <- reader$tgread_object()
      albumIdVal <- reader$read_int()
      offsetVal <- reader$read_int()
      limitVal <- reader$read_int()
      GetAlbumStoriesRequest$new(peer = peerObj, album_id = albumIdVal, offset = offsetVal, limit = limitVal)
    }
  )
)


#' @title GetAlbumsRequest
#' @description Telegram API request \code{stories.getAlbums} (constructor \code{#25b3eac7}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetAlbumsRequest <- R6::R6Class(
  "GetAlbumsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x25b3eac7,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x05a73d39,

    #  @field peer Field.
    peer = NULL,
    #  @field hash Field.
    hash = NULL,

    #  @description Initialize GetAlbumsRequest
    # 
    #  @param peer TypeInputPeer
    #  @param hash numeric/integer (64-bit)
    initialize = function(peer, hash) {
      self$peer <- peer
      # store hash as numeric (may represent 64-bit value)
      self$hash <- as.numeric(hash)
      invisible(self)
    },

    #  @description Resolve peer references
    # 
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "GetAlbumsRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        hash = self$hash
      )
    },

    #  @description Serialize to raw TL bytes
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes little-endian for 0x25b3eac7 -> 0xc7 0xea 0xb3 0x25
      parts[[1]] <- as.raw(c(0xc7, 0xea, 0xb3, 0x25))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # hash int64 little-endian (8 bytes)
      parts[[length(parts) + 1]] <- packInt64(self$hash)

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a GetAlbumsRequest instance from a reader
    # 
    #  reader expected to implement: tgread_object(), read_long()
    #  @param reader reader object
    #  @return GetAlbumsRequest
    from_reader = function(reader) {
      peerObj <- reader$tgread_object()
      hashVal <- reader$read_long()
      GetAlbumsRequest$new(peer = peerObj, hash = hashVal)
    }
  )
)


#' @title GetAllReadPeerStoriesRequest
#' @description Telegram API request \code{stories.getAllReadPeerStories} (constructor \code{#9b5ae7f9}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetAllReadPeerStoriesRequest <- R6::R6Class(
  "GetAllReadPeerStoriesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x9b5ae7f9,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,


    #  @description Convert to list
    # 
    #  @return list
    to_list = function() {
      list(`_` = "GetAllReadPeerStoriesRequest")
    },

    #  @description Serialize to raw TL bytes
    # 
    #  @return raw
    to_bytes = function() {
      # constructor bytes little-endian for 0x9b5ae7f9 -> f9 e7 5a 9b
      as.raw(c(0xf9, 0xe7, 0x5a, 0x9b))
    }
  ),
  class = list(
    #  @description Read a GetAllReadPeerStoriesRequest instance from a reader
    # 
    #  reader expected to implement nothing special for this class
    #  @param reader reader object (ignored)
    #  @return GetAllReadPeerStoriesRequest
    from_reader = function(reader) {
      GetAllReadPeerStoriesRequest$new()
    }
  )
)


#' @title GetAllStoriesRequest
#' @description Telegram API request \code{stories.getAllStories} (constructor \code{#eeb0d625}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetAllStoriesRequest <- R6::R6Class(
  "GetAllStoriesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xeeb0d625,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x7e60d0cd,
    .next = NULL,
    #  @field hidden Field.
    hidden = NULL,
    #  @field state Field.
    state = NULL,

    #  @description Initialize GetAllStoriesRequest
    # 
    #  @param next logical or NULL
    #  @param hidden logical or NULL
    #  @param state character or NULL
    #  @return invisible self
    initialize = function(.next = NULL, hidden = NULL, state = NULL) {
      self$.next <- if (!is.null(.next)) as.logical(.next) else NULL
      self$hidden <- if (!is.null(hidden)) as.logical(hidden) else NULL
      self$state <- if (!is.null(state)) as.character(state) else NULL
      invisible(self)
    },

    #  @description Convert to list
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "GetAllStoriesRequest",
        .next = self$.next,
        hidden = self$hidden,
        state = self$state
      )
    },

    #  @description Serialize to raw TL bytes
    # 
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes little-endian for 0xeeb0d625 -> 0x25 0xd6 0xb0 0xee
      parts[[1]] <- as.raw(c(0x25, 0xd6, 0xb0, 0xee))

      # flags: state=1, next=2, hidden=4
      flagsVal <- 0L
      if (!is.null(self$state)) flagsVal <- bitwOr(flagsVal, 1L)
      if (!is.null(self$.next) && isTRUE(self$.next)) flagsVal <- bitwOr(flagsVal, 2L)
      if (!is.null(self$hidden) && isTRUE(self$hidden)) flagsVal <- bitwOr(flagsVal, 4L)

      parts[[length(parts) + 1]] <- writeBin(as.integer(flagsVal), raw(), size = 4, endian = "little")

      # optional state string
      if (!is.null(self$state)) {
        if (is.function(self$serialize_bytes)) {
          parts[[length(parts) + 1]] <- self$serialize_bytes(self$state)
        } else {
          state_raw <- charToRaw(enc2utf8(self$state))
          # minimal TL string fallback (length as 1 byte when <254)
          parts[[length(parts) + 1]] <- writeBin(as.integer(length(state_raw)), raw(), size = 1, endian = "little")
          parts[[length(parts) + 1]] <- state_raw
        }
      }

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a GetAllStoriesRequest instance from a reader
    # 
    #  reader expected to implement: read_int(), tgread_string()
    #  @param reader reader object
    #  @return GetAllStoriesRequest
    from_reader = function(reader) {
      flagsVal <- reader$read_int()
      nextFlag <- bitwAnd(flagsVal, 2L) != 0L
      hiddenFlag <- bitwAnd(flagsVal, 4L) != 0L
      stateVal <- if (bitwAnd(flagsVal, 1L) != 0L) reader$tgread_string() else NULL

      GetAllStoriesRequest$new(
        .next = if (nextFlag) TRUE else NULL,
        hidden = if (hiddenFlag) TRUE else NULL,
        state = stateVal
      )
    }
  )
)


#' @title GetChatsToSendRequest
#' @description Telegram API request \code{stories.getChatsToSend} (constructor \code{#a56a8b60}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetChatsToSendRequest <- R6::R6Class(
  "GetChatsToSendRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xa56a8b60,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x99d5cb14,


    #  @description Convert to list
    # 
    #  @return list
    to_list = function() {
      list(`_` = "GetChatsToSendRequest")
    },

    #  @description Serialize to raw TL bytes
    # 
    #  @return raw
    to_bytes = function() {
      # constructor bytes little-endian for 0xa56a8b60 -> 0x60 0x8b 0x6a 0xa5
      as.raw(c(0x60, 0x8b, 0x6a, 0xa5))
    }
  ),
  class = list(
    #  @description Read a GetChatsToSendRequest instance from a reader
    # 
    #  reader expected to implement nothing special for this class
    #  @param reader reader object (ignored)
    #  @return GetChatsToSendRequest
    from_reader = function(reader) {
      GetChatsToSendRequest$new()
    }
  )
)


#' @title GetPeerMaxIDsRequest
#' @description Telegram API request \code{stories.getPeerMaxIDs} (constructor \code{#78499170}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetPeerMaxIDsRequest <- R6::R6Class("GetPeerMaxIDsRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0x78499170,
    SUBCLASS_OF_ID = 0x1cb5c415,
    id = NULL,
    initialize = function(id) {
      self$id <- id
    },
    resolve = function(client, utils) {
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "GetPeerMaxIDsRequest",
        "id" = if (inherits(self$id, "TLObject")) self$id$to_dict() else self$id
      )
    },
    to_list = function() {
      list(
        `_` = "GetPeerMaxIDsRequest",
        "id" = if (inherits(self$id, "TLObject")) self$id$to_dict() else self$id
      )
    },
    to_bytes = function() {
      c(
        as.raw(c(0x70, 0x91, 0x49, 0x78)),
        .telegramR_tl_vector(self$id)
      )
    },
    serialize = function() self$to_bytes()
  ),
  private = list(
    from_reader = function(reader) {
      self$id <- reader$tgread_vector()
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title GetPeerStoriesRequest
#' @description Telegram API request \code{stories.getPeerStories} (constructor \code{#2c4ada50}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetPeerStoriesRequest <- R6::R6Class(
  "GetPeerStoriesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x2c4ada50,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x9d56cfd0,

    #  @field peer Field.
    peer = NULL,

    #  @description Initialize GetPeerStoriesRequest
    # 
    #  @param peer TypeInputPeer
    #  @return invisible self
    initialize = function(peer) {
      self$peer <- peer
      invisible(self)
    },

    #  @description Resolve peer references
    # 
    #  Convert high-level peer reference to input peer using client/utils.
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer
    #  @return invisible self
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    #  @return list
    to_list = function() {
      list(
        `_` = "GetPeerStoriesRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer
      )
    },

    #  @description Serialize to raw TL bytes
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes little-endian for 0x2c4ada50 -> 0x50 0xda 0x4a 0x2c
      parts[[1]] <- as.raw(c(0x50, 0xda, 0x4a, 0x2c))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a GetPeerStoriesRequest instance from a reader
    # 
    #  reader expected to implement: tgread_object()
    #  @param reader reader object
    #  @return GetPeerStoriesRequest
    from_reader = function(reader) {
      peerObj <- reader$tgread_object()
      GetPeerStoriesRequest$new(peer = peerObj)
    }
  )
)


#' @title GetPinnedStoriesRequest
#' @description Telegram API request \code{stories.getPinnedStories} (constructor \code{#5821a5dc}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetPinnedStoriesRequest <- R6::R6Class(
  "GetPinnedStoriesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x5821a5dc,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x251c0c2c,

    #  @field peer Field.
    peer = NULL,
    #  @field offset_id Field.
    offset_id = NULL,
    #  @field limit Field.
    limit = NULL,

    #  @description Initialize GetPinnedStoriesRequest
    # 
    #  @param peer TypeInputPeer
    #  @param offset_id integer offset id
    #  @param limit integer limit
    #  @return invisible self
    initialize = function(peer, offset_id, limit) {
      self$peer <- peer
      self$offset_id <- as.integer(offset_id)
      self$limit <- as.integer(limit)
      invisible(self)
    },

    #  @description Resolve peer references
    # 
    #  Convert high-level peer reference to input peer using client/utils.
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer
    #  @return invisible self
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    #  @return list
    to_list = function() {
      list(
        `_` = "GetPinnedStoriesRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        offset_id = self$offset_id,
        limit = self$limit
      )
    },

    #  @description Serialize to raw TL bytes
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes little-endian for 0x5821a5dc -> 0xdc 0xa5 0x21 0x58
      parts[[1]] <- as.raw(c(0xdc, 0xa5, 0x21, 0x58))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # offset_id int32 little-endian
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$offset_id), raw(), size = 4, endian = "little")
      # limit int32 little-endian
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$limit), raw(), size = 4, endian = "little")

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a GetPinnedStoriesRequest instance from a reader
    # 
    #  reader expected to implement: tgread_object(), read_int()
    #  @param reader reader object
    #  @return GetPinnedStoriesRequest
    from_reader = function(reader) {
      peerObj <- reader$tgread_object()
      offsetIdVal <- reader$read_int()
      limitVal <- reader$read_int()
      GetPinnedStoriesRequest$new(peer = peerObj, offset_id = offsetIdVal, limit = limitVal)
    }
  )
)


#' @title GetStoriesArchiveRequest
#' @description Telegram API request \code{stories.getStoriesArchive} (constructor \code{#b4352016}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetStoriesArchiveRequest <- R6::R6Class(
  "GetStoriesArchiveRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xb4352016,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x251c0c2c,

    #  @field peer Field.
    peer = NULL,
    #  @field offset_id Field.
    offset_id = NULL,
    #  @field limit Field.
    limit = NULL,

    #  @description Initialize GetStoriesArchiveRequest
    # 
    #  @param peer TypeInputPeer
    #  @param offset_id integer offset id
    #  @param limit integer limit
    #  @return invisible self
    initialize = function(peer, offset_id, limit) {
      self$peer <- peer
      self$offset_id <- as.integer(offset_id)
      self$limit <- as.integer(limit)
      invisible(self)
    },

    #  @description Resolve peer references
    # 
    #  Convert high-level peer reference to input peer using client/utils.
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer
    #  @return invisible self
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    #  @return list
    to_list = function() {
      list(
        `_` = "GetStoriesArchiveRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        offset_id = self$offset_id,
        limit = self$limit
      )
    },

    #  @description Serialize to raw TL bytes
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes (little-endian of 0xb4352016 -> 0x16 0x20 0x35 0xb4)
      parts[[1]] <- as.raw(c(0x16, 0x20, 0x35, 0xb4))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # offset_id int32 little-endian
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$offset_id), raw(), size = 4, endian = "little")
      # limit int32 little-endian
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$limit), raw(), size = 4, endian = "little")

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a GetStoriesArchiveRequest instance from a reader
    # 
    #  reader expected to implement: tgread_object(), read_int()
    #  @param reader reader object
    #  @return GetStoriesArchiveRequest
    from_reader = function(reader) {
      peer_obj <- reader$tgread_object()
      offset_id_val <- reader$read_int()
      limit_val <- reader$read_int()
      GetStoriesArchiveRequest$new(peer = peer_obj, offset_id = offset_id_val, limit = limit_val)
    }
  )
)


#' @title GetStoriesByIDRequest
#' @description Telegram API request \code{stories.getStoriesByID} (constructor \code{#5774ca74}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetStoriesByIDRequest <- R6::R6Class(
  "GetStoriesByIDRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x5774ca74,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x251c0c2c,

    #  @field peer Field.
    peer = NULL,
    #  @field id Field.
    id = NULL,

    #  @description Initialize GetStoriesByIDRequest
    # 
    #  @param peer TypeInputPeer
    #  @param id integer vector of story ids
    #  @return invisible self
    initialize = function(peer, id) {
      self$peer <- peer
      self$id <- if (!is.null(id)) as.integer(id) else integer(0)
      invisible(self)
    },

    #  @description Resolve peer references
    # 
    #  Convert high-level peer reference to input peer using client/utils.
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer
    #  @return invisible self
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    #  @return list
    to_list = function() {
      list(
        `_` = "GetStoriesByIDRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        id = if (is.null(self$id)) integer(0) else as.integer(self$id)
      )
    },

    #  @description Serialize to raw TL bytes
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes (little-endian of 0x5774ca74 -> 0x74 0xca 0x74 0x57)
      parts[[1]] <- as.raw(c(0x74, 0xca, 0x74, 0x57))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # id vector: vector tag + length + ints
      vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
      parts[[length(parts) + 1]] <- vec_tag
      parts[[length(parts) + 1]] <- writeBin(as.integer(length(self$id)), raw(), size = 4, endian = "little")
      for (v in self$id) {
        parts[[length(parts) + 1]] <- writeBin(as.integer(v), raw(), size = 4, endian = "little")
      }

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a GetStoriesByIDRequest instance from a reader
    # 
    #  reader expected to implement: tgread_object(), read_int()
    #  @param reader reader object
    #  @return GetStoriesByIDRequest
    from_reader = function(reader) {
      peer_obj <- reader$tgread_object()

      # read vector constructor id (ignored) and length then ints

      n <- reader$read_int()
      if (n <= 0) {
        ids_vec <- integer(0)
      } else {
        ids_vec <- integer(n)
        for (i in seq_len(n)) ids_vec[i] <- reader$read_int()
      }

      GetStoriesByIDRequest$new(peer = peer_obj, id = ids_vec)
    }
  )
)


#' @title GetStoriesViewsRequest
#' @description Telegram API request \code{stories.getStoriesViews} (constructor \code{#28e16cc8}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetStoriesViewsRequest <- R6::R6Class(
  "GetStoriesViewsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x28e16cc8,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x4b3fc4ba,

    #  @field peer Field.
    peer = NULL,
    #  @field id Field.
    id = NULL,

    #  @description Initialize GetStoriesViewsRequest
    # 
    #  @param peer TypeInputPeer
    #  @param id integer vector of story ids
    initialize = function(peer, id) {
      self$peer <- peer
      self$id <- if (!is.null(id)) as.integer(id) else integer(0)
    },

    #  @description Resolve peer references
    # 
    #  Convert high-level peer reference to input peer using client/utils.
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    #  @return list
    to_list = function() {
      list(
        `_` = "GetStoriesViewsRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        id = if (is.null(self$id)) integer(0) else as.integer(self$id)
      )
    },

    #  @description Serialize to raw TL bytes
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes little-endian for 0x28e16cc8 -> c8 6c e1 28
      parts[[1]] <- as.raw(c(0xc8, 0x6c, 0xe1, 0x28))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # id vector: vector tag + length + ints
      vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
      parts[[length(parts) + 1]] <- vec_tag
      parts[[length(parts) + 1]] <- writeBin(as.integer(length(self$id)), raw(), size = 4, endian = "little")
      for (v in self$id) {
        parts[[length(parts) + 1]] <- writeBin(as.integer(v), raw(), size = 4, endian = "little")
      }

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a GetStoriesViewsRequest instance from a reader
    # 
    #  reader expected to implement: tgread_object(), read_int()
    #  @param reader reader object
    #  @return GetStoriesViewsRequest
    from_reader = function(reader) {
      peerObj <- reader$tgread_object()

      # read vector constructor id (ignored) and length then ints

      n <- reader$read_int()
      if (n <= 0) {
        idsVec <- integer(0)
      } else {
        idsVec <- integer(n)
        for (i in seq_len(n)) idsVec[i] <- reader$read_int()
      }

      GetStoriesViewsRequest$new(peer = peerObj, id = idsVec)
    }
  )
)


#' @title GetStoryReactionsListRequest
#' @description Telegram API request \code{stories.getStoryReactionsList} (constructor \code{#b9b2881f}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetStoryReactionsListRequest <- R6::R6Class(
  "GetStoryReactionsListRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xb9b2881f,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x046f91e3,

    #  @field peer Field.
    peer = NULL,
    #  @field id Field.
    id = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field forwards_first Field.
    forwards_first = NULL,
    #  @field reaction Field.
    reaction = NULL,
    #  @field offset Field.
    offset = NULL,

    #  @description Initialize GetStoryReactionsListRequest
    # 
    #  @param peer TypeInputPeer
    #  @param id integer story id
    #  @param limit integer limit
    #  @param forwards_first logical or NULL
    #  @param reaction TypeReaction or NULL
    #  @param offset character or NULL
    initialize = function(peer, id, limit, forwards_first = NULL, reaction = NULL, offset = NULL) {
      self$peer <- peer
      self$id <- as.integer(id)
      self$limit <- as.integer(limit)
      self$forwards_first <- if (!is.null(forwards_first)) as.logical(forwards_first) else NULL
      self$reaction <- reaction
      self$offset <- if (!is.null(offset)) as.character(offset) else NULL
    },

    #  @description Resolve peer references
    # 
    #  Convert high-level peer reference to input peer using client/utils.
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    #  @return list
    to_list = function() {
      list(
        `_` = "GetStoryReactionsListRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        id = self$id,
        limit = self$limit,
        forwards_first = self$forwards_first,
        reaction = if (inherits(self$reaction, "TLObject") && is.function(self$reaction$to_list)) self$reaction$to_list() else self$reaction,
        offset = self$offset
      )
    },

    #  @description Serialize to raw TL bytes
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes little-endian for 0xb9b2881f -> 1f 88 b2 b9
      parts[[1]] <- as.raw(c(0x1f, 0x88, 0xb2, 0xb9))

      # flags: bit 2 (4) = forwards_first, bit 0 (1) = reaction, bit 1 (2) = offset
      flagsVal <- 0L
      if (!is.null(self$forwards_first) && isTRUE(self$forwards_first)) flagsVal <- bitwOr(flagsVal, 4L)
      if (!is.null(self$reaction)) flagsVal <- bitwOr(flagsVal, 1L)
      if (!is.null(self$offset)) flagsVal <- bitwOr(flagsVal, 2L)
      parts[[length(parts) + 1]] <- writeBin(as.integer(flagsVal), raw(), size = 4, endian = "little")

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # id int32
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$id), raw(), size = 4, endian = "little")

      # optional reaction object
      if (!is.null(self$reaction)) {
        if (is.function(self$reaction$to_bytes)) {
          parts[[length(parts) + 1]] <- self$reaction$to_bytes()
        } else if (is.function(self$reaction$bytes)) {
          parts[[length(parts) + 1]] <- self$reaction$bytes()
        } else if (is.function(self$reaction$.bytes)) {
          parts[[length(parts) + 1]] <- self$reaction$.bytes()
        } else {
          stop("reaction object must provide a to_bytes/bytes/_bytes method")
        }
      }

      # optional offset string
      if (!is.null(self$offset)) {
        if (is.function(self$serialize_bytes)) {
          parts[[length(parts) + 1]] <- self$serialize_bytes(self$offset)
        } else {
          off_raw <- charToRaw(enc2utf8(self$offset))
          parts[[length(parts) + 1]] <- writeBin(as.integer(length(off_raw)), raw(), size = 1, endian = "little")
          parts[[length(parts) + 1]] <- off_raw
        }
      }

      # limit int32
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$limit), raw(), size = 4, endian = "little")

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a GetStoryReactionsListRequest instance from a reader
    # 
    #  reader expected to implement: read_int(), tgread_object(), tgread_string()
    #  @param reader reader object
    #  @return GetStoryReactionsListRequest
    from_reader = function(reader) {
      flagsVal <- reader$read_int()
      forwardsFirstVal <- bitwAnd(flagsVal, 4L) != 0L

      peerObj <- reader$tgread_object()
      idVal <- reader$read_int()

      reactionVal <- if (bitwAnd(flagsVal, 1L) != 0L) reader$tgread_object() else NULL
      offsetVal <- if (bitwAnd(flagsVal, 2L) != 0L) reader$tgread_string() else NULL

      limitVal <- reader$read_int()

      GetStoryReactionsListRequest$new(
        peer = peerObj,
        id = idVal,
        limit = limitVal,
        forwards_first = if (forwardsFirstVal) TRUE else NULL,
        reaction = reactionVal,
        offset = offsetVal
      )
    }
  )
)


#' @title GetStoryViewsListRequest
#' @description Telegram API request \code{stories.getStoryViewsList} (constructor \code{#7ed23c57}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
GetStoryViewsListRequest <- R6::R6Class(
  "GetStoryViewsListRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x7ed23c57,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xb9437560,

    #  @field peer Field.
    peer = NULL,
    #  @field id Field.
    id = NULL,
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field just_contacts Field.
    just_contacts = NULL,
    #  @field reactions_first Field.
    reactions_first = NULL,
    #  @field forwards_first Field.
    forwards_first = NULL,
    #  @field q Field.
    q = NULL,

    #  @description Initialize GetStoryViewsListRequest
    # 
    #  @param peer TypeInputPeer
    #  @param id integer story id
    #  @param offset character offset cursor
    #  @param limit integer limit
    #  @param just_contacts logical or NULL
    #  @param reactions_first logical or NULL
    #  @param forwards_first logical or NULL
    #  @param q character or NULL search query
    initialize = function(peer, id, offset, limit, just_contacts = NULL, reactions_first = NULL, forwards_first = NULL, q = NULL) {
      self$peer <- peer
      self$id <- as.integer(id)
      self$offset <- as.character(offset)
      self$limit <- as.integer(limit)
      self$just_contacts <- if (!is.null(just_contacts)) as.logical(just_contacts) else NULL
      self$reactions_first <- if (!is.null(reactions_first)) as.logical(reactions_first) else NULL
      self$forwards_first <- if (!is.null(forwards_first)) as.logical(forwards_first) else NULL
      self$q <- if (!is.null(q)) as.character(q) else NULL
    },

    #  @description Resolve peer references
    # 
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    #  @return list
    to_list = function() {
      list(
        `_` = "GetStoryViewsListRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        id = self$id,
        offset = self$offset,
        limit = self$limit,
        just_contacts = self$just_contacts,
        reactions_first = self$reactions_first,
        forwards_first = self$forwards_first,
        q = self$q
      )
    },

    #  @description Serialize to raw TL bytes
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes little-endian for 0x7ed23c57
      parts[[1]] <- as.raw(c(0x57, 0x3c, 0xd2, 0x7e))

      # flags: bit 0 (1) = just_contacts, bit 1 (2) = q, bit 2 (4) = reactions_first, bit 3 (8) = forwards_first
      flagsVal <- 0L
      if (!is.null(self$just_contacts) && isTRUE(self$just_contacts)) flagsVal <- bitwOr(flagsVal, 1L)
      if (!is.null(self$q)) flagsVal <- bitwOr(flagsVal, 2L)
      if (!is.null(self$reactions_first) && isTRUE(self$reactions_first)) flagsVal <- bitwOr(flagsVal, 4L)
      if (!is.null(self$forwards_first) && isTRUE(self$forwards_first)) flagsVal <- bitwOr(flagsVal, 8L)
      parts[[length(parts) + 1]] <- writeBin(as.integer(flagsVal), raw(), size = 4, endian = "little")

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # optional q (string)
      if (!is.null(self$q)) {
        if (is.function(self$serialize_bytes)) {
          parts[[length(parts) + 1]] <- self$serialize_bytes(self$q)
        } else {
          q_raw <- charToRaw(enc2utf8(self$q))
          parts[[length(parts) + 1]] <- writeBin(as.integer(length(q_raw)), raw(), size = 1, endian = "little")
          parts[[length(parts) + 1]] <- q_raw
        }
      }

      # id int32
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$id), raw(), size = 4, endian = "little")

      # offset (string, required)
      if (is.function(self$serialize_bytes)) {
        parts[[length(parts) + 1]] <- self$serialize_bytes(self$offset)
      } else {
        off_raw <- charToRaw(enc2utf8(self$offset))
        parts[[length(parts) + 1]] <- writeBin(as.integer(length(off_raw)), raw(), size = 1, endian = "little")
        parts[[length(parts) + 1]] <- off_raw
      }

      # limit int32
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$limit), raw(), size = 4, endian = "little")

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a GetStoryViewsListRequest instance from a reader
    # 
    #  reader expected to implement: read_int(), tgread_object(), tgread_string()
    #  @param reader reader object
    #  @return GetStoryViewsListRequest
    from_reader = function(reader) {
      flagsVal <- reader$read_int()
      justContactsVal <- bitwAnd(flagsVal, 1L) != 0L
      reactionsFirstVal <- bitwAnd(flagsVal, 4L) != 0L
      forwardsFirstVal <- bitwAnd(flagsVal, 8L) != 0L

      peerObj <- reader$tgread_object()
      qVal <- if (bitwAnd(flagsVal, 2L) != 0L) reader$tgread_string() else NULL

      idVal <- reader$read_int()
      offsetVal <- reader$tgread_string()
      limitVal <- reader$read_int()

      GetStoryViewsListRequest$new(
        peer = peerObj,
        id = idVal,
        offset = offsetVal,
        limit = limitVal,
        just_contacts = if (justContactsVal) TRUE else NULL,
        reactions_first = if (reactionsFirstVal) TRUE else NULL,
        forwards_first = if (forwardsFirstVal) TRUE else NULL,
        q = qVal
      )
    }
  )
)


#' @title IncrementStoryViewsRequest
#' @description Telegram API request \code{stories.incrementStoryViews} (constructor \code{#b2028afb}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
IncrementStoryViewsRequest <- R6::R6Class(
  "IncrementStoryViewsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xb2028afb,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @field peer Field.
    peer = NULL,
    #  @field id Field.
    id = NULL,

    #  @description Initialize IncrementStoryViewsRequest
    # 
    #  @param peer TypeInputPeer
    #  @param id integer vector of story ids
    initialize = function(peer, id) {
      self$peer <- peer
      self$id <- if (!is.null(id)) as.integer(id) else integer(0)
    },

    #  @description Resolve peer references
    # 
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    #  @return list
    to_list = function() {
      list(
        `_` = "IncrementStoryViewsRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        id = if (is.null(self$id)) integer(0) else as.integer(self$id)
      )
    },

    #  @description Serialize to raw TL bytes
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes little-endian for 0xb2028afb
      parts[[1]] <- as.raw(c(0xfb, 0x8a, 0x02, 0xb2))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # id vector: vector tag + length + ints
      vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
      parts[[length(parts) + 1]] <- vec_tag
      parts[[length(parts) + 1]] <- writeBin(as.integer(length(self$id)), raw(), size = 4, endian = "little")
      for (v in self$id) {
        parts[[length(parts) + 1]] <- writeBin(as.integer(v), raw(), size = 4, endian = "little")
      }

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read an IncrementStoryViewsRequest instance from a reader
    # 
    #  reader expected to implement: tgread_object(), read_int()
    #  @param reader reader object
    #  @return IncrementStoryViewsRequest
    from_reader = function(reader) {
      peerObj <- reader$tgread_object()

      # read vector constructor id (ignored) and length then ints
      .vec_tag <- reader$read_int()
      n <- reader$read_int()
      if (n <= 0) {
        idsVec <- integer(0)
      } else {
        idsVec <- integer(n)
        for (i in seq_len(n)) idsVec[i] <- reader$read_int()
      }

      IncrementStoryViewsRequest$new(peer = peerObj, id = idsVec)
    }
  )
)


#' @title ReadStoriesRequest
#' @description Telegram API request \code{stories.readStories} (constructor \code{#a556dac8}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ReadStoriesRequest <- R6::R6Class(
  "ReadStoriesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xa556dac8,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x5026710f,

    #  @field peer Field.
    peer = NULL,
    #  @field max_id Field.
    max_id = NULL,

    #  @description Initialize ReadStoriesRequest
    # 
    #  @param peer TypeInputPeer
    #  @param max_id integer
    initialize = function(peer, max_id) {
      self$peer <- peer
      self$max_id <- as.integer(max_id)
    },

    #  @description Resolve peer references
    # 
    #  Convert a high-level peer reference to an input peer using client/utils.
    #  @param client client object with get_input_entity method
    #  @param utils utils object with get_input_peer method
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    #  @return list
    to_list = function() {
      list(
        `_` = "ReadStoriesRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        max_id = self$max_id
      )
    },

    #  @description Serialize to raw TL bytes
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes: b'\xc8\xdaV\xa5'
      parts[[1]] <- as.raw(c(0xc8, 0xda, 0x56, 0xa5))

      # peer bytes (expects peer to provide to_bytes/bytes/_bytes)
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # max_id int32 little-endian
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$max_id), raw(), size = 4, endian = "little")

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a ReadStoriesRequest instance from a reader
    # 
    #  reader is expected to implement: tgread_object(), read_int()
    #  @param reader reader object
    #  @return ReadStoriesRequest
    from_reader = function(reader) {
      peerObj <- reader$tgread_object()
      maxIdVal <- reader$read_int()
      ReadStoriesRequest$new(peer = peerObj, max_id = maxIdVal)
    },

    #  @description Read result (Vector<int>) from reader
    # 
    #  @param reader reader with read_int method
    #  @return integer vector
    read_result = function(reader) {
      # read vector constructor id (ignored)

      n <- reader$read_int()
      if (n <= 0) {
        return(integer(0))
      }
      out <- integer(n)
      for (i in seq_len(n)) out[i] <- reader$read_int()
      out
    }
  )
)


#' @title ReorderAlbumsRequest
#' @description Telegram API request \code{stories.reorderAlbums} (constructor \code{#8535fbd9}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ReorderAlbumsRequest <- R6::R6Class(
  "ReorderAlbumsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x8535fbd9,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @field peer Field.
    peer = NULL,
    #  @field order Field.
    order = NULL,

    #  @description Initialize ReorderAlbumsRequest
    # 
    #  @param peer TypeInputPeer
    #  @param order integer vector
    initialize = function(peer, order) {
      self$peer <- peer
      self$order <- if (!is.null(order)) as.integer(order) else integer(0)
    },

    #  @description Resolve peer references
    # 
    #  Convert a high-level peer reference to an input peer using client/utils.
    #  @param client client object with get_input_entity method
    #  @param utils utils object with get_input_peer method
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    #  @return list
    to_list = function() {
      list(
        `_` = "ReorderAlbumsRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        order = if (is.null(self$order)) integer(0) else as.integer(self$order)
      )
    },

    #  @description Serialize to raw TL bytes
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes: b'\xd9\xfb5\x85'
      parts[[1]] <- as.raw(c(0xd9, 0xfb, 0x35, 0x85))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # vector tag + length + ints for order
      vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
      parts[[length(parts) + 1]] <- vec_tag
      parts[[length(parts) + 1]] <- writeBin(as.integer(length(self$order)), raw(), size = 4, endian = "little")
      for (v in self$order) {
        parts[[length(parts) + 1]] <- writeBin(as.integer(v), raw(), size = 4, endian = "little")
      }

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a ReorderAlbumsRequest instance from a reader
    # 
    #  reader is expected to implement: tgread_object(), read_int()
    #  @param reader reader object
    #  @return ReorderAlbumsRequest
    from_reader = function(reader) {
      peerObj <- reader$tgread_object()

      # read vector constructor id (ignored) and length then ints

      n <- reader$read_int()
      if (n <= 0) {
        orderVec <- integer(0)
      } else {
        orderVec <- integer(n)
        for (i in seq_len(n)) orderVec[i] <- reader$read_int()
      }

      ReorderAlbumsRequest$new(peer = peerObj, order = orderVec)
    }
  )
)


#' @title ReportRequest
#' @description Telegram API request \code{stories.report} (constructor \code{#19d8eb45}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ReportRequest <- R6::R6Class(
  "ReportRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x19d8eb45,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xacd3f438,

    #  @field peer Field.
    peer = NULL,
    #  @field id Field.
    id = NULL,
    #  @field option Field.
    option = NULL,
    #  @field message Field.
    message = NULL,

    #  @description Initialize ReportRequest
    # 
    #  @param peer TypeInputPeer
    #  @param id integer vector
    #  @param option raw or raw-like bytes
    #  @param message character
    initialize = function(peer, id, option, message) {
      self$peer <- peer
      self$id <- if (!is.null(id)) as.integer(id) else integer(0)
      # option expected as raw vector, but allow character -> convert
      if (!is.null(option) && is.character(option)) {
        self$option <- charToRaw(enc2utf8(option))
      } else {
        self$option <- option
      }
      self$message <- if (!is.null(message)) as.character(message) else ""
    },

    #  @description Resolve peer references
    # 
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "ReportRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        id = if (is.null(self$id)) integer(0) else as.integer(self$id),
        option = self$option,
        message = self$message
      )
    },

    #  @description Serialize to raw TL bytes
    # 
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes (0x19d8eb45 little-endian)
      parts[[1]] <- as.raw(c(0x45, 0xeb, 0xd8, 0x19))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide to_bytes/bytes/_bytes")
      }

      # id vector
      vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
      parts[[length(parts) + 1]] <- vec_tag
      parts[[length(parts) + 1]] <- writeBin(as.integer(length(self$id)), raw(), size = 4, endian = "little")
      for (v in self$id) parts[[length(parts) + 1]] <- writeBin(as.integer(v), raw(), size = 4, endian = "little")

      # option (bytes) and message (string)
      # prefer TLRequest::serialize_bytes if available
      if (is.function(self$serialize_bytes)) {
        parts[[length(parts) + 1]] <- self$serialize_bytes(self$option)
        parts[[length(parts) + 1]] <- self$serialize_bytes(self$message)
      } else {
        # fallback for option (raw): write length (int as 1..4 bytes not implemented fully) + bytes
        if (!is.null(self$option)) {
          opt_raw <- if (is.raw(self$option)) self$option else charToRaw(as.character(self$option))
          parts[[length(parts) + 1]] <- writeBin(as.integer(length(opt_raw)), raw(), size = 4, endian = "little")
          parts[[length(parts) + 1]] <- opt_raw
        } else {
          parts[[length(parts) + 1]] <- raw()
        }
        # message as simple TL string fallback
        msg_raw <- charToRaw(enc2utf8(self$message))
        parts[[length(parts) + 1]] <- writeBin(as.integer(length(msg_raw)), raw(), size = 1, endian = "little")
        parts[[length(parts) + 1]] <- msg_raw
      }

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a ReportRequest instance from reader
    # 
    #  reader is expected to implement: tgread_object(), read_int(), tgread_bytes(), tgread_string()
    #  @param reader reader object
    #  @return ReportRequest
    from_reader = function(reader) {
      peerObj <- reader$tgread_object()

      # read vector tag then length then ints
      # vector constructor id (ignored)
      nIds <- reader$read_int()
      idsVec <- if (nIds <= 0) integer(0) else integer(nIds)
      if (nIds > 0) {
        for (i in seq_len(nIds)) idsVec[i] <- reader$read_int()
      }

      optionBytes <- reader$tgread_bytes()
      messageStr <- reader$tgread_string()

      ReportRequest$new(peer = peerObj, id = idsVec, option = optionBytes, message = messageStr)
    }
  )
)


#' @title SearchPostsRequest
#' @description Telegram API request \code{stories.searchPosts} (constructor \code{#d1810907}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
SearchPostsRequest <- R6::R6Class(
  "SearchPostsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xd1810907,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x17790b35,

    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field hashtag Field.
    hashtag = NULL,
    #  @field area Field.
    area = NULL,
    #  @field peer Field.
    peer = NULL,

    #  @description Initialize SearchPostsRequest
    # 
    #  @param offset character
    #  @param limit integer
    #  @param hashtag character or NULL
    #  @param area TypeMediaArea or NULL
    #  @param peer TypeInputPeer or NULL
    initialize = function(offset, limit, hashtag = NULL, area = NULL, peer = NULL) {
      self$offset <- as.character(offset)
      self$limit <- as.integer(limit)
      self$hashtag <- if (!is.null(hashtag)) as.character(hashtag) else NULL
      self$area <- if (!is.null(area)) area else NULL
      self$peer <- if (!is.null(peer)) peer else NULL
    },

    #  @description Resolve peer/area references
    # 
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer/get_input_media_area (area expected as TL object normally)
    resolve = function(client, utils) {
      if (!is.null(self$peer)) {
        input_entity <- client$get_input_entity(self$peer)
        self$peer <- get_input_peer(input_entity)
      }
      invisible(self)
    },

    #  @description Convert to list
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "SearchPostsRequest",
        offset = self$offset,
        limit = self$limit,
        hashtag = self$hashtag,
        area = if (inherits(self$area, "TLObject") && is.function(self$area$to_list)) self$area$to_list() else self$area,
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer
      )
    },

    #  @description Serialize to raw TL bytes
    # 
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes (0xd1810907 little-endian)
      parts[[1]] <- as.raw(c(0x07, 0x09, 0x81, 0xd1))

      # flags: hashtag=1, area=2, peer=4
      flags <- 0L
      if (!is.null(self$hashtag)) flags <- bitwOr(flags, 1L)
      if (!is.null(self$area)) flags <- bitwOr(flags, 2L)
      if (!is.null(self$peer)) flags <- bitwOr(flags, 4L)
      parts[[length(parts) + 1]] <- writeBin(as.integer(flags), raw(), size = 4, endian = "little")

      # optional hashtag
      if (!is.null(self$hashtag)) {
        if (is.function(self$serialize_bytes)) {
          parts[[length(parts) + 1]] <- self$serialize_bytes(self$hashtag)
        } else {
          sraw <- charToRaw(enc2utf8(self$hashtag))
          parts[[length(parts) + 1]] <- writeBin(as.integer(length(sraw)), raw(), size = 1, endian = "little")
          parts[[length(parts) + 1]] <- sraw
        }
      }

      # optional area bytes
      if (!is.null(self$area)) {
        if (is.function(self$area$to_bytes)) {
          parts[[length(parts) + 1]] <- self$area$to_bytes()
        } else if (is.function(self$area$bytes)) {
          parts[[length(parts) + 1]] <- self$area$bytes()
        } else if (is.function(self$area$.bytes)) {
          parts[[length(parts) + 1]] <- self$area$.bytes()
        } else {
          stop("area object must provide to_bytes/bytes/_bytes")
        }
      }

      # optional peer bytes
      if (!is.null(self$peer)) {
        if (is.function(self$peer$to_bytes)) {
          parts[[length(parts) + 1]] <- self$peer$to_bytes()
        } else if (is.function(self$peer$bytes)) {
          parts[[length(parts) + 1]] <- self$peer$bytes()
        } else if (is.function(self$peer$bytes)) {
          parts[[length(parts) + 1]] <- self$peer$bytes()
        } else {
          stop("peer object must provide to_bytes/bytes/_bytes")
        }
      }

      # offset and limit
      if (is.function(self$serialize_bytes)) {
        parts[[length(parts) + 1]] <- self$serialize_bytes(self$offset)
      } else {
        offset_raw <- charToRaw(enc2utf8(self$offset))
        parts[[length(parts) + 1]] <- writeBin(as.integer(length(offset_raw)), raw(), size = 1, endian = "little")
        parts[[length(parts) + 1]] <- offset_raw
      }
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$limit), raw(), size = 4, endian = "little")

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a SearchPostsRequest instance from reader
    # 
    #  reader is expected to implement: read_int(), tgread_object(), tgread_string(), tgread_bytes()
    #  @param reader reader object
    #  @return SearchPostsRequest
    from_reader = function(reader) {
      flagsVal <- reader$read_int()
      hashtagVal <- if (bitwAnd(flagsVal, 1L) != 0L) reader$tgread_string() else NULL
      areaVal <- if (bitwAnd(flagsVal, 2L) != 0L) reader$tgread_object() else NULL
      peerVal <- if (bitwAnd(flagsVal, 4L) != 0L) reader$tgread_object() else NULL

      offsetVal <- reader$tgread_string()
      limitVal <- reader$read_int()

      SearchPostsRequest$new(offset = offsetVal, limit = limitVal, hashtag = hashtagVal, area = areaVal, peer = peerVal)
    }
  )
)


#' @title SendReactionRequest
#' @description Telegram API request \code{stories.sendReaction} (constructor \code{#7fd736b2}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
SendReactionRequest <- R6::R6Class(
  "SendReactionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x7fd736b2,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @field peer Field.
    peer = NULL,
    #  @field story_id Field.
    story_id = NULL,
    #  @field reaction Field.
    reaction = NULL,
    #  @field add_to_recent Field.
    add_to_recent = NULL,

    #  @description Initialize SendReactionRequest
    # 
    #  @param peer TypeInputPeer
    #  @param story_id integer
    #  @param reaction TypeReaction
    #  @param add_to_recent logical or NULL
    initialize = function(peer, story_id, reaction, add_to_recent = NULL) {
      self$peer <- peer
      self$story_id <- as.integer(story_id)
      self$reaction <- reaction
      self$add_to_recent <- if (!is.null(add_to_recent)) as.logical(add_to_recent) else NULL
    },

    #  @description Resolve peer references
    # 
    #  Convert high-level peer references to input peers using provided client/utils.
    #  @param client client object with get_input_entity method
    #  @param utils utils object with get_input_peer method
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list (similar to to_dict)
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "SendReactionRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        story_id = self$story_id,
        reaction = if (inherits(self$reaction, "TLObject") && is.function(self$reaction$to_list)) self$reaction$to_list() else self$reaction,
        add_to_recent = self$add_to_recent
      )
    },

    #  @description Serialize to raw bytes
    # 
    #  Produces a raw vector matching TL binary layout for this request.
    #  Expects helper serialization methods on peer and reaction (to_bytes/bytes/_bytes).
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes (little-endian representation of 0x7fd736b2)
      parts[[1]] <- as.raw(c(0xb2, 0x36, 0xd7, 0x7f))

      # flags (uint32 little-endian). bit 0 (1) = add_to_recent
      flags <- 0L
      if (!is.null(self$add_to_recent) && isTRUE(self$add_to_recent)) flags <- bitwOr(flags, 1L)
      parts[[length(parts) + 1]] <- writeBin(as.integer(flags), raw(), size = 4, endian = "little")

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # story_id int32 little-endian
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$story_id), raw(), size = 4, endian = "little")

      # reaction bytes
      if (is.function(self$reaction$to_bytes)) {
        parts[[length(parts) + 1]] <- self$reaction$to_bytes()
      } else if (is.function(self$reaction$bytes)) {
        parts[[length(parts) + 1]] <- self$reaction$bytes()
      } else if (is.function(self$reaction$.bytes)) {
        parts[[length(parts) + 1]] <- self$reaction$.bytes()
      } else {
        stop("reaction object must provide a to_bytes/bytes/_bytes method")
      }

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a SendReactionRequest instance from a reader
    # 
    #  reader is expected to implement: read_int(), tgread_object()
    #  @param reader an object with read_int and tgread_object methods
    #  @return SendReactionRequest
    from_reader = function(reader) {
      flagsVal <- reader$read_int()
      addToRecentVal <- bitwAnd(flagsVal, 1L) != 0L

      peerObj <- reader$tgread_object()
      storyIdVal <- reader$read_int()
      reactionObj <- reader$tgread_object()

      SendReactionRequest$new(
        peer = peerObj,
        story_id = storyIdVal,
        reaction = reactionObj,
        add_to_recent = if (addToRecentVal) TRUE else NULL
      )
    }
  )
)


#' @title SendStoryRequest
#' @description Telegram API request \code{stories.sendStory} (constructor \code{#8f9e6898}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
SendStoryRequest <- R6::R6Class("SendStoryRequest",
  inherit = TLRequest,
  public = list(
    CONSTRUCTOR_ID = 0x8f9e6898,
    SUBCLASS_OF_ID = 0x8af52aac,
    pinned = NULL,
    noforwards = NULL,
    fwd_modified = NULL,
    peer = NULL,
    media = NULL,
    media_areas = NULL,
    caption = NULL,
    entities = NULL,
    privacy_rules = NULL,
    random_id = NULL,
    period = NULL,
    fwd_from_id = NULL,
    fwd_from_story = NULL,
    albums = NULL,
    music = NULL,
    initialize = function(pinned = NULL, noforwards = NULL, fwd_modified = NULL, peer, media, media_areas = NULL, caption = NULL, entities = NULL, privacy_rules, random_id, period = NULL, fwd_from_id = NULL, fwd_from_story = NULL, albums = NULL, music = NULL) {
      self$pinned <- pinned
      self$noforwards <- noforwards
      self$fwd_modified <- fwd_modified
      self$peer <- peer
      self$media <- media
      self$media_areas <- media_areas
      self$caption <- caption
      self$entities <- entities
      self$privacy_rules <- privacy_rules
      self$random_id <- random_id
      self$period <- period
      self$fwd_from_id <- fwd_from_id
      self$fwd_from_story <- fwd_from_story
      self$albums <- albums
      self$music <- music
    },
    resolve = function(client, utils) {
      if (!is.null(self$peer)) self$peer <- tryCatch(utils$get_input_peer(client$get_input_entity(self$peer)), error = function(e) self$peer)
      if (!is.null(self$fwd_from_id)) self$fwd_from_id <- tryCatch(utils$get_input_peer(client$get_input_entity(self$fwd_from_id)), error = function(e) self$fwd_from_id)
      invisible(self)
    },
    to_dict = function() {
      list(
        `_` = "SendStoryRequest",
        "pinned" = if (inherits(self$pinned, "TLObject")) self$pinned$to_dict() else self$pinned,
        "noforwards" = if (inherits(self$noforwards, "TLObject")) self$noforwards$to_dict() else self$noforwards,
        "fwd_modified" = if (inherits(self$fwd_modified, "TLObject")) self$fwd_modified$to_dict() else self$fwd_modified,
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "media" = if (inherits(self$media, "TLObject")) self$media$to_dict() else self$media,
        "media_areas" = if (inherits(self$media_areas, "TLObject")) self$media_areas$to_dict() else self$media_areas,
        "caption" = if (inherits(self$caption, "TLObject")) self$caption$to_dict() else self$caption,
        "entities" = if (inherits(self$entities, "TLObject")) self$entities$to_dict() else self$entities,
        "privacy_rules" = if (inherits(self$privacy_rules, "TLObject")) self$privacy_rules$to_dict() else self$privacy_rules,
        "random_id" = if (inherits(self$random_id, "TLObject")) self$random_id$to_dict() else self$random_id,
        "period" = if (inherits(self$period, "TLObject")) self$period$to_dict() else self$period,
        "fwd_from_id" = if (inherits(self$fwd_from_id, "TLObject")) self$fwd_from_id$to_dict() else self$fwd_from_id,
        "fwd_from_story" = if (inherits(self$fwd_from_story, "TLObject")) self$fwd_from_story$to_dict() else self$fwd_from_story,
        "albums" = if (inherits(self$albums, "TLObject")) self$albums$to_dict() else self$albums,
        "music" = if (inherits(self$music, "TLObject")) self$music$to_dict() else self$music
      )
    },
    to_list = function() {
      list(
        `_` = "SendStoryRequest",
        "pinned" = if (inherits(self$pinned, "TLObject")) self$pinned$to_dict() else self$pinned,
        "noforwards" = if (inherits(self$noforwards, "TLObject")) self$noforwards$to_dict() else self$noforwards,
        "fwd_modified" = if (inherits(self$fwd_modified, "TLObject")) self$fwd_modified$to_dict() else self$fwd_modified,
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "media" = if (inherits(self$media, "TLObject")) self$media$to_dict() else self$media,
        "media_areas" = if (inherits(self$media_areas, "TLObject")) self$media_areas$to_dict() else self$media_areas,
        "caption" = if (inherits(self$caption, "TLObject")) self$caption$to_dict() else self$caption,
        "entities" = if (inherits(self$entities, "TLObject")) self$entities$to_dict() else self$entities,
        "privacy_rules" = if (inherits(self$privacy_rules, "TLObject")) self$privacy_rules$to_dict() else self$privacy_rules,
        "random_id" = if (inherits(self$random_id, "TLObject")) self$random_id$to_dict() else self$random_id,
        "period" = if (inherits(self$period, "TLObject")) self$period$to_dict() else self$period,
        "fwd_from_id" = if (inherits(self$fwd_from_id, "TLObject")) self$fwd_from_id$to_dict() else self$fwd_from_id,
        "fwd_from_story" = if (inherits(self$fwd_from_story, "TLObject")) self$fwd_from_story$to_dict() else self$fwd_from_story,
        "albums" = if (inherits(self$albums, "TLObject")) self$albums$to_dict() else self$albums,
        "music" = if (inherits(self$music, "TLObject")) self$music$to_dict() else self$music
      )
    },
    to_bytes = function() {
      flags <- 0L
      if (isTRUE(self$pinned)) flags <- bitwOr(flags, 4L)
      if (isTRUE(self$noforwards)) flags <- bitwOr(flags, 16L)
      if (isTRUE(self$fwd_modified)) flags <- bitwOr(flags, 128L)
      if (!is.null(self$media_areas)) flags <- bitwOr(flags, 32L)
      if (!is.null(self$caption)) flags <- bitwOr(flags, 1L)
      if (!is.null(self$entities)) flags <- bitwOr(flags, 2L)
      if (!is.null(self$period)) flags <- bitwOr(flags, 8L)
      if (!is.null(self$fwd_from_id)) flags <- bitwOr(flags, 64L)
      if (!is.null(self$fwd_from_story)) flags <- bitwOr(flags, 64L)
      if (!is.null(self$albums)) flags <- bitwOr(flags, 256L)
      if (!is.null(self$music)) flags <- bitwOr(flags, 512L)
      c(
        as.raw(c(0x98, 0x68, 0x9e, 0x8f)),
        pack("<I", flags),
        self$peer$bytes(),
        self$media$bytes(),
        if (!is.null(self$media_areas)) .telegramR_tl_vector(self$media_areas) else raw(0),
        if (!is.null(self$caption)) serialize_bytes(self$caption) else raw(0),
        if (!is.null(self$entities)) .telegramR_tl_vector(self$entities) else raw(0),
        .telegramR_tl_vector(self$privacy_rules),
        packInt64(self$random_id),
        if (!is.null(self$period)) pack("<i", self$period) else raw(0),
        if (!is.null(self$fwd_from_id)) self$fwd_from_id$bytes() else raw(0),
        if (!is.null(self$fwd_from_story)) pack("<i", self$fwd_from_story) else raw(0),
        if (!is.null(self$albums)) c(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$albums)), if (length(self$albums) > 0) do.call(c, lapply(self$albums, function(x) pack("<i", x))) else raw(0)) else raw(0),
        if (!is.null(self$music)) self$music$bytes() else raw(0)
      )
    },
    serialize = function() self$to_bytes()
  ),
  private = list(
    from_reader = function(reader) {
      flags <- reader$read_int()
      self$pinned <- bitwAnd(flags, 4L) != 0
      self$noforwards <- bitwAnd(flags, 16L) != 0
      self$fwd_modified <- bitwAnd(flags, 128L) != 0
      self$peer <- reader$tgread_object()
      self$media <- reader$tgread_object()
      self$media_areas <- if (bitwAnd(flags, 32L) != 0) reader$tgread_vector() else NULL
      self$caption <- if (bitwAnd(flags, 1L) != 0) reader$tgread_string() else NULL
      self$entities <- if (bitwAnd(flags, 2L) != 0) reader$tgread_vector() else NULL
      self$privacy_rules <- reader$tgread_vector()
      self$random_id <- reader$read_long()
      self$period <- if (bitwAnd(flags, 8L) != 0) reader$read_int() else NULL
      self$fwd_from_id <- if (bitwAnd(flags, 64L) != 0) reader$tgread_object() else NULL
      self$fwd_from_story <- if (bitwAnd(flags, 64L) != 0) reader$read_int() else NULL
      self$albums <- if (bitwAnd(flags, 256L) != 0) { reader$read_int(); n_ <- reader$read_int(); if (n_ > 0) lapply(seq_len(n_), function(.i) reader$read_int()) else list() } else NULL
      self$music <- if (bitwAnd(flags, 512L) != 0) reader$tgread_object() else NULL
      self
    }
  ),
  class = TRUE,
  lock_objects = FALSE
)

#' @title ToggleAllStoriesHiddenRequest
#' @description Telegram API request \code{stories.toggleAllStoriesHidden} (constructor \code{#7c2557c4}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ToggleAllStoriesHiddenRequest <- R6::R6Class(
  "ToggleAllStoriesHiddenRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x7c2557c4,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @field hidden Field.
    hidden = NULL,

    #  @description Initialize ToggleAllStoriesHiddenRequest
    # 
    #  @param hidden logical
    initialize = function(hidden) {
      self$hidden <- as.logical(hidden)
    },

    #  @description Convert to list (similar to to_dict)
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "ToggleAllStoriesHiddenRequest",
        hidden = self$hidden
      )
    },

    #  @description Serialize to raw bytes
    # 
    #  Produces a raw vector matching TL binary layout for this request.
    #  @return raw
    to_bytes = function() {
      # constructor bytes: b'\xc4W%|' (0xc4 0x57 0x25 0x7c)
      parts <- list(as.raw(c(0xc4, 0x57, 0x25, 0x7c)))

      # TL-encoded bool: True -> b'\xb5ur\x99', False -> b'7\x97y\xbc'
      true_bytes <- as.raw(c(0xb5, 0x75, 0x72, 0x99))
      false_bytes <- as.raw(c(0x37, 0x97, 0x79, 0xbc))
      parts[[length(parts) + 1]] <- if (isTRUE(self$hidden)) true_bytes else false_bytes

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a ToggleAllStoriesHiddenRequest instance from a reader
    # 
    #  reader is expected to implement: tgread_bool()
    #  @param reader an object with tgread_bool method
    #  @return ToggleAllStoriesHiddenRequest
    from_reader = function(reader) {
      hidden_flag <- reader$tgread_bool()
      ToggleAllStoriesHiddenRequest$new(hidden = hidden_flag)
    }
  )
)


#' @title TogglePeerStoriesHiddenRequest
#' @description Telegram API request \code{stories.togglePeerStoriesHidden} (constructor \code{#bd0415c4}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
TogglePeerStoriesHiddenRequest <- R6::R6Class(
  "TogglePeerStoriesHiddenRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xbd0415c4,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @field peer Field.
    peer = NULL,
    #  @field hidden Field.
    hidden = NULL,

    #  @description Initialize TogglePeerStoriesHiddenRequest
    # 
    #  @param peer TypeInputPeer
    #  @param hidden logical
    initialize = function(peer, hidden) {
      self$peer <- peer
      self$hidden <- as.logical(hidden)
    },

    #  @description Resolve peer references
    # 
    #  Convert high-level peer references to input peers using provided client/utils.
    #  @param client client object with get_input_entity method
    #  @param utils utils object with get_input_peer method
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list (similar to to_dict)
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "TogglePeerStoriesHiddenRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        hidden = self$hidden
      )
    },

    #  @description Serialize to raw bytes
    # 
    #  Produces a raw vector matching TL binary layout.
    #  Expects helper serialization methods on peer (to_bytes/bytes/_bytes).
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes: b'\xc4\x15\x04\xbd' (0xc4 0x15 0x04 0xbd)
      parts[[1]] <- as.raw(c(0xc4, 0x15, 0x04, 0xbd))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # TL-encoded bool: True -> b'\xb5ur\x99', False -> b'7\x97y\xbc'
      true_bytes <- as.raw(c(0xb5, 0x75, 0x72, 0x99))
      false_bytes <- as.raw(c(0x37, 0x97, 0x79, 0xbc))
      parts[[length(parts) + 1]] <- if (isTRUE(self$hidden)) true_bytes else false_bytes

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a TogglePeerStoriesHiddenRequest instance from a reader
    # 
    #  reader is expected to implement: tgread_object(), tgread_bool()
    #  @param reader an object with tgread_object and tgread_bool methods
    #  @return TogglePeerStoriesHiddenRequest
    from_reader = function(reader) {
      peer_obj <- reader$tgread_object()
      hidden_flag <- reader$tgread_bool()
      TogglePeerStoriesHiddenRequest$new(peer = peer_obj, hidden = hidden_flag)
    }
  )
)


#' @title TogglePinnedRequest
#' @description Telegram API request \code{stories.togglePinned} (constructor \code{#9a75a1ef}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
TogglePinnedRequest <- R6::R6Class(
  "TogglePinnedRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x9a75a1ef,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x5026710f,

    #  @field peer Field.
    peer = NULL,
    #  @field id Field.
    id = NULL,
    #  @field pinned Field.
    pinned = NULL,

    #  @description Initialize TogglePinnedRequest
    # 
    #  @param peer TypeInputPeer
    #  @param id integer vector of story ids
    #  @param pinned logical
    initialize = function(peer, id, pinned) {
      self$peer <- peer
      self$id <- if (!is.null(id)) as.integer(id) else integer(0)
      self$pinned <- as.logical(pinned)
    },

    #  @description Resolve peer references
    # 
    #  Convert high-level peer references to input peers using provided client/utils.
    #  @param client client object with get_input_entity method
    #  @param utils utils object with get_input_peer method
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list (similar to to_dict)
    # 
    #  Prepare a pure R list representation suitable for inspection or JSON.
    #  @return list
    to_list = function() {
      list(
        `_` = "TogglePinnedRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        id = if (is.null(self$id)) list() else as.integer(self$id),
        pinned = self$pinned
      )
    },

    #  @description Serialize to raw bytes
    # 
    #  Produces a raw vector matching TL binary layout.
    #  Expects helper serialization methods on peer (to_bytes/bytes/_bytes) and writeBin available.
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes from original spec: b'\xef\xa1u\x9a'
      parts[[1]] <- as.raw(c(0xef, 0xa1, 0x75, 0x9a))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # vector tag + length + ints
      vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
      parts[[length(parts) + 1]] <- vec_tag
      parts[[length(parts) + 1]] <- writeBin(as.integer(length(self$id)), raw(), size = 4, endian = "little")
      for (v in self$id) {
        parts[[length(parts) + 1]] <- writeBin(as.integer(v), raw(), size = 4, endian = "little")
      }

      # pinned boolean encoded as specific 4-byte bool (per spec)
      true_bytes <- as.raw(c(0xb5, 0x75, 0x72, 0x99)) # b'\xb5ur\x99'
      false_bytes <- as.raw(c(0x37, 0x97, 0x79, 0xbc)) # b'7\x97y\xbc'
      parts[[length(parts) + 1]] <- if (isTRUE(self$pinned)) true_bytes else false_bytes

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a TogglePinnedRequest instance from a reader
    # 
    #  reader is expected to implement: read_int(), tgread_object(), tgread_bool()
    #  @param reader an object with read_int, tgread_object, tgread_bool methods
    #  @return TogglePinnedRequest
    from_reader = function(reader) {
      peer_obj <- reader$tgread_object()

      # read vector tag then length then ints
      # vector constructor id (ignored)
      n <- reader$read_int()
      ids <- if (n <= 0) integer(0) else integer(n)
      if (n > 0) {
        for (i in seq_len(n)) ids[i] <- reader$read_int()
      }

      pinned_flag <- reader$tgread_bool()
      TogglePinnedRequest$new(peer = peer_obj, id = ids, pinned = pinned_flag)
    },

    #  @description Read result (Vector<int>) from reader
    # 
    #  @param reader reader with read_int method
    #  @return integer vector
    read_result = function(reader) {
      # read vector constructor id

      n <- reader$read_int()
      if (n <= 0) {
        return(integer(0))
      }
      out <- integer(n)
      for (i in seq_len(n)) out[i] <- reader$read_int()
      out
    }
  )
)


#' @title TogglePinnedToTopRequest
#' @description Telegram API request \code{stories.togglePinnedToTop} (constructor \code{#0b297e9b}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
TogglePinnedToTopRequest <- R6::R6Class(
  "TogglePinnedToTopRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x0b297e9b,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @field peer Field.
    peer = NULL,
    #  @field id Field.
    id = NULL,

    #  @description Initialize TogglePinnedToTopRequest
    # 
    #  @param peer TypeInputPeer
    #  @param id integer vector of story ids
    initialize = function(peer, id) {
      self$peer <- peer
      self$id <- if (!is.null(id)) as.integer(id) else integer(0)
    },

    #  @description Resolve peer references
    # 
    #  Convert high-level peer references to input peers using provided client/utils.
    #  @param client client object with get_input_entity method
    #  @param utils utils object with get_input_peer method
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list (similar to to_dict)
    # 
    #  Prepare a pure R list representation suitable for inspection or JSON.
    #  @return list
    to_list = function() {
      list(
        `_` = "TogglePinnedToTopRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        id = if (is.null(self$id)) list() else as.integer(self$id)
      )
    },

    #  @description Serialize to raw bytes
    # 
    #  Produces a raw vector matching TL binary layout.
    #  Expects helper serialization methods on peer (to_bytes/bytes/_bytes) and writeBin available.
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes from original spec: b'\x9b~)\x0b'
      parts[[1]] <- as.raw(c(0x9b, 0x7e, 0x29, 0x0b))

      # peer bytes
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # vector tag + length + ints
      vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
      parts[[length(parts) + 1]] <- vec_tag
      parts[[length(parts) + 1]] <- writeBin(as.integer(length(self$id)), raw(), size = 4, endian = "little")
      for (v in self$id) {
        parts[[length(parts) + 1]] <- writeBin(as.integer(v), raw(), size = 4, endian = "little")
      }

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a TogglePinnedToTopRequest instance from a reader
    # 
    #  reader is expected to implement: read_int(), tgread_object()
    #  @param reader an object with read_int, tgread_object methods
    #  @return TogglePinnedToTopRequest
    from_reader = function(reader) {
      peer_obj <- reader$tgread_object()

      # read vector tag then length then ints
      # vector constructor id (ignored)
      n <- reader$read_int()
      ids <- if (n <= 0) integer(0) else integer(n)
      if (n > 0) {
        for (i in seq_len(n)) ids[i] <- reader$read_int()
      }

      TogglePinnedToTopRequest$new(peer = peer_obj, id = ids)
    }
  )
)


#' @title UpdateAlbumRequest
#' @description Telegram API request \code{stories.updateAlbum} (constructor \code{#5e5259b6}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
UpdateAlbumRequest <- R6::R6Class(
  "UpdateAlbumRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x5e5259b6,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x7c8c5ea2,
    #  @field peer Field.
    peer = NULL,
    #  @field album_id Field.
    album_id = NULL,
    #  @field title Field.
    title = NULL,
    #  @field delete_stories Field.
    delete_stories = NULL,
    #  @field add_stories Field.
    add_stories = NULL,
    #  @field order Field.
    order = NULL,

    #  @description Initialize UpdateAlbumRequest
    # 
    #  @param peer TypeInputPeer
    #  @param album_id integer
    #  @param title character or NULL
    #  @param delete_stories integer vector or NULL
    #  @param add_stories integer vector or NULL
    #  @param order integer vector or NULL
    initialize = function(peer, album_id, title = NULL, delete_stories = NULL, add_stories = NULL, order = NULL) {
      self$peer <- peer
      self$album_id <- as.integer(album_id)
      self$title <- if (!is.null(title)) as.character(title) else NULL
      self$delete_stories <- if (!is.null(delete_stories)) as.integer(delete_stories) else NULL
      self$add_stories <- if (!is.null(add_stories)) as.integer(add_stories) else NULL
      self$order <- if (!is.null(order)) as.integer(order) else NULL
    },

    #  @description Resolve peer references
    # 
    #  Convert high-level peer references to input peers using provided client/utils.
    #  @param client client object with get_input_entity method
    #  @param utils utils object with get_input_peer method
    resolve = function(client, utils) {
      # synchronous style: client$get_input_entity and get_input_peer expected to be available
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      invisible(self)
    },

    #  @description Convert to list (similar to to_dict)
    # 
    #  Prepare a pure R list representation suitable for inspection or JSON.
    #  @return list
    to_list = function() {
      list(
        `_` = "UpdateAlbumRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        album_id = self$album_id,
        title = self$title,
        delete_stories = if (is.null(self$delete_stories)) list() else as.integer(self$delete_stories),
        add_stories = if (is.null(self$add_stories)) list() else as.integer(self$add_stories),
        order = if (is.null(self$order)) list() else as.integer(self$order)
      )
    },

    #  @description Serialize to raw bytes
    # 
    #  This produces a raw vector intended to match the TL binary layout used in the original implementation.
    #  It expects helper serialization methods available on the peer object (peer$to_bytes / peer$bytes),
    #  and a serialize_bytes(self, string) method on the TLRequest base or in scope.
    #  @return raw
    to_bytes = function() {
      # compute flags
      flags <- 0L
      if (!is.null(self$title)) flags <- bitwOr(flags, 1L)
      if (!is.null(self$delete_stories)) flags <- bitwOr(flags, 2L)
      if (!is.null(self$add_stories)) flags <- bitwOr(flags, 4L)
      if (!is.null(self$order)) flags <- bitwOr(flags, 8L)

      # constructor id bytes (b'\xb6YR^' -> 0xb6 0x59 0x52 0x5e)
      parts <- list(as.raw(c(0xb6, 0x59, 0x52, 0x5e)))

      # flags (uint32 little-endian)
      parts[[length(parts) + 1]] <- writeBin(as.integer(flags), raw(), size = 4, endian = "little")

      # peer bytes (assumes peer has to_bytes() or bytes() or _bytes())
      if (is.function(self$peer$to_bytes)) {
        parts[[length(parts) + 1]] <- self$peer$to_bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else if (is.function(self$peer$bytes)) {
        parts[[length(parts) + 1]] <- self$peer$bytes()
      } else {
        stop("peer object must provide a to_bytes/bytes/_bytes method")
      }

      # album_id (int32 little-endian)
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$album_id), raw(), size = 4, endian = "little")

      # optional fields
      if (!is.null(self$title)) {
        # expects TLRequest or scope provides serialize_bytes
        if (is.function(self$serialize_bytes)) {
          parts[[length(parts) + 1]] <- self$serialize_bytes(self$title)
        } else {
          # naive string -> TL string (length + bytes); may be adapted by user
          sraw <- charToRaw(enc2utf8(self$title))
          parts[[length(parts) + 1]] <- writeBin(as.integer(length(sraw)), raw(), size = 1, endian = "little")
          parts[[length(parts) + 1]] <- sraw
        }
      }

      vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c)) # vector constructor bytes

      write_int_vector <- function(vec) {
        out <- list()
        out[[1]] <- vec_tag
        out[[2]] <- writeBin(as.integer(length(vec)), raw(), size = 4, endian = "little")
        for (v in vec) {
          out[[length(out) + 1]] <- writeBin(as.integer(v), raw(), size = 4, endian = "little")
        }
        do.call(c, out)
      }

      if (!is.null(self$delete_stories)) {
        parts[[length(parts) + 1]] <- write_int_vector(self$delete_stories)
      }
      if (!is.null(self$add_stories)) {
        parts[[length(parts) + 1]] <- write_int_vector(self$add_stories)
      }
      if (!is.null(self$order)) {
        parts[[length(parts) + 1]] <- write_int_vector(self$order)
      }

      do.call(c, parts)
    }
  ),


  # class method implemented as public so it can be called like UpdateAlbumRequest$from_reader(reader)
  class = list(
    #  @description Read an UpdateAlbumRequest instance from a reader
    # 
    #  reader is expected to implement: read_int(), tgread_object(), tgread_string()
    #  @param reader an object with read_int, tgread_object, tgread_string methods
    #  @return UpdateAlbumRequest
    from_reader = function(reader) {
      flags <- reader$read_int()
      peer_obj <- reader$tgread_object()
      album_id_val <- reader$read_int()

      title_val <- if (bitwAnd(flags, 1L) != 0L) reader$tgread_string() else NULL

      read_int_vector <- function() {
        # read and check vector constructor then length then ints
        .vec_tag <- reader$read_int() # usually vector constructor
        n <- reader$read_int()
        if (n <= 0) {
          return(integer(0))
        }
        out <- integer(n)
        for (i in seq_len(n)) out[i] <- reader$read_int()
        out
      }

      delete_stories_val <- if (bitwAnd(flags, 2L) != 0L) read_int_vector() else NULL
      add_stories_val <- if (bitwAnd(flags, 4L) != 0L) read_int_vector() else NULL
      order_val <- if (bitwAnd(flags, 8L) != 0L) read_int_vector() else NULL

      UpdateAlbumRequest$new(
        peer = peer_obj,
        album_id = album_id_val,
        title = title_val,
        delete_stories = delete_stories_val,
        add_stories = add_stories_val,
        order = order_val
      )
    }
  )
)
