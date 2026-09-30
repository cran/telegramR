#' @title AcceptLoginTokenRequest
#' @description Telegram API request \code{auth.acceptLoginToken} (constructor \code{#e894ad4d}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
AcceptLoginTokenRequest <- R6::R6Class(
  "AcceptLoginTokenRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xe894ad4d,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xc913c01a,
    #  @field token Field.
    token = NULL,

    #  @description Initialize an AcceptLoginTokenRequest
    #  @param token raw vector or string
    initialize = function(token) {
      self$token <- token
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "AcceptLoginTokenRequest",
        token = self$token
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      # constructor id (little-endian): 0xe894ad4d -> 0x4D 0xAD 0x94 0xE8
      constructor_bytes <- as.raw(c(0x4D, 0xAD, 0x94, 0xE8))
      token_raw <- serialize_bytes(self$token)
      c(constructor_bytes, token_raw)
    },

    #  @description Read from reader and create AcceptLoginTokenRequest
    #  @param reader Reader object implementing tgread_bytes()
    #  @return AcceptLoginTokenRequest instance
    from_reader = function(reader) {
      token_val <- reader$tgread_bytes()
      AcceptLoginTokenRequest$new(token = token_val)
    }
  )
)


#' @title BindTempAuthKeyRequest
#' @description Telegram API request \code{auth.bindTempAuthKey} (constructor \code{#cdd42a05}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
BindTempAuthKeyRequest <- R6::R6Class(
  "BindTempAuthKeyRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xcdd42a05,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field perm_auth_key_id Field.
    perm_auth_key_id = NULL,
    #  @field nonce Field.
    nonce = NULL,
    #  @field expires_at Field.
    expires_at = NULL,
    #  @field encrypted_message Field.
    encrypted_message = NULL,

    #  @description Initialize a BindTempAuthKeyRequest
    #  @param perm_auth_key_id numeric or integer (64-bit)
    #  @param nonce numeric or integer (64-bit)
    #  @param expires_at POSIXct|Date or NULL
    #  @param encrypted_message raw vector or string
    initialize = function(perm_auth_key_id, nonce, expires_at = NULL, encrypted_message) {
      self$perm_auth_key_id <- perm_auth_key_id
      self$nonce <- nonce
      self$expires_at <- expires_at
      self$encrypted_message <- encrypted_message
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "BindTempAuthKeyRequest",
        perm_auth_key_id = self$perm_auth_key_id,
        nonce = self$nonce,
        expires_at = self$expires_at,
        encrypted_message = self$encrypted_message
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      pack_int64_le <- function(x) {
        # int64 must be packed as a true 64-bit integer, not an IEEE double
        packInt64(x)
      }

      # constructor id (little-endian): 0xcdd42a05 -> 0x05 0x2A 0xD4 0xCD
      constructor_bytes <- as.raw(c(0x05, 0x2A, 0xD4, 0xCD))
      perm_raw <- pack_int64_le(self$perm_auth_key_id)
      nonce_raw <- pack_int64_le(self$nonce)
      expires_raw <- serialize_datetime(self$expires_at)
      enc_msg_raw <- serialize_bytes(self$encrypted_message)

      c(constructor_bytes, perm_raw, nonce_raw, expires_raw, enc_msg_raw)
    },

    #  @description Read from reader and create BindTempAuthKeyRequest
    #  @param reader Reader object implementing read_long(), tgread_date(), tgread_bytes()
    #  @return BindTempAuthKeyRequest instance
    from_reader = function(reader) {
      perm_auth_key_id_val <- reader$read_long()
      nonce_val <- reader$read_long()
      expires_at_val <- reader$tgread_date()
      encrypted_message_val <- reader$tgread_bytes()

      BindTempAuthKeyRequest$new(
        perm_auth_key_id = perm_auth_key_id_val,
        nonce = nonce_val,
        expires_at = expires_at_val,
        encrypted_message = encrypted_message_val
      )
    }
  )
)


#' @title CancelCodeRequest
#' @description Telegram API request \code{auth.cancelCode} (constructor \code{#1f040578}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
CancelCodeRequest <- R6::R6Class(
  "CancelCodeRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x1f040578,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field phone_number Field.
    phone_number = NULL,
    #  @field phone_code_hash Field.
    phone_code_hash = NULL,

    #  @description Initialize a CancelCodeRequest
    #  @param phone_number character
    #  @param phone_code_hash character
    initialize = function(phone_number, phone_code_hash) {
      self$phone_number <- phone_number
      self$phone_code_hash <- phone_code_hash
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "CancelCodeRequest",
        phone_number = self$phone_number,
        phone_code_hash = self$phone_code_hash
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      # constructor id bytes (little-endian): 0x1f040578 -> 0x78 0x05 0x04 0x1f
      constructor_bytes <- as.raw(c(0x78, 0x05, 0x04, 0x1f))
      phone_raw <- serialize_bytes(self$phone_number)
      hash_raw <- serialize_bytes(self$phone_code_hash)
      c(constructor_bytes, phone_raw, hash_raw)
    },

    #  @description Read from reader and create CancelCodeRequest
    #  @param reader Reader object implementing tgread_string()
    #  @return CancelCodeRequest instance
    from_reader = function(reader) {
      phone_number_val <- reader$tgread_string()
      phone_code_hash_val <- reader$tgread_string()
      CancelCodeRequest$new(
        phone_number = phone_number_val,
        phone_code_hash = phone_code_hash_val
      )
    }
  )
)


