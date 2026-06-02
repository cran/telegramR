#  AddStickerToSetRequest R6 class
# 
#  Represents a request to add a sticker to a sticker set.
# 
# 
#  @section Methods:
#  - initialize(stickerset, sticker): create instance.
#  - resolve(client, utils): resolve friendly references to TL inputs (optional helper).
#  - to_list(): returns a list representation suitable for JSON/inspection.
#  - to_bytes(): returns a raw vector representing serialized bytes (TL-like).
#  - from_reader(reader): reads a request from a reader object and returns a new instance.
# 
#  All methods are exported as part of the R6 object.
# 
#  @title AddStickerToSetRequest
#  @description Telegram API type AddStickerToSetRequest
#  @export
#  @noRd
#  @noRd
AddStickerToSetRequest <- R6::R6Class(
  "AddStickerToSetRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x8653febe,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x9b704a5a,
    #  @field stickerset Field.
    stickerset = NULL,
    #  @field sticker Field.
    sticker = NULL,

    #  @description Initialize AddStickerToSetRequest
    # 
    #  @param stickerset InputStickerSet (TL object or representation)
    #  @param sticker InputStickerSetItem (TL object or representation)
    initialize = function(stickerset, sticker) {
      if (missing(stickerset)) stop("stickerset is required")
      if (missing(sticker)) stop("sticker is required")
      self$stickerset <- stickerset
      self$sticker <- sticker
      invisible(self)
    },

    #  @description Optionally resolve friendly inputs to TL input objects
    # 
    #  @param client client object (used for entity resolution if needed)
    #  @param utils utilities object with helper conversions (may implement get_input_document / get_input_user)
    resolve = function(client, utils) {
      # If utilities provide resolution functions, apply them (no-op otherwise)
      if (!is.null(utils) && is.function(utils$get_input_document)) {
        # stickerset may be an InputStickerSet, often no conversion; keep conservative
        try(self$stickerset <- utils$get_input_document(self$stickerset), silent = TRUE)
        try(self$sticker <- utils$get_input_document(self$sticker), silent = TRUE)
      }
      invisible(self)
    },

    #  @description Convert to an R list
    # 
    #  @return list representation
    to_list = function() {
      list(
        `_` = "AddStickerToSetRequest",
        stickerset = if (inherits(self$stickerset, "TLObject")) self$stickerset$to_list() else self$stickerset,
        sticker = if (inherits(self$sticker, "TLObject")) self$sticker$to_list() else self$sticker
      )
    },

    #  @description Serialize to raw bytes (TL-like approximation)
    # 
    #  @return raw vector
    to_bytes = function() {
      constructor_bytes <- as.raw(c(
        bitwAnd(self$CONSTRUCTOR_ID, 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 8), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 16), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 24), 0xFF)
      ))

      stickerset_bytes <- if (inherits(self$stickerset, "TLObject") && is.function(self$stickerset$to_bytes)) {
        self$stickerset$to_bytes()
      } else if (is.raw(self$stickerset)) {
        self$stickerset
      } else {
        raw(0)
      }

      sticker_bytes <- if (inherits(self$sticker, "TLObject") && is.function(self$sticker$to_bytes)) {
        self$sticker$to_bytes()
      } else if (is.raw(self$sticker)) {
        self$sticker
      } else {
        raw(0)
      }

      c(constructor_bytes, stickerset_bytes, sticker_bytes)
    }
  )
)

#  Create AddStickerToSetRequest from a reader
# 
#  The reader object is expected to provide method tgread_object().
# 
#  @param reader Reader object
#  @return AddStickerToSetRequest instance
#  @export
AddStickerToSetRequest$set("public", "from_reader", function(reader) {
  stickerset_obj <- reader$tgread_object()
  sticker_obj <- reader$tgread_object()
  AddStickerToSetRequest$new(stickerset = stickerset_obj, sticker = sticker_obj)
})


