#  @title ApplyGiftCodeRequest
#  @description Represents a request to apply a gift code. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ApplyGiftCodeRequest <- R6::R6Class(
  "ApplyGiftCodeRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xf6e26854,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field slug Field.
    slug = NULL,

    #  @description Initialize the ApplyGiftCodeRequest object.
    #  @param slug The slug string.
    initialize = function(slug) {
      self$slug <- slug
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "ApplyGiftCodeRequest",
        "slug" = self$slug
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x54, 0x68, 0xe2, 0xf6)),
        self$serialize_bytes(self$slug)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of ApplyGiftCodeRequest.
    from_reader = function(reader) {
      slug <- reader$tgread_string()
      self$initialize(slug)
      self
    }
  )
)

#  @title AssignAppStoreTransactionRequest
#  @description Telegram API type AssignAppStoreTransactionRequest
#  @export
#  @noRd
#  @noRd
AssignAppStoreTransactionRequest <- R6::R6Class(
  "AssignAppStoreTransactionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x80ed747d,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field receipt Field.
    receipt = NULL,
    #  @field purpose Field.
    purpose = NULL,

    #  @description Initialize the AssignAppStoreTransactionRequest object.
    #  @param receipt The receipt bytes.
    #  @param purpose The input store payment purpose (TypeInputStorePaymentPurpose).
    initialize = function(receipt, purpose) {
      self$receipt <- receipt
      self$purpose <- purpose
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "AssignAppStoreTransactionRequest",
        "receipt" = self$receipt,
        "purpose" = if (inherits(self$purpose, "TLObject")) self$purpose$to_dict() else self$purpose
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x7d, 0x74, 0xed, 0x80)),
        self$serialize_bytes(self$receipt),
        self$purpose$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of AssignAppStoreTransactionRequest.
    from_reader = function(reader) {
      receipt <- reader$tgread_bytes()
      purpose <- reader$tgread_object()
      self$initialize(receipt, purpose)
      self
    }
  )
)

#  @title AssignPlayMarketTransactionRequest
#  @description Telegram API type AssignPlayMarketTransactionRequest
#  @export
#  @noRd
#  @noRd
AssignPlayMarketTransactionRequest <- R6::R6Class(
  "AssignPlayMarketTransactionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xdffd50d3,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field receipt Field.
    receipt = NULL,
    #  @field purpose Field.
    purpose = NULL,

    #  @description Initialize the AssignPlayMarketTransactionRequest object.
    #  @param receipt The receipt data JSON (TypeDataJSON).
    #  @param purpose The input store payment purpose (TypeInputStorePaymentPurpose).
    initialize = function(receipt, purpose) {
      self$receipt <- receipt
      self$purpose <- purpose
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "AssignPlayMarketTransactionRequest",
        "receipt" = if (inherits(self$receipt, "TLObject")) self$receipt$to_dict() else self$receipt,
        "purpose" = if (inherits(self$purpose, "TLObject")) self$purpose$to_dict() else self$purpose
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xd3, 0x50, 0xfd, 0xdf)),
        self$receipt$bytes(),
        self$purpose$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of AssignPlayMarketTransactionRequest.
    from_reader = function(reader) {
      receipt <- reader$tgread_object()
      purpose <- reader$tgread_object()
      self$initialize(receipt, purpose)
      self
    }
  )
)


#  @title BotCancelStarsSubscriptionRequest
#  @description Telegram API type BotCancelStarsSubscriptionRequest
#  @export
#  @noRd
#  @noRd
BotCancelStarsSubscriptionRequest <- R6::R6Class(
  "BotCancelStarsSubscriptionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x6dfa0622,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field user_id Field.
    user_id = NULL,
    #  @field charge_id Field.
    charge_id = NULL,
    #  @field restore Field.
    restore = NULL,

    #  @description Initialize the BotCancelStarsSubscriptionRequest object.
    #  @param user_id The input user (TypeInputUser).
    #  @param charge_id The charge ID (string).
    #  @param restore Optional boolean flag to restore the subscription.
    initialize = function(user_id, charge_id, restore = NULL) {
      self$user_id <- user_id
      self$charge_id <- charge_id
      self$restore <- restore
    },

    #  @description Resolve the user_id using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$user_id <- utils$get_input_user((client$get_input_entity(self$user_id)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "BotCancelStarsSubscriptionRequest",
        "user_id" = if (inherits(self$user_id, "TLObject")) self$user_id$to_dict() else self$user_id,
        "charge_id" = self$charge_id,
        "restore" = self$restore
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$restore) || !self$restore) 0 else 1
      c(
        as.raw(c(0x22, 0x06, 0xfa, 0x6d)),
        pack("<I", flags),
        self$user_id$bytes(),
        self$serialize_bytes(self$charge_id)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of BotCancelStarsSubscriptionRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      restore <- bitwAnd(flags, 1) != 0
      user_id <- reader$tgread_object()
      charge_id <- reader$tgread_string()
      self$initialize(user_id, charge_id, restore)
      self
    }
  )
)

#  @title CanPurchaseStoreRequest
#  @description Represents a request to check if a store purchase can be made. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
CanPurchaseStoreRequest <- R6::R6Class(
  "CanPurchaseStoreRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x4fdc5ea7,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field purpose Field.
    purpose = NULL,

    #  @description Initialize the CanPurchaseStoreRequest object.
    #  @param purpose The input store payment purpose (TypeInputStorePaymentPurpose).
    initialize = function(purpose) {
      self$purpose <- purpose
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "CanPurchaseStoreRequest",
        "purpose" = if (inherits(self$purpose, "TLObject")) self$purpose$to_dict() else self$purpose
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xa7, 0x5e, 0xdc, 0x4f)),
        self$purpose$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of CanPurchaseStoreRequest.
    from_reader = function(reader) {
      purpose <- reader$tgread_object()
      self$initialize(purpose)
      self
    }
  )
)

#  @title ChangeStarsSubscriptionRequest
#  @description Telegram API type ChangeStarsSubscriptionRequest
#  @export
#  @noRd
#  @noRd
ChangeStarsSubscriptionRequest <- R6::R6Class(
  "ChangeStarsSubscriptionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xc7770878,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field peer Field.
    peer = NULL,
    #  @field subscription_id Field.
    subscription_id = NULL,
    #  @field canceled Field.
    canceled = NULL,

    #  @description Initialize the ChangeStarsSubscriptionRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param subscription_id The subscription ID (string).
    #  @param canceled Optional boolean flag indicating if canceled.
    initialize = function(peer, subscription_id, canceled = NULL) {
      self$peer <- peer
      self$subscription_id <- subscription_id
      self$canceled <- canceled
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "ChangeStarsSubscriptionRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "subscription_id" = self$subscription_id,
        "canceled" = self$canceled
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- if (is.null(self$canceled)) 0 else 1
      canceled_bytes <- if (is.null(self$canceled)) raw() else if (self$canceled) as.raw(c(0xb5, 0x75, 0x72, 0x99)) else as.raw(c(0x37, 0x97, 0x79, 0xbc))
      c(
        as.raw(c(0x78, 0x08, 0x77, 0xc7)),
        pack("<I", flags),
        self$peer$bytes(),
        self$serialize_bytes(self$subscription_id),
        canceled_bytes
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of ChangeStarsSubscriptionRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      peer <- reader$tgread_object()
      subscription_id <- reader$tgread_string()
      canceled <- if (bitwAnd(flags, 1) != 0) reader$tgread_bool() else NULL
      self$initialize(peer, subscription_id, canceled)
      self
    }
  )
)


#  @title CheckCanSendGiftRequest
#  @description Represents a request to check if a gift can be sent. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
CheckCanSendGiftRequest <- R6::R6Class(
  "CheckCanSendGiftRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xc0c4edc9,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x632efa30,
    #  @field gift_id Field.
    gift_id = NULL,

    #  @description Initialize the CheckCanSendGiftRequest object.
    #  @param gift_id The gift ID (integer).
    initialize = function(gift_id) {
      self$gift_id <- gift_id
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "CheckCanSendGiftRequest",
        "gift_id" = self$gift_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xc9, 0xed, 0xc4, 0xc0)),
        pack("<q", self$gift_id)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of CheckCanSendGiftRequest.
    from_reader = function(reader) {
      gift_id <- reader$read_long()
      self$initialize(gift_id)
      self
    }
  )
)

#  @title CheckGiftCodeRequest
#  @description Represents a request to check a gift code. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
CheckGiftCodeRequest <- R6::R6Class(
  "CheckGiftCodeRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x8e51b4c1,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x5b2997e8,
    #  @field slug Field.
    slug = NULL,

    #  @description Initialize the CheckGiftCodeRequest object.
    #  @param slug The slug string.
    initialize = function(slug) {
      self$slug <- slug
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "CheckGiftCodeRequest",
        "slug" = self$slug
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xc1, 0xb4, 0x51, 0x8e)),
        self$serialize_bytes(self$slug)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of CheckGiftCodeRequest.
    from_reader = function(reader) {
      slug <- reader$tgread_string()
      self$initialize(slug)
      self
    }
  )
)

#  @title ClearSavedInfoRequest
#  @description Telegram API type ClearSavedInfoRequest
#  @export
#  @noRd
#  @noRd
ClearSavedInfoRequest <- R6::R6Class(
  "ClearSavedInfoRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xd83d70c1,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field credentials Field.
    credentials = NULL,
    #  @field info Field.
    info = NULL,

    #  @description Initialize the ClearSavedInfoRequest object.
    #  @param credentials Optional boolean flag to clear credentials.
    #  @param info Optional boolean flag to clear info.
    initialize = function(credentials = NULL, info = NULL) {
      self$credentials <- credentials
      self$info <- info
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "ClearSavedInfoRequest",
        "credentials" = self$credentials,
        "info" = self$info
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xc1, 0x70, 0x3d, 0xd8)),
        pack("<I", (if (is.null(self$credentials) || !self$credentials) 0 else 1) | (if (is.null(self$info) || !self$info) 0 else 2))
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of ClearSavedInfoRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      credentials <- bitwAnd(flags, 1) != 0
      info <- bitwAnd(flags, 2) != 0
      self$initialize(credentials, info)
      self
    }
  )
)