#' @title CheckPasswordRequest
#' @description Telegram API request \code{auth.checkPassword} (constructor \code{#d18b4d16}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
CheckPasswordRequest <- R6::R6Class(
  "CheckPasswordRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xd18b4d16,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xb9e04e39,
    #  @field password Field.
    password = NULL,

    #  @description Initialize a CheckPasswordRequest
    #  @param password TL object (TypeInputCheckPasswordSRP)
    initialize = function(password) {
      self$password <- password
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "CheckPasswordRequest",
        password = if (inherits(self$password, "R6") && !is.null(self$password$to_list)) self$password$to_list() else self$password
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      # constructor id bytes (little-endian): 0xd18b4d16 -> 0x16 0x4D 0x8B 0xD1
      constructor_bytes <- as.raw(c(0x16, 0x4D, 0x8B, 0xD1))

      if (is.null(self$password)) {
        stop("password must be provided and be a TL object")
      }

      password_bytes <- raw()
      if (inherits(self$password, "R6") && !is.null(self$password$`_bytes`)) {
        password_bytes <- self$password$`_bytes`()
      } else if (inherits(self$password, "R6") && !is.null(self$password$to_bytes)) {
        password_bytes <- self$password$to_bytes()
      } else {
        stop("password object does not provide _bytes() or to_bytes()")
      }

      c(constructor_bytes, password_bytes)
    },

    #  @description Read from reader and create CheckPasswordRequest
    #  @param reader Reader object implementing tgread_object()
    #  @return CheckPasswordRequest instance
    from_reader = function(reader) {
      password_val <- reader$tgread_object()
      CheckPasswordRequest$new(password = password_val)
    }
  )
)


#' @title CheckRecoveryPasswordRequest
#' @description Telegram API request \code{auth.checkRecoveryPassword} (constructor \code{#0d36bf79}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
CheckRecoveryPasswordRequest <- R6::R6Class(
  "CheckRecoveryPasswordRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x0d36bf79,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field code Field.
    code = NULL,

    #  @description Initialize a CheckRecoveryPasswordRequest
    #  @param code character
    initialize = function(code) {
      self$code <- code
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "CheckRecoveryPasswordRequest",
        code = self$code
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      # constructor id bytes (little-endian): 0x0d36bf79 -> 0x79 0xBF 0x36 0x0D
      constructor_bytes <- as.raw(c(0x79, 0xBF, 0x36, 0x0D))
      code_raw <- serialize_bytes(self$code)
      c(constructor_bytes, code_raw)
    },

    #  @description Read from reader and create CheckRecoveryPasswordRequest
    #  @param reader Reader object implementing tgread_string()
    #  @return CheckRecoveryPasswordRequest instance
    from_reader = function(reader) {
      code_val <- reader$tgread_string()
      CheckRecoveryPasswordRequest$new(code = code_val)
    }
  )
)


#' @title DropTempAuthKeysRequest
#' @description Telegram API request \code{auth.dropTempAuthKeys} (constructor \code{#8e48a188}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
DropTempAuthKeysRequest <- R6::R6Class(
  "DropTempAuthKeysRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x8e48a188,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field except_auth_keys Field.
    except_auth_keys = NULL,

    #  @description Initialize a DropTempAuthKeysRequest
    #  @param except_auth_keys numeric vector (64-bit) or NULL
    initialize = function(except_auth_keys = NULL) {
      if (is.null(except_auth_keys)) {
        self$except_auth_keys <- numeric(0)
      } else {
        self$except_auth_keys <- as.numeric(except_auth_keys)
      }
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "DropTempAuthKeysRequest",
        except_auth_keys = if (length(self$except_auth_keys) == 0) list() else as.list(self$except_auth_keys)
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      pack_int32_le <- function(x) {
        con <- rawConnection(raw(), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      pack_int64_le <- function(x) {
        # int64 must be packed as a true 64-bit integer, not an IEEE double
        packInt64(x)
      }

      # constructor id bytes: b'\x88\xa1H\x8e'
      constructor_bytes <- as.raw(c(0x88, 0xA1, 0x48, 0x8E))

      # vector constructor for TL vectors: b'\x15\xc4\xb5\x1c'
      vector_constructor <- as.raw(c(0x15, 0xC4, 0xB5, 0x1C))
      count_raw <- pack_int32_le(length(self$except_auth_keys))
      ids_raw <- raw()
      if (length(self$except_auth_keys) > 0) {
        ids_raw <- do.call(c, lapply(self$except_auth_keys, pack_int64_le))
      }

      c(constructor_bytes, vector_constructor, count_raw, ids_raw)
    },

    #  @description Read from reader and create DropTempAuthKeysRequest
    #  @param reader Reader object implementing read_int(), read_long()
    #  @return DropTempAuthKeysRequest instance
    from_reader = function(reader) {
      # read and ignore vector constructor id
      reader$read_int()
      count_val <- reader$read_int()
      ids_list <- numeric(0)
      if (count_val > 0) {
        ids_vec <- vector("numeric", count_val)
        for (i in seq_len(count_val)) {
          ids_vec[i] <- reader$read_long()
        }
        ids_list <- ids_vec
      }
      DropTempAuthKeysRequest$new(except_auth_keys = ids_list)
    }
  )
)


#' @title ExportAuthorizationRequest
#' @description Telegram API request \code{auth.exportAuthorization} (constructor \code{#e5bfffcd}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ExportAuthorizationRequest <- R6::R6Class(
  "ExportAuthorizationRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xe5bfffcd,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x5fd1ec51,
    #  @field dc_id Field.
    dc_id = NULL,

    #  @description Initialize an ExportAuthorizationRequest
    #  @param dc_id integer
    initialize = function(dc_id) {
      self$dc_id <- as.integer(dc_id)
      invisible(self)
    },

    #  Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "ExportAuthorizationRequest",
        dc_id = self$dc_id
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      pack_int32_le <- function(x) {
        con <- rawConnection(raw(), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }

      # constructor id bytes as in Python b'\xcd\xff\xbf\xe5'
      constructor_bytes <- as.raw(c(0xCD, 0xFF, 0xBF, 0xE5))
      dc_raw <- pack_int32_le(self$dc_id)

      c(constructor_bytes, dc_raw)
    },

    #  @description Read from reader and create ExportAuthorizationRequest
    #  @param reader Reader object implementing read_int()
    #  @return ExportAuthorizationRequest instance
    from_reader = function(reader) {
      dc_val <- reader$read_int()
      ExportAuthorizationRequest$new(dc_id = dc_val)
    }
  )
)