#  ChangeStickerRequest R6 class
# 
#  Represents a request to change sticker attributes (emoji, mask coordinates, keywords).
# 
# 
#  @section Methods:
#  - initialize(sticker, emoji = NULL, mask_coords = NULL, keywords = NULL): create instance.
#  - resolve(client, utils): resolve friendly references to TL inputs (documents).
#  - to_list(): returns a list representation suitable for JSON/inspection.
#  - to_bytes(): returns a raw vector representing serialized bytes (TL-like).
#  - from_reader(reader): reads a request from a reader object and returns a new instance.
# 
#  All methods are exported as part of the R6 object.
# 
#  @title ChangeStickerRequest
#  @description Telegram API type ChangeStickerRequest
#  @export
#  @noRd
#  @noRd
ChangeStickerRequest <- R6::R6Class(
  "ChangeStickerRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xf5537ebc,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x9b704a5a,
    #  @field sticker Field.
    sticker = NULL,
    #  @field emoji Field.
    emoji = NULL,
    #  @field mask_coords Field.
    mask_coords = NULL,
    #  @field keywords Field.
    keywords = NULL,

    #  @description Initialize a ChangeStickerRequest
    # 
    #  @param sticker InputDocument (TL object or representation)
    #  @param emoji optional character emoji string
    #  @param mask_coords optional MaskCoords TL object (or raw representation)
    #  @param keywords optional character keywords string
    initialize = function(sticker, emoji = NULL, mask_coords = NULL, keywords = NULL) {
      if (missing(sticker)) stop("sticker is required")
      self$sticker <- sticker
      self$emoji <- if (is.null(emoji)) NULL else as.character(emoji)
      self$mask_coords <- mask_coords
      self$keywords <- if (is.null(keywords)) NULL else as.character(keywords)
      invisible(self)
    },

    #  @description Resolve friendly inputs to TL input objects
    # 
    #  @param client client object (used for entity resolution if needed)
    #  @param utils utilities object with helper conversions (must implement get_input_document)
    resolve = function(client, utils) {
      # convert user-friendly sticker references to an InputDocument TL object
      self$sticker <- utils$get_input_document(self$sticker)
      invisible(self)
    },

    #  @description Convert to an R list
    # 
    #  @return list representation
    to_list = function() {
      list(
        `_` = "ChangeStickerRequest",
        sticker = if (inherits(self$sticker, "TLObject")) self$sticker$to_list() else self$sticker,
        emoji = self$emoji,
        mask_coords = if (inherits(self$mask_coords, "TLObject")) self$mask_coords$to_list() else self$mask_coords,
        keywords = self$keywords
      )
    },

    #  @description Serialize to raw bytes (TL-like approximation)
    # 
    #  @return raw vector
    to_bytes = function() {
      int32_to_raw_le <- function(x) {
        x <- as.integer(x)
        as.raw(c(
          bitwAnd(x, 0xFF),
          bitwAnd(bitwShiftR(x, 8), 0xFF),
          bitwAnd(bitwShiftR(x, 16), 0xFF),
          bitwAnd(bitwShiftR(x, 24), 0xFF)
        ))
      }
      serialize_string <- function(s) {
        sbytes <- charToRaw(enc2utf8(s))
        c(int32_to_raw_le(length(sbytes)), sbytes)
      }

      constructor_bytes <- as.raw(c(
        bitwAnd(self$CONSTRUCTOR_ID, 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 8), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 16), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 24), 0xFF)
      ))

      flag_emoji <- if (!is.null(self$emoji)) 1L else 0L
      flag_mask_coords <- if (!is.null(self$mask_coords)) 2L else 0L
      flag_keywords <- if (!is.null(self$keywords)) 4L else 0L
      flags <- flag_emoji + flag_mask_coords + flag_keywords
      flags_bytes <- int32_to_raw_le(flags)

      sticker_bytes <- if (inherits(self$sticker, "TLObject") && is.function(self$sticker$to_bytes)) {
        self$sticker$to_bytes()
      } else if (is.raw(self$sticker)) {
        self$sticker
      } else {
        raw(0)
      }

      emoji_bytes <- if (!is.null(self$emoji)) serialize_string(self$emoji) else raw(0)

      mask_coords_bytes <- if (!is.null(self$mask_coords) && inherits(self$mask_coords, "TLObject") && is.function(self$mask_coords$to_bytes)) {
        self$mask_coords$to_bytes()
      } else if (!is.null(self$mask_coords) && is.raw(self$mask_coords)) {
        self$mask_coords
      } else {
        raw(0)
      }

      keywords_bytes <- if (!is.null(self$keywords)) serialize_string(self$keywords) else raw(0)

      c(constructor_bytes, flags_bytes, sticker_bytes, emoji_bytes, mask_coords_bytes, keywords_bytes)
    }
  )
)

#  Create ChangeStickerRequest from a reader
# 
#  The reader object is expected to provide methods:
#  - read_int() -> integer (32-bit)
#  - tgread_object() -> returns a TL object
#  - tgread_string() -> returns a string
# 
#  @param reader Reader object
#  @return ChangeStickerRequest instance
#  @export
ChangeStickerRequest$set("public", "from_reader", function(reader) {
  flags_val <- reader$read_int()
  sticker_obj <- reader$tgread_object()
  emoji_val <- if (bitwAnd(flags_val, 1L) != 0L) reader$tgread_string() else NULL
  mask_coords_obj <- if (bitwAnd(flags_val, 2L) != 0L) reader$tgread_object() else NULL
  keywords_val <- if (bitwAnd(flags_val, 4L) != 0L) reader$tgread_string() else NULL

  ChangeStickerRequest$new(
    sticker = sticker_obj,
    emoji = emoji_val,
    mask_coords = mask_coords_obj,
    keywords = keywords_val
  )
})