#  @title ConnectStarRefBotRequest
#  @description Telegram API type ConnectStarRefBotRequest
#  @export
#  @noRd
#  @noRd
ConnectStarRefBotRequest <- R6::R6Class(
  "ConnectStarRefBotRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x7ed5348a,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x235e1a67,
    #  @field peer Field.
    peer = NULL,
    #  @field bot Field.
    bot = NULL,

    #  @description Initialize the ConnectStarRefBotRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param bot The input user (TypeInputUser).
    initialize = function(peer, bot) {
      self$peer <- peer
      self$bot <- bot
    },

    #  @description Resolve the peer and bot using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
      self$bot <- utils$get_input_user((client$get_input_entity(self$bot)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "ConnectStarRefBotRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "bot" = if (inherits(self$bot, "TLObject")) self$bot$to_dict() else self$bot
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x8a, 0x34, 0xd5, 0x7e)),
        self$peer$bytes(),
        self$bot$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of ConnectStarRefBotRequest.
    from_reader = function(reader) {
      peer <- reader$tgread_object()
      bot <- reader$tgread_object()
      self$initialize(peer, bot)
      self
    }
  )
)

#  @title ConvertStarGiftRequest
#  @description Represents a request to convert a star gift. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ConvertStarGiftRequest <- R6::R6Class(
  "ConvertStarGiftRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x74bf076b,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field stargift Field.
    stargift = NULL,

    #  @description Initialize the ConvertStarGiftRequest object.
    #  @param stargift The input saved star gift (TypeInputSavedStarGift).
    initialize = function(stargift) {
      self$stargift <- stargift
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "ConvertStarGiftRequest",
        "stargift" = if (inherits(self$stargift, "TLObject")) self$stargift$to_dict() else self$stargift
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x6b, 0x07, 0xbf, 0x74)),
        self$stargift$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of ConvertStarGiftRequest.
    from_reader = function(reader) {
      stargift <- reader$tgread_object()
      self$initialize(stargift)
      self
    }
  )
)

#  @title CreateStarGiftCollectionRequest
#  @description Telegram API type CreateStarGiftCollectionRequest
#  @export
#  @noRd
#  @noRd
CreateStarGiftCollectionRequest <- R6::R6Class(
  "CreateStarGiftCollectionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x1f4a0e87,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x43e0cb4a,
    #  @field peer Field.
    peer = NULL,
    #  @field title Field.
    title = NULL,
    #  @field stargift Field.
    stargift = NULL,

    #  @description Initialize the CreateStarGiftCollectionRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param title The title string.
    #  @param stargift List of input saved star gifts (list of TypeInputSavedStarGift).
    initialize = function(peer, title, stargift) {
      self$peer <- peer
      self$title <- title
      self$stargift <- stargift
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "CreateStarGiftCollectionRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "title" = self$title,
        "stargift" = if (is.null(self$stargift)) list() else lapply(self$stargift, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x87, 0x0e, 0x4a, 0x1f)),
        self$peer$bytes(),
        self$serialize_bytes(self$title),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)), pack("<i", length(self$stargift)), do.call(c, lapply(self$stargift, function(x) x$bytes()))
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of CreateStarGiftCollectionRequest.
    from_reader = function(reader) {
      peer <- reader$tgread_object()
      title <- reader$tgread_string()
      reader$read_int()
      stargift <- lapply(seq_len(reader$read_int()), function(i) reader$tgread_object())
      self$initialize(peer, title, stargift)
      self
    }
  )
)


#  @title DeleteStarGiftCollectionRequest
#  @description Telegram API type DeleteStarGiftCollectionRequest
#  @export
#  @noRd
#  @noRd
DeleteStarGiftCollectionRequest <- R6::R6Class(
  "DeleteStarGiftCollectionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xad5648e8,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field peer Field.
    peer = NULL,
    #  @field collection_id Field.
    collection_id = NULL,

    #  @description Initialize the DeleteStarGiftCollectionRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param collection_id The collection ID (integer).
    initialize = function(peer, collection_id) {
      self$peer <- peer
      self$collection_id <- collection_id
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "DeleteStarGiftCollectionRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "collection_id" = self$collection_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xe8, 0x48, 0x56, 0xad)),
        self$peer$bytes(),
        pack("<i", self$collection_id)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of DeleteStarGiftCollectionRequest.
    from_reader = function(reader) {
      peer <- reader$tgread_object()
      collection_id <- reader$read_int()
      self$initialize(peer, collection_id)
      self
    }
  )
)

#  @title EditConnectedStarRefBotRequest
#  @description Telegram API type EditConnectedStarRefBotRequest
#  @export
#  @noRd
#  @noRd
EditConnectedStarRefBotRequest <- R6::R6Class(
  "EditConnectedStarRefBotRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xe4fca4a3,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x235e1a67,
    #  @field peer Field.
    peer = NULL,
    #  @field link Field.
    link = NULL,
    #  @field revoked Field.
    revoked = NULL,

    #  @description Initialize the EditConnectedStarRefBotRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param link The link string.
    #  @param revoked Optional boolean flag indicating if revoked.
    initialize = function(peer, link, revoked = NULL) {
      self$peer <- peer
      self$link <- link
      self$revoked <- revoked
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "EditConnectedStarRefBotRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "link" = self$link,
        "revoked" = self$revoked
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xa3, 0xa4, 0xfc, 0xe4)),
        pack("<I", if (is.null(self$revoked) || !self$revoked) 0 else 1),
        self$peer$bytes(),
        self$serialize_bytes(self$link)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of EditConnectedStarRefBotRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      revoked <- bitwAnd(flags, 1) != 0
      peer <- reader$tgread_object()
      link <- reader$tgread_string()
      self$initialize(peer, link, revoked)
      self
    }
  )
)

#  @title ExportInvoiceRequest
#  @description Represents a request to export an invoice. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
ExportInvoiceRequest <- R6::R6Class(
  "ExportInvoiceRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xf91b065,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x36105432,
    #  @field invoice_media Field.
    invoice_media = NULL,

    #  @description Initialize the ExportInvoiceRequest object.
    #  @param invoice_media The input media for the invoice (TypeInputMedia).
    initialize = function(invoice_media) {
      self$invoice_media <- invoice_media
    },

    #  @description Resolve the invoice_media using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$invoice_media <- utils$get_input_media(self$invoice_media)
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "ExportInvoiceRequest",
        "invoice_media" = if (inherits(self$invoice_media, "TLObject")) self$invoice_media$to_dict() else self$invoice_media
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x65, 0xb0, 0x91, 0x0f)),
        self$invoice_media$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of ExportInvoiceRequest.
    from_reader = function(reader) {
      invoice_media <- reader$tgread_object()
      self$initialize(invoice_media)
      self
    }
  )
)


#  @title FulfillStarsSubscriptionRequest
#  @description Telegram API type FulfillStarsSubscriptionRequest
#  @export
#  @noRd
#  @noRd
FulfillStarsSubscriptionRequest <- R6::R6Class(
  "FulfillStarsSubscriptionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xcc5bebb3,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field peer Field.
    peer = NULL,
    #  @field subscription_id Field.
    subscription_id = NULL,

    #  @description Initialize the FulfillStarsSubscriptionRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param subscription_id The subscription ID (string).
    initialize = function(peer, subscription_id) {
      self$peer <- peer
      self$subscription_id <- subscription_id
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "FulfillStarsSubscriptionRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "subscription_id" = self$subscription_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xb3, 0xeb, 0x5b, 0xcc)),
        self$peer$bytes(),
        self$serialize_bytes(self$subscription_id)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of FulfillStarsSubscriptionRequest.
    from_reader = function(reader) {
      peer <- reader$tgread_object()
      subscription_id <- reader$tgread_string()
      self$initialize(peer, subscription_id)
      self
    }
  )
)

#  @title GetBankCardDataRequest
#  @description Represents a request to get bank card data. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetBankCardDataRequest <- R6::R6Class(
  "GetBankCardDataRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x2e79d779,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8c6dd68b,
    #  @field number Field.
    number = NULL,

    #  @description Initialize the GetBankCardDataRequest object.
    #  @param number The card number (string).
    initialize = function(number) {
      self$number <- number
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetBankCardDataRequest",
        "number" = self$number
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x79, 0xd7, 0x79, 0x2e)),
        self$serialize_bytes(self$number)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetBankCardDataRequest.
    from_reader = function(reader) {
      number <- reader$tgread_string()
      self$initialize(number)
      self
    }
  )
)


#  @title GetConnectedStarRefBotRequest
#  @description Telegram API type GetConnectedStarRefBotRequest
#  @export
#  @noRd
#  @noRd
GetConnectedStarRefBotRequest <- R6::R6Class(
  "GetConnectedStarRefBotRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xb7d998f0,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x235e1a67,
    #  @field peer Field.
    peer = NULL,
    #  @field bot Field.
    bot = NULL,

    #  @description Initialize the GetConnectedStarRefBotRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param bot The input user (TypeInputUser).
    initialize = function(peer, bot) {
      self$peer <- peer
      self$bot <- bot
    },

    #  @description Resolve the peer and bot using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
      self$bot <- utils$get_input_user((client$get_input_entity(self$bot)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetConnectedStarRefBotRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "bot" = if (inherits(self$bot, "TLObject")) self$bot$to_dict() else self$bot
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xf0, 0x98, 0xd9, 0xb7)),
        self$peer$bytes(),
        self$bot$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetConnectedStarRefBotRequest.
    from_reader = function(reader) {
      peer <- reader$tgread_object()
      bot <- reader$tgread_object()
      self$initialize(peer, bot)
      self
    }
  )
)