#' @title ExportLoginTokenRequest
#' @description Telegram API request \code{auth.exportLoginToken} (constructor \code{#b7e085fe}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ExportLoginTokenRequest <- R6::R6Class(
  "ExportLoginTokenRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xb7e085fe,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x6b55f636,
    #  @field api_id Field.
    api_id = NULL,
    #  @field api_hash Field.
    api_hash = NULL,
    #  @field except_ids Field.
    except_ids = NULL,

    #  @description Initialize an ExportLoginTokenRequest
    #  @param api_id integer
    #  @param api_hash character
    #  @param except_ids numeric vector (64-bit) or NULL
    initialize = function(api_id, api_hash, except_ids = NULL) {
      self$api_id <- as.integer(api_id)
      self$api_hash <- api_hash
      if (is.null(except_ids)) {
        self$except_ids <- integer(0)
      } else {
        self$except_ids <- as.numeric(except_ids)
      }
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "ExportLoginTokenRequest",
        api_id = self$api_id,
        api_hash = self$api_hash,
        except_ids = if (length(self$except_ids) == 0) list() else as.list(self$except_ids)
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      pack_int32_le <- function(x) {
        con <- rawConnection(raw(), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      pack_int64_le <- function(x) {
        # int64 must be packed as a true 64-bit integer, not an IEEE double
        packInt64(x)
      }

      constructor_bytes <- as.raw(c(0xFE, 0x85, 0xE0, 0xB7))
      api_id_raw <- pack_int32_le(self$api_id)
      api_hash_raw <- serialize_bytes(self$api_hash)

      # serialize vector of 64-bit except_ids
      vector_constructor <- as.raw(c(0x15, 0xC4, 0xB5, 0x1C))
      count_raw <- pack_int32_le(length(self$except_ids))
      ids_raw <- raw()
      if (length(self$except_ids) > 0) {
        ids_raw <- do.call(c, lapply(self$except_ids, pack_int64_le))
      }

      c(constructor_bytes, api_id_raw, api_hash_raw, vector_constructor, count_raw, ids_raw)
    },

    #  @description Read from reader and create ExportLoginTokenRequest
    #  @param reader Reader object implementing read_int(), tgread_string(), read_long()
    #  @return ExportLoginTokenRequest instance
    from_reader = function(reader) {
      api_id_val <- reader$read_int()
      api_hash_val <- reader$tgread_string()

      # read and ignore vector constructor id (int), then read count and longs
      .vector_constructor <- reader$read_int()
      count_val <- reader$read_int()
      ids_val <- numeric(0)
      if (count_val > 0) {
        ids_list <- vector("numeric", count_val)
        for (i in seq_len(count_val)) {
          ids_list[i] <- reader$read_long()
        }
        ids_val <- ids_list
      }

      ExportLoginTokenRequest$new(
        api_id = api_id_val,
        api_hash = api_hash_val,
        except_ids = ids_val
      )
    }
  )
)

#' @title ImportAuthorizationRequest
#' @description Telegram API request \code{auth.importAuthorization} (constructor \code{#a57a7dad}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ImportAuthorizationRequest <- R6::R6Class(
  "ImportAuthorizationRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xa57a7dad,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xb9e04e39,
    #  @field id Field.
    id = NULL,
    #  @field bytes Field.
    bytes = NULL,

    #  @description Initialize an ImportAuthorizationRequest
    #  @param id numeric or integer (64-bit)
    #  @param bytes raw vector or string
    initialize = function(id, bytes) {
      self$id <- id
      self$bytes <- bytes
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "ImportAuthorizationRequest",
        id = self$id,
        bytes = self$bytes
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      pack_int64_le <- function(x) {
        # int64 must be packed as a true 64-bit integer, not an IEEE double
        packInt64(x)
      }

      # constructor id bytes as in Python b'\xad}z\xa5'
      constructor_bytes <- as.raw(c(0xAD, 0x7D, 0x7A, 0xA5))
      id_raw <- pack_int64_le(self$id)
      bytes_raw <- serialize_bytes(self$bytes)

      c(constructor_bytes, id_raw, bytes_raw)
    },

    #  @description Read from reader and create ImportAuthorizationRequest
    #  @param reader Reader object implementing read_long(), tgread_bytes()
    #  @return ImportAuthorizationRequest instance
    from_reader = function(reader) {
      id_val <- reader$read_long()
      bytes_val <- reader$tgread_bytes()

      ImportAuthorizationRequest$new(
        id = id_val,
        bytes = bytes_val
      )
    }
  )
)


#' @title ImportBotAuthorizationRequest
#' @description Telegram API request \code{auth.importBotAuthorization} (constructor \code{#67a3ff2c}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ImportBotAuthorizationRequest <- R6::R6Class(
  "ImportBotAuthorizationRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x67a3ff2c,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xb9e04e39,
    #  @field flags Field.
    flags = NULL,
    #  @field api_id Field.
    api_id = NULL,
    #  @field api_hash Field.
    api_hash = NULL,
    #  @field bot_auth_token Field.
    bot_auth_token = NULL,

    #  @description Initialize an ImportBotAuthorizationRequest
    #  @param flags integer
    #  @param api_id integer
    #  @param api_hash character
    #  @param bot_auth_token character
    initialize = function(flags, api_id, api_hash, bot_auth_token) {
      self$flags <- flags
      self$api_id <- api_id
      self$api_hash <- api_hash
      self$bot_auth_token <- bot_auth_token
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "ImportBotAuthorizationRequest",
        flags = self$flags,
        api_id = self$api_id,
        api_hash = self$api_hash,
        bot_auth_token = self$bot_auth_token
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      pack_int32_le <- function(x) {
        con <- rawConnection(raw(), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }

      # constructor id bytes (Python b',\xff\xa3g' -> 0x2C 0xFF 0xA3 0x67)
      constructor_bytes <- as.raw(c(0x2C, 0xFF, 0xA3, 0x67))
      flags_raw <- pack_int32_le(self$flags)
      api_id_raw <- pack_int32_le(self$api_id)
      api_hash_raw <- serialize_bytes(self$api_hash)
      bot_token_raw <- serialize_bytes(self$bot_auth_token)

      c(constructor_bytes, flags_raw, api_id_raw, api_hash_raw, bot_token_raw)
    },

    #  @description Read from reader and create ImportBotAuthorizationRequest
    #  @param reader Reader object implementing read_int(), tgread_string()
    #  @return ImportBotAuthorizationRequest instance
    from_reader = function(reader) {
      flags_val <- reader$read_int()
      api_id_val <- reader$read_int()
      api_hash_val <- reader$tgread_string()
      bot_token_val <- reader$tgread_string()

      ImportBotAuthorizationRequest$new(
        flags = flags_val,
        api_id = api_id_val,
        api_hash = api_hash_val,
        bot_auth_token = bot_token_val
      )
    }
  )
)


