#  DestroyAuthKeyRequest R6 class
# 
#  Represents the TL request `DestroyAuthKeyRequest`.
# 
#  Fields:
#  - (no fields)
# 
#  Methods:
#  - new(): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
#  @noRd
#  @noRd
DestroyAuthKeyRequest <- R6::R6Class(
  classname = "DestroyAuthKeyRequest",
  public = list(
    #  Initialize a DestroyAuthKeyRequest
    initialize = function() {
      # no fields to initialize
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      list(
        `_` = "DestroyAuthKeyRequest"
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    #  @details Writes constructor id 0xd1435160 as little-endian bytes: 0x60 0x51 0x43 0xD1
    to_raw = function() {
      constructor_bytes <- as.raw(c(0x60, 0x51, 0x43, 0xD1))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      rawConnectionValue(conn)
    }
  ),
  active = list(),
  #  @field class Field.
  class = TRUE
)

# Create a DestroyAuthKeyRequest from a reader
# @name DestroyAuthKeyRequest_from_reader
#
# The reader is not used for this constructor (no payload).
# @param reader ignored
# @return DestroyAuthKeyRequest instance
DestroyAuthKeyRequest$from_reader <- function(reader) {
  DestroyAuthKeyRequest$new()
}


#  DestroySessionRequest R6 class
# 
#  Represents the TL request `DestroySessionRequest`.
# 
#  Fields:
#  - session_id: numeric/integer (64-bit placeholder)
# 
#  Methods:
#  - new(session_id): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
#  @noRd
#  @noRd
DestroySessionRequest <- R6::R6Class(
  classname = "DestroySessionRequest",
  public = list(
    #  @field session_id Field.
    session_id = NULL,

    #  Initialize a DestroySessionRequest
    #  @param session_id numeric/integer 64-bit
    initialize = function(session_id) {
      if (missing(session_id)) stop("session_id is required")
      self$session_id <- session_id
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      list(
        `_` = "DestroySessionRequest",
        session_id = self$session_id
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    #  @details Writes constructor id 0xe7512126 as little-endian bytes: 0x26 0x21 0x51 0xE7,
    #  then writes session_id as 8-byte little-endian (placeholder via numeric).
    to_raw = function() {
      constructor_bytes <- as.raw(c(0x26, 0x21, 0x51, 0xE7))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # NOTE: writeBin on numeric with size=8 uses IEEE754 double; for exact 64-bit two's-complement
      # preservation, replace with a dedicated 64-bit writer.
      writeBin(as.numeric(self$session_id), conn, size = 8, endian = "little")
      rawConnectionValue(conn)
    }
  ),
  active = list(),
  #  @field class Field.
  class = TRUE
)

# Create a DestroySessionRequest from a reader
# @name DestroySessionRequest_from_reader
#
# The reader is expected to provide `read_long()` returning a numeric/integer for 64-bit.
# @param reader Object with a read_long() method
# @return DestroySessionRequest instance
DestroySessionRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$read_long)) {
    stop("reader must implement read_long()")
  }
  session_id_val <- reader$read_long()
  DestroySessionRequest$new(session_id = session_id_val)
}


#  GetFutureSaltsRequest R6 class
# 
#  Represents the TL request `GetFutureSaltsRequest`.
# 
#  Fields:
#  - num: integer (32-bit)
# 
#  Methods:
#  - new(num): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
#  @noRd
#  @noRd
GetFutureSaltsRequest <- R6::R6Class(
  classname = "GetFutureSaltsRequest",
  public = list(
    #  @field num Field.
    num = NULL,

    #  Initialize a GetFutureSaltsRequest
    #  @param num integer 32-bit
    initialize = function(num) {
      if (missing(num)) stop("num is required")
      self$num <- as.integer(num)
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      list(
        `_` = "GetFutureSaltsRequest",
        num = self$num
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    #  @details Writes constructor id 0xb921bd04 as little-endian bytes: 0x04 0xBD 0x21 0xB9,
    #  then writes num as 4-byte little-endian integer.
    to_raw = function() {
      constructor_bytes <- as.raw(c(0x04, 0xBD, 0x21, 0xB9))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      writeBin(as.integer(self$num), conn, size = 4, endian = "little")
      rawConnectionValue(conn)
    }
  ),
  active = list(),
  #  @field class Field.
  class = TRUE
)

# Create a GetFutureSaltsRequest from a reader
# @name GetFutureSaltsRequest_from_reader
#
# The reader is expected to provide `read_int()` returning an integer (32-bit).
# @param reader Object with a read_int() method
# @return GetFutureSaltsRequest instance
GetFutureSaltsRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$read_int)) {
    stop("reader must implement read_int()")
  }
  num_val <- reader$read_int()
  GetFutureSaltsRequest$new(num = num_val)
}