#  @title GetConnectedStarRefBotsRequest
#  @description Telegram API type GetConnectedStarRefBotsRequest
#  @export
#  @noRd
#  @noRd
GetConnectedStarRefBotsRequest <- R6::R6Class(
  "GetConnectedStarRefBotsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x5869a553,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x235e1a67,
    #  @field peer Field.
    peer = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field offset_date Field.
    offset_date = NULL,
    #  @field offset_link Field.
    offset_link = NULL,

    #  @description Initialize the GetConnectedStarRefBotsRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param limit The limit integer.
    #  @param offset_date Optional offset date (datetime).
    #  @param offset_link Optional offset link (string).
    initialize = function(peer, limit, offset_date = NULL, offset_link = NULL) {
      self$peer <- peer
      self$limit <- limit
      self$offset_date <- offset_date
      self$offset_link <- offset_link
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetConnectedStarRefBotsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "limit" = self$limit,
        "offset_date" = self$offset_date,
        "offset_link" = self$offset_link
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$offset_date)) 0 else 4) | (if (is.null(self$offset_link) || !nzchar(self$offset_link)) 0 else 4)
      c(
        as.raw(c(0x53, 0xa5, 0x69, 0x58)),
        pack("<I", flags),
        self$peer$bytes(),
        if (!is.null(self$offset_date)) self$serialize_datetime(self$offset_date) else raw(),
        if (!is.null(self$offset_link) && nzchar(self$offset_link)) self$serialize_bytes(self$offset_link) else raw(),
        pack("<i", self$limit)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetConnectedStarRefBotsRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      peer <- reader$tgread_object()
      offset_date <- if (bitwAnd(flags, 4) != 0) reader$tgread_date() else NULL
      offset_link <- if (bitwAnd(flags, 4) != 0) reader$tgread_string() else NULL
      limit <- reader$read_int()
      self$initialize(peer, limit, offset_date, offset_link)
      self
    }
  )
)


#  @title GetGiveawayInfoRequest
#  @description Telegram API type GetGiveawayInfoRequest
#  @export
#  @noRd
#  @noRd
GetGiveawayInfoRequest <- R6::R6Class(
  "GetGiveawayInfoRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xf4239425,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x96a377bd,
    #  @field peer Field.
    peer = NULL,
    #  @field msg_id Field.
    msg_id = NULL,

    #  @description Initialize the GetGiveawayInfoRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param msg_id The message ID (integer).
    initialize = function(peer, msg_id) {
      self$peer <- peer
      self$msg_id <- msg_id
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetGiveawayInfoRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "msg_id" = self$msg_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x25, 0x94, 0x23, 0xf4)),
        self$peer$bytes(),
        pack("<i", self$msg_id)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetGiveawayInfoRequest.
    from_reader = function(reader) {
      peer <- reader$tgread_object()
      msg_id <- reader$read_int()
      self$initialize(peer, msg_id)
      self
    }
  )
)

#  @title GetPaymentFormRequest
#  @description Telegram API type GetPaymentFormRequest
#  @export
#  @noRd
#  @noRd
GetPaymentFormRequest <- R6::R6Class(
  "GetPaymentFormRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x37148dbb,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xa0483f19,
    #  @field invoice Field.
    invoice = NULL,
    #  @field theme_params Field.
    theme_params = NULL,

    #  @description Initialize the GetPaymentFormRequest object.
    #  @param invoice The input invoice (TypeInputInvoice).
    #  @param theme_params Optional theme parameters (TypeDataJSON).
    initialize = function(invoice, theme_params = NULL) {
      self$invoice <- invoice
      self$theme_params <- theme_params
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetPaymentFormRequest",
        "invoice" = if (inherits(self$invoice, "TLObject")) self$invoice$to_dict() else self$invoice,
        "theme_params" = if (inherits(self$theme_params, "TLObject")) self$theme_params$to_dict() else self$theme_params
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xbb, 0x8d, 0x14, 0x37)),
        pack("<I", if (is.null(self$theme_params)) 0 else 1),
        self$invoice$bytes(),
        if (!is.null(self$theme_params)) self$theme_params$bytes() else raw()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetPaymentFormRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      invoice <- reader$tgread_object()
      theme_params <- if (bitwAnd(flags, 1) != 0) reader$tgread_object() else NULL
      self$initialize(invoice, theme_params)
      self
    }
  )
)


#  @title GetPaymentReceiptRequest
#  @description Telegram API type GetPaymentReceiptRequest
#  @export
#  @noRd
#  @noRd
GetPaymentReceiptRequest <- R6::R6Class(
  "GetPaymentReceiptRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x2478d1cc,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x590093c9,
    #  @field peer Field.
    peer = NULL,
    #  @field msg_id Field.
    msg_id = NULL,

    #  @description Initialize the GetPaymentReceiptRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param msg_id The message ID (integer).
    initialize = function(peer, msg_id) {
      self$peer <- peer
      self$msg_id <- msg_id
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetPaymentReceiptRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "msg_id" = self$msg_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xcc, 0xd1, 0x78, 0x24)),
        self$peer$bytes(),
        pack("<i", self$msg_id)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetPaymentReceiptRequest.
    from_reader = function(reader) {
      peer <- reader$tgread_object()
      msg_id <- reader$read_int()
      self$initialize(peer, msg_id)
      self
    }
  )
)

#  @title GetPremiumGiftCodeOptionsRequest
#  @description Represents a request to get premium gift code options. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetPremiumGiftCodeOptionsRequest <- R6::R6Class(
  "GetPremiumGiftCodeOptionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x2757ba54,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xaa92583,
    #  @field boost_peer Field.
    boost_peer = NULL,

    #  @description Initialize the GetPremiumGiftCodeOptionsRequest object.
    #  @param boost_peer Optional input peer for boosting (TypeInputPeer).
    initialize = function(boost_peer = NULL) {
      self$boost_peer <- boost_peer
    },

    #  @description Resolve the boost_peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      if (!is.null(self$boost_peer)) {
        self$boost_peer <- utils$get_input_peer((client$get_input_entity(self$boost_peer)))
      }
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetPremiumGiftCodeOptionsRequest",
        "boost_peer" = if (inherits(self$boost_peer, "TLObject")) self$boost_peer$to_dict() else self$boost_peer
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x54, 0xba, 0x57, 0x27)),
        pack("<I", if (is.null(self$boost_peer)) 0 else 1),
        if (!is.null(self$boost_peer)) self$boost_peer$bytes() else raw()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetPremiumGiftCodeOptionsRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      boost_peer <- if (bitwAnd(flags, 1) != 0) reader$tgread_object() else NULL
      self$initialize(boost_peer)
      self
    }
  )
)


#  @title GetResaleStarGiftsRequest
#  @description Telegram API type GetResaleStarGiftsRequest
#  @export
#  @noRd
#  @noRd
GetResaleStarGiftsRequest <- R6::R6Class(
  "GetResaleStarGiftsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x7a5fa236,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xb2dbb7e3,
    #  @field gift_id Field.
    gift_id = NULL,
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field sort_by_price Field.
    sort_by_price = NULL,
    #  @field sort_by_num Field.
    sort_by_num = NULL,
    #  @field attributes_hash Field.
    attributes_hash = NULL,
    #  @field attributes Field.
    attributes = NULL,

    #  @description Initialize the GetResaleStarGiftsRequest object.
    #  @param gift_id The gift ID (integer).
    #  @param offset The offset string.
    #  @param limit The limit integer.
    #  @param sort_by_price Optional boolean flag to sort by price.
    #  @param sort_by_num Optional boolean flag to sort by number.
    #  @param attributes_hash Optional attributes hash (integer).
    #  @param attributes Optional list of star gift attribute IDs (list of TypeStarGiftAttributeId).
    initialize = function(gift_id, offset, limit, sort_by_price = NULL, sort_by_num = NULL, attributes_hash = NULL, attributes = NULL) {
      self$gift_id <- gift_id
      self$offset <- offset
      self$limit <- limit
      self$sort_by_price <- sort_by_price
      self$sort_by_num <- sort_by_num
      self$attributes_hash <- attributes_hash
      self$attributes <- attributes
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetResaleStarGiftsRequest",
        "gift_id" = self$gift_id,
        "offset" = self$offset,
        "limit" = self$limit,
        "sort_by_price" = self$sort_by_price,
        "sort_by_num" = self$sort_by_num,
        "attributes_hash" = self$attributes_hash,
        "attributes" = if (is.null(self$attributes)) list() else lapply(self$attributes, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$sort_by_price) || !self$sort_by_price) 0 else 2) |
        (if (is.null(self$sort_by_num) || !self$sort_by_num) 0 else 4) |
        (if (is.null(self$attributes_hash)) 0 else 1) |
        (if (is.null(self$attributes)) 0 else 8)
      c(
        as.raw(c(0x36, 0xa2, 0x5f, 0x7a)),
        pack("<I", flags),
        if (!is.null(self$attributes_hash)) pack("<q", self$attributes_hash) else raw(),
        pack("<q", self$gift_id),
        if (!is.null(self$attributes)) c(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$attributes)), do.call(c, lapply(self$attributes, function(x) x$bytes()))) else raw(),
        self$serialize_bytes(self$offset),
        pack("<i", self$limit)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetResaleStarGiftsRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      sort_by_price <- bitwAnd(flags, 2) != 0
      sort_by_num <- bitwAnd(flags, 4) != 0
      if (bitwAnd(flags, 1) != 0) {
        attributes_hash <- reader$read_long()
      } else {
        attributes_hash <- NULL
      }
      gift_id <- reader$read_long()
      if (bitwAnd(flags, 8) != 0) {
        reader$read_int()
        attributes <- lapply(seq_len(reader$read_int()), function(i) reader$tgread_object())
      } else {
        attributes <- NULL
      }
      offset <- reader$tgread_string()
      limit <- reader$read_int()
      self$initialize(gift_id, offset, limit, sort_by_price, sort_by_num, attributes_hash, attributes)
      self
    }
  )
)

