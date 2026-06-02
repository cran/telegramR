#  FinishJobRequest R6 class
# 
#  Representation of the FinishJobRequest TLRequest.
#  @title FinishJobRequest
#  @description Telegram API type FinishJobRequest
#  @export
#  @noRd
#  @noRd
FinishJobRequest <- R6::R6Class(
  "FinishJobRequest",
  public = list(
    #  @field job_id Field.
    job_id = NULL,
    #  @field error Field.
    error = NULL,

    #  @description Initialize a FinishJobRequest
    #  @param job_id character
    #  @param error character or NULL
    #  @return self
    initialize = function(job_id, error = NULL) {
      if (!missing(job_id) && !is.null(job_id)) {
        job_id <- as.character(job_id)
      }
      if (!is.null(error)) {
        error <- as.character(error)
      }
      self$job_id <- job_id
      self$error <- error
      invisible(self)
    },

    #  @description Convert to list (dictionary-like)
    #  @return list
    to_list = function() {
      list(
        `_` = "FinishJobRequest",
        job_id = self$job_id,
        error = self$error
      )
    },

    #  @description Get raw bytes for this constructor
    #  @return raw vector
    #  @details Encodes constructor id, flags (bit 0 for error), job_id and optional error.
    bytes = function() {
      # constructor id bytes as in Python: b'$\xbf\x1eO' -> 0x24 0xbf 0x1e 0x4f
      ctor <- as.raw(c(0x24, 0xbf, 0x1e, 0x4f))
      flag_val <- if (is.null(self$error) || identical(self$error, FALSE)) 0L else 1L
      flags_bytes <- write_uint32_le(flag_val)
      parts <- list(ctor, flags_bytes, serialize_bytes(self$job_id))
      if (flag_val == 1L) {
        parts <- c(parts, list(serialize_bytes(self$error)))
      }
      do.call(c, parts)
    }
  ),
  #  @field lock_class Field.
  lock_class = FALSE
)

# static/class method: from_reader
FinishJobRequest$set("public", "from_reader", function(reader) {
  # reader is expected to implement read_int() and tgread_string()
  flags_val <- reader$read_int()
  job_id_read <- reader$tgread_string()
  if (bitwAnd(flags_val, 1L) != 0L) {
    error_read <- reader$tgread_string()
  } else {
    error_read <- NULL
  }
  FinishJobRequest$new(job_id = job_id_read, error = error_read)
})


#  GetSmsJobRequest R6 class
# 
#  Representation of the GetSmsJobRequest TLRequest.
#  @title GetSmsJobRequest
#  @description Telegram API type GetSmsJobRequest
#  @export
#  @noRd
#  @noRd
GetSmsJobRequest <- R6::R6Class(
  "GetSmsJobRequest",
  public = list(
    #  @field job_id Field.
    job_id = NULL,

    #  @description Initialize a GetSmsJobRequest
    #  @param job_id character
    #  @return self
    initialize = function(job_id) {
      if (!missing(job_id) && !is.null(job_id)) {
        job_id <- as.character(job_id)
      }
      self$job_id <- job_id
      invisible(self)
    },

    #  @description Convert to list (dictionary-like)
    #  @return list
    to_list = function() {
      list(
        `_` = "GetSmsJobRequest",
        job_id = self$job_id
      )
    },

    #  @description Get raw bytes for this constructor
    #  @return raw vector
    #  @details This calls a helper serialize_bytes() to encode the job_id.
    bytes = function() {
      ctor <- as.raw(c(0x2f, 0x90, 0x8d, 0x77))
      # serialize_bytes() is expected to be available in the package context
      c(ctor, serialize_bytes(self$job_id))
    }
  ),
  #  @field lock_class Field.
  lock_class = FALSE
)

# static/class method: from_reader
GetSmsJobRequest$set("public", "from_reader", function(reader) {
  # reader is expected to implement tgread_string()
  job_id <- reader$tgread_string()
  GetSmsJobRequest$new(job_id = job_id)
})


#  GetStatusRequest R6 class
# 
#  Representation of the GetStatusRequest TLRequest.
#  @title GetStatusRequest
#  @description Telegram API type GetStatusRequest
#  @export
#  @noRd
#  @noRd
GetStatusRequest <- R6::R6Class(
  "GetStatusRequest",
  public = list(
    #  @description Initialize a GetStatusRequest
    #  @return self
    initialize = function() {
      invisible(self)
    },

    #  @description Convert to list (dictionary-like)
    #  @return list
    to_list = function() {
      list(`_` = "GetStatusRequest")
    },

    #  @description Get raw bytes for this constructor
    #  @return raw vector
    bytes = function() {
      as.raw(c(0xe8, 0x98, 0xa6, 0x10))
    }
  ),
  #  @field lock_class Field.
  lock_class = FALSE
)

# static/class method: from_reader
GetStatusRequest$set("public", "from_reader", function(reader) {
  # nothing to read for this constructor
  GetStatusRequest$new()
})