#' @title ImportLoginTokenRequest
#' @description Telegram API request \code{auth.importLoginToken} (constructor \code{#95ac5ce4}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ImportLoginTokenRequest <- R6::R6Class(
  "ImportLoginTokenRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x95ac5ce4,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x6b55f636,
    #  @field token Field.
    token = NULL,

    #  @description Initialize an ImportLoginTokenRequest
    #  @param token raw vector or string
    initialize = function(token) {
      self$token <- token
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "ImportLoginTokenRequest",
        token = self$token
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      # constructor id (little-endian): 0x95ac5ce4 -> 0xE4 0x5C 0xAC 0x95
      constructor_bytes <- as.raw(c(0xE4, 0x5C, 0xAC, 0x95))
      token_raw <- serialize_bytes(self$token)
      c(constructor_bytes, token_raw)
    },

    #  @description Read from reader and create ImportLoginTokenRequest
    #  @param reader Reader object implementing read_int(), tgread_string(), tgread_bytes(), tgread_object()
    #  @return ImportLoginTokenRequest instance
    from_reader = function(reader) {
      token_val <- reader$tgread_bytes()
      ImportLoginTokenRequest$new(token = token_val)
    }
  )
)


#' @title ImportWebTokenAuthorizationRequest
#' @description Telegram API request \code{auth.importWebTokenAuthorization} (constructor \code{#2db873a9}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ImportWebTokenAuthorizationRequest <- R6::R6Class(
  "ImportWebTokenAuthorizationRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x2db873a9,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xb9e04e39,
    #  @field api_id Field.
    api_id = NULL,
    #  @field api_hash Field.
    api_hash = NULL,
    #  @field web_auth_token Field.
    web_auth_token = NULL,

    #  @description Initialize an ImportWebTokenAuthorizationRequest
    #  @param api_id integer
    #  @param api_hash character
    #  @param web_auth_token character
    initialize = function(api_id, api_hash, web_auth_token) {
      self$api_id <- api_id
      self$api_hash <- api_hash
      self$web_auth_token <- web_auth_token
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "ImportWebTokenAuthorizationRequest",
        api_id = self$api_id,
        api_hash = self$api_hash,
        web_auth_token = self$web_auth_token
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      pack_uint32_le <- function(x) {
        con <- rawConnection(raw(), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }

      # constructor id (little-endian): 0x2db873a9 -> 0xA9 0x73 0xB8 0x2D
      constructor_bytes <- as.raw(c(0xA9, 0x73, 0xB8, 0x2D))
      api_id_raw <- pack_uint32_le(self$api_id)
      api_hash_raw <- serialize_bytes(self$api_hash)
      web_auth_raw <- serialize_bytes(self$web_auth_token)

      c(constructor_bytes, api_id_raw, api_hash_raw, web_auth_raw)
    },

    #  @description Read from reader and create ImportWebTokenAuthorizationRequest
    #  @param reader Reader object implementing read_int(), tgread_string(), tgread_bytes(), tgread_object()
    #  @return ImportWebTokenAuthorizationRequest instance
    from_reader = function(reader) {
      api_id_val <- reader$read_int()
      api_hash_val <- reader$tgread_string()
      web_auth_val <- reader$tgread_string()

      ImportWebTokenAuthorizationRequest$new(
        api_id = api_id_val,
        api_hash = api_hash_val,
        web_auth_token = web_auth_val
      )
    }
  )
)

#' @title LogOutRequest
#' @description Telegram API request \code{auth.logOut} (constructor \code{#3e72ba19}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
LogOutRequest <- R6::R6Class(
  "LogOutRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x3e72ba19,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x0a804315,

    #  @description Initialize a LogOutRequest
    #  @return invisible self
    initialize = function() {
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "LogOutRequest"
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      # constructor id in little-endian byte order: 0x3e72ba19 -> 0x19 0xba 0x72 0x3e
      as.raw(c(0x19, 0xBA, 0x72, 0x3E))
    },

    #  @description Read from reader and create LogOutRequest
    #  @param reader Reader object implementing read_int(), tgread_string(), tgread_object()
    #  @return LogOutRequest instance
    from_reader = function(reader) {
      # no fields to read
      LogOutRequest$new()
    }
  )
)


