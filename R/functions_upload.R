#  GetCdnFileRequest R6 class

#  Internal helper to pack 64-bit integers in little-endian.
#  Uses numeric arithmetic (good for offsets/file sizes within 2^53).
.pack_int64_le_safe <- function(x) {
  if (inherits(x, "bigz")) {
    x <- as.numeric(x)
  }
  if (length(x) != 1 || is.na(x)) {
    x <- 0
  }
  if (x < 0) {
    x <- x + 2^64
  }
  low <- as.integer(x %% 2^32)
  high <- as.integer(floor(x / 2^32))
  con <- rawConnection(raw(), "wb")
  on.exit(close(con))
  writeBin(low, con, size = 4L, endian = "little")
  writeBin(high, con, size = 4L, endian = "little")
  rawConnectionValue(con)
}
# 
#  Represents the TL request upload.GetCdnFileRequest.
#  @title GetCdnFileRequest
#  @description Telegram API type GetCdnFileRequest
#  @export
#  @noRd
#  @noRd
GetCdnFileRequest <- R6::R6Class(
  "GetCdnFileRequest",
  public = list(
    #  @field file_token Field.
    file_token = NULL,
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,

    #  @description Initialize a GetCdnFileRequest
    #  @param file_token raw|integer|character
    #  @param offset numeric (64-bit)
    #  @param limit integer
    initialize = function(file_token, offset, limit) {
      self$file_token <- file_token
      self$offset <- offset
      self$limit <- as.integer(limit)
      invisible(self)
    },

    #  @description Convert to list (dictionary-like)
    #  @return list
    to_list = function() {
      list(
        `_` = "GetCdnFileRequest",
        file_token = self$file_token,
        offset = self$offset,
        limit = self$limit
      )
    },

    #  @description Serialize to raw vector
    #  @return raw
    to_bytes = function() {
      c(
        private$constructor_id,
        private$serialize_bytes(self$file_token),
        private$pack_int64_le(self$offset),
        private$pack_int32_le(self$limit)
      )
    },

    #  @description Read GetCdnFileRequest from a reader
    #  @param reader an object providing tgread_bytes(), read_long(), read_int()
    #  @return GetCdnFileRequest
    from_reader = function(reader) {
      file_token_val <- reader$tgread_bytes()
      offset_val <- reader$read_long()
      limit_val <- reader$read_int()
      GetCdnFileRequest$new(file_token = file_token_val, offset = offset_val, limit = limit_val)
    }
  ),
  private = list(
    constructor_id = as.raw(c(0xda, 0x69, 0x5f, 0x39)),
    pack_int32_le = function(x) { int_to_raw_le(x, 4L) },
    pack_int64_le = .pack_int64_le_safe,
    serialize_bytes = function(b) {
      if (is.raw(b)) {
        b_raw <- b
      } else if (is.character(b)) {
        b_raw <- charToRaw(b)
      } else if (is.numeric(b) || is.integer(b)) {
        b_raw <- as.raw(as.integer(b) %% 256)
      } else {
        stop("file_token must be raw, integer or character")
      }

      len <- length(b_raw)
      con <- rawConnection(raw(), "wb")
      on.exit(close(con))
      writeBin(as.integer(len), con, size = 4L, endian = "little")
      if (len > 0) writeBin(b_raw, con, size = 1L)
      pad <- (4 - (len %% 4)) %% 4
      if (pad > 0) writeBin(rep(as.raw(0x00), pad), con, size = 1L)
      rawConnectionValue(con)
    }
  )
)