#  @title GetSavedInfoRequest
#  @description Represents a request to get saved payment info. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetSavedInfoRequest <- R6::R6Class(
  "GetSavedInfoRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x227d824b,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xad3cf146,

    #  @description Initialize the GetSavedInfoRequest object.
    initialize = function() {
      # No parameters
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetSavedInfoRequest"
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      as.raw(c(0x4b, 0x82, 0x7d, 0x22))
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetSavedInfoRequest.
    from_reader = function(reader) {
      self$initialize()
      self
    }
  )
)

#  @title GetSavedStarGiftRequest
#  @description Represents a request to get a saved star gift. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetSavedStarGiftRequest <- R6::R6Class(
  "GetSavedStarGiftRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xb455a106,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xd5112897,
    #  @field stargift Field.
    stargift = NULL,

    #  @description Initialize the GetSavedStarGiftRequest object.
    #  @param stargift List of input saved star gifts (list of TypeInputSavedStarGift).
    initialize = function(stargift) {
      self$stargift <- stargift
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetSavedStarGiftRequest",
        "stargift" = if (is.null(self$stargift)) list() else lapply(self$stargift, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x06, 0xa1, 0x55, 0xb4)),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), pack("<i", length(self$stargift)), do.call(c, lapply(self$stargift, function(x) x$bytes()))
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetSavedStarGiftRequest.
    from_reader = function(reader) {
      reader$read_int()
      stargift <- lapply(seq_len(reader$read_int()), function(i) reader$tgread_object())
      self$initialize(stargift)
      self
    }
  )
)


#  @title GetSavedStarGiftsRequest
#  @description Telegram API type GetSavedStarGiftsRequest
#  @export
#  @noRd
#  @noRd
GetSavedStarGiftsRequest <- R6::R6Class(
  "GetSavedStarGiftsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xa319e569,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xd5112897,
    #  @field peer Field.
    peer = NULL,
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field exclude_unsaved Field.
    exclude_unsaved = NULL,
    #  @field exclude_saved Field.
    exclude_saved = NULL,
    #  @field exclude_unlimited Field.
    exclude_unlimited = NULL,
    #  @field exclude_unique Field.
    exclude_unique = NULL,
    #  @field sort_by_value Field.
    sort_by_value = NULL,
    #  @field exclude_upgradable Field.
    exclude_upgradable = NULL,
    #  @field exclude_unupgradable Field.
    exclude_unupgradable = NULL,
    #  @field collection_id Field.
    collection_id = NULL,

    #  @description Initialize the GetSavedStarGiftsRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param offset The offset string.
    #  @param limit The limit integer.
    #  @param exclude_unsaved Optional boolean flag to exclude unsaved gifts.
    #  @param exclude_saved Optional boolean flag to exclude saved gifts.
    #  @param exclude_unlimited Optional boolean flag to exclude unlimited gifts.
    #  @param exclude_unique Optional boolean flag to exclude unique gifts.
    #  @param sort_by_value Optional boolean flag to sort by value.
    #  @param exclude_upgradable Optional boolean flag to exclude upgradable gifts.
    #  @param exclude_unupgradable Optional boolean flag to exclude unupgradable gifts.
    #  @param collection_id Optional collection ID (integer).
    initialize = function(peer, offset, limit, exclude_unsaved = NULL, exclude_saved = NULL, exclude_unlimited = NULL, exclude_unique = NULL, sort_by_value = NULL, exclude_upgradable = NULL, exclude_unupgradable = NULL, collection_id = NULL) {
      self$peer <- peer
      self$offset <- offset
      self$limit <- limit
      self$exclude_unsaved <- exclude_unsaved
      self$exclude_saved <- exclude_saved
      self$exclude_unlimited <- exclude_unlimited
      self$exclude_unique <- exclude_unique
      self$sort_by_value <- sort_by_value
      self$exclude_upgradable <- exclude_upgradable
      self$exclude_unupgradable <- exclude_unupgradable
      self$collection_id <- collection_id
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetSavedStarGiftsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "offset" = self$offset,
        "limit" = self$limit,
        "exclude_unsaved" = self$exclude_unsaved,
        "exclude_saved" = self$exclude_saved,
        "exclude_unlimited" = self$exclude_unlimited,
        "exclude_unique" = self$exclude_unique,
        "sort_by_value" = self$sort_by_value,
        "exclude_upgradable" = self$exclude_upgradable,
        "exclude_unupgradable" = self$exclude_unupgradable,
        "collection_id" = self$collection_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$exclude_unsaved) || !self$exclude_unsaved) 0 else 1) |
        (if (is.null(self$exclude_saved) || !self$exclude_saved) 0 else 2) |
        (if (is.null(self$exclude_unlimited) || !self$exclude_unlimited) 0 else 4) |
        (if (is.null(self$exclude_unique) || !self$exclude_unique) 0 else 16) |
        (if (is.null(self$sort_by_value) || !self$sort_by_value) 0 else 32) |
        (if (is.null(self$exclude_upgradable) || !self$exclude_upgradable) 0 else 128) |
        (if (is.null(self$exclude_unupgradable) || !self$exclude_unupgradable) 0 else 256) |
        (if (is.null(self$collection_id)) 0 else 64)
      c(
        as.raw(c(0x69, 0xe5, 0x19, 0xa3)),
        pack("<I", flags),
        self$peer$bytes(),
        if (!is.null(self$collection_id)) pack("<i", self$collection_id) else raw(),
        self$serialize_bytes(self$offset),
        pack("<i", self$limit)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetSavedStarGiftsRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      exclude_unsaved <- bitwAnd(flags, 1) != 0
      exclude_saved <- bitwAnd(flags, 2) != 0
      exclude_unlimited <- bitwAnd(flags, 4) != 0
      exclude_unique <- bitwAnd(flags, 16) != 0
      sort_by_value <- bitwAnd(flags, 32) != 0
      exclude_upgradable <- bitwAnd(flags, 128) != 0
      exclude_unupgradable <- bitwAnd(flags, 256) != 0
      peer <- reader$tgread_object()
      collection_id <- if (bitwAnd(flags, 64) != 0) reader$read_int() else NULL
      offset <- reader$tgread_string()
      limit <- reader$read_int()
      self$initialize(peer, offset, limit, exclude_unsaved, exclude_saved, exclude_unlimited, exclude_unique, sort_by_value, exclude_upgradable, exclude_unupgradable, collection_id)
      self
    }
  )
)

#  @title GetStarGiftCollectionsRequest
#  @description Telegram API type GetStarGiftCollectionsRequest
#  @export
#  @noRd
#  @noRd
GetStarGiftCollectionsRequest <- R6::R6Class(
  "GetStarGiftCollectionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x981b91dd,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf01721ec,
    #  @field peer Field.
    peer = NULL,
    #  @field hash Field.
    hash = NULL,

    #  @description Initialize the GetStarGiftCollectionsRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param hash The hash value (integer).
    initialize = function(peer, hash) {
      self$peer <- peer
      self$hash <- hash
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetStarGiftCollectionsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xdd, 0x91, 0x1b, 0x98)),
        self$peer$bytes(),
        pack("<q", self$hash)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetStarGiftCollectionsRequest.
    from_reader = function(reader) {
      peer <- reader$tgread_object()
      hash <- reader$read_long()
      self$initialize(peer, hash)
      self
    }
  )
)


#  @title GetStarGiftUpgradePreviewRequest
#  @description Represents a request to get the star gift upgrade preview. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetStarGiftUpgradePreviewRequest <- R6::R6Class(
  "GetStarGiftUpgradePreviewRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x9c9abcb1,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x5e2b68c7,
    #  @field gift_id Field.
    gift_id = NULL,

    #  @description Initialize the GetStarGiftUpgradePreviewRequest object.
    #  @param gift_id The gift ID (integer).
    initialize = function(gift_id) {
      self$gift_id <- gift_id
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetStarGiftUpgradePreviewRequest",
        "gift_id" = self$gift_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xb1, 0xbc, 0x9a, 0x9c)),
        pack("<q", self$gift_id)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetStarGiftUpgradePreviewRequest.
    from_reader = function(reader) {
      gift_id <- reader$read_long()
      self$initialize(gift_id)
      self
    }
  )
)

#  @title GetStarGiftWithdrawalUrlRequest
#  @description Telegram API type GetStarGiftWithdrawalUrlRequest
#  @export
#  @noRd
#  @noRd
GetStarGiftWithdrawalUrlRequest <- R6::R6Class(
  "GetStarGiftWithdrawalUrlRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xd06e93a8,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xa2822dc5,
    #  @field stargift Field.
    stargift = NULL,
    #  @field password Field.
    password = NULL,

    #  @description Initialize the GetStarGiftWithdrawalUrlRequest object.
    #  @param stargift The input saved star gift (TypeInputSavedStarGift).
    #  @param password The input check password SRP (TypeInputCheckPasswordSRP).
    initialize = function(stargift, password) {
      self$stargift <- stargift
      self$password <- password
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetStarGiftWithdrawalUrlRequest",
        "stargift" = if (inherits(self$stargift, "TLObject")) self$stargift$to_dict() else self$stargift,
        "password" = if (inherits(self$password, "TLObject")) self$password$to_dict() else self$password
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xa8, 0x93, 0x6e, 0xd0)),
        self$stargift$bytes(),
        self$password$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetStarGiftWithdrawalUrlRequest.
    from_reader = function(reader) {
      stargift <- reader$tgread_object()
      password <- reader$tgread_object()
      self$initialize(stargift, password)
      self
    }
  )
)

#  @title GetStarGiftsRequest
#  @description Represents a request to get star gifts. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetStarGiftsRequest <- R6::R6Class(
  "GetStarGiftsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xc4563590,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x6178d9a4,
    #  @field hash Field.
    hash = NULL,

    #  @description Initialize the GetStarGiftsRequest object.
    #  @param hash The hash value (integer).
    initialize = function(hash) {
      self$hash <- hash
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetStarGiftsRequest",
        "hash" = self$hash
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x90, 0x53, 0x56, 0xc4)),
        pack("<i", self$hash)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetStarGiftsRequest.
    from_reader = function(reader) {
      hash <- reader$read_int()
      self$initialize(hash)
      self
    }
  )
)