#' @title RecoverPasswordRequest
#' @description Telegram API request \code{auth.recoverPassword} (constructor \code{#37096c70}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
RecoverPasswordRequest <- R6::R6Class(
  "RecoverPasswordRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x37096c70,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xb9e04e39,
    #  @field code Field.
    code = NULL,
    #  @field new_settings Field.
    new_settings = NULL,

    #  @description Initialize a RecoverPasswordRequest
    #  @param code character
    #  @param new_settings TL object or NULL
    initialize = function(code, new_settings = NULL) {
      self$code <- code
      self$new_settings <- new_settings
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "RecoverPasswordRequest",
        code = self$code,
        new_settings = if (is.null(self$new_settings)) NULL else (if (inherits(self$new_settings, "R6") && !is.null(self$new_settings$to_list)) self$new_settings$to_list() else self$new_settings)
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      pack_uint32_le <- function(x) {
        con <- rawConnection(raw(), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }

      flags <- if (is.null(self$new_settings) || identical(self$new_settings, FALSE)) 0L else 1L

      # constructor id bytes (little-endian): 0x37096c70 -> 0x70 0x6c 0x09 0x37
      constructor_bytes <- as.raw(c(0x70, 0x6c, 0x09, 0x37))
      flags_raw <- pack_uint32_le(flags)
      code_raw <- serialize_bytes(self$code)

      new_settings_raw <- raw()
      if (bitwAnd(flags, 1L) != 0L) {
        if (inherits(self$new_settings, "R6") && !is.null(self$new_settings$`_bytes`)) {
          new_settings_raw <- self$new_settings$`_bytes`()
        } else if (inherits(self$new_settings, "R6") && !is.null(self$new_settings$to_bytes)) {
          new_settings_raw <- self$new_settings$to_bytes()
        } else {
          stop("new_settings object does not provide _bytes() or to_bytes()")
        }
      }

      c(constructor_bytes, flags_raw, code_raw, new_settings_raw)
    },

    #  @description Read from reader and create RecoverPasswordRequest
    #  @param reader Reader object implementing read_int(), tgread_string(), tgread_object()
    #  @return RecoverPasswordRequest instance
    from_reader = function(reader) {
      flags_val <- reader$read_int()
      code_val <- reader$tgread_string()

      if (bitwAnd(flags_val, 1L) != 0L) {
        new_settings_val <- reader$tgread_object()
      } else {
        new_settings_val <- NULL
      }

      RecoverPasswordRequest$new(
        code = code_val,
        new_settings = new_settings_val
      )
    }
  )
)


#' @title ReportMissingCodeRequest
#' @description Telegram API request \code{auth.reportMissingCode} (constructor \code{#cb9deff6}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ReportMissingCodeRequest <- R6::R6Class(
  "ReportMissingCodeRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xcb9deff6,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field phone_number Field.
    phone_number = NULL,
    #  @field phone_code_hash Field.
    phone_code_hash = NULL,
    #  @field mnc Field.
    mnc = NULL,

    #  @description Initialize a ReportMissingCodeRequest
    #  @param phone_number character
    #  @param phone_code_hash character
    #  @param mnc character
    initialize = function(phone_number, phone_code_hash, mnc) {
      self$phone_number <- phone_number
      self$phone_code_hash <- phone_code_hash
      self$mnc <- mnc
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "ReportMissingCodeRequest",
        phone_number = self$phone_number,
        phone_code_hash = self$phone_code_hash,
        mnc = self$mnc
      )
    },

    #  Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      # constructor id bytes (same order as Python b'\xf6\xef\x9d\xcb')
      constructor_bytes <- as.raw(c(0xF6, 0xEF, 0x9D, 0xCB))
      phone_raw <- serialize_bytes(self$phone_number)
      hash_raw <- serialize_bytes(self$phone_code_hash)
      mnc_raw <- serialize_bytes(self$mnc)

      c(constructor_bytes, phone_raw, hash_raw, mnc_raw)
    },

    #  @description Read from reader and create ReportMissingCodeRequest
    #  @param reader Reader object implementing read_int(), tgread_string(), tgread_object()
    #  @return ReportMissingCodeRequest instance
    from_reader = function(reader) {
      phone_number_val <- reader$tgread_string()
      phone_code_hash_val <- reader$tgread_string()
      mnc_val <- reader$tgread_string()

      ReportMissingCodeRequest$new(
        phone_number = phone_number_val,
        phone_code_hash = phone_code_hash_val,
        mnc = mnc_val
      )
    }
  )
)


#' @title RequestFirebaseSmsRequest
#' @description Telegram API request \code{auth.requestFirebaseSms} (constructor \code{#8e39261e}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
RequestFirebaseSmsRequest <- R6::R6Class(
  "RequestFirebaseSmsRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x8e39261e,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field phone_number Field.
    phone_number = NULL,
    #  @field phone_code_hash Field.
    phone_code_hash = NULL,
    #  @field safety_net_token Field.
    safety_net_token = NULL,
    #  @field play_integrity_token Field.
    play_integrity_token = NULL,
    #  @field ios_push_secret Field.
    ios_push_secret = NULL,

    #  @description Initialize a RequestFirebaseSmsRequest
    #  @param phone_number character
    #  @param phone_code_hash character
    #  @param safety_net_token character or NULL
    #  @param play_integrity_token character or NULL
    #  @param ios_push_secret character or NULL
    initialize = function(phone_number, phone_code_hash, safety_net_token = NULL, play_integrity_token = NULL, ios_push_secret = NULL) {
      self$phone_number <- phone_number
      self$phone_code_hash <- phone_code_hash
      self$safety_net_token <- safety_net_token
      self$play_integrity_token <- play_integrity_token
      self$ios_push_secret <- ios_push_secret
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "RequestFirebaseSmsRequest",
        phone_number = self$phone_number,
        phone_code_hash = self$phone_code_hash,
        safety_net_token = self$safety_net_token,
        play_integrity_token = self$play_integrity_token,
        ios_push_secret = self$ios_push_secret
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      pack_uint32_le <- function(x) {
        con <- rawConnection(raw(), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }

      # Flags: safety_net_token -> 1, ios_push_secret -> 2, play_integrity_token -> 4
      flags <- 0L
      if (!is.null(self$safety_net_token) && !identical(self$safety_net_token, FALSE)) flags <- bitwOr(flags, 1L)
      if (!is.null(self$ios_push_secret) && !identical(self$ios_push_secret, FALSE)) flags <- bitwOr(flags, 2L)
      if (!is.null(self$play_integrity_token) && !identical(self$play_integrity_token, FALSE)) flags <- bitwOr(flags, 4L)

      constructor_bytes <- as.raw(c(0x1E, 0x26, 0x39, 0x8E)) # b'\x1e&9\x8e'
      flags_raw <- pack_uint32_le(flags)
      phone_raw <- serialize_bytes(self$phone_number)
      hash_raw <- serialize_bytes(self$phone_code_hash)

      safety_net_raw <- if (bitwAnd(flags, 1L) != 0L) serialize_bytes(self$safety_net_token) else raw()
      play_integrity_raw <- if (bitwAnd(flags, 4L) != 0L) serialize_bytes(self$play_integrity_token) else raw()
      ios_push_raw <- if (bitwAnd(flags, 2L) != 0L) serialize_bytes(self$ios_push_secret) else raw()

      c(constructor_bytes, flags_raw, phone_raw, hash_raw, safety_net_raw, play_integrity_raw, ios_push_raw)
    },

    #  @description Read from reader and create RequestFirebaseSmsRequest
    #  @param reader Reader object implementing read_int(), tgread_string(), tgread_object()
    #  @return RequestFirebaseSmsRequest instance
    from_reader = function(reader) {
      flags_val <- reader$read_int()

      phone_number_val <- reader$tgread_string()
      phone_code_hash_val <- reader$tgread_string()

      if (bitwAnd(flags_val, 1L) != 0L) {
        safety_net_val <- reader$tgread_string()
      } else {
        safety_net_val <- NULL
      }

      if (bitwAnd(flags_val, 4L) != 0L) {
        play_integrity_val <- reader$tgread_string()
      } else {
        play_integrity_val <- NULL
      }

      if (bitwAnd(flags_val, 2L) != 0L) {
        ios_push_val <- reader$tgread_string()
      } else {
        ios_push_val <- NULL
      }

      RequestFirebaseSmsRequest$new(
        phone_number = phone_number_val,
        phone_code_hash = phone_code_hash_val,
        safety_net_token = safety_net_val,
        play_integrity_token = play_integrity_val,
        ios_push_secret = ios_push_val
      )
    }
  )
)