#  InitConnectionRequest R6 class
# 
#  Represents the TL request `InitConnectionRequest`.
# 
#  Fields:
#  - api_id: integer (32-bit)
#  - device_model: character
#  - system_version: character
#  - app_version: character
#  - system_lang_code: character
#  - lang_pack: character
#  - lang_code: character
#  - query: TypeX (an object providing to_raw()/to_list() or a raw vector/character)
#  - proxy: optional TypeInputClientProxy (object with to_raw()/to_list(), raw, or character)
#  - params: optional TypeJSONValue (object with to_raw()/to_list(), raw, or character)
# 
#  Methods:
#  - new(api_id, device_model, system_version, app_version, system_lang_code, lang_pack, lang_code, query, proxy = NULL, params = NULL)
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
# 
#  Note: string and object serialization is simplified (charToRaw, nested to_raw()). For
#  exact TL compact string encoding or precise integer widths replace with correct utilities.
#  @noRd
#  @noRd
InitConnectionRequest <- R6::R6Class(
  classname = "InitConnectionRequest",
  public = list(
    #  @field api_id Field.
    api_id = NULL,
    #  @field device_model Field.
    device_model = NULL,
    #  @field system_version Field.
    system_version = NULL,
    #  @field app_version Field.
    app_version = NULL,
    #  @field system_lang_code Field.
    system_lang_code = NULL,
    #  @field lang_pack Field.
    lang_pack = NULL,
    #  @field lang_code Field.
    lang_code = NULL,
    #  @field query Field.
    query = NULL,
    #  @field proxy Field.
    proxy = NULL,
    #  @field params Field.
    params = NULL,

    #  Initialize an InitConnectionRequest
    #  @param api_id integer
    #  @param device_model character
    #  @param system_version character
    #  @param app_version character
    #  @param system_lang_code character
    #  @param lang_pack character
    #  @param lang_code character
    #  @param query nested query object (required)
    #  @param proxy optional proxy object
    #  @param params optional params object
    initialize = function(api_id, device_model, system_version, app_version,
                          system_lang_code, lang_pack, lang_code,
                          query, proxy = NULL, params = NULL) {
      if (missing(api_id) || missing(device_model) || missing(system_version) ||
        missing(app_version) || missing(system_lang_code) || missing(lang_pack) ||
        missing(lang_code) || missing(query)) {
        stop("api_id, device_model, system_version, app_version, system_lang_code, lang_pack, lang_code and query are required")
      }
      self$api_id <- as.integer(api_id)
      self$device_model <- as.character(device_model)
      self$system_version <- as.character(system_version)
      self$app_version <- as.character(app_version)
      self$system_lang_code <- as.character(system_lang_code)
      self$lang_pack <- as.character(lang_pack)
      self$lang_code <- as.character(lang_code)
      self$query <- query
      self$proxy <- proxy
      self$params <- params
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    #  @details to_list will call nested object's to_list() if available.
    to_list = function() {
      proxy_out <- NULL
      if (!is.null(self$proxy)) {
        if (is.function(self$proxy$to_list)) {
          proxy_out <- self$proxy$to_list()
        } else {
          proxy_out <- self$proxy
        }
      }
      params_out <- NULL
      if (!is.null(self$params)) {
        if (is.function(self$params$to_list)) {
          params_out <- self$params$to_list()
        } else {
          params_out <- self$params
        }
      }
      query_out <- NULL
      if (!is.null(self$query)) {
        if (is.function(self$query$to_list)) {
          query_out <- self$query$to_list()
        } else {
          query_out <- self$query
        }
      }
      list(
        `_` = "InitConnectionRequest",
        api_id = self$api_id,
        device_model = self$device_model,
        system_version = self$system_version,
        app_version = self$app_version,
        system_lang_code = self$system_lang_code,
        lang_pack = self$lang_pack,
        lang_code = self$lang_code,
        query = query_out,
        proxy = proxy_out,
        params = params_out
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    #  @details
    #  Writes constructor id 0xa95ecd c1 (bytes: 0xA9 0x5E 0xCD 0xC1),
    #  then flags (4 bytes little-endian), api_id (4 bytes little-endian),
    #  then simple string bytes for device_model, system_version, app_version,
    #  system_lang_code, lang_pack, lang_code, then optional proxy and params bytes,
    #  and finally nested query bytes.
    to_raw = function() {
      # CONSTRUCTOR_ID bytes: 0xA9 0x5E 0xCD 0xC1
      constructor_bytes <- as.raw(c(0xA9, 0x5E, 0xCD, 0xC1))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))

      writeBin(constructor_bytes, conn)

      flags <- bitwOr(
        if (is.null(self$proxy) || identical(self$proxy, FALSE)) 0L else 1L,
        if (is.null(self$params) || identical(self$params, FALSE)) 0L else 2L
      )
      writeBin(as.integer(flags), conn, size = 4, endian = "little")

      writeBin(as.integer(self$api_id), conn, size = 4, endian = "little")

      # TL strings must use Telegram's bytes/string encoding with padding.
      writeBin(serialize_bytes(self$device_model), conn)
      writeBin(serialize_bytes(self$system_version), conn)
      writeBin(serialize_bytes(self$app_version), conn)
      writeBin(serialize_bytes(self$system_lang_code), conn)
      writeBin(serialize_bytes(self$lang_pack), conn)
      writeBin(serialize_bytes(self$lang_code), conn)

      write_tl_object <- function(obj, field_name) {
        if (is.raw(obj)) {
          if (length(obj) > 0) writeBin(obj, conn)
          return(invisible(NULL))
        }
        if (!is.null(obj) && is.function(obj$to_bytes)) {
          nested <- obj$to_bytes()
          if (is.raw(nested) && length(nested) > 0) writeBin(nested, conn)
          return(invisible(NULL))
        }
        if (!is.null(obj) && is.function(obj$to_raw)) {
          nested <- obj$to_raw()
          if (is.raw(nested) && length(nested) > 0) writeBin(nested, conn)
          return(invisible(NULL))
        }
        if (!is.null(obj) && is.function(obj$bytes)) {
          nested <- obj$bytes()
          if (is.raw(nested) && length(nested) > 0) writeBin(nested, conn)
          return(invisible(NULL))
        }
        if (is.character(obj)) {
          writeBin(serialize_bytes(obj), conn)
          return(invisible(NULL))
        }
        stop(sprintf("%s must be TL object with to_bytes()/to_raw()/bytes(), raw, or character", field_name))
      }

      # optional proxy
      if (!is.null(self$proxy) && !identical(self$proxy, FALSE)) {
        write_tl_object(self$proxy, "proxy")
      }

      # optional params
      if (!is.null(self$params) && !identical(self$params, FALSE)) {
        write_tl_object(self$params, "params")
      }

      # nested query (required)
      write_tl_object(self$query, "query")

      rawConnectionValue(conn)
    }
  ),
  active = list(),
  #  @field class Field.
  class = TRUE
)

# Create an InitConnectionRequest from a reader
# @name InitConnectionRequest_from_reader
#
# The reader is expected to provide:
# - read_int(): returns integer for 32-bit
# - tgread_string(): returns a character string
# - tgread_object(): returns the nested object (already parsed)
# @param reader Object with required methods
# @return InitConnectionRequest instance
InitConnectionRequest$from_reader <- function(reader) {
  if (is.null(reader) ||
    !is.function(reader$read_int) ||
    !is.function(reader$tgread_string) ||
    !is.function(reader$tgread_object)) {
    stop("reader must implement read_int(), tgread_string() and tgread_object()")
  }

  flags <- reader$read_int()
  api_id_val <- reader$read_int()
  device_model_val <- reader$tgread_string()
  system_version_val <- reader$tgread_string()
  app_version_val <- reader$tgread_string()
  system_lang_code_val <- reader$tgread_string()
  lang_pack_val <- reader$tgread_string()
  lang_code_val <- reader$tgread_string()

  proxy_val <- NULL
  if (bitwAnd(flags, 1L) != 0L) {
    proxy_val <- reader$tgread_object()
  }

  params_val <- NULL
  if (bitwAnd(flags, 2L) != 0L) {
    params_val <- reader$tgread_object()
  }

  query_val <- reader$tgread_object()

  InitConnectionRequest$new(
    api_id = api_id_val,
    device_model = device_model_val,
    system_version = system_version_val,
    app_version = app_version_val,
    system_lang_code = system_lang_code_val,
    lang_pack = lang_pack_val,
    lang_code = lang_code_val,
    query = query_val,
    proxy = proxy_val,
    params = params_val
  )
}


#  InvokeAfterMsgRequest R6 class
# 
#  Represents the TL request `InvokeAfterMsgRequest`.
# 
#  Fields:
#  - msg_id: numeric/integer (64-bit placeholder)
#  - query: TypeX (an object representing a TL query). May be an R6 TL object with to_raw()/to_list().
# 
#  Methods:
#  - new(msg_id, query): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
# 
#  @details
#  to_raw() writes the constructor id (0xcb9f372d) in little-endian (bytes: 0x2D 0x37 0x9F 0xCB),
#  then msg_id as 8-byte little-endian value, followed by nested query bytes.
#  Note: writeBin on numeric with size=8 uses IEEE754 double; for exact 64-bit two's-complement
#  preservation, replace with a dedicated 64-bit writer.
#  @noRd
#  @noRd
InvokeAfterMsgRequest <- R6::R6Class(
  classname = "InvokeAfterMsgRequest",
  public = list(
    #  @field msg_id Field.
    msg_id = NULL,
    #  @field query Field.
    query = NULL,

    #  Initialize an InvokeAfterMsgRequest
    #  @param msg_id numeric/integer 64-bit
    #  @param query TypeX object or raw vector representing the inner query
    initialize = function(msg_id, query) {
      if (missing(msg_id) || missing(query)) stop("msg_id and query are required")
      self$msg_id <- msg_id
      self$query <- query
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    #  @description
    #  to_list will call query$to_list() if available to produce a nested list.
    to_list = function() {
      query_out <- NULL
      if (!is.null(self$query)) {
        if (is.function(self$query$to_list)) {
          query_out <- self$query$to_list()
        } else {
          query_out <- self$query
        }
      }
      list(
        `_` = "InvokeAfterMsgRequest",
        msg_id = self$msg_id,
        query = query_out
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    #  @description
    #  Writes constructor id 0xcb9f372d as little-endian (bytes: 0x2D 0x37 0x9F 0xCB),
    #  then writes msg_id as 8-byte little-endian, then nested query bytes.
    to_raw = function() {
      # CONSTRUCTOR_ID 0xcb9f372d little endian bytes: b'-7\x9f\xcb' => 0x2D 0x37 0x9F 0xCB
      constructor_bytes <- as.raw(c(0x2D, 0x37, 0x9F, 0xCB))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # NOTE: writeBin on numeric with size=8 uses IEEE754 double; if you need exact
      # two's-complement 64-bit integer, replace this with a proper 64-bit writer.
      writeBin(as.numeric(self$msg_id), conn, size = 8, endian = "little")
      # nested query bytes: prefer query$to_raw(), else if raw, write directly
      if (is.raw(self$query)) {
        if (length(self$query) > 0) writeBin(self$query, conn)
      } else if (!is.null(self$query) && is.function(self$query$to_raw)) {
        nested <- self$query$to_raw()
        if (is.raw(nested) && length(nested) > 0) writeBin(nested, conn)
      } else {
        if (is.character(self$query)) {
          writeBin(charToRaw(self$query), conn)
        } else {
          stop("query must be an object with to_raw(), a raw vector, or a character")
        }
      }
      rawConnectionValue(conn)
    }
  ),
  active = list(),
  #  @field class Field.
  class = TRUE
)

# Create an InvokeAfterMsgRequest from a reader
# @name InvokeAfterMsgRequest_from_reader
#
# The reader is expected to provide:
# - read_long(): returns numeric/integer for 64-bit
# - tgread_object(): returns the nested query object (already parsed)
# @param reader Object with required methods
# @return InvokeAfterMsgRequest instance
InvokeAfterMsgRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$read_long) || !is.function(reader$tgread_object)) {
    stop("reader must implement read_long() and tgread_object()")
  }
  msg_id_val <- reader$read_long()
  query_val <- reader$tgread_object()
  InvokeAfterMsgRequest$new(msg_id = msg_id_val, query = query_val)
}


#  InvokeAfterMsgsRequest R6 class
# 
#  Represents the TL request `InvokeAfterMsgsRequest`.
# 
#  Fields:
#  - msg_ids: numeric/integer vector (64-bit ids; numeric placeholders are used)
#  - query: TypeX (an object representing a TL query). May be an R6 TL object with to_raw()/to_list().
# 
#  Methods:
#  - new(msg_ids, query): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
# 
#  @details
#  to_raw() writes the constructor id (0x3dc4b4f0) in little-endian, then the TL-vector
#  constructor id (0x1cb5c415) and the vector length, then each msg_id as 8-byte
#  little-endian values, followed by nested query bytes.
#  @noRd
#  @noRd
InvokeAfterMsgsRequest <- R6::R6Class(
  classname = "InvokeAfterMsgsRequest",
  public = list(
    #  @field msg_ids Field.
    msg_ids = NULL,
    #  @field query Field.
    query = NULL,

    #  Initialize an InvokeAfterMsgsRequest
    #  @param msg_ids numeric/integer vector of message ids (64-bit placeholders)
    #  @param query TypeX object or raw vector representing the inner query
    initialize = function(msg_ids, query) {
      if (missing(msg_ids) || missing(query)) stop("msg_ids and query are required")
      if (!is.numeric(msg_ids)) stop("msg_ids must be numeric/integer vector")
      self$msg_ids <- as.numeric(msg_ids)
      self$query <- query
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      query_out <- NULL
      if (!is.null(self$query)) {
        if (is.function(self$query$to_list)) {
          query_out <- self$query$to_list()
        } else {
          query_out <- self$query
        }
      }
      list(
        `_` = "InvokeAfterMsgsRequest",
        msg_ids = self$msg_ids,
        query = query_out
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    to_raw = function() {
      # CONSTRUCTOR_ID 0x3dc4b4f0 little endian bytes: b'\xf0\xb4\xc4='
      constructor_bytes <- as.raw(c(0xF0, 0xB4, 0xC4, 0x3D))
      # TL vector constructor 0x1cb5c415 little endian bytes: b'\x15\xc4\xb5\x1c'
      vector_bytes <- as.raw(c(0x15, 0xC4, 0xB5, 0x1C))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # write vector constructor
      writeBin(vector_bytes, conn)
      # length of vector as 4-byte little-endian
      writeBin(as.integer(length(self$msg_ids)), conn, size = 4, endian = "little")
      # write each msg_id as 8-byte little-endian (placeholder via numeric)
      if (length(self$msg_ids) > 0) {
        for (v in self$msg_ids) {
          # NOTE: writeBin on numeric with size=8 uses IEEE754 double;
          # for exact 64-bit representation, replace with a proper 64-bit writer.
          writeBin(as.numeric(v), conn, size = 8, endian = "little")
        }
      }
      # nested query bytes: prefer query$to_raw(), else if raw, write directly
      if (is.raw(self$query)) {
        if (length(self$query) > 0) writeBin(self$query, conn)
      } else if (!is.null(self$query) && is.function(self$query$to_raw)) {
        nested <- self$query$to_raw()
        if (is.raw(nested) && length(nested) > 0) writeBin(nested, conn)
      } else {
        if (is.character(self$query)) {
          writeBin(charToRaw(self$query), conn)
        } else {
          stop("query must be an object with to_raw(), a raw vector, or a character")
        }
      }
      rawConnectionValue(conn)
    }
  ),
  active = list(),
  #  @field class Field.
  class = TRUE
)

# Create an InvokeAfterMsgsRequest from a reader
# @name InvokeAfterMsgsRequest_from_reader
#
# The reader is expected to provide:
# - read_int(): returns integer for 32-bit
# - read_long(): returns numeric/integer for 64-bit
# - tgread_object(): returns the nested query object (already parsed)
# @param reader Object with required methods
# @return InvokeAfterMsgsRequest instance
InvokeAfterMsgsRequest$from_reader <- function(reader) {
  if (is.null(reader) ||
    !is.function(reader$read_int) ||
    !is.function(reader$read_long) ||
    !is.function(reader$tgread_object)) {
    stop("reader must implement read_int(), read_long() and tgread_object()")
  }
  # consume vector constructor id (ignored)
  reader$read_int()
  count <- reader$read_int()
  msg_ids <- numeric(0)
  if (count > 0) {
    msg_ids <- numeric(count)
    for (i in seq_len(count)) {
      msg_ids[i] <- reader$read_long()
    }
  }
  query_obj <- reader$tgread_object()
  InvokeAfterMsgsRequest$new(msg_ids = msg_ids, query = query_obj)
}


#  InvokeWithApnsSecretRequest R6 class
# 
#  Represents the TL request `InvokeWithApnsSecretRequest`.
# 
#  Fields:
#  - nonce: character string
#  - secret: character string
#  - query: TypeX (an object representing a TL query). May be an R6 TL object with to_raw()/to_list().
# 
#  Methods:
#  - new(nonce, secret, query): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
# 
#  @details
#  to_raw() writes constructor id 0x0dae54f8 (little-endian bytes: 0xf8 0x54 0xae 0x0d),
#  then nonce and secret as TL strings (here serialized via charToRaw for simplicity),
#  then nested query bytes.
#  @noRd
#  @noRd
InvokeWithApnsSecretRequest <- R6::R6Class(
  classname = "InvokeWithApnsSecretRequest",
  public = list(
    #  @field nonce Field.
    nonce = NULL,
    #  @field secret Field.
    secret = NULL,
    #  @field query Field.
    query = NULL,

    #  Initialize an InvokeWithApnsSecretRequest
    #  @param nonce character string
    #  @param secret character string
    #  @param query TypeX object or raw vector representing the inner query
    initialize = function(nonce, secret, query) {
      if (missing(nonce) || missing(secret) || missing(query)) stop("nonce, secret and query are required")
      if (!is.character(nonce) || length(nonce) != 1) stop("nonce must be a single string")
      if (!is.character(secret) || length(secret) != 1) stop("secret must be a single string")
      self$nonce <- nonce
      self$secret <- secret
      self$query <- query
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      query_out <- NULL
      if (!is.null(self$query)) {
        if (is.function(self$query$to_list)) {
          query_out <- self$query$to_list()
        } else {
          query_out <- self$query
        }
      }
      list(
        `_` = "InvokeWithApnsSecretRequest",
        nonce = self$nonce,
        secret = self$secret,
        query = query_out
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    to_raw = function() {
      # CONSTRUCTOR_ID 0x0dae54f8 little endian bytes: b'\xf8T\xae\r'
      constructor_bytes <- as.raw(c(0xF8, 0x54, 0xAE, 0x0D))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # write nonce and secret as TL strings (simple raw bytes here)
      writeBin(charToRaw(self$nonce), conn)
      writeBin(charToRaw(self$secret), conn)
      # nested query bytes
      if (is.raw(self$query)) {
        if (length(self$query) > 0) writeBin(self$query, conn)
      } else if (!is.null(self$query) && is.function(self$query$to_raw)) {
        nested <- self$query$to_raw()
        if (is.raw(nested) && length(nested) > 0) writeBin(nested, conn)
      } else {
        if (is.character(self$query)) {
          writeBin(charToRaw(self$query), conn)
        } else {
          stop("query must be an object with to_raw(), a raw vector, or a character")
        }
      }
      rawConnectionValue(conn)
    }
  ),
  active = list(),
  #  @field class Field.
  class = TRUE
)

# Create an InvokeWithApnsSecretRequest from a reader
# @name InvokeWithApnsSecretRequest_from_reader
#
# The reader is expected to provide:
# - tgread_string(): returns a character string
# - tgread_object(): returns the nested query object (already parsed)
# @param reader Object with required methods
# @return InvokeWithApnsSecretRequest instance
InvokeWithApnsSecretRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$tgread_string) || !is.function(reader$tgread_object)) {
    stop("reader must implement tgread_string() and tgread_object()")
  }
  nonce_val <- reader$tgread_string()
  secret_val <- reader$tgread_string()
  query_obj <- reader$tgread_object()
  InvokeWithApnsSecretRequest$new(nonce = nonce_val, secret = secret_val, query = query_obj)
}


#  InvokeWithBusinessConnectionRequest R6 class
# 
#  Represents the TL request `InvokeWithBusinessConnectionRequest`.
# 
#  Fields:
#  - connection_id: character string
#  - query: TypeX (an object representing a TL query). May be an R6 TL object with to_raw()/to_list().
# 
#  Methods:
#  - new(connection_id, query): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
# 
#  @details
#  to_raw() writes the constructor id (0xdd289f8e) in little-endian, then the
#  connection_id bytes (here via charToRaw) and then the nested query bytes.
#  The nested query is expected to provide a to_raw() method returning a raw vector,
#  or to already be a raw vector. If the query is a character, it will be converted using charToRaw().
#  @noRd
#  @noRd
InvokeWithBusinessConnectionRequest <- R6::R6Class(
  classname = "InvokeWithBusinessConnectionRequest",
  public = list(
    #  @field connection_id Field.
    connection_id = NULL,
    #  @field query Field.
    query = NULL,

    #  Initialize an InvokeWithBusinessConnectionRequest
    #  @param connection_id character string
    #  @param query TypeX object or raw vector representing the inner query
    initialize = function(connection_id, query) {
      if (missing(connection_id) || missing(query)) stop("connection_id and query are required")
      if (!is.character(connection_id) || length(connection_id) != 1) stop("connection_id must be a single string")
      self$connection_id <- connection_id
      self$query <- query
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      query_out <- NULL
      if (!is.null(self$query)) {
        if (is.function(self$query$to_list)) {
          query_out <- self$query$to_list()
        } else {
          query_out <- self$query
        }
      }
      list(
        `_` = "InvokeWithBusinessConnectionRequest",
        connection_id = self$connection_id,
        query = query_out
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    #  @details
    #  Writes constructor id 0xdd289f8e as little-endian (bytes: 0x8E 0x9F 0x28 0xDD),
    #  then writes connection_id as raw bytes (charToRaw), then nested query bytes.
    to_raw = function() {
      # CONSTRUCTOR_ID 0xdd289f8e little endian bytes: b'\x8e\x9f(\xdd'
      constructor_bytes <- as.raw(c(0x8E, 0x9F, 0x28, 0xDD))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # write connection_id as raw bytes
      writeBin(charToRaw(self$connection_id), conn)
      # nested query bytes: prefer query$to_raw(), else if raw, write directly
      if (is.raw(self$query)) {
        if (length(self$query) > 0) writeBin(self$query, conn)
      } else if (!is.null(self$query) && is.function(self$query$to_raw)) {
        nested <- self$query$to_raw()
        if (is.raw(nested) && length(nested) > 0) writeBin(nested, conn)
      } else {
        if (is.character(self$query)) {
          writeBin(charToRaw(self$query), conn)
        } else {
          stop("query must be an object with to_raw(), a raw vector, or a character")
        }
      }
      rawConnectionValue(conn)
    }
  ),
  active = list(),
  #  @field class Field.
  class = TRUE
)

# Create an InvokeWithBusinessConnectionRequest from a reader
# @name InvokeWithBusinessConnectionRequest_from_reader
#
# The reader is expected to provide:
# - tgread_string(): returns a character string
# - tgread_object(): returns the nested query object (already parsed)
# @param reader Object with required methods
# @return InvokeWithBusinessConnectionRequest instance
InvokeWithBusinessConnectionRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$tgread_string) || !is.function(reader$tgread_object)) {
    stop("reader must implement tgread_string() and tgread_object()")
  }
  connection_id_val <- reader$tgread_string()
  query_val <- reader$tgread_object()
  InvokeWithBusinessConnectionRequest$new(connection_id = connection_id_val, query = query_val)
}


#  InvokeWithGooglePlayIntegrityRequest R6 class
# 
#  Represents the TL request `InvokeWithGooglePlayIntegrityRequest`.
# 
#  Fields:
#  - nonce: character string
#  - token: character string
#  - query: TypeX (an object representing a TL query). May be an R6 TL object with to_raw()/to_list().
# 
#  Methods:
#  - new(nonce, token, query): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
# 
#  @details
#  to_raw() writes the constructor id (0x1df92984) in little-endian, then nonce,
#  token as raw bytes and then the nested query bytes. The nested query is expected
#  to provide a to_raw() method or be a raw vector.
#  @noRd
#  @noRd
InvokeWithGooglePlayIntegrityRequest <- R6::R6Class(
  #  @field classname Field.
  classname = "InvokeWithGooglePlayIntegrityRequest",
  public = list(
    #  @field nonce Field.
    nonce = NULL,
    #  @field token Field.
    token = NULL,
    #  @field query Field.
    query = NULL,

    #  Initialize an InvokeWithGooglePlayIntegrityRequest
    #  @param nonce character string
    #  @param token character string
    #  @param query TypeX object or raw vector representing the inner query
    initialize = function(nonce, token, query) {
      if (missing(nonce) || missing(token) || missing(query)) stop("nonce, token and query are required")
      if (!is.character(nonce) || length(nonce) != 1) stop("nonce must be a single string")
      if (!is.character(token) || length(token) != 1) stop("token must be a single string")
      self$nonce <- nonce
      self$token <- token
      self$query <- query
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      query_out <- NULL
      if (!is.null(self$query)) {
        if (is.function(self$query$to_list)) {
          query_out <- self$query$to_list()
        } else {
          query_out <- self$query
        }
      }
      list(
        `_` = "InvokeWithGooglePlayIntegrityRequest",
        nonce = self$nonce,
        token = self$token,
        query = query_out
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    #  @details
    #  Writes constructor id 0x1df92984 as little-endian (bytes: 0x84 0x29 0xF9 0x1D),
    #  then nonce and token bytes, then nested query bytes.
    to_raw = function() {
      # CONSTRUCTOR_ID 0x1df92984 little endian bytes: b'\x84)\xf9\x1d'
      constructor_bytes <- as.raw(c(0x84, 0x29, 0xF9, 0x1D))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # write nonce and token as raw bytes
      writeBin(charToRaw(self$nonce), conn)
      writeBin(charToRaw(self$token), conn)
      # nested query bytes
      if (is.raw(self$query)) {
        if (length(self$query) > 0) writeBin(self$query, conn)
      } else if (!is.null(self$query) && is.function(self$query$to_raw)) {
        nested <- self$query$to_raw()
        if (is.raw(nested) && length(nested) > 0) writeBin(nested, conn)
      } else {
        if (is.character(self$query)) {
          writeBin(charToRaw(self$query), conn)
        } else {
          stop("query must be an object with to_raw(), a raw vector, or a character")
        }
      }
      rawConnectionValue(conn)
    }
  ),
  active = list(),
  class = TRUE
)

# Create an InvokeWithGooglePlayIntegrityRequest from a reader
# @name InvokeWithGooglePlayIntegrityRequest_from_reader
#
# The reader is expected to provide:
# - tgread_string(): returns a character string
# - tgread_object(): returns the nested query object (already parsed)
# @param reader Object with required methods
# @return InvokeWithGooglePlayIntegrityRequest instance
InvokeWithGooglePlayIntegrityRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$tgread_string) || !is.function(reader$tgread_object)) {
    stop("reader must implement tgread_string() and tgread_object()")
  }
  nonce_val <- reader$tgread_string()
  token_val <- reader$tgread_string()
  query_val <- reader$tgread_object()
  InvokeWithGooglePlayIntegrityRequest$new(nonce = nonce_val, token = token_val, query = query_val)
}