#  @title GetStarsGiftOptionsRequest
#  @description Represents a request to get stars gift options. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetStarsGiftOptionsRequest <- R6::R6Class(
  "GetStarsGiftOptionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xd3c96bc8,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xe9a3b7d5,
    #  @field user_id Field.
    user_id = NULL,

    #  @description Initialize the GetStarsGiftOptionsRequest object.
    #  @param user_id Optional input user (TypeInputUser).
    initialize = function(user_id = NULL) {
      self$user_id <- user_id
    },

    #  @description Resolve the user_id using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      if (!is.null(self$user_id)) {
        self$user_id <- utils$get_input_user((client$get_input_entity(self$user_id)))
      }
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetStarsGiftOptionsRequest",
        "user_id" = if (inherits(self$user_id, "TLObject")) self$user_id$to_dict() else self$user_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xc8, 0x6b, 0xc9, 0xd3)),
        pack("<I", if (is.null(self$user_id)) 0 else 1),
        if (!is.null(self$user_id)) self$user_id$bytes() else raw()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetStarsGiftOptionsRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      user_id <- if (bitwAnd(flags, 1) != 0) reader$tgread_object() else NULL
      self$initialize(user_id)
      self
    }
  )
)

#  @title GetStarsGiveawayOptionsRequest
#  @description Represents a request to get stars giveaway options. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetStarsGiveawayOptionsRequest <- R6::R6Class(
  "GetStarsGiveawayOptionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xbd1efd3e,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf8db30a9,

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetStarsGiveawayOptionsRequest"
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      as.raw(c(0x3e, 0xfd, 0x1e, 0xbd))
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetStarsGiveawayOptionsRequest.
    from_reader = function(reader) {
      self
    }
  )
)

#  @title GetStarsRevenueAdsAccountUrlRequest
#  @description Represents a request to get stars revenue ads account URL. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetStarsRevenueAdsAccountUrlRequest <- R6::R6Class(
  "GetStarsRevenueAdsAccountUrlRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xd1d7efc5,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x4a228b15,
    #  @field peer Field.
    peer = NULL,

    #  @description Initialize the GetStarsRevenueAdsAccountUrlRequest object.
    #  @param peer The input peer (TypeInputPeer).
    initialize = function(peer) {
      self$peer <- peer
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetStarsRevenueAdsAccountUrlRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xc5, 0xef, 0xd7, 0xd1)),
        self$peer$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetStarsRevenueAdsAccountUrlRequest.
    from_reader = function(reader) {
      peer <- reader$tgread_object()
      self$initialize(peer)
      self
    }
  )
)


#  @title GetStarsRevenueStatsRequest
#  @description Telegram API type GetStarsRevenueStatsRequest
#  @export
#  @noRd
#  @noRd
GetStarsRevenueStatsRequest <- R6::R6Class(
  "GetStarsRevenueStatsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xd91ffad6,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xa54755f3,
    #  @field peer Field.
    peer = NULL,
    #  @field dark Field.
    dark = NULL,
    #  @field ton Field.
    ton = NULL,

    #  @description Initialize the GetStarsRevenueStatsRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param dark Optional boolean flag for dark mode.
    #  @param ton Optional boolean flag for TON.
    initialize = function(peer, dark = NULL, ton = NULL) {
      self$peer <- peer
      self$dark <- dark
      self$ton <- ton
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetStarsRevenueStatsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "dark" = self$dark,
        "ton" = self$ton
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xd6, 0xfa, 0x1f, 0xd9)),
        pack("<I", (if (is.null(self$dark) || !self$dark) 0 else 1) | (if (is.null(self$ton) || !self$ton) 0 else 2)),
        self$peer$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetStarsRevenueStatsRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      dark <- bitwAnd(flags, 1) != 0
      ton <- bitwAnd(flags, 2) != 0
      peer <- reader$tgread_object()
      self$initialize(peer, dark, ton)
      self
    }
  )
)

#  @title GetStarsRevenueWithdrawalUrlRequest
#  @description Telegram API type GetStarsRevenueWithdrawalUrlRequest
#  @export
#  @noRd
#  @noRd
GetStarsRevenueWithdrawalUrlRequest <- R6::R6Class(
  "GetStarsRevenueWithdrawalUrlRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x2433dc92,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8466a0ee,
    #  @field peer Field.
    peer = NULL,
    #  @field password Field.
    password = NULL,
    #  @field ton Field.
    ton = NULL,
    #  @field amount Field.
    amount = NULL,

    #  @description Initialize the GetStarsRevenueWithdrawalUrlRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param password The input check password SRP (TypeInputCheckPasswordSRP).
    #  @param ton Optional boolean flag for TON.
    #  @param amount Optional amount (integer).
    initialize = function(peer, password, ton = NULL, amount = NULL) {
      self$peer <- peer
      self$password <- password
      self$ton <- ton
      self$amount <- amount
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetStarsRevenueWithdrawalUrlRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "password" = if (inherits(self$password, "TLObject")) self$password$to_dict() else self$password,
        "ton" = self$ton,
        "amount" = self$amount
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x92, 0xdc, 0x33, 0x24)),
        pack("<I", (if (is.null(self$ton) || !self$ton) 0 else 1) | (if (is.null(self$amount) || self$amount == 0) 0 else 2)),
        self$peer$bytes(),
        if (!is.null(self$amount) && self$amount != 0) pack("<q", self$amount) else raw(),
        self$password$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetStarsRevenueWithdrawalUrlRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      ton <- bitwAnd(flags, 1) != 0
      peer <- reader$tgread_object()
      amount <- if (bitwAnd(flags, 2) != 0) reader$read_long() else NULL
      password <- reader$tgread_object()
      self$initialize(peer, password, ton, amount)
      self
    }
  )
)


#  @title GetStarsStatusRequest
#  @description Telegram API type GetStarsStatusRequest
#  @export
#  @noRd
#  @noRd
GetStarsStatusRequest <- R6::R6Class(
  "GetStarsStatusRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x4ea9b3bf,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x6e9c1d6f,
    #  @field peer Field.
    peer = NULL,
    #  @field ton Field.
    ton = NULL,

    #  @description Initialize the GetStarsStatusRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param ton Optional boolean flag for TON.
    initialize = function(peer, ton = NULL) {
      self$peer <- peer
      self$ton <- ton
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetStarsStatusRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "ton" = self$ton
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xbf, 0xb3, 0xa9, 0x4e)),
        pack("<I", if (is.null(self$ton) || !self$ton) 0 else 1),
        self$peer$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetStarsStatusRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      ton <- bitwAnd(flags, 1) != 0
      peer <- reader$tgread_object()
      self$initialize(peer, ton)
      self
    }
  )
)

#  @title GetStarsSubscriptionsRequest
#  @description Telegram API type GetStarsSubscriptionsRequest
#  @export
#  @noRd
#  @noRd
GetStarsSubscriptionsRequest <- R6::R6Class(
  "GetStarsSubscriptionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x32512c5,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x6e9c1d6f,
    #  @field peer Field.
    peer = NULL,
    #  @field offset Field.
    offset = NULL,
    #  @field missing_balance Field.
    missing_balance = NULL,

    #  @description Initialize the GetStarsSubscriptionsRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param offset The offset string.
    #  @param missing_balance Optional boolean flag for missing balance.
    initialize = function(peer, offset, missing_balance = NULL) {
      self$peer <- peer
      self$offset <- offset
      self$missing_balance <- missing_balance
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetStarsSubscriptionsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "offset" = self$offset,
        "missing_balance" = self$missing_balance
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xc5, 0x12, 0x25, 0x03)),
        pack("<I", if (is.null(self$missing_balance) || !self$missing_balance) 0 else 1),
        self$peer$bytes(),
        self$serialize_bytes(self$offset)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetStarsSubscriptionsRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      missing_balance <- bitwAnd(flags, 1) != 0
      peer <- reader$tgread_object()
      offset <- reader$tgread_string()
      self$initialize(peer, offset, missing_balance)
      self
    }
  )
)


#  @title GetStarsTopupOptionsRequest
#  @description Represents a request to get stars topup options. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetStarsTopupOptionsRequest <- R6::R6Class(
  "GetStarsTopupOptionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xc00ec7d3,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xd4fe8a99,

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetStarsTopupOptionsRequest"
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      as.raw(c(0xd3, 0xc7, 0x0e, 0xc0))
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetStarsTopupOptionsRequest.
    from_reader = function(reader) {
      self
    }
  )
)

