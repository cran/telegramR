#  ApplyBoostRequest R6 class
# 
#  Representation of the TL request "ApplyBoostRequest".
#  @title ApplyBoostRequest
#  @description Telegram API type ApplyBoostRequest
#  @export
#  @noRd
#  @noRd
ApplyBoostRequest <- R6::R6Class(
  "ApplyBoostRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor ID for the request
    CONSTRUCTOR_ID = 0x6b7da746,

    #  @field SUBCLASS_OF_ID Subclass ID for the request
    SUBCLASS_OF_ID = 0xad3512db,

    #  @field peer Input peer (object or identifier)
    peer = NULL,

    #  @field slots Integer vector of slots or NULL
    slots = NULL,

    #  @description Create a new ApplyBoostRequest
    #  @param peer input peer or identifier
    #  @param slots integer vector of slots or NULL
    #  @return self
    initialize = function(peer = NULL, slots = NULL) {
      self$peer <- peer
      if (!is.null(slots)) self$slots <- as.integer(slots) else self$slots <- NULL
      invisible(self)
    },

    #  @description Resolve peer using client/utils helpers
    #  @param client client object that provides get_input_entity
    #  @param utils utils object that provides get_input_peer
    #  @return self
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      invisible(self)
    },

    #  @description Convert request to list (dictionary)
    #  @return list
    to_list = function() {
      peer_val <- if (!is.null(self$peer) && inherits(self$peer, "TLObject")) self$peer$to_list() else self$peer
      slots_val <- if (is.null(self$slots)) NULL else as.integer(self$slots)
      list(
        `_` = "ApplyBoostRequest",
        peer = peer_val,
        slots = slots_val
      )
    },

    #  @description Serialize to raw bytes
    #  @return raw vector
    bytes = function() {
      # prefix b'F\xa7}k' -> 0x46 0xa7 0x7d 0x6b
      prefix <- as.raw(c(0x46, 0xa7, 0x7d, 0x6b))
      flags_val <- as.integer(!is.null(self$slots) && length(self$slots) > 0)
      flags_bytes <- serialize_int(flags_val)

      slots_bytes <- raw()
      if (!is.null(self$slots) && length(self$slots) > 0) {
        # vector constructor b'\x15\xc4\xb5\x1c' -> 0x15 0xc4 0xb5 0x1c
        vec_prefix <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
        len_bytes <- serialize_int(length(self$slots))
        items_bytes <- do.call(c, lapply(self$slots, function(x) serialize_int(as.integer(x))))
        slots_bytes <- c(vec_prefix, len_bytes, items_bytes)
      }

      peer_bytes <- if (!is.null(self$peer) && is.function(self$peer$bytes)) self$peer$bytes() else raw()
      c(prefix, flags_bytes, slots_bytes, peer_bytes)
    },

    #  @description Construct a new ApplyBoostRequest from a reader
    #  @param reader reader object exposing read_int / tgread_object
    #  @return ApplyBoostRequest
    from_reader = function(reader) {
      flags <- reader$read_int()
      slots_val <- NULL
      if (bitwAnd(flags, 1L) != 0L) {
        # read and ignore vector constructor id (expected 0x1cb5c415)
        reader$read_int()
        count <- reader$read_int()
        if (count > 0) {
          slots_vec <- integer(count)
          for (i in seq_len(count)) {
            slots_vec[i] <- reader$read_int()
          }
        } else {
          slots_vec <- integer(0)
        }
        slots_val <- slots_vec
      } else {
        slots_val <- NULL
      }
      peer_obj <- reader$tgread_object()
      ApplyBoostRequest$new(peer = peer_obj, slots = slots_val)
    }
  )
)