#  InvokeWithLayerRequest R6 class
# 
#  Represents the TL request `InvokeWithLayerRequest`.
# 
#  Fields:
#  - layer: integer (32-bit)
#  - query: TypeX (an object representing a TL query). May be an R6 TL object with to_raw()/to_list().
# 
#  Methods:
#  - new(layer, query): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
# 
#  @details
#  to_raw() writes the constructor id (0xda9b0d0d) in little-endian, then a 4-byte
#  integer for layer, then the nested query bytes. The nested query is expected to
#  provide a to_raw() method returning a raw vector, or to already be a raw vector.
#  If the query is a character, it will be converted using charToRaw().
#  @noRd
#  @noRd
InvokeWithLayerRequest <- R6::R6Class(
  classname = "InvokeWithLayerRequest",
  public = list(
    #  @field layer Field.
    layer = NULL,
    #  @field query Field.
    query = NULL,

    #  Initialize an InvokeWithLayerRequest
    #  @param layer integer 32-bit
    #  @param query TypeX object or raw vector representing the inner query
    initialize = function(layer, query) {
      if (missing(layer) || missing(query)) stop("layer and query are required")
      self$layer <- as.integer(layer)
      self$query <- query
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      query_out <- NULL
      if (!is.null(self$query)) {
        if (is.function(self$query$to_list)) {
          query_out <- self$query$to_list()
        } else {
          query_out <- self$query
        }
      }
      list(
        `_` = "InvokeWithLayerRequest",
        layer = self$layer,
        query = query_out
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    to_raw = function() {
      # CONSTRUCTOR_ID 0xda9b0d0d little endian bytes: b'\r\r\x9b\xda'
      constructor_bytes <- as.raw(c(0x0D, 0x0D, 0x9B, 0xDA))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # write 4-byte integer for layer
      writeBin(as.integer(self$layer), conn, size = 4, endian = "little")
      # write nested query bytes
      if (is.raw(self$query)) {
        if (length(self$query) > 0) writeBin(self$query, conn)
      } else if (!is.null(self$query) && is.function(self$query$to_bytes)) {
        nested <- self$query$to_bytes()
        if (is.raw(nested) && length(nested) > 0) writeBin(nested, conn)
      } else if (!is.null(self$query) && is.function(self$query$to_raw)) {
        nested <- self$query$to_raw()
        if (is.raw(nested) && length(nested) > 0) writeBin(nested, conn)
      } else if (!is.null(self$query) && is.function(self$query$bytes)) {
        nested <- self$query$bytes()
        if (is.raw(nested) && length(nested) > 0) writeBin(nested, conn)
      } else if (is.character(self$query)) {
        writeBin(serialize_bytes(self$query), conn)
      } else {
        stop("query must be TL object with to_bytes()/to_raw()/bytes(), raw, or character")
      }
      rawConnectionValue(conn)
    }
  ),
  active = list(),
  #  @field class Field.
  class = TRUE
)

# Create an InvokeWithLayerRequest from a reader
# @name InvokeWithLayerRequest_from_reader
#
# The reader is expected to provide:
# - read_int(): returns integer for 32-bit
# - tgread_object(): returns the nested query object (already parsed)
# @param reader Object with required methods
# @return InvokeWithLayerRequest instance
InvokeWithLayerRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$read_int) || !is.function(reader$tgread_object)) {
    stop("reader must implement read_int() and tgread_object()")
  }
  layer_val <- reader$read_int()
  query_val <- reader$tgread_object()
  InvokeWithLayerRequest$new(layer = layer_val, query = query_val)
}