#' @title RequestPasswordRecoveryRequest
#' @description Telegram API request \code{auth.requestPasswordRecovery} (constructor \code{#d897bc66}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
RequestPasswordRecoveryRequest <- R6::R6Class(
  "RequestPasswordRecoveryRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xd897bc66,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xfa72d43a,

    #  @description Initialize a RequestPasswordRecoveryRequest
    #  @return invisible self
    initialize = function() {
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "RequestPasswordRecoveryRequest"
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      # constructor id bytes as in Python b'f\xbc\x97\xd8' -> 0x66 0xBC 0x97 0xD8
      as.raw(c(0x66, 0xBC, 0x97, 0xD8))
    },

    #  @description Read from reader and create RequestPasswordRecoveryRequest
    #  @param reader Reader object implementing read_int(), tgread_string(), tgread_object()
    #  @return RequestPasswordRecoveryRequest instance
    from_reader = function(reader) {
      # no fields to read
      RequestPasswordRecoveryRequest$new()
    }
  )
)


#' @title ResendCodeRequest
#' @description Telegram API request \code{auth.resendCode} (constructor \code{#cae47523}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ResendCodeRequest <- R6::R6Class(
  "ResendCodeRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xcae47523,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x6ce87081,
    #  @field phone_number Field.
    phone_number = NULL,
    #  @field phone_code_hash Field.
    phone_code_hash = NULL,
    #  @field reason Field.
    reason = NULL,

    #  @description Initialize a ResendCodeRequest
    #  @param phone_number character
    #  @param phone_code_hash character
    #  @param reason character or NULL
    initialize = function(phone_number, phone_code_hash, reason = NULL) {
      self$phone_number <- phone_number
      self$phone_code_hash <- phone_code_hash
      self$reason <- reason
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "ResendCodeRequest",
        phone_number = self$phone_number,
        phone_code_hash = self$phone_code_hash,
        reason = self$reason
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      pack_uint32_le <- function(x) {
        con <- rawConnection(raw(), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }

      flags <- if (is.null(self$reason) || identical(self$reason, FALSE)) 0L else 1L

      # constructor id bytes as in Python b'#u\xe4\xca' -> 0x23 0x75 0xE4 0xCA
      constructor_bytes <- as.raw(c(0x23, 0x75, 0xE4, 0xCA))

      phone_raw <- serialize_bytes(self$phone_number)
      hash_raw <- serialize_bytes(self$phone_code_hash)
      reason_raw <- if (is.null(self$reason) || identical(self$reason, FALSE)) raw() else serialize_bytes(self$reason)

      c(
        constructor_bytes,
        pack_uint32_le(flags),
        phone_raw,
        hash_raw,
        reason_raw
      )
    },

    #  @description Read from reader and create ResendCodeRequest
    #  @param reader Reader object implementing read_int(), tgread_string(), tgread_object()
    #  @return ResendCodeRequest instance
    from_reader = function(reader) {
      flags_val <- reader$read_int()

      phone_number_val <- reader$tgread_string()
      phone_code_hash_val <- reader$tgread_string()

      if (bitwAnd(flags_val, 1L) != 0L) {
        reason_val <- reader$tgread_string()
      } else {
        reason_val <- NULL
      }

      ResendCodeRequest$new(
        phone_number = phone_number_val,
        phone_code_hash = phone_code_hash_val,
        reason = reason_val
      )
    }
  )
)


#' @title ResetAuthorizationsRequest
#' @description Telegram API request \code{auth.resetAuthorizations} (constructor \code{#9fab0d1a}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ResetAuthorizationsRequest <- R6::R6Class(
  "ResetAuthorizationsRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x9fab0d1a,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize a ResetAuthorizationsRequest
    #  @return invisible self
    initialize = function() {
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "ResetAuthorizationsRequest"
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      # constructor id in little-endian byte order: b'\x1a\r\xab\x9f'
      as.raw(c(0x1a, 0x0d, 0xab, 0x9f))
    },

    #  @description Read from reader and create ResetAuthorizationsRequest
    #  @param reader Reader object implementing read_int(), tgread_string(), tgread_object()
    #  @return ResetAuthorizationsRequest instance
    from_reader = function(reader) {
      # no fields to read
      ResetAuthorizationsRequest$new()
    }
  )
)