#  @title GetStarsTransactionsRequest
#  @description Telegram API type GetStarsTransactionsRequest
#  @export
#  @noRd
#  @noRd
GetStarsTransactionsRequest <- R6::R6Class(
  "GetStarsTransactionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x69da4557,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x6e9c1d6f,
    #  @field peer Field.
    peer = NULL,
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field inbound Field.
    inbound = NULL,
    #  @field outbound Field.
    outbound = NULL,
    #  @field ascending Field.
    ascending = NULL,
    #  @field ton Field.
    ton = NULL,
    #  @field subscription_id Field.
    subscription_id = NULL,

    #  @description Initialize the GetStarsTransactionsRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param offset The offset string.
    #  @param limit The limit integer.
    #  @param inbound Optional boolean flag for inbound transactions.
    #  @param outbound Optional boolean flag for outbound transactions.
    #  @param ascending Optional boolean flag for ascending order.
    #  @param ton Optional boolean flag for TON.
    #  @param subscription_id Optional subscription ID (string).
    initialize = function(peer, offset, limit, inbound = NULL, outbound = NULL, ascending = NULL, ton = NULL, subscription_id = NULL) {
      self$peer <- peer
      self$offset <- offset
      self$limit <- limit
      self$inbound <- inbound
      self$outbound <- outbound
      self$ascending <- ascending
      self$ton <- ton
      self$subscription_id <- subscription_id
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetStarsTransactionsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "offset" = self$offset,
        "limit" = self$limit,
        "inbound" = self$inbound,
        "outbound" = self$outbound,
        "ascending" = self$ascending,
        "ton" = self$ton,
        "subscription_id" = self$subscription_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$inbound) || !self$inbound) 0 else 1) |
        (if (is.null(self$outbound) || !self$outbound) 0 else 2) |
        (if (is.null(self$ascending) || !self$ascending) 0 else 4) |
        (if (is.null(self$ton) || !self$ton) 0 else 16) |
        (if (is.null(self$subscription_id) || !nzchar(self$subscription_id)) 0 else 8)
      c(
        as.raw(c(0x57, 0x45, 0xda, 0x69)),
        pack("<I", flags),
        if (!is.null(self$subscription_id) && nzchar(self$subscription_id)) self$serialize_bytes(self$subscription_id) else raw(),
        self$peer$bytes(),
        self$serialize_bytes(self$offset),
        pack("<i", self$limit)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetStarsTransactionsRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      inbound <- bitwAnd(flags, 1) != 0
      outbound <- bitwAnd(flags, 2) != 0
      ascending <- bitwAnd(flags, 4) != 0
      ton <- bitwAnd(flags, 16) != 0
      subscription_id <- if (bitwAnd(flags, 8) != 0) reader$tgread_string() else NULL
      peer <- reader$tgread_object()
      offset <- reader$tgread_string()
      limit <- reader$read_int()
      self$initialize(peer, offset, limit, inbound, outbound, ascending, ton, subscription_id)
      self
    }
  )
)


#  @title GetStarsTransactionsByIDRequest
#  @description Telegram API type GetStarsTransactionsByIDRequest
#  @export
#  @noRd
#  @noRd
GetStarsTransactionsByIDRequest <- R6::R6Class(
  "GetStarsTransactionsByIDRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x2dca16b8,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x6e9c1d6f,
    #  @field peer Field.
    peer = NULL,
    #  @field id Field.
    id = NULL,
    #  @field ton Field.
    ton = NULL,

    #  @description Initialize the GetStarsTransactionsByIDRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param id List of input stars transactions (list of TypeInputStarsTransaction).
    #  @param ton Optional boolean flag for TON.
    initialize = function(peer, id, ton = NULL) {
      self$peer <- peer
      self$id <- id
      self$ton <- ton
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetStarsTransactionsByIDRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "id" = if (is.null(self$id)) list() else lapply(self$id, function(x) if (inherits(x, "TLObject")) x$to_dict() else x),
        "ton" = self$ton
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xb8, 0x16, 0xca, 0x2d)),
        pack("<I", if (is.null(self$ton) || !self$ton) 0 else 1),
        self$peer$bytes(),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)), pack("<i", length(self$id)), do.call(c, lapply(self$id, function(x) x$bytes()))
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetStarsTransactionsByIDRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      ton <- bitwAnd(flags, 1) != 0
      peer <- reader$tgread_object()
      reader$read_int()
      id <- lapply(seq_len(reader$read_int()), function(i) reader$tgread_object())
      self$initialize(peer, id, ton)
      self
    }
  )
)

#  @title GetSuggestedStarRefBotsRequest
#  @description Telegram API type GetSuggestedStarRefBotsRequest
#  @export
#  @noRd
#  @noRd
GetSuggestedStarRefBotsRequest <- R6::R6Class(
  "GetSuggestedStarRefBotsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xd6b48f7,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x70189243,
    #  @field peer Field.
    peer = NULL,
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field order_by_revenue Field.
    order_by_revenue = NULL,
    #  @field order_by_date Field.
    order_by_date = NULL,

    #  @description Initialize the GetSuggestedStarRefBotsRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param offset The offset string.
    #  @param limit The limit integer.
    #  @param order_by_revenue Optional boolean flag to order by revenue.
    #  @param order_by_date Optional boolean flag to order by date.
    initialize = function(peer, offset, limit, order_by_revenue = NULL, order_by_date = NULL) {
      self$peer <- peer
      self$offset <- offset
      self$limit <- limit
      self$order_by_revenue <- order_by_revenue
      self$order_by_date <- order_by_date
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetSuggestedStarRefBotsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "offset" = self$offset,
        "limit" = self$limit,
        "order_by_revenue" = self$order_by_revenue,
        "order_by_date" = self$order_by_date
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xf7, 0x48, 0x6b, 0x0d)),
        pack("<I", (if (is.null(self$order_by_revenue) || !self$order_by_revenue) 0 else 1) | (if (is.null(self$order_by_date) || !self$order_by_date) 0 else 2)),
        self$peer$bytes(),
        self$serialize_bytes(self$offset),
        pack("<i", self$limit)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetSuggestedStarRefBotsRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      order_by_revenue <- bitwAnd(flags, 1) != 0
      order_by_date <- bitwAnd(flags, 2) != 0
      peer <- reader$tgread_object()
      offset <- reader$tgread_string()
      limit <- reader$read_int()
      self$initialize(peer, offset, limit, order_by_revenue, order_by_date)
      self
    }
  )
)


#  @title GetUniqueStarGiftRequest
#  @description Represents a request to get a unique star gift. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetUniqueStarGiftRequest <- R6::R6Class(
  "GetUniqueStarGiftRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xa1974d72,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x78b0c5fb,
    #  @field slug Field.
    slug = NULL,

    #  @description Initialize the GetUniqueStarGiftRequest object.
    #  @param slug The slug string.
    initialize = function(slug) {
      self$slug <- slug
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetUniqueStarGiftRequest",
        "slug" = self$slug
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x72, 0x4d, 0x97, 0xa1)),
        self$serialize_bytes(self$slug)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetUniqueStarGiftRequest.
    from_reader = function(reader) {
      slug <- reader$tgread_string()
      self$initialize(slug)
      self
    }
  )
)

#  @title GetUniqueStarGiftValueInfoRequest
#  @description Represents a request to get unique star gift value info. Inherits from TLRequest.
#  @export
#  @noRd
#  @noRd
GetUniqueStarGiftValueInfoRequest <- R6::R6Class(
  "GetUniqueStarGiftValueInfoRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x4365af6b,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x16355bc4,
    #  @field slug Field.
    slug = NULL,

    #  @description Initialize the GetUniqueStarGiftValueInfoRequest object.
    #  @param slug The slug string.
    initialize = function(slug) {
      self$slug <- slug
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "GetUniqueStarGiftValueInfoRequest",
        "slug" = self$slug
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x6b, 0xaf, 0x65, 0x43)),
        self$serialize_bytes(self$slug)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of GetUniqueStarGiftValueInfoRequest.
    from_reader = function(reader) {
      slug <- reader$tgread_string()
      self$initialize(slug)
      self
    }
  )
)

#  @title LaunchPrepaidGiveawayRequest
#  @description Telegram API type LaunchPrepaidGiveawayRequest
#  @export
#  @noRd
#  @noRd
LaunchPrepaidGiveawayRequest <- R6::R6Class(
  "LaunchPrepaidGiveawayRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x5ff58f20,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field peer Field.
    peer = NULL,
    #  @field giveaway_id Field.
    giveaway_id = NULL,
    #  @field purpose Field.
    purpose = NULL,

    #  @description Initialize the LaunchPrepaidGiveawayRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param giveaway_id The giveaway ID (integer).
    #  @param purpose The input store payment purpose (TypeInputStorePaymentPurpose).
    initialize = function(peer, giveaway_id, purpose) {
      self$peer <- peer
      self$giveaway_id <- giveaway_id
      self$purpose <- purpose
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "LaunchPrepaidGiveawayRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "giveaway_id" = self$giveaway_id,
        "purpose" = if (inherits(self$purpose, "TLObject")) self$purpose$to_dict() else self$purpose
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x20, 0x8f, 0xf5, 0x5f)),
        self$peer$bytes(),
        pack("<q", self$giveaway_id),
        self$purpose$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of LaunchPrepaidGiveawayRequest.
    from_reader = function(reader) {
      peer <- reader$tgread_object()
      giveaway_id <- reader$read_long()
      purpose <- reader$tgread_object()
      self$initialize(peer, giveaway_id, purpose)
      self
    }
  )
)


#  @title RefundStarsChargeRequest
#  @description Telegram API type RefundStarsChargeRequest
#  @export
#  @noRd
#  @noRd
RefundStarsChargeRequest <- R6::R6Class(
  "RefundStarsChargeRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x25ae8f4a,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field user_id Field.
    user_id = NULL,
    #  @field charge_id Field.
    charge_id = NULL,

    #  @description Initialize the RefundStarsChargeRequest object.
    #  @param user_id The input user (TypeInputUser).
    #  @param charge_id The charge ID (string).
    initialize = function(user_id, charge_id) {
      self$user_id <- user_id
      self$charge_id <- charge_id
    },

    #  @description Resolve the user_id using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$user_id <- utils$get_input_user((client$get_input_entity(self$user_id)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "RefundStarsChargeRequest",
        "user_id" = if (inherits(self$user_id, "TLObject")) self$user_id$to_dict() else self$user_id,
        "charge_id" = self$charge_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x4a, 0x8f, 0xae, 0x25)),
        self$user_id$bytes(),
        self$serialize_bytes(self$charge_id)
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of RefundStarsChargeRequest.
    from_reader = function(reader) {
      user_id <- reader$tgread_object()
      charge_id <- reader$tgread_string()
      self$initialize(user_id, charge_id)
      self
    }
  )
)