#  IsEligibleToJoinRequest R6 class
# 
#  Representation of the IsEligibleToJoinRequest TLRequest.
#  @title IsEligibleToJoinRequest
#  @description Telegram API type IsEligibleToJoinRequest
#  @export
#  @noRd
#  @noRd
IsEligibleToJoinRequest <- R6::R6Class(
  "IsEligibleToJoinRequest",
  public = list(
    #  @description Initialize an IsEligibleToJoinRequest
    #  @return self
    initialize = function() {
      invisible(self)
    },

    #  @description Convert to list (dictionary-like)
    #  @return list
    to_list = function() {
      list(`_` = "IsEligibleToJoinRequest")
    },

    #  @description Get raw bytes for this constructor
    #  @return raw vector
    bytes = function() {
      as.raw(c(0xd0, 0x39, 0xdc, 0x0e))
    }
  ),
  #  @field lock_class Field.
  lock_class = FALSE
)

# static/class method: from_reader
IsEligibleToJoinRequest$set("public", "from_reader", function(reader) {
  # nothing to read for this constructor
  IsEligibleToJoinRequest$new()
})


# Helper: write a 32-bit unsigned integer in little-endian as raw vector
write_uint32_le <- function(x) {
  con <- rawConnection(raw(0), "r+")
  on.exit(close(con))
  if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
  rawConnectionValue(con)
}

#  JoinRequest R6 class
# 
#  Representation of the JoinRequest TLRequest.
#  @title JoinRequest
#  @description Telegram API type JoinRequest
#  @export
#  @noRd
#  @noRd
JoinRequest <- R6::R6Class(
  "JoinRequest",
  public = list(
    #  @description Initialize a JoinRequest
    #  @return self
    initialize = function() {
      invisible(self)
    },

    #  @description Convert to list (dictionary-like)
    #  @return list
    to_list = function() {
      list(`_` = "JoinRequest")
    },

    #  @description Get raw bytes for this constructor
    #  @return raw vector
    bytes = function() {
      as.raw(c(0x2d, 0xce, 0x4e, 0xa7))
    }
  ),
  #  @field lock_class Field.
  lock_class = FALSE
)

# static/class method: from_reader
JoinRequest$set("public", "from_reader", function(reader) {
  # reader is expected to have methods to read TL-serialized data; for JoinRequest nothing to read
  JoinRequest$new()
})


#  LeaveRequest R6 class
# 
#  Representation of the LeaveRequest TLRequest.
#  @title LeaveRequest
#  @description Telegram API type LeaveRequest
#  @export
#  @noRd
#  @noRd
LeaveRequest <- R6::R6Class(
  "LeaveRequest",
  public = list(
    #  @description Initialize a LeaveRequest
    #  @return self
    initialize = function() {
      invisible(self)
    },

    #  @description Convert to list (dictionary-like)
    #  @return list
    to_list = function() {
      list(`_` = "LeaveRequest")
    },

    #  @description Get raw bytes for this constructor
    #  @return raw vector
    bytes = function() {
      as.raw(c(0x73, 0xad, 0x98, 0x98))
    }
  ),
  #  @field lock_class Field.
  lock_class = FALSE
)

# static/class method: from_reader
LeaveRequest$set("public", "from_reader", function(reader) {
  LeaveRequest$new()
})


#  UpdateSettingsRequest R6 class
# 
#  Representation of the UpdateSettingsRequest TLRequest.
#  @title UpdateSettingsRequest
#  @description Telegram API type UpdateSettingsRequest
#  @export
#  @noRd
#  @noRd
UpdateSettingsRequest <- R6::R6Class(
  "UpdateSettingsRequest",
  public = list(
    #  @field allow_international Field.
    allow_international = NULL,

    #  @description Initialize UpdateSettingsRequest
    #  @param allow_international logical or NULL
    initialize = function(allow_international = NULL) {
      if (!is.null(allow_international)) {
        allow_international <- as.logical(allow_international)
      }
      self$allow_international <- allow_international
      invisible(self)
    },

    #  @description Convert to list (dictionary-like)
    #  @return list
    to_list = function() {
      list(
        `_` = "UpdateSettingsRequest",
        allow_international = self$allow_international
      )
    },

    #  @description Get raw bytes for this constructor
    #  @return raw vector
    bytes = function() {
      # constructor id bytes: b'\xbf\xa0?\t' -> 0xbf 0xa0 0x3f 0x09
      ctor <- as.raw(c(0xbf, 0xa0, 0x3f, 0x09))
      flag_val <- if (is.null(self$allow_international) || identical(self$allow_international, FALSE)) 0L else 1L
      flags_bytes <- write_uint32_le(flag_val)
      c(ctor, flags_bytes)
    }
  ),
  #  @field lock_class Field.
  lock_class = FALSE
)

# static/class method: from_reader
UpdateSettingsRequest$set("public", "from_reader", function(reader) {
  # reader is expected to implement read_int() returning a 32-bit integer
  flags <- reader$read_int()
  allow_international_read <- as.logical(bitwAnd(flags, 1L))
  UpdateSettingsRequest$new(allow_international = allow_international_read)
})