#  InvokeWithMessagesRangeRequest R6 class
# 
#  Represents the TL request `InvokeWithMessagesRangeRequest`.
# 
#  Fields:
#  - range: TypeMessageRange (an object representing a message range). May be an R6 TL object with to_raw()/to_list().
#  - query: TypeX (an object representing a TL query). May be an R6 TL object with to_raw()/to_list().
# 
#  Methods:
#  - new(range, query): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
# 
#  @details
#  to_raw() writes the constructor id (0x365275f2) in little-endian, then the
#  serialized bytes for the range, then the serialized bytes for the nested query.
#  @noRd
#  @noRd
InvokeWithMessagesRangeRequest <- R6::R6Class(
  classname = "InvokeWithMessagesRangeRequest",
  public = list(
    #  @field range Field.
    range = NULL,
    #  @field query Field.
    query = NULL,

    #  Initialize an InvokeWithMessagesRangeRequest
    #  @param range TypeMessageRange object or raw vector representing the range
    #  @param query TypeX object or raw vector representing the inner query
    initialize = function(range, query) {
      if (missing(range) || missing(query)) stop("range and query are required")
      self$range <- range
      self$query <- query
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      range_out <- NULL
      if (!is.null(self$range)) {
        if (is.function(self$range$to_list)) {
          range_out <- self$range$to_list()
        } else {
          range_out <- self$range
        }
      }
      query_out <- NULL
      if (!is.null(self$query)) {
        if (is.function(self$query$to_list)) {
          query_out <- self$query$to_list()
        } else {
          query_out <- self$query
        }
      }
      list(
        `_` = "InvokeWithMessagesRangeRequest",
        range = range_out,
        query = query_out
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    to_raw = function() {
      # CONSTRUCTOR_ID 0x365275f2 little endian bytes: b'\xf2uR6'
      constructor_bytes <- as.raw(c(0xF2, 0x75, 0x52, 0x36))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # write range bytes
      if (is.raw(self$range)) {
        if (length(self$range) > 0) writeBin(self$range, conn)
      } else if (!is.null(self$range) && is.function(self$range$to_raw)) {
        nestedRange <- self$range$to_raw()
        if (is.raw(nestedRange) && length(nestedRange) > 0) writeBin(nestedRange, conn)
      } else {
        stop("range must be an object with to_raw() or a raw vector")
      }
      # write nested query bytes
      if (is.raw(self$query)) {
        if (length(self$query) > 0) writeBin(self$query, conn)
      } else if (!is.null(self$query) && is.function(self$query$to_raw)) {
        nestedQuery <- self$query$to_raw()
        if (is.raw(nestedQuery) && length(nestedQuery) > 0) writeBin(nestedQuery, conn)
      } else {
        if (is.character(self$query)) {
          writeBin(charToRaw(self$query), conn)
        } else {
          stop("query must be an object with to_raw(), a raw vector, or a character")
        }
      }
      rawConnectionValue(conn)
    }
  ),
  active = list(),
  #  @field class Field.
  class = TRUE
)

# Create an InvokeWithMessagesRangeRequest from a reader
# @name InvokeWithMessagesRangeRequest_from_reader
#
# The reader is expected to provide:
# - tgread_object(): returns the nested range object (already parsed)
# - tgread_object(): returns the nested query object (already parsed)
# @param reader Object with required methods
# @return InvokeWithMessagesRangeRequest instance
InvokeWithMessagesRangeRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$tgread_object)) {
    stop("reader must implement tgread_object()")
  }
  range_val <- reader$tgread_object()
  query_val <- reader$tgread_object()
  InvokeWithMessagesRangeRequest$new(range = range_val, query = query_val)
}