#  @title ReorderStarGiftCollectionsRequest
#  @description Telegram API type ReorderStarGiftCollectionsRequest
#  @export
#  @noRd
#  @noRd
ReorderStarGiftCollectionsRequest <- R6::R6Class(
  "ReorderStarGiftCollectionsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xc32af4cc,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field peer Field.
    peer = NULL,
    #  @field order Field.
    order = NULL,

    #  @description Initialize the ReorderStarGiftCollectionsRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param order The order list of integers.
    initialize = function(peer, order) {
      self$peer <- peer
      self$order <- order
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "ReorderStarGiftCollectionsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "order" = if (is.null(self$order)) list() else self$order
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xcc, 0xf4, 0x2a, 0xc3)),
        self$peer$bytes(),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)), pack("<i", length(self$order)), do.call(c, lapply(self$order, function(x) pack("<i", x)))
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of ReorderStarGiftCollectionsRequest.
    from_reader = function(reader) {
      peer <- reader$tgread_object()
      reader$read_int()
      order <- lapply(seq_len(reader$read_int()), function(i) reader$read_int())
      self$initialize(peer, order)
      self
    }
  )
)

#  @title SaveStarGiftRequest
#  @description Telegram API type SaveStarGiftRequest
#  @export
#  @noRd
#  @noRd
SaveStarGiftRequest <- R6::R6Class(
  "SaveStarGiftRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x2a2a697c,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field stargift Field.
    stargift = NULL,
    #  @field unsave Field.
    unsave = NULL,

    #  @description Initialize the SaveStarGiftRequest object.
    #  @param stargift The input saved star gift (TypeInputSavedStarGift).
    #  @param unsave Optional boolean flag to unsave.
    initialize = function(stargift, unsave = NULL) {
      self$stargift <- stargift
      self$unsave <- unsave
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "SaveStarGiftRequest",
        "stargift" = if (inherits(self$stargift, "TLObject")) self$stargift$to_dict() else self$stargift,
        "unsave" = self$unsave
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x7c, 0x69, 0x2a, 0x2a)),
        pack("<I", if (is.null(self$unsave) || !self$unsave) 0 else 1),
        self$stargift$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of SaveStarGiftRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      unsave <- bitwAnd(flags, 1) != 0
      stargift <- reader$tgread_object()
      self$initialize(stargift, unsave)
      self
    }
  )
)


#  @title SendPaymentFormRequest
#  @description Telegram API type SendPaymentFormRequest
#  @export
#  @noRd
#  @noRd
SendPaymentFormRequest <- R6::R6Class(
  "SendPaymentFormRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x2d03522f,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8ae16a9d,
    #  @field form_id Field.
    form_id = NULL,
    #  @field invoice Field.
    invoice = NULL,
    #  @field credentials Field.
    credentials = NULL,
    #  @field requested_info_id Field.
    requested_info_id = NULL,
    #  @field shipping_option_id Field.
    shipping_option_id = NULL,
    #  @field tip_amount Field.
    tip_amount = NULL,

    #  @description Initialize the SendPaymentFormRequest object.
    #  @param form_id The form ID (integer).
    #  @param invoice The input invoice (TypeInputInvoice).
    #  @param credentials The input payment credentials (TypeInputPaymentCredentials).
    #  @param requested_info_id Optional requested info ID (string).
    #  @param shipping_option_id Optional shipping option ID (string).
    #  @param tip_amount Optional tip amount (integer).
    initialize = function(form_id, invoice, credentials, requested_info_id = NULL, shipping_option_id = NULL, tip_amount = NULL) {
      self$form_id <- form_id
      self$invoice <- invoice
      self$credentials <- credentials
      self$requested_info_id <- requested_info_id
      self$shipping_option_id <- shipping_option_id
      self$tip_amount <- tip_amount
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "SendPaymentFormRequest",
        "form_id" = self$form_id,
        "invoice" = if (inherits(self$invoice, "TLObject")) self$invoice$to_dict() else self$invoice,
        "credentials" = if (inherits(self$credentials, "TLObject")) self$credentials$to_dict() else self$credentials,
        "requested_info_id" = self$requested_info_id,
        "shipping_option_id" = self$shipping_option_id,
        "tip_amount" = self$tip_amount
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$requested_info_id) || !nzchar(self$requested_info_id)) 0 else 1) |
        (if (is.null(self$shipping_option_id) || !nzchar(self$shipping_option_id)) 0 else 2) |
        (if (is.null(self$tip_amount)) 0 else 4)
      c(
        as.raw(c(0x2f, 0x52, 0x03, 0x2d)),
        pack("<I", flags),
        pack("<q", self$form_id),
        self$invoice$bytes(),
        if (!is.null(self$requested_info_id) && nzchar(self$requested_info_id)) self$serialize_bytes(self$requested_info_id) else raw(),
        if (!is.null(self$shipping_option_id) && nzchar(self$shipping_option_id)) self$serialize_bytes(self$shipping_option_id) else raw(),
        self$credentials$bytes(),
        if (!is.null(self$tip_amount)) pack("<q", self$tip_amount) else raw()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of SendPaymentFormRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      form_id <- reader$read_long()
      invoice <- reader$tgread_object()
      requested_info_id <- if (bitwAnd(flags, 1) != 0) reader$tgread_string() else NULL
      shipping_option_id <- if (bitwAnd(flags, 2) != 0) reader$tgread_string() else NULL
      credentials <- reader$tgread_object()
      tip_amount <- if (bitwAnd(flags, 4) != 0) reader$read_long() else NULL
      self$initialize(form_id, invoice, credentials, requested_info_id, shipping_option_id, tip_amount)
      self
    }
  )
)

#  @title SendStarsFormRequest
#  @description Telegram API type SendStarsFormRequest
#  @export
#  @noRd
#  @noRd
SendStarsFormRequest <- R6::R6Class(
  "SendStarsFormRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x7998c914,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8ae16a9d,
    #  @field form_id Field.
    form_id = NULL,
    #  @field invoice Field.
    invoice = NULL,

    #  @description Initialize the SendStarsFormRequest object.
    #  @param form_id The form ID (integer).
    #  @param invoice The input invoice (TypeInputInvoice).
    initialize = function(form_id, invoice) {
      self$form_id <- form_id
      self$invoice <- invoice
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "SendStarsFormRequest",
        "form_id" = self$form_id,
        "invoice" = if (inherits(self$invoice, "TLObject")) self$invoice$to_dict() else self$invoice
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x14, 0xc9, 0x98, 0x79)),
        pack("<q", self$form_id),
        self$invoice$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of SendStarsFormRequest.
    from_reader = function(reader) {
      form_id <- reader$read_long()
      invoice <- reader$tgread_object()
      self$initialize(form_id, invoice)
      self
    }
  )
)


#  @title ToggleChatStarGiftNotificationsRequest
#  @description Telegram API type ToggleChatStarGiftNotificationsRequest
#  @export
#  @noRd
#  @noRd
ToggleChatStarGiftNotificationsRequest <- R6::R6Class(
  "ToggleChatStarGiftNotificationsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x60eaefa1,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field peer Field.
    peer = NULL,
    #  @field enabled Field.
    enabled = NULL,

    #  @description Initialize the ToggleChatStarGiftNotificationsRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param enabled Optional boolean flag to enable notifications.
    initialize = function(peer, enabled = NULL) {
      self$peer <- peer
      self$enabled <- enabled
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "ToggleChatStarGiftNotificationsRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "enabled" = self$enabled
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xa1, 0xef, 0xea, 0x60)),
        pack("<I", if (is.null(self$enabled) || !self$enabled) 0 else 1),
        self$peer$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of ToggleChatStarGiftNotificationsRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      enabled <- bitwAnd(flags, 1) != 0
      peer <- reader$tgread_object()
      self$initialize(peer, enabled)
      self
    }
  )
)

#  @title ToggleStarGiftsPinnedToTopRequest
#  @description Telegram API type ToggleStarGiftsPinnedToTopRequest
#  @export
#  @noRd
#  @noRd
ToggleStarGiftsPinnedToTopRequest <- R6::R6Class(
  "ToggleStarGiftsPinnedToTopRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x1513e7b0,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field peer Field.
    peer = NULL,
    #  @field stargift Field.
    stargift = NULL,

    #  @description Initialize the ToggleStarGiftsPinnedToTopRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param stargift List of input saved star gifts (list of TypeInputSavedStarGift).
    initialize = function(peer, stargift) {
      self$peer <- peer
      self$stargift <- stargift
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer(client$get_input_entity(self$peer))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "ToggleStarGiftsPinnedToTopRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "stargift" = if (is.null(self$stargift)) list() else lapply(self$stargift, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xb0, 0xe7, 0x13, 0x15)),
        self$peer$bytes(),
        as.raw(c(0x1c, 0xb5, 0xc4, 0x15)), pack("<i", length(self$stargift)), do.call(c, lapply(self$stargift, function(x) x$bytes()))
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of ToggleStarGiftsPinnedToTopRequest.
    from_reader = function(reader) {
      peer <- reader$tgread_object()
      reader$read_int()
      stargift <- lapply(seq_len(reader$read_int()), function(i) reader$tgread_object())
      self$initialize(peer, stargift)
      self
    }
  )
)

#  @title TransferStarGiftRequest
#  @description Telegram API type TransferStarGiftRequest
#  @export
#  @noRd
#  @noRd
TransferStarGiftRequest <- R6::R6Class(
  "TransferStarGiftRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x7f18176a,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field stargift Field.
    stargift = NULL,
    #  @field to_id Field.
    to_id = NULL,

    #  @description Initialize the TransferStarGiftRequest object.
    #  @param stargift The input saved star gift (TypeInputSavedStarGift).
    #  @param to_id The input peer to transfer to (TypeInputPeer).
    initialize = function(stargift, to_id) {
      self$stargift <- stargift
      self$to_id <- to_id
    },

    #  @description Resolve the to_id using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$to_id <- utils$get_input_peer(client$get_input_entity(self$to_id))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "TransferStarGiftRequest",
        "stargift" = if (inherits(self$stargift, "TLObject")) self$stargift$to_dict() else self$stargift,
        "to_id" = if (inherits(self$to_id, "TLObject")) self$to_id$to_dict() else self$to_id
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0x6a, 0x17, 0x18, 0x7f)),
        self$stargift$bytes(),
        self$to_id$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of TransferStarGiftRequest.
    from_reader = function(reader) {
      stargift <- reader$tgread_object()
      to_id <- reader$tgread_object()
      self$initialize(stargift, to_id)
      self
    }
  )
)