#  ChangeStickerPositionRequest R6 class
# 
#  Represents a request to change a sticker's position within a sticker set.
# 
# 
#  @section Methods:
#  - initialize(sticker, position): create instance.
#  - resolve(client, utils): resolve friendly references to TL inputs (documents).
#  - to_list(): returns a list representation suitable for JSON/inspection.
#  - to_bytes(): returns a raw vector representing serialized bytes (TL-like).
#  - from_reader(reader): reads a request from a reader object and returns a new instance.
# 
#  All methods are exported as part of the R6 object.
# 
#  @title ChangeStickerPositionRequest
#  @description Telegram API type ChangeStickerPositionRequest
#  @export
#  @noRd
#  @noRd
ChangeStickerPositionRequest <- R6::R6Class(
  "ChangeStickerPositionRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xffb6d4ca,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x9b704a5a,
    #  @field sticker Field.
    sticker = NULL,
    #  @field position Field.
    position = NULL,

    #  @description Initialize a ChangeStickerPositionRequest
    # 
    #  @param sticker InputDocument (TL object or representation)
    #  @param position integer new position
    initialize = function(sticker, position) {
      if (missing(sticker)) stop("sticker is required")
      if (missing(position) || !is.numeric(position) || length(position) != 1) stop("position must be a single numeric value")
      self$sticker <- sticker
      self$position <- as.integer(position)
      invisible(self)
    },

    #  @description Resolve friendly inputs to TL input objects
    # 
    #  @param client client object (used for entity resolution if needed)
    #  @param utils utilities object with helper conversions (must implement get_input_document)
    resolve = function(client, utils) {
      # convert user-friendly sticker references to an InputDocument TL object
      self$sticker <- utils$get_input_document(self$sticker)
      invisible(self)
    },

    #  @description Convert to an R list
    # 
    #  @return list representation
    to_list = function() {
      list(
        `_` = "ChangeStickerPositionRequest",
        sticker = if (inherits(self$sticker, "TLObject")) self$sticker$to_list() else self$sticker,
        position = self$position
      )
    },

    #  @description Serialize to raw bytes (TL-like approximation)
    # 
    #  @return raw vector
    to_bytes = function() {
      int32_to_raw_le <- function(x) {
        x <- as.integer(x)
        as.raw(c(
          bitwAnd(x, 0xFF),
          bitwAnd(bitwShiftR(x, 8), 0xFF),
          bitwAnd(bitwShiftR(x, 16), 0xFF),
          bitwAnd(bitwShiftR(x, 24), 0xFF)
        ))
      }

      constructor_bytes <- as.raw(c(
        bitwAnd(self$CONSTRUCTOR_ID, 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 8), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 16), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 24), 0xFF)
      ))

      sticker_bytes <- if (inherits(self$sticker, "TLObject") && is.function(self$sticker$to_bytes)) {
        self$sticker$to_bytes()
      } else if (is.raw(self$sticker)) {
        self$sticker
      } else {
        raw(0)
      }

      position_bytes <- int32_to_raw_le(self$position)

      c(constructor_bytes, sticker_bytes, position_bytes)
    }
  )
)

#  Create ChangeStickerPositionRequest from a reader
# 
#  The reader object is expected to provide methods:
#  - tgread_object() -> returns a TL object
#  - read_int() -> integer (32-bit)
# 
#  @param reader Reader object
#  @return ChangeStickerPositionRequest instance
#  @export
ChangeStickerPositionRequest$set("public", "from_reader", function(reader) {
  sticker_obj <- reader$tgread_object()
  position_val <- reader$read_int()
  ChangeStickerPositionRequest$new(sticker = sticker_obj, position = position_val)
})


#  CheckShortNameRequest R6 class
# 
#  Represents a request to check whether a short name is available/valid.
# 
# 
#  @section Methods:
#  - initialize(short_name): create instance.
#  - to_list(): returns a list representation suitable for JSON/inspection.
#  - to_bytes(): returns a raw vector representing serialized bytes (TL-like).
#  - from_reader(reader): reads a request from a reader object and returns a new instance.
# 
#  @title CheckShortNameRequest
#  @description Telegram API type CheckShortNameRequest
#  @export
#  @noRd
#  @noRd
CheckShortNameRequest <- R6::R6Class(
  "CheckShortNameRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x284b3639,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field short_name Field.
    short_name = NULL,

    #  @description Initialize a CheckShortNameRequest
    # 
    #  @param short_name character short name string
    initialize = function(short_name) {
      if (missing(short_name) || !is.character(short_name) || length(short_name) != 1) stop("short_name must be a single string")
      self$short_name <- short_name
      invisible(self)
    },

    #  @description Convert to an R list
    # 
    #  @return list representation
    to_list = function() {
      list(
        `_` = "CheckShortNameRequest",
        short_name = self$short_name
      )
    },

    #  @description Serialize to raw bytes (TL-like approximation)
    # 
    #  @return raw vector
    to_bytes = function() {
      # constructor bytes (little endian)
      constructor_bytes <- as.raw(c(
        bitwAnd(self$CONSTRUCTOR_ID, 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 8), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 16), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 24), 0xFF)
      ))

      serialize_string <- function(s) {
        sbytes <- charToRaw(enc2utf8(s))
        len_bytes <- as.raw(c(
          bitwAnd(length(sbytes), 0xFF),
          bitwAnd(bitwShiftR(length(sbytes), 8), 0xFF),
          bitwAnd(bitwShiftR(length(sbytes), 16), 0xFF),
          bitwAnd(bitwShiftR(length(sbytes), 24), 0xFF)
        ))
        c(len_bytes, sbytes)
      }

      c(constructor_bytes, serialize_string(self$short_name))
    }
  )
)

#  Create CheckShortNameRequest from a reader
# 
#  Reader must implement tgread_string() returning a single string.
# 
#  @param reader Reader object
#  @return CheckShortNameRequest instance
#  @export
CheckShortNameRequest$set("public", "from_reader", function(reader) {
  short_name_val <- reader$tgread_string()
  CheckShortNameRequest$new(short_name = short_name_val)
})