#  GetCdnFileHashesRequest R6 class
# 
#  Represents the TL request upload.GetCdnFileHashesRequest.
#  @title GetCdnFileHashesRequest
#  @description Telegram API type GetCdnFileHashesRequest
#  @export
#  @noRd
#  @noRd
GetCdnFileHashesRequest <- R6::R6Class(
  "GetCdnFileHashesRequest",
  public = list(
    #  @field file_token Field.
    file_token = NULL,
    #  @field offset Field.
    offset = NULL,

    #  @description Initialize a GetCdnFileHashesRequest
    #  @param file_token raw|integer|character
    #  @param offset numeric (64-bit)
    initialize = function(file_token, offset) {
      self$file_token <- file_token
      self$offset <- offset
      invisible(self)
    },

    #  @description Convert to list (dictionary-like)
    #  @return list
    to_list = function() {
      list(
        `_` = "GetCdnFileHashesRequest",
        file_token = self$file_token,
        offset = self$offset
      )
    },

    #  @description Serialize to raw vector
    #  @return raw
    to_bytes = function() {
      c(
        private$constructor_id,
        private$serialize_bytes(self$file_token),
        private$pack_int64_le(self$offset)
      )
    },

    #  @description Read GetCdnFileHashesRequest from a reader
    #  @param reader an object providing tgread_bytes() and read_long()
    #  @return GetCdnFileHashesRequest
    from_reader = function(reader) {
      file_token_val <- reader$tgread_bytes()
      offset_val <- reader$read_long()
      GetCdnFileHashesRequest$new(file_token = file_token_val, offset = offset_val)
    }
  ),
  private = list(
    constructor_id = as.raw(c(0x31, 0x3f, 0xdc, 0x91)),
    pack_int64_le = .pack_int64_le_safe,
    serialize_bytes = function(b) {
      if (is.raw(b)) {
        b_raw <- b
      } else if (is.character(b)) {
        b_raw <- charToRaw(b)
      } else if (is.numeric(b) || is.integer(b)) {
        b_raw <- as.raw(as.integer(b) %% 256)
      } else {
        stop("file_token must be raw, integer or character")
      }

      len <- length(b_raw)
      con <- rawConnection(raw(), "wb")
      on.exit(close(con))
      writeBin(as.integer(len), con, size = 4L, endian = "little")
      if (len > 0) writeBin(b_raw, con, size = 1L)
      pad <- (4 - (len %% 4)) %% 4
      if (pad > 0) writeBin(rep(as.raw(0x00), pad), con, size = 1L)
      rawConnectionValue(con)
    }
  )
)


#  GetFileRequest R6 class
# 
#  Represents the TL request upload.GetFileRequest.
#  @title GetFileRequest
#  @description Telegram API type GetFileRequest
#  @export
#  @noRd
#  @noRd
GetFileRequest <- R6::R6Class(
  "GetFileRequest",
  public = list(
    #  @field location Field.
    location = NULL,
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field precise Field.
    precise = NULL,
    #  @field cdn_supported Field.
    cdn_supported = NULL,

    #  @description Initialize a GetFileRequest
    #  @param location TLObject-like
    #  @param offset numeric (64-bit)
    #  @param limit integer
    #  @param precise logical or NULL
    #  @param cdn_supported logical or NULL
    initialize = function(location, offset, limit, precise = NULL, cdn_supported = NULL) {
      self$location <- location
      self$offset <- offset
      self$limit <- as.integer(limit)
      self$precise <- if (is.null(precise)) NULL else as.logical(precise)
      self$cdn_supported <- if (is.null(cdn_supported)) NULL else as.logical(cdn_supported)
      invisible(self)
    },

    #  @description Convert to list (dictionary-like)
    #  @return list
    to_list = function() {
      list(
        `_` = "GetFileRequest",
        location = if (inherits(self$location, "R6")) self$location$to_list() else self$location,
        offset = self$offset,
        limit = self$limit,
        precise = self$precise,
        cdn_supported = self$cdn_supported
      )
    },

    #  @description Serialize to raw vector
    #  @return raw
    to_bytes = function() {
      flags <- 0L
      if (!is.null(self$precise) && isTRUE(self$precise)) flags <- bitwOr(flags, 1L)
      if (!is.null(self$cdn_supported) && isTRUE(self$cdn_supported)) flags <- bitwOr(flags, 2L)

      c(
        private$constructor_id,
        private$pack_int32_le(flags),
        if (inherits(self$location, "R6")) {
          if (is.function(self$location$to_bytes)) {
            self$location$to_bytes()
          } else if (is.function(self$location$bytes)) {
            self$location$bytes()
          } else {
            stop("location must be an R6 TLObject-like with to_bytes() or bytes()")
          }
        } else {
          stop("location must be an R6 TLObject-like with to_bytes() or bytes()")
        },
        private$pack_int64_le(self$offset),
        private$pack_int32_le(self$limit)
      )
    },

    #  @description Read GetFileRequest from a reader
    #  @param reader an object providing read_int(), tgread_object(), read_long(), read_int()
    #  @return GetFileRequest
    from_reader = function(reader) {
      flags_val <- reader$read_int()
      precise_val <- bitwAnd(flags_val, 1L) != 0L
      cdn_supported_val <- bitwAnd(flags_val, 2L) != 0L
      location_val <- reader$tgread_object()
      offset_val <- reader$read_long()
      limit_val <- reader$read_int()
      GetFileRequest$new(location = location_val, offset = offset_val, limit = limit_val, precise = precise_val, cdn_supported = cdn_supported_val)
    }
  ),
  private = list(
    constructor_id = as.raw(c(0xbe, 0x35, 0x53, 0xbe)),
    pack_int32_le = function(x) { int_to_raw_le(x, 4L) },
    pack_int64_le = .pack_int64_le_safe
  )
)