#  @title UpdateStarGiftCollectionRequest
#  @description Telegram API type UpdateStarGiftCollectionRequest
#  @export
#  @noRd
#  @noRd
UpdateStarGiftCollectionRequest <- R6::R6Class(
  "UpdateStarGiftCollectionRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x4fddbee7,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x43e0cb4a,
    #  @field peer Field.
    peer = NULL,
    #  @field collection_id Field.
    collection_id = NULL,
    #  @field title Field.
    title = NULL,
    #  @field delete_stargift Field.
    delete_stargift = NULL,
    #  @field add_stargift Field.
    add_stargift = NULL,
    #  @field order Field.
    order = NULL,

    #  @description Initialize the UpdateStarGiftCollectionRequest object.
    #  @param peer The input peer (TypeInputPeer).
    #  @param collection_id The collection ID (integer).
    #  @param title Optional title (string).
    #  @param delete_stargift Optional list of star gifts to delete (list of TypeInputSavedStarGift).
    #  @param add_stargift Optional list of star gifts to add (list of TypeInputSavedStarGift).
    #  @param order Optional order of star gifts (list of TypeInputSavedStarGift).
    initialize = function(peer, collection_id, title = NULL, delete_stargift = NULL, add_stargift = NULL, order = NULL) {
      self$peer <- peer
      self$collection_id <- collection_id
      self$title <- title
      self$delete_stargift <- delete_stargift
      self$add_stargift <- add_stargift
      self$order <- order
    },

    #  @description Resolve the peer using client and utils.
    #  @param client The client object.
    #  @param utils The utils object.
    resolve = function(client, utils) {
      self$peer <- utils$get_input_peer((client$get_input_entity(self$peer)))
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "UpdateStarGiftCollectionRequest",
        "peer" = if (inherits(self$peer, "TLObject")) self$peer$to_dict() else self$peer,
        "collection_id" = self$collection_id,
        "title" = self$title,
        "delete_stargift" = if (is.null(self$delete_stargift)) list() else lapply(self$delete_stargift, function(x) if (inherits(x, "TLObject")) x$to_dict() else x),
        "add_stargift" = if (is.null(self$add_stargift)) list() else lapply(self$add_stargift, function(x) if (inherits(x, "TLObject")) x$to_dict() else x),
        "order" = if (is.null(self$order)) list() else lapply(self$order, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      flags <- (if (is.null(self$title) || !nzchar(self$title)) 0 else 1) |
        (if (is.null(self$delete_stargift)) 0 else 2) |
        (if (is.null(self$add_stargift)) 0 else 4) |
        (if (is.null(self$order)) 0 else 8)
      c(
        as.raw(c(0xe7, 0xbe, 0xdd, 0x4f)),
        pack("<I", flags),
        self$peer$bytes(),
        pack("<i", self$collection_id),
        if (!is.null(self$title) && nzchar(self$title)) self$serialize_bytes(self$title) else raw(),
        if (!is.null(self$delete_stargift)) c(as.raw(c(0x1c, 0xb5, 0xc4, 0x15)), pack("<i", length(self$delete_stargift)), do.call(c, lapply(self$delete_stargift, function(x) x$bytes()))) else raw(),
        if (!is.null(self$add_stargift)) c(as.raw(c(0x1c, 0xb5, 0xc4, 0x15)), pack("<i", length(self$add_stargift)), do.call(c, lapply(self$add_stargift, function(x) x$bytes()))) else raw(),
        if (!is.null(self$order)) c(as.raw(c(0x1c, 0xb5, 0xc4, 0x15)), pack("<i", length(self$order)), do.call(c, lapply(self$order, function(x) x$bytes()))) else raw()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of UpdateStarGiftCollectionRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      peer <- reader$tgread_object()
      collection_id <- reader$read_int()
      title <- if (bitwAnd(flags, 1) != 0) reader$tgread_string() else NULL
      delete_stargift <- if (bitwAnd(flags, 2) != 0) {
        reader$read_int()
        lapply(seq_len(reader$read_int()), function(i) reader$tgread_object())
      } else {
        NULL
      }
      add_stargift <- if (bitwAnd(flags, 4) != 0) {
        reader$read_int()
        lapply(seq_len(reader$read_int()), function(i) reader$tgread_object())
      } else {
        NULL
      }
      order <- if (bitwAnd(flags, 8) != 0) {
        reader$read_int()
        lapply(seq_len(reader$read_int()), function(i) reader$tgread_object())
      } else {
        NULL
      }
      self$initialize(peer, collection_id, title, delete_stargift, add_stargift, order)
      self
    }
  )
)

#  @title UpdateStarGiftPriceRequest
#  @description Telegram API type UpdateStarGiftPriceRequest
#  @export
#  @noRd
#  @noRd
UpdateStarGiftPriceRequest <- R6::R6Class(
  "UpdateStarGiftPriceRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xedbe6ccb,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field stargift Field.
    stargift = NULL,
    #  @field resell_amount Field.
    resell_amount = NULL,

    #  @description Initialize the UpdateStarGiftPriceRequest object.
    #  @param stargift The input saved star gift (TypeInputSavedStarGift).
    #  @param resell_amount The resell amount (TypeStarsAmount).
    initialize = function(stargift, resell_amount) {
      self$stargift <- stargift
      self$resell_amount <- resell_amount
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "UpdateStarGiftPriceRequest",
        "stargift" = if (inherits(self$stargift, "TLObject")) self$stargift$to_dict() else self$stargift,
        "resell_amount" = if (inherits(self$resell_amount, "TLObject")) self$resell_amount$to_dict() else self$resell_amount
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      c(
        as.raw(c(0xcb, 0x6c, 0xbe, 0xed)),
        self$stargift$bytes(),
        self$resell_amount$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of UpdateStarGiftPriceRequest.
    from_reader = function(reader) {
      stargift <- reader$tgread_object()
      resell_amount <- reader$tgread_object()
      self$initialize(stargift, resell_amount)
      self
    }
  )
)


#  @title UpgradeStarGiftRequest
#  @description Telegram API type UpgradeStarGiftRequest
#  @export
#  @noRd
#  @noRd
UpgradeStarGiftRequest <- R6::R6Class(
  "UpgradeStarGiftRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xaed6e4f5,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field stargift Field.
    stargift = NULL,
    #  @field keep_original_details Field.
    keep_original_details = NULL,

    #  @description Initialize the UpgradeStarGiftRequest object.
    #  @param stargift The input saved star gift (TypeInputSavedStarGift).
    #  @param keep_original_details Optional boolean flag to keep original details.
    initialize = function(stargift, keep_original_details = NULL) {
      self$stargift <- stargift
      self$keep_original_details <- keep_original_details
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "UpgradeStarGiftRequest",
        "stargift" = if (inherits(self$stargift, "TLObject")) self$stargift$to_dict() else self$stargift,
        "keep_original_details" = self$keep_original_details
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      # Note: This is a placeholder; actual byte serialization would require R equivalents of struct.pack and byte joining.
      # Assuming serialize_bytes and _bytes methods are available from parent or utils.
      c(
        as.raw(c(0xf5, 0xe4, 0xd6, 0xae)),
        pack("<I", if (is.null(self$keep_original_details) || !self$keep_original_details) 0 else 1),
        self$stargift$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of UpgradeStarGiftRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      keep_original_details <- bitwAnd(flags, 1) != 0
      stargift <- reader$tgread_object()
      self$initialize(stargift, keep_original_details)
      self
    }
  )
)

#  @title ValidateRequestedInfoRequest
#  @description Telegram API type ValidateRequestedInfoRequest
#  @export
#  @noRd
#  @noRd
ValidateRequestedInfoRequest <- R6::R6Class(
  "ValidateRequestedInfoRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xb6c8f12b,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8f8044b7,
    #  @field invoice Field.
    invoice = NULL,
    #  @field info Field.
    info = NULL,
    #  @field save Field.
    save = NULL,

    #  @description Initialize the ValidateRequestedInfoRequest object.
    #  @param invoice The input invoice (TypeInputInvoice).
    #  @param info The payment requested info (TypePaymentRequestedInfo).
    #  @param save Optional boolean flag to save the info.
    initialize = function(invoice, info, save = NULL) {
      self$invoice <- invoice
      self$info <- info
      self$save <- save
    },

    #  @description Convert the object to a dictionary-like list.
    #  @return A list representing the object in dictionary form.
    to_dict = function() {
      list(
        "_" = "ValidateRequestedInfoRequest",
        "invoice" = if (inherits(self$invoice, "TLObject")) self$invoice$to_dict() else self$invoice,
        "info" = if (inherits(self$info, "TLObject")) self$info$to_dict() else self$info,
        "save" = self$save
      )
    },

    #  @description Serialize the object to bytes.
    #  @return A raw vector of bytes.
    bytes = function() {
      # Note: This is a placeholder; actual byte serialization would require R equivalents of struct.pack and byte joining.
      # Assuming serialize_bytes and _bytes methods are available from parent or utils.
      c(
        as.raw(c(0x2b, 0xf1, 0xc8, 0xb6)),
        pack("<I", if (is.null(self$save) || !self$save) 0 else 1),
        self$invoice$bytes(),
        self$info$bytes()
      )
    },

    #  @description Deserialize from a reader.
    #  @param reader The reader object.
    #  @return An instance of ValidateRequestedInfoRequest.
    from_reader = function(reader) {
      flags <- reader$read_int()
      save <- bitwAnd(flags, 1) != 0
      invoice <- reader$tgread_object()
      info <- reader$tgread_object()
      self$initialize(invoice, info, save)
      self
    }
  )
)