#  CreateStickerSetRequest R6 class
# 
#  Represents a request to create a sticker set.
# 
# 
#  @section Methods:
#  - initialize(user_id, title, short_name, stickers, masks = NULL, emojis = NULL, text_color = NULL, thumb = NULL, software = NULL): create instance.
#  - resolve(client, utils): resolve friendly references to TL inputs (documents / users).
#  - to_list(): returns a list representation suitable for inspection/JSON.
#  - to_bytes(): returns a raw vector representing serialized bytes (TL-like).
#  - from_reader(reader): static-style constructor that reads values from a reader object.
# 
#  All methods are exported as part of the R6 object.
# 
#  @title CreateStickerSetRequest
#  @description Telegram API type CreateStickerSetRequest
#  @export
#  @noRd
#  @noRd
CreateStickerSetRequest <- R6::R6Class(
  "CreateStickerSetRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x9021ab67,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x9b704a5a,
    #  @field user_id Field.
    user_id = NULL,
    #  @field title Field.
    title = NULL,
    #  @field short_name Field.
    short_name = NULL,
    #  @field stickers Field.
    stickers = NULL,
    #  @field masks Field.
    masks = NULL,
    #  @field emojis Field.
    emojis = NULL,
    #  @field text_color Field.
    text_color = NULL,
    #  @field thumb Field.
    thumb = NULL,
    #  @field software Field.
    software = NULL,

    #  @description Initialize a CreateStickerSetRequest
    # 
    #  @param user_id InputUser (TL object or representation)
    #  @param title character Title string
    #  @param short_name character Short name string
    #  @param stickers list of InputStickerSetItem TL objects (or raw representations)
    #  @param masks logical optional
    #  @param emojis logical optional
    #  @param text_color logical optional
    #  @param thumb optional InputDocument TL object (or raw)
    #  @param software optional character string
    initialize = function(user_id, title, short_name, stickers, masks = NULL, emojis = NULL, text_color = NULL, thumb = NULL, software = NULL) {
      if (missing(user_id)) stop("user_id is required")
      if (missing(title) || !is.character(title) || length(title) != 1) stop("title must be a single string")
      if (missing(short_name) || !is.character(short_name) || length(short_name) != 1) stop("short_name must be a single string")
      if (missing(stickers) || !is.list(stickers)) stop("stickers must be a list of sticker items")
      self$user_id <- user_id
      self$title <- title
      self$short_name <- short_name
      self$stickers <- stickers
      self$masks <- masks
      self$emojis <- emojis
      self$text_color <- text_color
      self$thumb <- thumb
      self$software <- software
      invisible(self)
    },

    #  @description Resolve friendly inputs to TL input objects
    # 
    #  @param client client object (used for entity resolution if needed)
    #  @param utils utilities object with helper conversions (must implement get_input_user and get_input_document)
    resolve = function(client, utils) {
      # resolve user_id via client/utils
      self$user_id <- utils$get_input_user(client$get_input_entity(self$user_id))
      if (!is.null(self$thumb)) {
        self$thumb <- utils$get_input_document(self$thumb)
      }
      invisible(self)
    },

    #  @description Convert to an R list
    # 
    #  @return list representation
    to_list = function() {
      list(
        `_` = "CreateStickerSetRequest",
        user_id = if (inherits(self$user_id, "TLObject")) self$user_id$to_list() else self$user_id,
        title = self$title,
        short_name = self$short_name,
        stickers = if (is.null(self$stickers)) list() else lapply(self$stickers, function(x) if (inherits(x, "TLObject")) x$to_list() else x),
        masks = self$masks,
        emojis = self$emojis,
        text_color = self$text_color,
        thumb = if (inherits(self$thumb, "TLObject")) self$thumb$to_list() else self$thumb,
        software = self$software
      )
    },

    #  @description Serialize to raw bytes (TL-like approximation)
    # 
    #  @return raw vector
    to_bytes = function() {
      int32_to_raw_le <- function(x) {
        x <- as.integer(x)
        as.raw(c(
          bitwAnd(x, 0xFF),
          bitwAnd(bitwShiftR(x, 8), 0xFF),
          bitwAnd(bitwShiftR(x, 16), 0xFF),
          bitwAnd(bitwShiftR(x, 24), 0xFF)
        ))
      }
      serialize_string <- function(s) {
        sbytes <- charToRaw(enc2utf8(s))
        c(int32_to_raw_le(length(sbytes)), sbytes)
      }

      constructor_bytes <- as.raw(c(
        bitwAnd(self$CONSTRUCTOR_ID, 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 8), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 16), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 24), 0xFF)
      ))

      flag_masks <- if (!is.null(self$masks) && isTRUE(self$masks)) 1L else 0L
      flag_emojis <- if (!is.null(self$emojis) && isTRUE(self$emojis)) 32L else 0L
      flag_text_color <- if (!is.null(self$text_color) && isTRUE(self$text_color)) 64L else 0L
      flag_thumb <- if (!is.null(self$thumb)) 4L else 0L
      flag_software <- if (!is.null(self$software)) 8L else 0L

      flags <- flag_masks + flag_emojis + flag_text_color + flag_thumb + flag_software
      flags_bytes <- int32_to_raw_le(flags)

      user_bytes <- if (inherits(self$user_id, "TLObject") && is.function(self$user_id$to_bytes)) {
        self$user_id$to_bytes()
      } else if (is.raw(self$user_id)) {
        self$user_id
      } else {
        raw(0)
      }

      thumb_bytes <- if (!is.null(self$thumb) && inherits(self$thumb, "TLObject") && is.function(self$thumb$to_bytes)) {
        self$thumb$to_bytes()
      } else {
        raw(0)
      }

      # vector constructor for list: 0x1cb5c415 -> bytes in little endian: 0x15 0xC4 0xB5 0x1C
      vector_constructor <- as.raw(c(0x15, 0xC4, 0xB5, 0x1C))
      stickers_len <- if (is.null(self$stickers)) 0L else as.integer(length(self$stickers))
      stickers_len_bytes <- int32_to_raw_le(stickers_len)

      stickers_bytes_list <- list()
      if (!is.null(self$stickers) && length(self$stickers) > 0) {
        for (it in self$stickers) {
          item_bytes <- if (inherits(it, "TLObject") && is.function(it$to_bytes)) {
            it$to_bytes()
          } else if (is.raw(it)) {
            it
          } else {
            raw(0)
          }
          stickers_bytes_list <- c(stickers_bytes_list, list(item_bytes))
        }
      }
      stickers_bytes <- if (length(stickers_bytes_list) == 0) raw(0) else do.call(c, stickers_bytes_list)

      software_bytes <- if (!is.null(self$software)) serialize_string(self$software) else raw(0)

      c(
        constructor_bytes, flags_bytes, user_bytes, serialize_string(self$title), serialize_string(self$short_name),
        (if (length(thumb_bytes) > 0) thumb_bytes else raw(0)),
        vector_constructor, stickers_len_bytes, stickers_bytes,
        software_bytes
      )
    }
  )
)