#  GetBoostsListRequest R6 class
# 
#  Representation of the TL request "GetBoostsListRequest"
#  @title GetBoostsListRequest
#  @description Telegram API type GetBoostsListRequest
#  @export
#  @noRd
#  @noRd
GetBoostsListRequest <- R6::R6Class(
  "GetBoostsListRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor ID for the request
    CONSTRUCTOR_ID = 0x60f67660,

    #  @field SUBCLASS_OF_ID Subclass ID for the request
    SUBCLASS_OF_ID = 0x2235a8bd,

    #  @field peer Input peer (object or identifier)
    peer = NULL,

    #  @field offset String offset
    offset = NULL,

    #  @field limit Integer limit
    limit = NULL,

    #  @field gifts Optional logical
    gifts = NULL,

    #  @description Create a new GetBoostsListRequest
    #  @param peer input peer or identifier
    #  @param offset string offset
    #  @param limit integer limit
    #  @param gifts optional logical
    #  @return self
    initialize = function(peer = NULL, offset = "", limit = 0L, gifts = NULL) {
      self$peer <- peer
      self$offset <- offset
      self$limit <- as.integer(limit)
      self$gifts <- if (!is.null(gifts)) as.logical(gifts) else NULL
      invisible(self)
    },

    #  @description Resolve peer using client/utils helpers
    #  @param client client object that provides get_input_entity
    #  @param utils utils object that provides get_input_peer
    #  @return self
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      invisible(self)
    },

    #  @description Convert request to list (dictionary)
    #  @return list
    to_list = function() {
      peer_val <- if (!is.null(self$peer) && inherits(self$peer, "TLObject")) self$peer$to_list() else self$peer
      list(
        `_` = "GetBoostsListRequest",
        peer = peer_val,
        offset = self$offset,
        limit = self$limit,
        gifts = self$gifts
      )
    },

    #  @description Serialize to raw bytes
    #  @return raw vector
    bytes = function() {
      # prefix b'`v\xf6`' -> 0x60 0x76 0xf6 0x60
      prefix <- as.raw(c(0x60, 0x76, 0xf6, 0x60))
      flags_val <- as.integer(!is.null(self$gifts) && isTRUE(self$gifts))
      flags_bytes <- serialize_int(flags_val)
      peer_bytes <- if (!is.null(self$peer) && is.function(self$peer$bytes)) self$peer$bytes() else raw()
      offset_bytes <- serialize_string(self$offset)
      limit_bytes <- serialize_int(self$limit)
      c(prefix, flags_bytes, peer_bytes, offset_bytes, limit_bytes)
    },

    #  @description Construct a new GetBoostsListRequest from a reader
    #  @param reader reader object exposing read_int / read_string / tgread_object
    #  @return GetBoostsListRequest
    from_reader = function(reader) {
      flags <- reader$read_int()
      gifts_val <- as.logical(bitwAnd(flags, 1L))
      peer_obj <- reader$tgread_object()
      offset_str <- reader$read_string()
      limit_int <- reader$read_int()
      GetBoostsListRequest$new(peer = peer_obj, offset = offset_str, limit = limit_int, gifts = gifts_val)
    }
  )
)


#  GetBoostsStatusRequest R6 class
# 
#  Representation of the TL request "GetBoostsStatusRequest".
#  @title GetBoostsStatusRequest
#  @description Telegram API type GetBoostsStatusRequest
#  @export
#  @noRd
#  @noRd
GetBoostsStatusRequest <- R6::R6Class(
  "GetBoostsStatusRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor ID for the request
    CONSTRUCTOR_ID = 0x061f2f04, # note: bytes b'a\x1f/\x04' -> 0x61 0x1f 0x2f 0x04, but integer shown here for reference

    #  @field SUBCLASS_OF_ID Subclass ID for the request
    SUBCLASS_OF_ID = 0xc31b1ab9,

    #  @field peer Input peer (object or identifier)
    peer = NULL,

    #  @description Create a new GetBoostsStatusRequest
    #  @param peer input peer or identifier
    #  @return self
    initialize = function(peer = NULL) {
      self$peer <- peer
      invisible(self)
    },

    #  @description Resolve peer using client/utils helpers
    #  @param client client object that provides get_input_entity
    #  @param utils utils object that provides get_input_peer
    #  @return self
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      invisible(self)
    },

    #  @description Convert request to list (dictionary)
    #  @return list
    to_list = function() {
      peer_val <- if (!is.null(self$peer) && inherits(self$peer, "TLObject")) self$peer$to_list() else self$peer
      list(
        `_` = "GetBoostsStatusRequest",
        peer = peer_val
      )
    },

    #  @description Serialize to raw bytes
    #  @return raw vector
    bytes = function() {
      # prefix b'a\x1f/\x04' -> 0x61 0x1f 0x2f 0x04
      prefix <- as.raw(c(0x61, 0x1f, 0x2f, 0x04))
      peer_bytes <- if (!is.null(self$peer) && is.function(self$peer$bytes)) self$peer$bytes() else raw()
      c(prefix, peer_bytes)
    },

    #  @description Construct a new GetBoostsStatusRequest from a reader
    #  @param reader reader object exposing tgread_object()
    #  @return GetBoostsStatusRequest
    from_reader = function(reader) {
      peer_obj <- reader$tgread_object()
      GetBoostsStatusRequest$new(peer = peer_obj)
    }
  )
)