#  GetFileHashesRequest R6 class
# 
#  Represents the TL request upload.GetFileHashesRequest.
#  @title GetFileHashesRequest
#  @description Telegram API type GetFileHashesRequest
#  @export
#  @noRd
#  @noRd
GetFileHashesRequest <- R6::R6Class(
  "GetFileHashesRequest",
  public = list(
    #  @field location Field.
    location = NULL,
    #  @field offset Field.
    offset = NULL,

    #  @description Initialize a GetFileHashesRequest
    #  @param location TLObject-like
    #  @param offset numeric (64-bit)
    initialize = function(location, offset) {
      self$location <- location
      self$offset <- offset
      invisible(self)
    },

    #  @description Convert to list (dictionary-like)
    #  @return list
    to_list = function() {
      list(
        `_` = "GetFileHashesRequest",
        location = if (inherits(self$location, "R6")) self$location$to_list() else self$location,
        offset = self$offset
      )
    },

    #  @description Serialize to raw vector
    #  @return raw
    to_bytes = function() {
      c(
        private$constructor_id,
        if (inherits(self$location, "R6")) {
          if (is.function(self$location$to_bytes)) {
            self$location$to_bytes()
          } else if (is.function(self$location$bytes)) {
            self$location$bytes()
          } else {
            stop("location must be an R6 TLObject-like with to_bytes() or bytes()")
          }
        } else {
          stop("location must be an R6 TLObject-like with to_bytes() or bytes()")
        },
        private$pack_int64_le(self$offset)
      )
    },

    #  @description Read GetFileHashesRequest from a reader
    #  @param reader an object providing read_long() and tgread_object()
    #  @return GetFileHashesRequest
    from_reader = function(reader) {
      location_val <- reader$tgread_object()
      offset_val <- reader$read_long()
      GetFileHashesRequest$new(location = location_val, offset = offset_val)
    }
  ),
  private = list(
    constructor_id = as.raw(c(0x2a, 0x98, 0x56, 0x91)),
    pack_int32_le = function(x) { int_to_raw_le(x, 4L) },
    pack_int64_le = .pack_int64_le_safe,
    serialize_bytes = function(b) {
      if (is.raw(b)) {
        b_raw <- b
      } else if (is.character(b)) {
        b_raw <- charToRaw(b)
      } else if (is.numeric(b) || is.integer(b)) {
        b_raw <- as.raw(as.integer(b) %% 256)
      } else {
        stop("bytes must be raw, integer or character")
      }

      len <- length(b_raw)
      con <- rawConnection(raw(), "wb")
      on.exit(close(con))
      writeBin(as.integer(len), con, size = 4L, endian = "little")
      if (len > 0) writeBin(b_raw, con, size = 1L)
      pad <- (4 - (len %% 4)) %% 4
      if (pad > 0) writeBin(rep(as.raw(0x00), pad), con, size = 1L)
      rawConnectionValue(con)
    }
  )
)