#  InvokeWithReCaptchaRequest R6 class
# 
#  Represents the TL request `InvokeWithReCaptchaRequest`.
# 
#  Fields:
#  - token: character string
#  - query: TypeX (an object representing a TL query). May be an R6 TL object with to_raw()/to_list().
# 
#  Methods:
#  - new(token, query): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
# 
#  @details
#  to_raw() expects the query to provide a to_raw() method returning a raw vector,
#  or to already be a raw vector. If neither is true and query is character, it will
#  be coerced with charToRaw().
#  @noRd
#  @noRd
InvokeWithReCaptchaRequest <- R6::R6Class(
  classname = "InvokeWithReCaptchaRequest",
  public = list(
    #  @field token Field.
    token = NULL,
    #  @field query Field.
    query = NULL,

    #  Initialize an InvokeWithReCaptchaRequest
    #  @param token character token
    #  @param query TypeX object or raw vector representing the inner query
    initialize = function(token, query) {
      if (missing(token) || missing(query)) stop("token and query are required")
      if (!is.character(token) || length(token) != 1) stop("token must be a single string")
      self$token <- token
      self$query <- query
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      query_out <- NULL
      if (!is.null(self$query)) {
        if (is.function(self$query$to_list)) {
          query_out <- self$query$to_list()
        } else {
          query_out <- self$query
        }
      }
      list(
        `_` = "InvokeWithReCaptchaRequest",
        token = self$token,
        query = query_out
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    to_raw = function() {
      # CONSTRUCTOR_ID 0xadbb0f94 little endian bytes: b'\x94\x0f\xbb\xad'
      constructor_bytes <- as.raw(c(0x94, 0x0F, 0xBB, 0xAD))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # write token as TL string (here: raw bytes of the string; for compact TL string encoding
      # a specialized encoder would be used, but we follow the simple pattern used elsewhere)
      writeBin(charToRaw(self$token), conn)
      # write nested query bytes: prefer query$to_raw(), else if raw, write directly
      if (is.raw(self$query)) {
        if (length(self$query) > 0) writeBin(self$query, conn)
      } else if (!is.null(self$query) && is.function(self$query$to_raw)) {
        nested <- self$query$to_raw()
        if (is.raw(nested) && length(nested) > 0) writeBin(nested, conn)
      } else {
        if (is.character(self$query)) {
          writeBin(charToRaw(self$query), conn)
        } else {
          stop("query must be an object with to_raw(), a raw vector, or a character")
        }
      }
      rawConnectionValue(conn)
    }
  ),
  active = list(),
  #  @field class Field.
  class = TRUE
)

# Create an InvokeWithReCaptchaRequest from a reader
# @name InvokeWithReCaptchaRequest_from_reader
#
# The reader is expected to provide:
# - tgread_string(): returns a character string
# - tgread_object(): returns the nested query object (already parsed)
# @param reader Object with required methods
# @return InvokeWithReCaptchaRequest instance
InvokeWithReCaptchaRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$tgread_string) || !is.function(reader$tgread_object)) {
    stop("reader must implement tgread_string() and tgread_object()")
  }
  token_val <- reader$tgread_string()
  query_val <- reader$tgread_object()
  InvokeWithReCaptchaRequest$new(token = token_val, query = query_val)
}