#' @title ResetLoginEmailRequest
#' @description Telegram API request \code{auth.resetLoginEmail} (constructor \code{#7e960193}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
ResetLoginEmailRequest <- R6::R6Class(
  "ResetLoginEmailRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x7e960193,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x6ce87081,
    #  @field phone_number Field.
    phone_number = NULL,
    #  @field phone_code_hash Field.
    phone_code_hash = NULL,

    #  @description Initialize a ResetLoginEmailRequest
    #  @param phone_number character
    #  @param phone_code_hash character
    initialize = function(phone_number, phone_code_hash) {
      self$phone_number <- phone_number
      self$phone_code_hash <- phone_code_hash
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "ResetLoginEmailRequest",
        phone_number = self$phone_number,
        phone_code_hash = self$phone_code_hash
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      # constructor id in little-endian byte order: b'\x93\x01\x96~'
      constructor_bytes <- as.raw(c(0x93, 0x01, 0x96, 0x7e))
      phone_raw <- serialize_bytes(self$phone_number)
      hash_raw <- serialize_bytes(self$phone_code_hash)

      c(constructor_bytes, phone_raw, hash_raw)
    },

    #  @description Read from reader and create ResetLoginEmailRequest
    #  @param reader Reader object implementing read_int(), tgread_string(), tgread_object()
    #  @return ResetLoginEmailRequest instance
    from_reader = function(reader) {
      phone_number_val <- reader$tgread_string()
      phone_code_hash_val <- reader$tgread_string()

      ResetLoginEmailRequest$new(
        phone_number = phone_number_val,
        phone_code_hash = phone_code_hash_val
      )
    }
  )
)