# Create from_reader as a public function similar to other classes
#  Create CreateStickerSetRequest from a reader
# 
#  The reader object is expected to provide methods:
#  - read_int() -> integer (32-bit)
#  - tgread_object() -> returns a TL object
#  - tgread_string() -> returns a string
# 
#  @param reader Reader object
#  @return CreateStickerSetRequest instance
#  @export
CreateStickerSetRequest$set("public", "from_reader", function(reader) {
  flags <- reader$read_int()
  masks_val <- bitwAnd(flags, 1L) != 0L
  emojis_val <- bitwAnd(flags, 32L) != 0L
  text_color_val <- bitwAnd(flags, 64L) != 0L

  user_obj <- reader$tgread_object()
  title_val <- reader$tgread_string()
  short_name_val <- reader$tgread_string()

  thumb_obj <- if (bitwAnd(flags, 4L) != 0L) reader$tgread_object() else NULL

  # read and ignore vector constructor id, then read count
  reader$read_int()
  count <- reader$read_int()
  stickers_list <- list()
  if (count > 0) {
    for (i in seq_len(count)) {
      stickers_list[[i]] <- reader$tgread_object()
    }
  }

  software_val <- if (bitwAnd(flags, 8L) != 0L) reader$tgread_string() else NULL

  CreateStickerSetRequest$new(
    user_id = user_obj,
    title = title_val,
    short_name = short_name_val,
    stickers = stickers_list,
    masks = masks_val,
    emojis = emojis_val,
    text_color = text_color_val,
    thumb = thumb_obj,
    software = software_val
  )
})


#  DeleteStickerSetRequest R6 class
# 
#  Represents a request to delete a sticker set.
# 
# 
#  @section Methods:
#  - initialize(stickerset): create instance.
#  - to_list(): returns a list representation suitable for JSON/inspection.
#  - to_bytes(): returns a raw vector representing serialized bytes (TL-like).
#  - from_reader(reader): reads a request from a reader object and returns a new instance.
# 
#  @title DeleteStickerSetRequest
#  @description Telegram API type DeleteStickerSetRequest
#  @export
#  @noRd
#  @noRd
DeleteStickerSetRequest <- R6::R6Class(
  "DeleteStickerSetRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x87704394,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field stickerset Field.
    stickerset = NULL,

    #  @description Initialize a DeleteStickerSetRequest
    # 
    #  @param stickerset InputStickerSet (TL object or representation)
    initialize = function(stickerset) {
      if (missing(stickerset)) stop("stickerset is required")
      self$stickerset <- stickerset
      invisible(self)
    },

    #  @description Convert to an R list (dictionary-like)
    # 
    #  @return list representation of the request
    to_list = function() {
      list(
        `_` = "DeleteStickerSetRequest",
        stickerset = if (inherits(self$stickerset, "TLObject")) self$stickerset$to_list() else self$stickerset
      )
    },

    #  @description Serialize to raw bytes (simple TL-like approximation)
    # 
    #  @return raw vector
    to_bytes = function() {
      constructor_bytes <- as.raw(c(
        bitwAnd(self$CONSTRUCTOR_ID, 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 8), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 16), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 24), 0xFF)
      ))

      stickerset_bytes <- if (inherits(self$stickerset, "TLObject") && is.function(self$stickerset$to_bytes)) {
        self$stickerset$to_bytes()
      } else if (is.raw(self$stickerset)) {
        self$stickerset
      } else {
        raw(0)
      }

      c(constructor_bytes, stickerset_bytes)
    }
  )
)

#  Create DeleteStickerSetRequest from a reader
# 
#  The reader object is expected to provide method tgread_object().
# 
#  @param reader Reader object
#  @return DeleteStickerSetRequest instance
#  @export
DeleteStickerSetRequest$set("public", "from_reader", function(reader) {
  stickerset_obj <- reader$tgread_object()
  DeleteStickerSetRequest$new(stickerset = stickerset_obj)
})