#  InvokeWithTakeoutRequest R6 class
# 
#  Represents the TL request `InvokeWithTakeoutRequest`.
# 
#  Fields:
#  - takeout_id: numeric/integer (64-bit placeholder)
#  - query: TypeX (an object representing a TL query). May be an R6 TL object with to_raw()/to_list().
# 
#  Methods:
#  - new(takeout_id, query): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
# 
#  @details
#  to_raw() writes takeout_id as an 8-byte little-endian value using writeBin(as.numeric(...), size=8).
#  For exact two's-complement 64-bit preservation, replace with a dedicated 64-bit serializer.
#  @noRd
#  @noRd
InvokeWithTakeoutRequest <- R6::R6Class(
  classname = "InvokeWithTakeoutRequest",
  public = list(
    #  @field takeout_id Field.
    takeout_id = NULL,
    #  @field query Field.
    query = NULL,

    #  Initialize an InvokeWithTakeoutRequest
    #  @param takeout_id numeric/integer 64-bit
    #  @param query TypeX object or raw vector representing the inner query
    initialize = function(takeout_id, query) {
      if (missing(takeout_id) || missing(query)) stop("takeout_id and query are required")
      self$takeout_id <- takeout_id
      self$query <- query
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      query_out <- NULL
      if (!is.null(self$query)) {
        if (is.function(self$query$to_list)) {
          query_out <- self$query$to_list()
        } else {
          query_out <- self$query
        }
      }
      list(
        `_` = "InvokeWithTakeoutRequest",
        takeout_id = self$takeout_id,
        query = query_out
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    to_raw = function() {
      # CONSTRUCTOR_ID 0xaca9fd2e little endian bytes: b'.\xfd\xa9\xac'
      constructor_bytes <- as.raw(c(0x2E, 0xFD, 0xA9, 0xAC))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # write takeout_id as 8-byte little-endian (placeholder via numeric)
      writeBin(as.numeric(self$takeout_id), conn, size = 8, endian = "little")
      # write nested query bytes: prefer query$to_raw(), else if raw, write directly
      if (is.raw(self$query)) {
        if (length(self$query) > 0) writeBin(self$query, conn)
      } else if (!is.null(self$query) && is.function(self$query$to_raw)) {
        nested <- self$query$to_raw()
        if (is.raw(nested) && length(nested) > 0) writeBin(nested, conn)
      } else {
        if (is.character(self$query)) {
          writeBin(charToRaw(self$query), conn)
        } else {
          stop("query must be an object with to_raw(), a raw vector, or a character")
        }
      }
      rawConnectionValue(conn)
    }
  ),
  active = list(),
  #  @field class Field.
  class = TRUE
)

# Create an InvokeWithTakeoutRequest from a reader
# @name InvokeWithTakeoutRequest_from_reader
#
# The reader is expected to provide:
# - read_long(): returns numeric/integer for 64-bit
# - tgread_object(): returns nested query object
# @param reader Object with required methods
# @return InvokeWithTakeoutRequest instance
InvokeWithTakeoutRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$read_long) || !is.function(reader$tgread_object)) {
    stop("reader must implement read_long() and tgread_object()")
  }
  takeout_id_val <- reader$read_long()
  query_val <- reader$tgread_object()
  InvokeWithTakeoutRequest$new(takeout_id = takeout_id_val, query = query_val)
}


#  InvokeWithoutUpdatesRequest R6 class
# 
#  Represents the TL request `InvokeWithoutUpdatesRequest`.
# 
#  Fields:
#  - query: TypeX (an object representing a TL query). May be an R6 TL object with to_raw()/to_list().
# 
#  Methods:
#  - new(query): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
# 
#  Note: to_raw() expects the query to provide a to_raw() method returning a raw vector,
#  or to already be a raw vector. If neither is true, the query is written via as.raw
#  of its serialized form where appropriate.
#  @noRd
#  @noRd
InvokeWithoutUpdatesRequest <- R6::R6Class(
  classname = "InvokeWithoutUpdatesRequest",
  public = list(
    #  @field query Field.
    query = NULL,

    #  Initialize an InvokeWithoutUpdatesRequest
    #  @param query TypeX object or raw vector representing the inner query
    initialize = function(query) {
      if (missing(query)) stop("query is required")
      self$query <- query
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      query_out <- NULL
      if (!is.null(self$query)) {
        if (is.function(self$query$to_list)) {
          query_out <- self$query$to_list()
        } else {
          query_out <- self$query
        }
      }
      list(
        `_` = "InvokeWithoutUpdatesRequest",
        query = query_out
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    to_raw = function() {
      # CONSTRUCTOR_ID 0xbf9459b7 little endian bytes: b'\xb7Y\x94\xbf'
      constructor_bytes <- as.raw(c(0xB7, 0x59, 0x94, 0xBF))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # write nested query bytes
      if (is.raw(self$query)) {
        if (length(self$query) > 0) writeBin(self$query, conn)
      } else if (!is.null(self$query) && is.function(self$query$to_bytes)) {
        nested <- self$query$to_bytes()
        if (is.raw(nested) && length(nested) > 0) writeBin(nested, conn)
      } else if (!is.null(self$query) && is.function(self$query$to_raw)) {
        nested <- self$query$to_raw()
        if (is.raw(nested) && length(nested) > 0) writeBin(nested, conn)
      } else if (!is.null(self$query) && is.function(self$query$bytes)) {
        nested <- self$query$bytes()
        if (is.raw(nested) && length(nested) > 0) writeBin(nested, conn)
      } else if (is.character(self$query)) {
        writeBin(serialize_bytes(self$query), conn)
      } else {
        stop("query must be TL object with to_bytes()/to_raw()/bytes(), raw, or character")
      }
      rawConnectionValue(conn)
    }
  ),
  active = list(),
  #  @field class Field.
  class = TRUE
)

# Create an InvokeWithoutUpdatesRequest from a reader
# @name InvokeWithoutUpdatesRequest_from_reader
#
# The reader is expected to provide:
# - tgread_object(): returns the nested query object (already parsed)
# @param reader Object with required method
# @return InvokeWithoutUpdatesRequest instance
InvokeWithoutUpdatesRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$tgread_object)) {
    stop("reader must implement tgread_object()")
  }
  query_val <- reader$tgread_object()
  InvokeWithoutUpdatesRequest$new(query = query_val)
}


#  PingRequest R6 class
# 
#  Represents the TL request `PingRequest`.
# 
#  Fields:
#  - ping_id: numeric/integer (64-bit placeholder)
# 
#  Methods:
#  - new(ping_id): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
#  - from_reader(reader): construct instance from a reader with read_long().
# 
#  Note: 64-bit integer handling uses numeric placeholders via writeBin.
#  @noRd
#  @noRd
PingRequest <- R6::R6Class(
  classname = "PingRequest",
  public = list(
    #  @field ping_id Field.
    ping_id = NULL,

    #  Initialize a PingRequest
    #  @param ping_id numeric/integer 64-bit
    initialize = function(ping_id) {
      if (missing(ping_id)) stop("ping_id is required")
      self$ping_id <- ping_id
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      list(
        `_` = "PingRequest",
        ping_id = self$ping_id
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    to_raw = function() {
      # CONSTRUCTOR_ID 0x7abe77ec little endian bytes: b'\xecw\xbez'
      constructor_bytes <- as.raw(c(0xEC, 0x77, 0xBE, 0x7A))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # NOTE: writeBin on numeric with size=8 uses IEEE754 double; if you need exact
      # two's-complement 64-bit integer, replace this with a proper 64-bit writer.
      writeBin(as.numeric(self$ping_id), conn, size = 8, endian = "little")
      rawConnectionValue(conn)
    }
  ),
  active = list(),
  #  @field class Field.
  class = TRUE
)

# Create a PingRequest from a reader
# @name PingRequest_from_reader
#
# The reader is expected to provide `read_long()` that returns a numeric/integer value.
# @param reader Object with a read_long() method
# @return PingRequest instance
PingRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$read_long)) {
    stop("reader must implement read_long()")
  }
  ping_id_val <- reader$read_long()
  PingRequest$new(ping_id = ping_id_val)
}


#  PingDelayDisconnectRequest R6 class
# 
#  Represents the TL request `PingDelayDisconnectRequest`.
# 
#  Fields:
#  - ping_id: numeric/integer (64-bit placeholder)
#  - disconnect_delay: integer (32-bit)
# 
#  Methods:
#  - new(ping_id, disconnect_delay): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
# 
#  Note: 64-bit integer handling uses numeric placeholders via writeBin.
#  @noRd
#  @noRd
PingDelayDisconnectRequest <- R6::R6Class(
  classname = "PingDelayDisconnectRequest",
  public = list(
    #  @field ping_id Field.
    ping_id = NULL,
    #  @field disconnect_delay Field.
    disconnect_delay = NULL,

    #  Initialize a PingDelayDisconnectRequest
    #  @param ping_id numeric/integer 64-bit
    #  @param disconnect_delay integer 32-bit
    initialize = function(ping_id, disconnect_delay) {
      if (missing(ping_id) || missing(disconnect_delay)) {
        stop("ping_id and disconnect_delay are required")
      }
      self$ping_id <- ping_id
      self$disconnect_delay <- disconnect_delay
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      list(
        `_` = "PingDelayDisconnectRequest",
        ping_id = self$ping_id,
        disconnect_delay = self$disconnect_delay
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    to_raw = function() {
      # CONSTRUCTOR_ID 0xf3427b8c little endian bytes: b'\x8c{B\xf3'
      constructor_bytes <- as.raw(c(0x8C, 0x7B, 0x42, 0xF3))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # NOTE: writeBin on numeric with size=8 uses IEEE754 double; if you need exact
      # two's-complement 64-bit integer, replace this with a proper 64-bit writer.
      writeBin(as.numeric(self$ping_id), conn, size = 8, endian = "little")
      # write 4-byte integer for disconnect_delay
      writeBin(as.integer(self$disconnect_delay), conn, size = 4, endian = "little")
      rawConnectionValue(conn)
    }
  ),
  active = list(),
  #  @field class Field.
  class = TRUE
)

# Create a PingDelayDisconnectRequest from a reader
# @name PingDelayDisconnectRequest_from_reader
#
# The reader is expected to provide:
# - read_long(): returns numeric/integer for 64-bit
# - read_int(): returns integer for 32-bit
# @param reader Object with required methods
# @return PingDelayDisconnectRequest instance
PingDelayDisconnectRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$read_long) || !is.function(reader$read_int)) {
    stop("reader must implement read_long() and read_int()")
  }
  ping_id_val <- reader$read_long()
  disconnect_delay_val <- reader$read_int()
  PingDelayDisconnectRequest$new(ping_id = ping_id_val, disconnect_delay = disconnect_delay_val)
}