#  GetWebFileRequest R6 class
# 
#  Represents the TL request upload.GetWebFileRequest.
#  @title GetWebFileRequest
#  @description Telegram API type GetWebFileRequest
#  @export
#  @noRd
#  @noRd
GetWebFileRequest <- R6::R6Class(
  "GetWebFileRequest",
  public = list(
    #  @field location Field.
    location = NULL,
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,

    #  @description Initialize a GetWebFileRequest
    #  @param location TLObject-like
    #  @param offset integer
    #  @param limit integer
    initialize = function(location, offset, limit) {
      self$location <- location
      self$offset <- as.integer(offset)
      self$limit <- as.integer(limit)
      invisible(self)
    },

    #  @description Convert to list (dictionary-like)
    #  @return list
    to_list = function() {
      list(
        `_` = "GetWebFileRequest",
        location = if (inherits(self$location, "R6")) self$location$to_list() else self$location,
        offset = self$offset,
        limit = self$limit
      )
    },

    #  @description Serialize to raw vector
    #  @return raw
    to_bytes = function() {
      c(
        private$constructor_id,
        if (inherits(self$location, "R6")) {
          if (is.function(self$location$to_bytes)) {
            self$location$to_bytes()
          } else if (is.function(self$location$bytes)) {
            self$location$bytes()
          } else {
            stop("location must be an R6 TLObject-like with to_bytes() or bytes()")
          }
        } else {
          stop("location must be an R6 TLObject-like with to_bytes() or bytes()")
        },
        private$pack_int32_le(self$offset),
        private$pack_int32_le(self$limit)
      )
    },

    #  @description Read GetWebFileRequest from a reader
    #  @param reader an object providing tgread_object(), read_int()
    #  @return GetWebFileRequest
    from_reader = function(reader) {
      location_val <- reader$tgread_object()
      offset_val <- reader$read_int()
      limit_val <- reader$read_int()
      GetWebFileRequest$new(location = location_val, offset = offset_val, limit = limit_val)
    }
  ),
  private = list(
    constructor_id = as.raw(c(0x8d, 0x81, 0xe6, 0x24)),
    pack_int32_le = function(x) { int_to_raw_le(x, 4L) },
    pack_int64_le = .pack_int64_le_safe,
    serialize_bytes = function(b) {
      if (is.raw(b)) {
        b_raw <- b
      } else if (is.character(b)) {
        b_raw <- charToRaw(b)
      } else if (is.numeric(b) || is.integer(b)) {
        b_raw <- as.raw(as.integer(b) %% 256)
      } else {
        stop("bytes must be raw, integer or character")
      }

      len <- length(b_raw)
      con <- rawConnection(raw(), "wb")
      on.exit(close(con))
      writeBin(as.integer(len), con, size = 4L, endian = "little")
      if (len > 0) writeBin(b_raw, con, size = 1L)
      pad <- (4 - (len %% 4)) %% 4
      if (pad > 0) writeBin(rep(as.raw(0x00), pad), con, size = 1L)
      rawConnectionValue(con)
    }
  )
)


