#  ActivateStealthModeRequest R6 class
# 
#  Request to activate stealth mode with optional past/future flags.
#  Returns Updates.
#  @param past logical or NULL
#  @param future logical or NULL
#  @title ActivateStealthModeRequest
#  @description Telegram API type ActivateStealthModeRequest
#  @export
#  @noRd
#  @noRd
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


#  CanSendStoryRequest R6 class
# 
#  Request to check whether a story can be sent to a given peer.
#  Returns stories.CanSendStoryCount.
#  @param peer TypeInputPeer
#  @title CanSendStoryRequest
#  @description Telegram API type CanSendStoryRequest
#  @export
#  @noRd
#  @noRd
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


#  CreateAlbumRequest R6 class
# 
#  Request to create a story album for a given peer with a title and list of story ids.
#  Returns StoryAlbum.
#  @param peer TypeInputPeer
#  @param title character album title
#  @param stories integer vector of story ids
#  @title CreateAlbumRequest
#  @description Telegram API type CreateAlbumRequest
#  @export
#  @noRd
#  @noRd
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


#  DeleteAlbumRequest R6 class
# 
#  Request to delete an album for a given peer. Returns Bool.
#  @param peer TypeInputPeer
#  @param album_id integer album id
#  @title DeleteAlbumRequest
#  @description Telegram API type DeleteAlbumRequest
#  @export
#  @noRd
#  @noRd
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


#  DeleteStoriesRequest R6 class
# 
#  Request to delete one or more stories for a given peer. Returns Vector<int>.
#  @param peer TypeInputPeer
#  @param id integer vector of story ids
#  @title DeleteStoriesRequest
#  @description Telegram API type DeleteStoriesRequest
#  @export
#  @noRd
#  @noRd
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