#' @title SendCodeRequest
#' @description Telegram API request \code{auth.sendCode} (constructor \code{#a677244f}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
SendCodeRequest <- R6::R6Class(
  "SendCodeRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xa677244f,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x6ce87081,
    #  @field phone_number Field.
    phone_number = NULL,
    #  @field api_id Field.
    api_id = NULL,
    #  @field api_hash Field.
    api_hash = NULL,
    #  @field settings Field.
    settings = NULL,

    #  @description Initialize a SendCodeRequest
    #  @param phone_number character
    #  @param api_id integer
    #  @param api_hash character
    #  @param settings TL object
    initialize = function(phone_number, api_id, api_hash, settings) {
      self$phone_number <- phone_number
      self$api_id <- api_id
      self$api_hash <- api_hash
      self$settings <- settings
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "SendCodeRequest",
        phone_number = self$phone_number,
        api_id = self$api_id,
        api_hash = self$api_hash,
        settings = if (is.null(self$settings)) NULL else (if (inherits(self$settings, "R6") && !is.null(self$settings$to_list)) self$settings$to_list() else self$settings)
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      pack_uint32_le <- function(x) {
        con <- rawConnection(raw(), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_tl_obj <- function(obj) {
        if (is.null(obj)) {
          return(raw())
        }
        if (is.raw(obj)) {
          return(obj)
        }
        if (is.function(obj$to_bytes)) {
          return(obj$to_bytes())
        }
        if (is.function(obj$to_raw)) {
          return(obj$to_raw())
        }
        if (is.function(obj$bytes)) {
          return(obj$bytes())
        }

        # Fallback for partially generated CodeSettings class with no bytes methods.
        if (inherits(obj, "CodeSettings")) {
          # codeSettings#ad253d78 with flags only; default instance has all flags unset.
          ctor <- as.raw(c(0x78, 0x3d, 0x25, 0xad))
          flags <- pack_uint32_le(0L)
          return(c(ctor, flags))
        }
        stop("TL object does not provide to_bytes()/to_raw()/bytes()")
      }

      constructor_bytes <- as.raw(c(0x4f, 0x24, 0x77, 0xa6))

      phone_raw <- serialize_bytes(self$phone_number)
      api_id_raw <- pack_uint32_le(self$api_id)
      api_hash_raw <- serialize_bytes(self$api_hash)

      settings_bytes <- serialize_tl_obj(self$settings)

      c(
        constructor_bytes,
        api_id_raw = api_id_raw, # ensure ordering
        phone_raw,
        api_id_raw,
        api_hash_raw,
        settings_bytes
      ) -> out_parts

      # The above accidentally included api_id_raw twice; fix ordering explicitly:
      c(
        constructor_bytes,
        phone_raw,
        api_id_raw,
        api_hash_raw,
        settings_bytes
      )
    },

    #  @description Read from reader and create SendCodeRequest
    #  @param reader Reader object implementing read_int(), tgread_string(), tgread_object()
    #  @return SendCodeRequest instance
    from_reader = function(reader) {
      phone_number_val <- reader$tgread_string()
      api_id_val <- reader$read_int()
      api_hash_val <- reader$tgread_string()
      settings_val <- reader$tgread_object()

      SendCodeRequest$new(
        phone_number = phone_number_val,
        api_id = api_id_val,
        api_hash = api_hash_val,
        settings = settings_val
      )
    }
  )
)


#' @title SignInRequest
#' @description Telegram API request \code{auth.signIn} (constructor \code{#8d52a951}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
SignInRequest <- R6::R6Class(
  "SignInRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x8d52a951,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xb9e04e39,
    #  @field phone_number Field.
    phone_number = NULL,
    #  @field phone_code_hash Field.
    phone_code_hash = NULL,
    #  @field phone_code Field.
    phone_code = NULL,
    #  @field email_verification Field.
    email_verification = NULL,

    #  @description Initialize a SignInRequest
    #  @param phone_number character
    #  @param phone_code_hash character
    #  @param phone_code character or NULL
    #  @param email_verification TL object or NULL
    initialize = function(phone_number, phone_code_hash, phone_code = NULL, email_verification = NULL) {
      self$phone_number <- phone_number
      self$phone_code_hash <- phone_code_hash
      self$phone_code <- phone_code
      self$email_verification <- email_verification
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "SignInRequest",
        phone_number = self$phone_number,
        phone_code_hash = self$phone_code_hash,
        phone_code = self$phone_code,
        email_verification = if (is.null(self$email_verification)) NULL else (if (inherits(self$email_verification, "R6") && !is.null(self$email_verification$to_list)) self$email_verification$to_list() else self$email_verification)
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      pack_uint32_le <- function(x) {
        con <- rawConnection(raw(), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }

      flags <- if (is.null(self$phone_code) || identical(self$phone_code, FALSE)) 0L else 1L
      if (!is.null(self$email_verification) && !identical(self$email_verification, FALSE)) flags <- bitwOr(flags, 2L)

      constructor_bytes <- as.raw(c(0x51, 0xA9, 0x52, 0x8D))

      flags_raw <- pack_uint32_le(flags)
      phone_raw <- serialize_bytes(self$phone_number)
      hash_raw <- serialize_bytes(self$phone_code_hash)
      phone_code_raw <- if (is.null(self$phone_code) || identical(self$phone_code, FALSE)) raw() else serialize_bytes(self$phone_code)

      email_ver_bytes <- if (is.null(self$email_verification) || identical(self$email_verification, FALSE)) {
        raw()
      } else {
        if (inherits(self$email_verification, "R6") && !is.null(self$email_verification$`_bytes`)) {
          self$email_verification$`_bytes`()
        } else if (inherits(self$email_verification, "R6") && !is.null(self$email_verification$to_bytes)) {
          self$email_verification$to_bytes()
        } else {
          stop("email_verification object does not provide _bytes() or to_bytes()")
        }
      }

      c(
        constructor_bytes,
        flags_raw,
        phone_raw,
        hash_raw,
        phone_code_raw,
        email_ver_bytes
      )
    },

    #  @description Read from reader and create SignInRequest
    #  @param reader Reader object implementing read_int(), tgread_string(), tgread_object()
    #  @return SignInRequest instance
    from_reader = function(reader) {
      flags_val <- reader$read_int()

      phone_number_val <- reader$tgread_string()
      phone_code_hash_val <- reader$tgread_string()

      if (bitwAnd(flags_val, 1L) != 0L) {
        phone_code_val <- reader$tgread_string()
      } else {
        phone_code_val <- NULL
      }

      if (bitwAnd(flags_val, 2L) != 0L) {
        email_verification_val <- reader$tgread_object()
      } else {
        email_verification_val <- NULL
      }

      SignInRequest$new(
        phone_number = phone_number_val,
        phone_code_hash = phone_code_hash_val,
        phone_code = phone_code_val,
        email_verification = email_verification_val
      )
    }
  )
)


#' @title SignUpRequest
#' @description Telegram API request \code{auth.signUp} (constructor \code{#aac7b717}).
#'   Auto-generated from the TL schema by \code{data-raw/generate_tl.R}; do not edit by hand.
#' @keywords internal
#' @noRd
SignUpRequest <- R6::R6Class(
  "SignUpRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xaac7b717,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xb9e04e39,
    #  @field phone_number Field.
    phone_number = NULL,
    #  @field phone_code_hash Field.
    phone_code_hash = NULL,
    #  @field first_name Field.
    first_name = NULL,
    #  @field last_name Field.
    last_name = NULL,
    #  @field no_joined_notifications Field.
    no_joined_notifications = NULL,

    #  @description Initialize a SignUpRequest
    #  @param phone_number character
    #  @param phone_code_hash character
    #  @param first_name character
    #  @param last_name character
    #  @param no_joined_notifications logical or NULL
    initialize = function(phone_number, phone_code_hash, first_name, last_name, no_joined_notifications = NULL) {
      self$phone_number <- phone_number
      self$phone_code_hash <- phone_code_hash
      self$first_name <- first_name
      self$last_name <- last_name
      self$no_joined_notifications <- no_joined_notifications
      invisible(self)
    },

    #  @description Convert to an R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "SignUpRequest",
        phone_number = self$phone_number,
        phone_code_hash = self$phone_code_hash,
        first_name = self$first_name,
        last_name = self$last_name,
        no_joined_notifications = self$no_joined_notifications
      )
    },

    #  @description Serialize to bytes
    #  @return raw vector
    to_bytes = function() {
      # helper to pack a 32-bit unsigned integer little-endian
      pack_uint32_le <- function(x) {
        con <- rawConnection(raw(), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }

      flags <- if (is.null(self$no_joined_notifications) || identical(self$no_joined_notifications, FALSE)) 0L else 1L

      # constructor id bytes (same order as Python b'\x17\xb7\xc7\xaa')
      constructor_bytes <- as.raw(c(0x17, 0xB7, 0xC7, 0xAA))

      # The class expects a helper serialize_bytes(string) to exist (provided by TL base).
      # If not present in the environment, the following will error; that mirrors the
      # pattern used across other request classes.
      phone_raw <- serialize_bytes(self$phone_number)
      hash_raw <- serialize_bytes(self$phone_code_hash)
      first_raw <- serialize_bytes(self$first_name)
      last_raw <- serialize_bytes(self$last_name)

      c(
        constructor_bytes,
        pack_uint32_le(flags),
        phone_raw,
        hash_raw,
        first_raw,
        last_raw
      )
    },

    #  @description Read from reader and create SignUpRequest
    #  @param reader Reader object implementing read_int() and tgread_string()
    #  @return SignUpRequest instance
    from_reader = function(reader) {
      flags <- reader$read_int()
      no_joined_notifications_flag <- bitwAnd(flags, 1L) != 0L

      phone_number_val <- reader$tgread_string()
      phone_code_hash_val <- reader$tgread_string()
      first_name_val <- reader$tgread_string()
      last_name_val <- reader$tgread_string()

      SignUpRequest$new(
        phone_number = phone_number_val,
        phone_code_hash = phone_code_hash_val,
        first_name = first_name_val,
        last_name = last_name_val,
        no_joined_notifications = no_joined_notifications_flag
      )
    }
  )
)