#  RemoveStickerFromSetRequest R6 class
# 
#  Represents a request to remove a sticker from a set.
# 
# 
#  @section Methods:
#  - initialize(sticker): create instance.
#  - resolve(client, utils): resolves the sticker to an InputDocument using utils.
#  - to_list(): returns a list representation suitable for JSON/inspection.
#  - to_bytes(): returns a raw vector representing serialized bytes (TL-like).
#  - from_reader(reader): reads a request from a reader object and returns a new instance.
# 
#  @title RemoveStickerFromSetRequest
#  @description Telegram API type RemoveStickerFromSetRequest
#  @export
#  @noRd
#  @noRd
RemoveStickerFromSetRequest <- R6::R6Class(
  "RemoveStickerFromSetRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xf7760f51,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x9b704a5a,
    #  @field sticker Field.
    sticker = NULL,

    #  @description Initialize a RemoveStickerFromSetRequest
    # 
    #  @param sticker InputDocument (TL object or representation)
    initialize = function(sticker) {
      if (missing(sticker)) stop("sticker is required")
      self$sticker <- sticker
      invisible(self)
    },

    #  @description Resolve references (e.g. convert user-friendly inputs to TL inputs)
    # 
    #  @param client client object (used for entity resolution if needed)
    #  @param utils utilities object with helper conversions (must implement get_input_document)
    resolve = function(client, utils) {
      # utils$get_input_document should return an InputDocument TL object
      self$sticker <- utils$get_input_document(self$sticker)
      invisible(self)
    },

    #  @description Convert to an R list (dictionary-like)
    # 
    #  @return list representation of the request
    to_list = function() {
      list(
        `_` = "RemoveStickerFromSetRequest",
        sticker = if (inherits(self$sticker, "TLObject")) self$sticker$to_list() else self$sticker
      )
    },

    #  @description Serialize to raw bytes (simple TL-like approximation)
    # 
    #  @return raw vector
    to_bytes = function() {
      constructor_bytes <- as.raw(c(
        bitwAnd(self$CONSTRUCTOR_ID, 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 8), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 16), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 24), 0xFF)
      ))

      sticker_bytes <- if (inherits(self$sticker, "TLObject") && is.function(self$sticker$to_bytes)) {
        self$sticker$to_bytes()
      } else if (is.raw(self$sticker)) {
        self$sticker
      } else {
        raw(0)
      }

      c(constructor_bytes, sticker_bytes)
    }
  )
)

#  Create RemoveStickerFromSetRequest from a reader
# 
#  The reader object is expected to provide method tgread_object().
# 
#  @param reader Reader object
#  @return RemoveStickerFromSetRequest instance
#  @export
RemoveStickerFromSetRequest$set("public", "from_reader", function(reader) {
  sticker_obj <- reader$tgread_object()
  RemoveStickerFromSetRequest$new(sticker = sticker_obj)
})


#  RenameStickerSetRequest R6 class
# 
#  Represents a request to rename a sticker set.
# 
# 
#  @section Methods:
#  - initialize(stickerset, title): create instance.
#  - to_list(): returns a list representation suitable for JSON/inspection.
#  - to_bytes(): returns a raw vector representing serialized bytes (TL-like).
#  - from_reader(reader): reads a request from a reader object and returns a new instance.
# 
#  @title RenameStickerSetRequest
#  @description Telegram API type RenameStickerSetRequest
#  @export
#  @noRd
#  @noRd
RenameStickerSetRequest <- R6::R6Class(
  "RenameStickerSetRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x124b1c00,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x9b704a5a,
    #  @field stickerset Field.
    stickerset = NULL,
    #  @field title Field.
    title = NULL,

    #  @description Initialize a RenameStickerSetRequest
    # 
    #  @param stickerset InputStickerSet (TL object or representation)
    #  @param title character Title string
    initialize = function(stickerset, title) {
      if (missing(stickerset)) stop("stickerset is required")
      if (missing(title) || !is.character(title) || length(title) != 1) stop("title must be a single string")
      self$stickerset <- stickerset
      self$title <- title
      invisible(self)
    },

    #  @description Convert to an R list (dictionary-like)
    # 
    #  @return list representation of the request
    to_list = function() {
      list(
        `_` = "RenameStickerSetRequest",
        stickerset = if (inherits(self$stickerset, "TLObject")) self$stickerset$to_list() else self$stickerset,
        title = self$title
      )
    },

    #  @description Serialize to raw bytes (simple TL-like approximation)
    # 
    #  @return raw vector
    to_bytes = function() {
      int32_to_raw_le <- function(x) {
        x <- as.integer(x)
        as.raw(c(
          bitwAnd(x, 0xFF),
          bitwAnd(bitwShiftR(x, 8), 0xFF),
          bitwAnd(bitwShiftR(x, 16), 0xFF),
          bitwAnd(bitwShiftR(x, 24), 0xFF)
        ))
      }
      serialize_string <- function(s) {
        sbytes <- charToRaw(enc2utf8(s))
        len_bytes <- int32_to_raw_le(length(sbytes))
        c(len_bytes, sbytes)
      }

      constructor_bytes <- as.raw(c(
        bitwAnd(self$CONSTRUCTOR_ID, 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 8), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 16), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 24), 0xFF)
      ))

      stickerset_bytes <- if (inherits(self$stickerset, "TLObject") && is.function(self$stickerset$to_bytes)) {
        self$stickerset$to_bytes()
      } else if (is.raw(self$stickerset)) {
        self$stickerset
      } else {
        raw(0)
      }

      c(constructor_bytes, stickerset_bytes, serialize_string(self$title))
    }
  )
)

#  Create RenameStickerSetRequest from a reader
# 
#  The reader object is expected to provide methods:
#  - tgread_object() -> returns a TL object
#  - tgread_string() -> returns a string
# 
#  @param reader Reader object
#  @return RenameStickerSetRequest instance
#  @export
RenameStickerSetRequest$set("public", "from_reader", function(reader) {
  stickerset_obj <- reader$tgread_object()
  title_val <- reader$tgread_string()
  RenameStickerSetRequest$new(stickerset = stickerset_obj, title = title_val)
})