#  ReuploadCdnFileRequest R6 class
# 
#  Represents the TL request upload.ReuploadCdnFileRequest.
#  @title ReuploadCdnFileRequest
#  @description Telegram API type ReuploadCdnFileRequest
#  @export
#  @noRd
#  @noRd
ReuploadCdnFileRequest <- R6::R6Class(
  "ReuploadCdnFileRequest",
  public = list(
    #  @field file_token Field.
    file_token = NULL,
    #  @field request_token Field.
    request_token = NULL,

    #  @description Initialize a ReuploadCdnFileRequest
    #  @param file_token raw|integer|character
    #  @param request_token raw|integer|character
    initialize = function(file_token, request_token) {
      self$file_token <- file_token
      self$request_token <- request_token
      invisible(self)
    },

    #  @description Convert to list (dictionary-like)
    #  @return list
    to_list = function() {
      list(
        `_` = "ReuploadCdnFileRequest",
        file_token = self$file_token,
        request_token = self$request_token
      )
    },

    #  @description Serialize to raw vector
    #  @return raw
    to_bytes = function() {
      c(
        private$constructor_id,
        private$serialize_bytes(self$file_token),
        private$serialize_bytes(self$request_token)
      )
    },

    #  @description Read ReuploadCdnFileRequest from a reader
    #  @param reader an object providing tgread_bytes()
    #  @return ReuploadCdnFileRequest
    from_reader = function(reader) {
      file_token_val <- reader$tgread_bytes()
      request_token_val <- reader$tgread_bytes()
      ReuploadCdnFileRequest$new(file_token = file_token_val, request_token = request_token_val)
    }
  ),
  private = list(
    constructor_id = as.raw(c(0xa8, 0x54, 0x27, 0x9b)),
    pack_int32_le = function(x) { int_to_raw_le(x, 4L) },
    pack_int64_le = .pack_int64_le_safe,
    serialize_bytes = function(b) {
      if (is.raw(b)) {
        b_raw <- b
      } else if (is.character(b)) {
        b_raw <- charToRaw(b)
      } else if (is.numeric(b) || is.integer(b)) {
        b_raw <- as.raw(as.integer(b) %% 256)
      } else {
        stop("bytes must be raw, integer or character")
      }

      len <- length(b_raw)
      con <- rawConnection(raw(), "wb")
      on.exit(close(con))
      writeBin(as.integer(len), con, size = 4L, endian = "little")
      if (len > 0) writeBin(b_raw, con, size = 1L)
      pad <- (4 - (len %% 4)) %% 4
      if (pad > 0) writeBin(rep(as.raw(0x00), pad), con, size = 1L)
      rawConnectionValue(con)
    }
  )
)


#  SaveBigFilePartRequest R6 class
# 
#  Represents the TL request upload.SaveBigFilePartRequest.
#  @title SaveBigFilePartRequest
#  @description Telegram API type SaveBigFilePartRequest
#  @export
#  @noRd
#  @noRd
SaveBigFilePartRequest <- R6::R6Class(
  "SaveBigFilePartRequest",
  public = list(
    #  @field file_id Field.
    file_id = NULL,
    #  @field file_part Field.
    file_part = NULL,
    #  @field file_total_parts Field.
    file_total_parts = NULL,
    #  @field bytes_data Field.
    bytes_data = NULL,

    #  @description Initialize a SaveBigFilePartRequest
    #  @param file_id numeric (64-bit)
    #  @param file_part integer
    #  @param file_total_parts integer
    #  @param bytes_data raw|integer|character
    initialize = function(file_id, file_part, file_total_parts, bytes_data) {
      self$file_id <- file_id
      self$file_part <- as.integer(file_part)
      self$file_total_parts <- as.integer(file_total_parts)
      self$bytes_data <- bytes_data
      invisible(self)
    },

    #  @description Convert to list (dictionary-like)
    #  @return list
    to_list = function() {
      list(
        `_` = "SaveBigFilePartRequest",
        file_id = self$file_id,
        file_part = self$file_part,
        file_total_parts = self$file_total_parts,
        bytes = self$bytes_data
      )
    },

    #  @description Serialize to raw vector
    #  @return raw
    to_bytes = function() {
      c(
        private$constructor_id,
        private$pack_int64_le(self$file_id),
        private$pack_int32_le(self$file_part),
        private$pack_int32_le(self$file_total_parts),
        private$serialize_bytes(self$bytes_data)
      )
    },

    #  @description Read SaveBigFilePartRequest from a reader
    #  @param reader an object providing read_long(), read_int() and tgread_bytes()
    #  @return SaveBigFilePartRequest
    from_reader = function(reader) {
      file_id_val <- reader$read_long()
      file_part_val <- reader$read_int()
      file_total_parts_val <- reader$read_int()
      bytes_val <- reader$tgread_bytes()
      SaveBigFilePartRequest$new(
        file_id = file_id_val,
        file_part = file_part_val,
        file_total_parts = file_total_parts_val,
        bytes_data = bytes_val
      )
    }
  ),
  private = list(
    constructor_id = as.raw(c(0x3d, 0x67, 0x7b, 0xde)),
    pack_int32_le = function(x) { int_to_raw_le(x, 4L) },
    pack_int64_le = .pack_int64_le_safe,
    serialize_bytes = function(b) {
      if (is.raw(b)) {
        b_raw <- b
      } else if (is.character(b)) {
        b_raw <- charToRaw(b)
      } else if (is.numeric(b) || is.integer(b)) {
        b_raw <- as.raw(as.integer(b) %% 256)
      } else {
        stop("bytes_data must be raw, integer or character")
      }

      len <- length(b_raw)
      con <- rawConnection(raw(), "wb")
      on.exit(close(con))
      writeBin(as.integer(len), con, size = 4L, endian = "little")
      writeBin(b_raw, con, size = 1L)
      pad <- (4 - (len %% 4)) %% 4
      if (pad > 0) writeBin(rep(as.raw(0x00), pad), con, size = 1L)
      rawConnectionValue(con)
    }
  )
)