#  ReqDHParamsRequest R6 class
# 
#  Represents the TL request `ReqDHParamsRequest`.
# 
#  Fields:
#  - nonce: numeric/integer 128-bit nonce (placeholder representation)
#  - server_nonce: numeric/integer 128-bit server nonce (placeholder)
#  - p: raw, bytes
#  - q: raw, bytes
#  - public_key_fingerprint: numeric/integer 64-bit
#  - encrypted_data: raw, bytes
# 
#  Methods:
#  - new(nonce, server_nonce, p, q, public_key_fingerprint, encrypted_data): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
# 
#  Note: 128-bit integer handling is represented as numeric/double placeholders.
#  For precise 128-bit two's-complement behavior, use a big-integer library and
#  implement a precise serializer.
#  @noRd
#  @noRd
ReqDHParamsRequest <- R6::R6Class(
  classname = "ReqDHParamsRequest",
  public = list(
    #  @field nonce Field.
    nonce = NULL,
    #  @field server_nonce Field.
    server_nonce = NULL,
    #  @field p Field.
    p = NULL,
    #  @field q Field.
    q = NULL,
    #  @field public_key_fingerprint Field.
    public_key_fingerprint = NULL,
    #  @field encrypted_data Field.
    encrypted_data = NULL,

    #  Initialize a ReqDHParamsRequest
    #  @param nonce numeric/integer 128-bit nonce (placeholder)
    #  @param server_nonce numeric/integer 128-bit server nonce (placeholder)
    #  @param p raw or character convertible to raw
    #  @param q raw or character convertible to raw
    #  @param public_key_fingerprint numeric/integer 64-bit
    #  @param encrypted_data raw or character convertible to raw
    initialize = function(nonce, server_nonce, p, q, public_key_fingerprint, encrypted_data) {
      if (missing(nonce) || missing(server_nonce) || missing(p) || missing(q) ||
        missing(public_key_fingerprint) || missing(encrypted_data)) {
        stop("nonce, server_nonce, p, q, public_key_fingerprint and encrypted_data are required")
      }
      self$nonce <- nonce
      self$server_nonce <- server_nonce

      # normalize byte fields to raw
      to_raw_field <- function(x) {
        if (is.raw(x)) {
          return(x)
        }
        if (is.character(x)) {
          return(charToRaw(x))
        }
        stop("byte fields must be raw or character convertible to raw")
      }
      self$p <- to_raw_field(p)
      self$q <- to_raw_field(q)
      self$public_key_fingerprint <- public_key_fingerprint
      self$encrypted_data <- to_raw_field(encrypted_data)
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      list(
        `_` = "ReqDHParamsRequest",
        nonce = self$nonce,
        server_nonce = self$server_nonce,
        p = self$p,
        q = self$q,
        public_key_fingerprint = self$public_key_fingerprint,
        encrypted_data = self$encrypted_data
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    to_raw = function() {
      # CONSTRUCTOR_ID 0xd712e4be little endian bytes: b'\xbe\xe4\x12\xd7'
      constructor_bytes <- as.raw(c(0xBE, 0xE4, 0x12, 0xD7))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # NOTE: 128-bit values are written as 16-byte little-endian blocks.
      # Here we write nonce and server_nonce as numeric placeholders with size = 16.
      # For correct 128-bit integer handling, replace with a proper big-int serializer.
      writeBin(as.numeric(self$nonce), conn, size = 16, endian = "little")
      writeBin(as.numeric(self$server_nonce), conn, size = 16, endian = "little")

      # helper to write TL-style bytes (4-byte length + data + padding to 4)
      write_tl_bytes <- function(payload) {
        payload_len <- length(payload)
        writeBin(as.integer(payload_len), conn, size = 4, endian = "little")
        if (payload_len > 0) writeBin(payload, conn)
        pad_len <- (4 - (payload_len %% 4)) %% 4
        if (pad_len > 0) writeBin(as.raw(rep(0x00, pad_len)), conn)
      }

      write_tl_bytes(self$p)
      write_tl_bytes(self$q)
      # public_key_fingerprint as 8-byte little endian
      writeBin(as.numeric(self$public_key_fingerprint), conn, size = 8, endian = "little")
      write_tl_bytes(self$encrypted_data)

      rawConnectionValue(conn)
    }
  ),
  active = list()
)

# Create a ReqDHParamsRequest from a reader
# @name ReqDHParamsRequest_from_reader
#
# The reader is expected to provide:
# - read_large_int(bits = 128): returns numeric/placeholder for 128-bit integer
# - tgread_bytes(): returns raw vector of bytes
# - read_long(): returns numeric/integer for 64-bit
# @param reader Object with required methods
# @return ReqDHParamsRequest instance
ReqDHParamsRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$read_large_int) ||
    !is.function(reader$tgread_bytes) || !is.function(reader$read_long)) {
    stop("reader must implement read_large_int(bits = 128), tgread_bytes() and read_long()")
  }
  nonce_val <- reader$read_large_int(bits = 128)
  server_nonce_val <- reader$read_large_int(bits = 128)
  p_val <- reader$tgread_bytes()
  q_val <- reader$tgread_bytes()
  public_key_fingerprint_val <- reader$read_long()
  encrypted_data_val <- reader$tgread_bytes()
  ReqDHParamsRequest$new(
    nonce = nonce_val,
    server_nonce = server_nonce_val,
    p = p_val,
    q = q_val,
    public_key_fingerprint = public_key_fingerprint_val,
    encrypted_data = encrypted_data_val
  )
}


#  ReqPqRequest R6 class
# 
#  Represents the TL request `ReqPqRequest`.
# 
# 
#  @description
#  Methods:
#  - new(nonce): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
# 
#  Note: 128-bit integer handling is represented here as numeric/double placeholders.
#  For precise 128-bit two's-complement behavior, use a big-integer library and
#  implement a precise serializer.
#  @noRd
#  @noRd
ReqPqRequest <- R6::R6Class(
  classname = "ReqPqRequest",
  public = list(
    #  @field nonce Field.
    nonce = NULL,

    #  Initialize a ReqPqRequest
    #  @param nonce numeric/integer 128-bit nonce
    initialize = function(nonce) {
      if (missing(nonce)) stop("nonce is required")
      self$nonce <- nonce
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      list(
        `_` = "ReqPqRequest",
        nonce = self$nonce
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    to_raw = function() {
      # CONSTRUCTOR_ID 0x60469778 little endian bytes: b'x\x97F`'
      constructor_bytes <- as.raw(c(0x78, 0x97, 0x46, 0x60))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # NOTE: 128-bit value is written as a 16-byte little-endian block.
      # Here we use writeBin on numeric with size = 16 as a placeholder.
      # For correct 128-bit integer handling, replace with proper big-int serializer.
      writeBin(as.numeric(self$nonce), conn, size = 16, endian = "little")
      rawConnectionValue(conn)
    }
  ),
  active = list(),
  #  @field class Field.
  class = TRUE
)

# Create a ReqPqRequest from a reader
# @name ReqPqRequest_from_reader
#
# The reader is expected to provide `read_large_int(bits = 128)`.
# @param reader Object with a read_large_int(bits = 128) method
# @return ReqPqRequest instance
ReqPqRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$read_large_int)) {
    stop("reader must implement read_large_int(bits = 128)")
  }
  nonce_val <- reader$read_large_int(bits = 128)
  ReqPqRequest$new(nonce = nonce_val)
}