#  ReplaceStickerRequest R6 class
# 
#  Represents a request to replace a sticker with a new sticker item.
# 
# 
#  @section Methods:
#  - initialize(sticker, new_sticker): create instance.
#  - resolve(client, utils): resolves references (e.g. ensure sticker is InputDocument).
#  - to_list(): returns a list representation suitable for JSON/inspection.
#  - to_bytes(): returns a raw vector representing serialized bytes (TL-like).
#  - from_reader(reader): reads a request from a reader object and returns a new instance.
# 
#  @title ReplaceStickerRequest
#  @description Telegram API type ReplaceStickerRequest
#  @export
#  @noRd
#  @noRd
ReplaceStickerRequest <- R6::R6Class(
  "ReplaceStickerRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x4696459a,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x9b704a5a,
    #  @field sticker Field.
    sticker = NULL,
    #  @field new_sticker Field.
    new_sticker = NULL,

    #  @description Initialize a ReplaceStickerRequest
    # 
    #  @param sticker InputDocument (TL object or representation)
    #  @param new_sticker InputStickerSetItem (TL object or representation)
    initialize = function(sticker, new_sticker) {
      if (missing(sticker)) stop("sticker is required")
      if (missing(new_sticker)) stop("new_sticker is required")
      self$sticker <- sticker
      self$new_sticker <- new_sticker
      invisible(self)
    },

    #  @description Resolve references (e.g. convert user-friendly inputs to TL inputs)
    # 
    #  @param client client object (used for entity resolution if needed)
    #  @param utils utilities object with helper conversions (must implement get_input_document)
    resolve = function(client, utils) {
      # utils$get_input_document should return an InputDocument TL object
      self$sticker <- utils$get_input_document(self$sticker)
      invisible(self)
    },

    #  @description Convert to an R list (dictionary-like)
    # 
    #  @return list representation of the request
    to_list = function() {
      list(
        `_` = "ReplaceStickerRequest",
        sticker = if (inherits(self$sticker, "TLObject")) self$sticker$to_list() else self$sticker,
        new_sticker = if (inherits(self$new_sticker, "TLObject")) self$new_sticker$to_list() else self$new_sticker
      )
    },

    #  @description Serialize to raw bytes (simple TL-like approximation)
    # 
    #  @return raw vector
    to_bytes = function() {
      constructor_bytes <- as.raw(c(
        bitwAnd(self$CONSTRUCTOR_ID, 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 8), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 16), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 24), 0xFF)
      ))

      sticker_bytes <- if (inherits(self$sticker, "TLObject") && is.function(self$sticker$to_bytes)) {
        self$sticker$to_bytes()
      } else if (is.raw(self$sticker)) {
        self$sticker
      } else {
        raw(0)
      }

      new_sticker_bytes <- if (inherits(self$new_sticker, "TLObject") && is.function(self$new_sticker$to_bytes)) {
        self$new_sticker$to_bytes()
      } else if (is.raw(self$new_sticker)) {
        self$new_sticker
      } else {
        raw(0)
      }

      c(constructor_bytes, sticker_bytes, new_sticker_bytes)
    }
  )
)

#  Create ReplaceStickerRequest from a reader
# 
#  The reader object is expected to provide method tgread_object().
# 
#  @param reader Reader object
#  @return ReplaceStickerRequest instance
#  @export
ReplaceStickerRequest$set("public", "from_reader", function(reader) {
  sticker_obj <- reader$tgread_object()
  new_sticker_obj <- reader$tgread_object()
  ReplaceStickerRequest$new(sticker = sticker_obj, new_sticker = new_sticker_obj)
})


#  SetStickerSetThumbRequest R6 class
# 
#  Represents a request to set a thumbnail for a sticker set.
# 
# 
#  @section Methods:
#  - initialize(stickerset, thumb = NULL, thumb_document_id = NULL): create instance.
#  - resolve(client, utils): resolves references (e.g. ensure thumb is InputDocument).
#  - to_list(): returns a list representation suitable for JSON/inspection.
#  - to_bytes(): returns a raw vector representing serialized bytes (TL-like).
#  - from_reader(reader): reads a request from a reader object and returns a new instance.
# 
#  @title SetStickerSetThumbRequest
#  @description Telegram API type SetStickerSetThumbRequest
#  @export
#  @noRd
#  @noRd
SetStickerSetThumbRequest <- R6::R6Class(
  "SetStickerSetThumbRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xa76a5392,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x9b704a5a,
    #  @field stickerset Field.
    stickerset = NULL,
    #  @field thumb Field.
    thumb = NULL,
    #  @field thumb_document_id Field.
    thumb_document_id = NULL,

    #  @description Initialize a SetStickerSetThumbRequest
    # 
    #  @param stickerset InputStickerSet (TL object or representation)
    #  @param thumb Optional InputDocument (TL object or representation)
    #  @param thumb_document_id Optional integer identifier for thumb document
    initialize = function(stickerset, thumb = NULL, thumb_document_id = NULL) {
      if (missing(stickerset)) stop("stickerset is required")
      self$stickerset <- stickerset
      self$thumb <- thumb
      self$thumb_document_id <- thumb_document_id
      invisible(self)
    },

    #  @description Resolve references (e.g. convert user-friendly inputs to TL inputs)
    # 
    #  @param client client object (used for entity resolution if needed)
    #  @param utils utilities object with helper conversions (must implement get_input_document)
    resolve = function(client, utils) {
      if (!is.null(self$thumb)) {
        # utils$get_input_document should return an InputDocument TL object
        self$thumb <- utils$get_input_document(self$thumb)
      }
      invisible(self)
    },

    #  @description Convert to an R list (dictionary-like)
    # 
    #  @return list representation of the request
    to_list = function() {
      list(
        `_` = "SetStickerSetThumbRequest",
        stickerset = if (inherits(self$stickerset, "TLObject")) self$stickerset$to_list() else self$stickerset,
        thumb = if (inherits(self$thumb, "TLObject")) self$thumb$to_list() else self$thumb,
        thumb_document_id = self$thumb_document_id
      )
    },

    #  @description Serialize to raw bytes (simple TL-like approximation)
    # 
    #  @return raw vector
    to_bytes = function() {
      # helper: little-endian 32-bit int
      int32_to_raw_le <- function(x) {
        x <- as.integer(x)
        as.raw(c(
          bitwAnd(x, 0xFF),
          bitwAnd(bitwShiftR(x, 8), 0xFF),
          bitwAnd(bitwShiftR(x, 16), 0xFF),
          bitwAnd(bitwShiftR(x, 24), 0xFF)
        ))
      }
      # helper: little-endian 64-bit integer
      int64_to_raw_le <- function(x) {
        # convert numeric/integer64 to integer vector of 8 bytes
        # careful: numeric may lose precision for >53-bit; assume safe here
        x <- as.numeric(x)
        bytes <- raw(8)
        v <- x
        for (i in 1:8) {
          bytes[i] <- as.raw(as.integer(v %% 256))
          v <- floor(v / 256)
        }
        bytes
      }

      flag_thumb <- if (!is.null(self$thumb)) 1L else 0L
      flag_thumb_doc_id <- if (!is.null(self$thumb_document_id)) 2L else 0L
      flags <- flag_thumb + flag_thumb_doc_id

      constructor_bytes <- as.raw(c(
        bitwAnd(self$CONSTRUCTOR_ID, 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 8), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 16), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 24), 0xFF)
      ))

      flags_bytes <- int32_to_raw_le(flags)

      # For stickerset and thumb, assume they implement a $to_bytes() returning raw
      stickerset_bytes <- if (inherits(self$stickerset, "TLObject") && is.function(self$stickerset$to_bytes)) {
        self$stickerset$to_bytes()
      } else if (is.raw(self$stickerset)) {
        self$stickerset
      } else {
        raw(0)
      }

      thumb_bytes <- if (!is.null(self$thumb) && inherits(self$thumb, "TLObject") && is.function(self$thumb$to_bytes)) {
        self$thumb$to_bytes()
      } else {
        raw(0)
      }

      thumb_doc_id_bytes <- if (!is.null(self$thumb_document_id)) int64_to_raw_le(self$thumb_document_id) else raw(0)

      c(constructor_bytes, flags_bytes, stickerset_bytes, thumb_bytes, thumb_doc_id_bytes)
    }
  )
)

