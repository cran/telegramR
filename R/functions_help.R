#  AcceptTermsOfServiceRequest R6 class
# 
#  Accept terms of service (help.TermsOfService). Serializes a DataJSON id.
# 
#  @title AcceptTermsOfServiceRequest
#  @description Telegram API type AcceptTermsOfServiceRequest
#  @export
#  @noRd
#  @noRd
AcceptTermsOfServiceRequest <- R6::R6Class(
  "AcceptTermsOfServiceRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0xee72f79a),
    SUBCLASS_OF_ID = as.numeric(0xf5b399ac),
    #  @field id Field.
    id = NULL,

    #  @description Initialize AcceptTermsOfServiceRequest
    #  @param id TLObject-like or raw
    initialize = function(id = NULL) {
      self$id <- id
    },

    #  Convert to list
    #  @return list with `_` discriminator and id as list (if possible)
    to_list = function() {
      list(
        `_` = "AcceptTermsOfServiceRequest",
        id = if (is.null(self$id)) {
          NULL
        } else {
          if (is.environment(self$id) && !is.null(self$id$to_list)) self$id$to_list() else self$id
        }
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      parts <- list()
      parts[[1]] <- packInt32(self$CONSTRUCTOR_ID)
      if (is.raw(self$id)) {
        parts[[2]] <- self$id
      } else if (is.environment(self$id) && !is.null(self$id$to_bytes)) {
        parts[[2]] <- self$id$to_bytes()
      } else {
        stop("id must be a raw vector or provide to_bytes()")
      }
      do.call(c, parts)
    }
  ),
  private = list()
)

# Create AcceptTermsOfServiceRequest from a reader
# @name AcceptTermsOfServiceRequest_from_reader
#
# @param reader object providing `tgread_object()` method
# @return instance of AcceptTermsOfServiceRequest
# @export
AcceptTermsOfServiceRequest$from_reader <- function(reader) {
  idVal <- reader$tgread_object()
  AcceptTermsOfServiceRequest$new(id = idVal)
}