#  ReqPqMultiRequest R6 class
# 
#  Represents the TL request `ReqPqMultiRequest`.
# 
# 
#  @description
#  Methods:
#  - new(nonce): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
# 
#  Note: 128-bit integer handling is represented here as numeric/double placeholders.
#  For precise 128-bit two's-complement behavior, use a big-integer library and
#  implement a precise serializer.
#  @noRd
#  @noRd
ReqPqMultiRequest <- R6::R6Class(
  classname = "ReqPqMultiRequest",
  public = list(
    #  @field nonce Field.
    nonce = NULL,

    #  Initialize a ReqPqMultiRequest
    #  @param nonce numeric/integer 128-bit nonce
    initialize = function(nonce) {
      if (missing(nonce)) stop("nonce is required")
      self$nonce <- nonce
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      list(
        `_` = "ReqPqMultiRequest",
        nonce = self$nonce
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    to_raw = function() {
      # CONSTRUCTOR_ID 0xbe7e8ef1 little endian bytes: b'\xf1\x8e~\xbe'
      constructor_bytes <- as.raw(c(0xF1, 0x8E, 0x7E, 0xBE))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # NOTE: 128-bit value is written as a 16-byte little-endian block.
      # Here we use writeBin on numeric with size = 16 as a placeholder.
      # For correct 128-bit integer handling, replace with proper big-int serializer.
      writeBin(as.numeric(self$nonce), conn, size = 16, endian = "little")
      rawConnectionValue(conn)
    }
  ),
  active = list(),
  #  @field class Field.
  class = TRUE
)

# Create a ReqPqMultiRequest from a reader
# @name ReqPqMultiRequest_from_reader
#
# The reader is expected to provide `read_large_int(bits = 128)`.
# @param reader Object with a read_large_int(bits = 128) method
# @return ReqPqMultiRequest instance
ReqPqMultiRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$read_large_int)) {
    stop("reader must implement read_large_int(bits = 128)")
  }
  nonce_val <- reader$read_large_int(bits = 128)
  ReqPqMultiRequest$new(nonce = nonce_val)
}


#  RpcDropAnswerRequest R6 class
# 
#  Represents the TL request `RpcDropAnswerRequest`.
# 
# 
#  @description
#  Methods:
#  - new(req_msg_id): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
#  - from_reader(reader): class method, construct instance from a `reader` object
#    that exposes `read_long()` (returns numeric/integer) and similar methods.
# 
#  Note: to_raw() uses writeBin on numeric for 8-byte values. If exact 64-bit
#  two's-complement preservation is required, replace with a dedicated 64-bit
#  integer serialization utility.
# 
#  @noRd
#  @noRd
RpcDropAnswerRequest <- R6::R6Class(
  classname = "RpcDropAnswerRequest",
  public = list(
    #  @field req_msg_id Field.
    req_msg_id = NULL,

    #  Initialize a RpcDropAnswerRequest
    #  @param req_msg_id numeric/integer Request message id (64-bit)
    initialize = function(req_msg_id) {
      if (missing(req_msg_id)) stop("req_msg_id is required")
      self$req_msg_id <- req_msg_id
    },

    #  Convert object to a simple list (dictionary-like)
    #  @return list with fields
    to_list = function() {
      list(
        `_` = "RpcDropAnswerRequest",
        req_msg_id = self$req_msg_id
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    to_raw = function() {
      # CONSTRUCTOR_ID 0x58e4a740 little endian bytes: b'@\xa7\xe4X'
      constructor_bytes <- as.raw(c(0x40, 0xA7, 0xE4, 0x58))
      # write 8-byte (signed) little-endian - using writeBin on numeric (8 bytes)
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # NOTE: writeBin on numeric with size=8 uses IEEE754 double; if you need exact
      # two's-complement 64-bit integer, replace this with a proper 64-bit writer.
      writeBin(as.numeric(self$req_msg_id), conn, size = 8, endian = "little")
      rawConnectionValue(conn)
    }
  ),
  active = list(
    # no active bindings
  ),
  #  @field class Field.
  class = TRUE
)

# Create a RpcDropAnswerRequest from a reader
# @name RpcDropAnswerRequest_from_reader
#
# The reader is expected to provide `read_long()` that returns a numeric/integer value.
# @param reader Object with a read_long() method
# @return RpcDropAnswerRequest instance
RpcDropAnswerRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$read_long)) {
    stop("reader must implement read_long()")
  }
  req_msg_id <- reader$read_long()
  RpcDropAnswerRequest$new(req_msg_id = req_msg_id)
}


#  SetClientDHParamsRequest R6 class
# 
#  Represents the TL request `SetClientDHParamsRequest`.
# 
# 
#  @description
#  Methods:
#  - new(nonce, server_nonce, encrypted_data): create new instance.
#  - to_list(): return an R list representation.
#  - to_raw(): serialize to raw vector (bytes) in little endian as used in TL.
#  - from_reader(reader): class method, construct instance from a `reader` object
#    that exposes `read_large_int(bits = 128)` and `tgread_bytes()`.
# 
#  Note: 128-bit integer handling is represented here as numeric/double placeholders.
#  For precise 128-bit two's-complement behavior, use a big-integer library and
#  implement a precise serializer.
# 
#  @noRd
#  @noRd
SetClientDHParamsRequest <- R6::R6Class(
  classname = "SetClientDHParamsRequest",
  public = list(
    #  @field nonce Field.
    nonce = NULL,
    #  @field server_nonce Field.
    server_nonce = NULL,
    #  @field encrypted_data Field.
    encrypted_data = NULL,

    #  Initialize a SetClientDHParamsRequest
    #  @param nonce numeric/integer 128-bit nonce
    #  @param server_nonce numeric/integer 128-bit server nonce
    #  @param encrypted_data raw or raw-like encrypted payload
    initialize = function(nonce, server_nonce, encrypted_data) {
      if (missing(nonce) || missing(server_nonce) || missing(encrypted_data)) {
        stop("nonce, server_nonce and encrypted_data are required")
      }
      self$nonce <- nonce
      self$server_nonce <- server_nonce
      if (!is.raw(encrypted_data)) {
        # allow character or raw; convert character to raw via charToRaw
        if (is.character(encrypted_data)) {
          encrypted_data <- charToRaw(encrypted_data)
        } else {
          stop("encrypted_data must be raw or character convertible to raw")
        }
      }
      self$encrypted_data <- encrypted_data
    },

    #  Convert to list
    #  @return list representation
    to_list = function() {
      list(
        `_` = "SetClientDHParamsRequest",
        nonce = self$nonce,
        server_nonce = self$server_nonce,
        encrypted_data = self$encrypted_data
      )
    },

    #  Serialize to raw (bytes)
    #  @return raw vector
    to_raw = function() {
      # CONSTRUCTOR_ID 0xf5045f1f little endian bytes: b'\x1f_\x04\xf5'
      constructor_bytes <- as.raw(c(0x1F, 0x5F, 0x04, 0xF5))
      conn <- rawConnection(raw(), "wb")
      on.exit(close(conn))
      writeBin(constructor_bytes, conn)
      # NOTE: 128-bit values are written as two 8-byte little-endian blocks.
      # Here we write nonce and server_nonce as two 8-byte doubles each (placeholder).
      # For correct 128-bit integer handling, replace with proper big-int serializer.
      writeBin(as.numeric(self$nonce), conn, size = 16, endian = "little")
      writeBin(as.numeric(self$server_nonce), conn, size = 16, endian = "little")
      # write serialized TLBytes for encrypted_data (length-prefixed). TL uses
      # a compact length scheme; here we serialize as: 4-byte length (little endian)
      # followed by raw payload and padding to 4-bytes as a simple compatible scheme.
      payload <- self$encrypted_data
      payload_len <- length(payload)
      # write length as 4-byte little-endian integer
      writeBin(as.integer(payload_len), conn, size = 4, endian = "little")
      if (payload_len > 0) writeBin(payload, conn)
      # pad to multiple of 4
      pad_len <- (4 - (payload_len %% 4)) %% 4
      if (pad_len > 0) writeBin(as.raw(rep(0x00, pad_len)), conn)
      rawConnectionValue(conn)
    }
  ),
  active = list()
)

# Create a SetClientDHParamsRequest from a reader
# @name SetClientDHParamsRequest_from_reader
#
# The reader is expected to provide:
# - read_large_int(bits = 128): returns numeric/placeholder for 128-bit integer
# - tgread_bytes(): returns raw vector of bytes
# @param reader Object with required methods
# @return SetClientDHParamsRequest instance
SetClientDHParamsRequest$from_reader <- function(reader) {
  if (is.null(reader) || !is.function(reader$read_large_int) || !is.function(reader$tgread_bytes)) {
    stop("reader must implement read_large_int(bits = 128) and tgread_bytes()")
  }
  nonce <- reader$read_large_int(bits = 128)
  server_nonce <- reader$read_large_int(bits = 128)
  encrypted_data <- reader$tgread_bytes()
  SetClientDHParamsRequest$new(nonce = nonce, server_nonce = server_nonce, encrypted_data = encrypted_data)
}