#  Create SetStickerSetThumbRequest from a reader
# 
#  The reader object is expected to provide methods:
#  - read_int() -> integer (32-bit)
#  - tgread_object() -> returns a TL object
#  - read_long() -> numeric/integer64 (64-bit)
# 
#  @param reader Reader object
#  @return SetStickerSetThumbRequest instance
#  @export
SetStickerSetThumbRequest$set("public", "from_reader", function(reader) {
  flags <- reader$read_int()
  stickerset_obj <- reader$tgread_object()
  thumb_obj <- if (bitwAnd(flags, 1L) != 0L) reader$tgread_object() else NULL
  thumb_document_id_val <- if (bitwAnd(flags, 2L) != 0L) reader$read_long() else NULL
  SetStickerSetThumbRequest$new(stickerset = stickerset_obj, thumb = thumb_obj, thumb_document_id = thumb_document_id_val)
})


#  SuggestShortNameRequest R6 class
# 
#  Represents a request to suggest a short name for a sticker set.
# 
# 
#  @section Methods:
#  - initialize(title): create instance.
#  - to_list(): returns a list representation suitable for JSON/inspection.
#  - to_bytes(): returns a raw vector representing serialized bytes (TL-like).
#  - from_reader(reader): reads a request from a reader object and returns a new instance.
# 
#  @title SuggestShortNameRequest
#  @description Telegram API type SuggestShortNameRequest
#  @export
#  @noRd
#  @noRd
SuggestShortNameRequest <- R6::R6Class(
  "SuggestShortNameRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x4dafc503,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xc44a4b21,
    #  @field title Field.
    title = NULL,

    #  @description Initialize a SuggestShortNameRequest
    # 
    #  @param title character Title string
    initialize = function(title) {
      if (missing(title) || !is.character(title) || length(title) != 1) stop("title must be a single string")
      self$title <- title
      invisible(self)
    },

    #  @description Convert to an R list (dictionary-like)
    # 
    #  @return list representation
    to_list = function() {
      list(
        `_` = "SuggestShortNameRequest",
        title = self$title
      )
    },

    #  @description Serialize to raw bytes (simple TL-like approximation)
    # 
    #  @return raw vector
    to_bytes = function() {
      # constructor bytes
      constructor_bytes <- as.raw(c(
        bitwAnd(self$CONSTRUCTOR_ID, 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 8), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 16), 0xFF),
        bitwAnd(bitwShiftR(self$CONSTRUCTOR_ID, 24), 0xFF)
      ))
      # Very simple string encoding: length (32-bit le) + utf8 bytes
      str_bytes <- charToRaw(enc2utf8(self$title))
      len_bytes <- as.raw(c(
        bitwAnd(length(str_bytes), 0xFF),
        bitwAnd(bitwShiftR(length(str_bytes), 8), 0xFF),
        bitwAnd(bitwShiftR(length(str_bytes), 16), 0xFF),
        bitwAnd(bitwShiftR(length(str_bytes), 24), 0xFF)
      ))
      c(constructor_bytes, len_bytes, str_bytes)
    }
  )
)

#  Create SuggestShortNameRequest from a reader
# 
#  Reader must implement tgread_string() returning a single string.
# 
#  @param reader Reader object
#  @return SuggestShortNameRequest instance
#  @export
SuggestShortNameRequest$set("public", "from_reader", function(reader) {
  title_val <- reader$tgread_string()
  SuggestShortNameRequest$new(title = title_val)
})