#  SaveFilePartRequest R6 class
# 
#  R6 representation of the Telegram TL request upload.SaveFilePartRequest.
#  @title SaveFilePartRequest
#  @description Telegram API type SaveFilePartRequest
#  @export
#  @noRd
#  @noRd
SaveFilePartRequest <- R6::R6Class(
  "SaveFilePartRequest",
  public = list(
    #  @field file_id Field.
    file_id = NULL,
    #  @field file_part Field.
    file_part = NULL,
    #  @field bytes_data Field.
    bytes_data = NULL,

    #  @description Initialize a new SaveFilePartRequest instance.
    #  @param file_id numeric (64-bit) Unique file identifier.
    #  @param file_part integer Zero-based index of this part.
    #  @param bytes_data raw|integer|character Payload bytes for this part.
    #  @return SaveFilePartRequest (invisibly) for chaining.
    initialize = function(file_id, file_part, bytes_data) {
      self$file_id <- file_id
      self$file_part <- as.integer(file_part)
      self$bytes_data <- bytes_data
      invisible(self)
    },

    #  @description Convert the request to a plain list (for inspection or JSON).
    #  @return list A named list with class tag and fields.
    to_list = function() {
      list(
        `_` = "SaveFilePartRequest",
        file_id = self$file_id,
        file_part = self$file_part,
        bytes = self$bytes_data
      )
    },

    #  @description Serialize the request into TL-compliant raw bytes.
    #  @return raw Serialized byte vector.
    to_bytes = function() {
      c(
        private$constructor_id,
        private$pack_int64_le(self$file_id),
        private$pack_int32_le(self$file_part),
        private$serialize_bytes(self$bytes_data)
      )
    },

    #  @description Read SaveFilePartRequest from a reader
    #  @param reader an object providing read_long(), read_int() and tgread_bytes()
    #  @return SaveFilePartRequest
    from_reader = function(reader) {
      file_id_val <- reader$read_long()
      file_part_val <- reader$read_int()
      bytes_val <- reader$tgread_bytes()
      SaveFilePartRequest$new(
        file_id = file_id_val,
        file_part = file_part_val,
        bytes_data = bytes_val
      )
    }
  ),
  private = list(
    constructor_id = as.raw(c(0x21, 0xa6, 0x04, 0xb3)),
    pack_int32_le = function(x) { int_to_raw_le(x, 4L) },
    pack_int64_le = .pack_int64_le_safe,
    serialize_bytes = function(b) {
      if (is.raw(b)) {
        b_raw <- b
      } else if (is.character(b)) {
        b_raw <- charToRaw(b)
      } else if (is.numeric(b) || is.integer(b)) {
        b_raw <- as.raw(as.integer(b) %% 256)
      } else {
        stop("bytes_data must be raw, integer or character")
      }

      len <- length(b_raw)
      con <- rawConnection(raw(), "wb")
      on.exit(close(con))
      writeBin(as.integer(len), con, size = 4L, endian = "little")
      writeBin(b_raw, con, size = 1L)
      pad <- (4 - (len %% 4)) %% 4
      if (pad > 0) writeBin(rep(as.raw(0x00), pad), con, size = 1L)
      rawConnectionValue(con)
    }
  )
)