#  EditStoryRequest R6 class
# 
#  Request to edit an existing story. Depending on flags this may include media,
#  media areas, caption+entities (both must be provided together) and privacy rules.
#  Returns Updates.
#  @param peer TypeInputPeer
#  @param id integer story id
#  @param media TypeInputMedia or NULL
#  @param media_areas list of TypeMediaArea or NULL
#  @param caption character or NULL (must be provided together with entities)
#  @param entities list of TypeMessageEntity or NULL (must be provided together with caption)
#  @param privacy_rules list of TypeInputPrivacyRule or NULL
#  @title EditStoryRequest
#  @description Telegram API type EditStoryRequest
#  @export
#  @noRd
#  @noRd
EditStoryRequest <- R6::R6Class(
  "EditStoryRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xb583ba46,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @field peer Field.
    peer = NULL,
    #  @field id Field.
    id = NULL,
    #  @field media Field.
    media = NULL,
    #  @field media_areas Field.
    media_areas = NULL,
    #  @field caption Field.
    caption = NULL,
    #  @field entities Field.
    entities = NULL,
    #  @field privacy_rules Field.
    privacy_rules = NULL,

    #  @description Initialize EditStoryRequest
    # 
    #  @param peer TypeInputPeer
    #  @param id integer
    #  @param media TypeInputMedia or NULL
    #  @param media_areas list or NULL
    #  @param caption character or NULL (must be provided together with entities)
    #  @param entities list or NULL (must be provided together with caption)
    #  @param privacy_rules list or NULL
    initialize = function(peer, id, media = NULL, media_areas = NULL, caption = NULL, entities = NULL, privacy_rules = NULL) {
      self$peer <- peer
      self$id <- as.integer(id)
      self$media <- if (!is.null(media)) media else NULL
      self$media_areas <- if (!is.null(media_areas)) media_areas else NULL
      self$caption <- if (!is.null(caption)) as.character(caption) else NULL
      self$entities <- if (!is.null(entities)) entities else NULL
      self$privacy_rules <- if (!is.null(privacy_rules)) privacy_rules else NULL

      # enforce caption and entities to be both present or both NULL (they share the same flag)
      if (!((is.null(self$caption) && is.null(self$entities)) || (!is.null(self$caption) && !is.null(self$entities)))) {
        stop("caption and entities parameters must be either both NULL or both provided")
      }

      invisible(self)
    },

    #  @description Resolve peer/media references
    # 
    #  Convert high-level references to input forms using client/utils.
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer and get_input_media
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      if (!is.null(self$media)) {
        self$media <- get_input_media(self$media)
      }
      invisible(self)
    },

    #  @description Convert to list
    #  @return list
    to_list = function() {
      list(
        `_` = "EditStoryRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        id = self$id,
        media = if (inherits(self$media, "TLObject") && is.function(self$media$to_list)) self$media$to_list() else self$media,
        media_areas = if (is.null(self$media_areas)) list() else lapply(self$media_areas, function(x) if (inherits(x, "TLObject") && is.function(x$to_list)) x$to_list() else x),
        caption = self$caption,
        entities = if (is.null(self$entities)) list() else lapply(self$entities, function(x) if (inherits(x, "TLObject") && is.function(x$to_list)) x$to_list() else x),
        privacy_rules = if (is.null(self$privacy_rules)) list() else lapply(self$privacy_rules, function(x) if (inherits(x, "TLObject") && is.function(x$to_list)) x$to_list() else x)
      )
    },

    #  @description Serialize to raw TL bytes
    # 
    #  @return raw
    to_bytes = function() {
      # constructor bytes little-endian for 0xb583ba46 -> 0x46 0xba 0x83 0xb5
      parts <- list()
      parts[[1]] <- as.raw(c(0x46, 0xba, 0x83, 0xb5))

      # flags: media=1, caption+entities=2 (must be both), privacy_rules=4, media_areas=8
      flagsVal <- 0L
      if (!is.null(self$media)) flagsVal <- bitwOr(flagsVal, 1L)
      if (!is.null(self$caption) && !is.null(self$entities)) flagsVal <- bitwOr(flagsVal, 2L)
      if (!is.null(self$privacy_rules)) flagsVal <- bitwOr(flagsVal, 4L)
      if (!is.null(self$media_areas)) flagsVal <- bitwOr(flagsVal, 8L)

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

      # id int32 little-endian
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$id), raw(), size = 4, endian = "little")

      # optional media
      if (!is.null(self$media)) {
        if (is.function(self$media$to_bytes)) {
          parts[[length(parts) + 1]] <- self$media$to_bytes()
        } else if (is.function(self$media$bytes)) {
          parts[[length(parts) + 1]] <- self$media$bytes()
        } else if (is.function(self$media$.bytes)) {
          parts[[length(parts) + 1]] <- self$media$.bytes()
        } else {
          stop("media object must provide a to_bytes/bytes/_bytes method")
        }
      }

      # optional media_areas vector
      if (!is.null(self$media_areas)) {
        vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
        parts[[length(parts) + 1]] <- vec_tag
        parts[[length(parts) + 1]] <- writeBin(as.integer(length(self$media_areas)), raw(), size = 4, endian = "little")
        for (ma in self$media_areas) {
          if (is.function(ma$to_bytes)) {
            parts[[length(parts) + 1]] <- ma$to_bytes()
          } else if (is.function(ma$bytes)) {
            parts[[length(parts) + 1]] <- ma$bytes()
          } else if (is.function(ma$.bytes)) {
            parts[[length(parts) + 1]] <- ma$.bytes()
          } else {
            stop("media_area element must provide to_bytes/bytes/_bytes")
          }
        }
      }

      # caption and entities share a flag -> both must be present or both NULL
      if (!is.null(self$caption) && !is.null(self$entities)) {
        if (is.function(self$serialize_bytes)) {
          parts[[length(parts) + 1]] <- self$serialize_bytes(self$caption)
        } else {
          sraw <- charToRaw(enc2utf8(self$caption))
          parts[[length(parts) + 1]] <- writeBin(as.integer(length(sraw)), raw(), size = 1, endian = "little")
          parts[[length(parts) + 1]] <- sraw
        }

        vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
        parts[[length(parts) + 1]] <- vec_tag
        parts[[length(parts) + 1]] <- writeBin(as.integer(length(self$entities)), raw(), size = 4, endian = "little")
        for (ent in self$entities) {
          if (is.function(ent$to_bytes)) {
            parts[[length(parts) + 1]] <- ent$to_bytes()
          } else if (is.function(ent$bytes)) {
            parts[[length(parts) + 1]] <- ent$bytes()
          } else if (is.function(ent$.bytes)) {
            parts[[length(parts) + 1]] <- ent$.bytes()
          } else {
            stop("entity element must provide to_bytes/bytes/_bytes")
          }
        }
      }

      # optional privacy_rules vector
      if (!is.null(self$privacy_rules)) {
        vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
        parts[[length(parts) + 1]] <- vec_tag
        parts[[length(parts) + 1]] <- writeBin(as.integer(length(self$privacy_rules)), raw(), size = 4, endian = "little")
        for (pr in self$privacy_rules) {
          if (is.function(pr$to_bytes)) {
            parts[[length(parts) + 1]] <- pr$to_bytes()
          } else if (is.function(pr$bytes)) {
            parts[[length(parts) + 1]] <- pr$bytes()
          } else if (is.function(pr$.bytes)) {
            parts[[length(parts) + 1]] <- pr$.bytes()
          } else {
            stop("privacy_rule element must provide to_bytes/bytes/_bytes")
          }
        }
      }

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read an EditStoryRequest instance from a reader
    # 
    #  reader expected to implement: read_int(), tgread_object(), tgread_string()
    #  @param reader reader object
    #  @return EditStoryRequest
    from_reader = function(reader) {
      flagsVal <- reader$read_int()

      peerObj <- reader$tgread_object()
      idVal <- reader$read_int()

      mediaObj <- NULL
      if (bitwAnd(flagsVal, 1L) != 0L) {
        mediaObj <- reader$tgread_object()
      }

      mediaAreasList <- NULL
      if (bitwAnd(flagsVal, 8L) != 0L) {
        # vector constructor id (ignored)
        nma <- reader$read_int()
        if (nma > 0) {
          mediaAreasList <- vector("list", nma)
          for (i in seq_len(nma)) mediaAreasList[[i]] <- reader$tgread_object()
        } else {
          mediaAreasList <- list()
        }
      }

      captionVal <- NULL
      entitiesList <- NULL
      if (bitwAnd(flagsVal, 2L) != 0L) {
        captionVal <- reader$tgread_string()

        # read entities vector
        # vector constructor id (ignored)
        ne <- reader$read_int()
        if (ne > 0) {
          entitiesList <- vector("list", ne)
          for (i in seq_len(ne)) entitiesList[[i]] <- reader$tgread_object()
        } else {
          entitiesList <- list()
        }
      }

      privacyRulesList <- NULL
      if (bitwAnd(flagsVal, 4L) != 0L) {
        # vector constructor id (ignored)
        npr <- reader$read_int()
        if (npr > 0) {
          privacyRulesList <- vector("list", npr)
          for (i in seq_len(npr)) privacyRulesList[[i]] <- reader$tgread_object()
        } else {
          privacyRulesList <- list()
        }
      }

      EditStoryRequest$new(
        peer = peerObj,
        id = idVal,
        media = mediaObj,
        media_areas = mediaAreasList,
        caption = captionVal,
        entities = entitiesList,
        privacy_rules = privacyRulesList
      )
    }
  )
)


