#  @title AcceptEncryptionRequest
#  @description Represents a request to accept encryption. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
AcceptEncryptionRequest <- R6::R6Class(
  "AcceptEncryptionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x3dbc0415,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x6d28a37a,
    #  @field peer Field.
    peer = NULL,
    #  @field gB Field.
    gB = NULL,
    #  @field keyFingerprint Field.
    keyFingerprint = NULL,

    #  @description Initialize the AcceptEncryptionRequest object.
    #  @param peer The input encrypted chat.
    #  @param gB The g_b bytes.
    #  @param keyFingerprint The key fingerprint.
    initialize = function(peer, gB, keyFingerprint) {
      self$peer <- peer
      self$gB <- gB
      self$keyFingerprint <- keyFingerprint
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "AcceptEncryptionRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "g_b" = self$gB,
        "key_fingerprint" = self$keyFingerprint
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x15, 0x04, 0xbc, 0x3d)),
        self$peer$bytes(),
        self$serialize_bytes(self$gB),
        pack("<q", self$keyFingerprint)
      )
    }
  ),
  lock_objects = FALSE
)

# @title fromReader
# @name AcceptEncryptionRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of AcceptEncryptionRequest.
AcceptEncryptionRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  gB <- reader$tgreadBytes()
  keyFingerprint <- reader$readLong()
  AcceptEncryptionRequest$new(peer = peer, gB = gB, keyFingerprint = keyFingerprint)
}

#  @title AcceptUrlAuthRequest
#  @description Represents a request to accept URL auth. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
AcceptUrlAuthRequest <- R6::R6Class(
  "AcceptUrlAuthRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xb12c7125,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x7765cb1e,
    #  @field writeAllowed Field.
    writeAllowed = NULL,
    #  @field peer Field.
    peer = NULL,
    #  @field msgId Field.
    msgId = NULL,
    #  @field buttonId Field.
    buttonId = NULL,
    #  @field url Field.
    url = NULL,

    #  @description Initialize the AcceptUrlAuthRequest object.
    #  @param writeAllowed Whether write is allowed (optional).
    #  @param peer The input peer (optional).
    #  @param msgId The message ID (optional).
    #  @param buttonId The button ID (optional).
    #  @param url The URL (optional).
    initialize = function(writeAllowed = NULL, peer = NULL, msgId = NULL, buttonId = NULL, url = NULL) {
      self$writeAllowed <- writeAllowed
      self$peer <- peer
      self$msgId <- msgId
      self$buttonId <- buttonId
      self$url <- url
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      if (!is.null(self$peer)) {
        self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "AcceptUrlAuthRequest",
        "write_allowed" = self$writeAllowed,
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "msg_id" = self$msgId,
        "button_id" = self$buttonId,
        "url" = self$url
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$writeAllowed) || !self$writeAllowed) 0 else 1) |
        (if (is.null(self$peer)) 0 else 2) |
        (if (is.null(self$msgId)) 0 else 2) |
        (if (is.null(self$buttonId)) 0 else 2) |
        (if (is.null(self$url)) 0 else 4)
      c(
        as.raw(c(0x25, 0x71, 0x2c, 0xb1)),
        pack("<I", flags),
        if (is.null(self$peer)) raw(0) else self$peer$bytes(),
        if (is.null(self$msgId)) raw(0) else pack("<i", self$msgId),
        if (is.null(self$buttonId)) raw(0) else pack("<i", self$buttonId),
        if (is.null(self$url)) raw(0) else self$serialize_bytes(self$url)
      )
    }
  ),
  lock_objects = FALSE
)

# @title fromReader
# @name AcceptUrlAuthRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of AcceptUrlAuthRequest.
AcceptUrlAuthRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  writeAllowed <- bitwAnd(flags, 1) != 0
  peer <- if (bitwAnd(flags, 2) != 0) reader$tgreadObject() else NULL
  msgId <- if (bitwAnd(flags, 2) != 0) reader$readInt() else NULL
  buttonId <- if (bitwAnd(flags, 2) != 0) reader$readInt() else NULL
  url <- if (bitwAnd(flags, 4) != 0) reader$tgreadString() else NULL
  AcceptUrlAuthRequest$new(writeAllowed = writeAllowed, peer = peer, msgId = msgId, buttonId = buttonId, url = url)
}

#  @title AddChatUserRequest
#  @description Represents a request to add a chat user. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
AddChatUserRequest <- R6::R6Class(
  "AddChatUserRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xcbc6d107,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x3dbe90a1,
    #  @field chatId Field.
    chatId = NULL,
    #  @field userId Field.
    userId = NULL,
    #  @field fwdLimit Field.
    fwdLimit = NULL,

    #  @description Initialize the AddChatUserRequest object.
    #  @param chatId The chat ID.
    #  @param userId The input user ID.
    #  @param fwdLimit The forward limit.
    initialize = function(chatId, userId, fwdLimit) {
      self$chatId <- chatId
      self$userId <- userId
      self$fwdLimit <- fwdLimit
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$userId <- utils$getInputUser(client$getInputEntity(self$userId))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "AddChatUserRequest",
        "chat_id" = self$chatId,
        "user_id" = if (inherits(self$userId, "TLObject")) self$userId$toDict() else self$userId,
        "fwd_limit" = self$fwdLimit
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x07, 0xd1, 0xc6, 0xcb)),
        pack("<q", self$chatId),
        self$userId$bytes(),
        pack("<i", self$fwdLimit)
      )
    }
  )
)

# @title fromReader
# @name AddChatUserRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of AddChatUserRequest.
AddChatUserRequest$fromReader <- function(reader) {
  chatId <- reader$readLong()
  userId <- reader$tgreadObject()
  fwdLimit <- reader$readInt()
  AddChatUserRequest$new(chatId = chatId, userId = userId, fwdLimit = fwdLimit)
}


#  @title AppendTodoListRequest
#  @description Represents a request to append a todo list. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
AppendTodoListRequest <- R6::R6Class(
  "AppendTodoListRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x21a61057,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the AppendTodoListRequest object.
    #  @param peer The input peer.
    #  @param msgId The message ID.
    #  @param list The list of todo items.
    initialize = function(peer, msgId, list) {
      self$peer <- peer
      self$msgId <- msgId
      self$list <- list
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "AppendTodoListRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "msg_id" = self$msgId,
        "list" = if (is.null(self$list)) list() else lapply(self$list, function(x) if (inherits(x, "TLObject")) x$toDict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x57, 0x10, 0xa6, 0x21)),
        self$peer$bytes(),
        pack("<i", self$msgId),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$list)), do.call(c, lapply(self$list, function(x) x$bytes()))
      )
    }
  )
)

# @title fromReader
# @name AppendTodoListRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of AppendTodoListRequest.
AppendTodoListRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  msgId <- reader$readInt()
  reader$readInt()
  list <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$tgreadObject()
    list <- c(list, x)
  }
  AppendTodoListRequest$new(peer = peer, msgId = msgId, list = list)
}

#  @title CheckChatInviteRequest
#  @description Represents a request to check a chat invite. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
CheckChatInviteRequest <- R6::R6Class(
  "CheckChatInviteRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x3eadb1bb,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x4561736,
    #  @field hash The invite hash.
    hash = NULL,

    #  @description Initialize the CheckChatInviteRequest object.
    #  @param hash The invite hash.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "CheckChatInviteRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xbb, 0xb1, 0xad, 0x3e)),
        self$serialize_bytes(self$hash)
      )
    }
  )
)

# @title fromReader
# @name CheckChatInviteRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of CheckChatInviteRequest.
CheckChatInviteRequest$fromReader <- function(reader) {
  hash <- reader$tgreadString()
  CheckChatInviteRequest$new(hash = hash)
}

#  @title CheckHistoryImportRequest
#  @description Represents a request to check history import. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
CheckHistoryImportRequest <- R6::R6Class(
  "CheckHistoryImportRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x43fe19f3,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x5bb2720b,

    #  @description Initialize the CheckHistoryImportRequest object.
    #  @param importHead The import head string.
    initialize = function(importHead) {
      self$importHead <- importHead
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "CheckHistoryImportRequest",
        "import_head" = self$importHead
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xf3, 0x19, 0xfe, 0x43)),
        self$serialize_bytes(self$importHead)
      )
    }
  )
)

# @title fromReader
# @name CheckHistoryImportRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of CheckHistoryImportRequest.
CheckHistoryImportRequest$fromReader <- function(reader) {
  importHead <- reader$tgreadString()
  CheckHistoryImportRequest$new(importHead = importHead)
}


#  @title CheckHistoryImportPeerRequest
#  @description Represents a request to check history import peer. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
CheckHistoryImportPeerRequest <- R6::R6Class(
  "CheckHistoryImportPeerRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x5dc60f03,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xb84bb337,

    #  @description Initialize the CheckHistoryImportPeerRequest object.
    #  @param peer The input peer.
    initialize = function(peer) {
      self$peer <- peer
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "CheckHistoryImportPeerRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x03, 0x0f, 0xc6, 0x5d)),
        self$peer$bytes()
      )
    }
  )
)

# @title fromReader
# @name CheckHistoryImportPeerRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of CheckHistoryImportPeerRequest.
CheckHistoryImportPeerRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  CheckHistoryImportPeerRequest$new(peer = peer)
}

#  @title CheckQuickReplyShortcutRequest
#  @description Represents a request to check quick reply shortcut. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
CheckQuickReplyShortcutRequest <- R6::R6Class(
  "CheckQuickReplyShortcutRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xf1d0fbd3,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the CheckQuickReplyShortcutRequest object.
    #  @param shortcut The shortcut string.
    initialize = function(shortcut) {
      self$shortcut <- shortcut
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "CheckQuickReplyShortcutRequest",
        "shortcut" = self$shortcut
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xd3, 0xfb, 0xd0, 0xf1)),
        self$serialize_bytes(self$shortcut)
      )
    }
  )
)

# @title fromReader
# @name CheckQuickReplyShortcutRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of CheckQuickReplyShortcutRequest.
CheckQuickReplyShortcutRequest$fromReader <- function(reader) {
  shortcut <- reader$tgreadString()
  CheckQuickReplyShortcutRequest$new(shortcut = shortcut)
}

#  @title ClearAllDraftsRequest
#  @description Represents a request to clear all drafts. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ClearAllDraftsRequest <- R6::R6Class(
  "ClearAllDraftsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x7e58ee9c,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list("_" = "ClearAllDraftsRequest")
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      as.raw(c(0x9c, 0xee, 0x58, 0x7e))
    }
  )
)

# @title fromReader
# @name ClearAllDraftsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ClearAllDraftsRequest.
ClearAllDraftsRequest$fromReader <- function(reader) {
  ClearAllDraftsRequest$new()
}


#  @title ClearRecentReactionsRequest
#  @description Represents a request to clear recent reactions. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ClearRecentReactionsRequest <- R6::R6Class(
  "ClearRecentReactionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x9dfeefb4,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list("_" = "ClearRecentReactionsRequest")
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      as.raw(c(0xb4, 0xef, 0xfe, 0x9d))
    }
  )
)

# @title fromReader
# @name ClearRecentReactionsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ClearRecentReactionsRequest.
ClearRecentReactionsRequest$fromReader <- function(reader) {
  ClearRecentReactionsRequest$new()
}

#  @title ClearRecentStickersRequest
#  @description Represents a request to clear recent stickers. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ClearRecentStickersRequest <- R6::R6Class(
  "ClearRecentStickersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x8999602d,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ClearRecentStickersRequest object.
    #  @param attached Whether to clear attached stickers (optional).
    initialize = function(attached = NULL) {
      self$attached <- attached
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ClearRecentStickersRequest",
        "attached" = self$attached
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (0L | (if (is.null(self$attached) || !self$attached) 0L else 1L))
      c(
        as.raw(c(0x2d, 0x60, 0x99, 0x89)),
        pack("<I", flags)
      )
    }
  )
)

# @title fromReader
# @name ClearRecentStickersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ClearRecentStickersRequest.
ClearRecentStickersRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  attached <- bitwAnd(flags, 1) != 0
  ClearRecentStickersRequest$new(attached = attached)
}

#  @title ClickSponsoredMessageRequest
#  @description Represents a request to click a sponsored message. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ClickSponsoredMessageRequest <- R6::R6Class(
  "ClickSponsoredMessageRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x8235057e,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ClickSponsoredMessageRequest object.
    #  @param media Whether media was clicked (optional).
    #  @param fullscreen Whether fullscreen was used (optional).
    #  @param randomId The random ID (optional, generated if not provided).
    initialize = function(media = NULL, fullscreen = NULL, randomId = NULL) {
      self$media <- media
      self$fullscreen <- fullscreen
      if (is.null(randomId)) {
        # Generate random ID similar to Python
        self$randomId <- as.integer(runif(1, min = -2^31, max = 2^31 - 1))
      } else {
        self$randomId <- randomId
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ClickSponsoredMessageRequest",
        "media" = self$media,
        "fullscreen" = self$fullscreen,
        "random_id" = self$randomId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$media) || !self$media) 0 else 1) |
        (if (is.null(self$fullscreen) || !self$fullscreen) 0 else 2)
      c(
        as.raw(c(0x7e, 0x05, 0x35, 0x82)),
        pack("<I", flags),
        self$serialize_bytes(self$randomId)
      )
    }
  )
)

# @title fromReader
# @name ClickSponsoredMessageRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ClickSponsoredMessageRequest.
ClickSponsoredMessageRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  media <- bitwAnd(flags, 1) != 0
  fullscreen <- bitwAnd(flags, 2) != 0
  randomId <- reader$tgreadBytes()
  ClickSponsoredMessageRequest$new(media = media, fullscreen = fullscreen, randomId = randomId)
}


#  @title CreateChatRequest
#  @description Represents a request to create a chat. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
CreateChatRequest <- R6::R6Class(
  "CreateChatRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x92ceddd4,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x3dbe90a1,

    #  @description Initialize the CreateChatRequest object.
    #  @param users The list of input users.
    #  @param title The chat title.
    #  @param ttlPeriod The optional TTL period.
    initialize = function(users, title, ttlPeriod = NULL) {
      self$users <- users
      self$title <- title
      self$ttlPeriod <- ttlPeriod
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      tmp <- list()
      for (x in self$users) {
        tmp <- c(tmp, utils$getInputUser(client$getInputEntity(x)))
      }
      self$users <- tmp
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "CreateChatRequest",
        "users" = if (is.null(self$users)) list() else lapply(self$users, function(x) if (inherits(x, "TLObject")) x$toDict() else x),
        "title" = self$title,
        "ttl_period" = self$ttlPeriod
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$ttlPeriod)) 0 else 1
      c(
        as.raw(c(0xd4, 0xdd, 0xce, 0x92)),
        pack("<I", flags),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$users)), do.call(c, lapply(self$users, function(x) x$bytes())),
        self$serialize_bytes(self$title),
        if (is.null(self$ttlPeriod)) raw(0) else pack("<i", self$ttlPeriod)
      )
    }
  )
)

# @title fromReader
# @name CreateChatRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of CreateChatRequest.
CreateChatRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  reader$readInt()
  users <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$tgreadObject()
    users <- c(users, x)
  }
  title <- reader$tgreadString()
  ttlPeriod <- if (bitwAnd(flags, 1) != 0) reader$readInt() else NULL
  CreateChatRequest$new(users = users, title = title, ttlPeriod = ttlPeriod)
}

#  @title DeleteChatRequest
#  @description Represents a request to delete a chat. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
DeleteChatRequest <- R6::R6Class(
  "DeleteChatRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x5bd0ee50,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the DeleteChatRequest object.
    #  @param chatId The chat ID.
    initialize = function(chatId) {
      self$chatId <- chatId
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DeleteChatRequest",
        "chat_id" = self$chatId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x50, 0xee, 0xd0, 0x5b)),
        pack("<q", self$chatId)
      )
    }
  )
)

# @title fromReader
# @name DeleteChatRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of DeleteChatRequest.
DeleteChatRequest$fromReader <- function(reader) {
  chatId <- reader$readLong()
  DeleteChatRequest$new(chatId = chatId)
}

#  @title DeleteChatUserRequest
#  @description Represents a request to delete a user from a chat. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
DeleteChatUserRequest <- R6::R6Class(
  "DeleteChatUserRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xa2185cab,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the DeleteChatUserRequest object.
    #  @param chatId The chat ID.
    #  @param userId The input user ID.
    #  @param revokeHistory Whether to revoke history (optional).
    initialize = function(chatId, userId, revokeHistory = NULL) {
      self$chatId <- chatId
      self$userId <- userId
      self$revokeHistory <- revokeHistory
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$userId <- utils$getInputUser(client$getInputEntity(self$userId))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DeleteChatUserRequest",
        "chat_id" = self$chatId,
        "user_id" = if (inherits(self$userId, "TLObject")) self$userId$toDict() else self$userId,
        "revoke_history" = self$revokeHistory
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xab, 0x5c, 0x18, 0xa2)),
        pack("<I", (0L | (if (is.null(self$revokeHistory) || !self$revokeHistory) 0L else 1L))),
        pack("<q", self$chatId),
        self$userId$bytes()
      )
    }
  )
)

# @title fromReader
# @name DeleteChatUserRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of DeleteChatUserRequest.
DeleteChatUserRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  revokeHistory <- bitwAnd(flags, 1) != 0
  chatId <- reader$readLong()
  userId <- reader$tgreadObject()
  DeleteChatUserRequest$new(chatId = chatId, userId = userId, revokeHistory = revokeHistory)
}


#  @title DeleteExportedChatInviteRequest
#  @description Represents a request to delete an exported chat invite. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
DeleteExportedChatInviteRequest <- R6::R6Class(
  "DeleteExportedChatInviteRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xd464a42b,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the DeleteExportedChatInviteRequest object.
    #  @param peer The input peer.
    #  @param link The invite link.
    initialize = function(peer, link) {
      self$peer <- peer
      self$link <- link
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DeleteExportedChatInviteRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "link" = self$link
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x2b, 0xa4, 0x64, 0xd4)),
        self$peer$bytes(),
        self$serialize_bytes(self$link)
      )
    }
  )
)

# @title fromReader
# @name DeleteExportedChatInviteRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of DeleteExportedChatInviteRequest.
DeleteExportedChatInviteRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  link <- reader$tgreadString()
  DeleteExportedChatInviteRequest$new(peer = peer, link = link)
}

#  @title DeleteFactCheckRequest
#  @description Represents a request to delete a fact check. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
DeleteFactCheckRequest <- R6::R6Class(
  "DeleteFactCheckRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xd1da940c,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the DeleteFactCheckRequest object.
    #  @param peer The input peer.
    #  @param msgId The message ID.
    initialize = function(peer, msgId) {
      self$peer <- peer
      self$msgId <- msgId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DeleteFactCheckRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "msg_id" = self$msgId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x0c, 0x94, 0xda, 0xd1)),
        self$peer$bytes(),
        pack("<i", self$msgId)
      )
    }
  )
)

# @title fromReader
# @name DeleteFactCheckRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of DeleteFactCheckRequest.
DeleteFactCheckRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  msgId <- reader$readInt()
  DeleteFactCheckRequest$new(peer = peer, msgId = msgId)
}

#  @title DeleteHistoryRequest
#  @description Represents a request to delete history. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
DeleteHistoryRequest <- R6::R6Class(
  "DeleteHistoryRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xb08f922a,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x2c49c116,

    #  @description Initialize the DeleteHistoryRequest object.
    #  @param peer The input peer.
    #  @param maxId The maximum ID.
    #  @param justClear Whether to just clear (optional).
    #  @param revoke Whether to revoke (optional).
    #  @param minDate The minimum date (optional).
    #  @param maxDate The maximum date (optional).
    initialize = function(peer, maxId, justClear = NULL, revoke = NULL, minDate = NULL, maxDate = NULL) {
      self$peer <- peer
      self$maxId <- maxId
      self$justClear <- justClear
      self$revoke <- revoke
      self$minDate <- minDate
      self$maxDate <- maxDate
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DeleteHistoryRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "max_id" = self$maxId,
        "just_clear" = self$justClear,
        "revoke" = self$revoke,
        "min_date" = self$minDate,
        "max_date" = self$maxDate
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$justClear) || !self$justClear) 0 else 1) |
        (if (is.null(self$revoke) || !self$revoke) 0 else 2) |
        (if (is.null(self$minDate)) 0 else 4) |
        (if (is.null(self$maxDate)) 0 else 8)
      c(
        as.raw(c(0x2a, 0x92, 0x8f, 0xb0)),
        pack("<I", flags),
        self$peer$bytes(),
        pack("<i", self$maxId),
        if (is.null(self$minDate)) raw(0) else self$serialize_datetime(self$minDate),
        if (is.null(self$maxDate)) raw(0) else self$serialize_datetime(self$maxDate)
      )
    }
  )
)

# @title fromReader
# @name DeleteHistoryRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of DeleteHistoryRequest.
DeleteHistoryRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  justClear <- bitwAnd(flags, 1) != 0
  revoke <- bitwAnd(flags, 2) != 0
  peer <- reader$tgreadObject()
  maxId <- reader$readInt()
  minDate <- if (bitwAnd(flags, 4) != 0) reader$tgreadDate() else NULL
  maxDate <- if (bitwAnd(flags, 8) != 0) reader$tgreadDate() else NULL
  DeleteHistoryRequest$new(peer = peer, maxId = maxId, justClear = justClear, revoke = revoke, minDate = minDate, maxDate = maxDate)
}


#  @title DeleteMessagesRequest
#  @description Represents a request to delete messages. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
DeleteMessagesRequest <- R6::R6Class(
  "DeleteMessagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xe58e95d2,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xced3c06e,

    #  @description Initialize the DeleteMessagesRequest object.
    #  @param id The list of message IDs.
    #  @param revoke Whether to revoke the messages (optional).
    initialize = function(id, revoke = NULL) {
      self$id <- id
      self$revoke <- revoke
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DeleteMessagesRequest",
        "id" = if (is.null(self$id)) list() else self$id,
        "revoke" = self$revoke
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (0L | (if (is.null(self$revoke) || !self$revoke) 0L else 1L))
      c(
        as.raw(c(0xd2, 0x95, 0x8e, 0xe5)),
        pack("<I", flags),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$id)), do.call(c, lapply(self$id, function(x) pack("<i", x)))
      )
    }
  )
)

# @title fromReader
# @name DeleteMessagesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of DeleteMessagesRequest.
DeleteMessagesRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  revoke <- bitwAnd(flags, 1) != 0
  reader$readInt()
  id <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$readInt()
    id <- c(id, x)
  }
  DeleteMessagesRequest$new(id = id, revoke = revoke)
}

#  @title DeletePhoneCallHistoryRequest
#  @description Represents a request to delete phone call history. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
DeletePhoneCallHistoryRequest <- R6::R6Class(
  "DeletePhoneCallHistoryRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xf9cbe409,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf817652e,

    #  @description Initialize the DeletePhoneCallHistoryRequest object.
    #  @param revoke Whether to revoke the history (optional).
    initialize = function(revoke = NULL) {
      self$revoke <- revoke
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DeletePhoneCallHistoryRequest",
        "revoke" = self$revoke
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (0L | (if (is.null(self$revoke) || !self$revoke) 0L else 1L))
      c(
        as.raw(c(0x09, 0xe4, 0xcb, 0xf9)),
        pack("<I", flags)
      )
    }
  )
)

# @title fromReader
# @name DeletePhoneCallHistoryRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of DeletePhoneCallHistoryRequest.
DeletePhoneCallHistoryRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  revoke <- bitwAnd(flags, 1) != 0
  DeletePhoneCallHistoryRequest$new(revoke = revoke)
}

#  @title DeleteQuickReplyMessagesRequest
#  @description Represents a request to delete quick reply messages. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
DeleteQuickReplyMessagesRequest <- R6::R6Class(
  "DeleteQuickReplyMessagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xe105e910,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the DeleteQuickReplyMessagesRequest object.
    #  @param shortcutId The shortcut ID.
    #  @param id The list of message IDs.
    initialize = function(shortcutId, id) {
      self$shortcutId <- shortcutId
      self$id <- id
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DeleteQuickReplyMessagesRequest",
        "shortcut_id" = self$shortcutId,
        "id" = if (is.null(self$id)) list() else self$id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x10, 0xe9, 0x05, 0xe1)),
        pack("<i", self$shortcutId),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$id)), do.call(c, lapply(self$id, function(x) pack("<i", x)))
      )
    }
  )
)

# @title fromReader
# @name DeleteQuickReplyMessagesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of DeleteQuickReplyMessagesRequest.
DeleteQuickReplyMessagesRequest$fromReader <- function(reader) {
  shortcutId <- reader$readInt()
  reader$readInt()
  id <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$readInt()
    id <- c(id, x)
  }
  DeleteQuickReplyMessagesRequest$new(shortcutId = shortcutId, id = id)
}


#  @title DeleteQuickReplyShortcutRequest
#  @description Represents a request to delete a quick reply shortcut. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
DeleteQuickReplyShortcutRequest <- R6::R6Class(
  "DeleteQuickReplyShortcutRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x3cc04740,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the DeleteQuickReplyShortcutRequest object.
    #  @param shortcutId The shortcut ID.
    initialize = function(shortcutId) {
      self$shortcutId <- shortcutId
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DeleteQuickReplyShortcutRequest",
        "shortcut_id" = self$shortcutId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x40, 0x47, 0xc0, 0x3c)),
        pack("<i", self$shortcutId)
      )
    }
  )
)

# @title fromReader
# @name DeleteQuickReplyShortcutRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of DeleteQuickReplyShortcutRequest.
DeleteQuickReplyShortcutRequest$fromReader <- function(reader) {
  shortcutId <- reader$readInt()
  DeleteQuickReplyShortcutRequest$new(shortcutId = shortcutId)
}

#  @title DeleteRevokedExportedChatInvitesRequest
#  @description Represents a request to delete revoked exported chat invites. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
DeleteRevokedExportedChatInvitesRequest <- R6::R6Class(
  "DeleteRevokedExportedChatInvitesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x56987bd5,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the DeleteRevokedExportedChatInvitesRequest object.
    #  @param peer The input peer.
    #  @param adminId The input admin user.
    initialize = function(peer, adminId) {
      self$peer <- peer
      self$adminId <- adminId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      self$adminId <- utils$getInputUser(client$getInputEntity(self$adminId))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DeleteRevokedExportedChatInvitesRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "admin_id" = if (inherits(self$adminId, "TLObject")) self$adminId$toDict() else self$adminId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xd5, 0x7b, 0x98, 0x56)),
        self$peer$bytes(),
        self$adminId$bytes()
      )
    }
  )
)

# @title fromReader
# @name DeleteRevokedExportedChatInvitesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of DeleteRevokedExportedChatInvitesRequest.
DeleteRevokedExportedChatInvitesRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  adminId <- reader$tgreadObject()
  DeleteRevokedExportedChatInvitesRequest$new(peer = peer, adminId = adminId)
}

#  @title DeleteSavedHistoryRequest
#  @description Represents a request to delete saved history. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
DeleteSavedHistoryRequest <- R6::R6Class(
  "DeleteSavedHistoryRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x4dc5085f,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x2c49c116,

    #  @description Initialize the DeleteSavedHistoryRequest object.
    #  @param peer The input peer.
    #  @param maxId The maximum ID.
    #  @param parentPeer The optional input peer.
    #  @param minDate The optional minimum date.
    #  @param maxDate The optional maximum date.
    initialize = function(peer, maxId, parentPeer = NULL, minDate = NULL, maxDate = NULL) {
      self$peer <- peer
      self$maxId <- maxId
      self$parentPeer <- parentPeer
      self$minDate <- minDate
      self$maxDate <- maxDate
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      if (!is.null(self$parentPeer)) {
        self$parentPeer <- utils$getInputPeer(client$getInputEntity(self$parentPeer))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DeleteSavedHistoryRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "max_id" = self$maxId,
        "parent_peer" = if (inherits(self$parentPeer, "TLObject")) self$parentPeer$toDict() else self$parentPeer,
        "min_date" = self$minDate,
        "max_date" = self$maxDate
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$parentPeer)) 0 else 1) |
        (if (is.null(self$minDate)) 0 else 4) |
        (if (is.null(self$maxDate)) 0 else 8)
      c(
        as.raw(c(0x5f, 0x08, 0xc5, 0x4d)),
        pack("<I", flags),
        if (is.null(self$parentPeer)) raw(0) else self$parentPeer$bytes(),
        self$peer$bytes(),
        pack("<i", self$maxId),
        if (is.null(self$minDate)) raw(0) else self$serialize_datetime(self$minDate),
        if (is.null(self$maxDate)) raw(0) else self$serialize_datetime(self$maxDate)
      )
    }
  )
)

# @title fromReader
# @name DeleteSavedHistoryRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of DeleteSavedHistoryRequest.
DeleteSavedHistoryRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  parentPeer <- if (bitwAnd(flags, 1) != 0) reader$tgreadObject() else NULL
  peer <- reader$tgreadObject()
  maxId <- reader$readInt()
  minDate <- if (bitwAnd(flags, 4) != 0) reader$tgreadDate() else NULL
  maxDate <- if (bitwAnd(flags, 8) != 0) reader$tgreadDate() else NULL
  DeleteSavedHistoryRequest$new(peer = peer, maxId = maxId, parentPeer = parentPeer, minDate = minDate, maxDate = maxDate)
}


#  @title DeleteScheduledMessagesRequest
#  @description Represents a request to delete scheduled messages. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
DeleteScheduledMessagesRequest <- R6::R6Class(
  "DeleteScheduledMessagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x59ae2b16,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the DeleteScheduledMessagesRequest object.
    #  @param peer The input peer.
    #  @param id The list of message IDs.
    initialize = function(peer, id) {
      self$peer <- peer
      self$id <- id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DeleteScheduledMessagesRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "id" = if (is.null(self$id)) list() else self$id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x16, 0x2b, 0xae, 0x59)),
        self$peer$bytes(),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$id)), do.call(c, lapply(self$id, function(x) pack("<i", x)))
      )
    }
  )
)

# @title fromReader
# @name DeleteScheduledMessagesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of DeleteScheduledMessagesRequest.
DeleteScheduledMessagesRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  reader$readInt()
  id <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$readInt()
    id <- c(id, x)
  }
  DeleteScheduledMessagesRequest$new(peer = peer, id = id)
}

#  @title DiscardEncryptionRequest
#  @description Represents a request to discard encryption. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
DiscardEncryptionRequest <- R6::R6Class(
  "DiscardEncryptionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xf393aea0,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the DiscardEncryptionRequest object.
    #  @param chatId The chat ID.
    #  @param deleteHistory Whether to delete history (optional).
    initialize = function(chatId, deleteHistory = NULL) {
      self$chatId <- chatId
      self$deleteHistory <- deleteHistory
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DiscardEncryptionRequest",
        "chat_id" = self$chatId,
        "delete_history" = self$deleteHistory
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xa0, 0xae, 0x93, 0xf3)),
        pack("<I", (0L | (if (is.null(self$deleteHistory) || !self$deleteHistory) 0L else 1L))),
        pack("<i", self$chatId)
      )
    }
  )
)

# @title fromReader
# @name DiscardEncryptionRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of DiscardEncryptionRequest.
DiscardEncryptionRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  deleteHistory <- bitwAnd(flags, 1L) != 0L
  chatId <- reader$readInt()
  DiscardEncryptionRequest$new(chatId = chatId, deleteHistory = deleteHistory)
}

#  @title EditChatAboutRequest
#  @description Represents a request to edit chat about. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
EditChatAboutRequest <- R6::R6Class(
  "EditChatAboutRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xdef60797,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the EditChatAboutRequest object.
    #  @param peer The input peer.
    #  @param about The about text.
    initialize = function(peer, about) {
      self$peer <- peer
      self$about <- about
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "EditChatAboutRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "about" = self$about
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x97, 0x07, 0xf6, 0xde)),
        self$peer$bytes(),
        self$serialize_bytes(self$about)
      )
    }
  )
)

# @title fromReader
# @name EditChatAboutRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of EditChatAboutRequest.
EditChatAboutRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  about <- reader$tgreadString()
  EditChatAboutRequest$new(peer = peer, about = about)
}


#  @title EditChatAdminRequest
#  @description Represents a request to edit chat admin. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
EditChatAdminRequest <- R6::R6Class(
  "EditChatAdminRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xa85bd1c2,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the EditChatAdminRequest object.
    #  @param chatId The chat ID.
    #  @param userId The input user ID.
    #  @param isAdmin Whether the user is admin.
    initialize = function(chatId, userId, isAdmin) {
      self$chatId <- chatId
      self$userId <- userId
      self$isAdmin <- isAdmin
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$userId <- utils$getInputUser(client$getInputEntity(self$userId))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "EditChatAdminRequest",
        "chat_id" = self$chatId,
        "user_id" = if (inherits(self$userId, "TLObject")) self$userId$toDict() else self$userId,
        "is_admin" = self$isAdmin
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xc2, 0xd1, 0x5b, 0xa8)),
        pack("<q", self$chatId),
        self$userId$bytes(),
        if (self$isAdmin) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  )
)

# @title fromReader
# @name EditChatAdminRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of EditChatAdminRequest.
EditChatAdminRequest$fromReader <- function(reader) {
  chatId <- reader$readLong()
  userId <- reader$tgreadObject()
  isAdmin <- reader$tgreadBool()
  EditChatAdminRequest$new(chatId = chatId, userId = userId, isAdmin = isAdmin)
}

#  @title EditChatDefaultBannedRightsRequest
#  @description Represents a request to edit chat default banned rights. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
EditChatDefaultBannedRightsRequest <- R6::R6Class(
  "EditChatDefaultBannedRightsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xa5866b41,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the EditChatDefaultBannedRightsRequest object.
    #  @param peer The input peer.
    #  @param bannedRights The chat banned rights.
    initialize = function(peer, bannedRights) {
      self$peer <- peer
      self$bannedRights <- bannedRights
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "EditChatDefaultBannedRightsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "banned_rights" = if (inherits(self$bannedRights, "TLObject")) self$bannedRights$toDict() else self$bannedRights
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x41, 0x6b, 0x86, 0xa5)),
        self$peer$bytes(),
        self$bannedRights$bytes()
      )
    }
  )
)

# @title fromReader
# @name EditChatDefaultBannedRightsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of EditChatDefaultBannedRightsRequest.
EditChatDefaultBannedRightsRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  bannedRights <- reader$tgreadObject()
  EditChatDefaultBannedRightsRequest$new(peer = peer, bannedRights = bannedRights)
}

#  @title EditChatPhotoRequest
#  @description Represents a request to edit chat photo. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
EditChatPhotoRequest <- R6::R6Class(
  "EditChatPhotoRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x35ddd674,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the EditChatPhotoRequest object.
    #  @param chatId The chat ID.
    #  @param photo The input chat photo.
    initialize = function(chatId, photo) {
      self$chatId <- chatId
      self$photo <- photo
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$photo <- utils$getInputChatPhoto(self$photo)
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "EditChatPhotoRequest",
        "chat_id" = self$chatId,
        "photo" = if (inherits(self$photo, "TLObject")) self$photo$toDict() else self$photo
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x74, 0xd6, 0xdd, 0x35)),
        pack("<q", self$chatId),
        self$photo$bytes()
      )
    }
  )
)

# @title fromReader
# @name EditChatPhotoRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of EditChatPhotoRequest.
EditChatPhotoRequest$fromReader <- function(reader) {
  chatId <- reader$readLong()
  photo <- reader$tgreadObject()
  EditChatPhotoRequest$new(chatId = chatId, photo = photo)
}


#  @title EditChatTitleRequest
#  @description Represents a request to edit a chat title. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
EditChatTitleRequest <- R6::R6Class(
  "EditChatTitleRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x73783ffd,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the EditChatTitleRequest object.
    #  @param chatId The chat ID.
    #  @param title The new title.
    initialize = function(chatId, title) {
      self$chatId <- chatId
      self$title <- title
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "EditChatTitleRequest",
        "chat_id" = self$chatId,
        "title" = self$title
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xfd, 0x3f, 0x78, 0x73)),
        pack("<q", self$chatId),
        self$serialize_bytes(self$title)
      )
    }
  )
)

# @title fromReader
# @name EditChatTitleRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of EditChatTitleRequest.
EditChatTitleRequest$fromReader <- function(reader) {
  chatId <- reader$readLong()
  title <- reader$tgreadString()
  EditChatTitleRequest$new(chatId = chatId, title = title)
}

#  @title EditExportedChatInviteRequest
#  @description Represents a request to edit an exported chat invite. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
EditExportedChatInviteRequest <- R6::R6Class(
  "EditExportedChatInviteRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xbdca2f75,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x82dcd4ca,

    #  @description Initialize the EditExportedChatInviteRequest object.
    #  @param peer The input peer.
    #  @param link The invite link.
    #  @param revoked Whether the invite is revoked (optional).
    #  @param expireDate The expiration date (optional).
    #  @param usageLimit The usage limit (optional).
    #  @param requestNeeded Whether request is needed (optional).
    #  @param title The title (optional).
    initialize = function(peer, link, revoked = NULL, expireDate = NULL, usageLimit = NULL, requestNeeded = NULL, title = NULL) {
      self$peer <- peer
      self$link <- link
      self$revoked <- revoked
      self$expireDate <- expireDate
      self$usageLimit <- usageLimit
      self$requestNeeded <- requestNeeded
      self$title <- title
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "EditExportedChatInviteRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "link" = self$link,
        "revoked" = self$revoked,
        "expire_date" = self$expireDate,
        "usage_limit" = self$usageLimit,
        "request_needed" = self$requestNeeded,
        "title" = self$title
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$revoked) || !self$revoked) 0 else 4) |
        (if (is.null(self$expireDate)) 0 else 1) |
        (if (is.null(self$usageLimit)) 0 else 2) |
        (if (is.null(self$requestNeeded)) 0 else 8) |
        (if (is.null(self$title)) 0 else 16)
      c(
        as.raw(c(0x75, 0x2f, 0xca, 0xbd)),
        pack("<I", flags),
        self$peer$bytes(),
        self$serialize_bytes(self$link),
        if (is.null(self$expireDate)) raw(0) else self$serialize_datetime(self$expireDate),
        if (is.null(self$usageLimit)) raw(0) else pack("<i", self$usageLimit),
        if (is.null(self$requestNeeded)) raw(0) else if (self$requestNeeded) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc)),
        if (is.null(self$title)) raw(0) else self$serialize_bytes(self$title)
      )
    }
  )
)

# @title fromReader
# @name EditExportedChatInviteRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of EditExportedChatInviteRequest.
EditExportedChatInviteRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  revoked <- bitwAnd(flags, 4) != 0
  peer <- reader$tgreadObject()
  link <- reader$tgreadString()
  expireDate <- if (bitwAnd(flags, 1) != 0) reader$tgreadDate() else NULL
  usageLimit <- if (bitwAnd(flags, 2) != 0) reader$readInt() else NULL
  requestNeeded <- if (bitwAnd(flags, 8) != 0) reader$tgreadBool() else NULL
  title <- if (bitwAnd(flags, 16) != 0) reader$tgreadString() else NULL
  EditExportedChatInviteRequest$new(peer = peer, link = link, revoked = revoked, expireDate = expireDate, usageLimit = usageLimit, requestNeeded = requestNeeded, title = title)
}

#  @title EditFactCheckRequest
#  @description Represents a request to edit a fact check. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
EditFactCheckRequest <- R6::R6Class(
  "EditFactCheckRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x589ee75,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the EditFactCheckRequest object.
    #  @param peer The input peer.
    #  @param msgId The message ID.
    #  @param text The text with entities.
    initialize = function(peer, msgId, text) {
      self$peer <- peer
      self$msgId <- msgId
      self$text <- text
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "EditFactCheckRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "msg_id" = self$msgId,
        "text" = if (inherits(self$text, "TLObject")) self$text$toDict() else self$text
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x75, 0xee, 0x89, 0x05)),
        self$peer$bytes(),
        pack("<i", self$msgId),
        self$text$bytes()
      )
    }
  )
)

# @title fromReader
# @name EditFactCheckRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of EditFactCheckRequest.
EditFactCheckRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  msgId <- reader$readInt()
  text <- reader$tgreadObject()
  EditFactCheckRequest$new(peer = peer, msgId = msgId, text = text)
}


#  @title EditInlineBotMessageRequest
#  @description Represents a request to edit an inline bot message. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
EditInlineBotMessageRequest <- R6::R6Class(
  "EditInlineBotMessageRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x83557dba,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the EditInlineBotMessageRequest object.
    #  @param id The input bot inline message ID.
    #  @param noWebpage Whether to disable webpage preview (optional).
    #  @param invertMedia Whether to invert media (optional).
    #  @param message The message text (optional).
    #  @param media The input media (optional).
    #  @param replyMarkup The reply markup (optional).
    #  @param entities The message entities (optional).
    initialize = function(id, noWebpage = NULL, invertMedia = NULL, message = NULL, media = NULL, replyMarkup = NULL, entities = NULL) {
      self$id <- id
      self$noWebpage <- noWebpage
      self$invertMedia <- invertMedia
      self$message <- message
      self$media <- media
      self$replyMarkup <- replyMarkup
      self$entities <- entities
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      if (!is.null(self$media)) {
        self$media <- utils$getInputMedia(self$media)
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "EditInlineBotMessageRequest",
        "id" = if (inherits(self$id, "TLObject")) self$id$toDict() else self$id,
        "no_webpage" = self$noWebpage,
        "invert_media" = self$invertMedia,
        "message" = self$message,
        "media" = if (inherits(self$media, "TLObject")) self$media$toDict() else self$media,
        "reply_markup" = if (inherits(self$replyMarkup, "TLObject")) self$replyMarkup$toDict() else self$replyMarkup,
        "entities" = if (is.null(self$entities)) list() else lapply(self$entities, function(x) if (inherits(x, "TLObject")) x$toDict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$noWebpage) || !self$noWebpage) 0 else 2) |
        (if (is.null(self$invertMedia) || !self$invertMedia) 0 else 65536) |
        (if (is.null(self$message)) 0 else 2048) |
        (if (is.null(self$media)) 0 else 16384) |
        (if (is.null(self$replyMarkup)) 0 else 4) |
        (if (is.null(self$entities)) 0 else 8)
      c(
        as.raw(c(0xba, 0x7d, 0x55, 0x83)),
        pack("<I", flags),
        self$id$bytes(),
        if (is.null(self$message)) raw(0) else self$serialize_bytes(self$message),
        if (is.null(self$media)) raw(0) else self$media$bytes(),
        if (is.null(self$replyMarkup)) raw(0) else self$replyMarkup$bytes(),
        if (is.null(self$entities)) raw(0) else c(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$entities)), do.call(c, lapply(self$entities, function(x) x$bytes())))
      )
    }
  )
)

# @title fromReader
# @name EditInlineBotMessageRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of EditInlineBotMessageRequest.
EditInlineBotMessageRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  noWebpage <- bitwAnd(flags, 2) != 0
  invertMedia <- bitwAnd(flags, 65536) != 0
  id <- reader$tgreadObject()
  message <- if (bitwAnd(flags, 2048) != 0) reader$tgreadString() else NULL
  media <- if (bitwAnd(flags, 16384) != 0) reader$tgreadObject() else NULL
  replyMarkup <- if (bitwAnd(flags, 4) != 0) reader$tgreadObject() else NULL
  entities <- if (bitwAnd(flags, 8) != 0) {
    reader$readInt()
    lapply(1:reader$readInt(), function(i) reader$tgreadObject())
  } else {
    NULL
  }
  EditInlineBotMessageRequest$new(id = id, noWebpage = noWebpage, invertMedia = invertMedia, message = message, media = media, replyMarkup = replyMarkup, entities = entities)
}

#  @title EditMessageRequest
#  @description Represents a request to edit a message. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
EditMessageRequest <- R6::R6Class(
  "EditMessageRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xdfd14005,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the EditMessageRequest object.
    #  @param peer The input peer.
    #  @param id The message ID.
    #  @param noWebpage Whether to disable webpage preview (optional).
    #  @param invertMedia Whether to invert media (optional).
    #  @param message The message text (optional).
    #  @param media The input media (optional).
    #  @param replyMarkup The reply markup (optional).
    #  @param entities The message entities (optional).
    #  @param scheduleDate The schedule date (optional).
    #  @param quickReplyShortcutId The quick reply shortcut ID (optional).
    initialize = function(peer, id, noWebpage = NULL, invertMedia = NULL, message = NULL, media = NULL, replyMarkup = NULL, entities = NULL, scheduleDate = NULL, quickReplyShortcutId = NULL) {
      self$peer <- peer
      self$id <- id
      self$noWebpage <- noWebpage
      self$invertMedia <- invertMedia
      self$message <- message
      self$media <- media
      self$replyMarkup <- replyMarkup
      self$entities <- entities
      self$scheduleDate <- scheduleDate
      self$quickReplyShortcutId <- quickReplyShortcutId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      if (!is.null(self$media)) {
        self$media <- utils$getInputMedia(self$media)
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "EditMessageRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "id" = self$id,
        "no_webpage" = self$noWebpage,
        "invert_media" = self$invertMedia,
        "message" = self$message,
        "media" = if (inherits(self$media, "TLObject")) self$media$toDict() else self$media,
        "reply_markup" = if (inherits(self$replyMarkup, "TLObject")) self$replyMarkup$toDict() else self$replyMarkup,
        "entities" = if (is.null(self$entities)) list() else lapply(self$entities, function(x) if (inherits(x, "TLObject")) x$toDict() else x),
        "schedule_date" = self$scheduleDate,
        "quick_reply_shortcut_id" = self$quickReplyShortcutId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$noWebpage) || !self$noWebpage) 0 else 2) |
        (if (is.null(self$invertMedia) || !self$invertMedia) 0 else 65536) |
        (if (is.null(self$message)) 0 else 2048) |
        (if (is.null(self$media)) 0 else 16384) |
        (if (is.null(self$replyMarkup)) 0 else 4) |
        (if (is.null(self$entities)) 0 else 8) |
        (if (is.null(self$scheduleDate)) 0 else 32768) |
        (if (is.null(self$quickReplyShortcutId)) 0 else 131072)
      c(
        as.raw(c(0x05, 0x40, 0xd1, 0xdf)),
        pack("<I", flags),
        self$peer$bytes(),
        pack("<i", self$id),
        if (is.null(self$message)) raw(0) else self$serialize_bytes(self$message),
        if (is.null(self$media)) raw(0) else self$media$bytes(),
        if (is.null(self$replyMarkup)) raw(0) else self$replyMarkup$bytes(),
        if (is.null(self$entities)) raw(0) else c(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$entities)), do.call(c, lapply(self$entities, function(x) x$bytes()))),
        if (is.null(self$scheduleDate)) raw(0) else self$serialize_datetime(self$scheduleDate),
        if (is.null(self$quickReplyShortcutId)) raw(0) else pack("<i", self$quickReplyShortcutId)
      )
    }
  )
)

# @title fromReader
# @name EditMessageRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of EditMessageRequest.
EditMessageRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  noWebpage <- bitwAnd(flags, 2) != 0
  invertMedia <- bitwAnd(flags, 65536) != 0
  peer <- reader$tgreadObject()
  id <- reader$readInt()
  message <- if (bitwAnd(flags, 2048) != 0) reader$tgreadString() else NULL
  media <- if (bitwAnd(flags, 16384) != 0) reader$tgreadObject() else NULL
  replyMarkup <- if (bitwAnd(flags, 4) != 0) reader$tgreadObject() else NULL
  entities <- if (bitwAnd(flags, 8) != 0) {
    reader$readInt()
    lapply(1:reader$readInt(), function(i) reader$tgreadObject())
  } else {
    NULL
  }
  scheduleDate <- if (bitwAnd(flags, 32768) != 0) reader$tgreadDate() else NULL
  quickReplyShortcutId <- if (bitwAnd(flags, 131072) != 0) reader$readInt() else NULL
  EditMessageRequest$new(peer = peer, id = id, noWebpage = noWebpage, invertMedia = invertMedia, message = message, media = media, replyMarkup = replyMarkup, entities = entities, scheduleDate = scheduleDate, quickReplyShortcutId = quickReplyShortcutId)
}


#  @title EditQuickReplyShortcutRequest
#  @description Represents a request to edit a quick reply shortcut. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
EditQuickReplyShortcutRequest <- R6::R6Class(
  "EditQuickReplyShortcutRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x5c003cef,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the EditQuickReplyShortcutRequest object.
    #  @param shortcutId The shortcut ID.
    #  @param shortcut The shortcut string.
    initialize = function(shortcutId, shortcut) {
      self$shortcutId <- shortcutId
      self$shortcut <- shortcut
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "EditQuickReplyShortcutRequest",
        "shortcut_id" = self$shortcutId,
        "shortcut" = self$shortcut
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xef, 0x3c, 0x00, 0x5c)),
        pack("<i", self$shortcutId),
        self$serialize_bytes(self$shortcut)
      )
    }
  )
)

# @title fromReader
# @name EditQuickReplyShortcutRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of EditQuickReplyShortcutRequest.
EditQuickReplyShortcutRequest$fromReader <- function(reader) {
  shortcutId <- reader$readInt()
  shortcut <- reader$tgreadString()
  EditQuickReplyShortcutRequest$new(shortcutId = shortcutId, shortcut = shortcut)
}

#  @title ExportChatInviteRequest
#  @description Represents a request to export a chat invite. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ExportChatInviteRequest <- R6::R6Class(
  "ExportChatInviteRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xa455de90,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xb4748a58,

    #  @description Initialize the ExportChatInviteRequest object.
    #  @param peer The input peer.
    #  @param legacyRevokePermanent Whether to revoke permanently (legacy).
    #  @param requestNeeded Whether request is needed.
    #  @param expireDate The expiration date.
    #  @param usageLimit The usage limit.
    #  @param title The title.
    #  @param subscriptionPricing The subscription pricing.
    initialize = function(peer, legacyRevokePermanent = NULL, requestNeeded = NULL, expireDate = NULL, usageLimit = NULL, title = NULL, subscriptionPricing = NULL) {
      self$peer <- peer
      self$legacyRevokePermanent <- legacyRevokePermanent
      self$requestNeeded <- requestNeeded
      self$expireDate <- expireDate
      self$usageLimit <- usageLimit
      self$title <- title
      self$subscriptionPricing <- subscriptionPricing
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ExportChatInviteRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "legacy_revoke_permanent" = self$legacyRevokePermanent,
        "request_needed" = self$requestNeeded,
        "expire_date" = self$expireDate,
        "usage_limit" = self$usageLimit,
        "title" = self$title,
        "subscription_pricing" = if (inherits(self$subscriptionPricing, "TLObject")) self$subscriptionPricing$toDict() else self$subscriptionPricing
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$legacyRevokePermanent) || !self$legacyRevokePermanent) 0 else 4) |
        (if (is.null(self$requestNeeded) || !self$requestNeeded) 0 else 8) |
        (if (is.null(self$expireDate)) 0 else 1) |
        (if (is.null(self$usageLimit)) 0 else 2) |
        (if (is.null(self$title) || !nchar(self$title)) 0 else 16) |
        (if (is.null(self$subscriptionPricing)) 0 else 32)
      c(
        as.raw(c(0x90, 0xde, 0x55, 0xa4)),
        pack("<I", flags),
        self$peer$bytes(),
        if (is.null(self$expireDate)) raw(0) else self$serialize_datetime(self$expireDate),
        if (is.null(self$usageLimit)) raw(0) else pack("<i", self$usageLimit),
        if (is.null(self$title) || !nchar(self$title)) raw(0) else self$serialize_bytes(self$title),
        if (is.null(self$subscriptionPricing)) raw(0) else self$subscriptionPricing$bytes()
      )
    }
  )
)

# @title fromReader
# @name ExportChatInviteRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ExportChatInviteRequest.
ExportChatInviteRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  legacyRevokePermanent <- bitwAnd(flags, 4) != 0
  requestNeeded <- bitwAnd(flags, 8) != 0
  peer <- reader$tgreadObject()
  expireDate <- if (bitwAnd(flags, 1) != 0) reader$tgreadDate() else NULL
  usageLimit <- if (bitwAnd(flags, 2) != 0) reader$readInt() else NULL
  title <- if (bitwAnd(flags, 16) != 0) reader$tgreadString() else NULL
  subscriptionPricing <- if (bitwAnd(flags, 32) != 0) reader$tgreadObject() else NULL
  ExportChatInviteRequest$new(peer = peer, legacyRevokePermanent = legacyRevokePermanent, requestNeeded = requestNeeded, expireDate = expireDate, usageLimit = usageLimit, title = title, subscriptionPricing = subscriptionPricing)
}


#  @title FaveStickerRequest
#  @description Represents a request to fave or unfave a sticker. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
FaveStickerRequest <- R6::R6Class(
  "FaveStickerRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xb9ffc55b,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the FaveStickerRequest object.
    #  @param id The input document.
    #  @param unfave Whether to unfave the sticker.
    initialize = function(id, unfave) {
      self$id <- id
      self$unfave <- unfave
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$id <- utils$getInputDocument(self$id)
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "FaveStickerRequest",
        "id" = if (inherits(self$id, "TLObject")) self$id$toDict() else self$id,
        "unfave" = self$unfave
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x5b, 0xc5, 0xff, 0xb9)),
        self$id$bytes(),
        if (self$unfave) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  )
)

# @title fromReader
# @name FaveStickerRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of FaveStickerRequest.
FaveStickerRequest$fromReader <- function(reader) {
  id <- reader$tgreadObject()
  unfave <- reader$tgreadBool()
  FaveStickerRequest$new(id = id, unfave = unfave)
}

#  @title ForwardMessagesRequest
#  @description Represents a request to forward messages. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ForwardMessagesRequest <- R6::R6Class(
  "ForwardMessagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x978928ca,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the ForwardMessagesRequest object.
    #  @param fromPeer The input peer to forward from.
    #  @param id The list of message IDs.
    #  @param toPeer The input peer to forward to.
    #  @param silent Whether to send silently (optional).
    #  @param background Whether to send in background (optional).
    #  @param withMyScore Whether to include my score (optional).
    #  @param dropAuthor Whether to drop author (optional).
    #  @param dropMediaCaptions Whether to drop media captions (optional).
    #  @param noforwards Whether to disable forwards (optional).
    #  @param allowPaidFloodskip Whether to allow paid flood skip (optional).
    #  @param randomId The list of random IDs (optional).
    #  @param topMsgId The top message ID (optional).
    #  @param replyTo The reply to (optional).
    #  @param scheduleDate The schedule date (optional).
    #  @param sendAs The send as peer (optional).
    #  @param quickReplyShortcut The quick reply shortcut (optional).
    #  @param videoTimestamp The video timestamp (optional).
    #  @param allowPaidStars The allow paid stars (optional).
    #  @param suggestedPost The suggested post (optional).
    initialize = function(fromPeer, id, toPeer, silent = NULL, background = NULL, withMyScore = NULL, dropAuthor = NULL, dropMediaCaptions = NULL, noforwards = NULL, allowPaidFloodskip = NULL, randomId = NULL, topMsgId = NULL, replyTo = NULL, scheduleDate = NULL, sendAs = NULL, quickReplyShortcut = NULL, videoTimestamp = NULL, allowPaidStars = NULL, suggestedPost = NULL) {
      self$fromPeer <- fromPeer
      self$id <- id
      self$toPeer <- toPeer
      self$silent <- silent
      self$background <- background
      self$withMyScore <- withMyScore
      self$dropAuthor <- dropAuthor
      self$dropMediaCaptions <- dropMediaCaptions
      self$noforwards <- noforwards
      self$allowPaidFloodskip <- allowPaidFloodskip
      self$randomId <- randomId
      if (is.null(self$randomId)) {
        # Generate random IDs similar to Python
        self$randomId <- replicate(length(id), {
          # In R, use runif or similar; approximating int.from_bytes(os.urandom(8), 'big', signed=True)
          as.integer(runif(1, min = -2^63, max = 2^63 - 1))
        })
      }
      self$topMsgId <- topMsgId
      self$replyTo <- replyTo
      self$scheduleDate <- scheduleDate
      self$sendAs <- sendAs
      self$quickReplyShortcut <- quickReplyShortcut
      self$videoTimestamp <- videoTimestamp
      self$allowPaidStars <- allowPaidStars
      self$suggestedPost <- suggestedPost
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$fromPeer <- utils$getInputPeer(client$getInputEntity(self$fromPeer))
      self$toPeer <- utils$getInputPeer(client$getInputEntity(self$toPeer))
      if (!is.null(self$sendAs)) {
        self$sendAs <- utils$getInputPeer(client$getInputEntity(self$sendAs))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ForwardMessagesRequest",
        "from_peer" = if (inherits(self$fromPeer, "TLObject")) self$fromPeer$toDict() else self$fromPeer,
        "id" = if (is.null(self$id)) list() else self$id,
        "to_peer" = if (inherits(self$toPeer, "TLObject")) self$toPeer$toDict() else self$toPeer,
        "silent" = self$silent,
        "background" = self$background,
        "with_my_score" = self$withMyScore,
        "drop_author" = self$dropAuthor,
        "drop_media_captions" = self$dropMediaCaptions,
        "noforwards" = self$noforwards,
        "allow_paid_floodskip" = self$allowPaidFloodskip,
        "random_id" = if (is.null(self$randomId)) list() else self$randomId,
        "top_msg_id" = self$topMsgId,
        "reply_to" = if (inherits(self$replyTo, "TLObject")) self$replyTo$toDict() else self$replyTo,
        "schedule_date" = self$scheduleDate,
        "send_as" = if (inherits(self$sendAs, "TLObject")) self$sendAs$toDict() else self$sendAs,
        "quick_reply_shortcut" = if (inherits(self$quickReplyShortcut, "TLObject")) self$quickReplyShortcut$toDict() else self$quickReplyShortcut,
        "video_timestamp" = self$videoTimestamp,
        "allow_paid_stars" = self$allowPaidStars,
        "suggested_post" = if (inherits(self$suggestedPost, "TLObject")) self$suggestedPost$toDict() else self$suggestedPost
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$silent) || !self$silent) 0 else 32) |
        (if (is.null(self$background) || !self$background) 0 else 64) |
        (if (is.null(self$withMyScore) || !self$withMyScore) 0 else 256) |
        (if (is.null(self$dropAuthor) || !self$dropAuthor) 0 else 2048) |
        (if (is.null(self$dropMediaCaptions) || !self$dropMediaCaptions) 0 else 4096) |
        (if (is.null(self$noforwards) || !self$noforwards) 0 else 16384) |
        (if (is.null(self$allowPaidFloodskip) || !self$allowPaidFloodskip) 0 else 524288) |
        (if (is.null(self$topMsgId)) 0 else 512) |
        (if (is.null(self$replyTo)) 0 else 4194304) |
        (if (is.null(self$scheduleDate)) 0 else 1024) |
        (if (is.null(self$sendAs)) 0 else 8192) |
        (if (is.null(self$quickReplyShortcut)) 0 else 131072) |
        (if (is.null(self$videoTimestamp)) 0 else 1048576) |
        (if (is.null(self$allowPaidStars)) 0 else 2097152) |
        (if (is.null(self$suggestedPost)) 0 else 8388608)
      c(
        as.raw(c(0xca, 0x28, 0x89, 0x97)),
        pack("<I", flags),
        self$fromPeer$bytes(),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$id)), do.call(c, lapply(self$id, function(x) pack("<i", x))),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$randomId)), do.call(c, lapply(self$randomId, function(x) pack("<q", x))),
        self$toPeer$bytes(),
        if (is.null(self$topMsgId)) raw(0) else pack("<i", self$topMsgId),
        if (is.null(self$replyTo)) raw(0) else self$replyTo$bytes(),
        if (is.null(self$scheduleDate)) raw(0) else self$serialize_datetime(self$scheduleDate),
        if (is.null(self$sendAs)) raw(0) else self$sendAs$bytes(),
        if (is.null(self$quickReplyShortcut)) raw(0) else self$quickReplyShortcut$bytes(),
        if (is.null(self$videoTimestamp)) raw(0) else pack("<i", self$videoTimestamp),
        if (is.null(self$allowPaidStars)) raw(0) else pack("<q", self$allowPaidStars),
        if (is.null(self$suggestedPost)) raw(0) else self$suggestedPost$bytes()
      )
    }
  )
)

# @title fromReader
# @name ForwardMessagesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ForwardMessagesRequest.
ForwardMessagesRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  silent <- bitwAnd(flags, 32) != 0
  background <- bitwAnd(flags, 64) != 0
  withMyScore <- bitwAnd(flags, 256) != 0
  dropAuthor <- bitwAnd(flags, 2048) != 0
  dropMediaCaptions <- bitwAnd(flags, 4096) != 0
  noforwards <- bitwAnd(flags, 16384) != 0
  allowPaidFloodskip <- bitwAnd(flags, 524288) != 0
  fromPeer <- reader$tgreadObject()
  reader$readInt()
  id <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$readInt()
    id <- c(id, x)
  }
  reader$readInt()
  randomId <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$readLong()
    randomId <- c(randomId, x)
  }
  toPeer <- reader$tgreadObject()
  topMsgId <- if (bitwAnd(flags, 512) != 0) reader$readInt() else NULL
  replyTo <- if (bitwAnd(flags, 4194304) != 0) reader$tgreadObject() else NULL
  scheduleDate <- if (bitwAnd(flags, 1024) != 0) reader$tgreadDate() else NULL
  sendAs <- if (bitwAnd(flags, 8192) != 0) reader$tgreadObject() else NULL
  quickReplyShortcut <- if (bitwAnd(flags, 131072) != 0) reader$tgreadObject() else NULL
  videoTimestamp <- if (bitwAnd(flags, 1048576) != 0) reader$readInt() else NULL
  allowPaidStars <- if (bitwAnd(flags, 2097152) != 0) reader$readLong() else NULL
  suggestedPost <- if (bitwAnd(flags, 8388608) != 0) reader$tgreadObject() else NULL
  ForwardMessagesRequest$new(fromPeer = fromPeer, id = id, toPeer = toPeer, silent = silent, background = background, withMyScore = withMyScore, dropAuthor = dropAuthor, dropMediaCaptions = dropMediaCaptions, noforwards = noforwards, allowPaidFloodskip = allowPaidFloodskip, randomId = randomId, topMsgId = topMsgId, replyTo = replyTo, scheduleDate = scheduleDate, sendAs = sendAs, quickReplyShortcut = quickReplyShortcut, videoTimestamp = videoTimestamp, allowPaidStars = allowPaidStars, suggestedPost = suggestedPost)
}

#  @title GetAdminsWithInvitesRequest
#  @description Represents a request to get admins with invites. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetAdminsWithInvitesRequest <- R6::R6Class(
  "GetAdminsWithInvitesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x3920e6ef,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8f5bad2b,

    #  @description Initialize the GetAdminsWithInvitesRequest object.
    #  @param peer The input peer.
    initialize = function(peer) {
      self$peer <- peer
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetAdminsWithInvitesRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xef, 0xe6, 0x20, 0x39)),
        self$peer$bytes()
      )
    }
  )
)

# @title fromReader
# @name GetAdminsWithInvitesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetAdminsWithInvitesRequest.
GetAdminsWithInvitesRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  GetAdminsWithInvitesRequest$new(peer = peer)
}

#  @title GetAllDraftsRequest
#  @description Represents a request to get all drafts. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetAllDraftsRequest <- R6::R6Class(
  "GetAllDraftsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x6a3f8d65,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list("_" = "GetAllDraftsRequest")
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      as.raw(c(0x65, 0x8d, 0x3f, 0x6a))
    }
  )
)

# @title fromReader
# @name GetAllDraftsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetAllDraftsRequest.
GetAllDraftsRequest$fromReader <- function(reader) {
  GetAllDraftsRequest$new()
}

#  @title GetAllStickersRequest
#  @description Represents a request to get all stickers. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetAllStickersRequest <- R6::R6Class(
  "GetAllStickersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xb8a0a1a8,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x45834829,

    #  @description Initialize the GetAllStickersRequest object.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetAllStickersRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xa8, 0xa1, 0xa0, 0xb8)),
        pack("<q", self$hash)
      )
    }
  ),
  lock_objects = FALSE
)

# @title fromReader
# @name GetAllStickersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetAllStickersRequest.
GetAllStickersRequest$fromReader <- function(reader) {
  hash <- reader$readLong()
  GetAllStickersRequest$new(hash = hash)
}


#  @title GetArchivedStickersRequest
#  @description Represents a request to get archived stickers. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetArchivedStickersRequest <- R6::R6Class(
  "GetArchivedStickersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x57f17692,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x7296d771,

    #  @description Initialize the GetArchivedStickersRequest object.
    #  @param offsetId The offset ID.
    #  @param limit The limit value.
    #  @param masks Whether to include masks (optional).
    #  @param emojis Whether to include emojis (optional).
    initialize = function(offsetId, limit, masks = NULL, emojis = NULL) {
      self$offsetId <- offsetId
      self$limit <- limit
      self$masks <- masks
      self$emojis <- emojis
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetArchivedStickersRequest",
        "offset_id" = self$offsetId,
        "limit" = self$limit,
        "masks" = self$masks,
        "emojis" = self$emojis
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- bitwOr(
        if (is.null(self$masks) || !self$masks) 0L else 1L,
        if (is.null(self$emojis) || !self$emojis) 0L else 2L
      )
      c(
        as.raw(c(0x92, 0x76, 0xf1, 0x57)),
        pack("<I", flags),
        pack("<q", self$offsetId),
        pack("<i", self$limit)
      )
    }
  )
)

# @title fromReader
# @name GetArchivedStickersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetArchivedStickersRequest.
GetArchivedStickersRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  masks <- bitwAnd(flags, 1) != 0
  emojis <- bitwAnd(flags, 2) != 0
  offsetId <- reader$readLong()
  limit <- reader$readInt()
  GetArchivedStickersRequest$new(offsetId = offsetId, limit = limit, masks = masks, emojis = emojis)
}

#  @title GetAttachMenuBotRequest
#  @description Represents a request to get attach menu bot. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetAttachMenuBotRequest <- R6::R6Class(
  "GetAttachMenuBotRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x77216192,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xdb33883d,

    #  @description Initialize the GetAttachMenuBotRequest object.
    #  @param bot The input bot user.
    initialize = function(bot) {
      self$bot <- bot
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$bot <- utils$getInputUser(client$getInputEntity(self$bot))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetAttachMenuBotRequest",
        "bot" = if (inherits(self$bot, "TLObject")) self$bot$toDict() else self$bot
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x92, 0x61, 0x21, 0x77)),
        self$bot$bytes()
      )
    }
  )
)

# @title fromReader
# @name GetAttachMenuBotRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetAttachMenuBotRequest.
GetAttachMenuBotRequest$fromReader <- function(reader) {
  bot <- reader$tgreadObject()
  GetAttachMenuBotRequest$new(bot = bot)
}

#  @title GetAttachMenuBotsRequest
#  @description Represents a request to get attach menu bots. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetAttachMenuBotsRequest <- R6::R6Class(
  "GetAttachMenuBotsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x16fcc2cb,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x842e23da,

    #  @description Initialize the GetAttachMenuBotsRequest object.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetAttachMenuBotsRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xcb, 0xc2, 0xfc, 0x16)),
        pack("<q", self$hash)
      )
    }
  ),
  lock_objects = FALSE
)

# @title fromReader
# @name GetAttachMenuBotsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetAttachMenuBotsRequest.
GetAttachMenuBotsRequest$fromReader <- function(reader) {
  hash <- reader$readLong()
  GetAttachMenuBotsRequest$new(hash = hash)
}

#  @title GetAttachedStickersRequest
#  @description Represents a request to get attached stickers. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetAttachedStickersRequest <- R6::R6Class(
  "GetAttachedStickersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xcc5b67cc,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xcc125f6b,

    #  @description Initialize the GetAttachedStickersRequest object.
    #  @param media The input stickered media.
    initialize = function(media) {
      self$media <- media
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetAttachedStickersRequest",
        "media" = if (inherits(self$media, "TLObject")) self$media$toDict() else self$media
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xcc, 0x67, 0x5b, 0xcc)),
        self$media$bytes()
      )
    }
  )
)

# @title fromReader
# @name GetAttachedStickersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetAttachedStickersRequest.
GetAttachedStickersRequest$fromReader <- function(reader) {
  media <- reader$tgreadObject()
  GetAttachedStickersRequest$new(media = media)
}


#  @title GetAvailableEffectsRequest
#  @description Represents a request to get available effects. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetAvailableEffectsRequest <- R6::R6Class(
  "GetAvailableEffectsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xdea20a39,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x4470d5bd,

    #  @description Initialize the GetAvailableEffectsRequest object.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetAvailableEffectsRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xde, 0xa2, 0x0a, 0x39)),
        pack("<i", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetAvailableEffectsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetAvailableEffectsRequest.
GetAvailableEffectsRequest$fromReader <- function(reader) {
  hash <- reader$readInt()
  GetAvailableEffectsRequest$new(hash = hash)
}

#  @title GetAvailableReactionsRequest
#  @description Represents a request to get available reactions. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetAvailableReactionsRequest <- R6::R6Class(
  "GetAvailableReactionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x18dea0ac,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xe426ad82,

    #  @description Initialize the GetAvailableReactionsRequest object.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetAvailableReactionsRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x18, 0xde, 0xa0, 0xac)),
        pack("<i", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetAvailableReactionsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetAvailableReactionsRequest.
GetAvailableReactionsRequest$fromReader <- function(reader) {
  hash <- reader$readInt()
  GetAvailableReactionsRequest$new(hash = hash)
}

#  @title GetBotAppRequest
#  @description Represents a request to get bot app. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetBotAppRequest <- R6::R6Class(
  "GetBotAppRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x34fdc5c3,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8f7243a7,

    #  @description Initialize the GetBotAppRequest object.
    #  @param app The input bot app.
    #  @param hash The hash value.
    initialize = function(app, hash) {
      self$app <- app
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetBotAppRequest",
        "app" = if (inherits(self$app, "TLObject")) self$app$toDict() else self$app,
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x34, 0xfd, 0xc5, 0xc3)),
        self$app$bytes(),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetBotAppRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetBotAppRequest.
GetBotAppRequest$fromReader <- function(reader) {
  app <- reader$tgreadObject()
  hash <- reader$readLong()
  GetBotAppRequest$new(app = app, hash = hash)
}

#  @title GetBotCallbackAnswerRequest
#  @description Represents a request to get bot callback answer. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetBotCallbackAnswerRequest <- R6::R6Class(
  "GetBotCallbackAnswerRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x9342ca07,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x6c4dd18c,

    #  @description Initialize the GetBotCallbackAnswerRequest object.
    #  @param peer The input peer.
    #  @param msgId The message ID.
    #  @param game Whether it's a game (optional).
    #  @param data The data bytes (optional).
    #  @param password The input check password SRP (optional).
    initialize = function(peer, msgId, game = NULL, data = NULL, password = NULL) {
      self$peer <- peer
      self$msgId <- msgId
      self$game <- game
      self$data <- data
      self$password <- password
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetBotCallbackAnswerRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "msg_id" = self$msgId,
        "game" = self$game,
        "data" = self$data,
        "password" = if (inherits(self$password, "TLObject")) self$password$toDict() else self$password
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$game) || !self$game) 0 else 2) |
        (if (is.null(self$data) || !length(self$data)) 0 else 1) |
        (if (is.null(self$password)) 0 else 4)
      c(
        as.raw(c(0x93, 0x42, 0xca, 0x07)),
        pack("<I", flags),
        self$peer$bytes(),
        pack("<i", self$msgId),
        if (is.null(self$data) || !length(self$data)) raw(0) else self$serialize_bytes(self$data),
        if (is.null(self$password)) raw(0) else self$password$bytes()
      )
    }
  )
)

# @title fromReader
# @name GetBotCallbackAnswerRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetBotCallbackAnswerRequest.
GetBotCallbackAnswerRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  game <- bitwAnd(flags, 2) != 0
  peer <- reader$tgreadObject()
  msgId <- reader$readInt()
  data <- if (bitwAnd(flags, 1) != 0) reader$tgreadBytes() else NULL
  password <- if (bitwAnd(flags, 4) != 0) reader$tgreadObject() else NULL
  GetBotCallbackAnswerRequest$new(peer = peer, msgId = msgId, game = game, data = data, password = password)
}


#  @title GetChatInviteImportersRequest
#  @description Represents a request to get chat invite importers. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetChatInviteImportersRequest <- R6::R6Class(
  "GetChatInviteImportersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xdf04dd4e,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd9bc8aa6,

    #  @description Initialize the GetChatInviteImportersRequest object.
    #  @param peer The input peer.
    #  @param offsetDate The offset date (optional).
    #  @param offsetUser The offset user.
    #  @param limit The limit value.
    #  @param requested Whether requested (optional).
    #  @param subscriptionExpired Whether subscription expired (optional).
    #  @param link The link string (optional).
    #  @param q The query string (optional).
    initialize = function(peer, offsetDate = NULL, offsetUser, limit, requested = NULL, subscriptionExpired = NULL, link = NULL, q = NULL) {
      self$peer <- peer
      self$offsetDate <- offsetDate
      self$offsetUser <- offsetUser
      self$limit <- limit
      self$requested <- requested
      self$subscriptionExpired <- subscriptionExpired
      self$link <- link
      self$q <- q
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      self$offsetUser <- utils$getInputUser(client$getInputEntity(self$offsetUser))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetChatInviteImportersRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "offset_date" = self$offsetDate,
        "offset_user" = if (inherits(self$offsetUser, "TLObject")) self$offsetUser$toDict() else self$offsetUser,
        "limit" = self$limit,
        "requested" = self$requested,
        "subscription_expired" = self$subscriptionExpired,
        "link" = self$link,
        "q" = self$q
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$requested) || !self$requested) 0 else 1) |
        (if (is.null(self$subscriptionExpired) || !self$subscriptionExpired) 0 else 8) |
        (if (is.null(self$link) || !nchar(self$link)) 0 else 2) |
        (if (is.null(self$q) || !nchar(self$q)) 0 else 4)
      c(
        as.raw(c(0xdf, 0x04, 0xdd, 0x4e)),
        pack("<I", flags),
        self$peer$bytes(),
        if (is.null(self$link) || !nchar(self$link)) raw(0) else self$serialize_bytes(self$link),
        if (is.null(self$q) || !nchar(self$q)) raw(0) else self$serialize_bytes(self$q),
        self$serialize_datetime(self$offsetDate),
        self$offsetUser$bytes(),
        pack("<i", self$limit)
      )
    }
  )
)

# @title fromReader
# @name GetChatInviteImportersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetChatInviteImportersRequest.
GetChatInviteImportersRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  requested <- bitwAnd(flags, 1) != 0
  subscriptionExpired <- bitwAnd(flags, 8) != 0
  peer <- reader$tgreadObject()
  link <- if (bitwAnd(flags, 2) != 0) reader$tgreadString() else NULL
  q <- if (bitwAnd(flags, 4) != 0) reader$tgreadString() else NULL
  offsetDate <- reader$tgreadDate()
  offsetUser <- reader$tgreadObject()
  limit <- reader$readInt()
  GetChatInviteImportersRequest$new(peer = peer, offsetDate = offsetDate, offsetUser = offsetUser, limit = limit, requested = requested, subscriptionExpired = subscriptionExpired, link = link, q = q)
}

#  @title GetChatsRequest
#  @description Represents a request to get chats. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetChatsRequest <- R6::R6Class(
  "GetChatsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x49e9528f,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x99d5cb14,

    #  @description Initialize the GetChatsRequest object.
    #  @param id The list of chat IDs.
    initialize = function(id) {
      self$id <- id
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetChatsRequest",
        "id" = if (is.null(self$id)) list() else self$id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x49, 0xe9, 0x52, 0x8f)),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)),
        pack("<i", length(self$id)),
        do.call(c, lapply(self$id, function(x) pack("<q", x)))
      )
    }
  )
)

# @title fromReader
# @name GetChatsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetChatsRequest.
GetChatsRequest$fromReader <- function(reader) {
  reader$readInt()
  id <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$readLong()
    id <- c(id, x)
  }
  GetChatsRequest$new(id = id)
}

#  @title GetCommonChatsRequest
#  @description Represents a request to get common chats. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetCommonChatsRequest <- R6::R6Class(
  "GetCommonChatsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xe40ca104,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x99d5cb14,

    #  @description Initialize the GetCommonChatsRequest object.
    #  @param userId The input user ID.
    #  @param maxId The maximum ID.
    #  @param limit The limit value.
    initialize = function(userId, maxId, limit) {
      self$userId <- userId
      self$maxId <- maxId
      self$limit <- limit
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$userId <- utils$getInputUser(client$getInputEntity(self$userId))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetCommonChatsRequest",
        "user_id" = if (inherits(self$userId, "TLObject")) self$userId$toDict() else self$userId,
        "max_id" = self$maxId,
        "limit" = self$limit
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xe4, 0x0c, 0xa1, 0x04)),
        self$userId$bytes(),
        pack("<q", self$maxId),
        pack("<i", self$limit)
      )
    }
  )
)

# @title fromReader
# @name GetCommonChatsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetCommonChatsRequest.
GetCommonChatsRequest$fromReader <- function(reader) {
  userId <- reader$tgreadObject()
  maxId <- reader$readLong()
  limit <- reader$readInt()
  GetCommonChatsRequest$new(userId = userId, maxId = maxId, limit = limit)
}


#  @title GetCustomEmojiDocumentsRequest
#  @description Represents a request to get custom emoji documents. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetCustomEmojiDocumentsRequest <- R6::R6Class(
  "GetCustomEmojiDocumentsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xd9ab0f54,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xcc590e08,

    #  @description Initialize the GetCustomEmojiDocumentsRequest object.
    #  @param documentId The list of document IDs.
    initialize = function(documentId) {
      self$documentId <- documentId
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetCustomEmojiDocumentsRequest",
        "document_id" = if (is.null(self$documentId)) list() else self$documentId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xd9, 0xab, 0x0f, 0x54)),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        pack("<i", length(self$documentId)),
        do.call(c, lapply(self$documentId, function(x) pack("<q", x)))
      )
    }
  )
)

# @title fromReader
# @name GetCustomEmojiDocumentsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetCustomEmojiDocumentsRequest.
GetCustomEmojiDocumentsRequest$fromReader <- function(reader) {
  reader$readInt()
  documentId <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$readLong()
    documentId <- c(documentId, x)
  }
  GetCustomEmojiDocumentsRequest$new(documentId = documentId)
}

#  @title GetDefaultHistoryTTLRequest
#  @description Represents a request to get default history TTL. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetDefaultHistoryTTLRequest <- R6::R6Class(
  "GetDefaultHistoryTTLRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x658b7188,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf00d3367,

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list("_" = "GetDefaultHistoryTTLRequest")
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      as.raw(c(0x65, 0x8b, 0x71, 0x88))
    }
  )
)

# @title fromReader
# @name GetDefaultHistoryTTLRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetDefaultHistoryTTLRequest.
GetDefaultHistoryTTLRequest$fromReader <- function(reader) {
  GetDefaultHistoryTTLRequest$new()
}

#  @title GetDefaultTagReactionsRequest
#  @description Represents a request to get default tag reactions. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetDefaultTagReactionsRequest <- R6::R6Class(
  "GetDefaultTagReactionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xbdf93428,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xadc38324,

    #  @description Initialize the GetDefaultTagReactionsRequest object.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetDefaultTagReactionsRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xbd, 0xf9, 0x34, 0x28)),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetDefaultTagReactionsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetDefaultTagReactionsRequest.
GetDefaultTagReactionsRequest$fromReader <- function(reader) {
  hash <- reader$readLong()
  GetDefaultTagReactionsRequest$new(hash = hash)
}

#  @title GetDhConfigRequest
#  @description Represents a request to get DH config. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetDhConfigRequest <- R6::R6Class(
  "GetDhConfigRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x26cf8950,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xe488ed8b,

    #  @description Initialize the GetDhConfigRequest object.
    #  @param version The version.
    #  @param randomLength The random length.
    initialize = function(version, randomLength) {
      self$version <- version
      self$randomLength <- randomLength
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetDhConfigRequest",
        "version" = self$version,
        "random_length" = self$randomLength
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x26, 0xcf, 0x89, 0x50)),
        pack("<i", self$version),
        pack("<i", self$randomLength)
      )
    }
  )
)

# @title fromReader
# @name GetDhConfigRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetDhConfigRequest.
GetDhConfigRequest$fromReader <- function(reader) {
  version <- reader$readInt()
  randomLength <- reader$readInt()
  GetDhConfigRequest$new(version = version, randomLength = randomLength)
}


#  @title GetDialogFiltersRequest
#  @description Represents a request to get dialog filters. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetDialogFiltersRequest <- R6::R6Class(
  "GetDialogFiltersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xefd48c89,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xa5fff1b7,

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list("_" = "GetDialogFiltersRequest")
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      as.raw(c(0xef, 0xd4, 0x8c, 0x89))
    }
  )
)

# @title fromReader
# @name GetDialogFiltersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetDialogFiltersRequest.
GetDialogFiltersRequest$fromReader <- function(reader) {
  GetDialogFiltersRequest$new()
}

#  @title GetDialogUnreadMarksRequest
#  @description Represents a request to get dialog unread marks. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetDialogUnreadMarksRequest <- R6::R6Class(
  "GetDialogUnreadMarksRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x21202222,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xbec64ad9,

    #  @description Initialize the GetDialogUnreadMarksRequest object.
    #  @param parentPeer The optional input peer.
    initialize = function(parentPeer = NULL) {
      self$parentPeer <- parentPeer
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      if (!is.null(self$parentPeer)) {
        self$parentPeer <- utils$getInputPeer(client$getInputEntity(self$parentPeer))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetDialogUnreadMarksRequest",
        "parent_peer" = if (inherits(self$parentPeer, "TLObject")) self$parentPeer$toDict() else self$parentPeer
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$parentPeer)) 0 else 1
      c(
        as.raw(c(0x21, 0x20, 0x22, 0x22)),
        pack("<I", flags),
        if (is.null(self$parentPeer)) raw(0) else self$parentPeer$bytes()
      )
    }
  )
)

# @title fromReader
# @name GetDialogUnreadMarksRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetDialogUnreadMarksRequest.
GetDialogUnreadMarksRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  parentPeer <- if (bitwAnd(flags, 1) != 0) reader$tgreadObject() else NULL
  GetDialogUnreadMarksRequest$new(parentPeer = parentPeer)
}

#  @title GetDialogsRequest
#  @description Represents a request to get dialogs. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetDialogsRequest <- R6::R6Class(
  "GetDialogsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xa0f4cb4f,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xe1b52ee,

    #  @description Initialize the GetDialogsRequest object.
    #  @param offsetDate The offset date.
    #  @param offsetId The offset ID.
    #  @param offsetPeer The offset peer.
    #  @param limit The limit value.
    #  @param hash The hash value.
    #  @param excludePinned Whether to exclude pinned dialogs.
    #  @param folderId The folder ID.
    initialize = function(offsetDate, offsetId, offsetPeer, limit, hash, excludePinned = NULL, folderId = NULL) {
      self$offsetDate <- offsetDate
      self$offsetId <- offsetId
      self$offsetPeer <- offsetPeer
      self$limit <- limit
      self$hash <- hash
      self$excludePinned <- excludePinned
      self$folderId <- folderId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$offsetPeer <- utils$getInputPeer(client$getInputEntity(self$offsetPeer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetDialogsRequest",
        "offset_date" = self$offsetDate,
        "offset_id" = self$offsetId,
        "offset_peer" = if (inherits(self$offsetPeer, "TLObject")) self$offsetPeer$toDict() else self$offsetPeer,
        "limit" = self$limit,
        "hash" = self$hash,
        "exclude_pinned" = self$excludePinned,
        "folder_id" = self$folderId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$excludePinned) || !self$excludePinned) 0 else 1) |
        (if (is.null(self$folderId)) 0 else 2)
      c(
        as.raw(c(0xa0, 0xf4, 0xcb, 0x4f)),
        pack("<I", flags),
        if (is.null(self$folderId)) raw(0) else pack("<i", self$folderId),
        self$serialize_datetime(self$offsetDate),
        pack("<i", self$offsetId),
        self$offsetPeer$bytes(),
        pack("<i", self$limit),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetDialogsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetDialogsRequest.
GetDialogsRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  excludePinned <- bitwAnd(flags, 1) != 0
  folderId <- if (bitwAnd(flags, 2) != 0) reader$readInt() else NULL
  offsetDate <- reader$tgreadDate()
  offsetId <- reader$readInt()
  offsetPeer <- reader$tgreadObject()
  limit <- reader$readInt()
  hash <- reader$readLong()
  GetDialogsRequest$new(offsetDate = offsetDate, offsetId = offsetId, offsetPeer = offsetPeer, limit = limit, hash = hash, excludePinned = excludePinned, folderId = folderId)
}


#  @title GetDiscussionMessageRequest
#  @description Represents a request to get discussion message. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetDiscussionMessageRequest <- R6::R6Class(
  "GetDiscussionMessageRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x446972fd,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x53f8e3e8,

    #  @description Initialize the GetDiscussionMessageRequest object.
    #  @param peer The input peer.
    #  @param msgId The message ID.
    initialize = function(peer, msgId) {
      self$peer <- peer
      self$msgId <- msgId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetDiscussionMessageRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "msg_id" = self$msgId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xfd, 0x72, 0x69, 0x44)),
        self$peer$bytes(),
        pack("<i", self$msgId)
      )
    }
  )
)

# @title fromReader
# @name GetDiscussionMessageRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetDiscussionMessageRequest.
GetDiscussionMessageRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  msgId <- reader$readInt()
  GetDiscussionMessageRequest$new(peer = peer, msgId = msgId)
}

#  @title GetDocumentByHashRequest
#  @description Represents a request to get document by hash. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetDocumentByHashRequest <- R6::R6Class(
  "GetDocumentByHashRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xb1f2061f,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x211fe820,

    #  @description Initialize the GetDocumentByHashRequest object.
    #  @param sha256 The SHA256 hash bytes.
    #  @param size The size.
    #  @param mimeType The MIME type.
    initialize = function(sha256, size, mimeType) {
      self$sha256 <- sha256
      self$size <- size
      self$mimeType <- mimeType
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetDocumentByHashRequest",
        "sha256" = self$sha256,
        "size" = self$size,
        "mime_type" = self$mimeType
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x1f, 0x06, 0xf2, 0xb1)),
        self$serialize_bytes(self$sha256),
        pack("<q", self$size),
        self$serialize_bytes(self$mimeType)
      )
    }
  )
)

# @title fromReader
# @name GetDocumentByHashRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetDocumentByHashRequest.
GetDocumentByHashRequest$fromReader <- function(reader) {
  sha256 <- reader$tgreadBytes()
  size <- reader$readLong()
  mimeType <- reader$tgreadString()
  GetDocumentByHashRequest$new(sha256 = sha256, size = size, mimeType = mimeType)
}

#  @title GetEmojiGroupsRequest
#  @description Represents a request to get emoji groups. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetEmojiGroupsRequest <- R6::R6Class(
  "GetEmojiGroupsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x7488ce5b,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x7eca55d9,

    #  @description Initialize the GetEmojiGroupsRequest object.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetEmojiGroupsRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x5b, 0xce, 0x88, 0x74)),
        pack("<i", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetEmojiGroupsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetEmojiGroupsRequest.
GetEmojiGroupsRequest$fromReader <- function(reader) {
  hash <- reader$readInt()
  GetEmojiGroupsRequest$new(hash = hash)
}

#  @title GetEmojiKeywordsRequest
#  @description Represents a request to get emoji keywords. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetEmojiKeywordsRequest <- R6::R6Class(
  "GetEmojiKeywordsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x35a0e062,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd279c672,

    #  @description Initialize the GetEmojiKeywordsRequest object.
    #  @param langCode The language code.
    initialize = function(langCode) {
      self$langCode <- langCode
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetEmojiKeywordsRequest",
        "lang_code" = self$langCode
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x62, 0xe0, 0xa0, 0x35)),
        self$serialize_bytes(self$langCode)
      )
    }
  )
)

# @title fromReader
# @name GetEmojiKeywordsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetEmojiKeywordsRequest.
GetEmojiKeywordsRequest$fromReader <- function(reader) {
  langCode <- reader$tgreadString()
  GetEmojiKeywordsRequest$new(langCode = langCode)
}


#  @title GetEmojiKeywordsDifferenceRequest
#  @description Represents a request to get emoji keywords difference. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetEmojiKeywordsDifferenceRequest <- R6::R6Class(
  "GetEmojiKeywordsDifferenceRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x1508b6af,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd279c672,

    #  @description Initialize the GetEmojiKeywordsDifferenceRequest object.
    #  @param langCode The language code.
    #  @param fromVersion The version to get difference from.
    initialize = function(langCode, fromVersion) {
      self$langCode <- langCode
      self$fromVersion <- fromVersion
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetEmojiKeywordsDifferenceRequest",
        "lang_code" = self$langCode,
        "from_version" = self$fromVersion
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xaf, 0xb6, 0x08, 0x15)),
        self$serialize_bytes(self$langCode),
        pack("<i", self$fromVersion)
      )
    }
  )
)

# @title fromReader
# @name GetEmojiKeywordsDifferenceRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetEmojiKeywordsDifferenceRequest.
GetEmojiKeywordsDifferenceRequest$fromReader <- function(reader) {
  langCode <- reader$tgreadString()
  fromVersion <- reader$readInt()
  GetEmojiKeywordsDifferenceRequest$new(langCode = langCode, fromVersion = fromVersion)
}

#  @title GetEmojiKeywordsLanguagesRequest
#  @description Represents a request to get emoji keywords languages. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetEmojiKeywordsLanguagesRequest <- R6::R6Class(
  "GetEmojiKeywordsLanguagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x4e9963b2,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xe795d387,

    #  @description Initialize the GetEmojiKeywordsLanguagesRequest object.
    #  @param langCodes The list of language codes.
    initialize = function(langCodes) {
      self$langCodes <- langCodes
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetEmojiKeywordsLanguagesRequest",
        "lang_codes" = if (is.null(self$langCodes)) list() else self$langCodes
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xb2, 0x63, 0x99, 0x4e)),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)),
        pack("<i", length(self$langCodes)),
        do.call(c, lapply(self$langCodes, function(x) self$serialize_bytes(x)))
      )
    }
  )
)

# @title fromReader
# @name GetEmojiKeywordsLanguagesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetEmojiKeywordsLanguagesRequest.
GetEmojiKeywordsLanguagesRequest$fromReader <- function(reader) {
  reader$readInt()
  langCodes <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$tgreadString()
    langCodes <- c(langCodes, x)
  }
  GetEmojiKeywordsLanguagesRequest$new(langCodes = langCodes)
}

#  @title GetEmojiProfilePhotoGroupsRequest
#  @description Represents a request to get emoji profile photo groups. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetEmojiProfilePhotoGroupsRequest <- R6::R6Class(
  "GetEmojiProfilePhotoGroupsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x21a548f3,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x7eca55d9,

    #  @description Initialize the GetEmojiProfilePhotoGroupsRequest object.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetEmojiProfilePhotoGroupsRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xf3, 0x48, 0xa5, 0x21)),
        pack("<i", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetEmojiProfilePhotoGroupsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetEmojiProfilePhotoGroupsRequest.
GetEmojiProfilePhotoGroupsRequest$fromReader <- function(reader) {
  hash <- reader$readInt()
  GetEmojiProfilePhotoGroupsRequest$new(hash = hash)
}

#  @title GetEmojiStatusGroupsRequest
#  @description Represents a request to get emoji status groups. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetEmojiStatusGroupsRequest <- R6::R6Class(
  "GetEmojiStatusGroupsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x2ecd56cd,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x7eca55d9,

    #  @description Initialize the GetEmojiStatusGroupsRequest object.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetEmojiStatusGroupsRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xcd, 0x56, 0xcd, 0x2e)),
        pack("<i", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetEmojiStatusGroupsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetEmojiStatusGroupsRequest.
GetEmojiStatusGroupsRequest$fromReader <- function(reader) {
  hash <- reader$readInt()
  GetEmojiStatusGroupsRequest$new(hash = hash)
}


#  @title GetEmojiStickerGroupsRequest
#  @description Represents a request to get emoji sticker groups. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetEmojiStickerGroupsRequest <- R6::R6Class(
  "GetEmojiStickerGroupsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x1dd840f5,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x7eca55d9,

    #  @description Initialize the GetEmojiStickerGroupsRequest object.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetEmojiStickerGroupsRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xf5, 0x40, 0xd8, 0x1d)),
        pack("<i", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetEmojiStickerGroupsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetEmojiStickerGroupsRequest.
GetEmojiStickerGroupsRequest$fromReader <- function(reader) {
  hash <- reader$readInt()
  GetEmojiStickerGroupsRequest$new(hash = hash)
}

#  @title GetEmojiStickersRequest
#  @description Represents a request to get emoji stickers. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetEmojiStickersRequest <- R6::R6Class(
  "GetEmojiStickersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xfbfca18f,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x45834829,

    #  @description Initialize the GetEmojiStickersRequest object.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetEmojiStickersRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x8f, 0xa1, 0xfc, 0xfb)),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetEmojiStickersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetEmojiStickersRequest.
GetEmojiStickersRequest$fromReader <- function(reader) {
  hash <- reader$readLong()
  GetEmojiStickersRequest$new(hash = hash)
}

#  @title GetEmojiURLRequest
#  @description Represents a request to get emoji URL. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetEmojiURLRequest <- R6::R6Class(
  "GetEmojiURLRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xd5b10c26,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x1fa08a19,

    #  @description Initialize the GetEmojiURLRequest object.
    #  @param langCode The language code.
    initialize = function(langCode) {
      self$langCode <- langCode
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetEmojiURLRequest",
        "lang_code" = self$langCode
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x26, 0x0c, 0xb1, 0xd5)),
        self$serialize_bytes(self$langCode)
      )
    }
  )
)

# @title fromReader
# @name GetEmojiURLRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetEmojiURLRequest.
GetEmojiURLRequest$fromReader <- function(reader) {
  langCode <- reader$tgreadString()
  GetEmojiURLRequest$new(langCode = langCode)
}

#  @title GetExportedChatInviteRequest
#  @description Represents a request to get exported chat invite. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetExportedChatInviteRequest <- R6::R6Class(
  "GetExportedChatInviteRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x73746f5c,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x82dcd4ca,

    #  @description Initialize the GetExportedChatInviteRequest object.
    #  @param peer The input peer.
    #  @param link The link string.
    initialize = function(peer, link) {
      self$peer <- peer
      self$link <- link
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetExportedChatInviteRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "link" = self$link
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x5c, 0x6f, 0x74, 0x73)),
        self$peer$bytes(),
        self$serialize_bytes(self$link)
      )
    }
  )
)

# @title fromReader
# @name GetExportedChatInviteRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetExportedChatInviteRequest.
GetExportedChatInviteRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  link <- reader$tgreadString()
  GetExportedChatInviteRequest$new(peer = peer, link = link)
}


#  @title GetExportedChatInvitesRequest
#  @description Represents a request to get exported chat invites. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetExportedChatInvitesRequest <- R6::R6Class(
  "GetExportedChatInvitesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xa2b5a3f6,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x603d3871,

    #  @description Initialize the GetExportedChatInvitesRequest object.
    #  @param peer The input peer.
    #  @param adminId The input admin user.
    #  @param limit The limit value.
    #  @param revoked Whether revoked.
    #  @param offsetDate The offset date.
    #  @param offsetLink The offset link.
    initialize = function(peer, adminId, limit, revoked = NULL, offsetDate = NULL, offsetLink = NULL) {
      self$peer <- peer
      self$adminId <- adminId
      self$limit <- limit
      self$revoked <- revoked
      self$offsetDate <- offsetDate
      self$offsetLink <- offsetLink
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      self$adminId <- utils$getInputUser(client$getInputEntity(self$adminId))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetExportedChatInvitesRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "admin_id" = if (inherits(self$adminId, "TLObject")) self$adminId$toDict() else self$adminId,
        "limit" = self$limit,
        "revoked" = self$revoked,
        "offset_date" = self$offsetDate,
        "offset_link" = self$offsetLink
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      stopifnot(
        ((self$offsetDate || !is.null(self$offsetDate)) && (self$offsetLink || !is.null(self$offsetLink))) ||
          ((is.null(self$offsetDate) || !self$offsetDate) && (is.null(self$offsetLink) || !self$offsetLink)),
        "offsetDate, offsetLink parameters must all be FALSE-y (like NULL) or all TRUE-y"
      )
      flags <- (if (is.null(self$revoked) || !self$revoked) 0 else 8) |
        (if (is.null(self$offsetDate) || !self$offsetDate) 0 else 4) |
        (if (is.null(self$offsetLink) || !self$offsetLink) 0 else 4)
      c(
        as.raw(c(0xf6, 0xa3, 0xb5, 0xa2)),
        pack("<I", flags),
        self$peer$bytes(),
        self$adminId$bytes(),
        if (is.null(self$offsetDate) || !self$offsetDate) raw(0) else self$serialize_datetime(self$offsetDate),
        if (is.null(self$offsetLink) || !self$offsetLink) raw(0) else self$serialize_bytes(self$offsetLink),
        pack("<i", self$limit)
      )
    }
  )
)

# @title fromReader
# @name GetExportedChatInvitesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetExportedChatInvitesRequest.
GetExportedChatInvitesRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  revoked <- bitwAnd(flags, 8) != 0
  peer <- reader$tgreadObject()
  adminId <- reader$tgreadObject()
  offsetDate <- if (bitwAnd(flags, 4) != 0) reader$tgreadDate() else NULL
  offsetLink <- if (bitwAnd(flags, 4) != 0) reader$tgreadString() else NULL
  limit <- reader$readInt()
  GetExportedChatInvitesRequest$new(peer = peer, adminId = adminId, limit = limit, revoked = revoked, offsetDate = offsetDate, offsetLink = offsetLink)
}

#  @title GetExtendedMediaRequest
#  @description Represents a request to get extended media. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetExtendedMediaRequest <- R6::R6Class(
  "GetExtendedMediaRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x84f80814,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the GetExtendedMediaRequest object.
    #  @param peer The input peer.
    #  @param id The list of message IDs.
    initialize = function(peer, id) {
      self$peer <- peer
      self$id <- id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetExtendedMediaRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "id" = if (is.null(self$id)) list() else self$id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x14, 0x08, 0xf8, 0x84)),
        self$peer$bytes(),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)),
        pack("<i", length(self$id)),
        do.call(c, lapply(self$id, function(x) pack("<i", x)))
      )
    }
  )
)

# @title fromReader
# @name GetExtendedMediaRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetExtendedMediaRequest.
GetExtendedMediaRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  reader$readInt()
  id <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$readInt()
    id <- c(id, x)
  }
  GetExtendedMediaRequest$new(peer = peer, id = id)
}

#  @title GetFactCheckRequest
#  @description Represents a request to get fact check. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetFactCheckRequest <- R6::R6Class(
  "GetFactCheckRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xb9cdc5ee,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xbba61813,

    #  @description Initialize the GetFactCheckRequest object.
    #  @param peer The input peer.
    #  @param msgId The list of message IDs.
    initialize = function(peer, msgId) {
      self$peer <- peer
      self$msgId <- msgId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetFactCheckRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "msg_id" = if (is.null(self$msgId)) list() else self$msgId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xee, 0xc5, 0xcd, 0xb9)),
        self$peer$bytes(),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)),
        pack("<i", length(self$msgId)),
        do.call(c, lapply(self$msgId, function(x) pack("<i", x)))
      )
    }
  )
)

# @title fromReader
# @name GetFactCheckRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetFactCheckRequest.
GetFactCheckRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  reader$readInt()
  msgId <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$readInt()
    msgId <- c(msgId, x)
  }
  GetFactCheckRequest$new(peer = peer, msgId = msgId)
}


#  @title GetFavedStickersRequest
#  @description Represents a request to get faved stickers. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetFavedStickersRequest <- R6::R6Class(
  "GetFavedStickersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x4f1aaa9,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8e736fb9,

    #  @description Initialize the GetFavedStickersRequest object.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetFavedStickersRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xa9, 0xaa, 0xf1, 0x04)),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetFavedStickersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetFavedStickersRequest.
GetFavedStickersRequest$fromReader <- function(reader) {
  hash <- reader$readLong()
  GetFavedStickersRequest$new(hash = hash)
}

#  @title GetFeaturedEmojiStickersRequest
#  @description Represents a request to get featured emoji stickers. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetFeaturedEmojiStickersRequest <- R6::R6Class(
  "GetFeaturedEmojiStickersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xecf6736,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x2614b722,

    #  @description Initialize the GetFeaturedEmojiStickersRequest object.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetFeaturedEmojiStickersRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x36, 0x67, 0xcf, 0x0e)),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetFeaturedEmojiStickersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetFeaturedEmojiStickersRequest.
GetFeaturedEmojiStickersRequest$fromReader <- function(reader) {
  hash <- reader$readLong()
  GetFeaturedEmojiStickersRequest$new(hash = hash)
}

#  @title GetFeaturedStickersRequest
#  @description Represents a request to get featured stickers. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetFeaturedStickersRequest <- R6::R6Class(
  "GetFeaturedStickersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x64780b14,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x2614b722,

    #  @description Initialize the GetFeaturedStickersRequest object.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetFeaturedStickersRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x14, 0x0b, 0x78, 0x64)),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetFeaturedStickersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetFeaturedStickersRequest.
GetFeaturedStickersRequest$fromReader <- function(reader) {
  hash <- reader$readLong()
  GetFeaturedStickersRequest$new(hash = hash)
}

#  @title GetFullChatRequest
#  @description Represents a request to get full chat information. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetFullChatRequest <- R6::R6Class(
  "GetFullChatRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xaeb00b34,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x225a5109,

    #  @description Initialize the GetFullChatRequest object.
    #  @param chatId The chat ID.
    initialize = function(chatId) {
      self$chatId <- chatId
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetFullChatRequest",
        "chat_id" = self$chatId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x34, 0x0b, 0xb0, 0xae)),
        pack("<q", self$chatId)
      )
    }
  )
)

# @title fromReader
# @name GetFullChatRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetFullChatRequest.
GetFullChatRequest$fromReader <- function(reader) {
  chatId <- reader$readLong()
  GetFullChatRequest$new(chatId = chatId)
}


#  @title GetGameHighScoresRequest
#  @description Represents a request to get game high scores. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetGameHighScoresRequest <- R6::R6Class(
  "GetGameHighScoresRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xe822649d,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x6ccd95fd,

    #  @description Initialize the GetGameHighScoresRequest object.
    #  @param peer The input peer.
    #  @param id The message ID.
    #  @param userId The input user ID.
    initialize = function(peer, id, userId) {
      self$peer <- peer
      self$id <- id
      self$userId <- userId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      self$userId <- utils$getInputUser(client$getInputEntity(self$userId))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetGameHighScoresRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "id" = self$id,
        "user_id" = if (inherits(self$userId, "TLObject")) self$userId$toDict() else self$userId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x9d, 0xd2, 0x22, 0xe8)),
        self$peer$bytes(),
        pack("<i", self$id),
        self$userId$bytes()
      )
    }
  )
)

# @title fromReader
# @name GetGameHighScoresRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetGameHighScoresRequest.
GetGameHighScoresRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  id <- reader$readInt()
  userId <- reader$tgreadObject()
  GetGameHighScoresRequest$new(peer = peer, id = id, userId = userId)
}

#  @title GetHistoryRequest
#  @description Represents a request to get history. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetHistoryRequest <- R6::R6Class(
  "GetHistoryRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x4423e6c5,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd4b40b5e,

    #  @description Initialize the GetHistoryRequest object.
    #  @param peer The input peer.
    #  @param offsetId The offset ID.
    #  @param offsetDate The offset date.
    #  @param addOffset The add offset.
    #  @param limit The limit.
    #  @param maxId The maximum ID.
    #  @param minId The minimum ID.
    #  @param hash The hash value.
    initialize = function(peer, offsetId, offsetDate, addOffset, limit, maxId, minId, hash) {
      self$peer <- peer
      self$offsetId <- offsetId
      self$offsetDate <- offsetDate
      self$addOffset <- addOffset
      self$limit <- limit
      self$maxId <- maxId
      self$minId <- minId
      self$hash <- hash
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetHistoryRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "offset_id" = self$offsetId,
        "offset_date" = self$offsetDate,
        "add_offset" = self$addOffset,
        "limit" = self$limit,
        "max_id" = self$maxId,
        "min_id" = self$minId,
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xc5, 0xe6, 0x23, 0x44)),
        self$peer$bytes(),
        pack("<i", self$offsetId),
        self$serialize_datetime(self$offsetDate),
        pack("<i", self$addOffset),
        pack("<i", self$limit),
        pack("<i", self$maxId),
        pack("<i", self$minId),
        pack("<q", self$hash)
      )
    }
  ),
  lock_objects = FALSE
)

# @title fromReader
# @name GetHistoryRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetHistoryRequest.
GetHistoryRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  offsetId <- reader$readInt()
  offsetDate <- reader$tgreadDate()
  addOffset <- reader$readInt()
  limit <- reader$readInt()
  maxId <- reader$readInt()
  minId <- reader$readInt()
  hash <- reader$readLong()
  GetHistoryRequest$new(peer = peer, offsetId = offsetId, offsetDate = offsetDate, addOffset = addOffset, limit = limit, maxId = maxId, minId = minId, hash = hash)
}

#  @title GetInlineBotResultsRequest
#  @description Represents a request to get inline bot results. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetInlineBotResultsRequest <- R6::R6Class(
  "GetInlineBotResultsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x514e999d,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x3ed4d9c9,

    #  @description Initialize the GetInlineBotResultsRequest object.
    #  @param bot The input bot user.
    #  @param peer The input peer.
    #  @param query The query string.
    #  @param offset The offset string.
    #  @param geoPoint Optional geo point.
    initialize = function(bot, peer, query, offset, geoPoint = NULL) {
      self$bot <- bot
      self$peer <- peer
      self$query <- query
      self$offset <- offset
      self$geoPoint <- geoPoint
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$bot <- utils$getInputUser(client$getInputEntity(self$bot))
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetInlineBotResultsRequest",
        "bot" = if (inherits(self$bot, "TLObject")) self$bot$toDict() else self$bot,
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "query" = self$query,
        "offset" = self$offset,
        "geo_point" = if (inherits(self$geoPoint, "TLObject")) self$geoPoint$toDict() else self$geoPoint
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$geoPoint) || !length(self$geoPoint)) 0L else 1L
      c(
        as.raw(c(0x9d, 0x99, 0x4e, 0x51)),
        pack("<I", flags),
        self$bot$bytes(),
        self$peer$bytes(),
        if (is.null(self$geoPoint) || !length(self$geoPoint)) raw(0) else self$geoPoint$bytes(),
        self$serialize_bytes(self$query),
        self$serialize_bytes(self$offset)
      )
    }
  )
)

# @title fromReader
# @name GetInlineBotResultsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetInlineBotResultsRequest.
GetInlineBotResultsRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  bot <- reader$tgreadObject()
  peer <- reader$tgreadObject()
  geoPoint <- if (bitwAnd(flags, 1L) != 0) reader$tgreadObject() else NULL
  query <- reader$tgreadString()
  offset <- reader$tgreadString()
  GetInlineBotResultsRequest$new(bot = bot, peer = peer, query = query, offset = offset, geoPoint = geoPoint)
}


#  @title GetInlineGameHighScoresRequest
#  @description Represents a request to get inline game high scores. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetInlineGameHighScoresRequest <- R6::R6Class(
  "GetInlineGameHighScoresRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xf635e1b,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x6ccd95fd,

    #  @description Initialize the GetInlineGameHighScoresRequest object.
    #  @param id The input bot inline message ID.
    #  @param userId The input user ID.
    initialize = function(id, userId) {
      self$id <- id
      self$userId <- userId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$userId <- utils$getInputUser(client$getInputEntity(self$userId))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetInlineGameHighScoresRequest",
        "id" = if (inherits(self$id, "TLObject")) self$id$toDict() else self$id,
        "user_id" = if (inherits(self$userId, "TLObject")) self$userId$toDict() else self$userId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x1b, 0x5e, 0x63, 0x0f)),
        self$id$bytes(),
        self$userId$bytes()
      )
    }
  )
)

# @title fromReader
# @name GetInlineGameHighScoresRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetInlineGameHighScoresRequest.
GetInlineGameHighScoresRequest$fromReader <- function(reader) {
  id <- reader$tgreadObject()
  userId <- reader$tgreadObject()
  GetInlineGameHighScoresRequest$new(id = id, userId = userId)
}

#  @title GetMaskStickersRequest
#  @description Represents a request to get mask stickers. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetMaskStickersRequest <- R6::R6Class(
  "GetMaskStickersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x640f82b8,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x45834829,

    #  @description Initialize the GetMaskStickersRequest object.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetMaskStickersRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xb8, 0x82, 0x0f, 0x64)),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetMaskStickersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetMaskStickersRequest.
GetMaskStickersRequest$fromReader <- function(reader) {
  hash <- reader$readLong()
  GetMaskStickersRequest$new(hash = hash)
}

#  @title GetMessageEditDataRequest
#  @description Represents a request to get message edit data. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetMessageEditDataRequest <- R6::R6Class(
  "GetMessageEditDataRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xfda68d36,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xfb47949d,

    #  @description Initialize the GetMessageEditDataRequest object.
    #  @param peer The input peer.
    #  @param id The message ID.
    initialize = function(peer, id) {
      self$peer <- peer
      self$id <- id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetMessageEditDataRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "id" = self$id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x36, 0x8d, 0xa6, 0xfd)),
        self$peer$bytes(),
        pack("<i", self$id)
      )
    }
  )
)

# @title fromReader
# @name GetMessageEditDataRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetMessageEditDataRequest.
GetMessageEditDataRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  id <- reader$readInt()
  GetMessageEditDataRequest$new(peer = peer, id = id)
}


#  @title GetMessageReactionsListRequest
#  @description Represents a request to get message reactions list. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetMessageReactionsListRequest <- R6::R6Class(
  "GetMessageReactionsListRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x461b3f48,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x60fce5e6,

    #  @description Initialize the GetMessageReactionsListRequest object.
    #  @param peer The input peer.
    #  @param id The message ID.
    #  @param limit The limit value.
    #  @param reaction Optional reaction.
    #  @param offset Optional offset string.
    initialize = function(peer, id, limit, reaction = NULL, offset = NULL) {
      self$peer <- peer
      self$id <- id
      self$limit <- limit
      self$reaction <- reaction
      self$offset <- offset
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetMessageReactionsListRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "id" = self$id,
        "limit" = self$limit,
        "reaction" = if (inherits(self$reaction, "TLObject")) self$reaction$toDict() else self$reaction,
        "offset" = self$offset
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$reaction) || !length(self$reaction)) 0L else 1L) | (if (is.null(self$offset) || !nchar(self$offset)) 0L else 2L)
      c(
        as.raw(c(0x48, 0x3f, 0x1b, 0x46)),
        pack("<I", flags),
        self$peer$bytes(),
        pack("<i", self$id),
        if (is.null(self$reaction) || !length(self$reaction)) raw(0) else self$reaction$bytes(),
        if (is.null(self$offset) || !nchar(self$offset)) raw(0) else self$serialize_bytes(self$offset),
        pack("<i", self$limit)
      )
    }
  )
)

# @title fromReader
# @name GetMessageReactionsListRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetMessageReactionsListRequest.
GetMessageReactionsListRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  peer <- reader$tgreadObject()
  id <- reader$readInt()
  reaction <- if (bitwAnd(flags, 1L) != 0) reader$tgreadObject() else NULL
  offset <- if (bitwAnd(flags, 2L) != 0) reader$tgreadString() else NULL
  limit <- reader$readInt()
  GetMessageReactionsListRequest$new(peer = peer, id = id, limit = limit, reaction = reaction, offset = offset)
}

#  @title GetMessageReadParticipantsRequest
#  @description Represents a request to get message read participants. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetMessageReadParticipantsRequest <- R6::R6Class(
  "GetMessageReadParticipantsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x31c1c44f,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x21ca455b,

    #  @description Initialize the GetMessageReadParticipantsRequest object.
    #  @param peer The input peer.
    #  @param msgId The message ID.
    initialize = function(peer, msgId) {
      self$peer <- peer
      self$msgId <- msgId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetMessageReadParticipantsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "msg_id" = self$msgId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x4f, 0xc4, 0xc1, 0x31)),
        self$peer$bytes(),
        pack("<i", self$msgId)
      )
    }
  )
)

# @title fromReader
# @name GetMessageReadParticipantsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetMessageReadParticipantsRequest.
GetMessageReadParticipantsRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  msgId <- reader$readInt()
  GetMessageReadParticipantsRequest$new(peer = peer, msgId = msgId)
}

#  @title GetMessagesRequest
#  @description Represents a request to get messages. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetMessagesRequest <- R6::R6Class(
  "GetMessagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x63c66506,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd4b40b5e,

    #  @description Initialize the GetMessagesRequest object.
    #  @param id The list of input messages.
    initialize = function(id) {
      self$id <- id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      tmp <- list()
      for (x in self$id) {
        tmp <- c(tmp, list(utils$getInputMessage(x)))
      }
      self$id <- tmp
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetMessagesRequest",
        "id" = if (is.null(self$id)) list() else lapply(self$id, function(x) if (inherits(x, "TLObject")) x$toDict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x06, 0x65, 0xc6, 0x63)),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)),
        pack("<i", length(self$id)),
        do.call(c, lapply(self$id, function(x) x$bytes()))
      )
    }
  )
)

# @title fromReader
# @name GetMessagesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetMessagesRequest.
GetMessagesRequest$fromReader <- function(reader) {
  reader$readInt()
  id <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$tgreadObject()
    id <- c(id, list(x))
  }
  GetMessagesRequest$new(id = id)
}


#  @title GetMessagesReactionsRequest
#  @description Represents a request to get messages reactions. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetMessagesReactionsRequest <- R6::R6Class(
  "GetMessagesReactionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x8bba90e6,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the GetMessagesReactionsRequest object.
    #  @param peer The input peer.
    #  @param id The list of message IDs.
    initialize = function(peer, id) {
      self$peer <- peer
      self$id <- id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetMessagesReactionsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "id" = if (is.null(self$id)) list() else self$id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xe6, 0x90, 0xba, 0x8b)),
        self$peer$bytes(),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)),
        pack("<i", length(self$id)),
        do.call(c, lapply(self$id, function(x) pack("<i", x)))
      )
    }
  )
)

# @title fromReader
# @name GetMessagesReactionsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetMessagesReactionsRequest.
GetMessagesReactionsRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  reader$readInt()
  id <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$readInt()
    id <- c(id, x)
  }
  GetMessagesReactionsRequest$new(peer = peer, id = id)
}

#  @title GetMessagesViewsRequest
#  @description Represents a request to get messages views. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetMessagesViewsRequest <- R6::R6Class(
  "GetMessagesViewsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x5784d3e1,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xafb5eb9c,
    #  @field peer The input peer.
    peer = NULL,
    #  @field id The list of message IDs.
    id = NULL,
    #  @field increment Whether to increment views.
    increment = NULL,

    #  @description Initialize the GetMessagesViewsRequest object.
    #  @param peer The input peer.
    #  @param id The list of message IDs.
    #  @param increment Whether to increment views.
    initialize = function(peer, id, increment) {
      self$peer <- peer
      self$id <- id
      self$increment <- increment
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetMessagesViewsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "id" = if (is.null(self$id)) list() else self$id,
        "increment" = self$increment
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xe1, 0xd3, 0x84, 0x57)),
        self$peer$bytes(),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)),
        pack("<i", length(self$id)),
        do.call(c, lapply(self$id, function(x) pack("<i", x))),
        if (self$increment) as.raw(c(0x99, 0x75, 0x72, 0xb5)) else as.raw(c(0xbc, 0x79, 0x97, 0x37))
      )
    }
  )
)

# @title fromReader
# @name GetMessagesViewsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetMessagesViewsRequest.
GetMessagesViewsRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  reader$readInt()
  id <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$readInt()
    id <- c(id, x)
  }
  increment <- reader$tgreadBool()
  GetMessagesViewsRequest$new(peer = peer, id = id, increment = increment)
}

#  @title GetMyStickersRequest
#  @description Represents a request to get my stickers. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetMyStickersRequest <- R6::R6Class(
  "GetMyStickersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xd0b5e1fc,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xb1b4350a,

    #  @description Initialize the GetMyStickersRequest object.
    #  @param offsetId The offset ID.
    #  @param limit The limit value.
    initialize = function(offsetId, limit) {
      self$offsetId <- offsetId
      self$limit <- limit
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetMyStickersRequest",
        "offset_id" = self$offsetId,
        "limit" = self$limit
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xfc, 0xe1, 0xb5, 0xd0)),
        pack("<q", self$offsetId),
        pack("<i", self$limit)
      )
    }
  )
)

# @title fromReader
# @name GetMyStickersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetMyStickersRequest.
GetMyStickersRequest$fromReader <- function(reader) {
  offsetId <- reader$readLong()
  limit <- reader$readInt()
  GetMyStickersRequest$new(offsetId = offsetId, limit = limit)
}


#  @title GetOldFeaturedStickersRequest
#  @description Represents a request to get old featured stickers. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetOldFeaturedStickersRequest <- R6::R6Class(
  "GetOldFeaturedStickersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x7ed094a1,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x2614b722,

    #  @description Initialize the GetOldFeaturedStickersRequest object.
    #  @param offset The offset value.
    #  @param limit The limit value.
    #  @param hash The hash value.
    initialize = function(offset, limit, hash) {
      self$offset <- offset
      self$limit <- limit
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetOldFeaturedStickersRequest",
        "offset" = self$offset,
        "limit" = self$limit,
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xa1, 0x94, 0xd0, 0x7e)),
        pack("<i", self$offset),
        pack("<i", self$limit),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetOldFeaturedStickersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetOldFeaturedStickersRequest.
GetOldFeaturedStickersRequest$fromReader <- function(reader) {
  offset <- reader$readInt()
  limit <- reader$readInt()
  hash <- reader$readLong()
  GetOldFeaturedStickersRequest$new(offset = offset, limit = limit, hash = hash)
}

#  @title GetOnlinesRequest
#  @description Represents a request to get onlines. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetOnlinesRequest <- R6::R6Class(
  "GetOnlinesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x6e2be050,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8c81903a,

    #  @description Initialize the GetOnlinesRequest object.
    #  @param peer The input peer.
    initialize = function(peer) {
      self$peer <- peer
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetOnlinesRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x50, 0xe0, 0x2b, 0x6e)),
        self$peer$bytes()
      )
    }
  )
)

# @title fromReader
# @name GetOnlinesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetOnlinesRequest.
GetOnlinesRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  GetOnlinesRequest$new(peer = peer)
}

#  @title GetOutboxReadDateRequest
#  @description Represents a request to get outbox read date. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetOutboxReadDateRequest <- R6::R6Class(
  "GetOutboxReadDateRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x8c4bfe5d,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x6f5183c6,

    #  @description Initialize the GetOutboxReadDateRequest object.
    #  @param peer The input peer.
    #  @param msgId The message ID.
    initialize = function(peer, msgId) {
      self$peer <- peer
      self$msgId <- msgId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetOutboxReadDateRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "msg_id" = self$msgId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x5d, 0xfe, 0x4b, 0x8c)),
        self$peer$bytes(),
        pack("<i", self$msgId)
      )
    }
  )
)

# @title fromReader
# @name GetOutboxReadDateRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetOutboxReadDateRequest.
GetOutboxReadDateRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  msgId <- reader$readInt()
  GetOutboxReadDateRequest$new(peer = peer, msgId = msgId)
}

#  @title GetPaidReactionPrivacyRequest
#  @description Represents a request to get paid reaction privacy. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetPaidReactionPrivacyRequest <- R6::R6Class(
  "GetPaidReactionPrivacyRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x472455aa,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetPaidReactionPrivacyRequest"
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      as.raw(c(0xaa, 0x55, 0x24, 0x47))
    }
  )
)

# @title fromReader
# @name GetPaidReactionPrivacyRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetPaidReactionPrivacyRequest.
GetPaidReactionPrivacyRequest$fromReader <- function(reader) {
  GetPaidReactionPrivacyRequest$new()
}


#  @title GetPeerDialogsRequest
#  @description Represents a request to get peer dialogs. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetPeerDialogsRequest <- R6::R6Class(
  "GetPeerDialogsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xe470bcfd,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x3ac70132,

    #  @description Initialize the GetPeerDialogsRequest object.
    #  @param peers The list of input dialog peers.
    initialize = function(peers) {
      self$peers <- peers
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      tmp <- list()
      for (x in self$peers) {
        tmp <- c(tmp, list(client$getInputDialog(x)))
      }
      self$peers <- tmp
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetPeerDialogsRequest",
        "peers" = if (is.null(self$peers)) list() else lapply(self$peers, function(x) if (inherits(x, "TLObject")) x$toDict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xfd, 0xbc, 0x70, 0xe4)),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        pack("<i", length(self$peers)),
        do.call(c, lapply(self$peers, function(x) x$bytes()))
      )
    }
  )
)

# @title fromReader
# @name GetPeerDialogsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetPeerDialogsRequest.
GetPeerDialogsRequest$fromReader <- function(reader) {
  reader$readInt()
  peers <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$tgreadObject()
    peers <- c(peers, list(x))
  }
  GetPeerDialogsRequest$new(peers = peers)
}

#  @title GetPeerSettingsRequest
#  @description Represents a request to get peer settings. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetPeerSettingsRequest <- R6::R6Class(
  "GetPeerSettingsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xefd9a6a2,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x65a2f7a1,

    #  @description Initialize the GetPeerSettingsRequest object.
    #  @param peer The input peer.
    initialize = function(peer) {
      self$peer <- peer
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetPeerSettingsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xa2, 0xa6, 0xd9, 0xef)),
        self$peer$bytes()
      )
    }
  )
)

# @title fromReader
# @name GetPeerSettingsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetPeerSettingsRequest.
GetPeerSettingsRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  GetPeerSettingsRequest$new(peer = peer)
}

#  @title GetPinnedDialogsRequest
#  @description Represents a request to get pinned dialogs. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetPinnedDialogsRequest <- R6::R6Class(
  "GetPinnedDialogsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xd6b94df2,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x3ac70132,

    #  @description Initialize the GetPinnedDialogsRequest object.
    #  @param folderId The folder ID.
    initialize = function(folderId) {
      self$folderId <- folderId
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetPinnedDialogsRequest",
        "folder_id" = self$folderId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xf2, 0x4d, 0xb9, 0xd6)),
        pack("<i", self$folderId)
      )
    }
  )
)

# @title fromReader
# @name GetPinnedDialogsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetPinnedDialogsRequest.
GetPinnedDialogsRequest$fromReader <- function(reader) {
  folderId <- reader$readInt()
  GetPinnedDialogsRequest$new(folderId = folderId)
}

#  @title GetPinnedSavedDialogsRequest
#  @description Represents a request to get pinned saved dialogs. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetPinnedSavedDialogsRequest <- R6::R6Class(
  "GetPinnedSavedDialogsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xd63d94e0,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x614bb87e,

    #  @description Initialize the GetPinnedSavedDialogsRequest object.
    initialize = function() {},

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetPinnedSavedDialogsRequest"
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      as.raw(c(0xe0, 0x94, 0x3d, 0xd6))
    }
  )
)

# @title fromReader
# @name GetPinnedSavedDialogsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetPinnedSavedDialogsRequest.
GetPinnedSavedDialogsRequest$fromReader <- function(reader) {
  GetPinnedSavedDialogsRequest$new()
}


#  @title GetPollResultsRequest
#  @description Represents a request to get poll results. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetPollResultsRequest <- R6::R6Class(
  "GetPollResultsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x73bb643b,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the GetPollResultsRequest object.
    #  @param peer The input peer.
    #  @param msgId The message ID.
    initialize = function(peer, msgId) {
      self$peer <- peer
      self$msgId <- msgId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetPollResultsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "msg_id" = self$msgId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x3b, 0x64, 0xbb, 0x73)),
        self$peer$bytes(),
        pack("<i", self$msgId)
      )
    }
  )
)

# @title fromReader
# @name GetPollResultsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetPollResultsRequest.
GetPollResultsRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  msgId <- reader$readInt()
  GetPollResultsRequest$new(peer = peer, msgId = msgId)
}

#  @title GetPollVotesRequest
#  @description Represents a request to get poll votes. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetPollVotesRequest <- R6::R6Class(
  "GetPollVotesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xb86e380e,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xc2199885,

    #  @description Initialize the GetPollVotesRequest object.
    #  @param peer The input peer.
    #  @param id The poll ID.
    #  @param limit The limit value.
    #  @param option Optional option bytes.
    #  @param offset Optional offset string.
    initialize = function(peer, id, limit, option = NULL, offset = NULL) {
      self$peer <- peer
      self$id <- id
      self$limit <- limit
      self$option <- option
      self$offset <- offset
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetPollVotesRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "id" = self$id,
        "limit" = self$limit,
        "option" = self$option,
        "offset" = self$offset
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$option) || !length(self$option)) 0L else 1L) | (if (is.null(self$offset) || !nchar(self$offset)) 0L else 2L)
      c(
        as.raw(c(0x0e, 0x38, 0x6e, 0xb8)),
        pack("<I", flags),
        self$peer$bytes(),
        pack("<i", self$id),
        if (is.null(self$option) || !length(self$option)) raw(0) else self$serialize_bytes(self$option),
        if (is.null(self$offset) || !nchar(self$offset)) raw(0) else self$serialize_bytes(self$offset),
        pack("<i", self$limit)
      )
    }
  )
)

# @title fromReader
# @name GetPollVotesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetPollVotesRequest.
GetPollVotesRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  peer <- reader$tgreadObject()
  id <- reader$readInt()
  option <- if (bitwAnd(flags, 1L) != 0) reader$tgreadBytes() else NULL
  offset <- if (bitwAnd(flags, 2L) != 0) reader$tgreadString() else NULL
  limit <- reader$readInt()
  GetPollVotesRequest$new(peer = peer, id = id, limit = limit, option = option, offset = offset)
}

#  @title GetPreparedInlineMessageRequest
#  @description Represents a request to get a prepared inline message. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetPreparedInlineMessageRequest <- R6::R6Class(
  "GetPreparedInlineMessageRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x857ebdb8,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x490ddf4d,

    #  @description Initialize the GetPreparedInlineMessageRequest object.
    #  @param bot The input bot user.
    #  @param id The message ID string.
    initialize = function(bot, id) {
      self$bot <- bot
      self$id <- id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$bot <- utils$getInputUser(client$getInputEntity(self$bot))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetPreparedInlineMessageRequest",
        "bot" = if (inherits(self$bot, "TLObject")) self$bot$toDict() else self$bot,
        "id" = self$id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xb8, 0xbd, 0x7e, 0x85)),
        self$bot$bytes(),
        self$serialize_bytes(self$id)
      )
    }
  )
)

# @title fromReader
# @name GetPreparedInlineMessageRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetPreparedInlineMessageRequest.
GetPreparedInlineMessageRequest$fromReader <- function(reader) {
  bot <- reader$tgreadObject()
  id <- reader$tgreadString()
  GetPreparedInlineMessageRequest$new(bot = bot, id = id)
}


#  @title GetQuickRepliesRequest
#  @description Represents a request to get quick replies. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetQuickRepliesRequest <- R6::R6Class(
  "GetQuickRepliesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xd483f2a8,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf737e966,

    #  @description Initialize the GetQuickRepliesRequest object.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetQuickRepliesRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xa8, 0xf2, 0x83, 0xd4)),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetQuickRepliesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetQuickRepliesRequest.
GetQuickRepliesRequest$fromReader <- function(reader) {
  hash <- reader$readLong()
  GetQuickRepliesRequest$new(hash = hash)
}

#  @title GetQuickReplyMessagesRequest
#  @description Represents a request to get quick reply messages. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetQuickReplyMessagesRequest <- R6::R6Class(
  "GetQuickReplyMessagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x94a495c3,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd4b40b5e,

    #  @description Initialize the GetQuickReplyMessagesRequest object.
    #  @param shortcutId The shortcut ID.
    #  @param hash The hash value.
    #  @param id Optional list of message IDs.
    initialize = function(shortcutId, hash, id = NULL) {
      self$shortcutId <- shortcutId
      self$hash <- hash
      self$id <- id
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetQuickReplyMessagesRequest",
        "shortcut_id" = self$shortcutId,
        "hash" = self$hash,
        "id" = if (is.null(self$id)) list() else self$id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$id) || !length(self$id)) 0L else 1L
      c(
        as.raw(c(0xc3, 0x95, 0xa4, 0x94)),
        pack("<I", flags),
        pack("<i", self$shortcutId),
        if (is.null(self$id) || !length(self$id)) raw(0) else c(as.raw(c(0x1c, 0xb5, 0xc4, 0x15)), pack("<i", length(self$id)), do.call(c, lapply(self$id, function(x) pack("<i", x)))),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetQuickReplyMessagesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetQuickReplyMessagesRequest.
GetQuickReplyMessagesRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  shortcutId <- reader$readInt()
  if (bitwAnd(flags, 1L) != 0) {
    reader$readInt()
    id <- list()
    for (i in 1:reader$readInt()) {
      x <- reader$readInt()
      id <- c(id, x)
    }
  } else {
    id <- NULL
  }
  hash <- reader$readLong()
  GetQuickReplyMessagesRequest$new(shortcutId = shortcutId, hash = hash, id = id)
}

#  @title GetRecentLocationsRequest
#  @description Represents a request to get recent locations. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetRecentLocationsRequest <- R6::R6Class(
  "GetRecentLocationsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x702a40e0,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd4b40b5e,

    #  @description Initialize the GetRecentLocationsRequest object.
    #  @param peer The input peer.
    #  @param limit The limit value.
    #  @param hash The hash value.
    initialize = function(peer, limit, hash) {
      self$peer <- peer
      self$limit <- limit
      self$hash <- hash
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetRecentLocationsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "limit" = self$limit,
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xe0, 0x40, 0x2a, 0x70)),
        self$peer$bytes(),
        pack("<i", self$limit),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetRecentLocationsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetRecentLocationsRequest.
GetRecentLocationsRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  limit <- reader$readInt()
  hash <- reader$readLong()
  GetRecentLocationsRequest$new(peer = peer, limit = limit, hash = hash)
}


#  @title GetRecentReactionsRequest
#  @description Represents a request to get recent reactions. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetRecentReactionsRequest <- R6::R6Class(
  "GetRecentReactionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x39461db2,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xadc38324,

    #  @description Initialize the GetRecentReactionsRequest object.
    #  @param limit The limit value.
    #  @param hash The hash value.
    initialize = function(limit, hash) {
      self$limit <- limit
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetRecentReactionsRequest",
        "limit" = self$limit,
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xb2, 0x1d, 0x46, 0x39)),
        pack("<i", self$limit),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetRecentReactionsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetRecentReactionsRequest.
GetRecentReactionsRequest$fromReader <- function(reader) {
  limit <- reader$readInt()
  hash <- reader$readLong()
  GetRecentReactionsRequest$new(limit = limit, hash = hash)
}

#  @title GetRecentStickersRequest
#  @description Represents a request to get recent stickers. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetRecentStickersRequest <- R6::R6Class(
  "GetRecentStickersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x9da9403b,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf76f8683,

    #  @description Initialize the GetRecentStickersRequest object.
    #  @param hash The hash value.
    #  @param attached Whether attached.
    initialize = function(hash, attached = NULL) {
      self$hash <- hash
      self$attached <- attached
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetRecentStickersRequest",
        "hash" = self$hash,
        "attached" = self$attached
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$attached) || !self$attached) 0L else 1L
      c(
        as.raw(c(0x3b, 0x40, 0xa9, 0x9d)),
        pack("<I", flags),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetRecentStickersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetRecentStickersRequest.
GetRecentStickersRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  attached <- bitwAnd(flags, 1L) != 0
  hash <- reader$readLong()
  GetRecentStickersRequest$new(hash = hash, attached = attached)
}

#  @title GetRepliesRequest
#  @description Represents a request to get replies. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetRepliesRequest <- R6::R6Class(
  "GetRepliesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x22ddd30c,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd4b40b5e,

    #  @description Initialize the GetRepliesRequest object.
    #  @param peer The input peer.
    #  @param msgId The message ID.
    #  @param offsetId The offset ID.
    #  @param offsetDate The offset date.
    #  @param addOffset The add offset.
    #  @param limit The limit.
    #  @param maxId The maximum ID.
    #  @param minId The minimum ID.
    #  @param hash The hash value.
    initialize = function(peer, msgId, offsetId, offsetDate, addOffset, limit, maxId, minId, hash) {
      self$peer <- peer
      self$msgId <- msgId
      self$offsetId <- offsetId
      self$offsetDate <- offsetDate
      self$addOffset <- addOffset
      self$limit <- limit
      self$maxId <- maxId
      self$minId <- minId
      self$hash <- hash
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetRepliesRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "msg_id" = self$msgId,
        "offset_id" = self$offsetId,
        "offset_date" = self$offsetDate,
        "add_offset" = self$addOffset,
        "limit" = self$limit,
        "max_id" = self$maxId,
        "min_id" = self$minId,
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x0c, 0xd3, 0xdd, 0x22)),
        self$peer$bytes(),
        pack("<i", self$msgId),
        pack("<i", self$offsetId),
        self$serialize_datetime(self$offsetDate),
        pack("<i", self$addOffset),
        pack("<i", self$limit),
        pack("<i", self$maxId),
        pack("<i", self$minId),
        pack("<q", self$hash)
      )
    }
  ),
  lock_objects = FALSE
)

# @title fromReader
# @name GetRepliesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetRepliesRequest.
GetRepliesRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  msgId <- reader$readInt()
  offsetId <- reader$readInt()
  offsetDate <- reader$tgreadDate()
  addOffset <- reader$readInt()
  limit <- reader$readInt()
  maxId <- reader$readInt()
  minId <- reader$readInt()
  hash <- reader$readLong()
  GetRepliesRequest$new(peer = peer, msgId = msgId, offsetId = offsetId, offsetDate = offsetDate, addOffset = addOffset, limit = limit, maxId = maxId, minId = minId, hash = hash)
}

#  @title GetSavedDialogsRequest
#  @description Represents a request to get saved dialogs. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetSavedDialogsRequest <- R6::R6Class(
  "GetSavedDialogsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x1e91fc99,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x614bb87e,

    #  @description Initialize the GetSavedDialogsRequest object.
    #  @param offsetDate The offset date.
    #  @param offsetId The offset ID.
    #  @param offsetPeer The offset peer.
    #  @param limit The limit.
    #  @param hash The hash value.
    #  @param excludePinned Whether to exclude pinned dialogs.
    #  @param parentPeer Optional parent peer.
    initialize = function(offsetDate, offsetId, offsetPeer, limit, hash, excludePinned = NULL, parentPeer = NULL) {
      self$offsetDate <- offsetDate
      self$offsetId <- offsetId
      self$offsetPeer <- offsetPeer
      self$limit <- limit
      self$hash <- hash
      self$excludePinned <- excludePinned
      self$parentPeer <- parentPeer
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$offsetPeer <- utils$getInputPeer(client$getInputEntity(self$offsetPeer))
      if (!is.null(self$parentPeer)) {
        self$parentPeer <- utils$getInputPeer(client$getInputEntity(self$parentPeer))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetSavedDialogsRequest",
        "offset_date" = self$offsetDate,
        "offset_id" = self$offsetId,
        "offset_peer" = if (inherits(self$offsetPeer, "TLObject")) self$offsetPeer$toDict() else self$offsetPeer,
        "limit" = self$limit,
        "hash" = self$hash,
        "exclude_pinned" = self$excludePinned,
        "parent_peer" = if (inherits(self$parentPeer, "TLObject")) self$parentPeer$toDict() else self$parentPeer
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$excludePinned) || !self$excludePinned) 0L else 1L) | (if (is.null(self$parentPeer) || !self$parentPeer) 0L else 2L)
      c(
        as.raw(c(0x99, 0xfc, 0x91, 0x1e)),
        pack("<I", flags),
        if (is.null(self$parentPeer) || !self$parentPeer) raw(0) else self$parentPeer$bytes(),
        self$serialize_datetime(self$offsetDate),
        pack("<i", self$offsetId),
        self$offsetPeer$bytes(),
        pack("<i", self$limit),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetSavedDialogsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetSavedDialogsRequest.
GetSavedDialogsRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  excludePinned <- bitwAnd(flags, 1L) != 0
  parentPeer <- if (bitwAnd(flags, 2L) != 0) reader$tgreadObject() else NULL
  offsetDate <- reader$tgreadDate()
  offsetId <- reader$readInt()
  offsetPeer <- reader$tgreadObject()
  limit <- reader$readInt()
  hash <- reader$readLong()
  GetSavedDialogsRequest$new(offsetDate = offsetDate, offsetId = offsetId, offsetPeer = offsetPeer, limit = limit, hash = hash, excludePinned = excludePinned, parentPeer = parentPeer)
}

#  @title GetSavedDialogsByIDRequest
#  @description Represents a request to get saved dialogs by ID. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetSavedDialogsByIDRequest <- R6::R6Class(
  "GetSavedDialogsByIDRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x6f6f9c96,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x614bb87e,

    #  @description Initialize the GetSavedDialogsByIDRequest object.
    #  @param ids The list of IDs.
    #  @param parentPeer Optional parent peer.
    initialize = function(ids, parentPeer = NULL) {
      self$ids <- ids
      self$parentPeer <- parentPeer
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      tmp <- list()
      for (x in self$ids) {
        tmp <- c(tmp, list(utils$getInputPeer(client$getInputEntity(x))))
      }
      self$ids <- tmp
      if (!is.null(self$parentPeer)) {
        self$parentPeer <- utils$getInputPeer(client$getInputEntity(self$parentPeer))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetSavedDialogsByIDRequest",
        "ids" = if (is.null(self$ids)) list() else lapply(self$ids, function(x) if (inherits(x, "TLObject")) x$toDict() else x),
        "parent_peer" = if (inherits(self$parentPeer, "TLObject")) self$parentPeer$toDict() else self$parentPeer
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$parentPeer) || !self$parentPeer) 0L else 2L
      c(
        as.raw(c(0x96, 0x9c, 0x6f, 0x6f)),
        pack("<I", flags),
        if (is.null(self$parentPeer) || !self$parentPeer) raw(0) else self$parentPeer$bytes(),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)), pack("<i", length(self$ids)), do.call(c, lapply(self$ids, function(x) x$bytes()))
      )
    }
  )
)

# @title fromReader
# @name GetSavedDialogsByIDRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetSavedDialogsByIDRequest.
GetSavedDialogsByIDRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  parentPeer <- if (bitwAnd(flags, 2L) != 0) reader$tgreadObject() else NULL
  reader$readInt()
  ids <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$tgreadObject()
    ids <- c(ids, list(x))
  }
  GetSavedDialogsByIDRequest$new(ids = ids, parentPeer = parentPeer)
}

#  @title GetSavedGifsRequest
#  @description Represents a request to get saved GIFs. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetSavedGifsRequest <- R6::R6Class(
  "GetSavedGifsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x5cf09635,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xa68b61f5,

    #  @description Initialize the GetSavedGifsRequest object.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetSavedGifsRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x35, 0x96, 0xf0, 0x5c)),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetSavedGifsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetSavedGifsRequest.
GetSavedGifsRequest$fromReader <- function(reader) {
  hash <- reader$readLong()
  GetSavedGifsRequest$new(hash = hash)
}


#  @title GetSavedHistoryRequest
#  @description Represents a request to get saved history. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetSavedHistoryRequest <- R6::R6Class(
  "GetSavedHistoryRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x998ab009,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd4b40b5e,

    #  @description Initialize the GetSavedHistoryRequest object.
    #  @param peer The input peer.
    #  @param offset_id The offset ID.
    #  @param offset_date The offset date.
    #  @param add_offset The add offset.
    #  @param limit The limit.
    #  @param max_id The maximum ID.
    #  @param min_id The minimum ID.
    #  @param hash The hash value.
    #  @param parent_peer Optional parent peer.
    initialize = function(peer, offset_id, offset_date, add_offset, limit, max_id, min_id, hash, parent_peer = NULL) {
      self$peer <- peer
      self$offset_id <- offset_id
      self$offset_date <- offset_date
      self$add_offset <- add_offset
      self$limit <- limit
      self$max_id <- max_id
      self$min_id <- min_id
      self$hash <- hash
      self$parent_peer <- parent_peer
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      if (!is.null(self$parent_peer)) {
        self$parent_peer <- utils$getInputPeer(client$getInputEntity(self$parent_peer))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetSavedHistoryRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "offset_id" = self$offset_id,
        "offset_date" = self$offset_date,
        "add_offset" = self$add_offset,
        "limit" = self$limit,
        "max_id" = self$max_id,
        "min_id" = self$min_id,
        "hash" = self$hash,
        "parent_peer" = if (inherits(self$parent_peer, "TLObject")) self$parent_peer$toDict() else self$parent_peer
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$parent_peer) || !self$parent_peer) 0L else 1L
      c(
        as.raw(c(0x99, 0x8a, 0xb0, 0x09)),
        pack("<I", flags),
        if (is.null(self$parent_peer) || !self$parent_peer) raw(0) else self$parent_peer$bytes(),
        self$peer$bytes(),
        pack("<i", self$offset_id),
        self$serialize_datetime(self$offset_date),
        pack("<i", self$add_offset),
        pack("<i", self$limit),
        pack("<i", self$max_id),
        pack("<i", self$min_id),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetSavedHistoryRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetSavedHistoryRequest.
GetSavedHistoryRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  parent_peer <- if (bitwAnd(flags, 1L) != 0) reader$tgreadObject() else NULL
  peer <- reader$tgreadObject()
  offset_id <- reader$readInt()
  offset_date <- reader$tgreadDate()
  add_offset <- reader$readInt()
  limit <- reader$readInt()
  max_id <- reader$readInt()
  min_id <- reader$readInt()
  hash <- reader$readLong()
  GetSavedHistoryRequest$new(peer = peer, offset_id = offset_id, offset_date = offset_date, add_offset = add_offset, limit = limit, max_id = max_id, min_id = min_id, hash = hash, parent_peer = parent_peer)
}

#  @title GetSavedReactionTagsRequest
#  @description Represents a request to get saved reaction tags. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetSavedReactionTagsRequest <- R6::R6Class(
  "GetSavedReactionTagsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x3637e05b,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xa39b5be3,

    #  @description Initialize the GetSavedReactionTagsRequest object.
    #  @param hash The hash value.
    #  @param peer Optional peer.
    initialize = function(hash, peer = NULL) {
      self$hash <- hash
      self$peer <- peer
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      if (!is.null(self$peer)) {
        self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetSavedReactionTagsRequest",
        "hash" = self$hash,
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$peer) || !self$peer) 0L else 1L
      c(
        as.raw(c(0x5b, 0xe0, 0x37, 0x36)),
        pack("<I", flags),
        if (is.null(self$peer) || !self$peer) raw(0) else self$peer$bytes(),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetSavedReactionTagsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetSavedReactionTagsRequest.
GetSavedReactionTagsRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  peer <- if (bitwAnd(flags, 1L) != 0) reader$tgreadObject() else NULL
  hash <- reader$readLong()
  GetSavedReactionTagsRequest$new(hash = hash, peer = peer)
}

#  @title GetScheduledHistoryRequest
#  @description Represents a request to get scheduled history. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetScheduledHistoryRequest <- R6::R6Class(
  "GetScheduledHistoryRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xf516760b,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd4b40b5e,

    #  @description Initialize the GetScheduledHistoryRequest object.
    #  @param peer The input peer.
    #  @param hash The hash value.
    initialize = function(peer, hash) {
      self$peer <- peer
      self$hash <- hash
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetScheduledHistoryRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x0b, 0x76, 0x16, 0xf5)),
        self$peer$bytes(),
        pack("<q", self$hash)
      )
    }
  ),
  lock_objects = FALSE
)

# @title fromReader
# @name GetScheduledHistoryRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetScheduledHistoryRequest.
GetScheduledHistoryRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  hash <- reader$readLong()
  GetScheduledHistoryRequest$new(peer = peer, hash = hash)
}


#  @title GetScheduledMessagesRequest
#  @description Represents a request to get scheduled messages. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetScheduledMessagesRequest <- R6::R6Class(
  "GetScheduledMessagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xbdbb0464,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd4b40b5e,

    #  @description Initialize the GetScheduledMessagesRequest object.
    #  @param peer The input peer.
    #  @param id The list of message IDs.
    initialize = function(peer, id) {
      self$peer <- peer
      self$id <- id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetScheduledMessagesRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "id" = if (is.null(self$id)) list() else self$id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xbd, 0xbb, 0x04, 0x64)),
        self$peer$bytes(),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$id)), sapply(self$id, function(x) pack("<i", x))
      )
    }
  )
)

# @title fromReader
# @name GetScheduledMessagesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetScheduledMessagesRequest.
GetScheduledMessagesRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  reader$readInt()
  id <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$readInt()
    id <- c(id, x)
  }
  GetScheduledMessagesRequest$new(peer = peer, id = id)
}

#  @title GetSearchCountersRequest
#  @description Represents a request to get search counters. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetSearchCountersRequest <- R6::R6Class(
  "GetSearchCountersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x1bbcf300,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x6bde3c6e,

    #  @description Initialize the GetSearchCountersRequest object.
    #  @param peer The input peer.
    #  @param filters The list of message filters.
    #  @param savedPeerId Optional saved peer ID.
    #  @param topMsgId Optional top message ID.
    initialize = function(peer, filters, savedPeerId = NULL, topMsgId = NULL) {
      self$peer <- peer
      self$filters <- filters
      self$savedPeerId <- savedPeerId
      self$topMsgId <- topMsgId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      if (!is.null(self$savedPeerId)) {
        self$savedPeerId <- utils$getInputPeer(client$getInputEntity(self$savedPeerId))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetSearchCountersRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "filters" = if (is.null(self$filters)) list() else lapply(self$filters, function(x) if (inherits(x, "TLObject")) x$toDict() else x),
        "saved_peer_id" = if (inherits(self$savedPeerId, "TLObject")) self$savedPeerId$toDict() else self$savedPeerId,
        "top_msg_id" = self$topMsgId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$savedPeerId) || !self$savedPeerId) 0L else 4L) | (if (is.null(self$topMsgId) || !self$topMsgId) 0L else 1L)
      c(
        as.raw(c(0x1b, 0xbc, 0xf3, 0x00)),
        pack("<I", flags),
        self$peer$bytes(),
        if (is.null(self$savedPeerId) || !self$savedPeerId) raw(0) else self$savedPeerId$bytes(),
        if (is.null(self$topMsgId) || !self$topMsgId) raw(0) else pack("<i", self$topMsgId),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$filters)), sapply(self$filters, function(x) x$bytes())
      )
    }
  )
)

# @title fromReader
# @name GetSearchCountersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetSearchCountersRequest.
GetSearchCountersRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  peer <- reader$tgreadObject()
  savedPeerId <- if (bitwAnd(flags, 4L) != 0) reader$tgreadObject() else NULL
  topMsgId <- if (bitwAnd(flags, 1L) != 0) reader$readInt() else NULL
  reader$readInt()
  filters <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$tgreadObject()
    filters <- c(filters, list(x))
  }
  GetSearchCountersRequest$new(peer = peer, filters = filters, savedPeerId = savedPeerId, topMsgId = topMsgId)
}

#  @title GetSearchResultsCalendarRequest
#  @description Represents a request to get search results calendar. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetSearchResultsCalendarRequest <- R6::R6Class(
  "GetSearchResultsCalendarRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x6aa3f6bd,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x92c5640f,

    #  @description Initialize the GetSearchResultsCalendarRequest object.
    #  @param peer The input peer.
    #  @param filter The message filter.
    #  @param offsetId The offset ID.
    #  @param offsetDate The offset date.
    #  @param savedPeerId Optional saved peer ID.
    initialize = function(peer, filter, offsetId, offsetDate, savedPeerId = NULL) {
      self$peer <- peer
      self$filter <- filter
      self$offsetId <- offsetId
      self$offsetDate <- offsetDate
      self$savedPeerId <- savedPeerId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      if (!is.null(self$savedPeerId)) {
        self$savedPeerId <- utils$getInputPeer(client$getInputEntity(self$savedPeerId))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetSearchResultsCalendarRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "filter" = if (inherits(self$filter, "TLObject")) self$filter$toDict() else self$filter,
        "offset_id" = self$offsetId,
        "offset_date" = self$offsetDate,
        "saved_peer_id" = if (inherits(self$savedPeerId, "TLObject")) self$savedPeerId$toDict() else self$savedPeerId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$savedPeerId) || !self$savedPeerId) 0L else 4L
      c(
        as.raw(c(0x6a, 0xa3, 0xf6, 0xbd)),
        pack("<I", flags),
        self$peer$bytes(),
        if (is.null(self$savedPeerId) || !self$savedPeerId) raw(0) else self$savedPeerId$bytes(),
        self$filter$bytes(),
        pack("<i", self$offsetId),
        self$serialize_datetime(self$offsetDate)
      )
    }
  )
)

# @title fromReader
# @name GetSearchResultsCalendarRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetSearchResultsCalendarRequest.
GetSearchResultsCalendarRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  peer <- reader$tgreadObject()
  savedPeerId <- if (bitwAnd(flags, 4L) != 0) reader$tgreadObject() else NULL
  filter <- reader$tgreadObject()
  offsetId <- reader$readInt()
  offsetDate <- reader$tgreadDate()
  GetSearchResultsCalendarRequest$new(peer = peer, filter = filter, offsetId = offsetId, offsetDate = offsetDate, savedPeerId = savedPeerId)
}


#  @title GetSearchResultsPositionsRequest
#  @description Represents a request to get search results positions. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetSearchResultsPositionsRequest <- R6::R6Class(
  "GetSearchResultsPositionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x9c7f2f10,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd963708d,

    #  @description Initialize the GetSearchResultsPositionsRequest object.
    #  @param peer The input peer.
    #  @param filter The messages filter.
    #  @param offset_id The offset ID.
    #  @param limit The limit.
    #  @param saved_peer_id Optional saved peer ID.
    initialize = function(peer, filter, offset_id, limit, saved_peer_id = NULL) {
      self$peer <- peer
      self$filter <- filter
      self$offset_id <- offset_id
      self$limit <- limit
      self$saved_peer_id <- saved_peer_id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      if (!is.null(self$saved_peer_id)) {
        self$saved_peer_id <- utils$getInputPeer(client$getInputEntity(self$saved_peer_id))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetSearchResultsPositionsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "filter" = if (inherits(self$filter, "TLObject")) self$filter$toDict() else self$filter,
        "offset_id" = self$offset_id,
        "limit" = self$limit,
        "saved_peer_id" = if (inherits(self$saved_peer_id, "TLObject")) self$saved_peer_id$toDict() else self$saved_peer_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$saved_peer_id) || !self$saved_peer_id) 0L else 4L
      c(
        as.raw(c(0x9c, 0x7f, 0x2f, 0x10)),
        pack("<I", flags),
        self$peer$bytes(),
        if (is.null(self$saved_peer_id) || !self$saved_peer_id) raw(0) else self$saved_peer_id$bytes(),
        self$filter$bytes(),
        pack("<i", self$offset_id),
        pack("<i", self$limit)
      )
    }
  )
)

# @title fromReader
# @name GetSearchResultsPositionsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetSearchResultsPositionsRequest.
GetSearchResultsPositionsRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  peer <- reader$tgreadObject()
  savedPeerId <- if (bitwAnd(flags, 4L) != 0) reader$tgreadObject() else NULL
  filter <- reader$tgreadObject()
  offsetId <- reader$readInt()
  limit <- reader$readInt()
  GetSearchResultsPositionsRequest$new(peer = peer, filter = filter, offset_id = offsetId, limit = limit, saved_peer_id = savedPeerId)
}

#  @title GetSplitRangesRequest
#  @description Represents a request to get split ranges. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetSplitRangesRequest <- R6::R6Class(
  "GetSplitRangesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x1cff7e08,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x5ba52504,

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetSplitRangesRequest"
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      as.raw(c(0x1c, 0xff, 0x7e, 0x08))
    }
  )
)

# @title fromReader
# @name GetSplitRangesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetSplitRangesRequest.
GetSplitRangesRequest$fromReader <- function(reader) {
  GetSplitRangesRequest$new()
}

#  @title GetSponsoredMessagesRequest
#  @description Represents a request to get sponsored messages. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetSponsoredMessagesRequest <- R6::R6Class(
  "GetSponsoredMessagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x3d6ce850,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x7f4169e0,

    #  @description Initialize the GetSponsoredMessagesRequest object.
    #  @param peer The input peer.
    #  @param msg_id Optional message ID.
    initialize = function(peer, msg_id = NULL) {
      self$peer <- peer
      self$msg_id <- msg_id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetSponsoredMessagesRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "msg_id" = self$msg_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$msg_id) || !self$msg_id) 0L else 1L
      c(
        as.raw(c(0x3d, 0x6c, 0xe8, 0x50)),
        pack("<I", flags),
        self$peer$bytes(),
        if (is.null(self$msg_id) || !self$msg_id) raw(0) else pack("<i", self$msg_id)
      )
    }
  )
)

# @title fromReader
# @name GetSponsoredMessagesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetSponsoredMessagesRequest.
GetSponsoredMessagesRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  peer <- reader$tgreadObject()
  msgId <- if (bitwAnd(flags, 1L) != 0) reader$readInt() else NULL
  GetSponsoredMessagesRequest$new(peer = peer, msg_id = msgId)
}


#  @title GetStickerSetRequest
#  @description Represents a request to get a sticker set. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetStickerSetRequest <- R6::R6Class(
  "GetStickerSetRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xc8a0ec74,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x9b704a5a,

    #  @description Initialize the GetStickerSetRequest object.
    #  @param stickerset The input sticker set.
    #  @param hash The hash value.
    initialize = function(stickerset, hash) {
      self$stickerset <- stickerset
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetStickerSetRequest",
        "stickerset" = if (inherits(self$stickerset, "TLObject")) self$stickerset$toDict() else self$stickerset,
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xc8, 0xa0, 0xec, 0x74)),
        self$stickerset$bytes(),
        pack("<i", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetStickerSetRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetStickerSetRequest.
GetStickerSetRequest$fromReader <- function(reader) {
  stickerset <- reader$tgreadObject()
  hash <- reader$readInt()
  GetStickerSetRequest$new(stickerset = stickerset, hash = hash)
}

#  @title GetStickersRequest
#  @description Represents a request to get stickers. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetStickersRequest <- R6::R6Class(
  "GetStickersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xd5a5d3a1,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd73bb9de,

    #  @description Initialize the GetStickersRequest object.
    #  @param emoticon The emoticon string.
    #  @param hash The hash value.
    initialize = function(emoticon, hash) {
      self$emoticon <- emoticon
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetStickersRequest",
        "emoticon" = self$emoticon,
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xd5, 0xa5, 0xd3, 0xa1)),
        self$serialize_bytes(self$emoticon),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetStickersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetStickersRequest.
GetStickersRequest$fromReader <- function(reader) {
  emoticon <- reader$tgreadString()
  hash <- reader$readLong()
  GetStickersRequest$new(emoticon = emoticon, hash = hash)
}

#  @title GetSuggestedDialogFiltersRequest
#  @description Represents a request to get suggested dialog filters. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetSuggestedDialogFiltersRequest <- R6::R6Class(
  "GetSuggestedDialogFiltersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xa29cd42c,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x7b296c39,

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetSuggestedDialogFiltersRequest"
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      as.raw(c(0xa2, 0x9c, 0xd4, 0x2c))
    }
  )
)

# @title fromReader
# @name GetSuggestedDialogFiltersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetSuggestedDialogFiltersRequest.
GetSuggestedDialogFiltersRequest$fromReader <- function(reader) {
  GetSuggestedDialogFiltersRequest$new()
}

#  @title GetTopReactionsRequest
#  @description Represents a request to get top reactions. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetTopReactionsRequest <- R6::R6Class(
  "GetTopReactionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xbb8125ba,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xadc38324,

    #  @description Initialize the GetTopReactionsRequest object.
    #  @param limit The limit value.
    #  @param hash The hash value.
    initialize = function(limit, hash) {
      self$limit <- limit
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetTopReactionsRequest",
        "limit" = self$limit,
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xbb, 0x81, 0x25, 0xba)),
        pack("<i", self$limit),
        pack("<q", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetTopReactionsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetTopReactionsRequest.
GetTopReactionsRequest$fromReader <- function(reader) {
  limit <- reader$readInt()
  hash <- reader$readLong()
  GetTopReactionsRequest$new(limit = limit, hash = hash)
}


#  @title GetUnreadMentionsRequest
#  @description Represents a request to get unread mentions. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetUnreadMentionsRequest <- R6::R6Class(
  "GetUnreadMentionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xf107e790,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd4b40b5e,

    #  @description Initialize the GetUnreadMentionsRequest object.
    #  @param peer The input peer.
    #  @param offsetId The offset ID.
    #  @param addOffset The add offset.
    #  @param limit The limit.
    #  @param maxId The maximum ID.
    #  @param minId The minimum ID.
    #  @param topMsgId Optional top message ID.
    initialize = function(peer, offsetId, addOffset, limit, maxId, minId, topMsgId = NULL) {
      self$peer <- peer
      self$offsetId <- offsetId
      self$addOffset <- addOffset
      self$limit <- limit
      self$maxId <- maxId
      self$minId <- minId
      self$topMsgId <- topMsgId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetUnreadMentionsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "offsetId" = self$offsetId,
        "addOffset" = self$addOffset,
        "limit" = self$limit,
        "maxId" = self$maxId,
        "minId" = self$minId,
        "topMsgId" = self$topMsgId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$topMsgId) || !self$topMsgId) 0L else 1L
      c(
        as.raw(c(0x90, 0xe7, 0x07, 0xf1)),
        pack("<I", flags),
        self$peer$bytes(),
        if (is.null(self$topMsgId) || !self$topMsgId) raw() else pack("<i", self$topMsgId),
        pack("<i", self$offsetId),
        pack("<i", self$addOffset),
        pack("<i", self$limit),
        pack("<i", self$maxId),
        pack("<i", self$minId)
      )
    }
  )
)

# @title fromReader
# @name GetUnreadMentionsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetUnreadMentionsRequest.
GetUnreadMentionsRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  peer <- reader$tgreadObject()
  topMsgId <- if (bitwAnd(flags, 1L) != 0) reader$readInt() else NULL
  offsetId <- reader$readInt()
  addOffset <- reader$readInt()
  limit <- reader$readInt()
  maxId <- reader$readInt()
  minId <- reader$readInt()
  GetUnreadMentionsRequest$new(peer = peer, offsetId = offsetId, addOffset = addOffset, limit = limit, maxId = maxId, minId = minId, topMsgId = topMsgId)
}

#  @title GetUnreadReactionsRequest
#  @description Represents a request to get unread reactions. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetUnreadReactionsRequest <- R6::R6Class(
  "GetUnreadReactionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xbd7f90ac,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd4b40b5e,

    #  @description Initialize the GetUnreadReactionsRequest object.
    #  @param peer The input peer.
    #  @param offsetId The offset ID.
    #  @param addOffset The add offset.
    #  @param limit The limit.
    #  @param maxId The maximum ID.
    #  @param minId The minimum ID.
    #  @param topMsgId Optional top message ID.
    #  @param savedPeerId Optional saved peer ID.
    initialize = function(peer, offsetId, addOffset, limit, maxId, minId, topMsgId = NULL, savedPeerId = NULL) {
      self$peer <- peer
      self$offsetId <- offsetId
      self$addOffset <- addOffset
      self$limit <- limit
      self$maxId <- maxId
      self$minId <- minId
      self$topMsgId <- topMsgId
      self$savedPeerId <- savedPeerId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      if (!is.null(self$savedPeerId)) {
        self$savedPeerId <- utils$getInputPeer(client$getInputEntity(self$savedPeerId))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetUnreadReactionsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "offsetId" = self$offsetId,
        "addOffset" = self$addOffset,
        "limit" = self$limit,
        "maxId" = self$maxId,
        "minId" = self$minId,
        "topMsgId" = self$topMsgId,
        "savedPeerId" = if (inherits(self$savedPeerId, "TLObject")) self$savedPeerId$toDict() else self$savedPeerId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$topMsgId) || !self$topMsgId) 0L else 1L) | (if (is.null(self$savedPeerId) || !self$savedPeerId) 0L else 2L)
      c(
        as.raw(c(0xac, 0x90, 0x7f, 0xbd)),
        pack("<I", flags),
        self$peer$bytes(),
        if (is.null(self$topMsgId) || !self$topMsgId) raw() else pack("<i", self$topMsgId),
        if (is.null(self$savedPeerId) || !self$savedPeerId) raw() else self$savedPeerId$bytes(),
        pack("<i", self$offsetId),
        pack("<i", self$addOffset),
        pack("<i", self$limit),
        pack("<i", self$maxId),
        pack("<i", self$minId)
      )
    }
  )
)

# @title fromReader
# @name GetUnreadReactionsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetUnreadReactionsRequest.
GetUnreadReactionsRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  peer <- reader$tgreadObject()
  topMsgId <- if (bitwAnd(flags, 1L) != 0) reader$readInt() else NULL
  savedPeerId <- if (bitwAnd(flags, 2L) != 0) reader$tgreadObject() else NULL
  offsetId <- reader$readInt()
  addOffset <- reader$readInt()
  limit <- reader$readInt()
  maxId <- reader$readInt()
  minId <- reader$readInt()
  GetUnreadReactionsRequest$new(peer = peer, offsetId = offsetId, addOffset = addOffset, limit = limit, maxId = maxId, minId = minId, topMsgId = topMsgId, savedPeerId = savedPeerId)
}

#  @title GetWebPageRequest
#  @description Represents a request to get a web page. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetWebPageRequest <- R6::R6Class(
  "GetWebPageRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x8d9692a3,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x2cf8b154,

    #  @description Initialize the GetWebPageRequest object.
    #  @param url The URL string.
    #  @param hash The hash value.
    initialize = function(url, hash) {
      self$url <- url
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetWebPageRequest",
        "url" = self$url,
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xa3, 0x92, 0x96, 0x8d)),
        self$serialize_bytes(self$url),
        pack("<i", self$hash)
      )
    }
  )
)

# @title fromReader
# @name GetWebPageRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetWebPageRequest.
GetWebPageRequest$fromReader <- function(reader) {
  url <- reader$tgreadString()
  hash <- reader$readInt()
  GetWebPageRequest$new(url = url, hash = hash)
}


#  @title GetWebPagePreviewRequest
#  @description Represents a request to get a web page preview. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetWebPagePreviewRequest <- R6::R6Class(
  "GetWebPagePreviewRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x570d6f6f,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xe29410c2,

    #  @description Initialize the GetWebPagePreviewRequest object.
    #  @param message The message string.
    #  @param entities Optional list of message entities.
    initialize = function(message, entities = NULL) {
      self$message <- message
      self$entities <- entities
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetWebPagePreviewRequest",
        "message" = self$message,
        "entities" = if (is.null(self$entities)) list() else lapply(self$entities, function(x) if (inherits(x, "TLObject")) x$toDict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$entities) || !self$entities) 0L else 8L
      c(
        as.raw(c(0x6f, 0x6f, 0x0d, 0x57)),
        pack("<I", flags),
        self$serialize_bytes(self$message),
        if (is.null(self$entities) || !self$entities) raw() else c(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$entities)), do.call(c, lapply(self$entities, function(x) x$bytes())))
      )
    }
  )
)

# @title fromReader
# @name GetWebPagePreviewRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of GetWebPagePreviewRequest.
GetWebPagePreviewRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  message <- reader$tgreadString()
  if (bitwAnd(flags, 8L) != 0) {
    reader$readInt()
    entities <- list()
    for (i in 1:reader$readInt()) {
      x <- reader$tgreadObject()
      entities <- c(entities, x)
    }
  } else {
    entities <- NULL
  }
  GetWebPagePreviewRequest$new(message = message, entities = entities)
}

#  @title HideAllChatJoinRequestsRequest
#  @description Represents a request to hide all chat join requests. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
HideAllChatJoinRequestsRequest <- R6::R6Class(
  "HideAllChatJoinRequestsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xe085f4ea,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the HideAllChatJoinRequestsRequest object.
    #  @param peer The input peer.
    #  @param approved Optional approved flag.
    #  @param link Optional link string.
    initialize = function(peer, approved = NULL, link = NULL) {
      self$peer <- peer
      self$approved <- approved
      self$link <- link
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "HideAllChatJoinRequestsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "approved" = self$approved,
        "link" = self$link
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$approved) || !self$approved) 0L else 1L) | (if (is.null(self$link) || !self$link) 0L else 2L)
      c(
        as.raw(c(0xea, 0xf4, 0x85, 0xe0)),
        pack("<I", flags),
        self$peer$bytes(),
        if (is.null(self$link) || !self$link) raw() else self$serialize_bytes(self$link)
      )
    }
  )
)

# @title fromReader
# @name HideAllChatJoinRequestsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of HideAllChatJoinRequestsRequest.
HideAllChatJoinRequestsRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  approved <- bitwAnd(flags, 1L) != 0
  peer <- reader$tgreadObject()
  link <- if (bitwAnd(flags, 2L) != 0) reader$tgreadString() else NULL
  HideAllChatJoinRequestsRequest$new(peer = peer, approved = approved, link = link)
}

#  @title HideChatJoinRequestRequest
#  @description Represents a request to hide a chat join request. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
HideChatJoinRequestRequest <- R6::R6Class(
  "HideChatJoinRequestRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x7fe7e815,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the HideChatJoinRequestRequest object.
    #  @param peer The input peer.
    #  @param userId The input user ID.
    #  @param approved Optional approved flag.
    initialize = function(peer, userId, approved = NULL) {
      self$peer <- peer
      self$userId <- userId
      self$approved <- approved
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      self$userId <- utils$getInputUser(client$getInputEntity(self$userId))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "HideChatJoinRequestRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "user_id" = if (inherits(self$userId, "TLObject")) self$userId$toDict() else self$userId,
        "approved" = self$approved
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$approved) || !self$approved) 0L else 1L
      c(
        as.raw(c(0x15, 0xe8, 0xe7, 0x7f)),
        pack("<I", flags),
        self$peer$bytes(),
        self$userId$bytes()
      )
    }
  )
)

# @title fromReader
# @name HideChatJoinRequestRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of HideChatJoinRequestRequest.
HideChatJoinRequestRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  approved <- bitwAnd(flags, 1L) != 0
  peer <- reader$tgreadObject()
  userId <- reader$tgreadObject()
  HideChatJoinRequestRequest$new(peer = peer, userId = userId, approved = approved)
}


#  @title HidePeerSettingsBarRequest
#  @description Represents a request to hide peer settings bar. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
HidePeerSettingsBarRequest <- R6::R6Class(
  "HidePeerSettingsBarRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x4facb138,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the HidePeerSettingsBarRequest object.
    #  @param peer The input peer.
    initialize = function(peer) {
      self$peer <- peer
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "HidePeerSettingsBarRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x38, 0xb1, 0xac, 0x4f)),
        self$peer$bytes()
      )
    }
  )
)

# @title fromReader
# @name HidePeerSettingsBarRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of HidePeerSettingsBarRequest.
HidePeerSettingsBarRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  HidePeerSettingsBarRequest$new(peer = peer)
}

#  @title ImportChatInviteRequest
#  @description Represents a request to import a chat invite. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ImportChatInviteRequest <- R6::R6Class(
  "ImportChatInviteRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x6c50051c,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field hash The invite hash.
    hash = NULL,

    #  @description Initialize the ImportChatInviteRequest object.
    #  @param hash The invite hash.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ImportChatInviteRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x1c, 0x05, 0x50, 0x6c)),
        self$serialize_bytes(self$hash)
      )
    }
  )
)

# @title fromReader
# @name ImportChatInviteRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ImportChatInviteRequest.
ImportChatInviteRequest$fromReader <- function(reader) {
  hash <- reader$tgreadString()
  ImportChatInviteRequest$new(hash = hash)
}

#  @title InitHistoryImportRequest
#  @description Represents a request to initialize history import. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
InitHistoryImportRequest <- R6::R6Class(
  "InitHistoryImportRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x34090c3b,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xb18bb50a,

    #  @description Initialize the InitHistoryImportRequest object.
    #  @param peer The input peer.
    #  @param file The input file.
    #  @param mediaCount The media count.
    initialize = function(peer, file, mediaCount) {
      self$peer <- peer
      self$file <- file
      self$mediaCount <- mediaCount
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "InitHistoryImportRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "file" = if (inherits(self$file, "TLObject")) self$file$toDict() else self$file,
        "mediaCount" = self$mediaCount
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x3b, 0x0c, 0x09, 0x34)),
        self$peer$bytes(),
        self$file$bytes(),
        packBits(intToBits(self$mediaCount)[1:32], type = "raw") # Assuming little-endian int32
      )
    }
  )
)

# @title fromReader
# @name InitHistoryImportRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of InitHistoryImportRequest.
InitHistoryImportRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  file <- reader$tgreadObject()
  mediaCount <- reader$readInt()
  InitHistoryImportRequest$new(peer = peer, file = file, mediaCount = mediaCount)
}


#  @title InstallStickerSetRequest
#  @description Represents a request to install a sticker set. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
InstallStickerSetRequest <- R6::R6Class(
  "InstallStickerSetRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xc78fe460,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x67cb3fe8,

    #  @description Initialize the InstallStickerSetRequest object.
    #  @param stickerset The input sticker set.
    #  @param archived Whether the sticker set is archived.
    initialize = function(stickerset, archived) {
      self$stickerset <- stickerset
      self$archived <- archived
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "InstallStickerSetRequest",
        "stickerset" = if (inherits(self$stickerset, "TLObject")) self$stickerset$toDict() else self$stickerset,
        "archived" = self$archived
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x60, 0xe4, 0x8f, 0xc7)),
        self$stickerset$bytes(),
        if (self$archived) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  )
)

# @title fromReader
# @name InstallStickerSetRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of InstallStickerSetRequest.
InstallStickerSetRequest$fromReader <- function(reader) {
  stickerset <- reader$tgreadObject()
  archived <- reader$tgreadBool()
  InstallStickerSetRequest$new(stickerset = stickerset, archived = archived)
}

#  @title MarkDialogUnreadRequest
#  @description Represents a request to mark a dialog as unread. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
MarkDialogUnreadRequest <- R6::R6Class(
  "MarkDialogUnreadRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x8c5006f8,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the MarkDialogUnreadRequest object.
    #  @param peer The input dialog peer.
    #  @param unread Optional unread flag.
    #  @param parentPeer Optional parent peer.
    initialize = function(peer, unread = NULL, parentPeer = NULL) {
      self$peer <- peer
      self$unread <- unread
      self$parentPeer <- parentPeer
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- client$getInputDialog(self$peer)
      if (!is.null(self$parentPeer)) {
        self$parentPeer <- utils$getInputPeer(client$getInputEntity(self$parentPeer))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "MarkDialogUnreadRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "unread" = self$unread,
        "parent_peer" = if (inherits(self$parentPeer, "TLObject")) self$parentPeer$toDict() else self$parentPeer
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$unread) && self$unread) flags <- bitwOr(flags, 1L)
      if (!is.null(self$parentPeer) && self$parentPeer) flags <- bitwOr(flags, 2L)
      c(
        as.raw(c(0xf8, 0x06, 0x50, 0x8c)),
        writeBin(flags, raw(), size = 4, endian = "little"),
        if (!is.null(self$parentPeer) && self$parentPeer) self$parentPeer$bytes() else raw(),
        self$peer$bytes()
      )
    }
  )
)

# @title fromReader
# @name MarkDialogUnreadRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of MarkDialogUnreadRequest.
MarkDialogUnreadRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  unread <- bitwAnd(flags, 1L) != 0
  parentPeer <- if (bitwAnd(flags, 2L) != 0) reader$tgreadObject() else NULL
  peer <- reader$tgreadObject()
  MarkDialogUnreadRequest$new(peer = peer, unread = unread, parentPeer = parentPeer)
}

#  @title MigrateChatRequest
#  @description Represents a request to migrate a chat. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
MigrateChatRequest <- R6::R6Class(
  "MigrateChatRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xa2875319,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the MigrateChatRequest object.
    #  @param chatId The chat ID.
    initialize = function(chatId) {
      self$chatId <- chatId
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "MigrateChatRequest",
        "chat_id" = self$chatId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x19, 0x53, 0x87, 0xa2)),
        writeBin(self$chatId, raw(), size = 8, endian = "little")
      )
    }
  )
)

# @title fromReader
# @name MigrateChatRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of MigrateChatRequest.
MigrateChatRequest$fromReader <- function(reader) {
  chatId <- reader$readLong()
  MigrateChatRequest$new(chatId = chatId)
}


#  @title ProlongWebViewRequest
#  @description Represents a request to prolong a web view. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ProlongWebViewRequest <- R6::R6Class(
  "ProlongWebViewRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xb0d81a83,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ProlongWebViewRequest object.
    #  @param peer The input peer.
    #  @param bot The input bot user.
    #  @param queryId The query ID.
    #  @param silent Optional silent flag.
    #  @param replyTo Optional reply to.
    #  @param sendAs Optional send as peer.
    initialize = function(peer, bot, queryId, silent = NULL, replyTo = NULL, sendAs = NULL) {
      self$peer <- peer
      self$bot <- bot
      self$queryId <- queryId
      self$silent <- silent
      self$replyTo <- replyTo
      self$sendAs <- sendAs
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      self$bot <- utils$getInputUser(client$getInputEntity(self$bot))
      if (!is.null(self$sendAs)) {
        self$sendAs <- utils$getInputPeer(client$getInputEntity(self$sendAs))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ProlongWebViewRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "bot" = if (inherits(self$bot, "TLObject")) self$bot$toDict() else self$bot,
        "query_id" = self$queryId,
        "silent" = self$silent,
        "reply_to" = if (inherits(self$replyTo, "TLObject")) self$replyTo$toDict() else self$replyTo,
        "send_as" = if (inherits(self$sendAs, "TLObject")) self$sendAs$toDict() else self$sendAs
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$silent) && self$silent) flags <- bitwOr(flags, 32L)
      if (!is.null(self$replyTo) && self$replyTo) flags <- bitwOr(flags, 1L)
      if (!is.null(self$sendAs) && self$sendAs) flags <- bitwOr(flags, 8192L)
      c(
        as.raw(c(0x83, 0x1a, 0xd8, 0xb0)),
        writeBin(flags, raw(), size = 4, endian = "little"),
        self$peer$bytes(),
        self$bot$bytes(),
        writeBin(self$queryId, raw(), size = 8, endian = "little"),
        if (!is.null(self$replyTo) && self$replyTo) self$replyTo$bytes() else raw(),
        if (!is.null(self$sendAs) && self$sendAs) self$sendAs$bytes() else raw()
      )
    }
  )
)

# @title fromReader
# @name ProlongWebViewRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ProlongWebViewRequest.
ProlongWebViewRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  silent <- bitwAnd(flags, 32L) != 0
  peer <- reader$tgreadObject()
  bot <- reader$tgreadObject()
  queryId <- reader$readLong()
  replyTo <- if (bitwAnd(flags, 1L) != 0) reader$tgreadObject() else NULL
  sendAs <- if (bitwAnd(flags, 8192L) != 0) reader$tgreadObject() else NULL
  ProlongWebViewRequest$new(peer = peer, bot = bot, queryId = queryId, silent = silent, replyTo = replyTo, sendAs = sendAs)
}

#  @title RateTranscribedAudioRequest
#  @description Represents a request to rate transcribed audio. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
RateTranscribedAudioRequest <- R6::R6Class(
  "RateTranscribedAudioRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x7f1d072f,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the RateTranscribedAudioRequest object.
    #  @param peer The input peer.
    #  @param msgId The message ID.
    #  @param transcriptionId The transcription ID.
    #  @param good The good flag.
    initialize = function(peer, msgId, transcriptionId, good) {
      self$peer <- peer
      self$msgId <- msgId
      self$transcriptionId <- transcriptionId
      self$good <- good
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "RateTranscribedAudioRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "msg_id" = self$msgId,
        "transcription_id" = self$transcriptionId,
        "good" = self$good
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x2f, 0x07, 0x1d, 0x7f)),
        self$peer$bytes(),
        writeBin(self$msgId, raw(), size = 4, endian = "little"),
        writeBin(self$transcriptionId, raw(), size = 8, endian = "little"),
        if (self$good) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  )
)

# @title fromReader
# @name RateTranscribedAudioRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of RateTranscribedAudioRequest.
RateTranscribedAudioRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  msgId <- reader$readInt()
  transcriptionId <- reader$readLong()
  good <- reader$tgreadBool()
  RateTranscribedAudioRequest$new(peer = peer, msgId = msgId, transcriptionId = transcriptionId, good = good)
}

#  @title ReadDiscussionRequest
#  @description Represents a request to read discussion. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReadDiscussionRequest <- R6::R6Class(
  "ReadDiscussionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xf731a9f4,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ReadDiscussionRequest object.
    #  @param peer The input peer.
    #  @param msgId The message ID.
    #  @param readMaxId The read max ID.
    initialize = function(peer, msgId, readMaxId) {
      self$peer <- peer
      self$msgId <- msgId
      self$readMaxId <- readMaxId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ReadDiscussionRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "msg_id" = self$msgId,
        "read_max_id" = self$readMaxId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xf4, 0xa9, 0x31, 0xf7)),
        self$peer$bytes(),
        writeBin(self$msgId, raw(), size = 4, endian = "little"),
        writeBin(self$readMaxId, raw(), size = 4, endian = "little")
      )
    }
  )
)

# @title fromReader
# @name ReadDiscussionRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReadDiscussionRequest.
ReadDiscussionRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  msgId <- reader$readInt()
  readMaxId <- reader$readInt()
  ReadDiscussionRequest$new(peer = peer, msgId = msgId, readMaxId = readMaxId)
}


#  @title ReadEncryptedHistoryRequest
#  @description Represents a request to read encrypted history. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReadEncryptedHistoryRequest <- R6::R6Class(
  "ReadEncryptedHistoryRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x7f4b690a,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ReadEncryptedHistoryRequest object.
    #  @param peer The input encrypted chat peer.
    #  @param maxDate Optional maximum date.
    initialize = function(peer, maxDate = NULL) {
      self$peer <- peer
      self$maxDate <- maxDate
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ReadEncryptedHistoryRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "max_date" = self$maxDate
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x0a, 0x69, 0x4b, 0x7f)),
        self$peer$bytes(),
        self$serialize_datetime(self$maxDate)
      )
    }
  )
)

# @title fromReader
# @name ReadEncryptedHistoryRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReadEncryptedHistoryRequest.
ReadEncryptedHistoryRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  maxDate <- reader$tgreadDate()
  ReadEncryptedHistoryRequest$new(peer = peer, maxDate = maxDate)
}

#  @title ReadFeaturedStickersRequest
#  @description Represents a request to read featured stickers. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReadFeaturedStickersRequest <- R6::R6Class(
  "ReadFeaturedStickersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x5b118126,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ReadFeaturedStickersRequest object.
    #  @param id The list of sticker IDs.
    initialize = function(id) {
      self$id <- id
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ReadFeaturedStickersRequest",
        "id" = if (is.null(self$id)) list() else self$id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x26, 0x81, 0x11, 0x5b)),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        writeBin(length(self$id), raw(), size = 4, endian = "little"),
        unlist(lapply(self$id, function(x) writeBin(x, raw(), size = 8, endian = "little")))
      )
    }
  )
)

# @title fromReader
# @name ReadFeaturedStickersRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReadFeaturedStickersRequest.
ReadFeaturedStickersRequest$fromReader <- function(reader) {
  reader$readInt()
  id <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$readLong()
    id <- c(id, x)
  }
  ReadFeaturedStickersRequest$new(id = id)
}

#  @title ReadHistoryRequest
#  @description Represents a request to read history. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReadHistoryRequest <- R6::R6Class(
  "ReadHistoryRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xe306d3a,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xced3c06e,

    #  @description Initialize the ReadHistoryRequest object.
    #  @param peer The input peer.
    #  @param maxId The maximum ID.
    initialize = function(peer, maxId) {
      self$peer <- peer
      self$maxId <- maxId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ReadHistoryRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "max_id" = self$maxId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x3a, 0x6d, 0x30, 0x0e)),
        self$peer$bytes(),
        writeBin(self$maxId, raw(), size = 4, endian = "little")
      )
    }
  )
)

# @title fromReader
# @name ReadHistoryRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReadHistoryRequest.
ReadHistoryRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  maxId <- reader$readInt()
  ReadHistoryRequest$new(peer = peer, maxId = maxId)
}


#  @title ReadMentionsRequest
#  @description Represents a request to read mentions. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReadMentionsRequest <- R6::R6Class(
  "ReadMentionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x36e5bf4d,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x2c49c116,

    #  @description Initialize the ReadMentionsRequest object.
    #  @param peer The input peer.
    #  @param topMsgId Optional top message ID.
    initialize = function(peer, topMsgId = NULL) {
      self$peer <- peer
      self$topMsgId <- topMsgId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ReadMentionsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "top_msg_id" = self$topMsgId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$topMsgId) || !self$topMsgId) 0L else 1L
      c(
        as.raw(c(0x36, 0xe5, 0xbf, 0x4d)),
        writeBin(flags, raw(), size = 4, endian = "little"),
        self$peer$bytes(),
        if (!is.null(self$topMsgId) && self$topMsgId) writeBin(self$topMsgId, raw(), size = 4, endian = "little") else raw()
      )
    }
  )
)

# @title fromReader
# @name ReadMentionsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReadMentionsRequest.
ReadMentionsRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  peer <- reader$tgreadObject()
  topMsgId <- if (bitwAnd(flags, 1L) != 0) reader$readInt() else NULL
  ReadMentionsRequest$new(peer = peer, topMsgId = topMsgId)
}

#  @title ReadMessageContentsRequest
#  @description Represents a request to read message contents. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReadMessageContentsRequest <- R6::R6Class(
  "ReadMessageContentsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x36a73f77,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xced3c06e,

    #  @description Initialize the ReadMessageContentsRequest object.
    #  @param id The list of message IDs.
    initialize = function(id) {
      self$id <- id
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ReadMessageContentsRequest",
        "id" = if (is.null(self$id)) list() else self$id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x36, 0xa7, 0x3f, 0x77)),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        writeBin(length(self$id), raw(), size = 4, endian = "little"),
        unlist(lapply(self$id, function(x) writeBin(x, raw(), size = 4, endian = "little")))
      )
    }
  )
)

# @title fromReader
# @name ReadMessageContentsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReadMessageContentsRequest.
ReadMessageContentsRequest$fromReader <- function(reader) {
  reader$readInt()
  id <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$readInt()
    id <- c(id, x)
  }
  ReadMessageContentsRequest$new(id = id)
}

#  @title ReadReactionsRequest
#  @description Represents a request to read reactions. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReadReactionsRequest <- R6::R6Class(
  "ReadReactionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x9ec44f93,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x2c49c116,

    #  @description Initialize the ReadReactionsRequest object.
    #  @param peer The input peer.
    #  @param topMsgId Optional top message ID.
    #  @param savedPeerId Optional saved peer ID.
    initialize = function(peer, topMsgId = NULL, savedPeerId = NULL) {
      self$peer <- peer
      self$topMsgId <- topMsgId
      self$savedPeerId <- savedPeerId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      if (!is.null(self$savedPeerId)) {
        self$savedPeerId <- utils$getInputPeer(client$getInputEntity(self$savedPeerId))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ReadReactionsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "top_msg_id" = self$topMsgId,
        "saved_peer_id" = if (inherits(self$savedPeerId, "TLObject")) self$savedPeerId$toDict() else self$savedPeerId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$topMsgId) && self$topMsgId) flags <- bitwOr(flags, 1L)
      if (!is.null(self$savedPeerId) && self$savedPeerId) flags <- bitwOr(flags, 2L)
      c(
        as.raw(c(0x9e, 0xc4, 0x4f, 0x93)),
        writeBin(flags, raw(), size = 4, endian = "little"),
        self$peer$bytes(),
        if (!is.null(self$topMsgId) && self$topMsgId) writeBin(self$topMsgId, raw(), size = 4, endian = "little") else raw(),
        if (!is.null(self$savedPeerId) && self$savedPeerId) self$savedPeerId$bytes() else raw()
      )
    }
  )
)

# @title fromReader
# @name ReadReactionsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReadReactionsRequest.
ReadReactionsRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  peer <- reader$tgreadObject()
  topMsgId <- if (bitwAnd(flags, 1L) != 0) reader$readInt() else NULL
  savedPeerId <- if (bitwAnd(flags, 2L) != 0) reader$tgreadObject() else NULL
  ReadReactionsRequest$new(peer = peer, topMsgId = topMsgId, savedPeerId = savedPeerId)
}


#  @title ReadSavedHistoryRequest
#  @description Represents a request to read saved history. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReadSavedHistoryRequest <- R6::R6Class(
  "ReadSavedHistoryRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xba4a3b5b,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ReadSavedHistoryRequest object.
    #  @param parentPeer The input peer for the parent.
    #  @param peer The input peer.
    #  @param maxId The maximum ID.
    initialize = function(parentPeer, peer, maxId) {
      self$parentPeer <- parentPeer
      self$peer <- peer
      self$maxId <- maxId
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$parentPeer <- utils$getInputPeer(client$getInputEntity(self$parentPeer))
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ReadSavedHistoryRequest",
        "parent_peer" = if (inherits(self$parentPeer, "TLObject")) self$parentPeer$toDict() else self$parentPeer,
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "max_id" = self$maxId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xba, 0x4a, 0x3b, 0x5b)),
        self$parentPeer$bytes(),
        self$peer$bytes(),
        writeBin(self$maxId, raw(), size = 4, endian = "little")
      )
    }
  )
)

# @title fromReader
# @name ReadSavedHistoryRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReadSavedHistoryRequest.
ReadSavedHistoryRequest$fromReader <- function(reader) {
  parentPeer <- reader$tgreadObject()
  peer <- reader$tgreadObject()
  maxId <- reader$readInt()
  ReadSavedHistoryRequest$new(parentPeer = parentPeer, peer = peer, maxId = maxId)
}

#  @title ReceivedMessagesRequest
#  @description Represents a request to receive messages. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReceivedMessagesRequest <- R6::R6Class(
  "ReceivedMessagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x5a954c0,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8565f897,

    #  @description Initialize the ReceivedMessagesRequest object.
    #  @param maxId The maximum ID.
    initialize = function(maxId) {
      self$maxId <- maxId
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ReceivedMessagesRequest",
        "max_id" = self$maxId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xc0, 0x54, 0xa9, 0x05)),
        writeBin(self$maxId, raw(), size = 4, endian = "little")
      )
    }
  )
)

# @title fromReader
# @name ReceivedMessagesRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReceivedMessagesRequest.
ReceivedMessagesRequest$fromReader <- function(reader) {
  maxId <- reader$readInt()
  ReceivedMessagesRequest$new(maxId = maxId)
}

#  @title ReceivedQueueRequest
#  @description Represents a request to receive queue. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReceivedQueueRequest <- R6::R6Class(
  "ReceivedQueueRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x55a5bb66,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8918e168,

    #  @description Initialize the ReceivedQueueRequest object.
    #  @param maxQts The maximum QTS.
    initialize = function(maxQts) {
      self$maxQts <- maxQts
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ReceivedQueueRequest",
        "max_qts" = self$maxQts
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x66, 0xbb, 0xa5, 0x55)),
        writeBin(self$maxQts, raw(), size = 4, endian = "little")
      )
    }
  )
)

# @title fromReader
# @name ReceivedQueueRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReceivedQueueRequest.
ReceivedQueueRequest$fromReader <- function(reader) {
  maxQts <- reader$readInt()
  ReceivedQueueRequest$new(maxQts = maxQts)
}

# @title readResult
# @name ReceivedQueueRequest_readResult
# @description Static method to read the result from a reader.
# @param reader The reader object.
# @return A list of long values.
ReceivedQueueRequest$readResult <- function(reader) {
  reader$readInt() # Vector ID
  sapply(1:reader$readInt(), function(x) reader$readLong())
}


#  @title ReorderPinnedDialogsRequest
#  @description Represents a request to reorder pinned dialogs. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReorderPinnedDialogsRequest <- R6::R6Class(
  "ReorderPinnedDialogsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x3b1adf37,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ReorderPinnedDialogsRequest object.
    #  @param folder_id The folder ID.
    #  @param order The list of input dialog peers.
    #  @param force Optional force flag.
    initialize = function(folder_id, order, force = NULL) {
      self$folder_id <- folder_id
      self$order <- order
      self$force <- force
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      tmp <- list()
      for (x in self$order) {
        tmp <- c(tmp, client$get_input_dialog(x))
      }
      self$order <- tmp
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ReorderPinnedDialogsRequest",
        "folder_id" = self$folder_id,
        "order" = if (is.null(self$order)) list() else lapply(self$order, function(x) if (inherits(x, "TLObject")) x$to_dict() else x),
        "force" = self$force
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$force) || !self$force) 0L else 1L
      c(
        as.raw(c(0x37, 0xdf, 0x1a, 0x3b)),
        packBits(intToBits(flags), type = "integer"),
        packBits(intToBits(self$folder_id), type = "integer"),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        packBits(intToBits(length(self$order)), type = "integer"),
        unlist(lapply(self$order, function(x) x$bytes()))
      )
    }
  )
)

# @title from_reader
# @name ReorderPinnedDialogsRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReorderPinnedDialogsRequest.
ReorderPinnedDialogsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  force <- bitwAnd(flags, 1L) != 0
  folder_id <- reader$read_int()
  reader$read_int()
  order <- list()
  for (i in 1:reader$read_int()) {
    x <- reader$tgread_object()
    order <- c(order, x)
  }
  ReorderPinnedDialogsRequest$new(folder_id = folder_id, order = order, force = force)
}

#  @title ReorderPinnedSavedDialogsRequest
#  @description Represents a request to reorder pinned saved dialogs. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReorderPinnedSavedDialogsRequest <- R6::R6Class(
  "ReorderPinnedSavedDialogsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x8b716587,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ReorderPinnedSavedDialogsRequest object.
    #  @param order The list of input dialog peers.
    #  @param force Optional force flag.
    initialize = function(order, force = NULL) {
      self$order <- order
      self$force <- force
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      tmp <- list()
      for (x in self$order) {
        tmp <- c(tmp, client$get_input_dialog(x))
      }
      self$order <- tmp
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ReorderPinnedSavedDialogsRequest",
        "order" = if (is.null(self$order)) list() else lapply(self$order, function(x) if (inherits(x, "TLObject")) x$to_dict() else x),
        "force" = self$force
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$force) || !self$force) 0L else 1L
      c(
        as.raw(c(0x87, 0x65, 0x71, 0x8b)),
        packBits(intToBits(flags), type = "integer"),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        packBits(intToBits(length(self$order)), type = "integer"),
        unlist(lapply(self$order, function(x) x$bytes()))
      )
    }
  )
)

# @title from_reader
# @name ReorderPinnedSavedDialogsRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReorderPinnedSavedDialogsRequest.
ReorderPinnedSavedDialogsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  force <- bitwAnd(flags, 1L) != 0
  reader$read_int()
  order <- list()
  for (i in 1:reader$read_int()) {
    x <- reader$tgread_object()
    order <- c(order, x)
  }
  ReorderPinnedSavedDialogsRequest$new(order = order, force = force)
}

#  @title ReorderQuickRepliesRequest
#  @description Represents a request to reorder quick replies. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReorderQuickRepliesRequest <- R6::R6Class(
  "ReorderQuickRepliesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x60331907,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ReorderQuickRepliesRequest object.
    #  @param order The list of order IDs.
    initialize = function(order) {
      self$order <- order
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ReorderQuickRepliesRequest",
        "order" = if (is.null(self$order)) list() else self$order
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x07, 0x19, 0x33, 0x60)),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        packBits(intToBits(length(self$order)), type = "integer"),
        unlist(lapply(self$order, function(x) packBits(intToBits(x), type = "integer")))
      )
    }
  )
)

# @title from_reader
# @name ReorderQuickRepliesRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReorderQuickRepliesRequest.
ReorderQuickRepliesRequest$from_reader <- function(reader) {
  reader$read_int()
  order <- list()
  for (i in 1:reader$read_int()) {
    x <- reader$read_int()
    order <- c(order, x)
  }
  ReorderQuickRepliesRequest$new(order = order)
}


#  @title ReorderStickerSetsRequest
#  @description Represents a request to reorder sticker sets. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReorderStickerSetsRequest <- R6::R6Class(
  "ReorderStickerSetsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x78337739,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ReorderStickerSetsRequest object.
    #  @param order The list of sticker set IDs.
    #  @param masks Optional masks flag.
    #  @param emojis Optional emojis flag.
    initialize = function(order, masks = NULL, emojis = NULL) {
      self$order <- order
      self$masks <- masks
      self$emojis <- emojis
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ReorderStickerSetsRequest",
        "order" = if (is.null(self$order)) list() else self$order,
        "masks" = self$masks,
        "emojis" = self$emojis
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$masks) && self$masks) flags <- bitwOr(flags, 1L)
      if (!is.null(self$emojis) && self$emojis) flags <- bitwOr(flags, 2L)
      c(
        as.raw(c(0x39, 0x77, 0x33, 0x78)),
        packBits(intToBits(flags), type = "integer"),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        packBits(intToBits(length(self$order)), type = "integer"),
        unlist(lapply(self$order, function(x) packBits(intToBits(x), type = "integer")))
      )
    }
  )
)

# @title fromReader
# @name ReorderStickerSetsRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReorderStickerSetsRequest.
ReorderStickerSetsRequest$fromReader <- function(reader) {
  flags <- reader$readInt()
  masks <- bitwAnd(flags, 1L) != 0
  emojis <- bitwAnd(flags, 2L) != 0
  reader$readInt()
  order <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$readLong()
    order <- c(order, x)
  }
  ReorderStickerSetsRequest$new(order = order, masks = masks, emojis = emojis)
}

#  @title ReportRequest
#  @description Represents a request to report messages. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReportRequest <- R6::R6Class(
  "ReportRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xfc78af9b,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xacd3f438,

    #  @description Initialize the ReportRequest object.
    #  @param peer The input peer.
    #  @param id The list of message IDs.
    #  @param option The option bytes.
    #  @param message The report message.
    initialize = function(peer, id, option, message) {
      self$peer <- peer
      self$id <- id
      self$option <- option
      self$message <- message
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ReportRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        "id" = if (is.null(self$id)) list() else self$id,
        "option" = self$option,
        "message" = self$message
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x9b, 0xaf, 0x78, 0xfc)),
        self$peer$bytes(),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        packBits(intToBits(length(self$id)), type = "integer"),
        unlist(lapply(self$id, function(x) packBits(intToBits(x), type = "integer"))),
        self$serialize_bytes(self$option),
        self$serialize_bytes(self$message)
      )
    }
  )
)

# @title fromReader
# @name ReportRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReportRequest.
ReportRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  reader$readInt()
  id <- list()
  for (i in 1:reader$readInt()) {
    x <- reader$readInt()
    id <- c(id, x)
  }
  option <- reader$tgreadBytes()
  message <- reader$tgreadString()
  ReportRequest$new(peer = peer, id = id, option = option, message = message)
}

#  @title ReportEncryptedSpamRequest
#  @description Represents a request to report encrypted spam. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReportEncryptedSpamRequest <- R6::R6Class(
  "ReportEncryptedSpamRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x4b0c8c0f,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ReportEncryptedSpamRequest object.
    #  @param peer The input encrypted chat peer.
    initialize = function(peer) {
      self$peer <- peer
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ReportEncryptedSpamRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x0f, 0x8c, 0x0c, 0x4b)),
        self$peer$bytes()
      )
    }
  )
)

# @title fromReader
# @name ReportEncryptedSpamRequest_fromReader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReportEncryptedSpamRequest.
ReportEncryptedSpamRequest$fromReader <- function(reader) {
  peer <- reader$tgreadObject()
  ReportEncryptedSpamRequest$new(peer = peer)
}


#  @title ReportMessagesDeliveryRequest
#  @description Represents a request to report messages delivery. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReportMessagesDeliveryRequest <- R6::R6Class(
  "ReportMessagesDeliveryRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x5a6d7395,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ReportMessagesDeliveryRequest object.
    #  @param peer The input peer.
    #  @param id The list of message IDs.
    #  @param push Optional push flag.
    initialize = function(peer, id, push = NULL) {
      self$peer <- peer
      self$id <- id
      self$push <- push
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ReportMessagesDeliveryRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "id" = if (is.null(self$id)) list() else self$id,
        "push" = self$push
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$push) && self$push) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x95, 0x73, 0x6d, 0x5a)),
        packBits(intToBits(flags), type = "integer"),
        self$peer$bytes(),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        packBits(intToBits(length(self$id)), type = "integer"),
        unlist(lapply(self$id, function(x) packBits(intToBits(x), type = "integer")))
      )
    }
  )
)

# @title from_reader
# @name ReportMessagesDeliveryRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReportMessagesDeliveryRequest.
ReportMessagesDeliveryRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  push <- bitwAnd(flags, 1L) != 0
  peer <- reader$tgread_object()
  reader$read_int()
  id <- list()
  for (i in 1:reader$read_int()) {
    x <- reader$read_int()
    id <- c(id, x)
  }
  ReportMessagesDeliveryRequest$new(peer = peer, id = id, push = push)
}

#  @title ReportReactionRequest
#  @description Represents a request to report a reaction. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReportReactionRequest <- R6::R6Class(
  "ReportReactionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x3f64c076,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ReportReactionRequest object.
    #  @param peer The input peer.
    #  @param id The message ID.
    #  @param reaction_peer The reaction peer.
    initialize = function(peer, id, reaction_peer) {
      self$peer <- peer
      self$id <- id
      self$reaction_peer <- reaction_peer
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      self$reaction_peer <- utils$get_input_peer(client$get_input_entity(self$reaction_peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ReportReactionRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "id" = self$id,
        "reaction_peer" = if (inherits(self$reaction_peer, "TLObject")) self$reaction_peer$to_dict() else self$reaction_peer
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x76, 0xc0, 0x64, 0x3f)),
        self$peer$bytes(),
        packBits(intToBits(self$id), type = "integer"),
        self$reaction_peer$bytes()
      )
    }
  )
)

# @title from_reader
# @name ReportReactionRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReportReactionRequest.
ReportReactionRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  id <- reader$read_int()
  reaction_peer <- reader$tgread_object()
  ReportReactionRequest$new(peer = peer, id = id, reaction_peer = reaction_peer)
}

#  @title ReportSpamRequest
#  @description Represents a request to report spam. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReportSpamRequest <- R6::R6Class(
  "ReportSpamRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xcf1592db,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ReportSpamRequest object.
    #  @param peer The input peer.
    initialize = function(peer) {
      self$peer <- peer
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ReportSpamRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xdb, 0x92, 0x15, 0xcf)),
        self$peer$bytes()
      )
    }
  )
)

# @title from_reader
# @name ReportSpamRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReportSpamRequest.
ReportSpamRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  ReportSpamRequest$new(peer = peer)
}

#  @title ReportSponsoredMessageRequest
#  @description Represents a request to report a sponsored message. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ReportSponsoredMessageRequest <- R6::R6Class(
  "ReportSponsoredMessageRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x12cbf0c4,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x26231822,

    #  @description Initialize the ReportSponsoredMessageRequest object.
    #  @param option The option bytes.
    #  @param randomId The random ID (optional, defaults to generated value).
    initialize = function(option, randomId = NULL) {
      self$option <- option
      self$randomId <- if (is.null(randomId)) {
        # Generate a random 4-byte signed integer
        as.integer(runif(1, min = -2147483648, max = 2147483647))
      } else {
        randomId
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ReportSponsoredMessageRequest",
        "option" = self$option,
        "random_id" = self$randomId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      # Assuming serialize_bytes is a method or function that serializes bytes
      c(
        as.raw(c(0xc4, 0xf0, 0xcb, 0x12)),
        self$serialize_bytes(self$randomId),
        self$serialize_bytes(self$option)
      )
    }
  )
)

# @title from_reader
# @name ReportSponsoredMessageRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ReportSponsoredMessageRequest.
ReportSponsoredMessageRequest$from_reader <- function(reader) {
  randomId <- reader$tgread_bytes()
  option <- reader$tgread_bytes()
  ReportSponsoredMessageRequest$new(option = option, randomId = randomId)
}

#  @title RequestAppWebViewRequest
#  @description Represents a request to request an app web view. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
RequestAppWebViewRequest <- R6::R6Class(
  "RequestAppWebViewRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x53618bce,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x93cea746,

    #  @description Initialize the RequestAppWebViewRequest object.
    #  @param peer The input peer.
    #  @param app The input bot app.
    #  @param platform The platform string.
    #  @param writeAllowed Optional write allowed flag.
    #  @param compact Optional compact flag.
    #  @param fullscreen Optional fullscreen flag.
    #  @param startParam Optional start parameter.
    #  @param themeParams Optional theme parameters.
    initialize = function(peer, app, platform, writeAllowed = NULL, compact = NULL, fullscreen = NULL, startParam = NULL, themeParams = NULL) {
      self$peer <- peer
      self$app <- app
      self$platform <- platform
      self$writeAllowed <- writeAllowed
      self$compact <- compact
      self$fullscreen <- fullscreen
      self$startParam <- startParam
      self$themeParams <- themeParams
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "RequestAppWebViewRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "app" = if (inherits(self$app, "TLObject")) self$app$to_dict() else self$app,
        "platform" = self$platform,
        "write_allowed" = self$writeAllowed,
        "compact" = self$compact,
        "fullscreen" = self$fullscreen,
        "start_param" = self$startParam,
        "theme_params" = if (inherits(self$themeParams, "TLObject")) self$themeParams$to_dict() else self$themeParams
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$writeAllowed) && self$writeAllowed) flags <- bitwOr(flags, 1L)
      if (!is.null(self$compact) && self$compact) flags <- bitwOr(flags, 128L)
      if (!is.null(self$fullscreen) && self$fullscreen) flags <- bitwOr(flags, 256L)
      if (!is.null(self$startParam)) flags <- bitwOr(flags, 2L)
      if (!is.null(self$themeParams)) flags <- bitwOr(flags, 4L)
      c(
        as.raw(c(0xce, 0x8b, 0xa1, 0x53)), # Note: Adjusted for little-endian if needed, but keeping as is
        packBits(intToBits(flags), type = "raw")[1:4], # Assuming packBits for flags
        self$peer$bytes(),
        self$app$bytes(),
        if (!is.null(self$startParam)) self$serialize_bytes(self$startParam) else raw(0),
        if (!is.null(self$themeParams)) self$themeParams$bytes() else raw(0),
        self$serialize_bytes(self$platform)
      )
    }
  )
)

# @title from_reader
# @name RequestAppWebViewRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of RequestAppWebViewRequest.
RequestAppWebViewRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  writeAllowed <- bitwAnd(flags, 1L) != 0
  compact <- bitwAnd(flags, 128L) != 0
  fullscreen <- bitwAnd(flags, 256L) != 0
  peer <- reader$tgread_object()
  app <- reader$tgread_object()
  startParam <- if (bitwAnd(flags, 2L) != 0) reader$tgread_string() else NULL
  themeParams <- if (bitwAnd(flags, 4L) != 0) reader$tgread_object() else NULL
  platform <- reader$tgread_string()
  RequestAppWebViewRequest$new(peer = peer, app = app, platform = platform, writeAllowed = writeAllowed, compact = compact, fullscreen = fullscreen, startParam = startParam, themeParams = themeParams)
}

#  @title RequestEncryptionRequest
#  @description Represents a request to request encryption. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
RequestEncryptionRequest <- R6::R6Class(
  "RequestEncryptionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xf64daf43,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x6d28a37a,

    #  @description Initialize the RequestEncryptionRequest object.
    #  @param userId The input user.
    #  @param gA The g_a bytes.
    #  @param randomId The random ID (optional, defaults to generated value).
    initialize = function(userId, gA, randomId = NULL) {
      self$userId <- userId
      self$gA <- gA
      self$randomId <- if (is.null(randomId)) {
        # Generate a random 4-byte signed integer
        as.integer(runif(1, min = -2147483648, max = 2147483647))
      } else {
        randomId
      }
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$userId <- utils$get_input_user(client$get_input_entity(self$userId))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "RequestEncryptionRequest",
        "user_id" = if (inherits(self$userId, "TLObject")) self$userId$to_dict() else self$userId,
        "g_a" = self$gA,
        "random_id" = self$randomId
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x43, 0xaf, 0x4d, 0xf6)),
        self$userId$bytes(),
        packBits(intToBits(self$randomId), type = "raw")[1:4],
        self$serialize_bytes(self$gA)
      )
    }
  )
)

# @title from_reader
# @name RequestEncryptionRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of RequestEncryptionRequest.
RequestEncryptionRequest$from_reader <- function(reader) {
  userId <- reader$tgread_object()
  randomId <- reader$read_int()
  gA <- reader$tgread_bytes()
  RequestEncryptionRequest$new(userId = userId, gA = gA, randomId = randomId)
}


#  @title RequestMainWebViewRequest
#  @description Represents a request to request the main web view for a bot. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
RequestMainWebViewRequest <- R6::R6Class(
  "RequestMainWebViewRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xc9e01e7b,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x93cea746,

    #  @description Initialize the RequestMainWebViewRequest object.
    #  @param peer The input peer.
    #  @param bot The input user (bot).
    #  @param platform The platform string.
    #  @param compact Optional compact flag.
    #  @param fullscreen Optional fullscreen flag.
    #  @param start_param Optional start parameter.
    #  @param theme_params Optional theme parameters.
    initialize = function(peer, bot, platform, compact = NULL, fullscreen = NULL, start_param = NULL, theme_params = NULL) {
      self$peer <- peer
      self$bot <- bot
      self$platform <- platform
      self$compact <- compact
      self$fullscreen <- fullscreen
      self$start_param <- start_param
      self$theme_params <- theme_params
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      self$bot <- utils$get_input_user(client$get_input_entity(self$bot))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "RequestMainWebViewRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "bot" = if (inherits(self$bot, "TLObject")) self$bot$to_dict() else self$bot,
        "platform" = self$platform,
        "compact" = self$compact,
        "fullscreen" = self$fullscreen,
        "start_param" = self$start_param,
        "theme_params" = if (inherits(self$theme_params, "TLObject")) self$theme_params$to_dict() else self$theme_params
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$compact) && self$compact) flags <- bitwOr(flags, 128L)
      if (!is.null(self$fullscreen) && self$fullscreen) flags <- bitwOr(flags, 256L)
      if (!is.null(self$start_param)) flags <- bitwOr(flags, 2L)
      if (!is.null(self$theme_params)) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0xc9, 0xe0, 0x1e, 0x7b)),
        packBits(intToBits(flags), type = "raw")[1:4],
        self$peer$bytes(),
        self$bot$bytes(),
        if (!is.null(self$start_param)) self$serialize_bytes(self$start_param) else raw(0),
        if (!is.null(self$theme_params)) self$theme_params$bytes() else raw(0),
        self$serialize_bytes(self$platform)
      )
    }
  )
)

# @title from_reader
# @name RequestMainWebViewRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of RequestMainWebViewRequest.
RequestMainWebViewRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  compact <- bitwAnd(flags, 128L) != 0
  fullscreen <- bitwAnd(flags, 256L) != 0
  peer <- reader$tgread_object()
  bot <- reader$tgread_object()
  start_param <- if (bitwAnd(flags, 2L) != 0) reader$tgread_string() else NULL
  theme_params <- if (bitwAnd(flags, 1L) != 0) reader$tgread_object() else NULL
  platform <- reader$tgread_string()
  RequestMainWebViewRequest$new(peer = peer, bot = bot, platform = platform, compact = compact, fullscreen = fullscreen, start_param = start_param, theme_params = theme_params)
}

#  @title RequestSimpleWebViewRequest
#  @description Represents a request to request a simple web view for a bot. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
RequestSimpleWebViewRequest <- R6::R6Class(
  "RequestSimpleWebViewRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x413a3e73,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x93cea746,

    #  @description Initialize the RequestSimpleWebViewRequest object.
    #  @param bot The input user (bot).
    #  @param platform The platform string.
    #  @param from_switch_webview Optional from switch webview flag.
    #  @param from_side_menu Optional from side menu flag.
    #  @param compact Optional compact flag.
    #  @param fullscreen Optional fullscreen flag.
    #  @param url Optional URL.
    #  @param start_param Optional start parameter.
    #  @param theme_params Optional theme parameters.
    initialize = function(bot, platform, from_switch_webview = NULL, from_side_menu = NULL, compact = NULL, fullscreen = NULL, url = NULL, start_param = NULL, theme_params = NULL) {
      self$bot <- bot
      self$platform <- platform
      self$from_switch_webview <- from_switch_webview
      self$from_side_menu <- from_side_menu
      self$compact <- compact
      self$fullscreen <- fullscreen
      self$url <- url
      self$start_param <- start_param
      self$theme_params <- theme_params
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$bot <- utils$get_input_user(client$get_input_entity(self$bot))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "RequestSimpleWebViewRequest",
        "bot" = if (inherits(self$bot, "TLObject")) self$bot$to_dict() else self$bot,
        "platform" = self$platform,
        "from_switch_webview" = self$from_switch_webview,
        "from_side_menu" = self$from_side_menu,
        "compact" = self$compact,
        "fullscreen" = self$fullscreen,
        "url" = self$url,
        "start_param" = self$start_param,
        "theme_params" = if (inherits(self$theme_params, "TLObject")) self$theme_params$to_dict() else self$theme_params
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$from_switch_webview) && self$from_switch_webview) flags <- bitwOr(flags, 2L)
      if (!is.null(self$from_side_menu) && self$from_side_menu) flags <- bitwOr(flags, 4L)
      if (!is.null(self$compact) && self$compact) flags <- bitwOr(flags, 128L)
      if (!is.null(self$fullscreen) && self$fullscreen) flags <- bitwOr(flags, 256L)
      if (!is.null(self$url)) flags <- bitwOr(flags, 8L)
      if (!is.null(self$start_param)) flags <- bitwOr(flags, 16L)
      if (!is.null(self$theme_params)) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x41, 0x3a, 0x3e, 0x73)),
        packBits(intToBits(flags), type = "raw")[1:4],
        self$bot$bytes(),
        if (!is.null(self$url)) self$serialize_bytes(self$url) else raw(0),
        if (!is.null(self$start_param)) self$serialize_bytes(self$start_param) else raw(0),
        if (!is.null(self$theme_params)) self$theme_params$bytes() else raw(0),
        self$serialize_bytes(self$platform)
      )
    }
  )
)

# @title from_reader
# @name RequestSimpleWebViewRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of RequestSimpleWebViewRequest.
RequestSimpleWebViewRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  from_switch_webview <- bitwAnd(flags, 2L) != 0
  from_side_menu <- bitwAnd(flags, 4L) != 0
  compact <- bitwAnd(flags, 128L) != 0
  fullscreen <- bitwAnd(flags, 256L) != 0
  bot <- reader$tgread_object()
  url <- if (bitwAnd(flags, 8L) != 0) reader$tgread_string() else NULL
  start_param <- if (bitwAnd(flags, 16L) != 0) reader$tgread_string() else NULL
  theme_params <- if (bitwAnd(flags, 1L) != 0) reader$tgread_object() else NULL
  platform <- reader$tgread_string()
  RequestSimpleWebViewRequest$new(bot = bot, platform = platform, from_switch_webview = from_switch_webview, from_side_menu = from_side_menu, compact = compact, fullscreen = fullscreen, url = url, start_param = start_param, theme_params = theme_params)
}

#  @title RequestUrlAuthRequest
#  @description Represents a request to request URL auth. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
RequestUrlAuthRequest <- R6::R6Class(
  "RequestUrlAuthRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x198fb446,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x7765cb1e,

    #  @description Initialize the RequestUrlAuthRequest object.
    #  @param peer Optional input peer.
    #  @param msg_id Optional message ID.
    #  @param button_id Optional button ID.
    #  @param url Optional URL.
    initialize = function(peer = NULL, msg_id = NULL, button_id = NULL, url = NULL) {
      self$peer <- peer
      self$msg_id <- msg_id
      self$button_id <- button_id
      self$url <- url
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      if (!is.null(self$peer)) {
        self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "RequestUrlAuthRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "msg_id" = self$msg_id,
        "button_id" = self$button_id,
        "url" = self$url
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      stopifnot(
        ((!is.null(self$peer)) && (!is.null(self$msg_id)) && (!is.null(self$button_id))) ||
          (is.null(self$peer) && is.null(self$msg_id) && is.null(self$button_id)),
        "peer, msg_id, button_id parameters must all be present or all NULL"
      )
      flags <- 0L
      if (!is.null(self$peer) || !is.null(self$msg_id) || !is.null(self$button_id)) flags <- bitwOr(flags, 2L)
      if (!is.null(self$url)) flags <- bitwOr(flags, 4L)
      c(
        as.raw(c(0x46, 0xb4, 0x8f, 0x19)),
        struct.pack("<I", flags),
        if (!is.null(self$peer)) self$peer$bytes() else raw(0),
        if (!is.null(self$msg_id)) struct.pack("<i", self$msg_id) else raw(0),
        if (!is.null(self$button_id)) struct.pack("<i", self$button_id) else raw(0),
        if (!is.null(self$url)) self$serialize_bytes(self$url) else raw(0)
      )
    }
  )
)

# @title from_reader
# @name RequestUrlAuthRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of RequestUrlAuthRequest.
RequestUrlAuthRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  if (bitwAnd(flags, 2L) != 0) {
    peer <- reader$tgread_object()
    msg_id <- reader$read_int()
    button_id <- reader$read_int()
  } else {
    peer <- NULL
    msg_id <- NULL
    button_id <- NULL
  }
  if (bitwAnd(flags, 4L) != 0) {
    url <- reader$tgread_string()
  } else {
    url <- NULL
  }
  RequestUrlAuthRequest$new(peer = peer, msg_id = msg_id, button_id = button_id, url = url)
}

#  @title RequestWebViewRequest
#  @description Represents a request to request a web view. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
RequestWebViewRequest <- R6::R6Class(
  "RequestWebViewRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x269dc2c1,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x93cea746,

    #  @description Initialize the RequestWebViewRequest object.
    #  @param peer The input peer.
    #  @param bot The input user (bot).
    #  @param platform The platform string.
    #  @param from_bot_menu Optional from bot menu flag.
    #  @param silent Optional silent flag.
    #  @param compact Optional compact flag.
    #  @param fullscreen Optional fullscreen flag.
    #  @param url Optional URL.
    #  @param start_param Optional start parameter.
    #  @param theme_params Optional theme parameters.
    #  @param reply_to Optional input reply to.
    #  @param send_as Optional input peer to send as.
    initialize = function(peer, bot, platform, from_bot_menu = NULL, silent = NULL, compact = NULL, fullscreen = NULL, url = NULL, start_param = NULL, theme_params = NULL, reply_to = NULL, send_as = NULL) {
      self$peer <- peer
      self$bot <- bot
      self$platform <- platform
      self$from_bot_menu <- from_bot_menu
      self$silent <- silent
      self$compact <- compact
      self$fullscreen <- fullscreen
      self$url <- url
      self$start_param <- start_param
      self$theme_params <- theme_params
      self$reply_to <- reply_to
      self$send_as <- send_as
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      self$bot <- utils$get_input_user(client$get_input_entity(self$bot))
      if (!is.null(self$send_as)) {
        self$send_as <- utils$get_input_peer(client$get_input_entity(self$send_as))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "RequestWebViewRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "bot" = if (inherits(self$bot, "TLObject")) self$bot$to_dict() else self$bot,
        "platform" = self$platform,
        "from_bot_menu" = self$from_bot_menu,
        "silent" = self$silent,
        "compact" = self$compact,
        "fullscreen" = self$fullscreen,
        "url" = self$url,
        "start_param" = self$start_param,
        "theme_params" = if (inherits(self$theme_params, "TLObject")) self$theme_params$to_dict() else self$theme_params,
        "reply_to" = if (inherits(self$reply_to, "TLObject")) self$reply_to$to_dict() else self$reply_to,
        "send_as" = if (inherits(self$send_as, "TLObject")) self$send_as$to_dict() else self$send_as
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$from_bot_menu) && self$from_bot_menu) flags <- bitwOr(flags, 16L)
      if (!is.null(self$silent) && self$silent) flags <- bitwOr(flags, 32L)
      if (!is.null(self$compact) && self$compact) flags <- bitwOr(flags, 128L)
      if (!is.null(self$fullscreen) && self$fullscreen) flags <- bitwOr(flags, 256L)
      if (!is.null(self$url)) flags <- bitwOr(flags, 2L)
      if (!is.null(self$start_param)) flags <- bitwOr(flags, 8L)
      if (!is.null(self$theme_params)) flags <- bitwOr(flags, 4L)
      if (!is.null(self$reply_to)) flags <- bitwOr(flags, 1L)
      if (!is.null(self$send_as)) flags <- bitwOr(flags, 8192L)
      c(
        as.raw(c(0xc1, 0xc2, 0x9d, 0x26)),
        struct.pack("<I", flags),
        self$peer$bytes(),
        self$bot$bytes(),
        if (!is.null(self$url)) self$serialize_bytes(self$url) else raw(0),
        if (!is.null(self$start_param)) self$serialize_bytes(self$start_param) else raw(0),
        if (!is.null(self$theme_params)) self$theme_params$bytes() else raw(0),
        self$serialize_bytes(self$platform),
        if (!is.null(self$reply_to)) self$reply_to$bytes() else raw(0),
        if (!is.null(self$send_as)) self$send_as$bytes() else raw(0)
      )
    }
  )
)

# @title from_reader
# @name RequestWebViewRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of RequestWebViewRequest.
RequestWebViewRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  from_bot_menu <- bitwAnd(flags, 16L) != 0
  silent <- bitwAnd(flags, 32L) != 0
  compact <- bitwAnd(flags, 128L) != 0
  fullscreen <- bitwAnd(flags, 256L) != 0
  peer <- reader$tgread_object()
  bot <- reader$tgread_object()
  if (bitwAnd(flags, 2L) != 0) {
    url <- reader$tgread_string()
  } else {
    url <- NULL
  }
  if (bitwAnd(flags, 8L) != 0) {
    start_param <- reader$tgread_string()
  } else {
    start_param <- NULL
  }
  if (bitwAnd(flags, 4L) != 0) {
    theme_params <- reader$tgread_object()
  } else {
    theme_params <- NULL
  }
  platform <- reader$tgread_string()
  if (bitwAnd(flags, 1L) != 0) {
    reply_to <- reader$tgread_object()
  } else {
    reply_to <- NULL
  }
  if (bitwAnd(flags, 8192L) != 0) {
    send_as <- reader$tgread_object()
  } else {
    send_as <- NULL
  }
  RequestWebViewRequest$new(peer = peer, bot = bot, platform = platform, from_bot_menu = from_bot_menu, silent = silent, compact = compact, fullscreen = fullscreen, url = url, start_param = start_param, theme_params = theme_params, reply_to = reply_to, send_as = send_as)
}

#  @title SaveDefaultSendAsRequest
#  @description Represents a request to save the default send-as peer for a chat. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SaveDefaultSendAsRequest <- R6::R6Class(
  "SaveDefaultSendAsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xccfddf96,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the SaveDefaultSendAsRequest object.
    #  @param peer The input peer.
    #  @param send_as The send-as input peer.
    initialize = function(peer, send_as) {
      self$peer <- peer
      self$send_as <- send_as
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      self$send_as <- utils$get_input_peer(client$get_input_entity(self$send_as))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SaveDefaultSendAsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "send_as" = if (inherits(self$send_as, "TLObject")) self$send_as$to_dict() else self$send_as
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x96, 0xdf, 0xfd, 0xcc)),
        self$peer$bytes(),
        self$send_as$bytes()
      )
    }
  )
)

# @title from_reader
# @name SaveDefaultSendAsRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SaveDefaultSendAsRequest.
SaveDefaultSendAsRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  send_as <- reader$tgread_object()
  SaveDefaultSendAsRequest$new(peer = peer, send_as = send_as)
}

#  @title SaveDraftRequest
#  @description Represents a request to save a draft message. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SaveDraftRequest <- R6::R6Class(
  "SaveDraftRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x54ae308e,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the SaveDraftRequest object.
    #  @param peer The input peer.
    #  @param message The message string.
    #  @param no_webpage Optional no webpage flag.
    #  @param invert_media Optional invert media flag.
    #  @param reply_to Optional input reply to.
    #  @param entities Optional list of message entities.
    #  @param media Optional input media.
    #  @param effect Optional effect ID.
    #  @param suggested_post Optional suggested post.
    initialize = function(peer, message, no_webpage = NULL, invert_media = NULL, reply_to = NULL, entities = NULL, media = NULL, effect = NULL, suggested_post = NULL) {
      self$peer <- peer
      self$message <- message
      self$no_webpage <- no_webpage
      self$invert_media <- invert_media
      self$reply_to <- reply_to
      self$entities <- entities
      self$media <- media
      self$effect <- effect
      self$suggested_post <- suggested_post
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      if (!is.null(self$media)) {
        self$media <- utils$get_input_media(self$media)
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SaveDraftRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "message" = self$message,
        "no_webpage" = self$no_webpage,
        "invert_media" = self$invert_media,
        "reply_to" = if (inherits(self$reply_to, "TLObject")) self$reply_to$to_dict() else self$reply_to,
        "entities" = if (is.null(self$entities)) list() else lapply(self$entities, function(x) if (inherits(x, "TLObject")) x$to_dict() else x),
        "media" = if (inherits(self$media, "TLObject")) self$media$to_dict() else self$media,
        "effect" = self$effect,
        "suggested_post" = if (inherits(self$suggested_post, "TLObject")) self$suggested_post$to_dict() else self$suggested_post
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$no_webpage) && self$no_webpage) flags <- bitwOr(flags, 2L)
      if (!is.null(self$invert_media) && self$invert_media) flags <- bitwOr(flags, 64L)
      if (!is.null(self$reply_to)) flags <- bitwOr(flags, 16L)
      if (!is.null(self$entities)) flags <- bitwOr(flags, 8L)
      if (!is.null(self$media)) flags <- bitwOr(flags, 32L)
      if (!is.null(self$effect)) flags <- bitwOr(flags, 128L)
      if (!is.null(self$suggested_post)) flags <- bitwOr(flags, 256L)
      c(
        as.raw(c(0x8e, 0x30, 0xae, 0x54)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        if (!is.null(self$reply_to)) self$reply_to$bytes() else raw(0),
        self$peer$bytes(),
        self$serialize_bytes(self$message),
        if (!is.null(self$entities)) c(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), writeBin(as.integer(length(self$entities)), raw(), size = 4, endian = "little"), do.call(c, lapply(self$entities, function(x) x$bytes()))) else raw(0),
        if (!is.null(self$media)) self$media$bytes() else raw(0),
        if (!is.null(self$effect)) writeBin(as.integer(self$effect), raw(), size = 4, endian = "little") else raw(0),
        if (!is.null(self$suggested_post)) self$suggested_post$bytes() else raw(0)
      )
    }
  )
)

# @title from_reader
# @name SaveDraftRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SaveDraftRequest.
SaveDraftRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  no_webpage <- bitwAnd(flags, 2L) != 0
  invert_media <- bitwAnd(flags, 64L) != 0
  reply_to <- if (bitwAnd(flags, 16L) != 0) reader$tgread_object() else NULL
  peer <- reader$tgread_object()
  message <- reader$tgread_string()
  entities <- if (bitwAnd(flags, 8L) != 0) {
    reader$read_int() # skip vector ID
    lapply(1:reader$read_int(), function(i) reader$tgread_object())
  } else {
    NULL
  }
  media <- if (bitwAnd(flags, 32L) != 0) reader$tgread_object() else NULL
  effect <- if (bitwAnd(flags, 128L) != 0) reader$read_long() else NULL
  suggested_post <- if (bitwAnd(flags, 256L) != 0) reader$tgread_object() else NULL
  SaveDraftRequest$new(peer = peer, message = message, no_webpage = no_webpage, invert_media = invert_media, reply_to = reply_to, entities = entities, media = media, effect = effect, suggested_post = suggested_post)
}


#  @title SaveGifRequest
#  @description Represents a request to save or unsave a GIF. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SaveGifRequest <- R6::R6Class(
  "SaveGifRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x327a30cb,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the SaveGifRequest object.
    #  @param id The input document.
    #  @param unsave The unsave flag.
    initialize = function(id, unsave) {
      self$id <- id
      self$unsave <- unsave
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$id <- utils$get_input_document(self$id)
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SaveGifRequest",
        "id" = if (inherits(self$id, "TLObject")) self$id$to_dict() else self$id,
        "unsave" = self$unsave
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xcb, 0x30, 0x7a, 0x32)),
        self$id$bytes(),
        if (self$unsave) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  )
)

# @title from_reader
# @name SaveGifRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SaveGifRequest.
SaveGifRequest$from_reader <- function(reader) {
  id <- reader$tgread_object()
  unsave <- reader$tgread_bool()
  SaveGifRequest$new(id = id, unsave = unsave)
}

#  @title SavePreparedInlineMessageRequest
#  @description Represents a request to save a prepared inline message. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SavePreparedInlineMessageRequest <- R6::R6Class(
  "SavePreparedInlineMessageRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xf21f7f2f,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xef9119bb,

    #  @description Initialize the SavePreparedInlineMessageRequest object.
    #  @param result The input bot inline result.
    #  @param user_id The input user.
    #  @param peer_types Optional list of inline query peer types.
    initialize = function(result, user_id, peer_types = NULL) {
      self$result <- result
      self$user_id <- user_id
      self$peer_types <- peer_types
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$user_id <- utils$get_input_user(client$get_input_entity(self$user_id))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SavePreparedInlineMessageRequest",
        "result" = if (inherits(self$result, "TLObject")) self$result$to_dict() else self$result,
        "user_id" = if (inherits(self$user_id, "TLObject")) self$user_id$to_dict() else self$user_id,
        "peer_types" = if (is.null(self$peer_types)) list() else lapply(self$peer_types, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$peer_types)) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x2f, 0x7f, 0x1f, 0xf2)),
        writeBin(flags, raw(), size = 4, endian = "little"),
        self$result$bytes(),
        self$user_id$bytes(),
        if (is.null(self$peer_types)) {
          raw()
        } else {
          c(
            as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
            writeBin(length(self$peer_types), raw(), size = 4, endian = "little"),
            unlist(lapply(self$peer_types, function(x) x$bytes()))
          )
        }
      )
    }
  )
)

# @title from_reader
# @name SavePreparedInlineMessageRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SavePreparedInlineMessageRequest.
SavePreparedInlineMessageRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  result <- reader$tgread_object()
  user_id <- reader$tgread_object()
  if (bitwAnd(flags, 1L) != 0) {
    reader$read_int() # skip vector ID
    peer_types <- list()
    for (i in 1:reader$read_int()) {
      peer_types[[i]] <- reader$tgread_object()
    }
  } else {
    peer_types <- NULL
  }
  SavePreparedInlineMessageRequest$new(result = result, user_id = user_id, peer_types = peer_types)
}

#  @title SaveRecentStickerRequest
#  @description Represents a request to save or unsave a recent sticker. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SaveRecentStickerRequest <- R6::R6Class(
  "SaveRecentStickerRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x392718f8,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the SaveRecentStickerRequest object.
    #  @param id The input document.
    #  @param unsave The unsave flag.
    #  @param attached Optional attached flag.
    initialize = function(id, unsave, attached = NULL) {
      self$id <- id
      self$unsave <- unsave
      self$attached <- attached
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$id <- utils$get_input_document(self$id)
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SaveRecentStickerRequest",
        "id" = if (inherits(self$id, "TLObject")) self$id$to_dict() else self$id,
        "unsave" = self$unsave,
        "attached" = self$attached
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$attached) && self$attached) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0xf8, 0x18, 0x27, 0x39)),
        writeBin(flags, raw(), size = 4, endian = "little"),
        self$id$bytes(),
        if (self$unsave) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  )
)

# @title from_reader
# @name SaveRecentStickerRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SaveRecentStickerRequest.
SaveRecentStickerRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  attached <- bitwAnd(flags, 1L) != 0
  id <- reader$tgread_object()
  unsave <- reader$tgread_bool()
  SaveRecentStickerRequest$new(id = id, unsave = unsave, attached = attached)
}


#  @title SearchRequest
#  @description Represents a request to search messages. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SearchRequest <- R6::R6Class(
  "SearchRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x29ee847a,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd4b40b5e,

    #  @description Initialize the SearchRequest object.
    #  @param peer The input peer.
    #  @param q The search query string.
    #  @param filter The messages filter.
    #  @param min_date Optional minimum date.
    #  @param max_date Optional maximum date.
    #  @param offset_id The offset ID.
    #  @param add_offset The additional offset.
    #  @param limit The limit for results.
    #  @param max_id The maximum ID.
    #  @param min_id The minimum ID.
    #  @param hash The hash for caching.
    #  @param from_id Optional input peer for from ID.
    #  @param saved_peer_id Optional input peer for saved peer ID.
    #  @param saved_reaction Optional list of reactions.
    #  @param top_msg_id Optional top message ID.
    initialize = function(peer, q, filter, min_date = NULL, max_date = NULL, offset_id, add_offset, limit, max_id, min_id, hash, from_id = NULL, saved_peer_id = NULL, saved_reaction = NULL, top_msg_id = NULL) {
      self$peer <- peer
      self$q <- q
      self$filter <- filter
      self$min_date <- min_date
      self$max_date <- max_date
      self$offset_id <- offset_id
      self$add_offset <- add_offset
      self$limit <- limit
      self$max_id <- max_id
      self$min_id <- min_id
      self$hash <- hash
      self$from_id <- from_id
      self$saved_peer_id <- saved_peer_id
      self$saved_reaction <- saved_reaction
      self$top_msg_id <- top_msg_id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      if (!is.null(self$from_id)) {
        self$from_id <- utils$get_input_peer(client$get_input_entity(self$from_id))
      }
      if (!is.null(self$saved_peer_id)) {
        self$saved_peer_id <- utils$get_input_peer(client$get_input_entity(self$saved_peer_id))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SearchRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "q" = self$q,
        "filter" = if (inherits(self$filter, "TLObject")) self$filter$to_dict() else self$filter,
        "min_date" = self$min_date,
        "max_date" = self$max_date,
        "offset_id" = self$offset_id,
        "add_offset" = self$add_offset,
        "limit" = self$limit,
        "max_id" = self$max_id,
        "min_id" = self$min_id,
        "hash" = self$hash,
        "from_id" = if (inherits(self$from_id, "TLObject")) self$from_id$to_dict() else self$from_id,
        "saved_peer_id" = if (inherits(self$saved_peer_id, "TLObject")) self$saved_peer_id$to_dict() else self$saved_peer_id,
        "saved_reaction" = if (is.null(self$saved_reaction)) list() else lapply(self$saved_reaction, function(x) if (inherits(x, "TLObject")) x$to_dict() else x),
        "top_msg_id" = self$top_msg_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$from_id)) flags <- bitwOr(flags, 1L)
      if (!is.null(self$saved_peer_id)) flags <- bitwOr(flags, 4L)
      if (!is.null(self$saved_reaction)) flags <- bitwOr(flags, 8L)
      if (!is.null(self$top_msg_id)) flags <- bitwOr(flags, 2L)
      c(
        as.raw(c(0x7a, 0x84, 0xee, 0x29)),
        writeBin(flags, raw(), size = 4, endian = "little"),
        self$peer$bytes(),
        self$serialize_bytes(self$q),
        if (!is.null(self$from_id)) self$from_id$bytes() else raw(),
        if (!is.null(self$saved_peer_id)) self$saved_peer_id$bytes() else raw(),
        if (!is.null(self$saved_reaction)) c(as.raw(c(0x1c, 0xb5, 0xc4, 0x15)), writeBin(length(self$saved_reaction), raw(), size = 4, endian = "little"), do.call(c, lapply(self$saved_reaction, function(x) x$bytes()))) else raw(),
        if (!is.null(self$top_msg_id)) writeBin(self$top_msg_id, raw(), size = 4, endian = "little") else raw(),
        self$filter$bytes(),
        self$serialize_datetime(self$min_date),
        self$serialize_datetime(self$max_date),
        writeBin(self$offset_id, raw(), size = 4, endian = "little"),
        writeBin(self$add_offset, raw(), size = 4, endian = "little"),
        writeBin(self$limit, raw(), size = 4, endian = "little"),
        writeBin(self$max_id, raw(), size = 4, endian = "little"),
        writeBin(self$min_id, raw(), size = 4, endian = "little"),
        writeBin(self$hash, raw(), size = 8, endian = "little")
      )
    }
  ),
  lock_objects = FALSE
)

# @title from_reader
# @name SearchRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SearchRequest.
SearchRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  peer <- reader$tgread_object()
  q <- reader$tgread_string()
  from_id <- if (bitwAnd(flags, 1L) != 0) reader$tgread_object() else NULL
  saved_peer_id <- if (bitwAnd(flags, 4L) != 0) reader$tgread_object() else NULL
  saved_reaction <- if (bitwAnd(flags, 8L) != 0) {
    reader$read_int() # skip vector ID
    lapply(1:reader$read_int(), function(i) reader$tgread_object())
  } else {
    NULL
  }
  top_msg_id <- if (bitwAnd(flags, 2L) != 0) reader$read_int() else NULL
  filter <- reader$tgread_object()
  min_date <- reader$tgread_date()
  max_date <- reader$tgread_date()
  offset_id <- reader$read_int()
  add_offset <- reader$read_int()
  limit <- reader$read_int()
  max_id <- reader$read_int()
  min_id <- reader$read_int()
  hash <- reader$read_long()
  SearchRequest$new(peer = peer, q = q, filter = filter, min_date = min_date, max_date = max_date, offset_id = offset_id, add_offset = add_offset, limit = limit, max_id = max_id, min_id = min_id, hash = hash, from_id = from_id, saved_peer_id = saved_peer_id, saved_reaction = saved_reaction, top_msg_id = top_msg_id)
}

#  @title SearchCustomEmojiRequest
#  @description Represents a request to search custom emoji. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SearchCustomEmojiRequest <- R6::R6Class(
  "SearchCustomEmojiRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x2c11c0d7,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xbcef6aba,

    #  @description Initialize the SearchCustomEmojiRequest object.
    #  @param emoticon The emoticon string.
    #  @param hash The hash for caching.
    initialize = function(emoticon, hash) {
      self$emoticon <- emoticon
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SearchCustomEmojiRequest",
        "emoticon" = self$emoticon,
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xd7, 0xc0, 0x11, 0x2c)),
        self$serialize_bytes(self$emoticon),
        writeBin(self$hash, raw(), size = 8, endian = "little")
      )
    }
  ),
  lock_objects = FALSE
)

# @title from_reader
# @name SearchCustomEmojiRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SearchCustomEmojiRequest.
SearchCustomEmojiRequest$from_reader <- function(reader) {
  emoticon <- reader$tgread_string()
  hash <- reader$read_long()
  SearchCustomEmojiRequest$new(emoticon = emoticon, hash = hash)
}

#  @title SearchEmojiStickerSetsRequest
#  @description Represents a request to search emoji sticker sets. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SearchEmojiStickerSetsRequest <- R6::R6Class(
  "SearchEmojiStickerSetsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x92b4494c,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x40df361,

    #  @description Initialize the SearchEmojiStickerSetsRequest object.
    #  @param q The search query string.
    #  @param hash The hash for caching.
    #  @param exclude_featured Optional exclude featured flag.
    initialize = function(q, hash, exclude_featured = NULL) {
      self$q <- q
      self$hash <- hash
      self$exclude_featured <- exclude_featured
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SearchEmojiStickerSetsRequest",
        "q" = self$q,
        "hash" = self$hash,
        "exclude_featured" = self$exclude_featured
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$exclude_featured) && self$exclude_featured) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x4c, 0x49, 0xb4, 0x92)),
        writeBin(flags, raw(), size = 4, endian = "little"),
        self$serialize_bytes(self$q),
        writeBin(self$hash, raw(), size = 8, endian = "little")
      )
    }
  )
)

# @title from_reader
# @name SearchEmojiStickerSetsRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SearchEmojiStickerSetsRequest.
SearchEmojiStickerSetsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  exclude_featured <- bitwAnd(flags, 1L) != 0
  q <- reader$tgread_string()
  hash <- reader$read_long()
  SearchEmojiStickerSetsRequest$new(q = q, hash = hash, exclude_featured = exclude_featured)
}


#  @title SearchGlobalRequest
#  @description Represents a request to search globally. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SearchGlobalRequest <- R6::R6Class(
  "SearchGlobalRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x4bc6589a,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd4b40b5e,

    #  @description Initialize the SearchGlobalRequest object.
    #  @param q The search query string.
    #  @param filter The messages filter.
    #  @param min_date Optional minimum date.
    #  @param max_date Optional maximum date.
    #  @param offset_rate The offset rate.
    #  @param offset_peer The offset peer.
    #  @param offset_id The offset ID.
    #  @param limit The limit for results.
    #  @param broadcasts_only Optional broadcasts only flag.
    #  @param groups_only Optional groups only flag.
    #  @param users_only Optional users only flag.
    #  @param folder_id Optional folder ID.
    initialize = function(q, filter, min_date = NULL, max_date = NULL, offset_rate, offset_peer, offset_id, limit, broadcasts_only = NULL, groups_only = NULL, users_only = NULL, folder_id = NULL) {
      self$q <- q
      self$filter <- filter
      self$min_date <- min_date
      self$max_date <- max_date
      self$offset_rate <- offset_rate
      self$offset_peer <- offset_peer
      self$offset_id <- offset_id
      self$limit <- limit
      self$broadcasts_only <- broadcasts_only
      self$groups_only <- groups_only
      self$users_only <- users_only
      self$folder_id <- folder_id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$offset_peer <- utils$get_input_peer(client$get_input_entity(self$offset_peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SearchGlobalRequest",
        "q" = self$q,
        "filter" = if (inherits(self$filter, "TLObject")) self$filter$to_dict() else self$filter,
        "min_date" = self$min_date,
        "max_date" = self$max_date,
        "offset_rate" = self$offset_rate,
        "offset_peer" = if (inherits(self$offset_peer, "TLObject")) self$offset_peer$to_dict() else self$offset_peer,
        "offset_id" = self$offset_id,
        "limit" = self$limit,
        "broadcasts_only" = self$broadcasts_only,
        "groups_only" = self$groups_only,
        "users_only" = self$users_only,
        "folder_id" = self$folder_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$broadcasts_only) && self$broadcasts_only) flags <- bitwOr(flags, 2L)
      if (!is.null(self$groups_only) && self$groups_only) flags <- bitwOr(flags, 4L)
      if (!is.null(self$users_only) && self$users_only) flags <- bitwOr(flags, 8L)
      if (!is.null(self$folder_id)) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x9a, 0x58, 0xc6, 0x4b)),
        writeBin(flags, raw(), size = 4, endian = "little"),
        if (!is.null(self$folder_id)) writeBin(self$folder_id, raw(), size = 4, endian = "little") else raw(),
        self$serialize_bytes(self$q),
        self$filter$bytes(),
        self$serialize_datetime(self$min_date),
        self$serialize_datetime(self$max_date),
        writeBin(self$offset_rate, raw(), size = 4, endian = "little"),
        self$offset_peer$bytes(),
        writeBin(self$offset_id, raw(), size = 4, endian = "little"),
        writeBin(self$limit, raw(), size = 4, endian = "little")
      )
    }
  ),
  lock_objects = FALSE
)

# @title from_reader
# @name SearchGlobalRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SearchGlobalRequest.
SearchGlobalRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  broadcasts_only <- bitwAnd(flags, 2L) != 0
  groups_only <- bitwAnd(flags, 4L) != 0
  users_only <- bitwAnd(flags, 8L) != 0
  folder_id <- if (bitwAnd(flags, 1L) != 0) reader$read_int() else NULL
  q <- reader$tgread_string()
  filter <- reader$tgread_object()
  min_date <- reader$tgread_date()
  max_date <- reader$tgread_date()
  offset_rate <- reader$read_int()
  offset_peer <- reader$tgread_object()
  offset_id <- reader$read_int()
  limit <- reader$read_int()
  SearchGlobalRequest$new(q = q, filter = filter, min_date = min_date, max_date = max_date, offset_rate = offset_rate, offset_peer = offset_peer, offset_id = offset_id, limit = limit, broadcasts_only = broadcasts_only, groups_only = groups_only, users_only = users_only, folder_id = folder_id)
}

#  @title SearchSentMediaRequest
#  @description Represents a request to search sent media. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SearchSentMediaRequest <- R6::R6Class(
  "SearchSentMediaRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x107e31a0,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd4b40b5e,

    #  @description Initialize the SearchSentMediaRequest object.
    #  @param q The search query string.
    #  @param filter The messages filter.
    #  @param limit The limit for results.
    initialize = function(q, filter, limit) {
      self$q <- q
      self$filter <- filter
      self$limit <- limit
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SearchSentMediaRequest",
        "q" = self$q,
        "filter" = if (inherits(self$filter, "TLObject")) self$filter$to_dict() else self$filter,
        "limit" = self$limit
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xa0, 0x31, 0x7e, 0x10)),
        self$serialize_bytes(self$q),
        self$filter$bytes(),
        writeBin(self$limit, raw(), size = 4, endian = "little")
      )
    }
  ),
  lock_objects = FALSE
)

# @title from_reader
# @name SearchSentMediaRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SearchSentMediaRequest.
SearchSentMediaRequest$from_reader <- function(reader) {
  q <- reader$tgread_string()
  filter <- reader$tgread_object()
  limit <- reader$read_int()
  SearchSentMediaRequest$new(q = q, filter = filter, limit = limit)
}

#  @title SearchStickerSetsRequest
#  @description Represents a request to search sticker sets. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SearchStickerSetsRequest <- R6::R6Class(
  "SearchStickerSetsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x35705b8a,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x40df361,

    #  @description Initialize the SearchStickerSetsRequest object.
    #  @param q The search query string.
    #  @param hash The hash for caching.
    #  @param exclude_featured Optional exclude featured flag.
    initialize = function(q, hash, exclude_featured = NULL) {
      self$q <- q
      self$hash <- hash
      self$exclude_featured <- exclude_featured
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SearchStickerSetsRequest",
        "q" = self$q,
        "hash" = self$hash,
        "exclude_featured" = self$exclude_featured
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$exclude_featured) && self$exclude_featured) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x8a, 0x5b, 0x70, 0x35)),
        writeBin(flags, raw(), size = 4, endian = "little"),
        self$serialize_bytes(self$q),
        writeBin(self$hash, raw(), size = 8, endian = "little")
      )
    }
  )
)

# @title from_reader
# @name SearchStickerSetsRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SearchStickerSetsRequest.
SearchStickerSetsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  exclude_featured <- bitwAnd(flags, 1L) != 0
  q <- reader$tgread_string()
  hash <- reader$read_long()
  SearchStickerSetsRequest$new(q = q, hash = hash, exclude_featured = exclude_featured)
}

#  @title SearchStickersRequest
#  @description Represents a request to search for stickers. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SearchStickersRequest <- R6::R6Class(
  "SearchStickersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x29b1c66a,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x6402151,

    #  @description Initialize the SearchStickersRequest object.
    #  @param q The search query string.
    #  @param emoticon The emoticon string.
    #  @param lang_code List of language codes.
    #  @param offset The offset for pagination.
    #  @param limit The limit for results.
    #  @param hash The hash for caching.
    #  @param emojis Optional emojis flag.
    initialize = function(q, emoticon, lang_code, offset, limit, hash, emojis = NULL) {
      self$q <- q
      self$emoticon <- emoticon
      self$lang_code <- lang_code
      self$offset <- offset
      self$limit <- limit
      self$hash <- hash
      self$emojis <- emojis
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SearchStickersRequest",
        "q" = self$q,
        "emoticon" = self$emoticon,
        "lang_code" = if (is.null(self$lang_code)) list() else self$lang_code,
        "offset" = self$offset,
        "limit" = self$limit,
        "hash" = self$hash,
        "emojis" = self$emojis
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$emojis) && self$emojis) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x6a, 0xc6, 0xb1, 0x29)),
        writeBin(flags, raw(), size = 4, endian = "little"),
        self$serialize_bytes(self$q),
        self$serialize_bytes(self$emoticon),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)), writeBin(length(self$lang_code), raw(), size = 4, endian = "little"),
        do.call(c, lapply(self$lang_code, self$serialize_bytes)),
        writeBin(self$offset, raw(), size = 4, endian = "little"),
        writeBin(self$limit, raw(), size = 4, endian = "little"),
        writeBin(self$hash, raw(), size = 8, endian = "little")
      )
    }
  )
)

# @title from_reader
# @name SearchStickersRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SearchStickersRequest.
SearchStickersRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  emojis <- bitwAnd(flags, 1L) != 0
  q <- reader$tgread_string()
  emoticon <- reader$tgread_string()
  reader$read_int() # skip vector ID
  lang_code <- list()
  for (i in 1:reader$read_int()) {
    lang_code[[i]] <- reader$tgread_string()
  }
  offset <- reader$read_int()
  limit <- reader$read_int()
  hash <- reader$read_long()
  SearchStickersRequest$new(q = q, emoticon = emoticon, lang_code = lang_code, offset = offset, limit = limit, hash = hash, emojis = emojis)
}

#  @title SendBotRequestedPeerRequest
#  @description Represents a request to send bot requested peers. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SendBotRequestedPeerRequest <- R6::R6Class(
  "SendBotRequestedPeerRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x91b2d060,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the SendBotRequestedPeerRequest object.
    #  @param peer The input peer.
    #  @param msg_id The message ID.
    #  @param button_id The button ID.
    #  @param requested_peers List of requested peers.
    initialize = function(peer, msg_id, button_id, requested_peers) {
      self$peer <- peer
      self$msg_id <- msg_id
      self$button_id <- button_id
      self$requested_peers <- requested_peers
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      tmp <- list()
      for (x in self$requested_peers) {
        tmp <- c(tmp, utils$get_input_peer(client$get_input_entity(x)))
      }
      self$requested_peers <- tmp
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SendBotRequestedPeerRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "msg_id" = self$msg_id,
        "button_id" = self$button_id,
        "requested_peers" = if (is.null(self$requested_peers)) list() else lapply(self$requested_peers, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x60, 0xd0, 0xb2, 0x91)),
        self$peer$bytes(),
        writeBin(self$msg_id, raw(), size = 4, endian = "little"),
        writeBin(self$button_id, raw(), size = 4, endian = "little"),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)), writeBin(length(self$requested_peers), raw(), size = 4, endian = "little"),
        do.call(c, lapply(self$requested_peers, function(x) x$bytes()))
      )
    }
  )
)

# @title from_reader
# @name SendBotRequestedPeerRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SendBotRequestedPeerRequest.
SendBotRequestedPeerRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  msg_id <- reader$read_int()
  button_id <- reader$read_int()
  reader$read_int() # skip vector ID
  requested_peers <- list()
  for (i in 1:reader$read_int()) {
    requested_peers[[i]] <- reader$tgread_object()
  }
  SendBotRequestedPeerRequest$new(peer = peer, msg_id = msg_id, button_id = button_id, requested_peers = requested_peers)
}


#  @title SendEncryptedRequest
#  @description Represents a request to send an encrypted message. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SendEncryptedRequest <- R6::R6Class(
  "SendEncryptedRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x44fa7a15,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xc99e3e50,

    #  @description Initialize the SendEncryptedRequest object.
    #  @param peer The input encrypted chat peer.
    #  @param data The data bytes.
    #  @param silent Optional silent flag.
    #  @param random_id Optional random ID, defaults to a generated 64-bit signed integer.
    initialize = function(peer, data, silent = NULL, random_id = NULL) {
      self$peer <- peer
      self$data <- data
      self$silent <- silent
      self$random_id <- if (is.null(random_id)) as.integer(runif(1, min = -2^63, max = 2^63 - 1)) else random_id
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SendEncryptedRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "data" = self$data,
        "silent" = self$silent,
        "random_id" = self$random_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$silent) && self$silent) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x15, 0x7a, 0xfa, 0x44)),
        writeBin(flags, raw(), size = 4, endian = "little"),
        self$peer$bytes(),
        writeBin(as.integer(self$random_id), raw(), size = 8, endian = "little"),
        self$serialize_bytes(self$data)
      )
    }
  )
)

# @title from_reader
# @name SendEncryptedRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SendEncryptedRequest.
SendEncryptedRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  silent <- bitwAnd(flags, 1L) != 0
  peer <- reader$tgread_object()
  random_id <- reader$read_long()
  data <- reader$tgread_bytes()
  SendEncryptedRequest$new(peer = peer, data = data, silent = silent, random_id = random_id)
}

#  @title SendEncryptedFileRequest
#  @description Represents a request to send an encrypted file. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SendEncryptedFileRequest <- R6::R6Class(
  "SendEncryptedFileRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x5559481d,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xc99e3e50,

    #  @description Initialize the SendEncryptedFileRequest object.
    #  @param peer The input encrypted chat peer.
    #  @param data The data bytes.
    #  @param file The input encrypted file.
    #  @param silent Optional silent flag.
    #  @param random_id Optional random ID, defaults to a generated 64-bit signed integer.
    initialize = function(peer, data, file, silent = NULL, random_id = NULL) {
      self$peer <- peer
      self$data <- data
      self$file <- file
      self$silent <- silent
      self$random_id <- if (is.null(random_id)) as.integer(runif(1, min = -2^63, max = 2^63 - 1)) else random_id
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SendEncryptedFileRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "data" = self$data,
        "file" = if (inherits(self$file, "TLObject")) self$file$to_dict() else self$file,
        "silent" = self$silent,
        "random_id" = self$random_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$silent) && self$silent) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x1d, 0x48, 0x59, 0x55)),
        writeBin(flags, raw(), size = 4, endian = "little"),
        self$peer$bytes(),
        writeBin(as.integer(self$random_id), raw(), size = 8, endian = "little"),
        self$serialize_bytes(self$data),
        self$file$bytes()
      )
    }
  )
)

# @title from_reader
# @name SendEncryptedFileRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SendEncryptedFileRequest.
SendEncryptedFileRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  silent <- bitwAnd(flags, 1L) != 0
  peer <- reader$tgread_object()
  random_id <- reader$read_long()
  data <- reader$tgread_bytes()
  file <- reader$tgread_object()
  SendEncryptedFileRequest$new(peer = peer, data = data, file = file, silent = silent, random_id = random_id)
}


#  @title SendEncryptedServiceRequest
#  @description Represents a request to send an encrypted service message. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SendEncryptedServiceRequest <- R6::R6Class(
  "SendEncryptedServiceRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x32d439a4,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xc99e3e50,

    #  @description Initialize the SendEncryptedServiceRequest object.
    #  @param peer The input encrypted chat peer.
    #  @param data The data bytes.
    #  @param random_id Optional random ID, defaults to a generated 64-bit integer.
    initialize = function(peer, data, random_id = NULL) {
      self$peer <- peer
      self$data <- data
      self$random_id <- if (is.null(random_id)) as.integer(runif(1, min = -2^63, max = 2^63 - 1)) else random_id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      # No resolution needed for this request
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SendEncryptedServiceRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "data" = self$data,
        "random_id" = self$random_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xa4, 0x39, 0xd4, 0x32)),
        self$peer$bytes(),
        writeBin(as.integer(self$random_id), raw(), size = 8, endian = "little"),
        self$serialize_bytes(self$data)
      )
    }
  )
)

# @title from_reader
# @name SendEncryptedServiceRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SendEncryptedServiceRequest.
SendEncryptedServiceRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  random_id <- reader$read_long()
  data <- reader$tgread_bytes()
  SendEncryptedServiceRequest$new(peer = peer, data = data, random_id = random_id)
}

#  @title SendInlineBotResultRequest
#  @description Represents a request to send an inline bot result. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SendInlineBotResultRequest <- R6::R6Class(
  "SendInlineBotResultRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xc0cf7646,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the SendInlineBotResultRequest object.
    #  @param peer The input peer.
    #  @param query_id The query ID.
    #  @param id The result ID string.
    #  @param silent Optional silent flag.
    #  @param background Optional background flag.
    #  @param clear_draft Optional clear draft flag.
    #  @param hide_via Optional hide via flag.
    #  @param reply_to Optional input reply to.
    #  @param random_id Optional random ID, defaults to a generated 64-bit integer.
    #  @param schedule_date Optional schedule date.
    #  @param send_as Optional input peer to send as.
    #  @param quick_reply_shortcut Optional input quick reply shortcut.
    #  @param allow_paid_stars Optional allow paid stars count.
    initialize = function(peer, query_id, id, silent = NULL, background = NULL, clear_draft = NULL, hide_via = NULL, reply_to = NULL, random_id = NULL, schedule_date = NULL, send_as = NULL, quick_reply_shortcut = NULL, allow_paid_stars = NULL) {
      self$peer <- peer
      self$query_id <- query_id
      self$id <- id
      self$silent <- silent
      self$background <- background
      self$clear_draft <- clear_draft
      self$hide_via <- hide_via
      self$reply_to <- reply_to
      self$random_id <- if (is.null(random_id)) as.integer(runif(1, min = -2^63, max = 2^63 - 1)) else random_id
      self$schedule_date <- schedule_date
      self$send_as <- send_as
      self$quick_reply_shortcut <- quick_reply_shortcut
      self$allow_paid_stars <- allow_paid_stars
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      if (!is.null(self$send_as)) {
        self$send_as <- utils$get_input_peer(client$get_input_entity(self$send_as))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SendInlineBotResultRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "query_id" = self$query_id,
        "id" = self$id,
        "silent" = self$silent,
        "background" = self$background,
        "clear_draft" = self$clear_draft,
        "hide_via" = self$hide_via,
        "reply_to" = if (inherits(self$reply_to, "TLObject")) self$reply_to$to_dict() else self$reply_to,
        "random_id" = self$random_id,
        "schedule_date" = self$schedule_date,
        "send_as" = if (inherits(self$send_as, "TLObject")) self$send_as$to_dict() else self$send_as,
        "quick_reply_shortcut" = if (inherits(self$quick_reply_shortcut, "TLObject")) self$quick_reply_shortcut$to_dict() else self$quick_reply_shortcut,
        "allow_paid_stars" = self$allow_paid_stars
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$silent) && self$silent) flags <- bitwOr(flags, 32L)
      if (!is.null(self$background) && self$background) flags <- bitwOr(flags, 64L)
      if (!is.null(self$clear_draft) && self$clear_draft) flags <- bitwOr(flags, 128L)
      if (!is.null(self$hide_via) && self$hide_via) flags <- bitwOr(flags, 2048L)
      if (!is.null(self$reply_to)) flags <- bitwOr(flags, 1L)
      if (!is.null(self$schedule_date)) flags <- bitwOr(flags, 1024L)
      if (!is.null(self$send_as)) flags <- bitwOr(flags, 8192L)
      if (!is.null(self$quick_reply_shortcut)) flags <- bitwOr(flags, 131072L)
      if (!is.null(self$allow_paid_stars)) flags <- bitwOr(flags, 2097152L)
      c(
        as.raw(c(0x46, 0xcf, 0xc0)),
        writeBin(flags, raw(), size = 4, endian = "little"),
        self$peer$bytes(),
        if (!is.null(self$reply_to)) self$reply_to$bytes() else raw(),
        writeBin(as.integer(self$random_id), raw(), size = 8, endian = "little"),
        writeBin(as.integer(self$query_id), raw(), size = 8, endian = "little"),
        self$serialize_bytes(self$id),
        if (!is.null(self$schedule_date)) self$serialize_datetime(self$schedule_date) else raw(),
        if (!is.null(self$send_as)) self$send_as$bytes() else raw(),
        if (!is.null(self$quick_reply_shortcut)) self$quick_reply_shortcut$bytes() else raw(),
        if (!is.null(self$allow_paid_stars)) writeBin(as.integer(self$allow_paid_stars), raw(), size = 8, endian = "little") else raw()
      )
    }
  )
)

# @title from_reader
# @name SendInlineBotResultRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SendInlineBotResultRequest.
SendInlineBotResultRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  silent <- bitwAnd(flags, 32L) != 0
  background <- bitwAnd(flags, 64L) != 0
  clear_draft <- bitwAnd(flags, 128L) != 0
  hide_via <- bitwAnd(flags, 2048L) != 0
  peer <- reader$tgread_object()
  reply_to <- if (bitwAnd(flags, 1L) != 0) reader$tgread_object() else NULL
  random_id <- reader$read_long()
  query_id <- reader$read_long()
  id <- reader$tgread_string()
  schedule_date <- if (bitwAnd(flags, 1024L) != 0) reader$tgread_date() else NULL
  send_as <- if (bitwAnd(flags, 8192L) != 0) reader$tgread_object() else NULL
  quick_reply_shortcut <- if (bitwAnd(flags, 131072L) != 0) reader$tgread_object() else NULL
  allow_paid_stars <- if (bitwAnd(flags, 2097152L) != 0) reader$read_long() else NULL
  SendInlineBotResultRequest$new(peer = peer, query_id = query_id, id = id, silent = silent, background = background, clear_draft = clear_draft, hide_via = hide_via, reply_to = reply_to, random_id = random_id, schedule_date = schedule_date, send_as = send_as, quick_reply_shortcut = quick_reply_shortcut, allow_paid_stars = allow_paid_stars)
}


#  @title SendMediaRequest
#  @description Represents a request to send media. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SendMediaRequest <- R6::R6Class(
  "SendMediaRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xac55d9c1,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the SendMediaRequest object.
    #  @param peer The input peer.
    #  @param media The input media.
    #  @param message The message string.
    #  @param silent Optional silent flag.
    #  @param background Optional background flag.
    #  @param clear_draft Optional clear draft flag.
    #  @param noforwards Optional no forwards flag.
    #  @param update_stickersets_order Optional update stickersets order flag.
    #  @param invert_media Optional invert media flag.
    #  @param allow_paid_floodskip Optional allow paid floodskip flag.
    #  @param reply_to Optional input reply to.
    #  @param random_id Optional random ID, defaults to a generated 64-bit integer.
    #  @param reply_markup Optional reply markup.
    #  @param entities Optional list of message entities.
    #  @param schedule_date Optional schedule date.
    #  @param send_as Optional input peer to send as.
    #  @param quick_reply_shortcut Optional input quick reply shortcut.
    #  @param effect Optional effect ID.
    #  @param allow_paid_stars Optional allow paid stars count.
    #  @param suggested_post Optional suggested post.
    initialize = function(peer, media, message, silent = NULL, background = NULL, clear_draft = NULL, noforwards = NULL, update_stickersets_order = NULL, invert_media = NULL, allow_paid_floodskip = NULL, reply_to = NULL, random_id = NULL, reply_markup = NULL, entities = NULL, schedule_date = NULL, send_as = NULL, quick_reply_shortcut = NULL, effect = NULL, allow_paid_stars = NULL, suggested_post = NULL) {
      self$peer <- peer
      self$media <- media
      self$message <- message
      self$silent <- silent
      self$background <- background
      self$clear_draft <- clear_draft
      self$noforwards <- noforwards
      self$update_stickersets_order <- update_stickersets_order
      self$invert_media <- invert_media
      self$allow_paid_floodskip <- allow_paid_floodskip
      self$reply_to <- reply_to
      self$random_id <- if (is.null(random_id)) as.integer(runif(1, min = 0, max = 2^64 - 1)) else random_id
      self$reply_markup <- reply_markup
      self$entities <- entities
      self$schedule_date <- schedule_date
      self$send_as <- send_as
      self$quick_reply_shortcut <- quick_reply_shortcut
      self$effect <- effect
      self$allow_paid_stars <- allow_paid_stars
      self$suggested_post <- suggested_post
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      self$media <- utils$get_input_media(self$media)
      if (!is.null(self$send_as)) {
        self$send_as <- utils$get_input_peer(client$get_input_entity(self$send_as))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SendMediaRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "media" = if (inherits(self$media, "TLObject")) self$media$to_dict() else self$media,
        "message" = self$message,
        "silent" = self$silent,
        "background" = self$background,
        "clear_draft" = self$clear_draft,
        "noforwards" = self$noforwards,
        "update_stickersets_order" = self$update_stickersets_order,
        "invert_media" = self$invert_media,
        "allow_paid_floodskip" = self$allow_paid_floodskip,
        "reply_to" = if (inherits(self$reply_to, "TLObject")) self$reply_to$to_dict() else self$reply_to,
        "random_id" = self$random_id,
        "reply_markup" = if (inherits(self$reply_markup, "TLObject")) self$reply_markup$to_dict() else self$reply_markup,
        "entities" = if (is.null(self$entities)) list() else lapply(self$entities, function(x) if (inherits(x, "TLObject")) x$to_dict() else x),
        "schedule_date" = self$schedule_date,
        "send_as" = if (inherits(self$send_as, "TLObject")) self$send_as$to_dict() else self$send_as,
        "quick_reply_shortcut" = if (inherits(self$quick_reply_shortcut, "TLObject")) self$quick_reply_shortcut$to_dict() else self$quick_reply_shortcut,
        "effect" = self$effect,
        "allow_paid_stars" = self$allow_paid_stars,
        "suggested_post" = if (inherits(self$suggested_post, "TLObject")) self$suggested_post$to_dict() else self$suggested_post
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$silent) && self$silent) flags <- bitwOr(flags, 32L)
      if (!is.null(self$background) && self$background) flags <- bitwOr(flags, 64L)
      if (!is.null(self$clear_draft) && self$clear_draft) flags <- bitwOr(flags, 128L)
      if (!is.null(self$noforwards) && self$noforwards) flags <- bitwOr(flags, 16384L)
      if (!is.null(self$update_stickersets_order) && self$update_stickersets_order) flags <- bitwOr(flags, 32768L)
      if (!is.null(self$invert_media) && self$invert_media) flags <- bitwOr(flags, 65536L)
      if (!is.null(self$allow_paid_floodskip) && self$allow_paid_floodskip) flags <- bitwOr(flags, 524288L)
      if (!is.null(self$reply_to)) flags <- bitwOr(flags, 1L)
      if (!is.null(self$reply_markup)) flags <- bitwOr(flags, 4L)
      if (!is.null(self$entities)) flags <- bitwOr(flags, 8L)
      if (!is.null(self$schedule_date)) flags <- bitwOr(flags, 1024L)
      if (!is.null(self$send_as)) flags <- bitwOr(flags, 8192L)
      if (!is.null(self$quick_reply_shortcut)) flags <- bitwOr(flags, 131072L)
      if (!is.null(self$effect)) flags <- bitwOr(flags, 262144L)
      if (!is.null(self$allow_paid_stars)) flags <- bitwOr(flags, 2097152L)
      if (!is.null(self$suggested_post)) flags <- bitwOr(flags, 4194304L)
      c(
        as.raw(c(0xc1, 0xd9, 0x55, 0xac)),
        packBits(intToBits(flags), type = "raw")[1:4],
        self$peer$bytes(),
        if (!is.null(self$reply_to)) self$reply_to$bytes() else raw(0),
        self$media$bytes(),
        self$serialize_bytes(self$message),
        packBits(intToBits(self$random_id), type = "raw")[1:8],
        if (!is.null(self$reply_markup)) self$reply_markup$bytes() else raw(0),
        if (!is.null(self$entities)) c(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), packBits(intToBits(length(self$entities)), type = "raw")[1:4], do.call(c, lapply(self$entities, function(x) x$bytes()))) else raw(0),
        if (!is.null(self$schedule_date)) self$serialize_datetime(self$schedule_date) else raw(0),
        if (!is.null(self$send_as)) self$send_as$bytes() else raw(0),
        if (!is.null(self$quick_reply_shortcut)) self$quick_reply_shortcut$bytes() else raw(0),
        if (!is.null(self$effect)) packBits(intToBits(self$effect), type = "raw")[1:8] else raw(0),
        if (!is.null(self$allow_paid_stars)) packBits(intToBits(self$allow_paid_stars), type = "raw")[1:8] else raw(0),
        if (!is.null(self$suggested_post)) self$suggested_post$bytes() else raw(0)
      )
    }
  )
)

# @title from_reader
# @name SendMediaRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SendMediaRequest.
SendMediaRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  silent <- bitwAnd(flags, 32L) != 0
  background <- bitwAnd(flags, 64L) != 0
  clear_draft <- bitwAnd(flags, 128L) != 0
  noforwards <- bitwAnd(flags, 16384L) != 0
  update_stickersets_order <- bitwAnd(flags, 32768L) != 0
  invert_media <- bitwAnd(flags, 65536L) != 0
  allow_paid_floodskip <- bitwAnd(flags, 524288L) != 0
  peer <- reader$tgread_object()
  reply_to <- if (bitwAnd(flags, 1L) != 0) reader$tgread_object() else NULL
  media <- reader$tgread_object()
  message <- reader$tgread_string()
  random_id <- reader$read_long()
  reply_markup <- if (bitwAnd(flags, 4L) != 0) reader$tgread_object() else NULL
  entities <- if (bitwAnd(flags, 8L) != 0) {
    reader$read_int() # skip vector ID
    lapply(1:reader$read_int(), function(i) reader$tgread_object())
  } else {
    NULL
  }
  schedule_date <- if (bitwAnd(flags, 1024L) != 0) reader$tgread_date() else NULL
  send_as <- if (bitwAnd(flags, 8192L) != 0) reader$tgread_object() else NULL
  quick_reply_shortcut <- if (bitwAnd(flags, 131072L) != 0) reader$tgread_object() else NULL
  effect <- if (bitwAnd(flags, 262144L) != 0) reader$read_long() else NULL
  allow_paid_stars <- if (bitwAnd(flags, 2097152L) != 0) reader$read_long() else NULL
  suggested_post <- if (bitwAnd(flags, 4194304L) != 0) reader$tgread_object() else NULL
  SendMediaRequest$new(peer = peer, media = media, message = message, silent = silent, background = background, clear_draft = clear_draft, noforwards = noforwards, update_stickersets_order = update_stickersets_order, invert_media = invert_media, allow_paid_floodskip = allow_paid_floodskip, reply_to = reply_to, random_id = random_id, reply_markup = reply_markup, entities = entities, schedule_date = schedule_date, send_as = send_as, quick_reply_shortcut = quick_reply_shortcut, effect = effect, allow_paid_stars = allow_paid_stars, suggested_post = suggested_post)
}

#  @title SendMessageRequest
#  @description Represents a request to send a message. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SendMessageRequest <- R6::R6Class(
  "SendMessageRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xfe05dc9a,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the SendMessageRequest object.
    #  @param peer The input peer.
    #  @param message The message string.
    #  @param no_webpage Optional no webpage flag.
    #  @param silent Optional silent flag.
    #  @param background Optional background flag.
    #  @param clear_draft Optional clear draft flag.
    #  @param noforwards Optional no forwards flag.
    #  @param update_stickersets_order Optional update stickersets order flag.
    #  @param invert_media Optional invert media flag.
    #  @param allow_paid_floodskip Optional allow paid floodskip flag.
    #  @param reply_to Optional input reply to.
    #  @param random_id Optional random ID, defaults to a generated 64-bit integer.
    #  @param reply_markup Optional reply markup.
    #  @param entities Optional list of message entities.
    #  @param schedule_date Optional schedule date.
    #  @param send_as Optional input peer to send as.
    #  @param quick_reply_shortcut Optional input quick reply shortcut.
    #  @param effect Optional effect ID.
    #  @param allow_paid_stars Optional allow paid stars count.
    #  @param suggested_post Optional suggested post.
    initialize = function(peer, message, no_webpage = NULL, silent = NULL, background = NULL, clear_draft = NULL, noforwards = NULL, update_stickersets_order = NULL, invert_media = NULL, allow_paid_floodskip = NULL, reply_to = NULL, random_id = NULL, reply_markup = NULL, entities = NULL, schedule_date = NULL, send_as = NULL, quick_reply_shortcut = NULL, effect = NULL, allow_paid_stars = NULL, suggested_post = NULL) {
      self$peer <- peer
      self$message <- message
      self$no_webpage <- no_webpage
      self$silent <- silent
      self$background <- background
      self$clear_draft <- clear_draft
      self$noforwards <- noforwards
      self$update_stickersets_order <- update_stickersets_order
      self$invert_media <- invert_media
      self$allow_paid_floodskip <- allow_paid_floodskip
      self$reply_to <- reply_to
      self$random_id <- if (is.null(random_id)) as.integer(runif(1, min = 0, max = 2^64 - 1)) else random_id
      self$reply_markup <- reply_markup
      self$entities <- entities
      self$schedule_date <- schedule_date
      self$send_as <- send_as
      self$quick_reply_shortcut <- quick_reply_shortcut
      self$effect <- effect
      self$allow_paid_stars <- allow_paid_stars
      self$suggested_post <- suggested_post
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      if (!is.null(self$send_as)) {
        self$send_as <- utils$get_input_peer(client$get_input_entity(self$send_as))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SendMessageRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "message" = self$message,
        "no_webpage" = self$no_webpage,
        "silent" = self$silent,
        "background" = self$background,
        "clear_draft" = self$clear_draft,
        "noforwards" = self$noforwards,
        "update_stickersets_order" = self$update_stickersets_order,
        "invert_media" = self$invert_media,
        "allow_paid_floodskip" = self$allow_paid_floodskip,
        "reply_to" = if (inherits(self$reply_to, "TLObject")) self$reply_to$to_dict() else self$reply_to,
        "random_id" = self$random_id,
        "reply_markup" = if (inherits(self$reply_markup, "TLObject")) self$reply_markup$to_dict() else self$reply_markup,
        "entities" = if (is.null(self$entities)) list() else lapply(self$entities, function(x) if (inherits(x, "TLObject")) x$to_dict() else x),
        "schedule_date" = self$schedule_date,
        "send_as" = if (inherits(self$send_as, "TLObject")) self$send_as$to_dict() else self$send_as,
        "quick_reply_shortcut" = if (inherits(self$quick_reply_shortcut, "TLObject")) self$quick_reply_shortcut$to_dict() else self$quick_reply_shortcut,
        "effect" = self$effect,
        "allow_paid_stars" = self$allow_paid_stars,
        "suggested_post" = if (inherits(self$suggested_post, "TLObject")) self$suggested_post$to_dict() else self$suggested_post
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$no_webpage) && self$no_webpage) flags <- bitwOr(flags, 2L)
      if (!is.null(self$silent) && self$silent) flags <- bitwOr(flags, 32L)
      if (!is.null(self$background) && self$background) flags <- bitwOr(flags, 64L)
      if (!is.null(self$clear_draft) && self$clear_draft) flags <- bitwOr(flags, 128L)
      if (!is.null(self$noforwards) && self$noforwards) flags <- bitwOr(flags, 16384L)
      if (!is.null(self$update_stickersets_order) && self$update_stickersets_order) flags <- bitwOr(flags, 32768L)
      if (!is.null(self$invert_media) && self$invert_media) flags <- bitwOr(flags, 65536L)
      if (!is.null(self$allow_paid_floodskip) && self$allow_paid_floodskip) flags <- bitwOr(flags, 524288L)
      if (!is.null(self$reply_to)) flags <- bitwOr(flags, 1L)
      if (!is.null(self$reply_markup)) flags <- bitwOr(flags, 4L)
      if (!is.null(self$entities)) flags <- bitwOr(flags, 8L)
      if (!is.null(self$schedule_date)) flags <- bitwOr(flags, 1024L)
      if (!is.null(self$send_as)) flags <- bitwOr(flags, 8192L)
      if (!is.null(self$quick_reply_shortcut)) flags <- bitwOr(flags, 131072L)
      if (!is.null(self$effect)) flags <- bitwOr(flags, 262144L)
      if (!is.null(self$allow_paid_stars)) flags <- bitwOr(flags, 2097152L)
      if (!is.null(self$suggested_post)) flags <- bitwOr(flags, 4194304L)
      c(
        as.raw(c(0xfe, 0x05, 0xdc, 0x9a)),
        packBits(intToBits(flags), type = "raw")[1:4],
        self$peer$bytes(),
        if (!is.null(self$reply_to)) self$reply_to$bytes() else raw(0),
        self$serialize_bytes(self$message),
        packBits(intToBits(self$random_id), type = "raw")[1:8],
        if (!is.null(self$reply_markup)) self$reply_markup$bytes() else raw(0),
        if (!is.null(self$entities)) c(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), packBits(intToBits(length(self$entities)), type = "raw")[1:4], do.call(c, lapply(self$entities, function(x) x$bytes()))) else raw(0),
        if (!is.null(self$schedule_date)) self$serialize_datetime(self$schedule_date) else raw(0),
        if (!is.null(self$send_as)) self$send_as$bytes() else raw(0),
        if (!is.null(self$quick_reply_shortcut)) self$quick_reply_shortcut$bytes() else raw(0),
        if (!is.null(self$effect)) packBits(intToBits(self$effect), type = "raw")[1:8] else raw(0),
        if (!is.null(self$allow_paid_stars)) packBits(intToBits(self$allow_paid_stars), type = "raw")[1:8] else raw(0),
        if (!is.null(self$suggested_post)) self$suggested_post$bytes() else raw(0)
      )
    }
  )
)

# @title from_reader
# @name SendMessageRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SendMessageRequest.
SendMessageRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  no_webpage <- bitwAnd(flags, 2L) != 0
  silent <- bitwAnd(flags, 32L) != 0
  background <- bitwAnd(flags, 64L) != 0
  clear_draft <- bitwAnd(flags, 128L) != 0
  noforwards <- bitwAnd(flags, 16384L) != 0
  update_stickersets_order <- bitwAnd(flags, 32768L) != 0
  invert_media <- bitwAnd(flags, 65536L) != 0
  allow_paid_floodskip <- bitwAnd(flags, 524288L) != 0
  peer <- reader$tgread_object()
  reply_to <- if (bitwAnd(flags, 1L) != 0) reader$tgread_object() else NULL
  message <- reader$tgread_string()
  random_id <- reader$read_long()
  reply_markup <- if (bitwAnd(flags, 4L) != 0) reader$tgread_object() else NULL
  entities <- if (bitwAnd(flags, 8L) != 0) {
    reader$read_int() # skip vector ID
    lapply(1:reader$read_int(), function(i) reader$tgread_object())
  } else {
    NULL
  }
  schedule_date <- if (bitwAnd(flags, 1024L) != 0) reader$tgread_date() else NULL
  send_as <- if (bitwAnd(flags, 8192L) != 0) reader$tgread_object() else NULL
  quick_reply_shortcut <- if (bitwAnd(flags, 131072L) != 0) reader$tgread_object() else NULL
  effect <- if (bitwAnd(flags, 262144L) != 0) reader$read_long() else NULL
  allow_paid_stars <- if (bitwAnd(flags, 2097152L) != 0) reader$read_long() else NULL
  suggested_post <- if (bitwAnd(flags, 4194304L) != 0) reader$tgread_object() else NULL
  SendMessageRequest$new(peer = peer, message = message, no_webpage = no_webpage, silent = silent, background = background, clear_draft = clear_draft, noforwards = noforwards, update_stickersets_order = update_stickersets_order, invert_media = invert_media, allow_paid_floodskip = allow_paid_floodskip, reply_to = reply_to, random_id = random_id, reply_markup = reply_markup, entities = entities, schedule_date = schedule_date, send_as = send_as, quick_reply_shortcut = quick_reply_shortcut, effect = effect, allow_paid_stars = allow_paid_stars, suggested_post = suggested_post)
}


#  @title SendMultiMediaRequest
#  @description Represents a request to send multi media. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SendMultiMediaRequest <- R6::R6Class(
  "SendMultiMediaRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x1bf89d74,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the SendMultiMediaRequest object.
    #  @param peer The input peer.
    #  @param multi_media List of input single media.
    #  @param silent Optional silent flag.
    #  @param background Optional background flag.
    #  @param clear_draft Optional clear draft flag.
    #  @param noforwards Optional no forwards flag.
    #  @param update_stickersets_order Optional update stickersets order flag.
    #  @param invert_media Optional invert media flag.
    #  @param allow_paid_floodskip Optional allow paid floodskip flag.
    #  @param reply_to Optional input reply to.
    #  @param schedule_date Optional schedule date.
    #  @param send_as Optional input peer to send as.
    #  @param quick_reply_shortcut Optional input quick reply shortcut.
    #  @param effect Optional effect ID.
    #  @param allow_paid_stars Optional allow paid stars count.
    initialize = function(peer, multi_media, silent = NULL, background = NULL, clear_draft = NULL, noforwards = NULL, update_stickersets_order = NULL, invert_media = NULL, allow_paid_floodskip = NULL, reply_to = NULL, schedule_date = NULL, send_as = NULL, quick_reply_shortcut = NULL, effect = NULL, allow_paid_stars = NULL) {
      self$peer <- peer
      self$multi_media <- multi_media
      self$silent <- silent
      self$background <- background
      self$clear_draft <- clear_draft
      self$noforwards <- noforwards
      self$update_stickersets_order <- update_stickersets_order
      self$invert_media <- invert_media
      self$allow_paid_floodskip <- allow_paid_floodskip
      self$reply_to <- reply_to
      self$schedule_date <- schedule_date
      self$send_as <- send_as
      self$quick_reply_shortcut <- quick_reply_shortcut
      self$effect <- effect
      self$allow_paid_stars <- allow_paid_stars
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      if (!is.null(self$send_as)) {
        self$send_as <- utils$get_input_peer(client$get_input_entity(self$send_as))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SendMultiMediaRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "multi_media" = if (is.null(self$multi_media)) list() else lapply(self$multi_media, function(x) if (inherits(x, "TLObject")) x$to_dict() else x),
        "silent" = self$silent,
        "background" = self$background,
        "clear_draft" = self$clear_draft,
        "noforwards" = self$noforwards,
        "update_stickersets_order" = self$update_stickersets_order,
        "invert_media" = self$invert_media,
        "allow_paid_floodskip" = self$allow_paid_floodskip,
        "reply_to" = if (inherits(self$reply_to, "TLObject")) self$reply_to$to_dict() else self$reply_to,
        "schedule_date" = self$schedule_date,
        "send_as" = if (inherits(self$send_as, "TLObject")) self$send_as$to_dict() else self$send_as,
        "quick_reply_shortcut" = if (inherits(self$quick_reply_shortcut, "TLObject")) self$quick_reply_shortcut$to_dict() else self$quick_reply_shortcut,
        "effect" = self$effect,
        "allow_paid_stars" = self$allow_paid_stars
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$silent) && self$silent) flags <- bitwOr(flags, 32L)
      if (!is.null(self$background) && self$background) flags <- bitwOr(flags, 64L)
      if (!is.null(self$clear_draft) && self$clear_draft) flags <- bitwOr(flags, 128L)
      if (!is.null(self$noforwards) && self$noforwards) flags <- bitwOr(flags, 16384L)
      if (!is.null(self$update_stickersets_order) && self$update_stickersets_order) flags <- bitwOr(flags, 32768L)
      if (!is.null(self$invert_media) && self$invert_media) flags <- bitwOr(flags, 65536L)
      if (!is.null(self$allow_paid_floodskip) && self$allow_paid_floodskip) flags <- bitwOr(flags, 524288L)
      if (!is.null(self$reply_to)) flags <- bitwOr(flags, 1L)
      if (!is.null(self$schedule_date)) flags <- bitwOr(flags, 1024L)
      if (!is.null(self$send_as)) flags <- bitwOr(flags, 8192L)
      if (!is.null(self$quick_reply_shortcut)) flags <- bitwOr(flags, 131072L)
      if (!is.null(self$effect)) flags <- bitwOr(flags, 262144L)
      if (!is.null(self$allow_paid_stars)) flags <- bitwOr(flags, 2097152L)
      c(
        as.raw(c(0x74, 0x9d, 0xf8, 0x1b)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        self$peer$bytes(),
        if (!is.null(self$reply_to)) self$reply_to$bytes() else raw(0),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        packBits(intToBits(length(self$multi_media)), type = "raw")[1:4],
        unlist(lapply(self$multi_media, function(x) x$bytes())),
        if (!is.null(self$schedule_date)) self$serialize_datetime(self$schedule_date) else raw(0),
        if (!is.null(self$send_as)) self$send_as$bytes() else raw(0),
        if (!is.null(self$quick_reply_shortcut)) self$quick_reply_shortcut$bytes() else raw(0),
        if (!is.null(self$effect)) writeBin(as.double(self$effect), raw(), size = 8, endian = "little") else raw(0),
        if (!is.null(self$allow_paid_stars)) writeBin(as.double(self$allow_paid_stars), raw(), size = 8, endian = "little") else raw(0)
      )
    }
  )
)

# @title from_reader
# @name SendMultiMediaRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SendMultiMediaRequest.
SendMultiMediaRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  silent <- bitwAnd(flags, 32L) != 0
  background <- bitwAnd(flags, 64L) != 0
  clear_draft <- bitwAnd(flags, 128L) != 0
  noforwards <- bitwAnd(flags, 16384L) != 0
  update_stickersets_order <- bitwAnd(flags, 32768L) != 0
  invert_media <- bitwAnd(flags, 65536L) != 0
  allow_paid_floodskip <- bitwAnd(flags, 524288L) != 0
  peer <- reader$tgread_object()
  reply_to <- if (bitwAnd(flags, 1L) != 0) reader$tgread_object() else NULL
  reader$read_int() # skip vector ID
  multi_media <- list()
  for (i in 1:reader$read_int()) {
    x <- reader$tgread_object()
    multi_media[[i]] <- x
  }
  schedule_date <- if (bitwAnd(flags, 1024L) != 0) reader$tgread_date() else NULL
  send_as <- if (bitwAnd(flags, 8192L) != 0) reader$tgread_object() else NULL
  quick_reply_shortcut <- if (bitwAnd(flags, 131072L) != 0) reader$tgread_object() else NULL
  effect <- if (bitwAnd(flags, 262144L) != 0) reader$read_long() else NULL
  allow_paid_stars <- if (bitwAnd(flags, 2097152L) != 0) reader$read_long() else NULL
  SendMultiMediaRequest$new(peer = peer, multi_media = multi_media, silent = silent, background = background, clear_draft = clear_draft, noforwards = noforwards, update_stickersets_order = update_stickersets_order, invert_media = invert_media, allow_paid_floodskip = allow_paid_floodskip, reply_to = reply_to, schedule_date = schedule_date, send_as = send_as, quick_reply_shortcut = quick_reply_shortcut, effect = effect, allow_paid_stars = allow_paid_stars)
}

#  @title SendPaidReactionRequest
#  @description Represents a request to send a paid reaction. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SendPaidReactionRequest <- R6::R6Class(
  "SendPaidReactionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x58bbcb50,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the SendPaidReactionRequest object.
    #  @param peer The input peer.
    #  @param msg_id The message ID.
    #  @param count The count.
    #  @param random_id Optional random ID, defaults to a generated 64-bit integer.
    #  @param private Optional paid reaction privacy.
    initialize = function(peer, msg_id, count, random_id = NULL, private = NULL) {
      self$peer <- peer
      self$msg_id <- msg_id
      self$count <- count
      self$random_id <- if (is.null(random_id)) as.integer(runif(1, min = 0, max = 2^64 - 1)) else random_id
      self$private <- private
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SendPaidReactionRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "msg_id" = self$msg_id,
        "count" = self$count,
        "random_id" = self$random_id,
        "private" = if (inherits(self$private, "TLObject")) self$private$to_dict() else self$private
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$private)) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x50, 0xcb, 0xbb, 0x58)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        self$peer$bytes(),
        packBits(intToBits(self$msg_id), type = "raw")[1:4],
        packBits(intToBits(self$count), type = "raw")[1:4],
        writeBin(as.double(self$random_id), raw(), size = 8, endian = "little"),
        if (!is.null(self$private)) self$private$bytes() else raw(0)
      )
    }
  )
)

# @title from_reader
# @name SendPaidReactionRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SendPaidReactionRequest.
SendPaidReactionRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  peer <- reader$tgread_object()
  msg_id <- reader$read_int()
  count <- reader$read_int()
  random_id <- reader$read_long()
  private <- if (bitwAnd(flags, 1L) != 0) reader$tgread_object() else NULL
  SendPaidReactionRequest$new(peer = peer, msg_id = msg_id, count = count, random_id = random_id, private = private)
}


#  @title SendQuickReplyMessagesRequest
#  @description Represents a request to send quick reply messages. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SendQuickReplyMessagesRequest <- R6::R6Class(
  "SendQuickReplyMessagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x6c750de1,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the SendQuickReplyMessagesRequest object.
    #  @param peer The input peer.
    #  @param shortcut_id The shortcut ID.
    #  @param id List of message IDs.
    #  @param random_id Optional list of random IDs, defaults to generated random 64-bit integers.
    initialize = function(peer, shortcut_id, id, random_id = NULL) {
      self$peer <- peer
      self$shortcut_id <- shortcut_id
      self$id <- id
      self$random_id <- if (is.null(random_id)) {
        sapply(seq_along(id), function(x) sample(.Machine$integer.max, 1))
      } else {
        random_id
      }
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SendQuickReplyMessagesRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "shortcut_id" = self$shortcut_id,
        "id" = if (is.null(self$id)) list() else self$id,
        "random_id" = if (is.null(self$random_id)) list() else self$random_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xe1, 0x0d, 0x75, 0x6c)),
        self$peer$bytes(),
        packBits(intToBits(self$shortcut_id), type = "raw")[1:4],
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        packBits(intToBits(length(self$id)), type = "raw")[1:4],
        unlist(lapply(self$id, function(x) packBits(intToBits(x), type = "raw")[1:4])),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        packBits(intToBits(length(self$random_id)), type = "raw")[1:4],
        unlist(lapply(self$random_id, function(x) writeBin(as.double(x), raw(), size = 8, endian = "little")))
      )
    }
  )
)

# @title from_reader
# @name SendQuickReplyMessagesRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SendQuickReplyMessagesRequest.
SendQuickReplyMessagesRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  shortcut_id <- reader$read_int()
  reader$read_int()
  id <- list()
  for (i in 1:reader$read_int()) {
    id[[i]] <- reader$read_int()
  }
  reader$read_int()
  random_id <- list()
  for (i in 1:reader$read_int()) {
    random_id[[i]] <- reader$read_long()
  }
  SendQuickReplyMessagesRequest$new(peer = peer, shortcut_id = shortcut_id, id = id, random_id = random_id)
}

#  @title SendReactionRequest
#  @description Represents a request to send a reaction. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SendReactionRequest <- R6::R6Class(
  "SendReactionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xd30d78d4,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the SendReactionRequest object.
    #  @param peer The input peer.
    #  @param msg_id The message ID.
    #  @param big Optional big flag.
    #  @param add_to_recent Optional add to recent flag.
    #  @param reaction Optional list of reactions.
    initialize = function(peer, msg_id, big = NULL, add_to_recent = NULL, reaction = NULL) {
      self$peer <- peer
      self$msg_id <- msg_id
      self$big <- big
      self$add_to_recent <- add_to_recent
      self$reaction <- reaction
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SendReactionRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "msg_id" = self$msg_id,
        "big" = self$big,
        "add_to_recent" = self$add_to_recent,
        "reaction" = if (is.null(self$reaction)) list() else lapply(self$reaction, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$big) && self$big) flags <- bitwOr(flags, 2L)
      if (!is.null(self$add_to_recent) && self$add_to_recent) flags <- bitwOr(flags, 4L)
      if (!is.null(self$reaction)) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0xd4, 0x78, 0x0d, 0xd3)),
        packBits(intToBits(flags), type = "raw")[1:4],
        self$peer$bytes(),
        packBits(intToBits(self$msg_id), type = "raw")[1:4],
        if (!is.null(self$reaction)) {
          c(
            as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
            packBits(intToBits(length(self$reaction)), type = "raw")[1:4],
            unlist(lapply(self$reaction, function(x) x$bytes()))
          )
        } else {
          raw(0)
        }
      )
    }
  )
)

# @title from_reader
# @name SendReactionRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SendReactionRequest.
SendReactionRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  big <- bitwAnd(flags, 2L) != 0
  add_to_recent <- bitwAnd(flags, 4L) != 0
  peer <- reader$tgread_object()
  msg_id <- reader$read_int()
  reaction <- if (bitwAnd(flags, 1L) != 0) {
    reader$read_int()
    lapply(1:reader$read_int(), function(i) reader$tgread_object())
  } else {
    NULL
  }
  SendReactionRequest$new(peer = peer, msg_id = msg_id, big = big, add_to_recent = add_to_recent, reaction = reaction)
}

#  @title SendScheduledMessagesRequest
#  @description Represents a request to send scheduled messages. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SendScheduledMessagesRequest <- R6::R6Class(
  "SendScheduledMessagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xbd38850a,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the SendScheduledMessagesRequest object.
    #  @param peer The input peer.
    #  @param id List of message IDs.
    initialize = function(peer, id) {
      self$peer <- peer
      self$id <- id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SendScheduledMessagesRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "id" = if (is.null(self$id)) list() else self$id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x0a, 0x85, 0x38, 0xbd)),
        self$peer$bytes(),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        packBits(intToBits(length(self$id)), type = "raw")[1:4],
        unlist(lapply(self$id, function(x) packBits(intToBits(x), type = "raw")[1:4]))
      )
    }
  )
)

# @title from_reader
# @name SendScheduledMessagesRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SendScheduledMessagesRequest.
SendScheduledMessagesRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  reader$read_int()
  id <- list()
  for (i in 1:reader$read_int()) {
    id[[i]] <- reader$read_int()
  }
  SendScheduledMessagesRequest$new(peer = peer, id = id)
}


#  @title SendScreenshotNotificationRequest
#  @description Represents a request to send a screenshot notification. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SendScreenshotNotificationRequest <- R6::R6Class(
  "SendScreenshotNotificationRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xa1405817,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the SendScreenshotNotificationRequest object.
    #  @param peer The input peer.
    #  @param reply_to The input reply to.
    #  @param random_id Optional random ID, defaults to a generated 64-bit integer.
    initialize = function(peer, reply_to, random_id = NULL) {
      self$peer <- peer
      self$reply_to <- reply_to
      self$random_id <- if (is.null(random_id)) as.integer(runif(1, min = 0, max = 2^64 - 1)) else random_id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SendScreenshotNotificationRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "reply_to" = if (inherits(self$reply_to, "TLObject")) self$reply_to$to_dict() else self$reply_to,
        "random_id" = self$random_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x17, 0x58, 0x40, 0xa1)),
        self$peer$bytes(),
        self$reply_to$bytes(),
        writeBin(as.double(self$random_id), raw(), size = 8, endian = "little")
      )
    }
  )
)

# @title from_reader
# @name SendScreenshotNotificationRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SendScreenshotNotificationRequest.
SendScreenshotNotificationRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  reply_to <- reader$tgread_object()
  random_id <- reader$read_long()
  SendScreenshotNotificationRequest$new(peer = peer, reply_to = reply_to, random_id = random_id)
}

#  @title SendVoteRequest
#  @description Represents a request to send a vote. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SendVoteRequest <- R6::R6Class(
  "SendVoteRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x10ea6184,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the SendVoteRequest object.
    #  @param peer The input peer.
    #  @param msg_id The message ID.
    #  @param options List of vote options as bytes.
    initialize = function(peer, msg_id, options) {
      self$peer <- peer
      self$msg_id <- msg_id
      self$options <- options
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SendVoteRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "msg_id" = self$msg_id,
        "options" = if (is.null(self$options)) list() else self$options
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x84, 0x61, 0xea, 0x10)),
        self$peer$bytes(),
        packBits(intToBits(self$msg_id), type = "raw")[1:4],
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        packBits(intToBits(length(self$options)), type = "raw")[1:4],
        unlist(lapply(self$options, function(x) self$serialize_bytes(x)))
      )
    }
  )
)

# @title from_reader
# @name SendVoteRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SendVoteRequest.
SendVoteRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  msg_id <- reader$read_int()
  reader$read_int()
  options <- list()
  for (i in 1:reader$read_int()) {
    options[[i]] <- reader$tgread_bytes()
  }
  SendVoteRequest$new(peer = peer, msg_id = msg_id, options = options)
}

#  @title SendWebViewDataRequest
#  @description Represents a request to send web view data. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SendWebViewDataRequest <- R6::R6Class(
  "SendWebViewDataRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xdc0242c8,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the SendWebViewDataRequest object.
    #  @param bot The input user (bot).
    #  @param button_text The button text.
    #  @param data The data string.
    #  @param random_id Optional random ID, defaults to a generated 64-bit integer.
    initialize = function(bot, button_text, data, random_id = NULL) {
      self$bot <- bot
      self$button_text <- button_text
      self$data <- data
      self$random_id <- if (is.null(random_id)) as.integer(runif(1, min = 0, max = 2^64 - 1)) else random_id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$bot <- utils$get_input_user(client$get_input_entity(self$bot))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SendWebViewDataRequest",
        "bot" = if (inherits(self$bot, "TLObject")) self$bot$to_dict() else self$bot,
        "button_text" = self$button_text,
        "data" = self$data,
        "random_id" = self$random_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xc8, 0x42, 0x02, 0xdc)),
        self$bot$bytes(),
        writeBin(as.double(self$random_id), raw(), size = 8, endian = "little"),
        self$serialize_bytes(self$button_text),
        self$serialize_bytes(self$data)
      )
    }
  )
)

# @title from_reader
# @name SendWebViewDataRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SendWebViewDataRequest.
SendWebViewDataRequest$from_reader <- function(reader) {
  bot <- reader$tgread_object()
  random_id <- reader$read_long()
  button_text <- reader$tgread_string()
  data <- reader$tgread_string()
  SendWebViewDataRequest$new(bot = bot, button_text = button_text, data = data, random_id = random_id)
}


#  @title SendWebViewResultMessageRequest
#  @description Represents a request to send a web view result message. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SendWebViewResultMessageRequest <- R6::R6Class(
  "SendWebViewResultMessageRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xa4314f5,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x75e49312,

    #  @description Initialize the SendWebViewResultMessageRequest object.
    #  @param bot_query_id The bot query ID as a string.
    #  @param result The input bot inline result.
    initialize = function(bot_query_id, result) {
      self$bot_query_id <- bot_query_id
      self$result <- result
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SendWebViewResultMessageRequest",
        "bot_query_id" = self$bot_query_id,
        "result" = if (inherits(self$result, "TLObject")) self$result$to_dict() else self$result
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xf5, 0x14, 0x43, 0x0a)),
        self$serialize_bytes(self$bot_query_id),
        self$result$bytes()
      )
    }
  )
)

# @title from_reader
# @name SendWebViewResultMessageRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SendWebViewResultMessageRequest.
SendWebViewResultMessageRequest$from_reader <- function(reader) {
  bot_query_id <- reader$tgread_string()
  result <- reader$tgread_object()
  SendWebViewResultMessageRequest$new(bot_query_id = bot_query_id, result = result)
}

#  @title SetBotCallbackAnswerRequest
#  @description Represents a request to set bot callback answer. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SetBotCallbackAnswerRequest <- R6::R6Class(
  "SetBotCallbackAnswerRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xd58f130a,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the SetBotCallbackAnswerRequest object.
    #  @param query_id The query ID.
    #  @param cache_time The cache time.
    #  @param alert Optional alert flag.
    #  @param message Optional message string.
    #  @param url Optional URL string.
    initialize = function(query_id, cache_time, alert = NULL, message = NULL, url = NULL) {
      self$query_id <- query_id
      self$cache_time <- cache_time
      self$alert <- alert
      self$message <- message
      self$url <- url
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetBotCallbackAnswerRequest",
        "query_id" = self$query_id,
        "cache_time" = self$cache_time,
        "alert" = self$alert,
        "message" = self$message,
        "url" = self$url
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$alert) && self$alert != FALSE) flags <- bitwOr(flags, 2L)
      if (!is.null(self$message) && self$message != FALSE) flags <- bitwOr(flags, 1L)
      if (!is.null(self$url) && self$url != FALSE) flags <- bitwOr(flags, 4L)
      c(
        as.raw(c(0x0a, 0x13, 0x8f, 0xd5)),
        packBits(intToBits(flags), type = "raw")[1:4],
        writeBin(as.double(self$query_id), raw(), size = 8, endian = "little"),
        if (!is.null(self$message) && self$message != FALSE) self$serialize_bytes(self$message) else raw(0),
        if (!is.null(self$url) && self$url != FALSE) self$serialize_bytes(self$url) else raw(0),
        packBits(intToBits(self$cache_time), type = "raw")[1:4]
      )
    }
  )
)

# @title from_reader
# @name SetBotCallbackAnswerRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SetBotCallbackAnswerRequest.
SetBotCallbackAnswerRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  alert <- bitwAnd(flags, 2L) != 0
  query_id <- reader$read_long()
  message <- if (bitwAnd(flags, 1L) != 0) reader$tgread_string() else NULL
  url <- if (bitwAnd(flags, 4L) != 0) reader$tgread_string() else NULL
  cache_time <- reader$read_int()
  SetBotCallbackAnswerRequest$new(query_id = query_id, cache_time = cache_time, alert = alert, message = message, url = url)
}

#  @title SetBotPrecheckoutResultsRequest
#  @description Represents a request to set bot precheckout results. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SetBotPrecheckoutResultsRequest <- R6::R6Class(
  "SetBotPrecheckoutResultsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x9c2dd95,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the SetBotPrecheckoutResultsRequest object.
    #  @param query_id The query ID.
    #  @param success Optional success flag.
    #  @param error Optional error message.
    initialize = function(query_id, success = NULL, error = NULL) {
      self$query_id <- query_id
      self$success <- success
      self$error <- error
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetBotPrecheckoutResultsRequest",
        "query_id" = self$query_id,
        "success" = self$success,
        "error" = self$error
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$success) && self$success != FALSE) flags <- bitwOr(flags, 2L)
      if (!is.null(self$error) && self$error != FALSE) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x95, 0xdd, 0xc2, 0x09)),
        packBits(intToBits(flags), type = "raw")[1:4],
        writeBin(as.double(self$query_id), raw(), size = 8, endian = "little"),
        if (!is.null(self$error) && self$error != FALSE) self$serialize_bytes(self$error) else raw(0)
      )
    }
  )
)

# @title from_reader
# @name SetBotPrecheckoutResultsRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SetBotPrecheckoutResultsRequest.
SetBotPrecheckoutResultsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  success <- bitwAnd(flags, 2L) != 0
  query_id <- reader$read_long()
  error <- if (bitwAnd(flags, 1L) != 0) reader$tgread_string() else NULL
  SetBotPrecheckoutResultsRequest$new(query_id = query_id, success = success, error = error)
}


#  @title SetBotShippingResultsRequest
#  @description Represents a request to set bot shipping results. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SetBotShippingResultsRequest <- R6::R6Class(
  "SetBotShippingResultsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xe5f672fa,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the SetBotShippingResultsRequest object.
    #  @param query_id The query ID.
    #  @param error Optional error message.
    #  @param shipping_options Optional list of shipping options.
    initialize = function(query_id, error = NULL, shipping_options = NULL) {
      self$query_id <- query_id
      self$error <- error
      self$shipping_options <- shipping_options
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetBotShippingResultsRequest",
        query_id = self$query_id,
        error = self$error,
        shipping_options = if (is.null(self$shipping_options)) list() else lapply(self$shipping_options, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$error) && self$error != FALSE) flags <- bitwOr(flags, 1L)
      if (!is.null(self$shipping_options) && self$shipping_options != FALSE) flags <- bitwOr(flags, 2L)
      c(
        as.raw(c(0xfa, 0x72, 0xf6, 0xe5)),
        packBits(intToBits(flags), type = "raw")[1:4],
        writeBin(as.double(self$query_id), raw(), size = 8, endian = "little"),
        if (!is.null(self$error) && self$error != FALSE) self$serialize_bytes(self$error) else raw(0),
        if (!is.null(self$shipping_options) && self$shipping_options != FALSE) c(as.raw(c(0x1c, 0xb5, 0xc4, 0x15)), packBits(intToBits(length(self$shipping_options)), type = "raw")[1:4], do.call(c, lapply(self$shipping_options, function(x) x$bytes()))) else raw(0)
      )
    }
  )
)

# @title from_reader
# @name SetBotShippingResultsRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SetBotShippingResultsRequest.
SetBotShippingResultsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  query_id <- reader$read_long()
  error <- if (bitwAnd(flags, 1L) != 0) reader$tgread_string() else NULL
  shipping_options <- if (bitwAnd(flags, 2L) != 0) {
    reader$read_int()
    lapply(1:reader$read_int(), function(i) reader$tgread_object())
  } else {
    NULL
  }
  SetBotShippingResultsRequest$new(query_id = query_id, error = error, shipping_options = shipping_options)
}

#  @title SetChatAvailableReactionsRequest
#  @description Represents a request to set chat available reactions. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SetChatAvailableReactionsRequest <- R6::R6Class(
  "SetChatAvailableReactionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x864b2581,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the SetChatAvailableReactionsRequest object.
    #  @param peer The input peer.
    #  @param available_reactions The available reactions.
    #  @param reactions_limit Optional reactions limit.
    #  @param paid_enabled Optional paid enabled flag.
    initialize = function(peer, available_reactions, reactions_limit = NULL, paid_enabled = NULL) {
      self$peer <- peer
      self$available_reactions <- available_reactions
      self$reactions_limit <- reactions_limit
      self$paid_enabled <- paid_enabled
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetChatAvailableReactionsRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        available_reactions = if (inherits(self$available_reactions, "TLObject")) self$available_reactions$to_dict() else self$available_reactions,
        reactions_limit = self$reactions_limit,
        paid_enabled = self$paid_enabled
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$reactions_limit) && self$reactions_limit != FALSE) flags <- bitwOr(flags, 1L)
      if (!is.null(self$paid_enabled)) flags <- bitwOr(flags, 2L)
      c(
        as.raw(c(0x81, 0x25, 0x4b, 0x86)),
        packBits(intToBits(flags), type = "raw")[1:4],
        self$peer$bytes(),
        self$available_reactions$bytes(),
        if (!is.null(self$reactions_limit) && self$reactions_limit != FALSE) packBits(intToBits(self$reactions_limit), type = "raw")[1:4] else raw(0),
        if (!is.null(self$paid_enabled)) if (self$paid_enabled) as.raw(c(0x99, 0x75, 0xb5)) else as.raw(c(0xbc, 0x79, 0x37)) else raw(0)
      )
    }
  )
)

# @title from_reader
# @name SetChatAvailableReactionsRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SetChatAvailableReactionsRequest.
SetChatAvailableReactionsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  peer <- reader$tgread_object()
  available_reactions <- reader$tgread_object()
  reactions_limit <- if (bitwAnd(flags, 1L) != 0) reader$read_int() else NULL
  paid_enabled <- if (bitwAnd(flags, 2L) != 0) reader$tgread_bool() else NULL
  SetChatAvailableReactionsRequest$new(peer = peer, available_reactions = available_reactions, reactions_limit = reactions_limit, paid_enabled = paid_enabled)
}

#  @title SetChatThemeRequest
#  @description Represents a request to set chat theme. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SetChatThemeRequest <- R6::R6Class(
  "SetChatThemeRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x81202c9,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the SetChatThemeRequest object.
    #  @param peer The input peer.
    #  @param theme The input chat theme.
    initialize = function(peer, theme) {
      self$peer <- peer
      self$theme <- theme
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetChatThemeRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        theme = if (inherits(self$theme, "TLObject")) self$theme$to_dict() else self$theme
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xc9, 0x02, 0x12, 0x08)),
        self$peer$bytes(),
        self$theme$bytes()
      )
    }
  )
)

# @title from_reader
# @name SetChatThemeRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SetChatThemeRequest.
SetChatThemeRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  theme <- reader$tgread_object()
  SetChatThemeRequest$new(peer = peer, theme = theme)
}


#  @title SetChatWallPaperRequest
#  @description Represents a request to set chat wallpaper. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SetChatWallPaperRequest <- R6::R6Class(
  "SetChatWallPaperRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x8ffacae1,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the SetChatWallPaperRequest object.
    #  @param peer The input peer.
    #  @param for_both Optional flag for both.
    #  @param revert Optional revert flag.
    #  @param wallpaper Optional input wallpaper.
    #  @param settings Optional wallpaper settings.
    #  @param id Optional ID.
    initialize = function(peer, for_both = NULL, revert = NULL, wallpaper = NULL, settings = NULL, id = NULL) {
      self$peer <- peer
      self$for_both <- for_both
      self$revert <- revert
      self$wallpaper <- wallpaper
      self$settings <- settings
      self$id <- id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetChatWallPaperRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        for_both = self$for_both,
        revert = self$revert,
        wallpaper = if (inherits(self$wallpaper, "TLObject")) self$wallpaper$to_dict() else self$wallpaper,
        settings = if (inherits(self$settings, "TLObject")) self$settings$to_dict() else self$settings,
        id = self$id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$for_both) && self$for_both != FALSE) flags <- bitwOr(flags, 8L)
      if (!is.null(self$revert) && self$revert != FALSE) flags <- bitwOr(flags, 16L)
      if (!is.null(self$wallpaper) && self$wallpaper != FALSE) flags <- bitwOr(flags, 1L)
      if (!is.null(self$settings) && self$settings != FALSE) flags <- bitwOr(flags, 4L)
      if (!is.null(self$id) && self$id != FALSE) flags <- bitwOr(flags, 2L)
      c(
        as.raw(c(0xe1, 0xca, 0xfa, 0x8f)),
        struct_pack("<I", flags),
        self$peer$bytes(),
        if (!is.null(self$wallpaper) && self$wallpaper != FALSE) self$wallpaper$bytes() else raw(0),
        if (!is.null(self$settings) && self$settings != FALSE) self$settings$bytes() else raw(0),
        if (!is.null(self$id) && self$id != FALSE) struct_pack("<i", self$id) else raw(0)
      )
    }
  )
)

# @title from_reader
# @name SetChatWallPaperRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SetChatWallPaperRequest.
SetChatWallPaperRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  for_both <- bitwAnd(flags, 8L) != 0
  revert <- bitwAnd(flags, 16L) != 0
  peer <- reader$tgread_object()
  wallpaper <- if (bitwAnd(flags, 1L) != 0) reader$tgread_object() else NULL
  settings <- if (bitwAnd(flags, 4L) != 0) reader$tgread_object() else NULL
  id <- if (bitwAnd(flags, 2L) != 0) reader$read_int() else NULL
  SetChatWallPaperRequest$new(peer = peer, for_both = for_both, revert = revert, wallpaper = wallpaper, settings = settings, id = id)
}

#  @title SetDefaultHistoryTTLRequest
#  @description Represents a request to set default history TTL. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SetDefaultHistoryTTLRequest <- R6::R6Class(
  "SetDefaultHistoryTTLRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x9eb51445,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the SetDefaultHistoryTTLRequest object.
    #  @param period The TTL period.
    initialize = function(period) {
      self$period <- period
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetDefaultHistoryTTLRequest",
        period = self$period
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x45, 0x14, 0xb5, 0x9e)),
        struct_pack("<i", self$period)
      )
    }
  )
)

# @title from_reader
# @name SetDefaultHistoryTTLRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SetDefaultHistoryTTLRequest.
SetDefaultHistoryTTLRequest$from_reader <- function(reader) {
  period <- reader$read_int()
  SetDefaultHistoryTTLRequest$new(period = period)
}

#  @title SetDefaultReactionRequest
#  @description Represents a request to set default reaction. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SetDefaultReactionRequest <- R6::R6Class(
  "SetDefaultReactionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x4f47a016,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the SetDefaultReactionRequest object.
    #  @param reaction The reaction.
    initialize = function(reaction) {
      self$reaction <- reaction
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetDefaultReactionRequest",
        reaction = if (inherits(self$reaction, "TLObject")) self$reaction$to_dict() else self$reaction
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x16, 0xa0, 0x47, 0x4f)),
        self$reaction$bytes()
      )
    }
  )
)

# @title from_reader
# @name SetDefaultReactionRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SetDefaultReactionRequest.
SetDefaultReactionRequest$from_reader <- function(reader) {
  reaction <- reader$tgread_object()
  SetDefaultReactionRequest$new(reaction = reaction)
}


#  @title SetEncryptedTypingRequest
#  @description Represents a request to set encrypted typing. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SetEncryptedTypingRequest <- R6::R6Class(
  "SetEncryptedTypingRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x791451ed,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the SetEncryptedTypingRequest object.
    #  @param peer The input encrypted chat peer.
    #  @param typing Whether typing is enabled.
    initialize = function(peer, typing) {
      self$peer <- peer
      self$typing <- typing
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetEncryptedTypingRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        typing = self$typing
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xed, 0x51, 0x14, 0x79)),
        self$peer$bytes(),
        if (self$typing) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  )
)

# @title from_reader
# @name SetEncryptedTypingRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SetEncryptedTypingRequest.
SetEncryptedTypingRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  typing <- reader$tgread_bool()
  SetEncryptedTypingRequest$new(peer = peer, typing = typing)
}

#  @title SetGameScoreRequest
#  @description Represents a request to set game score. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SetGameScoreRequest <- R6::R6Class(
  "SetGameScoreRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x8ef8ecc0,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the SetGameScoreRequest object.
    #  @param peer The input peer.
    #  @param id The message ID.
    #  @param user_id The input user.
    #  @param score The score.
    #  @param edit_message Optional edit message flag.
    #  @param force Optional force flag.
    initialize = function(peer, id, user_id, score, edit_message = NULL, force = NULL) {
      self$peer <- peer
      self$id <- id
      self$user_id <- user_id
      self$score <- score
      self$edit_message <- edit_message
      self$force <- force
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      self$user_id <- utils$get_input_user(client$get_input_entity(self$user_id))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetGameScoreRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        id = self$id,
        user_id = if (inherits(self$user_id, "TLObject")) self$user_id$to_dict() else self$user_id,
        score = self$score,
        edit_message = self$edit_message,
        force = self$force
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$edit_message) && self$edit_message != FALSE) flags <- bitwOr(flags, 1L)
      if (!is.null(self$force) && self$force != FALSE) flags <- bitwOr(flags, 2L)
      c(
        as.raw(c(0xc0, 0xec, 0xf8, 0x8e)),
        struct_pack("<I", flags),
        self$peer$bytes(),
        struct_pack("<i", self$id),
        self$user_id$bytes(),
        struct_pack("<i", self$score)
      )
    }
  )
)

# @title from_reader
# @name SetGameScoreRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SetGameScoreRequest.
SetGameScoreRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  edit_message <- bitwAnd(flags, 1L) != 0
  force <- bitwAnd(flags, 2L) != 0
  peer <- reader$tgread_object()
  id <- reader$read_int()
  user_id <- reader$tgread_object()
  score <- reader$read_int()
  SetGameScoreRequest$new(peer = peer, id = id, user_id = user_id, score = score, edit_message = edit_message, force = force)
}

#  @title SetHistoryTTLRequest
#  @description Represents a request to set history TTL. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SetHistoryTTLRequest <- R6::R6Class(
  "SetHistoryTTLRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xb80e5fe4,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the SetHistoryTTLRequest object.
    #  @param peer The input peer.
    #  @param period The TTL period.
    initialize = function(peer, period) {
      self$peer <- peer
      self$period <- period
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetHistoryTTLRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        period = self$period
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xe4, 0x5f, 0x0e, 0xb8)),
        self$peer$bytes(),
        struct_pack("<i", self$period)
      )
    }
  )
)

# @title from_reader
# @name SetHistoryTTLRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SetHistoryTTLRequest.
SetHistoryTTLRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  period <- reader$read_int()
  SetHistoryTTLRequest$new(peer = peer, period = period)
}


#  @title SetInlineBotResultsRequest
#  @description Represents a request to set inline bot results. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SetInlineBotResultsRequest <- R6::R6Class(
  "SetInlineBotResultsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xbb12a419,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the SetInlineBotResultsRequest object.
    #  @param query_id The query ID.
    #  @param results The list of results.
    #  @param cache_time The cache time.
    #  @param gallery Optional gallery flag.
    #  @param private Optional private flag.
    #  @param next_offset Optional next offset.
    #  @param switch_pm Optional switch PM.
    #  @param switch_webview Optional switch webview.
    initialize = function(query_id, results, cache_time, gallery = NULL, private = NULL, next_offset = NULL, switch_pm = NULL, switch_webview = NULL) {
      self$query_id <- query_id
      self$results <- results
      self$cache_time <- cache_time
      self$gallery <- gallery
      self$private <- private
      self$next_offset <- next_offset
      self$switch_pm <- switch_pm
      self$switch_webview <- switch_webview
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetInlineBotResultsRequest",
        query_id = self$query_id,
        results = if (is.null(self$results)) list() else lapply(self$results, function(x) if (inherits(x, "TLObject")) x$to_dict() else x),
        cache_time = self$cache_time,
        gallery = self$gallery,
        private = self$private,
        next_offset = self$next_offset,
        switch_pm = if (inherits(self$switch_pm, "TLObject")) self$switch_pm$to_dict() else self$switch_pm,
        switch_webview = if (inherits(self$switch_webview, "TLObject")) self$switch_webview$to_dict() else self$switch_webview
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$gallery) && self$gallery != FALSE) flags <- bitwOr(flags, 1L)
      if (!is.null(self$private) && self$private != FALSE) flags <- bitwOr(flags, 2L)
      if (!is.null(self$next_offset) && self$next_offset != FALSE) flags <- bitwOr(flags, 4L)
      if (!is.null(self$switch_pm) && self$switch_pm != FALSE) flags <- bitwOr(flags, 8L)
      if (!is.null(self$switch_webview) && self$switch_webview != FALSE) flags <- bitwOr(flags, 16L)
      c(
        as.raw(c(0x19, 0xa4, 0x12, 0xbb)),
        struct_pack("<I", flags),
        struct_pack("<q", self$query_id),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)),
        struct_pack("<i", length(self$results)),
        do.call(c, lapply(self$results, function(x) x$bytes())),
        struct_pack("<i", self$cache_time),
        if (!is.null(self$next_offset) && self$next_offset != FALSE) self$serialize_bytes(self$next_offset) else raw(),
        if (!is.null(self$switch_pm) && self$switch_pm != FALSE) self$switch_pm$bytes() else raw(),
        if (!is.null(self$switch_webview) && self$switch_webview != FALSE) self$switch_webview$bytes() else raw()
      )
    }
  )
)

# @title from_reader
# @name SetInlineBotResultsRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SetInlineBotResultsRequest.
SetInlineBotResultsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  gallery <- bitwAnd(flags, 1L) != 0
  private <- bitwAnd(flags, 2L) != 0
  query_id <- reader$read_long()
  reader$read_int()
  results <- list()
  for (i in 1:reader$read_int()) {
    results <- c(results, reader$tgread_object())
  }
  cache_time <- reader$read_int()
  next_offset <- if (bitwAnd(flags, 4L) != 0) reader$tgread_string() else NULL
  switch_pm <- if (bitwAnd(flags, 8L) != 0) reader$tgread_object() else NULL
  switch_webview <- if (bitwAnd(flags, 16L) != 0) reader$tgread_object() else NULL
  SetInlineBotResultsRequest$new(query_id = query_id, results = results, cache_time = cache_time, gallery = gallery, private = private, next_offset = next_offset, switch_pm = switch_pm, switch_webview = switch_webview)
}

#  @title SetInlineGameScoreRequest
#  @description Represents a request to set inline game score. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SetInlineGameScoreRequest <- R6::R6Class(
  "SetInlineGameScoreRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x15ad9f64,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the SetInlineGameScoreRequest object.
    #  @param id The input bot inline message ID.
    #  @param user_id The input user.
    #  @param score The score.
    #  @param edit_message Optional edit message flag.
    #  @param force Optional force flag.
    initialize = function(id, user_id, score, edit_message = NULL, force = NULL) {
      self$id <- id
      self$user_id <- user_id
      self$score <- score
      self$edit_message <- edit_message
      self$force <- force
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$user_id <- utils$get_input_user(client$get_input_entity(self$user_id))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetInlineGameScoreRequest",
        id = if (inherits(self$id, "TLObject")) self$id$to_dict() else self$id,
        user_id = if (inherits(self$user_id, "TLObject")) self$user_id$to_dict() else self$user_id,
        score = self$score,
        edit_message = self$edit_message,
        force = self$force
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$edit_message) && self$edit_message != FALSE) flags <- bitwOr(flags, 1L)
      if (!is.null(self$force) && self$force != FALSE) flags <- bitwOr(flags, 2L)
      c(
        as.raw(c(0x64, 0x9f, 0xad, 0x15)),
        struct_pack("<I", flags),
        self$id$bytes(),
        self$user_id$bytes(),
        struct_pack("<i", self$score)
      )
    }
  )
)

# @title from_reader
# @name SetInlineGameScoreRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SetInlineGameScoreRequest.
SetInlineGameScoreRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  edit_message <- bitwAnd(flags, 1L) != 0
  force <- bitwAnd(flags, 2L) != 0
  id <- reader$tgread_object()
  user_id <- reader$tgread_object()
  score <- reader$read_int()
  SetInlineGameScoreRequest$new(id = id, user_id = user_id, score = score, edit_message = edit_message, force = force)
}

#  @title SetTypingRequest
#  @description Represents a request to set typing. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
SetTypingRequest <- R6::R6Class(
  "SetTypingRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x58943ee2,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the SetTypingRequest object.
    #  @param peer The input peer.
    #  @param action The send message action.
    #  @param top_msg_id Optional top message ID.
    initialize = function(peer, action, top_msg_id = NULL) {
      self$peer <- peer
      self$action <- action
      self$top_msg_id <- top_msg_id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "SetTypingRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        action = if (inherits(self$action, "TLObject")) self$action$to_dict() else self$action,
        top_msg_id = self$top_msg_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$top_msg_id) && self$top_msg_id != FALSE) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0xe2, 0x3e, 0x94, 0x58)),
        struct_pack("<I", flags),
        self$peer$bytes(),
        if (!is.null(self$top_msg_id) && self$top_msg_id != FALSE) struct_pack("<i", self$top_msg_id) else raw(),
        self$action$bytes()
      )
    }
  )
)

# @title from_reader
# @name SetTypingRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of SetTypingRequest.
SetTypingRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  peer <- reader$tgread_object()
  top_msg_id <- if (bitwAnd(flags, 1L) != 0) reader$read_int() else NULL
  action <- reader$tgread_object()
  SetTypingRequest$new(peer = peer, action = action, top_msg_id = top_msg_id)
}


#  @title StartBotRequest
#  @description Represents a request to start a bot. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
StartBotRequest <- R6::R6Class(
  "StartBotRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xe6df7378,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the StartBotRequest object.
    #  @param bot The input user (bot).
    #  @param peer The input peer.
    #  @param start_param The start parameter.
    #  @param random_id Optional random ID, defaults to a generated value.
    initialize = function(bot, peer, start_param, random_id = NULL) {
      self$bot <- bot
      self$peer <- peer
      self$start_param <- start_param
      if (is.null(random_id)) {
        self$random_id <- int.from_bytes(os.urandom(8), "big", signed = TRUE)
      } else {
        self$random_id <- random_id
      }
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$bot <- utils$get_input_user(client$get_input_entity(self$bot))
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "StartBotRequest",
        bot = if (inherits(self$bot, "TLObject")) self$bot$to_dict() else self$bot,
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        start_param = self$start_param,
        random_id = self$random_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x78, 0x73, 0xdf, 0xe6)),
        self$bot$bytes(),
        self$peer$bytes(),
        struct.pack("<q", self$random_id),
        self$serialize_bytes(self$start_param)
      )
    }
  )
)

# @title from_reader
# @name StartBotRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of StartBotRequest.
StartBotRequest$from_reader <- function(reader) {
  bot <- reader$tgread_object()
  peer <- reader$tgread_object()
  random_id <- reader$read_long()
  start_param <- reader$tgread_string()
  StartBotRequest$new(bot = bot, peer = peer, start_param = start_param, random_id = random_id)
}

#  @title StartHistoryImportRequest
#  @description Represents a request to start history import. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
StartHistoryImportRequest <- R6::R6Class(
  "StartHistoryImportRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xb43df344,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the StartHistoryImportRequest object.
    #  @param peer The input peer.
    #  @param import_id The import ID.
    initialize = function(peer, import_id) {
      self$peer <- peer
      self$import_id <- import_id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "StartHistoryImportRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        import_id = self$import_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x44, 0xf3, 0x3d, 0xb4)),
        self$peer$bytes(),
        struct.pack("<q", self$import_id)
      )
    }
  )
)

# @title from_reader
# @name StartHistoryImportRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of StartHistoryImportRequest.
StartHistoryImportRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  import_id <- reader$read_long()
  StartHistoryImportRequest$new(peer = peer, import_id = import_id)
}

#  @title ToggleBotInAttachMenuRequest
#  @description Represents a request to toggle bot in attach menu. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ToggleBotInAttachMenuRequest <- R6::R6Class(
  "ToggleBotInAttachMenuRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x69f59d69,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ToggleBotInAttachMenuRequest object.
    #  @param bot The input user (bot).
    #  @param enabled Whether the bot is enabled.
    #  @param write_allowed Optional write allowed flag.
    initialize = function(bot, enabled, write_allowed = NULL) {
      self$bot <- bot
      self$enabled <- enabled
      self$write_allowed <- write_allowed
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$bot <- utils$get_input_user(client$get_input_entity(self$bot))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ToggleBotInAttachMenuRequest",
        bot = if (inherits(self$bot, "TLObject")) self$bot$to_dict() else self$bot,
        enabled = self$enabled,
        write_allowed = self$write_allowed
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$write_allowed) && self$write_allowed != FALSE) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x69, 0x9d, 0xf5, 0x69)),
        struct.pack("<I", flags),
        self$bot$bytes(),
        if (self$enabled) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  )
)

# @title from_reader
# @name ToggleBotInAttachMenuRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ToggleBotInAttachMenuRequest.
ToggleBotInAttachMenuRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  write_allowed <- bitwAnd(flags, 1L) != 0
  bot <- reader$tgread_object()
  enabled <- reader$tgread_bool()
  ToggleBotInAttachMenuRequest$new(bot = bot, enabled = enabled, write_allowed = write_allowed)
}


#  @title ToggleDialogFilterTagsRequest
#  @description Represents a request to toggle dialog filter tags. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ToggleDialogFilterTagsRequest <- R6::R6Class(
  "ToggleDialogFilterTagsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xfd2dda49,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ToggleDialogFilterTagsRequest object.
    #  @param enabled Whether the dialog filter tags are enabled.
    initialize = function(enabled) {
      self$enabled <- enabled
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ToggleDialogFilterTagsRequest",
        enabled = self$enabled
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x49, 0xda, 0x2d, 0xfd)),
        if (self$enabled) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  )
)

# @title from_reader
# @name ToggleDialogFilterTagsRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ToggleDialogFilterTagsRequest.
ToggleDialogFilterTagsRequest$from_reader <- function(reader) {
  enabled <- reader$tgread_bool()
  ToggleDialogFilterTagsRequest$new(enabled = enabled)
}

#  @title ToggleDialogPinRequest
#  @description Represents a request to toggle dialog pin. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ToggleDialogPinRequest <- R6::R6Class(
  "ToggleDialogPinRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xa731e257,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ToggleDialogPinRequest object.
    #  @param peer The input dialog peer.
    #  @param pinned Optional pinned flag.
    initialize = function(peer, pinned = NULL) {
      self$peer <- peer
      self$pinned <- pinned
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- client$get_input_dialog(self$peer)
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ToggleDialogPinRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        pinned = self$pinned
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$pinned) && self$pinned != FALSE) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x57, 0xe2, 0x31, 0xa7)),
        struct_pack("<I", flags),
        self$peer$bytes()
      )
    }
  )
)

# @title from_reader
# @name ToggleDialogPinRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ToggleDialogPinRequest.
ToggleDialogPinRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  pinned <- bitwAnd(flags, 1L) != 0
  peer <- reader$tgread_object()
  ToggleDialogPinRequest$new(peer = peer, pinned = pinned)
}

#  @title ToggleNoForwardsRequest
#  @description Represents a request to toggle no forwards. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ToggleNoForwardsRequest <- R6::R6Class(
  "ToggleNoForwardsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xb11eafa2,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the ToggleNoForwardsRequest object.
    #  @param peer The input peer.
    #  @param enabled Whether no forwards is enabled.
    initialize = function(peer, enabled) {
      self$peer <- peer
      self$enabled <- enabled
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ToggleNoForwardsRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        enabled = self$enabled
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xa2, 0xaf, 0x1e, 0xb1)),
        self$peer$bytes(),
        if (self$enabled) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    }
  )
)

# @title from_reader
# @name ToggleNoForwardsRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ToggleNoForwardsRequest.
ToggleNoForwardsRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  enabled <- reader$tgread_bool()
  ToggleNoForwardsRequest$new(peer = peer, enabled = enabled)
}


#  @title TogglePaidReactionPrivacyRequest
#  @description Represents a request to toggle paid reaction privacy. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
TogglePaidReactionPrivacyRequest <- R6::R6Class(
  "TogglePaidReactionPrivacyRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x435885b5,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the TogglePaidReactionPrivacyRequest object.
    #  @param peer The input peer.
    #  @param msg_id The message ID.
    #  @param private The paid reaction privacy.
    initialize = function(peer, msg_id, private) {
      self$peer <- peer
      self$msg_id <- msg_id
      self$private <- private
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "TogglePaidReactionPrivacyRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        msg_id = self$msg_id,
        private = if (inherits(self$private, "TLObject")) self$private$to_dict() else self$private
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xb5, 0x85, 0x58, 0x43)),
        self$peer$bytes(),
        struct_pack("<i", self$msg_id),
        self$private$bytes()
      )
    }
  )
)

# @title from_reader
# @name TogglePaidReactionPrivacyRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of TogglePaidReactionPrivacyRequest.
TogglePaidReactionPrivacyRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  msg_id <- reader$read_int()
  private <- reader$tgread_object()
  TogglePaidReactionPrivacyRequest$new(peer = peer, msg_id = msg_id, private = private)
}

#  @title TogglePeerTranslationsRequest
#  @description Represents a request to toggle peer translations. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
TogglePeerTranslationsRequest <- R6::R6Class(
  "TogglePeerTranslationsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xe47cb579,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the TogglePeerTranslationsRequest object.
    #  @param peer The input peer.
    #  @param disabled Optional disabled flag.
    initialize = function(peer, disabled = NULL) {
      self$peer <- peer
      self$disabled <- disabled
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "TogglePeerTranslationsRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        disabled = self$disabled
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$disabled) && self$disabled != FALSE) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x79, 0xb5, 0x7c, 0xe4)),
        struct_pack("<I", flags),
        self$peer$bytes()
      )
    }
  )
)

# @title from_reader
# @name TogglePeerTranslationsRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of TogglePeerTranslationsRequest.
TogglePeerTranslationsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  disabled <- bitwAnd(flags, 1L) != 0
  peer <- reader$tgread_object()
  TogglePeerTranslationsRequest$new(peer = peer, disabled = disabled)
}

#  @title ToggleSavedDialogPinRequest
#  @description Represents a request to toggle saved dialog pin. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ToggleSavedDialogPinRequest <- R6::R6Class(
  "ToggleSavedDialogPinRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xac81bbde,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ToggleSavedDialogPinRequest object.
    #  @param peer The input dialog peer.
    #  @param pinned Optional pinned flag.
    initialize = function(peer, pinned = NULL) {
      self$peer <- peer
      self$pinned <- pinned
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- client$get_input_dialog(self$peer)
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ToggleSavedDialogPinRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        pinned = self$pinned
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$pinned) && self$pinned != FALSE) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0xde, 0xbb, 0x81, 0xac)),
        struct_pack("<I", flags),
        self$peer$bytes()
      )
    }
  )
)

# @title from_reader
# @name ToggleSavedDialogPinRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ToggleSavedDialogPinRequest.
ToggleSavedDialogPinRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  pinned <- bitwAnd(flags, 1L) != 0
  peer <- reader$tgread_object()
  ToggleSavedDialogPinRequest$new(peer = peer, pinned = pinned)
}


#  @title ToggleStickerSetsRequest
#  @description Represents a request to toggle sticker sets. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ToggleStickerSetsRequest <- R6::R6Class(
  "ToggleStickerSetsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xb5052fea,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ToggleStickerSetsRequest object.
    #  @param stickersets The list of input sticker sets.
    #  @param uninstall Optional uninstall flag.
    #  @param archive Optional archive flag.
    #  @param unarchive Optional unarchive flag.
    initialize = function(stickersets, uninstall = NULL, archive = NULL, unarchive = NULL) {
      self$stickersets <- stickersets
      self$uninstall <- uninstall
      self$archive <- archive
      self$unarchive <- unarchive
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ToggleStickerSetsRequest",
        stickersets = if (is.null(self$stickersets)) list() else lapply(self$stickersets, function(x) if (inherits(x, "TLObject")) x$to_dict() else x),
        uninstall = self$uninstall,
        archive = self$archive,
        unarchive = self$unarchive
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$uninstall) && self$uninstall != FALSE) flags <- bitwOr(flags, 1L)
      if (!is.null(self$archive) && self$archive != FALSE) flags <- bitwOr(flags, 2L)
      if (!is.null(self$unarchive) && self$unarchive != FALSE) flags <- bitwOr(flags, 4L)
      c(
        as.raw(c(0xea, 0x2f, 0x05, 0xb5)),
        struct_pack("<I", flags),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)),
        struct_pack("<i", length(self$stickersets)),
        do.call(c, lapply(self$stickersets, function(x) x$bytes()))
      )
    }
  )
)

# @title from_reader
# @name ToggleStickerSetsRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ToggleStickerSetsRequest.
ToggleStickerSetsRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  uninstall <- bitwAnd(flags, 1L) != 0
  archive <- bitwAnd(flags, 2L) != 0
  unarchive <- bitwAnd(flags, 4L) != 0
  reader$read_int()
  stickersets <- list()
  for (i in 1:reader$read_int()) {
    stickersets <- c(stickersets, reader$tgread_object())
  }
  ToggleStickerSetsRequest$new(stickersets = stickersets, uninstall = uninstall, archive = archive, unarchive = unarchive)
}

#  @title ToggleSuggestedPostApprovalRequest
#  @description Represents a request to toggle suggested post approval. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ToggleSuggestedPostApprovalRequest <- R6::R6Class(
  "ToggleSuggestedPostApprovalRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x8107455c,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the ToggleSuggestedPostApprovalRequest object.
    #  @param peer The input peer.
    #  @param msg_id The message ID.
    #  @param reject Optional reject flag.
    #  @param schedule_date Optional schedule date.
    #  @param reject_comment Optional reject comment.
    initialize = function(peer, msg_id, reject = NULL, schedule_date = NULL, reject_comment = NULL) {
      self$peer <- peer
      self$msg_id <- msg_id
      self$reject <- reject
      self$schedule_date <- schedule_date
      self$reject_comment <- reject_comment
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ToggleSuggestedPostApprovalRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        msg_id = self$msg_id,
        reject = self$reject,
        schedule_date = self$schedule_date,
        reject_comment = self$reject_comment
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$reject) && self$reject != FALSE) flags <- bitwOr(flags, 2L)
      if (!is.null(self$schedule_date) && self$schedule_date != FALSE) flags <- bitwOr(flags, 1L)
      if (!is.null(self$reject_comment) && self$reject_comment != FALSE) flags <- bitwOr(flags, 4L)
      c(
        as.raw(c(0x5c, 0x45, 0x07, 0x81)),
        struct_pack("<I", flags),
        self$peer$bytes(),
        struct_pack("<i", self$msg_id),
        if (!is.null(self$schedule_date) && self$schedule_date != FALSE) self$serialize_datetime(self$schedule_date) else raw(),
        if (!is.null(self$reject_comment) && self$reject_comment != FALSE) self$serialize_bytes(self$reject_comment) else raw()
      )
    }
  )
)

# @title from_reader
# @name ToggleSuggestedPostApprovalRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ToggleSuggestedPostApprovalRequest.
ToggleSuggestedPostApprovalRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  reject <- bitwAnd(flags, 2L) != 0
  peer <- reader$tgread_object()
  msg_id <- reader$read_int()
  schedule_date <- if (bitwAnd(flags, 1L) != 0) reader$tgread_date() else NULL
  reject_comment <- if (bitwAnd(flags, 4L) != 0) reader$tgread_string() else NULL
  ToggleSuggestedPostApprovalRequest$new(peer = peer, msg_id = msg_id, reject = reject, schedule_date = schedule_date, reject_comment = reject_comment)
}

#  @title ToggleTodoCompletedRequest
#  @description Represents a request to toggle todo completed status. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ToggleTodoCompletedRequest <- R6::R6Class(
  "ToggleTodoCompletedRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xd3e03124,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the ToggleTodoCompletedRequest object.
    #  @param peer The input peer.
    #  @param msg_id The message ID.
    #  @param completed The list of completed IDs.
    #  @param incompleted The list of incompleted IDs.
    initialize = function(peer, msg_id, completed, incompleted) {
      self$peer <- peer
      self$msg_id <- msg_id
      self$completed <- completed
      self$incompleted <- incompleted
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ToggleTodoCompletedRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        msg_id = self$msg_id,
        completed = if (is.null(self$completed)) list() else self$completed,
        incompleted = if (is.null(self$incompleted)) list() else self$incompleted
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x24, 0x31, 0xe0, 0xd3)),
        self$peer$bytes(),
        struct_pack("<i", self$msg_id),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)),
        struct_pack("<i", length(self$completed)),
        do.call(c, lapply(self$completed, function(x) struct_pack("<i", x))),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)),
        struct_pack("<i", length(self$incompleted)),
        do.call(c, lapply(self$incompleted, function(x) struct_pack("<i", x)))
      )
    }
  )
)

# @title from_reader
# @name ToggleTodoCompletedRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ToggleTodoCompletedRequest.
ToggleTodoCompletedRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  msg_id <- reader$read_int()
  reader$read_int()
  completed <- list()
  for (i in 1:reader$read_int()) {
    completed <- c(completed, reader$read_int())
  }
  reader$read_int()
  incompleted <- list()
  for (i in 1:reader$read_int()) {
    incompleted <- c(incompleted, reader$read_int())
  }
  ToggleTodoCompletedRequest$new(peer = peer, msg_id = msg_id, completed = completed, incompleted = incompleted)
}


#  @title TranscribeAudioRequest
#  @description Represents a request to transcribe audio. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
TranscribeAudioRequest <- R6::R6Class(
  "TranscribeAudioRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x269e9a49,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x21b24936,

    #  @description Initialize the TranscribeAudioRequest object.
    #  @param peer The input peer.
    #  @param msg_id The message ID.
    initialize = function(peer, msg_id) {
      self$peer <- peer
      self$msg_id <- msg_id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "TranscribeAudioRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        msg_id = self$msg_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x49, 0x9a, 0x9e, 0x26)),
        self$peer$bytes(),
        struct_pack("<i", self$msg_id)
      )
    }
  )
)

# @title from_reader
# @name TranscribeAudioRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of TranscribeAudioRequest.
TranscribeAudioRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  msg_id <- reader$read_int()
  TranscribeAudioRequest$new(peer = peer, msg_id = msg_id)
}

#  @title TranslateTextRequest
#  @description Represents a request to translate text. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
TranslateTextRequest <- R6::R6Class(
  "TranslateTextRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x63183030,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x24243e8,

    #  @description Initialize the TranslateTextRequest object.
    #  @param to_lang The target language.
    #  @param peer Optional input peer.
    #  @param id Optional list of IDs.
    #  @param text Optional list of text with entities.
    initialize = function(to_lang, peer = NULL, id = NULL, text = NULL) {
      self$to_lang <- to_lang
      self$peer <- peer
      self$id <- id
      self$text <- text
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      if (!is.null(self$peer)) {
        self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "TranslateTextRequest",
        to_lang = self$to_lang,
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        id = if (is.null(self$id)) list() else self$id,
        text = if (is.null(self$text)) list() else lapply(self$text, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      if (!((!is.null(self$peer) && self$peer != FALSE) && (!is.null(self$id) && self$id != FALSE)) &&
        ((is.null(self$peer) || self$peer == FALSE) && (is.null(self$id) || self$id == FALSE))) {
        stop("peer, id parameters must all be False-y (like NULL) or all be True-y")
      }
      flags <- 0L
      if (!is.null(self$peer) && self$peer != FALSE) flags <- bitwOr(flags, 1L)
      if (!is.null(self$id) && self$id != FALSE) flags <- bitwOr(flags, 1L)
      if (!is.null(self$text) && self$text != FALSE) flags <- bitwOr(flags, 2L)
      c(
        as.raw(c(0x30, 0x30, 0x18, 0x63)),
        struct_pack("<I", flags),
        if (!is.null(self$peer) && self$peer != FALSE) self$peer$bytes() else raw(),
        if (!is.null(self$id) && self$id != FALSE) c(as.raw(c(0x1c, 0xb5, 0xc4, 0x15)), struct_pack("<i", length(self$id)), do.call(c, lapply(self$id, function(x) struct_pack("<i", x)))) else raw(),
        if (!is.null(self$text) && self$text != FALSE) c(as.raw(c(0x1c, 0xb5, 0xc4, 0x15)), struct_pack("<i", length(self$text)), do.call(c, lapply(self$text, function(x) x$bytes()))) else raw(),
        self$serialize_bytes(self$to_lang)
      )
    }
  )
)

# @title from_reader
# @name TranslateTextRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of TranslateTextRequest.
TranslateTextRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  if (bitwAnd(flags, 1L) != 0) {
    peer <- reader$tgread_object()
  } else {
    peer <- NULL
  }
  if (bitwAnd(flags, 1L) != 0) {
    reader$read_int()
    id <- list()
    for (i in 1:reader$read_int()) {
      id <- c(id, reader$read_int())
    }
  } else {
    id <- NULL
  }
  if (bitwAnd(flags, 2L) != 0) {
    reader$read_int()
    text <- list()
    for (i in 1:reader$read_int()) {
      text <- c(text, reader$tgread_object())
    }
  } else {
    text <- NULL
  }
  to_lang <- reader$tgread_string()
  TranslateTextRequest$new(to_lang = to_lang, peer = peer, id = id, text = text)
}

#  @title UninstallStickerSetRequest
#  @description Represents a request to uninstall a sticker set. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
UninstallStickerSetRequest <- R6::R6Class(
  "UninstallStickerSetRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xf96e55de,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the UninstallStickerSetRequest object.
    #  @param stickerset The input sticker set.
    initialize = function(stickerset) {
      self$stickerset <- stickerset
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "UninstallStickerSetRequest",
        stickerset = if (inherits(self$stickerset, "TLObject")) self$stickerset$to_dict() else self$stickerset
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xde, 0x55, 0x6e, 0xf9)),
        self$stickerset$bytes()
      )
    }
  )
)

# @title from_reader
# @name UninstallStickerSetRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of UninstallStickerSetRequest.
UninstallStickerSetRequest$from_reader <- function(reader) {
  stickerset <- reader$tgread_object()
  UninstallStickerSetRequest$new(stickerset = stickerset)
}


#  @title UnpinAllMessagesRequest
#  @description Represents a request to unpin all messages. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
UnpinAllMessagesRequest <- R6::R6Class(
  "UnpinAllMessagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x62dd747,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x2c49c116,

    #  @description Initialize the UnpinAllMessagesRequest object.
    #  @param peer The input peer.
    #  @param top_msg_id Optional top message ID.
    #  @param saved_peer_id Optional saved peer ID.
    initialize = function(peer, top_msg_id = NULL, saved_peer_id = NULL) {
      self$peer <- peer
      self$top_msg_id <- top_msg_id
      self$saved_peer_id <- saved_peer_id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      if (!is.null(self$saved_peer_id)) {
        self$saved_peer_id <- utils$get_input_peer(client$get_input_entity(self$saved_peer_id))
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "UnpinAllMessagesRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        top_msg_id = self$top_msg_id,
        saved_peer_id = if (inherits(self$saved_peer_id, "TLObject")) self$saved_peer_id$to_dict() else self$saved_peer_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$top_msg_id) && self$top_msg_id != FALSE) flags <- bitwOr(flags, 1L)
      if (!is.null(self$saved_peer_id) && self$saved_peer_id != FALSE) flags <- bitwOr(flags, 2L)
      c(
        as.raw(c(0x47, 0xd7, 0x2d, 0x06)),
        struct_pack("<I", flags),
        self$peer$bytes(),
        if (!is.null(self$top_msg_id) && self$top_msg_id != FALSE) struct_pack("<i", self$top_msg_id) else raw(),
        if (!is.null(self$saved_peer_id) && self$saved_peer_id != FALSE) self$saved_peer_id$bytes() else raw()
      )
    }
  )
)

# @title from_reader
# @name UnpinAllMessagesRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of UnpinAllMessagesRequest.
UnpinAllMessagesRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  peer <- reader$tgread_object()
  top_msg_id <- if (bitwAnd(flags, 1L) != 0) reader$read_int() else NULL
  saved_peer_id <- if (bitwAnd(flags, 2L) != 0) reader$tgread_object() else NULL
  UnpinAllMessagesRequest$new(peer = peer, top_msg_id = top_msg_id, saved_peer_id = saved_peer_id)
}

#  @title UpdateDialogFilterRequest
#  @description Represents a request to update a dialog filter. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
UpdateDialogFilterRequest <- R6::R6Class(
  "UpdateDialogFilterRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x1ad4a04a,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the UpdateDialogFilterRequest object.
    #  @param id The filter ID.
    #  @param filter Optional dialog filter.
    initialize = function(id, filter = NULL) {
      self$id <- id
      self$filter <- filter
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "UpdateDialogFilterRequest",
        id = self$id,
        filter = if (inherits(self$filter, "TLObject")) self$filter$to_dict() else self$filter
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$filter) && self$filter != FALSE) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x4a, 0xa0, 0xd4, 0x1a)),
        struct_pack("<I", flags),
        struct_pack("<i", self$id),
        if (!is.null(self$filter) && self$filter != FALSE) self$filter$bytes() else raw()
      )
    }
  )
)

# @title from_reader
# @name UpdateDialogFilterRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of UpdateDialogFilterRequest.
UpdateDialogFilterRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  id <- reader$read_int()
  filter <- if (bitwAnd(flags, 1L) != 0) reader$tgread_object() else NULL
  UpdateDialogFilterRequest$new(id = id, filter = filter)
}

#  @title UpdateDialogFiltersOrderRequest
#  @description Represents a request to update the order of dialog filters. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
UpdateDialogFiltersOrderRequest <- R6::R6Class(
  "UpdateDialogFiltersOrderRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xc563c1e4,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the UpdateDialogFiltersOrderRequest object.
    #  @param order The list of order IDs.
    initialize = function(order) {
      self$order <- order
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "UpdateDialogFiltersOrderRequest",
        order = if (is.null(self$order)) list() else self$order
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xe4, 0xc1, 0x63, 0xc5)),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)),
        struct_pack("<i", length(self$order)),
        do.call(c, lapply(self$order, function(x) struct_pack("<i", x)))
      )
    }
  )
)

# @title from_reader
# @name UpdateDialogFiltersOrderRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of UpdateDialogFiltersOrderRequest.
UpdateDialogFiltersOrderRequest$from_reader <- function(reader) {
  reader$read_int()
  order <- list()
  for (i in 1:reader$read_int()) {
    order <- c(order, reader$read_int())
  }
  UpdateDialogFiltersOrderRequest$new(order = order)
}


#  @title UpdatePinnedMessageRequest
#  @description Represents a request to update a pinned message. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
UpdatePinnedMessageRequest <- R6::R6Class(
  "UpdatePinnedMessageRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0xd2aaf7ec,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the UpdatePinnedMessageRequest object.
    #  @param peer The input peer.
    #  @param id The message ID.
    #  @param silent Optional silent flag.
    #  @param unpin Optional unpin flag.
    #  @param pm_oneside Optional pm_oneside flag.
    initialize = function(peer, id, silent = NULL, unpin = NULL, pm_oneside = NULL) {
      self$peer <- peer
      self$id <- id
      self$silent <- silent
      self$unpin <- unpin
      self$pm_oneside <- pm_oneside
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "UpdatePinnedMessageRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        id = self$id,
        silent = self$silent,
        unpin = self$unpin,
        pm_oneside = self$pm_oneside
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$silent) && self$silent != FALSE) flags <- bitwOr(flags, 1L)
      if (!is.null(self$unpin) && self$unpin != FALSE) flags <- bitwOr(flags, 2L)
      if (!is.null(self$pm_oneside) && self$pm_oneside != FALSE) flags <- bitwOr(flags, 4L)
      c(
        as.raw(c(0xec, 0xf7, 0xaa, 0xd2)),
        struct_pack("<I", flags),
        self$peer$bytes(),
        struct_pack("<i", self$id)
      )
    }
  )
)

# @title from_reader
# @name UpdatePinnedMessageRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of UpdatePinnedMessageRequest.
UpdatePinnedMessageRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  silent <- bitwAnd(flags, 1L) != 0
  unpin <- bitwAnd(flags, 2L) != 0
  pm_oneside <- bitwAnd(flags, 4L) != 0
  peer <- reader$tgread_object()
  id <- reader$read_int()
  UpdatePinnedMessageRequest$new(peer = peer, id = id, silent = silent, unpin = unpin, pm_oneside = pm_oneside)
}

#  @title UpdateSavedReactionTagRequest
#  @description Represents a request to update a saved reaction tag. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
UpdateSavedReactionTagRequest <- R6::R6Class(
  "UpdateSavedReactionTagRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x60297dec,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the UpdateSavedReactionTagRequest object.
    #  @param reaction The reaction.
    #  @param title Optional title.
    initialize = function(reaction, title = NULL) {
      self$reaction <- reaction
      self$title <- title
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "UpdateSavedReactionTagRequest",
        reaction = if (inherits(self$reaction, "TLObject")) self$reaction$to_dict() else self$reaction,
        title = self$title
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$title) && self$title != FALSE) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0xec, 0x29, 0x60)),
        struct_pack("<I", flags),
        self$reaction$bytes(),
        if (!is.null(self$title) && self$title != FALSE) self$serialize_bytes(self$title) else raw()
      )
    }
  )
)

# @title from_reader
# @name UpdateSavedReactionTagRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of UpdateSavedReactionTagRequest.
UpdateSavedReactionTagRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  reaction <- reader$tgread_object()
  title <- if (bitwAnd(flags, 1L) != 0) reader$tgread_string() else NULL
  UpdateSavedReactionTagRequest$new(reaction = reaction, title = title)
}

#  @title UploadEncryptedFileRequest
#  @description Represents a request to upload an encrypted file. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
UploadEncryptedFileRequest <- R6::R6Class(
  "UploadEncryptedFileRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x5057c497,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x842a67c0,

    #  @description Initialize the UploadEncryptedFileRequest object.
    #  @param peer The input encrypted chat peer.
    #  @param file The input encrypted file.
    initialize = function(peer, file) {
      self$peer <- peer
      self$file <- file
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "UploadEncryptedFileRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        file = if (inherits(self$file, "TLObject")) self$file$to_dict() else self$file
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x97, 0xc4, 0x57, 0x50)),
        self$peer$bytes(),
        self$file$bytes()
      )
    }
  )
)

# @title from_reader
# @name UploadEncryptedFileRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of UploadEncryptedFileRequest.
UploadEncryptedFileRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  file <- reader$tgread_object()
  UploadEncryptedFileRequest$new(peer = peer, file = file)
}


#  @title UploadImportedMediaRequest
#  @description Represents a request to upload imported media. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
UploadImportedMediaRequest <- R6::R6Class(
  "UploadImportedMediaRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x2a862092,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x476cbe32,

    #  @description Initialize the UploadImportedMediaRequest object.
    #  @param peer The input peer.
    #  @param import_id The import ID.
    #  @param file_name The file name.
    #  @param media The input media.
    initialize = function(peer, import_id, file_name, media) {
      self$peer <- peer
      self$import_id <- import_id
      self$file_name <- file_name
      self$media <- media
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      self$media <- utils$get_input_media(self$media)
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "UploadImportedMediaRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        import_id = self$import_id,
        file_name = self$file_name,
        media = if (inherits(self$media, "TLObject")) self$media$to_dict() else self$media
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x92, 0x20, 0x86, 0x2a)),
        self$peer$bytes(),
        struct_pack("<q", self$import_id),
        self$serialize_bytes(self$file_name),
        self$media$bytes()
      )
    }
  )
)

# @title from_reader
# @name UploadImportedMediaRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of UploadImportedMediaRequest.
UploadImportedMediaRequest$from_reader <- function(reader) {
  peer <- reader$tgread_object()
  import_id <- reader$read_long()
  file_name <- reader$tgread_string()
  media <- reader$tgread_object()
  UploadImportedMediaRequest$new(peer = peer, import_id = import_id, file_name = file_name, media = media)
}

#  @title UploadMediaRequest
#  @description Represents a request to upload media. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
UploadMediaRequest <- R6::R6Class(
  "UploadMediaRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x14967978,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x476cbe32,

    #  @description Initialize the UploadMediaRequest object.
    #  @param peer The input peer.
    #  @param media The input media.
    #  @param business_connection_id Optional business connection ID.
    initialize = function(peer, media, business_connection_id = NULL) {
      self$peer <- peer
      self$media <- media
      self$business_connection_id <- business_connection_id
    },

    #  @description Resolve the request using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
      self$media <- utils$get_input_media(self$media)
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "UploadMediaRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        media = if (inherits(self$media, "TLObject")) self$media$to_dict() else self$media,
        business_connection_id = self$business_connection_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- 0L
      if (!is.null(self$business_connection_id) && self$business_connection_id != FALSE) flags <- bitwOr(flags, 1L)
      c(
        as.raw(c(0x78, 0x96, 0x14)),
        struct_pack("<I", flags),
        if (!is.null(self$business_connection_id) && self$business_connection_id != FALSE) self$serialize_bytes(self$business_connection_id) else raw(),
        self$peer$bytes(),
        self$media$bytes()
      )
    }
  )
)

# @title from_reader
# @name UploadMediaRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of UploadMediaRequest.
UploadMediaRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  business_connection_id <- if (bitwAnd(flags, 1L) != 0) reader$tgread_string() else NULL
  peer <- reader$tgread_object()
  media <- reader$tgread_object()
  UploadMediaRequest$new(peer = peer, media = media, business_connection_id = business_connection_id)
}

#  @title ViewSponsoredMessageRequest
#  @description Represents a request to view a sponsored message. This class inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ViewSponsoredMessageRequest <- R6::R6Class(
  "ViewSponsoredMessageRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID.
    CONSTRUCTOR_ID = 0x269e3643,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ViewSponsoredMessageRequest object.
    #  @param random_id Optional random ID, defaults to a generated value.
    initialize = function(random_id = NULL) {
      if (is.null(random_id)) {
        self$random_id <- int_to_bytes(sample(.Machine$integer.max, 1), 4, "big")
      } else {
        self$random_id <- random_id
      }
    },

    #  @description Convert the object to a dictionary.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        "_" = "ViewSponsoredMessageRequest",
        random_id = self$random_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x43, 0x36, 0x9e, 0x26)),
        self$serialize_bytes(self$random_id)
      )
    }
  )
)

# @title from_reader
# @name ViewSponsoredMessageRequest_from_reader
# @description Class method to create an instance from a reader.
# @param reader The reader object.
# @return An instance of ViewSponsoredMessageRequest.
ViewSponsoredMessageRequest$from_reader <- function(reader) {
  random_id <- reader$tgread_bytes()
  ViewSponsoredMessageRequest$new(random_id = random_id)
}