#  GetMyBoostsRequest R6 class
# 
#  Representation of the TL request "GetMyBoostsRequest".
#  @title GetMyBoostsRequest
#  @description Telegram API type GetMyBoostsRequest
#  @export
#  @noRd
#  @noRd
GetMyBoostsRequest <- R6::R6Class(
  "GetMyBoostsRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor ID for the request
    CONSTRUCTOR_ID = 0xbe77b4a,

    #  @field SUBCLASS_OF_ID Subclass ID for the request
    SUBCLASS_OF_ID = 0xad3512db,

    #  @description Create a new GetMyBoostsRequest
    #  @return self
    initialize = function() {
      invisible(self)
    },

    #  @description Convert request to a list (dictionary)
    #  @return list
    to_list = function() {
      list(`_` = "GetMyBoostsRequest")
    },

    #  @description Serialize to raw bytes
    #  @return raw vector
    bytes = function() {
      # b'J{\xe7\x0b' -> 0x4a 0x7b 0xe7 0x0b
      as.raw(c(0x4a, 0x7b, 0xe7, 0x0b))
    },

    #  Read object from reader and return new instance
    #  @param reader an object exposing tgread_object / read_int / read_string as in the surrounding codebase
    #  @return GetMyBoostsRequest
    from_reader = function(reader) {
      # This request has no payload; return a new instance
      GetMyBoostsRequest$new()
    }
  )
)


#  GetUserBoostsRequest R6 class
# 
#  Representation of the TL request "GetUserBoostsRequest".
#  @title GetUserBoostsRequest
#  @description Telegram API type GetUserBoostsRequest
#  @export
#  @noRd
#  @noRd
GetUserBoostsRequest <- R6::R6Class(
  "GetUserBoostsRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor ID for the request
    CONSTRUCTOR_ID = 0x39854d1f,

    #  @field SUBCLASS_OF_ID Subclass ID for the request
    SUBCLASS_OF_ID = 0x2235a8bd,

    #  @field peer Input peer (object or identifier)
    peer = NULL,

    #  @field user_id Input user (object or identifier)
    user_id = NULL,

    #  @description Initialize GetUserBoostsRequest
    #  @param peer input peer or identifier
    #  @param user_id input user or identifier
    #  @return self
    initialize = function(peer = NULL, user_id = NULL) {
      self$peer <- peer
      self$user_id <- user_id
      invisible(self)
    },

    #  @description Resolve peer and user_id using client/utils helpers
    #  @param client client object that provides get_input_entity
    #  @param utils utils object that provides get_input_peer and get_input_user
    #  @return self
    resolve = function(client, utils) {
      # expected to be synchronous wrappers in this R environment
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      self$user_id <- utils$get_input_user(client$get_input_entity(self$user_id))
      invisible(self)
    },

    #  @description Convert request to list (dictionary)
    #  @return list
    to_list = function() {
      peer_val <- if (!is.null(self$peer) && inherits(self$peer, "TLObject")) self$peer$to_list() else self$peer
      user_val <- if (!is.null(self$user_id) && inherits(self$user_id, "TLObject")) self$user_id$to_list() else self$user_id
      list(
        `_` = "GetUserBoostsRequest",
        peer = peer_val,
        user_id = user_val
      )
    },

    #  @description Serialize to raw bytes
    #  @return raw vector
    bytes = function() {
      # prefix b'\x1fM\x859' -> 0x1f 0x4d 0x85 0x39
      prefix <- as.raw(c(0x1f, 0x4d, 0x85, 0x39))
      peer_bytes <- if (!is.null(self$peer) && is.function(self$peer$bytes)) self$peer$bytes() else raw()
      user_bytes <- if (!is.null(self$user_id) && is.function(self$user_id$bytes)) self$user_id$bytes() else raw()
      c(prefix, peer_bytes, user_bytes)
    },

    #  @description Construct a new GetUserBoostsRequest from a reader
    #  @param reader reader object exposing tgread_object()
    #  @return GetUserBoostsRequest
    from_reader = function(reader) {
      peer_obj <- reader$tgread_object()
      user_obj <- reader$tgread_object()
      GetUserBoostsRequest$new(peer = peer_obj, user_id = user_obj)
    }
  )
)