#  ExportStoryLinkRequest R6 class
# 
#  Request to export a story link for a given peer and story id.
#  Returns stories.ExportedStoryLink.
#  @param peer TypeInputPeer
#  @param id integer story id
#  @title ExportStoryLinkRequest
#  @description Telegram API type ExportStoryLinkRequest
#  @export
#  @noRd
#  @noRd
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


#  GetAlbumStoriesRequest R6 class
# 
#  Request to get stories from an album for a given peer with paging (offset, limit).
#  Returns stories.Stories.
#  @param peer TypeInputPeer
#  @param album_id integer album id
#  @param offset integer offset id
#  @param limit integer limit
#  @title GetAlbumStoriesRequest
#  @description Telegram API type GetAlbumStoriesRequest
#  @export
#  @noRd
#  @noRd
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


#  GetAlbumsRequest R6 class
# 
#  Request to get albums for a peer. Returns stories.Albums (or AlbumsNotModified).
#  @param peer TypeInputPeer
#  @param hash numeric/int64 hash value
#  @title GetAlbumsRequest
#  @description Telegram API type GetAlbumsRequest
#  @export
#  @noRd
#  @noRd
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
      parts[[length(parts) + 1]] <- writeBin(as.numeric(self$hash), raw(), size = 8, endian = "little")

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


#  GetAllReadPeerStoriesRequest R6 class
# 
#  Request without parameters; returns all read peer stories.
#  @title GetAllReadPeerStoriesRequest
#  @description Telegram API type GetAllReadPeerStoriesRequest
#  @export
#  @noRd
#  @noRd
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


#  GetAllStoriesRequest R6 class
# 
#  Request to get all stories with optional pagination/visibility/state.
#  Returns stories.AllStories (or AllStoriesNotModified).
#  @param next logical or NULL (controls paging)
#  @param hidden logical or NULL (include hidden)
#  @param state character or NULL state cursor
#  @title GetAllStoriesRequest
#  @description Telegram API type GetAllStoriesRequest
#  @export
#  @noRd
#  @noRd
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