#  DismissSuggestionRequest R6 class
# 
#  Dismiss a suggestion for a peer with an associated suggestion string.
# 
#  @title DismissSuggestionRequest
#  @description Telegram API type DismissSuggestionRequest
#  @export
#  @noRd
#  @noRd
DismissSuggestionRequest <- R6::R6Class(
  "DismissSuggestionRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0xf50dbaa1),
    SUBCLASS_OF_ID = as.numeric(0xf5b399ac),
    #  @field peer Field.
    peer = NULL,
    #  @field suggestion Field.
    suggestion = "",

    #  @description Initialize DismissSuggestionRequest
    #  @param peer TLObject-like or raw
    #  @param suggestion character
    initialize = function(peer = NULL, suggestion = "") {
      self$peer <- peer
      self$suggestion <- as.character(suggestion)
    },

    #  Resolve peer using client and utils
    #  @param client client object providing get_input_entity()
    #  @param utils utils providing get_input_peer()
    resolve = function(client, utils) {
      # replace peer with resolved input peer if helpers are provided
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  Convert to list
    #  @return list with `_` discriminator, peer and suggestion
    to_list = function() {
      list(
        `_` = "DismissSuggestionRequest",
        peer = if (is.null(self$peer)) {
          NULL
        } else {
          if (is.environment(self$peer) && !is.null(self$peer$to_list)) self$peer$to_list() else self$peer
        },
        suggestion = self$suggestion
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      parts <- list()
      parts[[1]] <- packInt32(self$CONSTRUCTOR_ID)
      # peer must provide to_bytes() or already be a raw vector
      if (is.raw(self$peer)) {
        parts[[2]] <- self$peer
      } else if (is.environment(self$peer) && !is.null(self$peer$to_bytes)) {
        parts[[2]] <- self$peer$to_bytes()
      } else {
        stop("peer must be a raw vector or provide to_bytes()")
      }
      # serialize suggestion string using Telegram string scheme
      strRaw <- charToRaw(self$suggestion)
      strLen <- length(strRaw)
      if (strLen < 254) {
        parts[[3]] <- as.raw(strLen)
        parts[[4]] <- strRaw
        pad <- (4 - ((1 + strLen) %% 4)) %% 4
        if (pad > 0) parts[[5]] <- as.raw(rep(0, pad))
      } else {
        parts[[3]] <- as.raw(254)
        parts[[4]] <- writeBin(as.integer(strLen), raw(), size = 4, endian = "little")
        parts[[5]] <- strRaw
        pad <- (4 - (strLen %% 4)) %% 4
        if (pad > 0) parts[[6]] <- as.raw(rep(0, pad))
      }
      do.call(c, parts)
    }
  ),
  private = list()
)

# Create DismissSuggestionRequest from a reader
# @name DismissSuggestionRequest_from_reader
#
# @param reader object providing `tgread_object()` and `tgread_string()` methods
# @return instance of DismissSuggestionRequest
# @export
DismissSuggestionRequest$from_reader <- function(reader) {
  peerVal <- reader$tgread_object()
  suggestionVal <- reader$tgread_string()
  DismissSuggestionRequest$new(peer = peerVal, suggestion = suggestionVal)
}


#  EditUserInfoRequest R6 class
# 
#  Edit user info (help.UserInfo). Serializes an input user, a message and a list
#  of message entities.
# 
#  @title EditUserInfoRequest
#  @description Telegram API type EditUserInfoRequest
#  @export
#  @noRd
#  @noRd
EditUserInfoRequest <- R6::R6Class(
  "EditUserInfoRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0x66b91b70),
    SUBCLASS_OF_ID = as.numeric(0x5c53d7d8),
    #  @field userId Field.
    userId = NULL,
    #  @field message Field.
    message = "",
    entities = list(),

    #  @description Initialize EditUserInfoRequest
    #  @param userId TLObject-like or raw
    #  @param message character
    #  @param entities list of TLObject-like entities
    initialize = function(userId = NULL, message = "", entities = list()) {
      self$userId <- userId
      self$message <- as.character(message)
      if (is.null(entities)) {
        self$entities <- list()
      } else {
        self$entities <- entities
      }
    },

    #  Resolve userId using client and utils
    #  @param client client object providing get_input_entity()
    #  @param utils utils providing get_input_user()
    resolve = function(client, utils) {
      # replace userId with resolved input user if helpers are provided
      self$userId <- utils$get_input_user(client$get_input_entity(self$userId))
    },

    #  Convert to list
    #  @return list with `_` discriminator, user_id, message and entities as lists (if possible)
    to_list = function() {
      list(
        `_` = "EditUserInfoRequest",
        user_id = if (is.null(self$userId)) {
          NULL
        } else {
          if (is.environment(self$userId) && !is.null(self$userId$to_list)) self$userId$to_list() else self$userId
        },
        message = self$message,
        entities = if (is.null(self$entities)) {
          list()
        } else {
          lapply(self$entities, function(x) {
            if (is.environment(x) && !is.null(x$to_list)) x$to_list() else x
          })
        }
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      parts <- list()
      parts[[1]] <- packInt32(self$CONSTRUCTOR_ID)
      # userId must provide to_bytes() or already be a raw vector
      if (is.raw(self$userId)) {
        parts[[2]] <- self$userId
      } else if (is.environment(self$userId) && !is.null(self$userId$to_bytes)) {
        parts[[2]] <- self$userId$to_bytes()
      } else {
        stop("userId must be a raw vector or provide to_bytes()")
      }
      # serialize message string using Telegram string scheme
      strRaw <- charToRaw(self$message)
      strLen <- length(strRaw)
      if (strLen < 254) {
        parts[[3]] <- as.raw(strLen)
        parts[[4]] <- strRaw
        pad <- (4 - ((1 + strLen) %% 4)) %% 4
        if (pad > 0) parts[[5]] <- as.raw(rep(0, pad))
      } else {
        parts[[3]] <- as.raw(254)
        parts[[4]] <- writeBin(as.integer(strLen), raw(), size = 4, endian = "little")
        parts[[5]] <- strRaw
        pad <- (4 - (strLen %% 4)) %% 4
        if (pad > 0) parts[[6]] <- as.raw(rep(0, pad))
      }
      # vector constructor for entities
      vecIndex <- length(parts) + 1
      parts[[vecIndex]] <- as.raw(c(0x15, 0xC4, 0xB5, 0x1C))
      # length of entities
      parts[[vecIndex + 1]] <- writeBin(as.integer(length(self$entities)), raw(), size = 4, endian = "little")
      # each entity is expected to provide a to_bytes() method or already be a raw vector
      if (length(self$entities) > 0) {
        entityBytes <- lapply(self$entities, function(ev) {
          if (is.raw(ev)) {
            return(ev)
          }
          if (is.environment(ev) && !is.null(ev$to_bytes)) {
            return(ev$to_bytes())
          }
          stop("Each entity must be a raw vector or provide to_bytes()")
        })
        parts[[vecIndex + 2]] <- do.call(c, entityBytes)
      }
      do.call(c, parts)
    }
  ),
  private = list()
)

# Create EditUserInfoRequest from a reader
# @name EditUserInfoRequest_from_reader
#
# @param reader object providing `tgread_object()`, `tgread_string()` and `read_int()` methods
# @return instance of EditUserInfoRequest
# @export
EditUserInfoRequest$from_reader <- function(reader) {
  userObj <- reader$tgread_object()
  messageVal <- reader$tgread_string()
  # discard vector constructor int (if present) and read count
  reader$read_int()
  countVal <- reader$read_int()
  entitiesList <- vector("list", countVal)
  for (i in seq_len(countVal)) {
    entitiesList[[i]] <- reader$tgread_object()
  }
  EditUserInfoRequest$new(userId = userObj, message = messageVal, entities = entitiesList)
}


#  GetAppConfigRequest R6 class
# 
#  Request to get app configuration (possibly not modified).
# 
#  @title GetAppConfigRequest
#  @description Telegram API type GetAppConfigRequest
#  @export
#  @noRd
#  @noRd
GetAppConfigRequest <- R6::R6Class(
  "GetAppConfigRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0x61e3f854),
    SUBCLASS_OF_ID = as.numeric(0x14381c9a),
    hash = 0L,

    #  @description Initialize GetAppConfigRequest
    #  @param hash integer
    initialize = function(hash = 0L) {
      self$hash <- as.integer(hash)
    },

    #  Convert to list
    #  @return list with `_` discriminator and hash
    to_list = function() {
      list(
        `_` = "GetAppConfigRequest",
        hash = self$hash
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      parts <- list()
      parts[[1]] <- packInt32(self$CONSTRUCTOR_ID)
      parts[[2]] <- writeBin(as.integer(self$hash), raw(), size = 4, endian = "little")
      do.call(c, parts)
    }
  ),
  private = list()
)

# Create GetAppConfigRequest from a reader
# @name GetAppConfigRequest_from_reader
#
# @param reader object providing `read_int()` method
# @return instance of GetAppConfigRequest
# @export
GetAppConfigRequest$from_reader <- function(reader) {
  hashVal <- reader$read_int()
  GetAppConfigRequest$new(hash = hashVal)
}


#  GetAppUpdateRequest R6 class
# 
#  Request to get app update info.
# 
#  @title GetAppUpdateRequest
#  @description Telegram API type GetAppUpdateRequest
#  @export
#  @noRd
#  @noRd
GetAppUpdateRequest <- R6::R6Class(
  "GetAppUpdateRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0x522d5a7d),
    SUBCLASS_OF_ID = as.numeric(0x5897069e),
    #  @field source Field.
    source = "",

    #  @description Initialize GetAppUpdateRequest
    #  @param source character
    initialize = function(source = "") {
      self$source <- as.character(source)
    },

    #  Convert to list
    #  @return list with `_` discriminator and source
    to_list = function() {
      list(
        `_` = "GetAppUpdateRequest",
        source = self$source
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      parts <- list()
      parts[[1]] <- packInt32(self$CONSTRUCTOR_ID)
      # serialize source string using Telegram string scheme
      strRaw <- charToRaw(self$source)
      strLen <- length(strRaw)
      if (strLen < 254) {
        parts[[2]] <- as.raw(strLen)
        parts[[3]] <- strRaw
        pad <- (4 - ((1 + strLen) %% 4)) %% 4
        if (pad > 0) parts[[4]] <- as.raw(rep(0, pad))
      } else {
        parts[[2]] <- as.raw(254)
        parts[[3]] <- writeBin(as.integer(strLen), raw(), size = 4, endian = "little")
        parts[[4]] <- strRaw
        pad <- (4 - (strLen %% 4)) %% 4
        if (pad > 0) parts[[5]] <- as.raw(rep(0, pad))
      }
      do.call(c, parts)
    }
  ),
  private = list()
)

# Create GetAppUpdateRequest from a reader
# @name GetAppUpdateRequest_from_reader
#
# @param reader object providing `tgread_string()` method
# @return instance of GetAppUpdateRequest
# @export
GetAppUpdateRequest$from_reader <- function(reader) {
  sourceVal <- reader$tgread_string()
  GetAppUpdateRequest$new(source = sourceVal)
}


#  GetCdnConfigRequest R6 class
# 
#  Request to get CDN configuration.
# 
#  @title GetCdnConfigRequest
#  @description Telegram API type GetCdnConfigRequest
#  @export
#  @noRd
#  @noRd
GetCdnConfigRequest <- R6::R6Class(
  "GetCdnConfigRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0x52029342),
    SUBCLASS_OF_ID = as.numeric(0xecda397c),

    #  @description Initialize GetCdnConfigRequest
    #  @return invisible NULL
    initialize = function() {
      invisible(NULL)
    },

    #  Convert to list
    #  @return list with `_` discriminator
    to_list = function() {
      list(
        `_` = "GetCdnConfigRequest"
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      packInt32(self$CONSTRUCTOR_ID)
    }
  ),
  private = list()
)

# Create GetCdnConfigRequest from a reader
# @name GetCdnConfigRequest_from_reader
#
# @param reader reader (not used)
# @return instance of GetCdnConfigRequest
# @export
GetCdnConfigRequest$from_reader <- function(reader) {
  GetCdnConfigRequest$new()
}


#  GetConfigRequest R6 class
# 
#  Request to get configuration.
# 
#  @title GetConfigRequest
#  @description Telegram API type GetConfigRequest
#  @export
#  @noRd
#  @noRd
GetConfigRequest <- R6::R6Class(
  "GetConfigRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0xc4f9186b),
    SUBCLASS_OF_ID = as.numeric(0xd3262a4a),

    #  @description Initialize GetConfigRequest
    #  @return invisible NULL
    initialize = function() {
      invisible(NULL)
    },

    #  Convert to list
    #  @return list with type discriminator
    to_list = function() {
      list(
        `_` = "GetConfigRequest"
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      # constructor id (little-endian 4 bytes)
      packInt32(self$CONSTRUCTOR_ID)
    }
  ),
  private = list()
)

# Create GetConfigRequest from a reader
# @name GetConfigRequest_from_reader
#
# @param reader object providing reader methods (not used here)
# @return instance of GetConfigRequest
# @export
GetConfigRequest$from_reader <- function(reader) {
  GetConfigRequest$new()
}


#  GetCountriesListRequest R6 class
# 
#  Request to get the list of countries (possibly not modified).
# 
#  @title GetCountriesListRequest
#  @description Telegram API type GetCountriesListRequest
#  @export
#  @noRd
#  @noRd
GetCountriesListRequest <- R6::R6Class(
  "GetCountriesListRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0x735787a8),
    SUBCLASS_OF_ID = as.numeric(0xea31fe88),
    #  @field langCode Field.
    langCode = "",
    hash = 0L,

    #  @description Initialize GetCountriesListRequest
    #  @param langCode character
    #  @param hash integer
    initialize = function(langCode = "", hash = 0L) {
      self$langCode <- as.character(langCode)
      self$hash <- as.integer(hash)
    },

    #  Convert to list
    #  @return list with `_` discriminator, lang_code and hash
    to_list = function() {
      list(
        `_` = "GetCountriesListRequest",
        lang_code = self$langCode,
        hash = self$hash
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      parts <- list()
      parts[[1]] <- packInt32(self$CONSTRUCTOR_ID)
      # serialize langCode string using Telegram string scheme
      strRaw <- charToRaw(self$langCode)
      strLen <- length(strRaw)
      if (strLen < 254) {
        parts[[2]] <- as.raw(strLen)
        parts[[3]] <- strRaw
        pad <- (4 - ((1 + strLen) %% 4)) %% 4
        if (pad > 0) parts[[4]] <- as.raw(rep(0, pad))
      } else {
        parts[[2]] <- as.raw(254)
        parts[[3]] <- writeBin(as.integer(strLen), raw(), size = 4, endian = "little")
        parts[[4]] <- strRaw
        pad <- (4 - (strLen %% 4)) %% 4
        if (pad > 0) parts[[5]] <- as.raw(rep(0, pad))
      }
      # append hash (little-endian 4 bytes)
      parts[[length(parts) + 1]] <- writeBin(as.integer(self$hash), raw(), size = 4, endian = "little")
      do.call(c, parts)
    }
  ),
  private = list()
)

# Create GetCountriesListRequest from a reader
# @name GetCountriesListRequest_from_reader
#
# @param reader object providing tgread_string() and read_int() methods
# @return instance of GetCountriesListRequest
# @export
GetCountriesListRequest$from_reader <- function(reader) {
  langVal <- reader$tgread_string()
  hashVal <- reader$read_int()
  GetCountriesListRequest$new(langCode = langVal, hash = hashVal)
}


#  GetDeepLinkInfoRequest R6 class
# 
#  Request to get deep link info.
# 
#  @title GetDeepLinkInfoRequest
#  @description Telegram API type GetDeepLinkInfoRequest
#  @export
#  @noRd
#  @noRd
GetDeepLinkInfoRequest <- R6::R6Class(
  "GetDeepLinkInfoRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0x3fedc75f),
    SUBCLASS_OF_ID = as.numeric(0x984aac38),
    #  @field path Field.
    path = "",

    #  @description Initialize GetDeepLinkInfoRequest
    #  @param path character
    initialize = function(path = "") {
      self$path <- as.character(path)
    },

    #  Convert to list
    #  @return list with `_` discriminator and path
    to_list = function() {
      list(
        `_` = "GetDeepLinkInfoRequest",
        path = self$path
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      parts <- list()
      parts[[1]] <- packInt32(self$CONSTRUCTOR_ID)
      # serialize path string using Telegram string scheme
      strRaw <- charToRaw(self$path)
      strLen <- length(strRaw)
      if (strLen < 254) {
        parts[[2]] <- as.raw(strLen)
        parts[[3]] <- strRaw
        pad <- (4 - ((1 + strLen) %% 4)) %% 4
        if (pad > 0) parts[[4]] <- as.raw(rep(0, pad))
      } else {
        parts[[2]] <- as.raw(254)
        parts[[3]] <- writeBin(as.integer(strLen), raw(), size = 4, endian = "little")
        parts[[4]] <- strRaw
        pad <- (4 - (strLen %% 4)) %% 4
        if (pad > 0) parts[[5]] <- as.raw(rep(0, pad))
      }
      do.call(c, parts)
    }
  ),
  private = list()
)

# Create GetDeepLinkInfoRequest from a reader
# @name GetDeepLinkInfoRequest_from_reader
#
# @param reader object providing tgread_string() method
# @return instance of GetDeepLinkInfoRequest
# @export
GetDeepLinkInfoRequest$from_reader <- function(reader) {
  pathVal <- reader$tgread_string()
  GetDeepLinkInfoRequest$new(path = pathVal)
}


#  GetInviteTextRequest R6 class
# 
#  Request to get invite text.
# 
#  @title GetInviteTextRequest
#  @description Telegram API type GetInviteTextRequest
#  @export
#  @noRd
#  @noRd
GetInviteTextRequest <- R6::R6Class(
  "GetInviteTextRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0x4d392343),
    SUBCLASS_OF_ID = as.numeric(0xcf70aa35),

    #  @description Initialize GetInviteTextRequest
    #  @return invisible NULL
    initialize = function() {
      invisible(NULL)
    },

    #  Convert to list
    #  @return list with type discriminator
    to_list = function() {
      list(
        #  @field type Field.
        type = "GetInviteTextRequest"
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      packInt32(self$CONSTRUCTOR_ID)
    }
  ),
  private = list()
)

# Create GetInviteTextRequest from a reader
# @name GetInviteTextRequest_from_reader
#
# @param reader object providing reader methods (not used here)
# @return instance of GetInviteTextRequest
# @export
GetInviteTextRequest$from_reader <- function(reader) {
  GetInviteTextRequest$new()
}


#  GetNearestDcRequest R6 class
# 
#  Request to get the nearest data-center info.
# 
#  @title GetNearestDcRequest
#  @description Telegram API type GetNearestDcRequest
#  @export
#  @noRd
#  @noRd
GetNearestDcRequest <- R6::R6Class(
  "GetNearestDcRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0x1fb33026),
    SUBCLASS_OF_ID = as.numeric(0x3877045f),

    #  @description Initialize GetNearestDcRequest
    #  @return invisible NULL
    initialize = function() {
      invisible(NULL)
    },

    #  Convert to list
    #  @return list with type discriminator
    to_list = function() {
      list(
        #  @field type Field.
        type = "GetNearestDcRequest"
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      packInt32(self$CONSTRUCTOR_ID)
    }
  ),
  private = list()
)

# Create GetNearestDcRequest from a reader
# @name GetNearestDcRequest_from_reader
#
# @param reader object providing reader methods (not used here)
# @return instance of GetNearestDcRequest
GetNearestDcRequest$from_reader <- function(reader) {
  GetNearestDcRequest$new()
}


#  GetPassportConfigRequest R6 class
# 
#  Request to get passport configuration (possibly not modified).
# 
#  @title GetPassportConfigRequest
#  @description Telegram API type GetPassportConfigRequest
#  @export
#  @noRd
#  @noRd
GetPassportConfigRequest <- R6::R6Class(
  "GetPassportConfigRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0xc661ad08),
    SUBCLASS_OF_ID = as.numeric(0xc666c0ad),
    hash = 0L,

    #  @description Initialize GetPassportConfigRequest
    #  @param hash integer
    initialize = function(hash = 0L) {
      self$hash <- as.integer(hash)
    },

    #  Convert to list
    #  @return list with type discriminator and hash
    to_list = function() {
      list(
        #  @field type Field.
        type = "GetPassportConfigRequest",
        hash = self$hash
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      parts <- list()
      parts[[1]] <- packInt32(self$CONSTRUCTOR_ID)
      parts[[2]] <- writeBin(as.integer(self$hash), raw(), size = 4, endian = "little")
      do.call(c, parts)
    }
  ),
  private = list()
)

# Create GetPassportConfigRequest from a reader
# @name GetPassportConfigRequest_from_reader
#
# @param reader object providing `read_int()` method
# @return instance of GetPassportConfigRequest
# @export
GetPassportConfigRequest$from_reader <- function(reader) {
  hashVal <- reader$read_int()
  GetPassportConfigRequest$new(hash = hashVal)
}


#  GetPeerColorsRequest R6 class
# 
#  Request to get peer colors (possibly not modified).
# 
#  @title GetPeerColorsRequest
#  @description Telegram API type GetPeerColorsRequest
#  @export
#  @noRd
#  @noRd
GetPeerColorsRequest <- R6::R6Class(
  "GetPeerColorsRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0xda80f42f),
    SUBCLASS_OF_ID = as.numeric(0x0e3f6733),
    hash = 0L,

    #  @description Initialize GetPeerColorsRequest
    #  @param hash integer
    initialize = function(hash = 0L) {
      self$hash <- as.integer(hash)
    },

    #  Convert to list
    #  @return list with `type` discriminator and hash
    to_list = function() {
      list(
        #  @field type Field.
        type = "GetPeerColorsRequest",
        hash = self$hash
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      parts <- list()
      parts[[1]] <- packInt32(self$CONSTRUCTOR_ID)
      parts[[2]] <- writeBin(as.integer(self$hash), raw(), size = 4, endian = "little")
      do.call(c, parts)
    }
  ),
  private = list()
)

# Create GetPeerColorsRequest from a reader
# @name GetPeerColorsRequest_from_reader
#
# @param reader object providing `read_int()` method
# @return instance of GetPeerColorsRequest
GetPeerColorsRequest$from_reader <- function(reader) {
  hashVal <- reader$read_int()
  GetPeerColorsRequest$new(hash = hashVal)
}


#  GetPeerProfileColorsRequest R6 class
# 
#  Request to get peer profile colors (possibly not modified).
# 
#  @title GetPeerProfileColorsRequest
#  @description Telegram API type GetPeerProfileColorsRequest
#  @export
#  @noRd
#  @noRd
GetPeerProfileColorsRequest <- R6::R6Class(
  "GetPeerProfileColorsRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0xabcfa9fd),
    SUBCLASS_OF_ID = as.numeric(0x0e3f6733),
    hash = 0L,

    #  @description Initialize GetPeerProfileColorsRequest
    #  @param hash integer
    initialize = function(hash = 0L) {
      self$hash <- as.integer(hash)
    },

    #  Convert to list
    #  @return list with `type` discriminator and hash
    to_list = function() {
      list(
        #  @field type Field.
        type = "GetPeerProfileColorsRequest",
        hash = self$hash
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      parts <- list()
      parts[[1]] <- packInt32(self$CONSTRUCTOR_ID)
      parts[[2]] <- writeBin(as.integer(self$hash), raw(), size = 4, endian = "little")
      do.call(c, parts)
    }
  ),
  private = list()
)

# Create GetPeerProfileColorsRequest from a reader
# @name GetPeerProfileColorsRequest_from_reader
#
# @param reader object providing `read_int()` method
# @return instance of GetPeerProfileColorsRequest
GetPeerProfileColorsRequest$from_reader <- function(reader) {
  hashVal <- reader$read_int()
  GetPeerProfileColorsRequest$new(hash = hashVal)
}


#  GetPremiumPromoRequest R6 class
# 
#  Request to get premium promotion info.
# 
#  @title GetPremiumPromoRequest
#  @description Telegram API type GetPremiumPromoRequest
#  @export
#  @noRd
#  @noRd
GetPremiumPromoRequest <- R6::R6Class(
  "GetPremiumPromoRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0xb81b93d4),
    SUBCLASS_OF_ID = as.numeric(0xc987a338),

    #  @description Initialize GetPremiumPromoRequest
    #  @return invisible NULL
    initialize = function() {
      invisible(NULL)
    },

    #  Convert to list
    #  @return list with type discriminator
    to_list = function() {
      list(
        #  @field type Field.
        type = "GetPremiumPromoRequest"
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      packInt32(self$CONSTRUCTOR_ID)
    }
  ),
  private = list()
)

# Create GetPremiumPromoRequest from a reader
# @name GetPremiumPromoRequest_from_reader
#
# @param reader object providing reader methods (not used here)
# @return instance of GetPremiumPromoRequest
# @export
GetPremiumPromoRequest$from_reader <- function(reader) {
  GetPremiumPromoRequest$new()
}


#  GetPromoDataRequest R6 class
# 
#  Request to get promo data.
# 
#  @title GetPromoDataRequest
#  @description Telegram API type GetPromoDataRequest
#  @export
#  @noRd
#  @noRd
GetPromoDataRequest <- R6::R6Class(
  "GetPromoDataRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0xc0977421),
    SUBCLASS_OF_ID = as.numeric(0x9d595542),

    #  @description Initialize GetPromoDataRequest
    #  @return invisible NULL
    initialize = function() {
      invisible(NULL)
    },

    #  Convert to list
    #  @return list with type discriminator
    to_list = function() {
      list(
        #  @field type Field.
        type = "GetPromoDataRequest"
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      packInt32(self$CONSTRUCTOR_ID)
    }
  ),
  private = list()
)

# Create GetPromoDataRequest from a reader
# @name GetPromoDataRequest_from_reader
#
# @param reader object providing reader methods (not used here)
# @return instance of GetPromoDataRequest
# @export
GetPromoDataRequest$from_reader <- function(reader) {
  GetPromoDataRequest$new()
}


#  GetRecentMeUrlsRequest R6 class
# 
#  Request to get recent "me" URLs with a referer string.
# 
#  @title GetRecentMeUrlsRequest
#  @description Telegram API type GetRecentMeUrlsRequest
#  @export
#  @noRd
#  @noRd
GetRecentMeUrlsRequest <- R6::R6Class(
  "GetRecentMeUrlsRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0x3dc0f114),
    SUBCLASS_OF_ID = as.numeric(0xf269c477),
    #  @field referer Field.
    referer = "",

    #  @description Initialize GetRecentMeUrlsRequest
    #  @param referer character
    initialize = function(referer = "") {
      self$referer <- as.character(referer)
    },

    #  Convert to list
    #  @return list with type discriminator and referer
    to_list = function() {
      list(
        #  @field type Field.
        type = "GetRecentMeUrlsRequest",
        referer = self$referer
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      parts <- list()
      parts[[1]] <- packInt32(self$CONSTRUCTOR_ID)
      # serialize referer string using Telegram string scheme
      strRaw <- charToRaw(self$referer)
      strLen <- length(strRaw)
      if (strLen < 254) {
        parts[[2]] <- as.raw(strLen)
        parts[[3]] <- strRaw
        pad <- (4 - ((1 + strLen) %% 4)) %% 4
        if (pad > 0) parts[[4]] <- as.raw(rep(0, pad))
      } else {
        parts[[2]] <- as.raw(254)
        parts[[3]] <- writeBin(as.integer(strLen), raw(), size = 4, endian = "little")
        parts[[4]] <- strRaw
        pad <- (4 - (strLen %% 4)) %% 4
        if (pad > 0) parts[[5]] <- as.raw(rep(0, pad))
      }
      do.call(c, parts)
    }
  ),
  private = list()
)

# Create GetRecentMeUrlsRequest from a reader
# @name GetRecentMeUrlsRequest_from_reader
#
# @param reader object providing tgread_string() method
# @return instance of GetRecentMeUrlsRequest
# @export
GetRecentMeUrlsRequest$from_reader <- function(reader) {
  refererVal <- reader$tgread_string()
  GetRecentMeUrlsRequest$new(referer = refererVal)
}


#  GetSupportRequest R6 class
# 
#  Request to get support information.
# 
#  @title GetSupportRequest
#  @description Telegram API type GetSupportRequest
#  @export
#  @noRd
#  @noRd
GetSupportRequest <- R6::R6Class(
  "GetSupportRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0x9cdf08cd),
    SUBCLASS_OF_ID = as.numeric(0x7159bceb),

    #  @description Initialize GetSupportRequest
    #  @return invisible NULL
    initialize = function() {
      invisible(NULL)
    },

    #  Convert to list
    #  @return list with type discriminator
    to_list = function() {
      list(
        #  @field type Field.
        type = "GetSupportRequest"
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      packInt32(self$CONSTRUCTOR_ID)
    }
  ),
  private = list()
)

# Create GetSupportRequest from a reader
# @name GetSupportRequest_from_reader
#
# @param reader object providing reader methods (not used here)
# @return instance of GetSupportRequest
# @export
GetSupportRequest$from_reader <- function(reader) {
  GetSupportRequest$new()
}


#  GetSupportNameRequest R6 class
# 
#  Request to get support name.
# 
#  @title GetSupportNameRequest
#  @description Telegram API type GetSupportNameRequest
#  @export
#  @noRd
#  @noRd
GetSupportNameRequest <- R6::R6Class(
  "GetSupportNameRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0xd360e72c),
    SUBCLASS_OF_ID = as.numeric(0x7f50b7c2),

    #  @description Initialize GetSupportNameRequest
    #  @return invisible NULL
    initialize = function() {
      invisible(NULL)
    },

    #  Convert to list
    #  @return list with `type` discriminator
    to_list = function() {
      list(
        #  @field type Field.
        type = "GetSupportNameRequest"
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      # constructor id (little-endian 4 bytes)
      packInt32(self$CONSTRUCTOR_ID)
    }
  ),
  private = list()
)

# Create GetSupportNameRequest from a reader
# @name GetSupportNameRequest_from_reader
#
# @param reader object providing `read_*()` methods (not used here)
# @return instance of GetSupportNameRequest
# @export
GetSupportNameRequest$from_reader <- function(reader) {
  GetSupportNameRequest$new()
}


#  GetTermsOfServiceUpdateRequest R6 class
# 
#  Request to get terms of service update.
# 
#  @title GetTermsOfServiceUpdateRequest
#  @description Telegram API type GetTermsOfServiceUpdateRequest
#  @export
#  @noRd
#  @noRd
GetTermsOfServiceUpdateRequest <- R6::R6Class(
  "GetTermsOfServiceUpdateRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0x2ca51fd1),
    SUBCLASS_OF_ID = as.numeric(0x293c2977),

    #  @description Initialize GetTermsOfServiceUpdateRequest
    #  @return invisible NULL
    initialize = function() {
      invisible(NULL)
    },

    #  Convert to list
    #  @return list with `type` discriminator
    to_list = function() {
      list(
        #  @field type Field.
        type = "GetTermsOfServiceUpdateRequest"
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      packInt32(self$CONSTRUCTOR_ID)
    }
  ),
  private = list()
)

# Create GetTermsOfServiceUpdateRequest from a reader
# @name GetTermsOfServiceUpdateRequest_from_reader
#
# @param reader object providing `read_*()` methods (not used here)
# @return instance of GetTermsOfServiceUpdateRequest
# @export
GetTermsOfServiceUpdateRequest$from_reader <- function(reader) {
  GetTermsOfServiceUpdateRequest$new()
}


#  GetTimezonesListRequest R6 class
# 
#  Request to get timezones list (possibly not modified).
# 
#  @title GetTimezonesListRequest
#  @description Telegram API type GetTimezonesListRequest
#  @export
#  @noRd
#  @noRd
GetTimezonesListRequest <- R6::R6Class(
  "GetTimezonesListRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0x49b30240),
    SUBCLASS_OF_ID = as.numeric(0xca76e475),
    hash = 0L,

    #  @description Initialize GetTimezonesListRequest
    #  @param hash integer
    initialize = function(hash = 0L) {
      self$hash <- as.integer(hash)
    },

    #  Convert to list
    #  @return list with `type` discriminator and hash
    to_list = function() {
      list(
        #  @field type Field.
        type = "GetTimezonesListRequest",
        hash = self$hash
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      parts <- list()
      parts[[1]] <- packInt32(self$CONSTRUCTOR_ID)
      parts[[2]] <- writeBin(as.integer(self$hash), raw(), size = 4, endian = "little")
      do.call(c, parts)
    }
  ),
  private = list()
)

# Create GetTimezonesListRequest from a reader
# @name GetTimezonesListRequest_from_reader
#
# @param reader object providing `read_int()` and similar methods
# @return instance of GetTimezonesListRequest
# @export
GetTimezonesListRequest$from_reader <- function(reader) {
  hashVal <- reader$read_int()
  GetTimezonesListRequest$new(hash = hashVal)
}


#  GetUserInfoRequest R6 class
# 
#  Request to get user info (help.UserInfo).
# 
#  @title GetUserInfoRequest
#  @description Telegram API type GetUserInfoRequest
#  @export
#  @noRd
#  @noRd
GetUserInfoRequest <- R6::R6Class(
  "GetUserInfoRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0x038a08d3),
    SUBCLASS_OF_ID = as.numeric(0x5c53d7d8),
    #  @field userId Field.
    userId = NULL,

    #  @description Initialize GetUserInfoRequest
    #  @param userId TLObject-like or raw
    initialize = function(userId = NULL) {
      self$userId <- userId
    },

    #  Resolve userId using client and utils
    #  @param client client object providing get_input_entity()
    #  @param utils utils providing get_input_user()
    resolve = function(client, utils) {
      # replace userId with resolved input user if helpers are provided
      self$userId <- utils$get_input_user(client$get_input_entity(self$userId))
    },

    #  Convert to list
    #  @return list with `_` discriminator and user_id as list (if possible)
    to_list = function() {
      list(
        `_` = "GetUserInfoRequest",
        user_id = if (is.null(self$userId)) {
          NULL
        } else {
          if (is.environment(self$userId) && !is.null(self$userId$to_list)) self$userId$to_list() else self$userId
        }
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      parts <- list()
      # constructor id (little-endian 4 bytes)
      parts[[1]] <- packInt32(self$CONSTRUCTOR_ID)
      # userId must provide to_bytes() or already be a raw vector
      if (is.raw(self$userId)) {
        parts[[2]] <- self$userId
      } else if (is.environment(self$userId) && !is.null(self$userId$to_bytes)) {
        parts[[2]] <- self$userId$to_bytes()
      } else {
        stop("userId must be a raw vector or provide to_bytes()")
      }
      do.call(c, parts)
    }
  ),
  private = list()
)

# Create GetUserInfoRequest from a reader
# @name GetUserInfoRequest_from_reader
#
# @param reader object providing `tgread_object()` method
# @return instance of GetUserInfoRequest
# @export
GetUserInfoRequest$from_reader <- function(reader) {
  userObj <- reader$tgread_object()
  GetUserInfoRequest$new(userId = userObj)
}


#  HidePromoDataRequest R6 class
# 
#  Request to hide promo data for a peer.
# 
#  @title HidePromoDataRequest
#  @description Telegram API type HidePromoDataRequest
#  @export
#  @noRd
#  @noRd
HidePromoDataRequest <- R6::R6Class(
  "HidePromoDataRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0x1e251c95),
    SUBCLASS_OF_ID = as.numeric(0xf5b399ac),
    #  @field peer Field.
    peer = NULL,

    #  @description Initialize HidePromoDataRequest
    #  @param peer TLObject-like or raw
    initialize = function(peer = NULL) {
      self$peer <- peer
    },

    #  Resolve peer using client and utils
    #  @param client client object providing get_input_entity()
    #  @param utils utils providing get_input_peer()
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  Convert to list
    #  @return list with `_` discriminator and peer as list (if possible)
    to_list = function() {
      list(
        `_` = "HidePromoDataRequest",
        peer = if (is.null(self$peer)) {
          NULL
        } else {
          if (is.environment(self$peer) && !is.null(self$peer$to_list)) self$peer$to_list() else self$peer
        }
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      parts <- list()
      parts[[1]] <- packInt32(self$CONSTRUCTOR_ID)
      if (is.raw(self$peer)) {
        parts[[2]] <- self$peer
      } else if (is.environment(self$peer) && !is.null(self$peer$to_bytes)) {
        parts[[2]] <- self$peer$to_bytes()
      } else {
        stop("peer must be a raw vector or provide to_bytes()")
      }
      do.call(c, parts)
    }
  ),
  private = list()
)

# Create HidePromoDataRequest from a reader
# @name HidePromoDataRequest_from_reader
#
# @param reader object providing `tgread_object()` method
# @return instance of HidePromoDataRequest
# @export
HidePromoDataRequest$from_reader <- function(reader) {
  peerObj <- reader$tgread_object()
  HidePromoDataRequest$new(peer = peerObj)
}


#  SaveAppLogRequest R6 class
# 
#  Request to save application log events.
# 
#  @title SaveAppLogRequest
#  @description Telegram API type SaveAppLogRequest
#  @export
#  @noRd
#  @noRd
SaveAppLogRequest <- R6::R6Class(
  "SaveAppLogRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0x6f02f748),
    SUBCLASS_OF_ID = as.numeric(0xf5b399ac),
    #  @field events Field.
    events = NULL,

    #  @description Initialize SaveAppLogRequest
    #  @param events list of TLObject-like events
    initialize = function(events = list()) {
      self$events <- events
    },

    #  Convert to list
    #  @return list with a `_` discriminator and events as lists (if possible)
    to_list = function() {
      list(
        `_` = "SaveAppLogRequest",
        events = if (is.null(self$events)) {
          list()
        } else {
          lapply(self$events, function(x) {
            if (is.environment(x) && !is.null(x$to_list)) x$to_list() else x
          })
        }
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      parts <- list()
      # constructor id (little-endian 4 bytes)
      parts[[1]] <- packInt32(self$CONSTRUCTOR_ID)
      # vector constructor for lists: 0x1cb5c415 encoded as bytes \x15\xc4\xb5\x1c
      parts[[2]] <- as.raw(c(0x15, 0xC4, 0xB5, 0x1C))
      # length of events
      parts[[3]] <- writeBin(as.integer(length(self$events)), raw(), size = 4, endian = "little")
      # each event is expected to provide a to_bytes() method or already be a raw vector
      eventBytes <- lapply(self$events, function(ev) {
        if (is.raw(ev)) {
          return(ev)
        }
        if (is.environment(ev) && !is.null(ev$to_bytes)) {
          return(ev$to_bytes())
        }
        stop("Each event must be a raw vector or provide to_bytes()")
      })
      if (length(eventBytes) > 0) parts[[4]] <- do.call(c, eventBytes)
      do.call(c, parts)
    }
  ),
  active = list(),
  private = list()
)

# Create SaveAppLogRequest from a reader
# @name SaveAppLogRequest_from_reader
#
# @param reader object providing `read_int()` and `tgread_object()` methods
# @return instance of SaveAppLogRequest
# @export
SaveAppLogRequest$from_reader <- function(reader) {
  # read potential vector constructor int (discard)
  reader$read_int()
  count <- reader$read_int()
  eventsList <- vector("list", count)
  for (i in seq_len(count)) {
    eventsList[[i]] <- reader$tgread_object()
  }
  SaveAppLogRequest$new(events = eventsList)
}


#  SetBotUpdatesStatusRequest R6 class
# 
#  Notify server of bot updates status.
# 
#  @title SetBotUpdatesStatusRequest
#  @description Telegram API type SetBotUpdatesStatusRequest
#  @export
#  @noRd
#  @noRd
SetBotUpdatesStatusRequest <- R6::R6Class(
  "SetBotUpdatesStatusRequest",
  public = list(
    CONSTRUCTOR_ID = as.numeric(0xec22cfcd),
    SUBCLASS_OF_ID = as.numeric(0xf5b399ac),
    pendingUpdatesCount = 0L,
    #  @field message Field.
    message = "",

    #  @description Initialize SetBotUpdatesStatusRequest
    #  @param pendingUpdatesCount integer
    #  @param message character
    initialize = function(pendingUpdatesCount = 0L, message = "") {
      self$pendingUpdatesCount <- as.integer(pendingUpdatesCount)
      self$message <- as.character(message)
    },

    #  Convert to list
    #  @return list representation
    to_list = function() {
      list(
        `_` = "SetBotUpdatesStatusRequest",
        pending_updates_count = self$pendingUpdatesCount,
        message = self$message
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw vector
    to_bytes = function() {
      parts <- list()
      parts[[1]] <- packInt32(self$CONSTRUCTOR_ID)
      parts[[2]] <- writeBin(as.integer(self$pendingUpdatesCount), raw(), size = 4, endian = "little")
      # simple Telegram-style string serialization:
      strRaw <- charToRaw(self$message)
      strLen <- length(strRaw)
      # for compactness use 1-byte length if <254, else 4-byte length as usual TG scheme
      if (strLen < 254) {
        parts[[3]] <- as.raw(strLen)
        parts[[4]] <- strRaw
        # padding to 4 bytes
        pad <- (4 - ((1 + strLen) %% 4)) %% 4
        if (pad > 0) parts[[5]] <- as.raw(rep(0, pad))
      } else {
        parts[[3]] <- as.raw(254)
        parts[[4]] <- writeBin(as.integer(strLen), raw(), size = 4, endian = "little")
        parts[[5]] <- strRaw
        pad <- (4 - (strLen %% 4)) %% 4
        if (pad > 0) parts[[6]] <- as.raw(rep(0, pad))
      }
      do.call(c, parts)
    }
  ),
  private = list()
)

# Create SetBotUpdatesStatusRequest from a reader
# @name SetBotUpdatesStatusRequest_from_reader
#
# @param reader object providing `read_int()` and `tgread_string()` methods
# @return instance of SetBotUpdatesStatusRequest
# @export
SetBotUpdatesStatusRequest$from_reader <- function(reader) {
  pendingCount <- reader$read_int()
  msg <- reader$tgread_string()
  SetBotUpdatesStatusRequest$new(pendingUpdatesCount = pendingCount, message = msg)
}
