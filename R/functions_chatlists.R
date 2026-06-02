#  CheckChatlistInviteRequest R6 class
# 
#  Request to check a chatlist invite by slug.
# 
#  @title CheckChatlistInviteRequest
#  @description Telegram API type CheckChatlistInviteRequest
#  @export
#  @noRd
#  @noRd
CheckChatlistInviteRequest <- R6::R6Class(
  "CheckChatlistInviteRequest",
  public = list(
    CONSTRUCTOR_ID = 0x41c10fff,
    SUBCLASS_OF_ID = 0x41720e75,
    #  @field slug Field.
    slug = NULL,

    #  @description Initialize CheckChatlistInviteRequest
    #  @param slug Invite slug (string)
    initialize = function(slug = NULL) {
      self$slug <- slug
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    #  @return A named list representation
    to_list = function() {
      list(
        `_` = "CheckChatlistInviteRequest",
        slug = self$slug
      )
    },

    #  Serialize to raw bytes
    #  @details Serializes constructor id followed by TL-string encoded slug.
    #  @return raw vector with serialized bytes
    bytes = function() {
      tl_serialize_string <- function(s) {
        if (is.null(s)) {
          return(raw())
        }
        rb <- charToRaw(enc2utf8(as.character(s)))
        n <- length(rb)
        if (n < 254) {
          head <- as.raw(n)
          body <- c(head, rb)
          pad_len <- (4 - (length(body) %% 4)) %% 4
          if (pad_len > 0) body <- c(body, rep(as.raw(0x00), pad_len))
          return(as.raw(body))
        } else {
          head <- c(as.raw(254), writeBin(as.integer(n), raw(), size = 3, endian = "little"))
          body <- c(head, rb)
          pad_len <- (4 - (length(body) %% 4)) %% 4
          if (pad_len > 0) body <- c(body, rep(as.raw(0x00), pad_len))
          return(as.raw(body))
        }
      }

      parts <- list()
      # constructor id bytes (little-endian): 0xff 0x0f 0xc1 0x41
      parts[[length(parts) + 1]] <- as.raw(c(0xff, 0x0f, 0xc1, 0x41))
      parts[[length(parts) + 1]] <- tl_serialize_string(self$slug)
      do.call(c, parts)
    }
  )
)

#  Construct CheckChatlistInviteRequest from reader
# 
#  Reads slug from a reader and returns a new instance.
#  @param reader Reader object providing tgread_string
#  @return CheckChatlistInviteRequest instance
#  @export
CheckChatlistInviteRequest$set("public", "from_reader", function(reader) {
  slug_val <- reader$tgread_string()
  CheckChatlistInviteRequest$new(slug = slug_val)
})


#  DeleteExportedInviteRequest R6 class
# 
#  Request to delete an exported invite for a chatlist.
# 
#  @title DeleteExportedInviteRequest
#  @description Telegram API type DeleteExportedInviteRequest
#  @export
#  @noRd
#  @noRd
DeleteExportedInviteRequest <- R6::R6Class(
  "DeleteExportedInviteRequest",
  public = list(
    CONSTRUCTOR_ID = 0x719c5c5e,
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field chatlist Field.
    chatlist = NULL,
    #  @field slug Field.
    slug = NULL,

    #  @description Initialize DeleteExportedInviteRequest
    #  @param chatlist Input chatlist object
    #  @param slug Invite slug (string)
    initialize = function(chatlist = NULL, slug = NULL) {
      self$chatlist <- chatlist
      self$slug <- slug
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    #  @return A named list representation
    to_list = function() {
      list(
        `_` = "DeleteExportedInviteRequest",
        chatlist = if (!is.null(self$chatlist) && inherits(self$chatlist, "TLObject")) self$chatlist$to_list() else self$chatlist,
        slug = self$slug
      )
    },

    #  Serialize to raw bytes
    #  @details Serializes constructor id, chatlist bytes, then TL-string encoded slug.
    #  @return raw vector with serialized bytes
    bytes = function() {
      tl_serialize_string <- function(s) {
        if (is.null(s)) {
          return(raw())
        }
        rb <- charToRaw(enc2utf8(as.character(s)))
        n <- length(rb)
        if (n < 254) {
          head <- as.raw(n)
          body <- c(head, rb)
          pad_len <- (4 - (length(body) %% 4)) %% 4
          if (pad_len > 0) body <- c(body, rep(as.raw(0x00), pad_len))
          return(as.raw(body))
        } else {
          head <- c(as.raw(254), writeBin(as.integer(n), raw(), size = 3, endian = "little"))
          body <- c(head, rb)
          pad_len <- (4 - (length(body) %% 4)) %% 4
          if (pad_len > 0) body <- c(body, rep(as.raw(0x00), pad_len))
          return(as.raw(body))
        }
      }

      parts <- list()
      # constructor id bytes (little-endian): 0x5e 0x5c 0x9c 0x71
      parts[[length(parts) + 1]] <- as.raw(c(0x5e, 0x5c, 0x9c, 0x71))
      if (!is.null(self$chatlist) && is.function(self$chatlist$bytes)) {
        parts[[length(parts) + 1]] <- self$chatlist$bytes()
      } else {
        parts[[length(parts) + 1]] <- raw()
      }
      parts[[length(parts) + 1]] <- tl_serialize_string(self$slug)
      do.call(c, parts)
    }
  )
)

#  Construct DeleteExportedInviteRequest from reader
# 
#  Reads chatlist and slug from a reader and returns a new instance.
#  @param reader Reader object providing tgread_object and tgread_string
#  @return DeleteExportedInviteRequest instance
#  @export
DeleteExportedInviteRequest$set("public", "from_reader", function(reader) {
  chatlist_obj <- reader$tgread_object()
  slug_val <- reader$tgread_string()
  DeleteExportedInviteRequest$new(chatlist = chatlist_obj, slug = slug_val)
})


#  EditExportedInviteRequest R6 class
# 
#  Request to edit an exported invite for a chatlist (optional title and peers).
# 
#  @title EditExportedInviteRequest
#  @description Telegram API type EditExportedInviteRequest
#  @export
#  @noRd
#  @noRd
EditExportedInviteRequest <- R6::R6Class(
  "EditExportedInviteRequest",
  public = list(
    CONSTRUCTOR_ID = 0x653db63d,
    SUBCLASS_OF_ID = 0x7711f8ff,
    #  @field chatlist Field.
    chatlist = NULL,
    #  @field slug Field.
    slug = NULL,
    #  @field title Field.
    title = NULL,
    #  @field peers Field.
    peers = NULL,

    #  @description Initialize EditExportedInviteRequest
    #  @param chatlist Input chatlist object
    #  @param slug Invite slug (string)
    #  @param title Optional invite title (string)
    #  @param peers Optional list of input peers
    initialize = function(chatlist = NULL, slug = NULL, title = NULL, peers = NULL) {
      self$chatlist <- chatlist
      self$slug <- slug
      self$title <- title
      self$peers <- peers
      invisible(self)
    },

    #  Resolve peer entities to input peers
    # 
    #  Iterates over peers, resolves each via client and utils and replaces
    #  the peers field with input_peer objects.
    #  @param client Client object that provides get_input_entity
    #  @param utils Utilities that provide get_input_peer
    #  @return Invisible self
    resolve = function(client, utils) {
      tmp_list <- list()
      if (!is.null(self$peers)) {
        for (p in self$peers) {
          ent <- client$get_input_entity(p)
          ip <- utils$get_input_peer(ent)
          tmp_list[[length(tmp_list) + 1]] <- ip
        }
      }
      self$peers <- tmp_list
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    #  @return A named list representation
    to_list = function() {
      list(
        `_` = "EditExportedInviteRequest",
        chatlist = if (!is.null(self$chatlist) && inherits(self$chatlist, "TLObject")) self$chatlist$to_list() else self$chatlist,
        slug = self$slug,
        title = self$title,
        peers = if (is.null(self$peers)) list() else lapply(self$peers, function(x) if (inherits(x, "TLObject")) x$to_list() else x)
      )
    },

    #  Serialize to raw bytes
    # 
    #  Serializes constructor id, flags, chatlist, slug, optional title and optional peers vector.
    #  @return raw vector with serialized bytes
    bytes = function() {
      pack_int32 <- function(i) writeBin(as.integer(i), raw(), size = 4, endian = "little")

      tl_serialize_string <- function(s) {
        if (is.null(s)) {
          return(raw())
        }
        rb <- charToRaw(enc2utf8(as.character(s)))
        n <- length(rb)
        if (n < 254) {
          head <- as.raw(n)
          body <- c(head, rb)
          pad_len <- (4 - (length(body) %% 4)) %% 4
          if (pad_len > 0) body <- c(body, rep(as.raw(0x00), pad_len))
          return(as.raw(body))
        } else {
          head <- c(as.raw(254), writeBin(as.integer(n), raw(), size = 3, endian = "little"))
          body <- c(head, rb)
          pad_len <- (4 - (length(body) %% 4)) %% 4
          if (pad_len > 0) body <- c(body, rep(as.raw(0x00), pad_len))
          return(as.raw(body))
        }
      }

      flags_int <- 0L
      if (!is.null(self$title) && !identical(self$title, FALSE)) flags_int <- flags_int + 2L
      if (!is.null(self$peers) && !identical(self$peers, FALSE)) flags_int <- flags_int + 4L

      parts <- list()
      # constructor id bytes (little-endian): 0x3d 0xb6 0x3d 0x65
      parts[[length(parts) + 1]] <- as.raw(c(0x3d, 0xb6, 0x3d, 0x65))
      # flags
      parts[[length(parts) + 1]] <- pack_int32(flags_int)
      # chatlist bytes
      if (!is.null(self$chatlist) && is.function(self$chatlist$bytes)) {
        parts[[length(parts) + 1]] <- self$chatlist$bytes()
      } else {
        parts[[length(parts) + 1]] <- raw()
      }
      # slug serialized
      parts[[length(parts) + 1]] <- tl_serialize_string(self$slug)
      # optional title
      if (!is.null(self$title) && !identical(self$title, FALSE)) {
        parts[[length(parts) + 1]] <- tl_serialize_string(self$title)
      }
      # optional peers vector
      if (!is.null(self$peers) && !identical(self$peers, FALSE)) {
        parts[[length(parts) + 1]] <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
        count_peers <- as.integer(length(self$peers))
        parts[[length(parts) + 1]] <- pack_int32(count_peers)
        if (count_peers > 0) {
          for (p in self$peers) {
            if (is.function(p$bytes)) {
              parts[[length(parts) + 1]] <- p$bytes()
            } else {
              parts[[length(parts) + 1]] <- raw()
            }
          }
        }
      }
      do.call(c, parts)
    }
  ),
  active = list(),
  private = list(),
  class = FALSE
)

#  Construct EditExportedInviteRequest from reader
# 
#  Reads flags, chatlist, slug, optional title and optional peers from a reader and returns a new instance.
#  @param reader Reader object providing read_int, tgread_object and tgread_string
#  @return EditExportedInviteRequest instance
#  @export
EditExportedInviteRequest$set("public", "from_reader", function(reader) {
  flags <- reader$read_int()
  has_title <- bitwAnd(flags, 2L) != 0L
  has_peers <- bitwAnd(flags, 4L) != 0L

  chatlist_obj <- reader$tgread_object()
  slug_val <- reader$tgread_string()

  title_val <- NULL
  if (has_title) {
    title_val <- reader$tgread_string()
  }

  peers_val <- NULL
  if (has_peers) {
    # read and ignore an int (vector marker)
    .ignored_marker <- reader$read_int()
    count <- reader$read_int()
    peers_list <- vector("list", count)
    if (count > 0) {
      for (i in seq_len(count)) {
        peer_obj <- reader$tgread_object()
        peers_list[[i]] <- peer_obj
      }
    }
    peers_val <- peers_list
  }

  EditExportedInviteRequest$new(chatlist = chatlist_obj, slug = slug_val, title = title_val, peers = peers_val)
})


#  ExportChatlistInviteRequest R6 class
# 
#  Request to export an invite for a chatlist with a title and list of peers.
# 
#  @title ExportChatlistInviteRequest
#  @description Telegram API type ExportChatlistInviteRequest
#  @export
#  @noRd
#  @noRd
ExportChatlistInviteRequest <- R6::R6Class(
  "ExportChatlistInviteRequest",
  public = list(
    CONSTRUCTOR_ID = 0x8472478e,
    SUBCLASS_OF_ID = 0xc2694ee9,
    #  @field chatlist Field.
    chatlist = NULL,
    #  @field title Field.
    title = NULL,
    #  @field peers Field.
    peers = NULL,

    #  @description Initialize ExportChatlistInviteRequest
    #  @param chatlist Input chatlist object
    #  @param title Invite title (string)
    #  @param peers List of input peers
    initialize = function(chatlist = NULL, title = NULL, peers = NULL) {
      self$chatlist <- chatlist
      self$title <- title
      self$peers <- peers
      invisible(self)
    },

    #  Resolve peer entities to input peers
    # 
    #  Iterates over peers, resolves each via client and utils and replaces
    #  the peers field with input_peer objects.
    #  @param client Client object that provides get_input_entity
    #  @param utils Utilities that provide get_input_peer
    #  @return Invisible self
    resolve = function(client, utils) {
      tmp_list <- list()
      if (!is.null(self$peers)) {
        for (p in self$peers) {
          ent <- client$get_input_entity(p)
          ip <- utils$get_input_peer(ent)
          tmp_list[[length(tmp_list) + 1]] <- ip
        }
      }
      self$peers <- tmp_list
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    #  @return A named list representation
    to_list = function() {
      list(
        `_` = "ExportChatlistInviteRequest",
        chatlist = if (!is.null(self$chatlist) && inherits(self$chatlist, "TLObject")) self$chatlist$to_list() else self$chatlist,
        title = self$title,
        peers = if (is.null(self$peers)) list() else lapply(self$peers, function(x) if (inherits(x, "TLObject")) x$to_list() else x)
      )
    },

    #  Serialize to raw bytes
    #  @details Serializes constructor id, chatlist bytes, title (TL-string), then peers vector.
    #  @return raw vector with serialized bytes
    bytes = function() {
      pack_int32 <- function(i) writeBin(as.integer(i), raw(), size = 4, endian = "little")

      tl_serialize_string <- function(s) {
        if (is.null(s)) {
          return(raw())
        }
        rb <- charToRaw(enc2utf8(as.character(s)))
        n <- length(rb)
        if (n < 254) {
          head <- as.raw(n)
          body <- c(head, rb)
          pad_len <- (4 - (length(body) %% 4)) %% 4
          if (pad_len > 0) body <- c(body, rep(as.raw(0x00), pad_len))
          return(as.raw(body))
        } else {
          head <- c(as.raw(254), writeBin(as.integer(n), raw(), size = 3, endian = "little"))
          body <- c(head, rb)
          pad_len <- (4 - (length(body) %% 4)) %% 4
          if (pad_len > 0) body <- c(body, rep(as.raw(0x00), pad_len))
          return(as.raw(body))
        }
      }

      parts <- list()
      # constructor id bytes (little-endian)
      parts[[length(parts) + 1]] <- as.raw(c(0x8e, 0x47, 0x72, 0x84))
      # chatlist bytes
      if (!is.null(self$chatlist) && is.function(self$chatlist$bytes)) {
        parts[[length(parts) + 1]] <- self$chatlist$bytes()
      } else {
        parts[[length(parts) + 1]] <- raw()
      }
      # title serialized
      parts[[length(parts) + 1]] <- tl_serialize_string(self$title)
      # vector marker for peers: 0x15c4b51c in little endian
      parts[[length(parts) + 1]] <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
      count_peers <- if (is.null(self$peers)) 0L else as.integer(length(self$peers))
      parts[[length(parts) + 1]] <- pack_int32(count_peers)
      if (!is.null(self$peers) && length(self$peers) > 0) {
        for (p in self$peers) {
          if (is.function(p$bytes)) {
            parts[[length(parts) + 1]] <- p$bytes()
          } else {
            parts[[length(parts) + 1]] <- raw()
          }
        }
      }
      do.call(c, parts)
    }
  )
)

#  Construct ExportChatlistInviteRequest from reader
# 
#  Reads chatlist, title and peers from a reader and returns a new instance.
#  @param reader Reader object providing tgread_object, tgread_string and read_int
#  @return ExportChatlistInviteRequest instance
#  @export
ExportChatlistInviteRequest$set("public", "from_reader", function(reader) {
  chatlist_obj <- reader$tgread_object()
  title_val <- reader$tgread_string()
  # read and ignore an int (vector marker)
  ignored_marker <- reader$read_int()
  count <- reader$read_int()
  peers_list <- vector("list", count)
  if (count > 0) {
    for (i in seq_len(count)) {
      peer_obj <- reader$tgread_object()
      peers_list[[i]] <- peer_obj
    }
  }
  ExportChatlistInviteRequest$new(chatlist = chatlist_obj, title = title_val, peers = peers_list)
})


#  GetChatlistUpdatesRequest R6 class
# 
#  Request to get updates for a chatlist.
# 
#  @title GetChatlistUpdatesRequest
#  @description Telegram API type GetChatlistUpdatesRequest
#  @export
#  @noRd
#  @noRd
GetChatlistUpdatesRequest <- R6::R6Class(
  "GetChatlistUpdatesRequest",
  public = list(
    CONSTRUCTOR_ID = 0x89419521,
    SUBCLASS_OF_ID = 0x7d1641ea,
    #  @field chatlist Field.
    chatlist = NULL,

    #  @description Initialize GetChatlistUpdatesRequest
    #  @param chatlist Input chatlist object
    initialize = function(chatlist = NULL) {
      self$chatlist <- chatlist
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    #  @return A named list representation
    to_list = function() {
      list(
        `_` = "GetChatlistUpdatesRequest",
        chatlist = if (!is.null(self$chatlist) && inherits(self$chatlist, "TLObject")) self$chatlist$to_list() else self$chatlist
      )
    },

    #  Serialize to raw bytes
    #  @details Serializes the constructor id followed by chatlist bytes.
    #  @return raw vector with serialized bytes
    bytes = function() {
      parts <- list()
      # constructor id bytes (little-endian)
      parts[[length(parts) + 1]] <- as.raw(c(0x21, 0x95, 0x41, 0x89))
      # chatlist bytes
      if (!is.null(self$chatlist) && is.function(self$chatlist$bytes)) {
        parts[[length(parts) + 1]] <- self$chatlist$bytes()
      } else {
        parts[[length(parts) + 1]] <- raw()
      }
      do.call(c, parts)
    }
  )
)

#  Construct GetChatlistUpdatesRequest from reader
# 
#  Reads chatlist from a reader and returns a new instance.
#  @param reader Reader object providing tgread_object
#  @return GetChatlistUpdatesRequest instance
#  @export
GetChatlistUpdatesRequest$set("public", "from_reader", function(reader) {
  chatlist_obj <- reader$tgread_object()
  GetChatlistUpdatesRequest$new(chatlist = chatlist_obj)
})


#  GetExportedInvitesRequest R6 class
# 
#  Request to get exported invites for a chatlist.
# 
#  @title GetExportedInvitesRequest
#  @description Telegram API type GetExportedInvitesRequest
#  @export
#  @noRd
#  @noRd
GetExportedInvitesRequest <- R6::R6Class(
  "GetExportedInvitesRequest",
  public = list(
    CONSTRUCTOR_ID = 0xce03da83,
    SUBCLASS_OF_ID = 0xe6c209c0,
    #  @field chatlist Field.
    chatlist = NULL,

    #  @description Initialize GetExportedInvitesRequest
    #  @param chatlist Input chatlist object
    initialize = function(chatlist = NULL) {
      self$chatlist <- chatlist
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    #  @return A named list representation
    to_list = function() {
      list(
        `_` = "GetExportedInvitesRequest",
        chatlist = if (!is.null(self$chatlist) && inherits(self$chatlist, "TLObject")) self$chatlist$to_list() else self$chatlist
      )
    },

    #  Serialize to raw bytes
    #  @details Serializes the constructor id followed by chatlist bytes.
    #  @return raw vector with serialized bytes
    bytes = function() {
      parts <- list()
      # constructor id bytes (little-endian)
      parts[[length(parts) + 1]] <- as.raw(c(0x83, 0xda, 0x03, 0xce))
      # chatlist bytes
      if (!is.null(self$chatlist) && is.function(self$chatlist$bytes)) {
        parts[[length(parts) + 1]] <- self$chatlist$bytes()
      } else {
        parts[[length(parts) + 1]] <- raw()
      }
      do.call(c, parts)
    }
  )
)

#  Construct GetExportedInvitesRequest from reader
# 
#  Reads chatlist from a reader and returns a new instance.
#  @param reader Reader object providing tgread_object
#  @return GetExportedInvitesRequest instance
#  @export
GetExportedInvitesRequest$set("public", "from_reader", function(reader) {
  chatlist_obj <- reader$tgread_object()
  GetExportedInvitesRequest$new(chatlist = chatlist_obj)
})


#  GetLeaveChatlistSuggestionsRequest R6 class
# 
#  Request to get suggestions of peers to leave from a chatlist.
# 
#  @title GetLeaveChatlistSuggestionsRequest
#  @description Telegram API type GetLeaveChatlistSuggestionsRequest
#  @export
#  @noRd
#  @noRd
GetLeaveChatlistSuggestionsRequest <- R6::R6Class(
  "GetLeaveChatlistSuggestionsRequest",
  public = list(
    CONSTRUCTOR_ID = 0xfdbcd714,
    SUBCLASS_OF_ID = 0xb9945d7e,
    #  @field chatlist Field.
    chatlist = NULL,

    #  @description Initialize GetLeaveChatlistSuggestionsRequest
    #  @param chatlist Input chatlist object
    initialize = function(chatlist = NULL) {
      self$chatlist <- chatlist
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    #  @return A named list representation
    to_list = function() {
      list(
        `_` = "GetLeaveChatlistSuggestionsRequest",
        chatlist = if (!is.null(self$chatlist) && inherits(self$chatlist, "TLObject")) self$chatlist$to_list() else self$chatlist
      )
    },

    #  Serialize to raw bytes
    #  @details Serializes the constructor id followed by chatlist bytes.
    #  @return raw vector with serialized bytes
    bytes = function() {
      parts <- list()
      # constructor id bytes (little-endian)
      parts[[length(parts) + 1]] <- as.raw(c(0x14, 0xd7, 0xbc, 0xfd))
      # chatlist bytes
      if (!is.null(self$chatlist) && is.function(self$chatlist$bytes)) {
        parts[[length(parts) + 1]] <- self$chatlist$bytes()
      } else {
        parts[[length(parts) + 1]] <- raw()
      }
      do.call(c, parts)
    }
  )
)

#  Construct GetLeaveChatlistSuggestionsRequest from reader
# 
#  Reads chatlist from a reader and returns a new instance.
#  @param reader Reader object providing tgread_object
#  @return GetLeaveChatlistSuggestionsRequest instance
#  @export
GetLeaveChatlistSuggestionsRequest$set("public", "from_reader", function(reader) {
  chatlist_obj <- reader$tgread_object()
  GetLeaveChatlistSuggestionsRequest$new(chatlist = chatlist_obj)
})


#  HideChatlistUpdatesRequest R6 class
# 
#  Request to hide updates for a chatlist.
# 
#  @title HideChatlistUpdatesRequest
#  @description Telegram API type HideChatlistUpdatesRequest
#  @export
#  @noRd
#  @noRd
HideChatlistUpdatesRequest <- R6::R6Class(
  "HideChatlistUpdatesRequest",
  public = list(
    CONSTRUCTOR_ID = 0x66e486fb,
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field chatlist Field.
    chatlist = NULL,

    #  @description Initialize HideChatlistUpdatesRequest
    #  @param chatlist Input chatlist object
    initialize = function(chatlist = NULL) {
      self$chatlist <- chatlist
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    #  @return A named list representation
    to_list = function() {
      list(
        `_` = "HideChatlistUpdatesRequest",
        chatlist = if (!is.null(self$chatlist) && inherits(self$chatlist, "TLObject")) self$chatlist$to_list() else self$chatlist
      )
    },

    #  Serialize to raw bytes
    #  @details Serializes the constructor id followed by chatlist bytes.
    #  @return raw vector with serialized bytes
    bytes = function() {
      pack_int32 <- function(i) writeBin(as.integer(i), raw(), size = 4, endian = "little")
      parts <- list()
      # constructor id bytes (little-endian)
      parts[[length(parts) + 1]] <- as.raw(c(0xfb, 0x86, 0xe4, 0x66))
      # chatlist bytes
      if (!is.null(self$chatlist) && is.function(self$chatlist$bytes)) {
        parts[[length(parts) + 1]] <- self$chatlist$bytes()
      } else {
        parts[[length(parts) + 1]] <- raw()
      }
      do.call(c, parts)
    }
  )
)

#  Construct HideChatlistUpdatesRequest from reader
# 
#  Reads chatlist from a reader and returns a new instance.
#  @param reader Reader object providing tgread_object
#  @return HideChatlistUpdatesRequest instance
#  @export
HideChatlistUpdatesRequest$set("public", "from_reader", function(reader) {
  chatlist_obj <- reader$tgread_object()
  HideChatlistUpdatesRequest$new(chatlist = chatlist_obj)
})


#  JoinChatlistInviteRequest R6 class
# 
#  Request to join a chatlist invite (by slug) with specific peers.
# 
#  @title JoinChatlistInviteRequest
#  @description Telegram API type JoinChatlistInviteRequest
#  @export
#  @noRd
#  @noRd
JoinChatlistInviteRequest <- R6::R6Class(
  "JoinChatlistInviteRequest",
  public = list(
    CONSTRUCTOR_ID = 0xa6b1e39a,
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field slug Field.
    slug = NULL,
    #  @field peers Field.
    peers = NULL,

    #  @description Initialize JoinChatlistInviteRequest
    #  @param slug Invite slug string
    #  @param peers List of input peers
    initialize = function(slug = NULL, peers = NULL) {
      self$slug <- slug
      self$peers <- peers
      invisible(self)
    },

    #  Resolve peer entities to input peers
    # 
    #  Iterates over peers, resolves each via client and utils and replaces
    #  the peers field with input_peer objects.
    #  @param client Client object that provides get_input_entity
    #  @param utils Utilities that provide get_input_peer
    #  @return Invisible self
    resolve = function(client, utils) {
      tmp_list <- list()
      if (!is.null(self$peers)) {
        for (p in self$peers) {
          ent <- client$get_input_entity(p)
          ip <- utils$get_input_peer(ent)
          tmp_list[[length(tmp_list) + 1]] <- ip
        }
      }
      self$peers <- tmp_list
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    #  @return A named list representation
    to_list = function() {
      list(
        `_` = "JoinChatlistInviteRequest",
        slug = self$slug,
        peers = if (is.null(self$peers)) list() else lapply(self$peers, function(x) if (inherits(x, "TLObject")) x$to_list() else x)
      )
    },

    #  Serialize to raw bytes
    #  @details Serializes constructor id, slug (TL-string encoding), then peers vector.
    #  @return raw vector with serialized bytes
    bytes = function() {
      pack_int32 <- function(i) writeBin(as.integer(i), raw(), size = 4, endian = "little")

      # TL-string serializer (full TL-string encoding)
      tl_serialize_string <- function(s) {
        if (is.null(s)) {
          return(raw())
        }
        rb <- charToRaw(enc2utf8(as.character(s)))
        n <- length(rb)
        if (n < 254) {
          head <- as.raw(n)
          body <- c(head, rb)
          pad_len <- (4 - (length(body) %% 4)) %% 4
          if (pad_len > 0) body <- c(body, rep(as.raw(0x00), pad_len))
          return(as.raw(body))
        } else {
          head <- c(as.raw(254), writeBin(as.integer(n), raw(), size = 3, endian = "little"))
          body <- c(head, rb)
          pad_len <- (4 - (length(body) %% 4)) %% 4
          if (pad_len > 0) body <- c(body, rep(as.raw(0x00), pad_len))
          return(as.raw(body))
        }
      }

      parts <- list()
      # constructor id bytes (little-endian)
      parts[[length(parts) + 1]] <- as.raw(c(0x9a, 0xe3, 0xb1, 0xa6))
      # slug serialized
      parts[[length(parts) + 1]] <- tl_serialize_string(self$slug)
      # vector marker for peers: 0x15c4b51c in little endian
      parts[[length(parts) + 1]] <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
      # count of peers
      count_peers <- if (is.null(self$peers)) 0L else as.integer(length(self$peers))
      parts[[length(parts) + 1]] <- pack_int32(count_peers)
      # peers bytes
      if (!is.null(self$peers) && length(self$peers) > 0) {
        for (p in self$peers) {
          if (is.function(p$bytes)) {
            parts[[length(parts) + 1]] <- p$bytes()
          } else {
            parts[[length(parts) + 1]] <- raw()
          }
        }
      }
      do.call(c, parts)
    }
  ),
  active = list(),
  private = list(),
  class = FALSE
)

#  Construct JoinChatlistInviteRequest from reader
# 
#  Reads slug and peers from a reader and returns a new instance.
#  @param reader Reader object providing tgread_string, read_int and tgread_object
#  @return JoinChatlistInviteRequest instance
#  @export
JoinChatlistInviteRequest$set("public", "from_reader", function(reader) {
  slug_val <- reader$tgread_string()
  # read and ignore an int (vector marker)
  ignored_marker <- reader$read_int()
  count <- reader$read_int()
  peers_list <- vector("list", count)
  if (count > 0) {
    for (i in seq_len(count)) {
      peer_obj <- reader$tgread_object()
      peers_list[[i]] <- peer_obj
    }
  }
  JoinChatlistInviteRequest$new(slug = slug_val, peers = peers_list)
})


#  JoinChatlistUpdatesRequest R6 class
# 
#  Request to join a chatlist with specific peers.
# 
#  @title JoinChatlistUpdatesRequest
#  @description Telegram API type JoinChatlistUpdatesRequest
#  @export
#  @noRd
#  @noRd
JoinChatlistUpdatesRequest <- R6::R6Class(
  "JoinChatlistUpdatesRequest",
  public = list(
    CONSTRUCTOR_ID = 0xe089f8f5,
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field chatlist Field.
    chatlist = NULL,
    #  @field peers Field.
    peers = NULL,

    #  @description Initialize JoinChatlistUpdatesRequest
    #  @param chatlist Input chatlist object
    #  @param peers List of input peers
    initialize = function(chatlist = NULL, peers = NULL) {
      self$chatlist <- chatlist
      self$peers <- peers
      invisible(self)
    },

    #  Resolve peer entities to input peers
    # 
    #  Iterates over peers, resolves each via client and utils and replaces
    #  the peers field with input_peer objects.
    #  @param client Client object that provides get_input_entity
    #  @param utils Utilities that provide get_input_peer
    #  @return Invisible self
    resolve = function(client, utils) {
      tmp_list <- list()
      if (!is.null(self$peers)) {
        for (p in self$peers) {
          ent <- client$get_input_entity(p)
          ip <- utils$get_input_peer(ent)
          tmp_list[[length(tmp_list) + 1]] <- ip
        }
      }
      self$peers <- tmp_list
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    #  @return A named list representation
    to_list = function() {
      list(
        `_` = "JoinChatlistUpdatesRequest",
        chatlist = if (!is.null(self$chatlist) && inherits(self$chatlist, "TLObject")) self$chatlist$to_list() else self$chatlist,
        peers = if (is.null(self$peers)) list() else lapply(self$peers, function(x) if (inherits(x, "TLObject")) x$to_list() else x)
      )
    },

    #  Serialize to raw bytes
    #  @return raw vector with serialized bytes
    bytes = function() {
      pack_int32 <- function(i) writeBin(as.integer(i), raw(), size = 4, endian = "little")
      parts <- list()
      # constructor id bytes (little-endian as raw)
      parts[[length(parts) + 1]] <- as.raw(c(0xf5, 0xf8, 0x89, 0xe0))
      # chatlist bytes
      if (!is.null(self$chatlist) && is.function(self$chatlist$bytes)) {
        parts[[length(parts) + 1]] <- self$chatlist$bytes()
      } else {
        parts[[length(parts) + 1]] <- raw()
      }
      # vector marker for peers: 0x15c4b51c in little endian
      parts[[length(parts) + 1]] <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
      parts[[length(parts) + 1]] <- pack_int32(length(self$peers))
      if (!is.null(self$peers) && length(self$peers) > 0) {
        for (p in self$peers) {
          if (is.function(p$bytes)) {
            parts[[length(parts) + 1]] <- p$bytes()
          } else {
            parts[[length(parts) + 1]] <- raw()
          }
        }
      }
      do.call(c, parts)
    }
  ),
  active = list(),
  private = list(),
  class = FALSE
)

#  Construct JoinChatlistUpdatesRequest from reader
# 
#  Reads chatlist and peers from a reader and returns a new instance.
#  @param reader Reader object providing tgread_object and read_int
#  @return JoinChatlistUpdatesRequest instance
#  @export
JoinChatlistUpdatesRequest$set("public", "from_reader", function(reader) {
  chatlist_obj <- reader$tgread_object()
  # read and ignore an int (as per original structure)
  .ignored <- reader$read_int()
  count <- reader$read_int()
  peers_vec <- vector("list", count)
  if (count > 0) {
    for (i in seq_len(count)) {
      peer_obj <- reader$tgread_object()
      peers_vec[[i]] <- peer_obj
    }
  }
  JoinChatlistUpdatesRequest$new(chatlist = chatlist_obj, peers = peers_vec)
})


#  LeaveChatlistRequest R6 class
# 
#  Request to leave a chatlist for specific peers.
# 
#  @title LeaveChatlistRequest
#  @description Telegram API type LeaveChatlistRequest
#  @export
#  @noRd
#  @noRd
LeaveChatlistRequest <- R6::R6Class(
  "LeaveChatlistRequest",
  public = list(
    CONSTRUCTOR_ID = 0x74fae13a,
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field chatlist Field.
    chatlist = NULL,
    #  @field peers Field.
    peers = NULL,

    #  @description Initialize LeaveChatlistRequest
    #  @param chatlist Input chatlist object
    #  @param peers List of input peers
    initialize = function(chatlist = NULL, peers = NULL) {
      self$chatlist <- chatlist
      self$peers <- peers
      invisible(self)
    },

    #  Resolve peer entities to input peers
    # 
    #  @param client Client object that provides get_input_entity
    #  @param utils Utilities that provide get_input_peer
    #  @return Invisible self
    resolve = function(client, utils) {
      tmp_list <- list()
      if (!is.null(self$peers)) {
        for (p in self$peers) {
          ent <- client$get_input_entity(p)
          ip <- utils$get_input_peer(ent)
          tmp_list[[length(tmp_list) + 1]] <- ip
        }
      }
      self$peers <- tmp_list
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    #  @return A named list representation
    to_list = function() {
      list(
        `_` = "LeaveChatlistRequest",
        chatlist = if (!is.null(self$chatlist) && inherits(self$chatlist, "TLObject")) self$chatlist$to_list() else self$chatlist,
        peers = if (is.null(self$peers)) list() else lapply(self$peers, function(x) if (inherits(x, "TLObject")) x$to_list() else x)
      )
    },

    #  Serialize to raw bytes
    #  @return raw vector with serialized bytes
    bytes = function() {
      pack_int32 <- function(i) writeBin(as.integer(i), raw(), size = 4, endian = "little")
      parts <- list()
      parts[[length(parts) + 1]] <- as.raw(c(0x3a, 0xe1, 0x7f, 0x74)) # b':\xe1\xfat'
      if (!is.null(self$chatlist) && is.function(self$chatlist$bytes)) {
        parts[[length(parts) + 1]] <- self$chatlist$bytes()
      } else {
        parts[[length(parts) + 1]] <- raw()
      }
      parts[[length(parts) + 1]] <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
      parts[[length(parts) + 1]] <- pack_int32(length(self$peers))
      if (!is.null(self$peers) && length(self$peers) > 0) {
        for (p in self$peers) {
          if (is.function(p$bytes)) {
            parts[[length(parts) + 1]] <- p$bytes()
          } else {
            parts[[length(parts) + 1]] <- raw()
          }
        }
      }
      do.call(c, parts)
    }
  )
)

#  Construct LeaveChatlistRequest from reader
# 
#  Reads chatlist and peers from a reader and returns a new instance.
#  @param reader Reader object providing tgread_object and read_int
#  @return LeaveChatlistRequest instance
#  @export
LeaveChatlistRequest$set("public", "from_reader", function(reader) {
  chatlist_obj <- reader$tgread_object()
  # read and ignore an int (as per original structure)
  .ignored <- reader$read_int()
  count <- reader$read_int()
  peers_vec <- vector("list", count)
  if (count > 0) {
    for (i in seq_len(count)) {
      peer_obj <- reader$tgread_object()
      peers_vec[[i]] <- peer_obj
    }
  }
  LeaveChatlistRequest$new(chatlist = chatlist_obj, peers = peers_vec)
})