#  GetChatsToSendRequest R6 class
# 
#  Request without parameters; returns chats to send.
#  @title GetChatsToSendRequest
#  @description Telegram API type GetChatsToSendRequest
#  @export
#  @noRd
#  @noRd
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


#  GetPeerMaxIDsRequest R6 class
# 
#  Request to get maximum IDs for a vector of input peers. Returns Vector<int>.
#  @param id list of TypeInputPeer
#  @title GetPeerMaxIDsRequest
#  @description Telegram API type GetPeerMaxIDsRequest
#  @export
#  @noRd
#  @noRd
GetPeerMaxIDsRequest <- R6::R6Class(
  "GetPeerMaxIDsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x535983c3,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x5026710f,

    #  @field id Field.
    id = NULL,

    #  @description Initialize GetPeerMaxIDsRequest
    # 
    #  @param id list of TypeInputPeer
    initialize = function(id) {
      self$id <- if (!is.null(id)) id else list()
      invisible(self)
    },

    #  @description Resolve peer references
    # 
    #  Convert high-level peer references to input peers using client/utils.
    #  @param client client with get_input_entity
    #  @param utils utils with get_input_peer
    resolve = function(client, utils) {
      resolved_list <- list()
      if (length(self$id) > 0) {
        for (i in seq_along(self$id)) {
          input_entity <- client$get_input_entity(self$id[[i]])
          resolved_list[[i]] <- get_input_peer(input_entity)
        }
      }
      self$id <- resolved_list
      invisible(self)
    },

    #  @description Convert to list
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "GetPeerMaxIDsRequest",
        id = if (is.null(self$id)) list() else lapply(self$id, function(x) if (inherits(x, "TLObject") && is.function(x$to_list)) x$to_list() else x)
      )
    },

    #  @description Serialize to raw TL bytes
    # 
    #  @return raw
    to_bytes = function() {
      parts <- list()
      # constructor bytes little-endian for 0x535983c3 -> 0xc3 0x83 0x59 0x53
      parts[[1]] <- as.raw(c(0xc3, 0x83, 0x59, 0x53))

      # vector tag + length + objects
      vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
      parts[[length(parts) + 1]] <- vec_tag
      parts[[length(parts) + 1]] <- writeBin(as.integer(length(self$id)), raw(), size = 4, endian = "little")

      if (length(self$id) > 0) {
        for (elem in self$id) {
          if (is.function(elem$to_bytes)) {
            parts[[length(parts) + 1]] <- elem$to_bytes()
          } else if (is.function(elem$bytes)) {
            parts[[length(parts) + 1]] <- elem$bytes()
          } else if (is.function(elem$.bytes)) {
            parts[[length(parts) + 1]] <- elem$.bytes()
          } else {
            stop("id elements must provide to_bytes/bytes/_bytes method")
          }
        }
      }

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a GetPeerMaxIDsRequest instance from a reader
    # 
    #  reader expected to implement: tgread_object(), read_int()
    #  @param reader reader object
    #  @return GetPeerMaxIDsRequest
    from_reader = function(reader) {
      # read and ignore vector constructor id
      .vec_tag <- reader$read_int()
      n <- reader$read_int()
      if (n <= 0) {
        id_list <- list()
      } else {
        id_list <- vector("list", n)
        for (i in seq_len(n)) id_list[[i]] <- reader$tgread_object()
      }
      GetPeerMaxIDsRequest$new(id = id_list)
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


#  GetPeerStoriesRequest R6 class
# 
#  Request to get stories for a given peer. Returns stories.PeerStories.
#  @export
#  @noRd
#  @noRd
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


#  GetPinnedStoriesRequest R6 class
# 
#  Request to get pinned stories for a peer with pagination (offset_id, limit).
#  Returns stories.Stories.
#  @export
#  @noRd
#  @noRd
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


#  GetStoriesArchiveRequest R6 class
# 
#  Request to get archived stories for a peer with pagination (offset_id, limit).
#  Returns stories.Stories.
#  @export
#  @noRd
#  @noRd
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


#  GetStoriesByIDRequest R6 class
# 
#  Request to get stories by explicit ids for a given peer.
#  Returns stories.Stories.
#  @export
#  @noRd
#  @noRd
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


#  GetStoriesViewsRequest R6 class
# 
#  Request to get story views for a peer and a vector of story ids.
#  Returns stories.StoryViews.
#  @export
#  @noRd
#  @noRd
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


#  GetStoryReactionsListRequest R6 class
# 
#  Request to get a list of story reactions with optional filters.
#  Returns stories.StoryReactionsList.
#  @export
#  @noRd
#  @noRd
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


#  GetStoryViewsListRequest R6 class
# 
#  Request to get a list of story views with optional filters (just_contacts,
#  reactions_first, forwards_first, q). Returns a stories.StoryViewsList.
#  @export
#  @noRd
#  @noRd
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


#  IncrementStoryViewsRequest R6 class
# 
#  Request to increment story views for a peer and a vector of ids.
#  Returns Bool.
#  @export
#  @noRd
#  @noRd
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


#  ReadStoriesRequest R6 class
# 
#  Represents a TL request that reads stories up to a given max_id and
#  returns a Vector<int> result.
# 
#  @docType class
#  @name ReadStoriesRequest
#  @export
#  @noRd
#  @noRd
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


#  ReorderAlbumsRequest R6 class
# 
#  Represents a TL request to reorder albums for a peer; returns Bool.
# 
#  @docType class
#  @name ReorderAlbumsRequest
#  @export
#  @noRd
#  @noRd
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


#  ReportRequest R6 class
# 
#  Represents a TL request to report stories.
# 
#  @docType class
#  @name ReportRequest
#  @export
#  @noRd
#  @noRd
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


#  SearchPostsRequest R6 class
# 
#  Represents a TL request to search posts/stories (by hashtag/area/peer).
# 
#  @docType class
#  @name SearchPostsRequest
#  @export
#  @noRd
#  @noRd
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


#  SendReactionRequest R6 class
# 
#  Represents a TL request to send a reaction to a story.
# 
#  @docType class
#  @name SendReactionRequest
#  @export
#  @noRd
#  @noRd
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


#  SendStoryRequest R6 class
# 
#  Represents a TL request to send a story.
# 
#  @docType class
#  @name SendStoryRequest
#  @export
#  @noRd
#  @noRd
SendStoryRequest <- R6::R6Class(
  "SendStoryRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x737fc2ec,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @field peer Field.
    peer = NULL,
    #  @field media Field.
    media = NULL,
    #  @field privacy_rules Field.
    privacy_rules = NULL,
    #  @field pinned Field.
    pinned = NULL,
    #  @field noforwards Field.
    noforwards = NULL,
    #  @field fwd_modified Field.
    fwd_modified = NULL,
    #  @field media_areas Field.
    media_areas = NULL,
    #  @field caption Field.
    caption = NULL,
    #  @field entities Field.
    entities = NULL,
    #  @field random_id Field.
    random_id = NULL,
    #  @field period Field.
    period = NULL,
    #  @field fwd_from_id Field.
    fwd_from_id = NULL,
    #  @field fwd_from_story Field.
    fwd_from_story = NULL,
    #  @field albums Field.
    albums = NULL,

    #  @description Initialize SendStoryRequest
    # 
    #  @param peer TypeInputPeer
    #  @param media TypeInputMedia
    #  @param privacy_rules list
    #  @param pinned logical or NULL
    #  @param noforwards logical or NULL
    #  @param fwd_modified logical or NULL
    #  @param media_areas list or NULL
    #  @param caption character or NULL
    #  @param entities list or NULL
    #  @param random_id numeric/integer or NULL (auto-generated when NULL)
    #  @param period integer or NULL
    #  @param fwd_from_id TypeInputPeer or NULL
    #  @param fwd_from_story integer or NULL
    #  @param albums integer vector or NULL
    initialize = function(peer, media, privacy_rules, pinned = NULL, noforwards = NULL,
                          fwd_modified = NULL, media_areas = NULL, caption = NULL,
                          entities = NULL, random_id = NULL, period = NULL,
                          fwd_from_id = NULL, fwd_from_story = NULL, albums = NULL) {
      self$peer <- peer
      self$media <- media
      self$privacy_rules <- if (is.null(privacy_rules)) list() else privacy_rules
      self$pinned <- if (!is.null(pinned)) as.logical(pinned) else NULL
      self$noforwards <- if (!is.null(noforwards)) as.logical(noforwards) else NULL
      self$fwd_modified <- if (!is.null(fwd_modified)) as.logical(fwd_modified) else NULL
      self$media_areas <- if (!is.null(media_areas)) media_areas else NULL
      self$caption <- if (!is.null(caption)) as.character(caption) else NULL
      self$entities <- if (!is.null(entities)) entities else NULL

      # random_id: generate 8 random bytes -> signed 64-bit integer (readBin)
      if (is.null(random_id)) {
        rnd_raw <- as.raw(sample(0:255, 8, replace = TRUE))
        # read as signed 64-bit big-endian to mimic Python's int.from_bytes(..., 'big', signed=TRUE)
        random_val <- readBin(rnd_raw, "integer", size = 8, signed = TRUE, endian = "big")
        self$random_id <- random_val
      } else {
        self$random_id <- random_id
      }

      self$period <- if (!is.null(period)) as.integer(period) else NULL
      self$fwd_from_id <- if (!is.null(fwd_from_id)) fwd_from_id else NULL
      self$fwd_from_story <- if (!is.null(fwd_from_story)) as.integer(fwd_from_story) else NULL
      self$albums <- if (!is.null(albums)) as.integer(albums) else NULL
    },

    #  @description Resolve peer and forward references
    # 
    #  @param client client object with get_input_entity
    #  @param utils utils object with get_input_peer / get_input_media
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$peer)
      self$peer <- get_input_peer(input_entity)
      self$media <- get_input_media(self$media)
      if (!is.null(self$fwd_from_id)) {
        input_entity2 <- client$get_input_entity(self$fwd_from_id)
        self$fwd_from_id <- get_input_peer(input_entity2)
      }
      invisible(self)
    },

    #  @description Convert to list (similar to to_dict)
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "SendStoryRequest",
        peer = if (inherits(self$peer, "TLObject") && is.function(self$peer$to_list)) self$peer$to_list() else self$peer,
        media = if (inherits(self$media, "TLObject") && is.function(self$media$to_list)) self$media$to_list() else self$media,
        privacy_rules = if (is.null(self$privacy_rules)) list() else lapply(self$privacy_rules, function(x) if (inherits(x, "TLObject") && is.function(x$to_list)) x$to_list() else x),
        pinned = self$pinned,
        noforwards = self$noforwards,
        fwd_modified = self$fwd_modified,
        media_areas = if (is.null(self$media_areas)) list() else lapply(self$media_areas, function(x) if (inherits(x, "TLObject") && is.function(x$to_list)) x$to_list() else x),
        caption = self$caption,
        entities = if (is.null(self$entities)) list() else lapply(self$entities, function(x) if (inherits(x, "TLObject") && is.function(x$to_list)) x$to_list() else x),
        random_id = self$random_id,
        period = self$period,
        fwd_from_id = if (inherits(self$fwd_from_id, "TLObject") && is.function(self$fwd_from_id$to_list)) self$fwd_from_id$to_list() else self$fwd_from_id,
        fwd_from_story = self$fwd_from_story,
        albums = if (is.null(self$albums)) integer(0) else as.integer(self$albums)
      )
    },

    #  @description Serialize to raw bytes
    # 
    #  Produces a raw vector matching TL binary layout for this request.
    #  Expects helper serialization methods on peer/media/privacy_rules/media_areas/entities/fwd_from_id.
    # 
    #  @return raw
    to_bytes = function() {
      # compute flags as in original spec
      flags <- 0L
      if (!is.null(self$pinned) && isTRUE(self$pinned)) flags <- bitwOr(flags, 4L)
      if (!is.null(self$noforwards) && isTRUE(self$noforwards)) flags <- bitwOr(flags, 16L)
      if (!is.null(self$fwd_modified) && isTRUE(self$fwd_modified)) flags <- bitwOr(flags, 128L)
      if (!is.null(self$media_areas)) flags <- bitwOr(flags, 32L)
      if (!is.null(self$caption)) flags <- bitwOr(flags, 1L)
      if (!is.null(self$entities)) flags <- bitwOr(flags, 2L)
      if (!is.null(self$period)) flags <- bitwOr(flags, 8L)
      if (!is.null(self$fwd_from_id) || !is.null(self$fwd_from_story)) flags <- bitwOr(flags, 64L)
      if (!is.null(self$albums)) flags <- bitwOr(flags, 256L)

      parts <- list()
      # constructor bytes: b'\xec\xc2\x7fs'
      parts[[1]] <- as.raw(c(0xec, 0xc2, 0x7f, 0x73))
      # flags (uint32 little-endian)
      parts[[2]] <- writeBin(as.integer(flags), raw(), size = 4, endian = "little")

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

      # media bytes
      if (is.function(self$media$to_bytes)) {
        parts[[length(parts) + 1]] <- self$media$to_bytes()
      } else if (is.function(self$media$bytes)) {
        parts[[length(parts) + 1]] <- self$media$bytes()
      } else if (is.function(self$media$.bytes)) {
        parts[[length(parts) + 1]] <- self$media$.bytes()
      } else {
        stop("media object must provide a to_bytes/bytes/_bytes method")
      }

      # optional media_areas vector
      if (!is.null(self$media_areas)) {
        vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
        parts[[length(parts) + 1]] <- vec_tag
        parts[[length(parts) + 1]] <- writeBin(as.integer(length(self$media_areas)), raw(), size = 4, endian = "little")
        for (ma in self$media_areas) {
          if (is.function(ma$to_bytes)) {
            parts[[length(parts) + 1]] <- ma$to_bytes()
          } else if (is.function(ma$bytes)) {
            parts[[length(parts) + 1]] <- ma$bytes()
          } else if (is.function(ma$.bytes)) {
            parts[[length(parts) + 1]] <- ma$.bytes()
          } else {
            stop("media_area element must provide to_bytes/bytes/_bytes")
          }
        }
      }

      # caption
      if (!is.null(self$caption)) {
        # prefer serialize_bytes if available on TLRequest base class
        if (is.function(self$serialize_bytes)) {
          parts[[length(parts) + 1]] <- self$serialize_bytes(self$caption)
        } else {
          sraw <- charToRaw(enc2utf8(self$caption))
          # simple TL string encoding fallback (length as 1 byte if <254), minimal implementation
          parts[[length(parts) + 1]] <- writeBin(as.integer(length(sraw)), raw(), size = 1, endian = "little")
          parts[[length(parts) + 1]] <- sraw
        }
      }

      # entities vector
      if (!is.null(self$entities)) {
        vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
        parts[[length(parts) + 1]] <- vec_tag
        parts[[length(parts) + 1]] <- writeBin(as.integer(length(self$entities)), raw(), size = 4, endian = "little")
        for (ent in self$entities) {
          if (is.function(ent$to_bytes)) {
            parts[[length(parts) + 1]] <- ent$to_bytes()
          } else if (is.function(ent$bytes)) {
            parts[[length(parts) + 1]] <- ent$bytes()
          } else if (is.function(ent$.bytes)) {
            parts[[length(parts) + 1]] <- ent$.bytes()
          } else {
            stop("entity element must provide to_bytes/bytes/_bytes")
          }
        }
      }

      # privacy_rules vector (required)
      vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
      parts[[length(parts) + 1]] <- vec_tag
      parts[[length(parts) + 1]] <- writeBin(as.integer(length(self$privacy_rules)), raw(), size = 4, endian = "little")
      for (pr in self$privacy_rules) {
        if (is.function(pr$to_bytes)) {
          parts[[length(parts) + 1]] <- pr$to_bytes()
        } else if (is.function(pr$bytes)) {
          parts[[length(parts) + 1]] <- pr$bytes()
        } else if (is.function(pr$.bytes)) {
          parts[[length(parts) + 1]] <- pr$.bytes()
        } else {
          stop("privacy_rule element must provide to_bytes/bytes/_bytes")
        }
      }

      # random_id as 64-bit little-endian
      parts[[length(parts) + 1]] <- writeBin(as.numeric(self$random_id), raw(), size = 8, endian = "little")

      # period
      if (!is.null(self$period)) {
        parts[[length(parts) + 1]] <- writeBin(as.integer(self$period), raw(), size = 4, endian = "little")
      }

      # fwd_from_id
      if (!is.null(self$fwd_from_id)) {
        if (is.function(self$fwd_from_id$to_bytes)) {
          parts[[length(parts) + 1]] <- self$fwd_from_id$to_bytes()
        } else if (is.function(self$fwd_from_id$bytes)) {
          parts[[length(parts) + 1]] <- self$fwd_from_id$bytes()
        } else if (is.function(self$fwd_from_id$.bytes)) {
          parts[[length(parts) + 1]] <- self$fwd_from_id$.bytes()
        } else {
          stop("fwd_from_id must provide to_bytes/bytes/_bytes")
        }
      }

      # fwd_from_story
      if (!is.null(self$fwd_from_story)) {
        parts[[length(parts) + 1]] <- writeBin(as.integer(self$fwd_from_story), raw(), size = 4, endian = "little")
      }

      # albums vector
      if (!is.null(self$albums)) {
        vec_tag <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
        parts[[length(parts) + 1]] <- vec_tag
        parts[[length(parts) + 1]] <- writeBin(as.integer(length(self$albums)), raw(), size = 4, endian = "little")
        for (a in self$albums) parts[[length(parts) + 1]] <- writeBin(as.integer(a), raw(), size = 4, endian = "little")
      }

      do.call(c, parts)
    }
  ),
  class = list(
    #  @description Read a SendStoryRequest instance from a reader
    # 
    #  reader is expected to implement: read_int(), tgread_object(), tgread_string(), read_long()
    #  @param reader an object with read_int, tgread_object, tgread_string, read_long methods
    #  @return SendStoryRequest
    from_reader = function(reader) {
      flagsVal <- reader$read_int()
      pinnedVal <- bitwAnd(flagsVal, 4L) != 0L
      noforwardsVal <- bitwAnd(flagsVal, 16L) != 0L
      fwdModifiedVal <- bitwAnd(flagsVal, 128L) != 0L

      peerObj <- reader$tgread_object()
      mediaObj <- reader$tgread_object()

      # media_areas
      mediaAreasVal <- NULL
      if (bitwAnd(flagsVal, 32L) != 0L) {
        # vector constructor
        nma <- reader$read_int()
        if (nma > 0) {
          mediaAreasVal <- vector("list", nma)
          for (i in seq_len(nma)) mediaAreasVal[[i]] <- reader$tgread_object()
        } else {
          mediaAreasVal <- list()
        }
      }

      # caption
      captionVal <- if (bitwAnd(flagsVal, 1L) != 0L) reader$tgread_string() else NULL

      # entities
      entitiesVal <- NULL
      if (bitwAnd(flagsVal, 2L) != 0L) {
        ne <- reader$read_int()
        if (ne > 0) {
          entitiesVal <- vector("list", ne)
          for (i in seq_len(ne)) entitiesVal[[i]] <- reader$tgread_object()
        } else {
          entitiesVal <- list()
        }
      }

      # privacy_rules (vector)

      npr <- reader$read_int()
      privacyRulesVal <- list()
      if (npr > 0) {
        privacyRulesVal <- vector("list", npr)
        for (i in seq_len(npr)) privacyRulesVal[[i]] <- reader$tgread_object()
      }

      randomIdVal <- reader$read_long()

      periodVal <- if (bitwAnd(flagsVal, 8L) != 0L) reader$read_int() else NULL

      fwdFromIdVal <- if (bitwAnd(flagsVal, 64L) != 0L) reader$tgread_object() else NULL
      fwdFromStoryVal <- if (bitwAnd(flagsVal, 64L) != 0L) reader$read_int() else NULL

      albumsVal <- NULL
      if (bitwAnd(flagsVal, 256L) != 0L) {
        na <- reader$read_int()
        if (na > 0) {
          albumsVal <- integer(na)
          for (i in seq_len(na)) albumsVal[i] <- reader$read_int()
        } else {
          albumsVal <- integer(0)
        }
      }

      SendStoryRequest$new(
        peer = peerObj,
        media = mediaObj,
        privacy_rules = privacyRulesVal,
        pinned = if (bitwAnd(flagsVal, 4L) != 0L) pinnedVal else NULL,
        noforwards = if (bitwAnd(flagsVal, 16L) != 0L) noforwardsVal else NULL,
        fwd_modified = if (bitwAnd(flagsVal, 128L) != 0L) fwdModifiedVal else NULL,
        media_areas = mediaAreasVal,
        caption = captionVal,
        entities = entitiesVal,
        random_id = randomIdVal,
        period = periodVal,
        fwd_from_id = fwdFromIdVal,
        fwd_from_story = fwdFromStoryVal,
        albums = albumsVal
      )
    }
  )
)


#  ToggleAllStoriesHiddenRequest R6 class
# 
#  Represents a TL request to toggle the "all stories hidden" flag.
# 
#  @docType class
#  @name ToggleAllStoriesHiddenRequest
#  @export
#  @noRd
#  @noRd
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


#  TogglePeerStoriesHiddenRequest R6 class
# 
#  Represents a TL request to toggle hidden state for stories of a particular peer.
# 
#  @docType class
#  @name TogglePeerStoriesHiddenRequest
#  @export
#  @noRd
#  @noRd
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


#  TogglePinnedRequest R6 class
# 
#  Represents a TL request to toggle pinned state for stories.
# 
#  @docType class
#  @name TogglePinnedRequest
#  @export
#  @noRd
#  @noRd
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


#  TogglePinnedToTopRequest R6 class
# 
#  Represents a TL request to toggle pinned-to-top state for stories.
# 
#  @docType class
#  @name TogglePinnedToTopRequest
#  @export
#  @noRd
#  @noRd
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


#  UpdateAlbumRequest R6 class
# 
#  Represents a TL request to update a story album.
# 
#  @docType class
#  @name UpdateAlbumRequest
#  @export
#  @noRd
#  @noRd
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
