#  @title AcceptAuthorizationRequest
#  @description R6 class representing an AcceptAuthorizationRequest.
#  @details This class handles accepting authorization for a bot with specified bot ID, scope, public key, value hashes, and credentials.
#  @export
#  @noRd
#  @noRd
AcceptAuthorizationRequest <- R6::R6Class(
  "AcceptAuthorizationRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x73, 0x4c, 0xed, 0xf3)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xac, 0x99, 0xb3, 0xf5)),

    #  @description Initialize the AcceptAuthorizationRequest.
    #  @param botId The bot ID as an integer.
    #  @param scope The scope string.
    #  @param publicKey The public key string.
    #  @param valueHashes List of secure value hashes.
    #  @param credentials The secure credentials encrypted.
    initialize = function(botId, scope, publicKey, valueHashes, credentials) {
      self$botId <- botId
      self$scope <- scope
      self$publicKey <- publicKey
      self$valueHashes <- valueHashes
      self$credentials <- credentials
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "AcceptAuthorizationRequest",
        "bot_id" = self$botId,
        "scope" = self$scope,
        "public_key" = self$publicKey,
        "value_hashes" = if (is.null(self$valueHashes)) list() else lapply(self$valueHashes, function(x) if (inherits(x, "TLObject")) x$toDict() else x),
        "credentials" = if (inherits(self$credentials, "TLObject")) self$credentials$toDict() else self$credentials
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x73, 0x4c, 0xed, 0xf3)),
        writeBin(as.integer(self$botId), raw(), size = 8, endian = "little"),
        self$serialize_bytes(self$scope),
        self$serialize_bytes(self$publicKey),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        writeBin(length(self$valueHashes), raw(), size = 4, endian = "little"),
        do.call(c, lapply(self$valueHashes, function(x) x$bytes())),
        self$credentials$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of AcceptAuthorizationRequest.
    fromReader = function(reader) {
      botId <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      scope <- reader$tgreadString()
      publicKey <- reader$tgreadString()
      reader$readInt()
      valueHashes <- list()
      for (i in seq_len(reader$readInt())) {
        x <- reader$tgreadObject()
        valueHashes <- c(valueHashes, list(x))
      }
      credentials <- reader$tgreadObject()
      AcceptAuthorizationRequest$new(botId = botId, scope = scope, publicKey = publicKey, valueHashes = valueHashes, credentials = credentials)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title CancelPasswordEmailRequest
#  @description R6 class representing a CancelPasswordEmailRequest.
#  @details This class handles canceling a password email request.
#  @export
#  @noRd
#  @noRd
CancelPasswordEmailRequest <- R6::R6Class(
  "CancelPasswordEmailRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0xb6, 0xd5, 0xcb, 0xc1)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xac, 0x99, 0xb3, 0xf5)),

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "CancelPasswordEmailRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0xb6, 0xd5, 0xcb, 0xc1))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of CancelPasswordEmailRequest.
    fromReader = function(reader) {
      CancelPasswordEmailRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title ChangeAuthorizationSettingsRequest
#  @description R6 class representing a ChangeAuthorizationSettingsRequest.
#  @details This class handles changing authorization settings with hash and optional flags for confirmed, encrypted requests disabled, and call requests disabled.
#  @export
#  @noRd
#  @noRd
ChangeAuthorizationSettingsRequest <- R6::R6Class(
  "ChangeAuthorizationSettingsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x62, 0x84, 0xf4, 0x40)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xac, 0x99, 0xb3, 0xf5)),

    #  @description Initialize the ChangeAuthorizationSettingsRequest.
    #  @param hash The hash value.
    #  @param confirmed Optional boolean indicating if confirmed.
    #  @param encryptedRequestsDisabled Optional boolean indicating if encrypted requests are disabled.
    #  @param callRequestsDisabled Optional boolean indicating if call requests are disabled.
    initialize = function(hash, confirmed = NULL, encryptedRequestsDisabled = NULL, callRequestsDisabled = NULL) {
      self$hash <- hash
      self$confirmed <- confirmed
      self$encryptedRequestsDisabled <- encryptedRequestsDisabled
      self$callRequestsDisabled <- callRequestsDisabled
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ChangeAuthorizationSettingsRequest",
        "hash" = self$hash,
        "confirmed" = self$confirmed,
        "encrypted_requests_disabled" = self$encryptedRequestsDisabled,
        "call_requests_disabled" = self$callRequestsDisabled
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- (if (is.null(self$confirmed) || !self$confirmed) 0 else 8) |
        (if (is.null(self$encryptedRequestsDisabled) || !self$encryptedRequestsDisabled) 0 else 1) |
        (if (is.null(self$callRequestsDisabled) || !self$callRequestsDisabled) 0 else 2)
      c(
        as.raw(c(0x62, 0x84, 0xf4, 0x40)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        writeBin(as.integer(self$hash), raw(), size = 8, endian = "little"),
        if (!is.null(self$encryptedRequestsDisabled)) if (self$encryptedRequestsDisabled) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc)) else raw(),
        if (!is.null(self$callRequestsDisabled)) if (self$callRequestsDisabled) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc)) else raw()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ChangeAuthorizationSettingsRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      confirmed <- bitwAnd(flags, 8) != 0
      hash <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      encryptedRequestsDisabled <- if (bitwAnd(flags, 1) != 0) reader$tgreadBool() else NULL
      callRequestsDisabled <- if (bitwAnd(flags, 2) != 0) reader$tgreadBool() else NULL
      ChangeAuthorizationSettingsRequest$new(hash = hash, confirmed = confirmed, encryptedRequestsDisabled = encryptedRequestsDisabled, callRequestsDisabled = callRequestsDisabled)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title ChangePhoneRequest
#  @description R6 class representing a ChangePhoneRequest.
#  @details This class handles changing the phone number with code hash and code.
#  @export
#  @noRd
#  @noRd
ChangePhoneRequest <- R6::R6Class(
  "ChangePhoneRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0xdb, 0x2e, 0xc3, 0x70)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0x77, 0x79, 0xa1, 0x2d)),

    #  @description Initialize the ChangePhoneRequest.
    #  @param phoneNumber The phone number string.
    #  @param phoneCodeHash The phone code hash string.
    #  @param phoneCode The phone code string.
    initialize = function(phoneNumber, phoneCodeHash, phoneCode) {
      self$phoneNumber <- phoneNumber
      self$phoneCodeHash <- phoneCodeHash
      self$phoneCode <- phoneCode
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ChangePhoneRequest",
        phoneNumber = self$phoneNumber,
        phoneCodeHash = self$phoneCodeHash,
        phoneCode = self$phoneCode
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xdb, 0x2e, 0xc3, 0x70)),
        self$serialize_bytes(self$phoneNumber),
        self$serialize_bytes(self$phoneCodeHash),
        self$serialize_bytes(self$phoneCode)
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ChangePhoneRequest.
    fromReader = function(reader) {
      phoneNumber <- reader$tgreadString()
      phoneCodeHash <- reader$tgreadString()
      phoneCode <- reader$tgreadString()
      ChangePhoneRequest$new(phoneNumber = phoneNumber, phoneCodeHash = phoneCodeHash, phoneCode = phoneCode)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title ClearRecentEmojiStatusesRequest
#  @description R6 class representing a ClearRecentEmojiStatusesRequest.
#  @details This class handles clearing recent emoji statuses.
#  @export
#  @noRd
#  @noRd
ClearRecentEmojiStatusesRequest <- R6::R6Class(
  "ClearRecentEmojiStatusesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0xae, 0x1a, 0x20, 0x18)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xac, 0x99, 0xb3, 0xf5)),

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ClearRecentEmojiStatusesRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0xae, 0x1a, 0x20, 0x18))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ClearRecentEmojiStatusesRequest.
    fromReader = function(reader) {
      ClearRecentEmojiStatusesRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title ConfirmPasswordEmailRequest
#  @description R6 class representing a ConfirmPasswordEmailRequest.
#  @details This class handles confirming a password email with a code.
#  @export
#  @noRd
#  @noRd
ConfirmPasswordEmailRequest <- R6::R6Class(
  "ConfirmPasswordEmailRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x20, 0x19, 0xdf, 0x8f)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xac, 0x99, 0xb3, 0xf5)),

    #  @description Initialize the ConfirmPasswordEmailRequest.
    #  @param code The confirmation code string.
    initialize = function(code) {
      self$code <- code
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ConfirmPasswordEmailRequest",
        code = self$code
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x20, 0x19, 0xdf, 0x8f)),
        self$serialize_bytes(self$code)
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ConfirmPasswordEmailRequest.
    fromReader = function(reader) {
      code <- reader$tgreadString()
      ConfirmPasswordEmailRequest$new(code = code)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title ConfirmPhoneRequest
#  @description R6 class representing a ConfirmPhoneRequest.
#  @details This class handles confirming a phone with code hash and code.
#  @export
#  @noRd
#  @noRd
ConfirmPhoneRequest <- R6::R6Class(
  "ConfirmPhoneRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0xc3, 0x78, 0x21, 0x5f)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xac, 0x99, 0xb3, 0xf5)),

    #  @description Initialize the ConfirmPhoneRequest.
    #  @param phoneCodeHash The phone code hash string.
    #  @param phoneCode The phone code string.
    initialize = function(phoneCodeHash, phoneCode) {
      self$phoneCodeHash <- phoneCodeHash
      self$phoneCode <- phoneCode
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ConfirmPhoneRequest",
        phoneCodeHash = self$phoneCodeHash,
        phoneCode = self$phoneCode
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xc3, 0x78, 0x21, 0x5f)),
        self$serialize_bytes(self$phoneCodeHash),
        self$serialize_bytes(self$phoneCode)
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ConfirmPhoneRequest.
    fromReader = function(reader) {
      phoneCodeHash <- reader$tgreadString()
      phoneCode <- reader$tgreadString()
      ConfirmPhoneRequest$new(phoneCodeHash = phoneCodeHash, phoneCode = phoneCode)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title CreateBusinessChatLinkRequest
#  @description R6 class representing a CreateBusinessChatLinkRequest.
#  @details This class handles creating a business chat link.
#  @export
#  @noRd
#  @noRd
CreateBusinessChatLinkRequest <- R6::R6Class(
  "CreateBusinessChatLinkRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x8e, 0xe6, 0x51, 0x88)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0x8b, 0x4a, 0x0d, 0x3c)),

    #  @description Initialize the CreateBusinessChatLinkRequest.
    #  @param link The input business chat link.
    initialize = function(link) {
      self$link <- link
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "CreateBusinessChatLinkRequest",
        link = if (inherits(self$link, "TLObject")) self$link$toDict() else self$link
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x8e, 0xe6, 0x51, 0x88)),
        self$link$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of CreateBusinessChatLinkRequest.
    fromReader = function(reader) {
      link <- reader$tgreadObject()
      CreateBusinessChatLinkRequest$new(link = link)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title CreateThemeRequest
#  @description R6 class representing a CreateThemeRequest.
#  @details This class handles creating a theme with specified slug, title, optional document, and settings.
#  @export
#  @noRd
#  @noRd
CreateThemeRequest <- R6::R6Class(
  "CreateThemeRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x00, 0x44, 0x2e, 0x65)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0x0c, 0xc8, 0xb4, 0x56)),

    #  @description Initialize the CreateThemeRequest.
    #  @param slug The slug string.
    #  @param title The title string.
    #  @param document Optional input document.
    #  @param settings Optional list of input theme settings.
    initialize = function(slug, title, document = NULL, settings = NULL) {
      self$slug <- slug
      self$title <- title
      self$document <- document
      self$settings <- settings
    },

    #  @description Resolve the document using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      if (!is.null(self$document)) {
        self$document <- utils$getInputDocument(self$document)
      }
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "CreateThemeRequest",
        slug = self$slug,
        title = self$title,
        document = if (inherits(self$document, "TLObject")) self$document$toDict() else self$document,
        settings = if (is.null(self$settings)) list() else lapply(self$settings, function(x) if (inherits(x, "TLObject")) x$toDict() else x)
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- (if (is.null(self$document)) 0 else 4) | (if (is.null(self$settings)) 0 else 8)
      settingsBytes <- if (!is.null(self$settings)) {
        c(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), writeBin(length(self$settings), raw(), size = 4, endian = "little"), do.call(c, lapply(self$settings, function(x) x$bytes())))
      } else {
        raw()
      }
      c(
        as.raw(c(0x00, 0x44, 0x2e, 0x65)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        self$serialize_bytes(self$slug),
        self$serialize_bytes(self$title),
        if (!is.null(self$document)) self$document$bytes() else raw(),
        settingsBytes
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of CreateThemeRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      slug <- reader$tgreadString()
      title <- reader$tgreadString()
      document <- if (bitwAnd(flags, 4) != 0) reader$tgreadObject() else NULL
      settings <- if (bitwAnd(flags, 8) != 0) {
        reader$readInt()
        lapply(seq_len(reader$readInt()), function(i) reader$tgreadObject())
      } else {
        NULL
      }
      CreateThemeRequest$new(slug = slug, title = title, document = document, settings = settings)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title DeclinePasswordResetRequest
#  @description R6 class representing a DeclinePasswordResetRequest.
#  @details This class handles declining a password reset request.
#  @export
#  @noRd
#  @noRd
DeclinePasswordResetRequest <- R6::R6Class(
  "DeclinePasswordResetRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0xf6, 0x09, 0x94, 0x4c)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xac, 0x99, 0xb3, 0xf5)),

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DeclinePasswordResetRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0xf6, 0x09, 0x94, 0x4c))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of DeclinePasswordResetRequest.
    fromReader = function(reader) {
      DeclinePasswordResetRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title DeleteAccountRequest
#  @description R6 class representing a DeleteAccountRequest.
#  @details This class handles deleting an account with a reason and optional password.
#  @export
#  @noRd
#  @noRd
DeleteAccountRequest <- R6::R6Class(
  "DeleteAccountRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x74, 0xcf, 0xc0, 0xa2)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xac, 0x99, 0xb3, 0xf5)),

    #  @description Initialize the DeleteAccountRequest.
    #  @param reason The reason string.
    #  @param password Optional input check password SRP.
    initialize = function(reason, password = NULL) {
      self$reason <- reason
      self$password <- password
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DeleteAccountRequest",
        reason = self$reason,
        password = if (inherits(self$password, "TLObject")) self$password$toDict() else self$password
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- if (is.null(self$password)) 0 else 1
      c(
        as.raw(c(0x74, 0xcf, 0xc0, 0xa2)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        self$serialize_bytes(self$reason),
        if (!is.null(self$password)) self$password$bytes() else raw()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of DeleteAccountRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      reason <- reader$tgreadString()
      password <- if (bitwAnd(flags, 1) != 0) reader$tgreadObject() else NULL
      DeleteAccountRequest$new(reason = reason, password = password)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title DeleteAutoSaveExceptionsRequest
#  @description R6 class representing a DeleteAutoSaveExceptionsRequest.
#  @details This class handles deleting auto-save exceptions.
#  @export
#  @noRd
#  @noRd
DeleteAutoSaveExceptionsRequest <- R6::R6Class(
  "DeleteAutoSaveExceptionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x20, 0x00, 0xbc, 0x53)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xac, 0x99, 0xb3, 0xf5)),

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DeleteAutoSaveExceptionsRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0x20, 0x00, 0xbc, 0x53))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of DeleteAutoSaveExceptionsRequest.
    fromReader = function(reader) {
      DeleteAutoSaveExceptionsRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title DeleteBusinessChatLinkRequest
#  @description R6 class representing a DeleteBusinessChatLinkRequest.
#  @details This class handles deleting a business chat link with a specified slug.
#  @export
#  @noRd
#  @noRd
DeleteBusinessChatLinkRequest <- R6::R6Class(
  "DeleteBusinessChatLinkRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x74, 0x36, 0x07, 0x60)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xac, 0x99, 0xb3, 0xf5)),

    #  @description Initialize the DeleteBusinessChatLinkRequest.
    #  @param slug The slug string.
    initialize = function(slug) {
      self$slug <- slug
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DeleteBusinessChatLinkRequest",
        slug = self$slug
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x74, 0x36, 0x07, 0x60)),
        self$serialize_bytes(self$slug)
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of DeleteBusinessChatLinkRequest.
    fromReader = function(reader) {
      slug <- reader$tgreadString()
      DeleteBusinessChatLinkRequest$new(slug = slug)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title DeleteSecureValueRequest
#  @description R6 class representing a DeleteSecureValueRequest.
#  @details This class handles deleting secure values for specified types.
#  @export
#  @noRd
#  @noRd
DeleteSecureValueRequest <- R6::R6Class(
  "DeleteSecureValueRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x4b, 0xbc, 0x80, 0xb8)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xac, 0x99, 0xb3, 0xf5)),

    #  @description Initialize the DeleteSecureValueRequest.
    #  @param types List of secure value types.
    initialize = function(types) {
      self$types <- types
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DeleteSecureValueRequest",
        types = if (is.null(self$types)) list() else lapply(self$types, function(x) if (inherits(x, "TLObject")) x$toDict() else x)
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x4b, 0xbc, 0x80, 0xb8)),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        writeBin(length(self$types), raw(), size = 4, endian = "little"),
        do.call(c, lapply(self$types, function(x) x$bytes()))
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of DeleteSecureValueRequest.
    fromReader = function(reader) {
      reader$readInt()
      types <- list()
      for (i in seq_len(reader$readInt())) {
        x <- reader$tgreadObject()
        types <- c(types, list(x))
      }
      DeleteSecureValueRequest$new(types = types)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title DisablePeerConnectedBotRequest
#  @description R6 class representing a DisablePeerConnectedBotRequest.
#  @details This class handles disabling a connected bot for a peer.
#  @export
#  @noRd
#  @noRd
DisablePeerConnectedBotRequest <- R6::R6Class(
  "DisablePeerConnectedBotRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0xd9, 0x7e, 0x43, 0x5e)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xac, 0x99, 0xb3, 0xf5)),

    #  @description Initialize the DisablePeerConnectedBotRequest.
    #  @param peer The input peer.
    initialize = function(peer) {
      self$peer <- peer
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "DisablePeerConnectedBotRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xd9, 0x7e, 0x43, 0x5e)),
        self$peer$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of DisablePeerConnectedBotRequest.
    fromReader = function(reader) {
      peer <- reader$tgreadObject()
      DisablePeerConnectedBotRequest$new(peer = peer)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title EditBusinessChatLinkRequest
#  @description R6 class representing an EditBusinessChatLinkRequest.
#  @details This class handles editing a business chat link.
#  @export
#  @noRd
#  @noRd
EditBusinessChatLinkRequest <- R6::R6Class(
  "EditBusinessChatLinkRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0xaf, 0x10, 0x34, 0x8c)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0x8b, 0x4a, 0x0d, 0x3c)),

    #  @description Initialize the EditBusinessChatLinkRequest.
    #  @param slug The slug string.
    #  @param link The input business chat link.
    initialize = function(slug, link) {
      self$slug <- slug
      self$link <- link
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "EditBusinessChatLinkRequest",
        slug = self$slug,
        link = if (inherits(self$link, "TLObject")) self$link$toDict() else self$link
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xaf, 0x10, 0x34, 0x8c)),
        self$serialize_bytes(self$slug),
        self$link$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of EditBusinessChatLinkRequest.
    fromReader = function(reader) {
      slug <- reader$tgreadString()
      link <- reader$tgreadObject()
      EditBusinessChatLinkRequest$new(slug = slug, link = link)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title FinishTakeoutSessionRequest
#  @description R6 class representing a FinishTakeoutSessionRequest.
#  @details This class handles finishing a takeout session.
#  @export
#  @noRd
#  @noRd
FinishTakeoutSessionRequest <- R6::R6Class(
  "FinishTakeoutSessionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0xee, 0x52, 0x26, 0x1d)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xac, 0x99, 0xb3, 0xf5)),

    #  @description Initialize the FinishTakeoutSessionRequest.
    #  @param success Optional boolean indicating success.
    initialize = function(success = NULL) {
      self$success <- success
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "FinishTakeoutSessionRequest",
        success = self$success
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- if (is.null(self$success) || !self$success) 0 else 1
      c(
        as.raw(c(0xee, 0x52, 0x26, 0x1d)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of FinishTakeoutSessionRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      success <- bitwAnd(flags, 1) != 0
      FinishTakeoutSessionRequest$new(success = success)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title GetAccountTTLRequest
#  @description R6 class representing a GetAccountTTLRequest.
#  @details This class handles requesting the current account TTL (time to live) settings.
#  @export
#  @noRd
#  @noRd
GetAccountTTLRequest <- R6::R6Class(
  "GetAccountTTLRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x1d, 0x11, 0xc7, 0x8f)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0x88, 0x9d, 0xa3, 0xba)),

    #  @description Initialize the GetAccountTTLRequest.
    initialize = function() {},

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetAccountTTLRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0x1d, 0x11, 0xc7, 0x8f))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetAccountTTLRequest.
    fromReader = function(reader) {
      GetAccountTTLRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetAllSecureValuesRequest
#  @description R6 class representing a GetAllSecureValuesRequest.
#  @details This class handles requesting all secure values.
#  @export
#  @noRd
#  @noRd
GetAllSecureValuesRequest <- R6::R6Class(
  "GetAllSecureValuesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x7d, 0xbc, 0x88, 0xb2)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0x21, 0x41, 0x2e, 0xe8)),

    #  @description Initialize the GetAllSecureValuesRequest.
    initialize = function() {},

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetAllSecureValuesRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0x7d, 0xbc, 0x88, 0xb2))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetAllSecureValuesRequest.
    fromReader = function(reader) {
      GetAllSecureValuesRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetAuthorizationFormRequest
#  @description R6 class representing a GetAuthorizationFormRequest.
#  @details This class handles requesting an authorization form for a bot with specified scope and public key.
#  @export
#  @noRd
#  @noRd
GetAuthorizationFormRequest <- R6::R6Class(
  "GetAuthorizationFormRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x7a, 0x59, 0x29, 0xa9)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0x94, 0x9a, 0x04, 0x78)),

    #  @description Initialize the GetAuthorizationFormRequest.
    #  @param botId The bot ID as an integer.
    #  @param scope The scope string.
    #  @param publicKey The public key string.
    initialize = function(botId, scope, publicKey) {
      self$botId <- botId
      self$scope <- scope
      self$publicKey <- publicKey
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetAuthorizationFormRequest",
        "bot_id" = self$botId,
        "scope" = self$scope,
        "public_key" = self$publicKey
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x7a, 0x59, 0x29, 0xa9)),
        writeBin(as.integer(self$botId), raw(), size = 8, endian = "little"),
        self$serialize_bytes(self$scope),
        self$serialize_bytes(self$publicKey)
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetAuthorizationFormRequest.
    fromReader = function(reader) {
      botId <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      scope <- reader$tgreadString()
      publicKey <- reader$tgreadString()
      GetAuthorizationFormRequest$new(botId = botId, scope = scope, publicKey = publicKey)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetAuthorizationsRequest
#  @description R6 class representing a GetAuthorizationsRequest.
#  @details This class handles requesting the list of authorizations.
#  @export
#  @noRd
#  @noRd
GetAuthorizationsRequest <- R6::R6Class(
  "GetAuthorizationsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x58, 0xc1, 0x20, 0xe3)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xff, 0xe0, 0x5e, 0x0b)),

    #  @description Initialize the GetAuthorizationsRequest.
    initialize = function() {},

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetAuthorizationsRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0x58, 0xc1, 0x20, 0xe3))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetAuthorizationsRequest.
    fromReader = function(reader) {
      GetAuthorizationsRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title GetAutoDownloadSettingsRequest
#  @description R6 class representing a GetAutoDownloadSettingsRequest.
#  @details This class handles requesting auto-download settings.
#  @export
#  @noRd
#  @noRd
GetAutoDownloadSettingsRequest <- R6::R6Class(
  "GetAutoDownloadSettingsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x3f, 0x0b, 0xda, 0x56)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0x21, 0x59, 0xb8, 0x2f)),

    #  @description Initialize the GetAutoDownloadSettingsRequest.
    initialize = function() {},

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetAutoDownloadSettingsRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0x3f, 0x0b, 0xda, 0x56))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetAutoDownloadSettingsRequest.
    fromReader = function(reader) {
      GetAutoDownloadSettingsRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetAutoSaveSettingsRequest
#  @description R6 class representing a GetAutoSaveSettingsRequest.
#  @details This class handles requesting auto-save settings.
#  @export
#  @noRd
#  @noRd
GetAutoSaveSettingsRequest <- R6::R6Class(
  "GetAutoSaveSettingsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0xda, 0xbc, 0xcb, 0xad)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0x02, 0x2f, 0xcf, 0x48)),

    #  @description Initialize the GetAutoSaveSettingsRequest.
    initialize = function() {},

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetAutoSaveSettingsRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0xda, 0xbc, 0xcb, 0xad))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetAutoSaveSettingsRequest.
    fromReader = function(reader) {
      GetAutoSaveSettingsRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetBotBusinessConnectionRequest
#  @description R6 class representing a GetBotBusinessConnectionRequest.
#  @details This class handles requesting bot business connection with a connection ID.
#  @export
#  @noRd
#  @noRd
GetBotBusinessConnectionRequest <- R6::R6Class(
  "GetBotBusinessConnectionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x70, 0x62, 0xa8, 0x76)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xac, 0x2a, 0xf5, 0x8a)),

    #  @description Initialize the GetBotBusinessConnectionRequest.
    #  @param connectionId The connection ID string.
    initialize = function(connectionId) {
      self$connectionId <- connectionId
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetBotBusinessConnectionRequest",
        "connectionId" = self$connectionId
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x70, 0x62, 0xa8, 0x76)),
        self$serialize_bytes(self$connectionId)
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetBotBusinessConnectionRequest.
    fromReader = function(reader) {
      connectionId <- reader$tgreadString()
      GetBotBusinessConnectionRequest$new(connectionId = connectionId)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetBusinessChatLinksRequest
#  @description R6 class representing a GetBusinessChatLinksRequest.
#  @details This class handles requesting business chat links.
#  @export
#  @noRd
#  @noRd
GetBusinessChatLinksRequest <- R6::R6Class(
  "GetBusinessChatLinksRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0xe1, 0xdd, 0x70, 0x6f)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0x31, 0x4a, 0xba, 0xc6)),

    #  @description Initialize the GetBusinessChatLinksRequest.
    initialize = function() {},

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetBusinessChatLinksRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0xe1, 0xdd, 0x70, 0x6f))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetBusinessChatLinksRequest.
    fromReader = function(reader) {
      GetBusinessChatLinksRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title GetChannelDefaultEmojiStatusesRequest
#  @description R6 class representing a GetChannelDefaultEmojiStatusesRequest.
#  @details This class handles requesting channel default emoji statuses with a hash for caching.
#  @export
#  @noRd
#  @noRd
GetChannelDefaultEmojiStatusesRequest <- R6::R6Class(
  "GetChannelDefaultEmojiStatusesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0xd5, 0xa7, 0x27, 0x77)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xca, 0x05, 0xe0, 0xd3)),

    #  @description Initialize the GetChannelDefaultEmojiStatusesRequest.
    #  @param hash The hash value for caching.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetChannelDefaultEmojiStatusesRequest",
        hash = self$hash
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xd5, 0xa7, 0x27, 0x77)),
        writeBin(as.integer(self$hash), raw(), size = 8, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetChannelDefaultEmojiStatusesRequest.
    fromReader = function(reader) {
      hash <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      GetChannelDefaultEmojiStatusesRequest$new(hash = hash)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetChannelRestrictedStatusEmojisRequest
#  @description R6 class representing a GetChannelRestrictedStatusEmojisRequest.
#  @details This class handles requesting channel restricted status emojis with a hash for caching.
#  @export
#  @noRd
#  @noRd
GetChannelRestrictedStatusEmojisRequest <- R6::R6Class(
  "GetChannelRestrictedStatusEmojisRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0xd5, 0xe0, 0xa9, 0x35)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xba, 0xef, 0xc6, 0xbc)),

    #  @description Initialize the GetChannelRestrictedStatusEmojisRequest.
    #  @param hash The hash value for caching.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetChannelRestrictedStatusEmojisRequest",
        hash = self$hash
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xd5, 0xe0, 0xa9, 0x35)),
        writeBin(as.integer(self$hash), raw(), size = 8, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetChannelRestrictedStatusEmojisRequest.
    fromReader = function(reader) {
      hash <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      GetChannelRestrictedStatusEmojisRequest$new(hash = hash)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetChatThemesRequest
#  @description R6 class representing a GetChatThemesRequest.
#  @details This class handles requesting chat themes with a hash for caching.
#  @export
#  @noRd
#  @noRd
GetChatThemesRequest <- R6::R6Class(
  "GetChatThemesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x89, 0xde, 0x38, 0xd6)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0x04, 0x22, 0xc5, 0x7f)),

    #  @description Initialize the GetChatThemesRequest.
    #  @param hash The hash value for caching.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetChatThemesRequest",
        hash = self$hash
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x89, 0xde, 0x38, 0xd6)),
        writeBin(as.integer(self$hash), raw(), size = 8, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetChatThemesRequest.
    fromReader = function(reader) {
      hash <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      GetChatThemesRequest$new(hash = hash)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title GetCollectibleEmojiStatusesRequest
#  @description R6 class representing a GetCollectibleEmojiStatusesRequest.
#  @details This class handles requesting collectible emoji statuses with a hash for caching.
#  @export
#  @noRd
#  @noRd
GetCollectibleEmojiStatusesRequest <- R6::R6Class(
  "GetCollectibleEmojiStatusesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x43, 0x45, 0x7b, 0x2e)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xca, 0x05, 0xe0, 0xd3)),

    #  @description Initialize the GetCollectibleEmojiStatusesRequest.
    #  @param hash The hash value for caching.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetCollectibleEmojiStatusesRequest",
        hash = self$hash
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x43, 0x45, 0x7b, 0x2e)),
        writeBin(as.integer(self$hash), raw(), size = 8, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetCollectibleEmojiStatusesRequest.
    fromReader = function(reader) {
      hash <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      GetCollectibleEmojiStatusesRequest$new(hash = hash)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetConnectedBotsRequest
#  @description R6 class representing a GetConnectedBotsRequest.
#  @details This class handles requesting connected bots.
#  @export
#  @noRd
#  @noRd
GetConnectedBotsRequest <- R6::R6Class(
  "GetConnectedBotsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x0f, 0xc8, 0xa4, 0x4e)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xd3, 0xf7, 0xca, 0xe4)),

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetConnectedBotsRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0x0f, 0xc8, 0xa4, 0x4e))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetConnectedBotsRequest.
    fromReader = function(reader) {
      GetConnectedBotsRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetContactSignUpNotificationRequest
#  @description R6 class representing a GetContactSignUpNotificationRequest.
#  @details This class handles requesting contact sign-up notification settings.
#  @export
#  @noRd
#  @noRd
GetContactSignUpNotificationRequest <- R6::R6Class(
  "GetContactSignUpNotificationRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x28, 0xc7, 0x07, 0x9f)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xac, 0x99, 0xb3, 0xf5)),

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetContactSignUpNotificationRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0x28, 0xc7, 0x07, 0x9f))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetContactSignUpNotificationRequest.
    fromReader = function(reader) {
      GetContactSignUpNotificationRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetContentSettingsRequest
#  @description R6 class representing a GetContentSettingsRequest.
#  @details This class handles requesting content settings.
#  @export
#  @noRd
#  @noRd
GetContentSettingsRequest <- R6::R6Class(
  "GetContentSettingsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0xae, 0x4d, 0x9b, 0x8b)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0x91, 0xf8, 0x3f, 0xae)),

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetContentSettingsRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0xae, 0x4d, 0x9b, 0x8b))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetContentSettingsRequest.
    fromReader = function(reader) {
      GetContentSettingsRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title GetDefaultBackgroundEmojisRequest
#  @description R6 class representing a GetDefaultBackgroundEmojisRequest.
#  @details This class handles requesting default background emojis with a hash for caching.
#  @export
#  @noRd
#  @noRd
GetDefaultBackgroundEmojisRequest <- R6::R6Class(
  "GetDefaultBackgroundEmojisRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0xce, 0xb9, 0x0a, 0xa6)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xba, 0x6a, 0xef, 0xbc)),

    #  @description Initialize the GetDefaultBackgroundEmojisRequest.
    #  @param hash The hash value for caching.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetDefaultBackgroundEmojisRequest",
        hash = self$hash
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xce, 0xb9, 0x0a, 0xa6)),
        writeBin(as.integer(self$hash), raw(), size = 8, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetDefaultBackgroundEmojisRequest.
    fromReader = function(reader) {
      hash <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      GetDefaultBackgroundEmojisRequest$new(hash = hash)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetDefaultEmojiStatusesRequest
#  @description R6 class representing a GetDefaultEmojiStatusesRequest.
#  @details This class handles requesting default emoji statuses with a hash for caching.
#  @export
#  @noRd
#  @noRd
GetDefaultEmojiStatusesRequest <- R6::R6Class(
  "GetDefaultEmojiStatusesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0x86, 0x33, 0x75, 0xd6)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xca, 0x05, 0xe0, 0xd3)),

    #  @description Initialize the GetDefaultEmojiStatusesRequest.
    #  @param hash The hash value for caching.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetDefaultEmojiStatusesRequest",
        hash = self$hash
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x86, 0x33, 0x75, 0xd6)),
        writeBin(as.integer(self$hash), raw(), size = 8, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetDefaultEmojiStatusesRequest.
    fromReader = function(reader) {
      hash <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      GetDefaultEmojiStatusesRequest$new(hash = hash)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetDefaultGroupPhotoEmojisRequest
#  @description R6 class representing a GetDefaultGroupPhotoEmojisRequest.
#  @details This class handles requesting default group photo emojis with a hash for caching.
#  @export
#  @noRd
#  @noRd
GetDefaultGroupPhotoEmojisRequest <- R6::R6Class(
  "GetDefaultGroupPhotoEmojisRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = as.raw(c(0xae, 0x60, 0x58, 0x91)),
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = as.raw(c(0xba, 0x6a, 0xef, 0xbc)),

    #  @description Initialize the GetDefaultGroupPhotoEmojisRequest.
    #  @param hash The hash value for caching.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetDefaultGroupPhotoEmojisRequest",
        hash = self$hash
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xae, 0x60, 0x58, 0x91)),
        writeBin(as.integer(self$hash), raw(), size = 8, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetDefaultGroupPhotoEmojisRequest.
    fromReader = function(reader) {
      hash <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      GetDefaultGroupPhotoEmojisRequest$new(hash = hash)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title GetDefaultProfilePhotoEmojisRequest
#  @description R6 class representing a GetDefaultProfilePhotoEmojisRequest.
#  @details This class handles requesting default profile photo emojis with a hash for caching.
#  @export
#  @noRd
#  @noRd
GetDefaultProfilePhotoEmojisRequest <- R6::R6Class(
  "GetDefaultProfilePhotoEmojisRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xe2750328,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xbcef6aba,

    #  @description Initialize the GetDefaultProfilePhotoEmojisRequest.
    #  @param hash The hash value for caching.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetDefaultProfilePhotoEmojisRequest",
        hash = self$hash
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x28, 0x03, 0x75, 0xe2)),
        writeBin(as.integer(self$hash), raw(), size = 8, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetDefaultProfilePhotoEmojisRequest.
    fromReader = function(reader) {
      hash <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      GetDefaultProfilePhotoEmojisRequest$new(hash = hash)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetGlobalPrivacySettingsRequest
#  @description R6 class representing a GetGlobalPrivacySettingsRequest.
#  @details This class handles requesting global privacy settings.
#  @export
#  @noRd
#  @noRd
GetGlobalPrivacySettingsRequest <- R6::R6Class(
  "GetGlobalPrivacySettingsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xeb2b4cf6,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xc90e5770,

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetGlobalPrivacySettingsRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0xf6, 0x4c, 0x2b, 0xeb))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetGlobalPrivacySettingsRequest.
    fromReader = function(reader) {
      GetGlobalPrivacySettingsRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetMultiWallPapersRequest
#  @description R6 class representing a GetMultiWallPapersRequest.
#  @details This class handles requesting multiple wallpapers.
#  @export
#  @noRd
#  @noRd
GetMultiWallPapersRequest <- R6::R6Class(
  "GetMultiWallPapersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0x65ad71dc,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8ec35283,

    #  @description Initialize the GetMultiWallPapersRequest.
    #  @param wallpapers List of input wallpapers.
    initialize = function(wallpapers) {
      self$wallpapers <- wallpapers
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetMultiWallPapersRequest",
        wallpapers = if (is.null(self$wallpapers)) list() else lapply(self$wallpapers, function(x) if (inherits(x, "TLObject")) x$toDict() else x)
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xdc, 0x71, 0xad, 0x65)),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        writeBin(length(self$wallpapers), raw(), size = 4, endian = "little"),
        do.call(c, lapply(self$wallpapers, function(x) x$bytes()))
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetMultiWallPapersRequest.
    fromReader = function(reader) {
      reader$readInt()
      wallpapers <- list()
      for (i in seq_len(reader$readInt())) {
        x <- reader$tgreadObject()
        wallpapers <- c(wallpapers, list(x))
      }
      GetMultiWallPapersRequest$new(wallpapers = wallpapers)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title GetNotifyExceptionsRequest
#  @description R6 class representing a GetNotifyExceptionsRequest.
#  @details This class handles requesting notification exceptions with optional compare flags and peer.
#  @export
#  @noRd
#  @noRd
GetNotifyExceptionsRequest <- R6::R6Class(
  "GetNotifyExceptionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0x53577479,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8af52aac,

    #  @description Initialize the GetNotifyExceptionsRequest.
    #  @param compareSound Optional boolean indicating if to compare sound.
    #  @param compareStories Optional boolean indicating if to compare stories.
    #  @param peer Optional input notify peer.
    initialize = function(compareSound = NULL, compareStories = NULL, peer = NULL) {
      self$compareSound <- compareSound
      self$compareStories <- compareStories
      self$peer <- peer
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      if (!is.null(self$peer)) {
        self$peer <- client$getInputNotify(self$peer)
      }
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetNotifyExceptionsRequest",
        compareSound = self$compareSound,
        compareStories = self$compareStories,
        peer = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- (if (is.null(self$compareSound) || !self$compareSound) 0 else 2) |
        (if (is.null(self$compareStories) || !self$compareStories) 0 else 4) |
        (if (is.null(self$peer)) 0 else 1)
      c(
        as.raw(c(0x79, 0x74, 0x57, 0x53)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        if (!is.null(self$peer)) self$peer$bytes() else raw()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetNotifyExceptionsRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      compareSound <- bitwAnd(flags, 2) != 0
      compareStories <- bitwAnd(flags, 4) != 0
      peer <- if (bitwAnd(flags, 1) != 0) reader$tgreadObject() else NULL
      GetNotifyExceptionsRequest$new(compareSound = compareSound, compareStories = compareStories, peer = peer)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetNotifySettingsRequest
#  @description R6 class representing a GetNotifySettingsRequest.
#  @details This class handles requesting notification settings for a peer.
#  @export
#  @noRd
#  @noRd
GetNotifySettingsRequest <- R6::R6Class(
  "GetNotifySettingsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0x12b3ad31,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xcf20c074,

    #  @description Initialize the GetNotifySettingsRequest.
    #  @param peer The input notify peer.
    initialize = function(peer) {
      self$peer <- peer
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- client$getInputNotify(self$peer)
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetNotifySettingsRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x31, 0xad, 0xb3, 0x12)),
        self$peer$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetNotifySettingsRequest.
    fromReader = function(reader) {
      peer <- reader$tgreadObject()
      GetNotifySettingsRequest$new(peer = peer)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetPaidMessagesRevenueRequest
#  @description R6 class representing a GetPaidMessagesRevenueRequest.
#  @details This class handles requesting paid messages revenue for a user with optional parent peer.
#  @export
#  @noRd
#  @noRd
GetPaidMessagesRevenueRequest <- R6::R6Class(
  "GetPaidMessagesRevenueRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0x19ba4a67,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x152f0c57,

    #  @description Initialize the GetPaidMessagesRevenueRequest.
    #  @param userId The input user ID.
    #  @param parentPeer Optional input parent peer.
    initialize = function(userId, parentPeer = NULL) {
      self$userId <- userId
      self$parentPeer <- parentPeer
    },

    #  @description Resolve the user ID and parent peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$userId <- utils$getInputUser(client$getInputEntity(self$userId))
      if (!is.null(self$parentPeer)) {
        self$parentPeer <- utils$getInputPeer(client$getInputEntity(self$parentPeer))
      }
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetPaidMessagesRevenueRequest",
        userId = if (inherits(self$userId, "TLObject")) self$userId$toDict() else self$userId,
        parentPeer = if (inherits(self$parentPeer, "TLObject")) self$parentPeer$toDict() else self$parentPeer
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- if (is.null(self$parentPeer)) 0 else 1
      c(
        as.raw(c(0x67, 0x4a, 0xba, 0x19)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        if (!is.null(self$parentPeer)) self$parentPeer$bytes() else raw(),
        self$userId$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetPaidMessagesRevenueRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      parentPeer <- if (bitwAnd(flags, 1) != 0) reader$tgreadObject() else NULL
      userId <- reader$tgreadObject()
      GetPaidMessagesRevenueRequest$new(userId = userId, parentPeer = parentPeer)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title GetPasswordRequest
#  @description R6 class representing a GetPasswordRequest.
#  @details This class handles requesting the current password information.
#  @export
#  @noRd
#  @noRd
GetPasswordRequest <- R6::R6Class(
  "GetPasswordRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0x548a30f5,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x53a211a3,

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetPasswordRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0xf5, 0x30, 0x8a, 0x54))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetPasswordRequest.
    fromReader = function(reader) {
      GetPasswordRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetPasswordSettingsRequest
#  @description R6 class representing a GetPasswordSettingsRequest.
#  @details This class handles requesting password settings with a password input.
#  @export
#  @noRd
#  @noRd
GetPasswordSettingsRequest <- R6::R6Class(
  "GetPasswordSettingsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0x9cd4eaf9,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd23fb078,

    #  @description Initialize the GetPasswordSettingsRequest.
    #  @param password The input check password SRP.
    initialize = function(password) {
      self$password <- password
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetPasswordSettingsRequest",
        password = if (inherits(self$password, "TLObject")) self$password$toDict() else self$password
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xf9, 0xea, 0xd4, 0x9c)),
        self$password$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetPasswordSettingsRequest.
    fromReader = function(reader) {
      password <- reader$tgreadObject()
      GetPasswordSettingsRequest$new(password = password)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetPrivacyRequest
#  @description R6 class representing a GetPrivacyRequest.
#  @details This class handles requesting privacy rules for a given key.
#  @export
#  @noRd
#  @noRd
GetPrivacyRequest <- R6::R6Class(
  "GetPrivacyRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xdadbc950,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xb55aba82,

    #  @description Initialize the GetPrivacyRequest.
    #  @param key The input privacy key.
    initialize = function(key) {
      self$key <- key
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetPrivacyRequest",
        key = if (inherits(self$key, "TLObject")) self$key$toDict() else self$key
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x50, 0xc9, 0xdb, 0xda)),
        self$key$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetPrivacyRequest.
    fromReader = function(reader) {
      key <- reader$tgreadObject()
      GetPrivacyRequest$new(key = key)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetReactionsNotifySettingsRequest
#  @description R6 class representing a GetReactionsNotifySettingsRequest.
#  @details This class handles requesting reactions notify settings.
#  @export
#  @noRd
#  @noRd
GetReactionsNotifySettingsRequest <- R6::R6Class(
  "GetReactionsNotifySettingsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0x6dd654c,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x8dff0851,

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetReactionsNotifySettingsRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0x4c, 0xd6, 0xdd, 0x06))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetReactionsNotifySettingsRequest.
    fromReader = function(reader) {
      GetReactionsNotifySettingsRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title GetRecentEmojiStatusesRequest
#  @description R6 class representing a GetRecentEmojiStatusesRequest.
#  @details This class handles requesting recent emoji statuses with a hash for caching.
#  @export
#  @noRd
#  @noRd
GetRecentEmojiStatusesRequest <- R6::R6Class(
  "GetRecentEmojiStatusesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xf578105,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xd3e005ca,

    #  @description Initialize the GetRecentEmojiStatusesRequest.
    #  @param hash The hash value for caching.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetRecentEmojiStatusesRequest",
        hash = self$hash
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x05, 0x81, 0x57, 0x0f)),
        writeBin(as.integer(self$hash), raw(), size = 8, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetRecentEmojiStatusesRequest.
    fromReader = function(reader) {
      hash <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      GetRecentEmojiStatusesRequest$new(hash = hash)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetSavedMusicIdsRequest
#  @description R6 class representing a GetSavedMusicIdsRequest.
#  @details This class handles requesting saved music IDs with a hash for caching.
#  @export
#  @noRd
#  @noRd
GetSavedMusicIdsRequest <- R6::R6Class(
  "GetSavedMusicIdsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xe09d5faf,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x4b4af692,

    #  @description Initialize the GetSavedMusicIdsRequest.
    #  @param hash The hash value for caching.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetSavedMusicIdsRequest",
        hash = self$hash
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xaf, 0x5f, 0x9d, 0xe0)),
        writeBin(as.integer(self$hash), raw(), size = 8, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetSavedMusicIdsRequest.
    fromReader = function(reader) {
      hash <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      GetSavedMusicIdsRequest$new(hash = hash)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetSavedRingtonesRequest
#  @description R6 class representing a GetSavedRingtonesRequest.
#  @details This class handles requesting saved ringtones with a hash for caching.
#  @export
#  @noRd
#  @noRd
GetSavedRingtonesRequest <- R6::R6Class(
  "GetSavedRingtonesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xe1902288,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x27bcc95e,

    #  @description Initialize the GetSavedRingtonesRequest.
    #  @param hash The hash value for caching.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetSavedRingtonesRequest",
        hash = self$hash
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x88, 0x22, 0x90, 0xe1)),
        writeBin(as.integer(self$hash), raw(), size = 8, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetSavedRingtonesRequest.
    fromReader = function(reader) {
      hash <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      GetSavedRingtonesRequest$new(hash = hash)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title GetSecureValueRequest
#  @description R6 class representing a GetSecureValueRequest.
#  @details This class handles requesting secure values for specified types.
#  @export
#  @noRd
#  @noRd
GetSecureValueRequest <- R6::R6Class(
  "GetSecureValueRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0x73665bc2,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xe82e4121,

    #  @description Initialize the GetSecureValueRequest.
    #  @param types List of secure value types.
    initialize = function(types) {
      self$types <- types
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetSecureValueRequest",
        types = if (is.null(self$types)) list() else lapply(self$types, function(x) if (inherits(x, "TLObject")) x$toDict() else x)
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xc2, 0x5b, 0x66, 0x73)),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        writeBin(length(self$types), raw(), size = 4, endian = "little"),
        do.call(c, lapply(self$types, function(x) x$bytes()))
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetSecureValueRequest.
    fromReader = function(reader) {
      reader$readInt()
      types <- list()
      for (i in seq_len(reader$readInt())) {
        x <- reader$tgreadObject()
        types <- c(types, list(x))
      }
      GetSecureValueRequest$new(types = types)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetThemeRequest
#  @description R6 class representing a GetThemeRequest.
#  @details This class handles requesting a theme with specified format and theme input.
#  @export
#  @noRd
#  @noRd
GetThemeRequest <- R6::R6Class(
  "GetThemeRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0x3a5869ec,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x56b4c80c,

    #  @description Initialize the GetThemeRequest.
    #  @param format The format string.
    #  @param theme The input theme.
    initialize = function(format, theme) {
      self$format <- format
      self$theme <- theme
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetThemeRequest",
        format = self$format,
        theme = if (inherits(self$theme, "TLObject")) self$theme$toDict() else self$theme
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xec, 0x69, 0x58, 0x3a)),
        self$serialize_bytes(self$format),
        self$theme$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetThemeRequest.
    fromReader = function(reader) {
      format <- reader$tgreadString()
      theme <- reader$tgreadObject()
      GetThemeRequest$new(format = format, theme = theme)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetThemesRequest
#  @description R6 class representing a GetThemesRequest.
#  @details This class handles requesting themes with specified format and hash.
#  @export
#  @noRd
#  @noRd
GetThemesRequest <- R6::R6Class(
  "GetThemesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0x7206e458,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x7fc52204,

    #  @description Initialize the GetThemesRequest.
    #  @param format The format string.
    #  @param hash The hash value.
    initialize = function(format, hash) {
      self$format <- format
      self$hash <- hash
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetThemesRequest",
        format = self$format,
        hash = self$hash
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x58, 0xe4, 0x06, 0x72)),
        self$serialize_bytes(self$format),
        writeBin(as.integer(self$hash), raw(), size = 8, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetThemesRequest.
    fromReader = function(reader) {
      format <- reader$tgreadString()
      hash <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      GetThemesRequest$new(format = format, hash = hash)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title GetTmpPasswordRequest
#  @description R6 class representing a GetTmpPasswordRequest.
#  @details This class handles requesting a temporary password with a password and period.
#  @export
#  @noRd
#  @noRd
GetTmpPasswordRequest <- R6::R6Class(
  "GetTmpPasswordRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0x449e0b51,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xb064992d,

    #  @description Initialize the GetTmpPasswordRequest.
    #  @param password The input check password SRP.
    #  @param period The period in seconds.
    initialize = function(password, period) {
      self$password <- password
      self$period <- period
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetTmpPasswordRequest",
        password = if (inherits(self$password, "TLObject")) self$password$toDict() else self$password,
        period = self$period
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x51, 0x0b, 0x9e, 0x44)),
        self$password$bytes(),
        writeBin(as.integer(self$period), raw(), size = 4, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetTmpPasswordRequest.
    fromReader = function(reader) {
      password <- reader$tgreadObject()
      period <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      GetTmpPasswordRequest$new(password = password, period = period)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetUniqueGiftChatThemesRequest
#  @description R6 class representing a GetUniqueGiftChatThemesRequest.
#  @details This class handles requesting unique gift chat themes with offset, limit, and hash.
#  @export
#  @noRd
#  @noRd
GetUniqueGiftChatThemesRequest <- R6::R6Class(
  "GetUniqueGiftChatThemesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xfe74ef9f,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x15c14aa8,

    #  @description Initialize the GetUniqueGiftChatThemesRequest.
    #  @param offset The offset for pagination.
    #  @param limit The limit for the number of themes.
    #  @param hash The hash for caching.
    initialize = function(offset, limit, hash) {
      self$offset <- offset
      self$limit <- limit
      self$hash <- hash
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetUniqueGiftChatThemesRequest",
        offset = self$offset,
        limit = self$limit,
        hash = self$hash
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x9f, 0xef, 0x74, 0xfe)),
        writeBin(as.integer(self$offset), raw(), size = 4, endian = "little"),
        writeBin(as.integer(self$limit), raw(), size = 4, endian = "little"),
        writeBin(as.integer(self$hash), raw(), size = 8, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetUniqueGiftChatThemesRequest.
    fromReader = function(reader) {
      offset <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      limit <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      hash <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      GetUniqueGiftChatThemesRequest$new(offset = offset, limit = limit, hash = hash)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetWallPaperRequest
#  @description R6 class representing a GetWallPaperRequest.
#  @details This class handles requesting a wallpaper.
#  @export
#  @noRd
#  @noRd
GetWallPaperRequest <- R6::R6Class(
  "GetWallPaperRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xfc8ddbea,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x96a2c98b,

    #  @description Initialize the GetWallPaperRequest.
    #  @param wallpaper The input wallpaper.
    initialize = function(wallpaper) {
      self$wallpaper <- wallpaper
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetWallPaperRequest",
        wallpaper = if (inherits(self$wallpaper, "TLObject")) self$wallpaper$toDict() else self$wallpaper
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xea, 0xdb, 0x8d, 0xfc)),
        self$wallpaper$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetWallPaperRequest.
    fromReader = function(reader) {
      wallpaper <- reader$tgreadObject()
      GetWallPaperRequest$new(wallpaper = wallpaper)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title GetWallPapersRequest
#  @description R6 class representing a GetWallPapersRequest.
#  @details This class handles requesting wallpapers with a hash for caching.
#  @export
#  @noRd
#  @noRd
GetWallPapersRequest <- R6::R6Class(
  "GetWallPapersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0x7967d36,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xa2c548fd,

    #  @description Initialize the GetWallPapersRequest.
    #  @param hash The hash value for caching.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetWallPapersRequest",
        hash = self$hash
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x36, 0x7d, 0x96, 0x07)),
        writeBin(as.integer(self$hash), raw(), size = 8, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetWallPapersRequest.
    fromReader = function(reader) {
      hash <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      GetWallPapersRequest$new(hash = hash)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title GetWebAuthorizationsRequest
#  @description R6 class representing a GetWebAuthorizationsRequest.
#  @details This class handles requesting web authorizations.
#  @export
#  @noRd
#  @noRd
GetWebAuthorizationsRequest <- R6::R6Class(
  "GetWebAuthorizationsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0x182e6d6f,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x9a365b32,

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "GetWebAuthorizationsRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0x6f, 0x6d, 0x2e, 0x18))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of GetWebAuthorizationsRequest.
    fromReader = function(reader) {
      GetWebAuthorizationsRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title InitTakeoutSessionRequest
#  @description R6 class representing an InitTakeoutSessionRequest.
#  @details This class handles initializing a takeout session with various options.
#  @export
#  @noRd
#  @noRd
InitTakeoutSessionRequest <- R6::R6Class(
  "InitTakeoutSessionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0x8ef3eab0,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x843ebe85,

    #  @description Initialize the InitTakeoutSessionRequest.
    #  @param contacts Optional boolean indicating if contacts are included.
    #  @param messageUsers Optional boolean indicating if message users are included.
    #  @param messageChats Optional boolean indicating if message chats are included.
    #  @param messageMegagroups Optional boolean indicating if message megagroups are included.
    #  @param messageChannels Optional boolean indicating if message channels are included.
    #  @param files Optional boolean indicating if files are included.
    #  @param fileMaxSize Optional maximum file size.
    initialize = function(contacts = NULL, messageUsers = NULL, messageChats = NULL, messageMegagroups = NULL, messageChannels = NULL, files = NULL, fileMaxSize = NULL) {
      self$contacts <- contacts
      self$messageUsers <- messageUsers
      self$messageChats <- messageChats
      self$messageMegagroups <- messageMegagroups
      self$messageChannels <- messageChannels
      self$files <- files
      self$fileMaxSize <- fileMaxSize
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "InitTakeoutSessionRequest",
        contacts = self$contacts,
        messageUsers = self$messageUsers,
        messageChats = self$messageChats,
        messageMegagroups = self$messageMegagroups,
        messageChannels = self$messageChannels,
        files = self$files,
        fileMaxSize = self$fileMaxSize
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- (if (is.null(self$contacts) || !self$contacts) 0 else 1) |
        (if (is.null(self$messageUsers) || !self$messageUsers) 0 else 2) |
        (if (is.null(self$messageChats) || !self$messageChats) 0 else 4) |
        (if (is.null(self$messageMegagroups) || !self$messageMegagroups) 0 else 8) |
        (if (is.null(self$messageChannels) || !self$messageChannels) 0 else 16) |
        (if (is.null(self$files) || !self$files) 0 else 32) |
        (if (is.null(self$fileMaxSize) || self$fileMaxSize == 0) 0 else 32)
      c(
        as.raw(c(0xb0, 0xea, 0xf3, 0x8e)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        if (!is.null(self$fileMaxSize) && self$fileMaxSize != 0) writeBin(as.integer(self$fileMaxSize), raw(), size = 8, endian = "little") else raw()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of InitTakeoutSessionRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      contacts <- bitwAnd(flags, 1) != 0
      messageUsers <- bitwAnd(flags, 2) != 0
      messageChats <- bitwAnd(flags, 4) != 0
      messageMegagroups <- bitwAnd(flags, 8) != 0
      messageChannels <- bitwAnd(flags, 16) != 0
      files <- bitwAnd(flags, 32) != 0
      fileMaxSize <- if (bitwAnd(flags, 32) != 0) readBin(reader$readRaw(8), "integer", size = 8, endian = "little") else NULL
      InitTakeoutSessionRequest$new(contacts = contacts, messageUsers = messageUsers, messageChats = messageChats, messageMegagroups = messageMegagroups, messageChannels = messageChannels, files = files, fileMaxSize = fileMaxSize)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title InstallThemeRequest
#  @description R6 class representing an InstallThemeRequest.
#  @details This class handles installing a theme with optional dark mode, theme, format, and base theme.
#  @export
#  @noRd
#  @noRd
InstallThemeRequest <- R6::R6Class(
  "InstallThemeRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xc727bb3b,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the InstallThemeRequest.
    #  @param dark Optional boolean indicating if dark mode is enabled.
    #  @param theme Optional input theme.
    #  @param format Optional format string.
    #  @param baseTheme Optional base theme.
    initialize = function(dark = NULL, theme = NULL, format = NULL, baseTheme = NULL) {
      self$dark <- dark
      self$theme <- theme
      self$format <- format
      self$baseTheme <- baseTheme
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "InstallThemeRequest",
        dark = self$dark,
        theme = if (inherits(self$theme, "TLObject")) self$theme$toDict() else self$theme,
        format = self$format,
        baseTheme = if (inherits(self$baseTheme, "TLObject")) self$baseTheme$toDict() else self$baseTheme
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- (if (is.null(self$dark) || !self$dark) 0 else 1) |
        (if (is.null(self$theme)) 0 else 2) |
        (if (is.null(self$format) || !nzchar(self$format)) 0 else 4) |
        (if (is.null(self$baseTheme)) 0 else 8)
      c(
        as.raw(c(0x3b, 0xbb, 0x27, 0xc7)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        if (!is.null(self$theme)) self$theme$bytes() else raw(),
        if (!is.null(self$format) && nzchar(self$format)) self$serialize_bytes(self$format) else raw(),
        if (!is.null(self$baseTheme)) self$baseTheme$bytes() else raw()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of InstallThemeRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      dark <- bitwAnd(flags, 1) != 0
      theme <- if (bitwAnd(flags, 2) != 0) reader$tgreadObject() else NULL
      format <- if (bitwAnd(flags, 4) != 0) reader$tgreadString() else NULL
      baseTheme <- if (bitwAnd(flags, 8) != 0) reader$tgreadObject() else NULL
      InstallThemeRequest$new(dark = dark, theme = theme, format = format, baseTheme = baseTheme)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title InstallWallPaperRequest
#  @description R6 class representing an InstallWallPaperRequest.
#  @details This class handles installing a wallpaper with settings.
#  @export
#  @noRd
#  @noRd
InstallWallPaperRequest <- R6::R6Class(
  "InstallWallPaperRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xfeed5769,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the InstallWallPaperRequest.
    #  @param wallpaper The input wallpaper.
    #  @param settings The wallpaper settings.
    initialize = function(wallpaper, settings) {
      self$wallpaper <- wallpaper
      self$settings <- settings
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "InstallWallPaperRequest",
        wallpaper = if (inherits(self$wallpaper, "TLObject")) self$wallpaper$toDict() else self$wallpaper,
        settings = if (inherits(self$settings, "TLObject")) self$settings$toDict() else self$settings
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x69, 0x57, 0xed, 0xfe)),
        self$wallpaper$bytes(),
        self$settings$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of InstallWallPaperRequest.
    fromReader = function(reader) {
      wallpaper <- reader$tgreadObject()
      settings <- reader$tgreadObject()
      InstallWallPaperRequest$new(wallpaper = wallpaper, settings = settings)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title InvalidateSignInCodesRequest
#  @description R6 class representing an InvalidateSignInCodesRequest.
#  @details This class handles invalidating sign-in codes.
#  @export
#  @noRd
#  @noRd
InvalidateSignInCodesRequest <- R6::R6Class(
  "InvalidateSignInCodesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xca8ae8ba,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the InvalidateSignInCodesRequest.
    #  @param codes List of sign-in codes.
    initialize = function(codes) {
      self$codes <- codes
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "InvalidateSignInCodesRequest",
        codes = if (is.null(self$codes)) list() else self$codes
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xba, 0xe8, 0x8a, 0xca)),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        writeBin(length(self$codes), raw(), size = 4, endian = "little"),
        do.call(c, lapply(self$codes, function(x) self$serialize_bytes(x)))
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of InvalidateSignInCodesRequest.
    fromReader = function(reader) {
      reader$readInt()
      codes <- list()
      for (i in seq_len(reader$readInt())) {
        x <- reader$tgreadString()
        codes <- c(codes, list(x))
      }
      InvalidateSignInCodesRequest$new(codes = codes)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title RegisterDeviceRequest
#  @description R6 class representing a RegisterDeviceRequest.
#  @details This class handles registering a device with token details, app sandbox status, secret, and other user IDs.
#  @export
#  @noRd
#  @noRd
RegisterDeviceRequest <- R6::R6Class(
  "RegisterDeviceRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xec86017a,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the RegisterDeviceRequest.
    #  @param tokenType The token type integer.
    #  @param token The token string.
    #  @param appSandbox Boolean indicating if the app is in sandbox mode.
    #  @param secret The secret bytes.
    #  @param otherUids List of other user IDs.
    #  @param noMuted Optional boolean indicating if muted notifications are disabled.
    initialize = function(tokenType, token, appSandbox, secret, otherUids, noMuted = NULL) {
      self$tokenType <- tokenType
      self$token <- token
      self$appSandbox <- appSandbox
      self$secret <- secret
      self$otherUids <- otherUids
      self$noMuted <- noMuted
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "RegisterDeviceRequest",
        tokenType = self$tokenType,
        token = self$token,
        appSandbox = self$appSandbox,
        secret = self$secret,
        otherUids = if (is.null(self$otherUids)) list() else self$otherUids,
        noMuted = self$noMuted
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- if (is.null(self$noMuted) || !self$noMuted) 0 else 1
      c(
        as.raw(c(0x7a, 0x01, 0x86, 0xec)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        writeBin(as.integer(self$tokenType), raw(), size = 4, endian = "little"),
        self$serialize_bytes(self$token),
        if (self$appSandbox) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc)),
        self$serialize_bytes(self$secret),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        writeBin(length(self$otherUids), raw(), size = 4, endian = "little"),
        do.call(c, lapply(self$otherUids, function(x) writeBin(as.integer(x), raw(), size = 8, endian = "little")))
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of RegisterDeviceRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      noMuted <- bitwAnd(flags, 1) != 0
      tokenType <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      token <- reader$tgreadString()
      appSandbox <- reader$tgreadBool()
      secret <- reader$tgreadBytes()
      reader$readInt()
      otherUids <- list()
      for (i in seq_len(reader$readInt())) {
        x <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
        otherUids <- c(otherUids, x)
      }
      RegisterDeviceRequest$new(tokenType = tokenType, token = token, appSandbox = appSandbox, secret = secret, otherUids = otherUids, noMuted = noMuted)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title ReorderUsernamesRequest
#  @description R6 class representing a ReorderUsernamesRequest.
#  @details This class handles reordering usernames.
#  @export
#  @noRd
#  @noRd
ReorderUsernamesRequest <- R6::R6Class(
  "ReorderUsernamesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xef500eab,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ReorderUsernamesRequest.
    #  @param order List of usernames in order.
    initialize = function(order) {
      self$order <- order
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ReorderUsernamesRequest",
        order = if (is.null(self$order)) list() else self$order
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xab, 0x0e, 0x50, 0xef)),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        writeBin(length(self$order), raw(), size = 4, endian = "little"),
        do.call(c, lapply(self$order, function(x) self$serialize_bytes(x)))
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ReorderUsernamesRequest.
    fromReader = function(reader) {
      reader$readInt()
      order <- list()
      for (i in seq_len(reader$readInt())) {
        x <- reader$tgreadString()
        order <- c(order, list(x))
      }
      ReorderUsernamesRequest$new(order = order)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title ReportPeerRequest
#  @description R6 class representing a ReportPeerRequest.
#  @details This class handles reporting a peer with a reason and message.
#  @export
#  @noRd
#  @noRd
ReportPeerRequest <- R6::R6Class(
  "ReportPeerRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xc5ba3d86,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ReportPeerRequest.
    #  @param peer The input peer.
    #  @param reason The report reason.
    #  @param message The message string.
    initialize = function(peer, reason, message) {
      self$peer <- peer
      self$reason <- reason
      self$message <- message
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ReportPeerRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        reason = if (inherits(self$reason, "TLObject")) self$reason$toDict() else self$reason,
        message = self$message
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x86, 0x3d, 0xba, 0xc5)),
        self$peer$bytes(),
        self$reason$bytes(),
        self$serialize_bytes(self$message)
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ReportPeerRequest.
    fromReader = function(reader) {
      peer <- reader$tgreadObject()
      reason <- reader$tgreadObject()
      message <- reader$tgreadString()
      ReportPeerRequest$new(peer = peer, reason = reason, message = message)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title ReportProfilePhotoRequest
#  @description R6 class representing a ReportProfilePhotoRequest.
#  @details This class handles reporting a profile photo with a peer, photo ID, reason, and message.
#  @export
#  @noRd
#  @noRd
ReportProfilePhotoRequest <- R6::R6Class(
  "ReportProfilePhotoRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xfa8cc6f5,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ReportProfilePhotoRequest.
    #  @param peer The input peer.
    #  @param photoId The input photo ID.
    #  @param reason The report reason.
    #  @param message The message string.
    initialize = function(peer, photoId, reason, message) {
      self$peer <- peer
      self$photoId <- photoId
      self$reason <- reason
      self$message <- message
    },

    #  @description Resolve the peer and photo ID using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      self$photoId <- utils$getInputPhoto(self$photoId)
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ReportProfilePhotoRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        photoId = if (inherits(self$photoId, "TLObject")) self$photoId$toDict() else self$photoId,
        reason = if (inherits(self$reason, "TLObject")) self$reason$toDict() else self$reason,
        message = self$message
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xf5, 0xc6, 0x8c, 0xfa)),
        self$peer$bytes(),
        self$photoId$bytes(),
        self$reason$bytes(),
        self$serialize_bytes(self$message)
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ReportProfilePhotoRequest.
    fromReader = function(reader) {
      peer <- reader$tgreadObject()
      photoId <- reader$tgreadObject()
      reason <- reader$tgreadObject()
      message <- reader$tgreadString()
      ReportProfilePhotoRequest$new(peer = peer, photoId = photoId, reason = reason, message = message)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title ResendPasswordEmailRequest
#  @description R6 class representing a ResendPasswordEmailRequest.
#  @details This class handles resending the password email.
#  @export
#  @noRd
#  @noRd
ResendPasswordEmailRequest <- R6::R6Class(
  "ResendPasswordEmailRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0x7a7f2a15,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ResendPasswordEmailRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0x15, 0x2a, 0x7f, 0x7a))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ResendPasswordEmailRequest.
    fromReader = function(reader) {
      ResendPasswordEmailRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title ResetAuthorizationRequest
#  @description R6 class representing a ResetAuthorizationRequest.
#  @details This class handles resetting authorization with a hash.
#  @export
#  @noRd
#  @noRd
ResetAuthorizationRequest <- R6::R6Class(
  "ResetAuthorizationRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xdf77f3bc,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ResetAuthorizationRequest.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ResetAuthorizationRequest",
        hash = self$hash
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xbc, 0xf3, 0x77, 0xdf)),
        writeBin(as.integer(self$hash), raw(), size = 8, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ResetAuthorizationRequest.
    fromReader = function(reader) {
      hash <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      ResetAuthorizationRequest$new(hash = hash)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title ResetNotifySettingsRequest
#  @description R6 class representing a ResetNotifySettingsRequest.
#  @details This class handles resetting notification settings.
#  @export
#  @noRd
#  @noRd
ResetNotifySettingsRequest <- R6::R6Class(
  "ResetNotifySettingsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xdb7e1747,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ResetNotifySettingsRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0x47, 0x17, 0x7e, 0xdb))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ResetNotifySettingsRequest.
    fromReader = function(reader) {
      ResetNotifySettingsRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title ResetPasswordRequest
#  @description R6 class representing a ResetPasswordRequest.
#  @details This class handles resetting the password.
#  @export
#  @noRd
#  @noRd
ResetPasswordRequest <- R6::R6Class(
  "ResetPasswordRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0x9308ce1b,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0x49507416,

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ResetPasswordRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0x1b, 0xce, 0x08, 0x93))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ResetPasswordRequest.
    fromReader = function(reader) {
      ResetPasswordRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title ResetWallPapersRequest
#  @description R6 class representing a ResetWallPapersRequest.
#  @details This class handles resetting wallpapers.
#  @export
#  @noRd
#  @noRd
ResetWallPapersRequest <- R6::R6Class(
  "ResetWallPapersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0xbb3b9804,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ResetWallPapersRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0x04, 0x98, 0x3b, 0xbb))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ResetWallPapersRequest.
    fromReader = function(reader) {
      ResetWallPapersRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title ResetWebAuthorizationRequest
#  @description R6 class representing a ResetWebAuthorizationRequest.
#  @details This class handles resetting web authorization with a hash.
#  @export
#  @noRd
#  @noRd
ResetWebAuthorizationRequest <- R6::R6Class(
  "ResetWebAuthorizationRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for the request.
    CONSTRUCTOR_ID = 0x2d01b9ef,
    #  @field SUBCLASS_OF_ID The subclass ID.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize the ResetWebAuthorizationRequest.
    #  @param hash The hash value.
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ResetWebAuthorizationRequest",
        hash = self$hash
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xef, 0xb9, 0x01, 0x2d)),
        writeBin(as.integer(self$hash), raw(), size = 8, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ResetWebAuthorizationRequest.
    fromReader = function(reader) {
      hash <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      ResetWebAuthorizationRequest$new(hash = hash)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title ResetWebAuthorizationsRequest
#  @description R6 class representing a ResetWebAuthorizationsRequest.
#  @details This class handles resetting web authorizations.
#  @export
#  @noRd
#  @noRd
ResetWebAuthorizationsRequest <- R6::R6Class(
  "ResetWebAuthorizationsRequest",
  inherit = TLRequest,
  public = list(
    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ResetWebAuthorizationsRequest"
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      as.raw(c(0x94, 0x25, 0x2d, 0x68))
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ResetWebAuthorizationsRequest.
    fromReader = function(reader) {
      ResetWebAuthorizationsRequest$new()
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title ResolveBusinessChatLinkRequest
#  @description R6 class representing a ResolveBusinessChatLinkRequest.
#  @details This class handles resolving a business chat link with a slug.
#  @export
#  @noRd
#  @noRd
ResolveBusinessChatLinkRequest <- R6::R6Class(
  "ResolveBusinessChatLinkRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the ResolveBusinessChatLinkRequest.
    #  @param slug The slug string.
    initialize = function(slug) {
      self$slug <- slug
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ResolveBusinessChatLinkRequest",
        slug = self$slug
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xee, 0xe5, 0x92, 0x54)),
        self$serialize_bytes(self$slug)
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ResolveBusinessChatLinkRequest.
    fromReader = function(reader) {
      slug <- reader$tgreadString()
      ResolveBusinessChatLinkRequest$new(slug = slug)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title SaveAutoDownloadSettingsRequest
#  @description R6 class representing a SaveAutoDownloadSettingsRequest.
#  @details This class handles saving auto-download settings with optional low and high flags.
#  @export
#  @noRd
#  @noRd
SaveAutoDownloadSettingsRequest <- R6::R6Class(
  "SaveAutoDownloadSettingsRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SaveAutoDownloadSettingsRequest.
    #  @param settings The auto-download settings.
    #  @param low Optional boolean indicating low quality.
    #  @param high Optional boolean indicating high quality.
    initialize = function(settings, low = NULL, high = NULL) {
      self$settings <- settings
      self$low <- low
      self$high <- high
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SaveAutoDownloadSettingsRequest",
        settings = if (inherits(self$settings, "TLObject")) self$settings$toDict() else self$settings,
        low = self$low,
        high = self$high
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- (if (is.null(self$low) || !self$low) 0 else 1) |
        (if (is.null(self$high) || !self$high) 0 else 2)
      c(
        as.raw(c(0x33, 0x62, 0xf3, 0x76)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        self$settings$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SaveAutoDownloadSettingsRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      low <- bitwAnd(flags, 1) != 0
      high <- bitwAnd(flags, 2) != 0
      settings <- reader$tgreadObject()
      SaveAutoDownloadSettingsRequest$new(settings = settings, low = low, high = high)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title SaveAutoSaveSettingsRequest
#  @description R6 class representing a SaveAutoSaveSettingsRequest.
#  @details This class handles saving auto-save settings with optional flags for users, chats, broadcasts, and a peer.
#  @export
#  @noRd
#  @noRd
SaveAutoSaveSettingsRequest <- R6::R6Class(
  "SaveAutoSaveSettingsRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SaveAutoSaveSettingsRequest.
    #  @param settings The auto-save settings.
    #  @param users Optional boolean indicating if for users.
    #  @param chats Optional boolean indicating if for chats.
    #  @param broadcasts Optional boolean indicating if for broadcasts.
    #  @param peer Optional input peer.
    initialize = function(settings, users = NULL, chats = NULL, broadcasts = NULL, peer = NULL) {
      self$settings <- settings
      self$users <- users
      self$chats <- chats
      self$broadcasts <- broadcasts
      self$peer <- peer
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      if (!is.null(self$peer)) {
        self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
      }
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SaveAutoSaveSettingsRequest",
        settings = if (inherits(self$settings, "TLObject")) self$settings$toDict() else self$settings,
        users = self$users,
        chats = self$chats,
        broadcasts = self$broadcasts,
        peer = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- (if (is.null(self$users) || !self$users) 0 else 1) |
        (if (is.null(self$chats) || !self$chats) 0 else 2) |
        (if (is.null(self$broadcasts) || !self$broadcasts) 0 else 4) |
        (if (is.null(self$peer)) 0 else 8)
      c(
        as.raw(c(0xa1, 0x83, 0x9b, 0xd6)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        if (!is.null(self$peer)) self$peer$bytes() else raw(),
        self$settings$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SaveAutoSaveSettingsRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      users <- bitwAnd(flags, 1) != 0
      chats <- bitwAnd(flags, 2) != 0
      broadcasts <- bitwAnd(flags, 4) != 0
      peer <- if (bitwAnd(flags, 8) != 0) reader$tgreadObject() else NULL
      settings <- reader$tgreadObject()
      SaveAutoSaveSettingsRequest$new(settings = settings, users = users, chats = chats, broadcasts = broadcasts, peer = peer)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title SaveMusicRequest
#  @description R6 class representing a SaveMusicRequest.
#  @details This class handles saving or unsaving music with an optional after ID.
#  @export
#  @noRd
#  @noRd
SaveMusicRequest <- R6::R6Class(
  "SaveMusicRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SaveMusicRequest.
    #  @param id The input document ID.
    #  @param unsave Optional boolean indicating if to unsave.
    #  @param afterId Optional input document for after ID.
    initialize = function(id, unsave = NULL, afterId = NULL) {
      self$id <- id
      self$unsave <- unsave
      self$afterId <- afterId
    },

    #  @description Resolve the ID and after ID using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$id <- utils$getInputDocument(self$id)
      if (!is.null(self$afterId)) {
        self$afterId <- utils$getInputDocument(self$afterId)
      }
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SaveMusicRequest",
        id = if (inherits(self$id, "TLObject")) self$id$toDict() else self$id,
        unsave = self$unsave,
        afterId = if (inherits(self$afterId, "TLObject")) self$afterId$toDict() else self$afterId
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- (if (is.null(self$unsave) || !self$unsave) 0 else 1) |
        (if (is.null(self$afterId)) 0 else 2)
      c(
        as.raw(c(0xa9, 0x32, 0x67, 0xb2)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        self$id$bytes(),
        if (!is.null(self$afterId)) self$afterId$bytes() else raw()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SaveMusicRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      unsave <- bitwAnd(flags, 1) != 0
      id <- reader$tgreadObject()
      afterId <- if (bitwAnd(flags, 2) != 0) reader$tgreadObject() else NULL
      SaveMusicRequest$new(id = id, unsave = unsave, afterId = afterId)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title SaveRingtoneRequest
#  @description R6 class representing a SaveRingtoneRequest.
#  @details This class handles saving or unsaving a ringtone.
#  @export
#  @noRd
#  @noRd
SaveRingtoneRequest <- R6::R6Class(
  "SaveRingtoneRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SaveRingtoneRequest.
    #  @param id The input document ID.
    #  @param unsave Boolean indicating if to unsave.
    initialize = function(id, unsave) {
      self$id <- id
      self$unsave <- unsave
    },

    #  @description Resolve the ID using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$id <- utils$getInputDocument(self$id)
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SaveRingtoneRequest",
        id = if (inherits(self$id, "TLObject")) self$id$toDict() else self$id,
        unsave = self$unsave
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x03, 0x5b, 0xea, 0x3d)),
        self$id$bytes(),
        if (self$unsave) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SaveRingtoneRequest.
    fromReader = function(reader) {
      id <- reader$tgreadObject()
      unsave <- reader$tgreadBool()
      SaveRingtoneRequest$new(id = id, unsave = unsave)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title SaveSecureValueRequest
#  @description R6 class representing a SaveSecureValueRequest.
#  @details This class handles saving a secure value with a secure secret ID.
#  @export
#  @noRd
#  @noRd
SaveSecureValueRequest <- R6::R6Class(
  "SaveSecureValueRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SaveSecureValueRequest.
    #  @param value The input secure value.
    #  @param secureSecretId The secure secret ID.
    initialize = function(value, secureSecretId) {
      self$value <- value
      self$secureSecretId <- secureSecretId
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SaveSecureValueRequest",
        value = if (inherits(self$value, "TLObject")) self$value$toDict() else self$value,
        secureSecretId = self$secureSecretId
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x1d, 0xe3, 0x9f, 0x89)),
        self$value$bytes(),
        writeBin(as.integer(self$secureSecretId), raw(), size = 8, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SaveSecureValueRequest.
    fromReader = function(reader) {
      value <- reader$tgreadObject()
      secureSecretId <- readBin(reader$readRaw(8), "integer", size = 8, endian = "little")
      SaveSecureValueRequest$new(value = value, secureSecretId = secureSecretId)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title SaveThemeRequest
#  @description R6 class representing a SaveThemeRequest.
#  @details This class handles saving or unsaving a theme.
#  @export
#  @noRd
#  @noRd
SaveThemeRequest <- R6::R6Class(
  "SaveThemeRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SaveThemeRequest.
    #  @param theme The input theme.
    #  @param unsave Boolean indicating if to unsave the theme.
    initialize = function(theme, unsave) {
      self$theme <- theme
      self$unsave <- unsave
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SaveThemeRequest",
        theme = if (inherits(self$theme, "TLObject")) self$theme$toDict() else self$theme,
        unsave = self$unsave
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x6c, 0x10, 0x57, 0xf2)),
        self$theme$bytes(),
        if (self$unsave) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SaveThemeRequest.
    fromReader = function(reader) {
      theme <- reader$tgreadObject()
      unsave <- reader$tgreadBool()
      SaveThemeRequest$new(theme = theme, unsave = unsave)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title SaveWallPaperRequest
#  @description R6 class representing a SaveWallPaperRequest.
#  @details This class handles saving or unsaving a wallpaper with settings.
#  @export
#  @noRd
#  @noRd
SaveWallPaperRequest <- R6::R6Class(
  "SaveWallPaperRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SaveWallPaperRequest.
    #  @param wallpaper The input wallpaper.
    #  @param unsave Boolean indicating if to unsave the wallpaper.
    #  @param settings The wallpaper settings.
    initialize = function(wallpaper, unsave, settings) {
      self$wallpaper <- wallpaper
      self$unsave <- unsave
      self$settings <- settings
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SaveWallPaperRequest",
        wallpaper = if (inherits(self$wallpaper, "TLObject")) self$wallpaper$toDict() else self$wallpaper,
        unsave = self$unsave,
        settings = if (inherits(self$settings, "TLObject")) self$settings$toDict() else self$settings
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x37, 0x5b, 0x5a, 0x6c)),
        self$wallpaper$bytes(),
        if (self$unsave) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc)),
        self$settings$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SaveWallPaperRequest.
    fromReader = function(reader) {
      wallpaper <- reader$tgreadObject()
      unsave <- reader$tgreadBool()
      settings <- reader$tgreadObject()
      SaveWallPaperRequest$new(wallpaper = wallpaper, unsave = unsave, settings = settings)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title SendChangePhoneCodeRequest
#  @description R6 class representing a SendChangePhoneCodeRequest.
#  @details This class handles sending a change phone code request with phone number and settings.
#  @export
#  @noRd
#  @noRd
SendChangePhoneCodeRequest <- R6::R6Class(
  "SendChangePhoneCodeRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SendChangePhoneCodeRequest.
    #  @param phoneNumber The phone number string.
    #  @param settings The code settings object.
    initialize = function(phoneNumber, settings) {
      self$phoneNumber <- phoneNumber
      self$settings <- settings
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SendChangePhoneCodeRequest",
        phoneNumber = self$phoneNumber,
        settings = if (inherits(self$settings, "TLObject")) self$settings$toDict() else self$settings
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xe5, 0x4a, 0x57, 0x82)),
        self$serialize_bytes(self$phoneNumber),
        self$settings$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SendChangePhoneCodeRequest.
    fromReader = function(reader) {
      phoneNumber <- reader$tgreadString()
      settings <- reader$tgreadObject()
      SendChangePhoneCodeRequest$new(phoneNumber = phoneNumber, settings = settings)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title SendConfirmPhoneCodeRequest
#  @description R6 class representing a SendConfirmPhoneCodeRequest.
#  @details This class handles sending a confirm phone code request with hash and settings.
#  @export
#  @noRd
#  @noRd
SendConfirmPhoneCodeRequest <- R6::R6Class(
  "SendConfirmPhoneCodeRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SendConfirmPhoneCodeRequest.
    #  @param hash The hash string.
    #  @param settings The code settings object.
    initialize = function(hash, settings) {
      self$hash <- hash
      self$settings <- settings
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SendConfirmPhoneCodeRequest",
        hash = self$hash,
        settings = if (inherits(self$settings, "TLObject")) self$settings$toDict() else self$settings
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x88, 0xaa, 0x3f, 0x1b)),
        self$serialize_bytes(self$hash),
        self$settings$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SendConfirmPhoneCodeRequest.
    fromReader = function(reader) {
      hash <- reader$tgreadString()
      settings <- reader$tgreadObject()
      SendConfirmPhoneCodeRequest$new(hash = hash, settings = settings)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title SendVerifyEmailCodeRequest
#  @description R6 class representing a SendVerifyEmailCodeRequest.
#  @details This class handles sending a verify email code request with purpose and email.
#  @export
#  @noRd
#  @noRd
SendVerifyEmailCodeRequest <- R6::R6Class(
  "SendVerifyEmailCodeRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SendVerifyEmailCodeRequest.
    #  @param purpose The email verify purpose object.
    #  @param email The email string.
    initialize = function(purpose, email) {
      self$purpose <- purpose
      self$email <- email
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SendVerifyEmailCodeRequest",
        purpose = if (inherits(self$purpose, "TLObject")) self$purpose$toDict() else self$purpose,
        email = self$email
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xbb, 0x37, 0xe0, 0x98)),
        self$purpose$bytes(),
        self$serialize_bytes(self$email)
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SendVerifyEmailCodeRequest.
    fromReader = function(reader) {
      purpose <- reader$tgreadObject()
      email <- reader$tgreadString()
      SendVerifyEmailCodeRequest$new(purpose = purpose, email = email)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title SendVerifyPhoneCodeRequest
#  @description R6 class representing a SendVerifyPhoneCodeRequest.
#  @details This class handles sending a verification code to a phone number for verification purposes.
#  @export
#  @noRd
#  @noRd
SendVerifyPhoneCodeRequest <- R6::R6Class(
  "SendVerifyPhoneCodeRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SendVerifyPhoneCodeRequest.
    #  @param phoneNumber The phone number string.
    #  @param settings The code settings object.
    initialize = function(phoneNumber, settings) {
      self$phoneNumber <- phoneNumber
      self$settings <- settings
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SendVerifyPhoneCodeRequest",
        phoneNumber = self$phoneNumber,
        settings = if (inherits(self$settings, "TLObject")) self$settings$toDict() else self$settings
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xa5, 0xa3, 0x56, 0xf9)),
        self$serialize_bytes(self$phoneNumber),
        self$settings$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SendVerifyPhoneCodeRequest.
    fromReader = function(reader) {
      phoneNumber <- reader$tgreadString()
      settings <- reader$tgreadObject()
      SendVerifyPhoneCodeRequest$new(phoneNumber = phoneNumber, settings = settings)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title SetAccountTTLRequest
#  @description R6 class representing a SetAccountTTLRequest.
#  @details This class handles setting the account TTL (time to live) for messages.
#  @export
#  @noRd
#  @noRd
SetAccountTTLRequest <- R6::R6Class(
  "SetAccountTTLRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SetAccountTTLRequest.
    #  @param ttl The account days TTL object.
    initialize = function(ttl) {
      self$ttl <- ttl
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SetAccountTTLRequest",
        ttl = if (inherits(self$ttl, "TLObject")) self$ttl$toDict() else self$ttl
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x24, 0x42, 0x48, 0x5e)),
        self$ttl$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SetAccountTTLRequest.
    fromReader = function(reader) {
      ttl <- reader$tgreadObject()
      SetAccountTTLRequest$new(ttl = ttl)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title SetAuthorizationTTLRequest
#  @description R6 class representing a SetAuthorizationTTLRequest.
#  @details This class handles setting the authorization TTL in days.
#  @export
#  @noRd
#  @noRd
SetAuthorizationTTLRequest <- R6::R6Class(
  "SetAuthorizationTTLRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SetAuthorizationTTLRequest.
    #  @param authorizationTtlDays The authorization TTL in days.
    initialize = function(authorizationTtlDays) {
      self$authorizationTtlDays <- authorizationTtlDays
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SetAuthorizationTTLRequest",
        authorizationTtlDays = self$authorizationTtlDays
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xbf, 0x89, 0x9a, 0xa0)),
        writeBin(as.integer(self$authorizationTtlDays), raw(), size = 4, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SetAuthorizationTTLRequest.
    fromReader = function(reader) {
      authorizationTtlDays <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      SetAuthorizationTTLRequest$new(authorizationTtlDays = authorizationTtlDays)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title SetContactSignUpNotificationRequest
#  @description R6 class representing a SetContactSignUpNotificationRequest.
#  @details This class handles setting contact sign-up notification settings.
#  @export
#  @noRd
#  @noRd
SetContactSignUpNotificationRequest <- R6::R6Class(
  "SetContactSignUpNotificationRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SetContactSignUpNotificationRequest.
    #  @param silent Boolean indicating if notifications are silent.
    initialize = function(silent) {
      self$silent <- silent
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SetContactSignUpNotificationRequest",
        silent = self$silent
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xcf, 0xf4, 0x3f, 0x61)),
        if (self$silent) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SetContactSignUpNotificationRequest.
    fromReader = function(reader) {
      silent <- reader$tgreadBool()
      SetContactSignUpNotificationRequest$new(silent = silent)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title SetContentSettingsRequest
#  @description R6 class representing a SetContentSettingsRequest.
#  @details This class handles setting content settings, such as sensitive content enabled.
#  @export
#  @noRd
#  @noRd
SetContentSettingsRequest <- R6::R6Class(
  "SetContentSettingsRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SetContentSettingsRequest.
    #  @param sensitiveEnabled Optional boolean indicating if sensitive content is enabled.
    initialize = function(sensitiveEnabled = NULL) {
      self$sensitiveEnabled <- sensitiveEnabled
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SetContentSettingsRequest",
        sensitiveEnabled = self$sensitiveEnabled
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- if (is.null(self$sensitiveEnabled) || !self$sensitiveEnabled) 0 else 1
      c(
        as.raw(c(0xb5, 0x74, 0xb1, 0x6b)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SetContentSettingsRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      sensitiveEnabled <- bitwAnd(flags, 1) != 0
      SetContentSettingsRequest$new(sensitiveEnabled = sensitiveEnabled)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title SetGlobalPrivacySettingsRequest
#  @description R6 class representing a SetGlobalPrivacySettingsRequest.
#  @details This class handles setting global privacy settings.
#  @export
#  @noRd
#  @noRd
SetGlobalPrivacySettingsRequest <- R6::R6Class(
  "SetGlobalPrivacySettingsRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SetGlobalPrivacySettingsRequest.
    #  @param settings The global privacy settings.
    initialize = function(settings) {
      self$settings <- settings
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SetGlobalPrivacySettingsRequest",
        settings = if (inherits(self$settings, "TLObject")) self$settings$toDict() else self$settings
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x1e, 0xda, 0xaa, 0xc2)),
        self$settings$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SetGlobalPrivacySettingsRequest.
    fromReader = function(reader) {
      settings <- reader$tgreadObject()
      SetGlobalPrivacySettingsRequest$new(settings = settings)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title SetMainProfileTabRequest
#  @description R6 class representing a SetMainProfileTabRequest.
#  @details This class handles setting the main profile tab.
#  @export
#  @noRd
#  @noRd
SetMainProfileTabRequest <- R6::R6Class(
  "SetMainProfileTabRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SetMainProfileTabRequest.
    #  @param tab The profile tab.
    initialize = function(tab) {
      self$tab <- tab
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SetMainProfileTabRequest",
        tab = if (inherits(self$tab, "TLObject")) self$tab$toDict() else self$tab
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xb0, 0x78, 0xee, 0x5d)),
        self$tab$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SetMainProfileTabRequest.
    fromReader = function(reader) {
      tab <- reader$tgreadObject()
      SetMainProfileTabRequest$new(tab = tab)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title SetPrivacyRequest
#  @description R6 class representing a SetPrivacyRequest.
#  @details This class handles setting privacy rules for a key.
#  @export
#  @noRd
#  @noRd
SetPrivacyRequest <- R6::R6Class(
  "SetPrivacyRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SetPrivacyRequest.
    #  @param key The input privacy key.
    #  @param rules List of input privacy rules.
    initialize = function(key, rules) {
      self$key <- key
      self$rules <- rules
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SetPrivacyRequest",
        key = if (inherits(self$key, "TLObject")) self$key$toDict() else self$key,
        rules = if (is.null(self$rules)) list() else lapply(self$rules, function(x) if (inherits(x, "TLObject")) x$toDict() else x)
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xe8, 0x1c, 0xf8, 0xc9)),
        self$key$bytes(),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        writeBin(as.integer(length(self$rules)), raw(), size = 4, endian = "little"),
        do.call(c, lapply(self$rules, function(x) x$bytes()))
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SetPrivacyRequest.
    fromReader = function(reader) {
      key <- reader$tgreadObject()
      reader$readInt()
      rules <- list()
      for (i in seq_len(reader$readInt())) {
        x <- reader$tgreadObject()
        rules <- c(rules, list(x))
      }
      SetPrivacyRequest$new(key = key, rules = rules)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title SetReactionsNotifySettingsRequest
#  @description R6 class representing a SetReactionsNotifySettingsRequest.
#  @details This class handles setting reactions notify settings.
#  @export
#  @noRd
#  @noRd
SetReactionsNotifySettingsRequest <- R6::R6Class(
  "SetReactionsNotifySettingsRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the SetReactionsNotifySettingsRequest.
    #  @param settings The reactions notify settings.
    initialize = function(settings) {
      self$settings <- settings
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "SetReactionsNotifySettingsRequest",
        settings = if (inherits(self$settings, "TLObject")) self$settings$toDict() else self$settings
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x48, 0xe5, 0x6c, 0x31)),
        self$settings$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of SetReactionsNotifySettingsRequest.
    fromReader = function(reader) {
      settings <- reader$tgreadObject()
      SetReactionsNotifySettingsRequest$new(settings = settings)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title ToggleConnectedBotPausedRequest
#  @description R6 class representing a ToggleConnectedBotPausedRequest.
#  @details This class handles toggling the paused state of a connected bot for a peer.
#  @export
#  @noRd
#  @noRd
ToggleConnectedBotPausedRequest <- R6::R6Class(
  "ToggleConnectedBotPausedRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the ToggleConnectedBotPausedRequest.
    #  @param peer The input peer.
    #  @param paused Boolean indicating if the bot is paused.
    initialize = function(peer, paused) {
      self$peer <- peer
      self$paused <- paused
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$getInputPeer(client$getInputEntity(self$peer))
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ToggleConnectedBotPausedRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        paused = self$paused
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x97, 0x10, 0x6e, 0x64)),
        self$peer$bytes(),
        if (self$paused) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ToggleConnectedBotPausedRequest.
    fromReader = function(reader) {
      peer <- reader$tgreadObject()
      paused <- reader$tgreadBool()
      ToggleConnectedBotPausedRequest$new(peer = peer, paused = paused)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title ToggleNoPaidMessagesExceptionRequest
#  @description R6 class representing a ToggleNoPaidMessagesExceptionRequest.
#  @details This class handles toggling the no paid messages exception for a user.
#  @export
#  @noRd
#  @noRd
ToggleNoPaidMessagesExceptionRequest <- R6::R6Class(
  "ToggleNoPaidMessagesExceptionRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the ToggleNoPaidMessagesExceptionRequest.
    #  @param userId The input user ID.
    #  @param refundCharged Optional boolean for refund charged.
    #  @param requirePayment Optional boolean for require payment.
    #  @param parentPeer Optional input parent peer.
    initialize = function(userId, refundCharged = NULL, requirePayment = NULL, parentPeer = NULL) {
      self$userId <- userId
      self$refundCharged <- refundCharged
      self$requirePayment <- requirePayment
      self$parentPeer <- parentPeer
    },

    #  @description Resolve the user ID and parent peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$userId <- utils$getInputUser(client$getInputEntity(self$userId))
      if (!is.null(self$parentPeer)) {
        self$parentPeer <- utils$getInputPeer(client$getInputEntity(self$parentPeer))
      }
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ToggleNoPaidMessagesExceptionRequest",
        userId = if (inherits(self$userId, "TLObject")) self$userId$toDict() else self$userId,
        refundCharged = self$refundCharged,
        requirePayment = self$requirePayment,
        parentPeer = if (inherits(self$parentPeer, "TLObject")) self$parentPeer$toDict() else self$parentPeer
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- (if (is.null(self$refundCharged) || !self$refundCharged) 0 else 1) |
        (if (is.null(self$requirePayment) || !self$requirePayment) 0 else 4) |
        (if (is.null(self$parentPeer)) 0 else 2)
      c(
        as.raw(c(0x76, 0xda, 0x2e, 0xfe)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        if (!is.null(self$parentPeer)) self$parentPeer$bytes() else raw(),
        self$userId$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ToggleNoPaidMessagesExceptionRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      refundCharged <- bitwAnd(flags, 1) != 0
      requirePayment <- bitwAnd(flags, 4) != 0
      parentPeer <- if (bitwAnd(flags, 2) != 0) reader$tgreadObject() else NULL
      userId <- reader$tgreadObject()
      ToggleNoPaidMessagesExceptionRequest$new(userId = userId, refundCharged = refundCharged, requirePayment = requirePayment, parentPeer = parentPeer)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title ToggleSponsoredMessagesRequest
#  @description R6 class representing a ToggleSponsoredMessagesRequest.
#  @details This class handles toggling sponsored messages.
#  @export
#  @noRd
#  @noRd
ToggleSponsoredMessagesRequest <- R6::R6Class(
  "ToggleSponsoredMessagesRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the ToggleSponsoredMessagesRequest.
    #  @param enabled Boolean indicating if sponsored messages are enabled.
    initialize = function(enabled) {
      self$enabled <- enabled
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ToggleSponsoredMessagesRequest",
        enabled = self$enabled
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x8d, 0xa3, 0xd9, 0xb9)),
        if (self$enabled) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ToggleSponsoredMessagesRequest.
    fromReader = function(reader) {
      enabled <- reader$tgreadBool()
      ToggleSponsoredMessagesRequest$new(enabled = enabled)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title ToggleUsernameRequest
#  @description R6 class representing a ToggleUsernameRequest.
#  @details This class handles toggling the active status of a username.
#  @export
#  @noRd
#  @noRd
ToggleUsernameRequest <- R6::R6Class(
  "ToggleUsernameRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the ToggleUsernameRequest.
    #  @param username The username string.
    #  @param active Boolean indicating if the username is active.
    initialize = function(username, active) {
      self$username <- username
      self$active <- active
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "ToggleUsernameRequest",
        username = self$username,
        active = self$active
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x76, 0xb3, 0xd6, 0x58)),
        self$serialize_bytes(self$username),
        if (self$active) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of ToggleUsernameRequest.
    fromReader = function(reader) {
      username <- reader$tgreadString()
      active <- reader$tgreadBool()
      ToggleUsernameRequest$new(username = username, active = active)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title UnregisterDeviceRequest
#  @description R6 class representing an UnregisterDeviceRequest.
#  @details This class handles unregistering a device with token details and other UIDs.
#  @export
#  @noRd
#  @noRd
UnregisterDeviceRequest <- R6::R6Class(
  "UnregisterDeviceRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UnregisterDeviceRequest.
    #  @param tokenType The token type integer.
    #  @param token The token string.
    #  @param otherUids List of other user IDs.
    initialize = function(tokenType, token, otherUids) {
      self$tokenType <- tokenType
      self$token <- token
      self$otherUids <- otherUids
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UnregisterDeviceRequest",
        tokenType = self$tokenType,
        token = self$token,
        otherUids = if (is.null(self$otherUids)) list() else self$otherUids
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x06, 0x32, 0x0d, 0x6a)),
        writeBin(as.integer(self$tokenType), raw(), size = 4, endian = "little"),
        self$serialize_bytes(self$token),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        writeBin(as.integer(length(self$otherUids)), raw(), size = 4, endian = "little"),
        do.call(c, lapply(self$otherUids, function(x) writeBin(as.numeric(x), raw(), size = 8, endian = "little")))
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UnregisterDeviceRequest.
    fromReader = function(reader) {
      tokenType <- reader$readInt()
      token <- reader$tgreadString()
      reader$readInt()
      otherUids <- list()
      for (i in seq_len(reader$readInt())) {
        x <- reader$readLong()
        otherUids <- c(otherUids, x)
      }
      UnregisterDeviceRequest$new(tokenType = tokenType, token = token, otherUids = otherUids)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title UpdateBirthdayRequest
#  @description R6 class representing an UpdateBirthdayRequest.
#  @details This class handles updating the user's birthday.
#  @export
#  @noRd
#  @noRd
UpdateBirthdayRequest <- R6::R6Class(
  "UpdateBirthdayRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UpdateBirthdayRequest.
    #  @param birthday Optional birthday object.
    initialize = function(birthday = NULL) {
      self$birthday <- birthday
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UpdateBirthdayRequest",
        birthday = if (inherits(self$birthday, "TLObject")) self$birthday$toDict() else self$birthday
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- if (is.null(self$birthday)) 0 else 1
      c(
        as.raw(c(0x11, 0x0c, 0x6e, 0xcc)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        if (!is.null(self$birthday)) self$birthday$bytes() else raw()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UpdateBirthdayRequest.
    fromReader = function(reader) {
      flags <- reader$readInt()
      birthday <- if (bitwAnd(flags, 1) != 0) reader$tgreadObject() else NULL
      UpdateBirthdayRequest$new(birthday = birthday)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title UpdateBusinessAwayMessageRequest
#  @description R6 class representing an UpdateBusinessAwayMessageRequest.
#  @details This class handles updating the business away message with an optional input business away message.
#  @export
#  @noRd
#  @noRd
UpdateBusinessAwayMessageRequest <- R6::R6Class(
  "UpdateBusinessAwayMessageRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UpdateBusinessAwayMessageRequest.
    #  @param message Optional input business away message.
    initialize = function(message = NULL) {
      self$message <- message
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UpdateBusinessAwayMessageRequest",
        message = if (inherits(self$message, "TLObject")) self$message$toDict() else self$message
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- if (is.null(self$message)) 0 else 1
      c(
        as.raw(c(0xa5, 0x7f, 0x6a, 0xa2)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        if (!is.null(self$message)) self$message$bytes() else raw()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UpdateBusinessAwayMessageRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      message <- if (bitwAnd(flags, 1) != 0) reader$tgreadObject() else NULL
      UpdateBusinessAwayMessageRequest$new(message = message)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title UpdateBusinessGreetingMessageRequest
#  @description R6 class representing an UpdateBusinessGreetingMessageRequest.
#  @details This class handles updating the business greeting message with an optional input business greeting message.
#  @export
#  @noRd
#  @noRd
UpdateBusinessGreetingMessageRequest <- R6::R6Class(
  "UpdateBusinessGreetingMessageRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UpdateBusinessGreetingMessageRequest.
    #  @param message Optional input business greeting message.
    initialize = function(message = NULL) {
      self$message <- message
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UpdateBusinessGreetingMessageRequest",
        message = if (inherits(self$message, "TLObject")) self$message$toDict() else self$message
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- if (is.null(self$message)) 0 else 1
      c(
        as.raw(c(0xc4, 0xaf, 0xcd, 0x66)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        if (!is.null(self$message)) self$message$bytes() else raw()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UpdateBusinessGreetingMessageRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      message <- if (bitwAnd(flags, 1) != 0) reader$tgreadObject() else NULL
      UpdateBusinessGreetingMessageRequest$new(message = message)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title UpdateBusinessIntroRequest
#  @description R6 class representing an UpdateBusinessIntroRequest.
#  @details This class handles updating the business intro with an optional input business intro.
#  @export
#  @noRd
#  @noRd
UpdateBusinessIntroRequest <- R6::R6Class(
  "UpdateBusinessIntroRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UpdateBusinessIntroRequest.
    #  @param intro Optional input business intro.
    initialize = function(intro = NULL) {
      self$intro <- intro
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UpdateBusinessIntroRequest",
        intro = if (inherits(self$intro, "TLObject")) self$intro$toDict() else self$intro
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- if (is.null(self$intro)) 0 else 1
      c(
        as.raw(c(0x34, 0xd0, 0x14, 0xa6)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        if (!is.null(self$intro)) self$intro$bytes() else raw()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UpdateBusinessIntroRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      intro <- if (bitwAnd(flags, 1) != 0) reader$tgreadObject() else NULL
      UpdateBusinessIntroRequest$new(intro = intro)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title UpdateBusinessLocationRequest
#  @description R6 class representing an UpdateBusinessLocationRequest.
#  @details This class handles updating the business location with optional geo point and address.
#  @export
#  @noRd
#  @noRd
UpdateBusinessLocationRequest <- R6::R6Class(
  "UpdateBusinessLocationRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UpdateBusinessLocationRequest.
    #  @param geoPoint Optional input geo point.
    #  @param address Optional address string.
    initialize = function(geoPoint = NULL, address = NULL) {
      self$geoPoint <- geoPoint
      self$address <- address
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UpdateBusinessLocationRequest",
        geoPoint = if (inherits(self$geoPoint, "TLObject")) self$geoPoint$toDict() else self$geoPoint,
        address = self$address
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- (if (is.null(self$geoPoint)) 0 else 2) | (if (is.null(self$address) || !nzchar(self$address)) 0 else 1)
      c(
        as.raw(c(0x1a, 0x13, 0x6b, 0x9e)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        if (!is.null(self$geoPoint)) self$geoPoint$bytes() else raw(),
        if (!is.null(self$address) && nzchar(self$address)) self$serialize_bytes(self$address) else raw()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UpdateBusinessLocationRequest.
    fromReader = function(reader) {
      flags <- reader$readInt()
      geoPoint <- if (bitwAnd(flags, 2) != 0) reader$tgreadObject() else NULL
      address <- if (bitwAnd(flags, 1) != 0) reader$tgreadString() else NULL
      UpdateBusinessLocationRequest$new(geoPoint = geoPoint, address = address)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title UpdateBusinessWorkHoursRequest
#  @description R6 class representing an UpdateBusinessWorkHoursRequest.
#  @details This class handles updating the business work hours.
#  @export
#  @noRd
#  @noRd
UpdateBusinessWorkHoursRequest <- R6::R6Class(
  "UpdateBusinessWorkHoursRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UpdateBusinessWorkHoursRequest.
    #  @param businessWorkHours Optional business work hours.
    initialize = function(businessWorkHours = NULL) {
      self$businessWorkHours <- businessWorkHours
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UpdateBusinessWorkHoursRequest",
        businessWorkHours = if (inherits(self$businessWorkHours, "TLObject")) self$businessWorkHours$toDict() else self$businessWorkHours
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- if (is.null(self$businessWorkHours)) 0 else 1
      c(
        as.raw(c(0x66, 0xe0, 0x00, 0x4b)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        if (!is.null(self$businessWorkHours)) self$businessWorkHours$bytes() else raw()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UpdateBusinessWorkHoursRequest.
    fromReader = function(reader) {
      flags <- reader$readInt()
      businessWorkHours <- if (bitwAnd(flags, 1) != 0) reader$tgreadObject() else NULL
      UpdateBusinessWorkHoursRequest$new(businessWorkHours = businessWorkHours)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title UpdateColorRequest
#  @description R6 class representing an UpdateColorRequest.
#  @details This class handles updating the color settings with optional profile flag, color, and background emoji ID.
#  @export
#  @noRd
#  @noRd
UpdateColorRequest <- R6::R6Class(
  "UpdateColorRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UpdateColorRequest.
    #  @param forProfile Optional boolean indicating if for profile.
    #  @param color Optional color integer.
    #  @param backgroundEmojiId Optional background emoji ID.
    initialize = function(forProfile = NULL, color = NULL, backgroundEmojiId = NULL) {
      self$forProfile <- forProfile
      self$color <- color
      self$backgroundEmojiId <- backgroundEmojiId
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UpdateColorRequest",
        forProfile = self$forProfile,
        color = self$color,
        backgroundEmojiId = self$backgroundEmojiId
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- (if (is.null(self$forProfile) || !self$forProfile) 0 else 2) | (if (is.null(self$color)) 0 else 4) | (if (is.null(self$backgroundEmojiId)) 0 else 1)
      c(
        as.raw(c(0x5d, 0xa1, 0xef, 0x7c)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        if (!is.null(self$color)) writeBin(as.integer(self$color), raw(), size = 4, endian = "little") else raw(),
        if (!is.null(self$backgroundEmojiId)) writeBin(as.integer(self$backgroundEmojiId), raw(), size = 8, endian = "little") else raw()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UpdateColorRequest.
    fromReader = function(reader) {
      flags <- reader$readInt()
      forProfile <- bitwAnd(flags, 2) != 0
      color <- if (bitwAnd(flags, 4) != 0) reader$readInt() else NULL
      backgroundEmojiId <- if (bitwAnd(flags, 1) != 0) reader$readLong() else NULL
      UpdateColorRequest$new(forProfile = forProfile, color = color, backgroundEmojiId = backgroundEmojiId)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title UpdateConnectedBotRequest
#  @description R6 class representing an UpdateConnectedBotRequest.
#  @details This class handles updating a connected bot with recipients, deletion status, and rights.
#  @export
#  @noRd
#  @noRd
UpdateConnectedBotRequest <- R6::R6Class(
  "UpdateConnectedBotRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UpdateConnectedBotRequest.
    #  @param bot The input user for the bot.
    #  @param recipients The input business bot recipients.
    #  @param deleted Optional boolean indicating if deleted.
    #  @param rights Optional business bot rights.
    initialize = function(bot, recipients, deleted = NULL, rights = NULL) {
      self$bot <- bot
      self$recipients <- recipients
      self$deleted <- deleted
      self$rights <- rights
    },

    #  @description Resolve the bot using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$bot <- utils$getInputUser(client$getInputEntity(self$bot))
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UpdateConnectedBotRequest",
        bot = if (inherits(self$bot, "TLObject")) self$bot$toDict() else self$bot,
        recipients = if (inherits(self$recipients, "TLObject")) self$recipients$toDict() else self$recipients,
        deleted = self$deleted,
        rights = if (inherits(self$rights, "TLObject")) self$rights$toDict() else self$rights
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- (if (is.null(self$deleted) || !self$deleted) 0 else 2) |
        (if (is.null(self$rights)) 0 else 1)
      c(
        as.raw(c(0x7e, 0x8c, 0xa0, 0x66)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        if (!is.null(self$rights)) self$rights$bytes() else raw(),
        self$bot$bytes(),
        self$recipients$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UpdateConnectedBotRequest.
    fromReader = function(reader) {
      flags <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      deleted <- bitwAnd(flags, 2) != 0
      rights <- if (bitwAnd(flags, 1) != 0) reader$tgreadObject() else NULL
      bot <- reader$tgreadObject()
      recipients <- reader$tgreadObject()
      UpdateConnectedBotRequest$new(bot = bot, recipients = recipients, deleted = deleted, rights = rights)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title UpdateDeviceLockedRequest
#  @description R6 class representing an UpdateDeviceLockedRequest.
#  @details This class handles updating the device locked period.
#  @export
#  @noRd
#  @noRd
UpdateDeviceLockedRequest <- R6::R6Class(
  "UpdateDeviceLockedRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UpdateDeviceLockedRequest.
    #  @param period The lock period in seconds.
    initialize = function(period) {
      self$period <- period
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UpdateDeviceLockedRequest",
        period = self$period
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x32, 0x35, 0xdf, 0x38)),
        writeBin(as.integer(self$period), raw(), size = 4, endian = "little")
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UpdateDeviceLockedRequest.
    fromReader = function(reader) {
      period <- readBin(reader$readRaw(4), "integer", size = 4, endian = "little")
      UpdateDeviceLockedRequest$new(period = period)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title UpdateEmojiStatusRequest
#  @description R6 class representing an UpdateEmojiStatusRequest.
#  @details This class handles updating the emoji status.
#  @export
#  @noRd
#  @noRd
UpdateEmojiStatusRequest <- R6::R6Class(
  "UpdateEmojiStatusRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UpdateEmojiStatusRequest.
    #  @param emojiStatus The emoji status.
    initialize = function(emojiStatus) {
      self$emojiStatus <- emojiStatus
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UpdateEmojiStatusRequest",
        emojiStatus = if (inherits(self$emojiStatus, "TLObject")) self$emojiStatus$toDict() else self$emojiStatus
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x6b, 0xde, 0xd3, 0xfb)),
        self$emojiStatus$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UpdateEmojiStatusRequest.
    fromReader = function(reader) {
      emojiStatus <- reader$tgreadObject()
      UpdateEmojiStatusRequest$new(emojiStatus = emojiStatus)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title UpdateNotifySettingsRequest
#  @description R6 class representing an UpdateNotifySettingsRequest.
#  @details This class handles updating notification settings for a peer.
#  @export
#  @noRd
#  @noRd
UpdateNotifySettingsRequest <- R6::R6Class(
  "UpdateNotifySettingsRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UpdateNotifySettingsRequest.
    #  @param peer The input notify peer.
    #  @param settings The input peer notify settings.
    initialize = function(peer, settings) {
      self$peer <- peer
      self$settings <- settings
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- client$getInputNotify(self$peer)
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UpdateNotifySettingsRequest",
        peer = if (inherits(self$peer, "TLObject")) self$peer$toDict() else self$peer,
        settings = if (inherits(self$settings, "TLObject")) self$settings$toDict() else self$settings
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x93, 0x5b, 0xbe, 0x84)),
        self$peer$bytes(),
        self$settings$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UpdateNotifySettingsRequest.
    fromReader = function(reader) {
      peer <- reader$tgreadObject()
      settings <- reader$tgreadObject()
      UpdateNotifySettingsRequest$new(peer = peer, settings = settings)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title UpdatePasswordSettingsRequest
#  @description R6 class representing an UpdatePasswordSettingsRequest.
#  @details This class handles updating password settings.
#  @export
#  @noRd
#  @noRd
UpdatePasswordSettingsRequest <- R6::R6Class(
  "UpdatePasswordSettingsRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UpdatePasswordSettingsRequest.
    #  @param password The input check password SRP.
    #  @param newSettings The new password input settings.
    initialize = function(password, newSettings) {
      self$password <- password
      self$newSettings <- newSettings
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UpdatePasswordSettingsRequest",
        password = if (inherits(self$password, "TLObject")) self$password$toDict() else self$password,
        newSettings = if (inherits(self$newSettings, "TLObject")) self$newSettings$toDict() else self$newSettings
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x2f, 0x10, 0x9b, 0xa5)),
        self$password$bytes(),
        self$newSettings$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UpdatePasswordSettingsRequest.
    fromReader = function(reader) {
      password <- reader$tgreadObject()
      newSettings <- reader$tgreadObject()
      UpdatePasswordSettingsRequest$new(password = password, newSettings = newSettings)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title UpdatePersonalChannelRequest
#  @description R6 class representing an UpdatePersonalChannelRequest.
#  @details This class handles updating the personal channel.
#  @export
#  @noRd
#  @noRd
UpdatePersonalChannelRequest <- R6::R6Class(
  "UpdatePersonalChannelRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UpdatePersonalChannelRequest.
    #  @param channel The input channel.
    initialize = function(channel) {
      self$channel <- channel
    },

    #  @description Resolve the channel using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$channel <- utils$getInputChannel(client$getInputEntity(self$channel))
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UpdatePersonalChannelRequest",
        channel = if (inherits(self$channel, "TLObject")) self$channel$toDict() else self$channel
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xe0, 0x05, 0x43, 0xd9)),
        self$channel$bytes()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UpdatePersonalChannelRequest.
    fromReader = function(reader) {
      channel <- reader$tgreadObject()
      UpdatePersonalChannelRequest$new(channel = channel)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title UpdateProfileRequest
#  @description R6 class representing an UpdateProfileRequest.
#  @details This class handles updating the user profile information.
#  @export
#  @noRd
#  @noRd
UpdateProfileRequest <- R6::R6Class(
  "UpdateProfileRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UpdateProfileRequest.
    #  @param firstName Optional first name string.
    #  @param lastName Optional last name string.
    #  @param about Optional about string.
    initialize = function(firstName = NULL, lastName = NULL, about = NULL) {
      self$firstName <- firstName
      self$lastName <- lastName
      self$about <- about
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UpdateProfileRequest",
        firstName = self$firstName,
        lastName = self$lastName,
        about = self$about
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- (if (is.null(self$firstName) || !nzchar(self$firstName)) 0 else 1) |
        (if (is.null(self$lastName) || !nzchar(self$lastName)) 0 else 2) |
        (if (is.null(self$about) || !nzchar(self$about)) 0 else 4)
      c(
        as.raw(c(0x75, 0x57, 0x51, 0x78)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        if (!is.null(self$firstName) && nzchar(self$firstName)) self$serialize_bytes(self$firstName) else raw(),
        if (!is.null(self$lastName) && nzchar(self$lastName)) self$serialize_bytes(self$lastName) else raw(),
        if (!is.null(self$about) && nzchar(self$about)) self$serialize_bytes(self$about) else raw()
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UpdateProfileRequest.
    fromReader = function(reader) {
      flags <- reader$readInt()
      firstName <- if (bitwAnd(flags, 1) != 0) reader$tgreadString() else NULL
      lastName <- if (bitwAnd(flags, 2) != 0) reader$tgreadString() else NULL
      about <- if (bitwAnd(flags, 4) != 0) reader$tgreadString() else NULL
      UpdateProfileRequest$new(firstName = firstName, lastName = lastName, about = about)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title UpdateStatusRequest
#  @description R6 class representing an UpdateStatusRequest.
#  @details This class handles updating the user status (online/offline).
#  @export
#  @noRd
#  @noRd
UpdateStatusRequest <- R6::R6Class(
  "UpdateStatusRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UpdateStatusRequest.
    #  @param offline Boolean indicating if the user is offline.
    initialize = function(offline) {
      self$offline <- offline
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UpdateStatusRequest",
        offline = self$offline
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x2c, 0x56, 0x28, 0x66)),
        if (self$offline) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UpdateStatusRequest.
    fromReader = function(reader) {
      offline <- reader$tgreadBool()
      UpdateStatusRequest$new(offline = offline)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title UpdateThemeRequest
#  @description R6 class representing an UpdateThemeRequest.
#  @details This class handles updating a theme.
#  @export
#  @noRd
#  @noRd
UpdateThemeRequest <- R6::R6Class(
  "UpdateThemeRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UpdateThemeRequest.
    #  @param format The format string.
    #  @param theme The input theme.
    #  @param slug Optional slug string.
    #  @param title Optional title string.
    #  @param document Optional input document.
    #  @param settings Optional list of input theme settings.
    initialize = function(format, theme, slug = NULL, title = NULL, document = NULL, settings = NULL) {
      self$format <- format
      self$theme <- theme
      self$slug <- slug
      self$title <- title
      self$document <- document
      self$settings <- settings
    },

    #  @description Resolve the document using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      if (!is.null(self$document)) {
        self$document <- utils$getInputDocument(self$document)
      }
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UpdateThemeRequest",
        format = self$format,
        theme = if (inherits(self$theme, "TLObject")) self$theme$toDict() else self$theme,
        slug = self$slug,
        title = self$title,
        document = if (inherits(self$document, "TLObject")) self$document$toDict() else self$document,
        settings = if (is.null(self$settings)) list() else lapply(self$settings, function(x) if (inherits(x, "TLObject")) x$toDict() else x)
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- (if (is.null(self$slug) || !nzchar(self$slug)) 0 else 1) |
        (if (is.null(self$title) || !nzchar(self$title)) 0 else 2) |
        (if (is.null(self$document)) 0 else 4) |
        (if (is.null(self$settings)) 0 else 8)
      settingsBytes <- if (!is.null(self$settings)) {
        c(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), writeBin(as.integer(length(self$settings)), raw(), size = 4, endian = "little"), do.call(c, lapply(self$settings, function(x) x$bytes())))
      } else {
        raw()
      }
      c(
        as.raw(c(0xcc, 0x0c, 0xf4, 0x2b)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        self$serialize_bytes(self$format),
        self$theme$bytes(),
        if (!is.null(self$slug) && nzchar(self$slug)) self$serialize_bytes(self$slug) else raw(),
        if (!is.null(self$title) && nzchar(self$title)) self$serialize_bytes(self$title) else raw(),
        if (!is.null(self$document)) self$document$bytes() else raw(),
        settingsBytes
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UpdateThemeRequest.
    fromReader = function(reader) {
      flags <- reader$readInt()
      format <- reader$tgreadString()
      theme <- reader$tgreadObject()
      slug <- if (bitwAnd(flags, 1) != 0) reader$tgreadString() else NULL
      title <- if (bitwAnd(flags, 2) != 0) reader$tgreadString() else NULL
      document <- if (bitwAnd(flags, 4) != 0) reader$tgreadObject() else NULL
      settings <- if (bitwAnd(flags, 8) != 0) {
        reader$readInt()
        lapply(seq_len(reader$readInt()), function(i) reader$tgreadObject())
      } else {
        NULL
      }
      UpdateThemeRequest$new(format = format, theme = theme, slug = slug, title = title, document = document, settings = settings)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title UpdateUsernameRequest
#  @description R6 class representing an UpdateUsernameRequest.
#  @details This class handles updating the username.
#  @export
#  @noRd
#  @noRd
UpdateUsernameRequest <- R6::R6Class(
  "UpdateUsernameRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UpdateUsernameRequest.
    #  @param username The username string.
    initialize = function(username) {
      self$username <- username
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UpdateUsernameRequest",
        username = self$username
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x3e, 0x0b, 0xdd, 0x7c)),
        self$serialize_bytes(self$username)
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UpdateUsernameRequest.
    fromReader = function(reader) {
      username <- reader$tgreadString()
      UpdateUsernameRequest$new(username = username)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title UploadRingtoneRequest
#  @description R6 class representing an UploadRingtoneRequest.
#  @details This class handles uploading a ringtone.
#  @export
#  @noRd
#  @noRd
UploadRingtoneRequest <- R6::R6Class(
  "UploadRingtoneRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UploadRingtoneRequest.
    #  @param file The input file.
    #  @param fileName The file name.
    #  @param mimeType The MIME type.
    initialize = function(file, fileName, mimeType) {
      self$file <- file
      self$fileName <- fileName
      self$mimeType <- mimeType
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UploadRingtoneRequest",
        file = if (inherits(self$file, "TLObject")) self$file$toDict() else self$file,
        fileName = self$fileName,
        mimeType = self$mimeType
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x83, 0x1a, 0x83, 0xa2)),
        self$file$bytes(),
        self$serialize_bytes(self$fileName),
        self$serialize_bytes(self$mimeType)
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UploadRingtoneRequest.
    fromReader = function(reader) {
      file <- reader$tgreadObject()
      fileName <- reader$tgreadString()
      mimeType <- reader$tgreadString()
      UploadRingtoneRequest$new(file = file, fileName = fileName, mimeType = mimeType)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title UploadThemeRequest
#  @description R6 class representing an UploadThemeRequest.
#  @details This class handles uploading a theme.
#  @export
#  @noRd
#  @noRd
UploadThemeRequest <- R6::R6Class(
  "UploadThemeRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UploadThemeRequest.
    #  @param file The input file.
    #  @param fileName The file name.
    #  @param mimeType The MIME type.
    #  @param thumb Optional thumbnail file.
    initialize = function(file, fileName, mimeType, thumb = NULL) {
      self$file <- file
      self$fileName <- fileName
      self$mimeType <- mimeType
      self$thumb <- thumb
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UploadThemeRequest",
        file = if (inherits(self$file, "TLObject")) self$file$toDict() else self$file,
        fileName = self$fileName,
        mimeType = self$mimeType,
        thumb = if (inherits(self$thumb, "TLObject")) self$thumb$toDict() else self$thumb
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      flags <- if (is.null(self$thumb) || !self$thumb) 0 else 1
      c(
        as.raw(c(0x1c, 0x3d, 0xb3, 0x33)),
        writeBin(as.integer(flags), raw(), size = 4, endian = "little"),
        self$file$bytes(),
        if (!is.null(self$thumb) && self$thumb) self$thumb$bytes() else raw(),
        self$serialize_bytes(self$fileName),
        self$serialize_bytes(self$mimeType)
      )
    },

    #  @description Create from reader.
    #  @param reader The reader object.
    #  @return An instance of UploadThemeRequest.
    fromReader = function(reader) {
      flags <- reader$readInt()
      file <- reader$tgreadObject()
      thumb <- if (bitwAnd(flags, 1) != 0) reader$tgreadObject() else NULL
      fileName <- reader$tgreadString()
      mimeType <- reader$tgreadString()
      UploadThemeRequest$new(file = file, fileName = fileName, mimeType = mimeType, thumb = thumb)
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)


#  @title UploadWallPaperRequest
#  @description R6 class representing an UploadWallPaperRequest.
#  @details This class handles uploading a wallpaper with specified settings.
#  @export
#  @noRd
#  @noRd
UploadWallPaperRequest <- R6::R6Class(
  "UploadWallPaperRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the UploadWallPaperRequest.
    #  @param file The input file.
    #  @param mimeType The MIME type of the file.
    #  @param settings The wallpaper settings.
    #  @param forChat Optional boolean indicating if for chat.
    initialize = function(file, mimeType, settings, forChat = NULL) {
      self$file <- file
      self$mimeType <- mimeType
      self$settings <- settings
      self$forChat <- forChat
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "UploadWallPaperRequest",
        file = if (inherits(self$file, "TLObject")) self$file$toDict() else self$file,
        mimeType = self$mimeType,
        settings = if (inherits(self$settings, "TLObject")) self$settings$toDict() else self$settings,
        forChat = self$forChat
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0x03, 0x8f, 0x9a, 0xe3)),
        writeBin(as.integer(if (is.null(self$forChat) || !self$forChat) 0 else 1), raw(), size = 4, endian = "little"),
        self$file$bytes(),
        self$serialize_bytes(self$mimeType),
        self$settings$bytes()
      )
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title VerifyEmailRequest
#  @description R6 class representing a VerifyEmailRequest.
#  @details This class handles email verification requests.
#  @export
#  @noRd
#  @noRd
VerifyEmailRequest <- R6::R6Class(
  "VerifyEmailRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the VerifyEmailRequest.
    #  @param purpose The email verification purpose.
    #  @param verification The email verification details.
    initialize = function(purpose, verification) {
      self$purpose <- purpose
      self$verification <- verification
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "VerifyEmailRequest",
        purpose = if (inherits(self$purpose, "TLObject")) self$purpose$toDict() else self$purpose,
        verification = if (inherits(self$verification, "TLObject")) self$verification$toDict() else self$verification
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xcf, 0xa4, 0x2d, 0x03)),
        self$purpose$bytes(),
        self$verification$bytes()
      )
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)

#  @title VerifyPhoneRequest
#  @description R6 class representing a VerifyPhoneRequest.
#  @details This class handles phone verification requests.
#  @export
#  @noRd
#  @noRd
VerifyPhoneRequest <- R6::R6Class(
  "VerifyPhoneRequest",
  inherit = TLRequest,
  public = list(
    #  @description Initialize the VerifyPhoneRequest.
    #  @param phoneNumber The phone number.
    #  @param phoneCodeHash The phone code hash.
    #  @param phoneCode The phone code.
    initialize = function(phoneNumber, phoneCodeHash, phoneCode) {
      self$phoneNumber <- phoneNumber
      self$phoneCodeHash <- phoneCodeHash
      self$phoneCode <- phoneCode
    },

    #  @description Convert to dictionary.
    #  @return A list representing the object.
    toDict = function() {
      list(
        "_" = "VerifyPhoneRequest",
        phoneNumber = self$phoneNumber,
        phoneCodeHash = self$phoneCodeHash,
        phoneCode = self$phoneCode
      )
    },

    #  @description Serialize to bytes.
    #  @return Raw bytes.
    bytes = function() {
      c(
        as.raw(c(0xf6, 0xa7, 0xd3, 0x4d)),
        self$serialize_bytes(self$phoneNumber),
        self$serialize_bytes(self$phoneCodeHash),
        self$serialize_bytes(self$phoneCode)
      )
    }
  ),
  private = list(),
  active = list(),
  lock_objects = FALSE
)
