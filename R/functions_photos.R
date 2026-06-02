#  DeletePhotosRequest
# 
#  R6 translation of the TLRequest DeletePhotosRequest.
# 
# 
#  @format A R6 object inheriting from TLRequest.
#  @section Methods:
#  - new(id = NULL):
#    Create a new DeletePhotosRequest object.
#  - resolve(client, utils):
#    Resolve references (convert each provided id to input photo via utils).
#  - to_list():
#    Return a list representation suitable for JSON / introspection.
#  - to_bytes():
#    Serialize the object to a raw vector (little-endian packing). Writes vector constructor and elements.
#  - from_reader(reader):
#    Class method: read fields from a reader and construct an instance.
# 
#  @name DeletePhotosRequest
#  @title DeletePhotosRequest
#  @description Telegram API type DeletePhotosRequest
#  @export
#  @noRd
#  @noRd
DeletePhotosRequest <- R6::R6Class(
  "DeletePhotosRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID integer
    CONSTRUCTOR_ID = 0x87cf7f2f,

    #  @field SUBCLASS_OF_ID integer
    SUBCLASS_OF_ID = 0x8918e168,

    #  @field id list of TLObject or NULL
    id = NULL,

    #  @description Initialize a new DeletePhotosRequest
    # 
    #  @param id list of TLObject or identifiers for input photos
    initialize = function(id = NULL) {
      self$id <- id
    },

    #  @description Resolve references (client + utils)
    # 
    #  Convert each provided id into an input photo using utils.
    #  @param client client (not used here, included for API symmetry)
    #  @param utils helper with get_input_photo method
    resolve = function(client, utils) {
      if (!is.null(self$id)) {
        resolved <- lapply(self$id, function(x) utils$get_input_photo(x))
        self$id <- resolved
      }
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return list representation of the request
    to_list = function() {
      list(
        `_` = "DeletePhotosRequest",
        id = if (is.null(self$id)) NULL else lapply(self$id, function(x) if (inherits(x, "TLObject")) x$to_list() else x)
      )
    },

    #  @description Serialize to bytes (raw vector)
    # 
    #  Packs constructor id, vector constructor id, length and elements in little-endian order.
    #  Each element must implement to_bytes().
    #  @return raw vector
    to_bytes = function() {
      con <- rawConnection(raw(), "r+")
      on.exit(close(con))

      # constructor bytes for 0x87cf7f2f (little-endian)
      writeBin(as.raw(c(0x2f, 0x7f, 0xcf, 0x87)), con)

      # write Vector constructor id (0x1cb5c415 -> little-endian bytes)
      writeBin(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), con)

      len <- if (is.null(self$id)) 0L else length(self$id)
      writeBin(as.integer(len), con, size = 4, endian = "little")

      if (!is.null(self$id)) {
        for (elem in self$id) {
          if (!is.null(elem$to_bytes)) {
            writeBin(elem$to_bytes(), con)
          } else {
            stop("Each id element must implement to_bytes()")
          }
        }
      }

      rawConnectionValue(con)
    }
  ),
  active = list(
    # nothing active
  ),
  #  @field class Field.
  class = TRUE,
  private = list(
    from_reader_impl = function(reader) {
      # Read and verify vector constructor id (already provided by stream; still consume)
      reader$read_int()
      count <- reader$read_int()
      ids_list <- vector("list", count)
      for (i in seq_len(count)) {
        ids_list[[i]] <- reader$tgread_object()
      }
      DeletePhotosRequest$new(id = ids_list)
    }
  ),
  portable = TRUE
)

# Construct DeletePhotosRequest from a reader
# @name DeletePhotosRequest_from_reader
#
# Class-level convenience wrapper around the private from_reader_impl.
# @param reader Reader object providing read_int, tgread_object, etc.
# @return DeletePhotosRequest instance
# @export
DeletePhotosRequest$from_reader <- function(reader) {
  DeletePhotosRequest$private_methods$from_reader_impl(reader)
}

# Read result for DeletePhotosRequest
# @name DeletePhotosRequest_read_result
#
# Reads a Vector<long> result returned by the server for this request.
# @param reader Reader object providing read_int, read_long, etc.
# @return numeric vector (R doubles) of longs
# @export
DeletePhotosRequest$read_result <- function(reader) {
  # consume vector constructor id
  reader$read_int()
  count <- reader$read_int()
  result_vec <- numeric(count)
  for (i in seq_len(count)) {
    result_vec[i] <- reader$read_long()
  }
  result_vec
}


#  GetUserPhotosRequest
# 
#  R6 translation of the TLRequest GetUserPhotosRequest.
# 
# 
#  @format A R6 object inheriting from TLRequest.
#  @section Methods:
#  - new(user_id = NULL, offset = 0L, max_id = 0, limit = 0L):
#    Create a new GetUserPhotosRequest object.
#  - resolve(client, utils):
#    Resolve references (convert user identifier to input user via client + utils).
#  - to_list():
#    Return a list representation suitable for JSON / introspection.
#  - to_bytes():
#    Serialize the object to a raw vector (little-endian packing).
#  - from_reader(reader):
#    Class method: read fields from a reader and construct an instance.
# 
#  @name GetUserPhotosRequest
#  @title GetUserPhotosRequest
#  @description Telegram API type GetUserPhotosRequest
#  @export
#  @noRd
#  @noRd
GetUserPhotosRequest <- R6::R6Class(
  "GetUserPhotosRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID integer
    CONSTRUCTOR_ID = 0x91cd32a8,

    #  @field SUBCLASS_OF_ID integer
    SUBCLASS_OF_ID = 0x27cfb967,

    #  @field user_id TLObject or NULL
    user_id = NULL,
    #  @field offset integer
    offset = NULL,
    #  @field max_id numeric (64-bit representation)
    max_id = NULL,
    #  @field limit integer
    limit = NULL,

    #  @description Initialize a new GetUserPhotosRequest
    # 
    #  @param user_id TLObject or identifier for input user
    #  @param offset integer
    #  @param max_id numeric (64-bit)
    #  @param limit integer
    initialize = function(user_id = NULL, offset = 0L, max_id = 0, limit = 0L) {
      self$user_id <- user_id
      self$offset <- as.integer(offset)
      self$max_id <- max_id
      self$limit <- as.integer(limit)
    },

    #  @description Resolve references (client + utils)
    # 
    #  Convert provided user identifier into an input user using client and utils.
    #  @param client client with get_input_entity method
    #  @param utils helper with get_input_user method
    resolve = function(client, utils) {
      if (!is.null(self$user_id)) {
        entity <- client$get_input_entity(self$user_id)
        self$user_id <- utils$get_input_user(entity)
      }
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return list representation of the request
    to_list = function() {
      list(
        `_` = "GetUserPhotosRequest",
        user_id = if (!is.null(self$user_id) && inherits(self$user_id, "TLObject")) self$user_id$to_list() else self$user_id,
        offset = self$offset,
        max_id = self$max_id,
        limit = self$limit
      )
    },

    #  @description Serialize to bytes (raw vector)
    # 
    #  Packs constructor id and fields in little-endian order.
    #  Relies on user_id implementing to_bytes(). max_id is written as 8 bytes (numeric).
    #  @return raw vector
    to_bytes = function() {
      con <- rawConnection(raw(), "r+")
      on.exit(close(con))

      # constructor bytes for 0x91cd32a8 -> little-endian bytes
      writeBin(as.raw(c(0xa8, 0x32, 0xcd, 0x91)), con)

      if (!is.null(self$user_id) && !is.null(self$user_id$to_bytes)) {
        writeBin(self$user_id$to_bytes(), con)
      } else {
        stop("user_id must be provided and implement to_bytes()")
      }

      writeBin(as.integer(self$offset), con, size = 4, endian = "little")
      # write max_id as 8-byte little-endian. Represented as numeric (double) in R.
      writeBin(as.double(self$max_id), con, size = 8, endian = "little")
      writeBin(as.integer(self$limit), con, size = 4, endian = "little")

      rawConnectionValue(con)
    }
  ),
  active = list(
    # nothing active
  ),
  #  @field class Field.
  class = TRUE,
  private = list(
    from_reader_impl = function(reader) {
      user_entity <- reader$tgread_object()
      offset_val <- reader$read_int()
      max_id_val <- reader$read_long()
      limit_val <- reader$read_int()
      GetUserPhotosRequest$new(
        user_id = user_entity,
        offset = offset_val,
        max_id = max_id_val,
        limit = limit_val
      )
    }
  ),
  portable = TRUE
)

# Construct GetUserPhotosRequest from a reader
# @name GetUserPhotosRequest_from_reader
#
# Class-level convenience wrapper around the private from_reader_impl.
# @param reader Reader object providing tgread_object, read_int, read_long, etc.
# @return GetUserPhotosRequest instance
# @export
GetUserPhotosRequest$from_reader <- function(reader) {
  GetUserPhotosRequest$private_methods$from_reader_impl(reader)
}


#  UpdateProfilePhotoRequest
# 
#  R6 translation of the TLRequest UpdateProfilePhotoRequest.
# 
# 
#  @format A R6 object inheriting from TLRequest.
#  @section Methods:
#  - new(id = NULL, fallback = NULL, bot = NULL):
#    Create a new UpdateProfilePhotoRequest object.
#  - resolve(client, utils):
#    Resolve references (convert provided id to input photo and bot to input user).
#  - to_list():
#    Return a list representation suitable for JSON / introspection.
#  - to_bytes():
#    Serialize the object to a raw vector (little-endian packing).
#  - from_reader(reader):
#    Class method: read fields from a reader and construct an instance.
# 
#  @name UpdateProfilePhotoRequest
#  @title UpdateProfilePhotoRequest
#  @description Telegram API type UpdateProfilePhotoRequest
#  @export
#  @noRd
#  @noRd
UpdateProfilePhotoRequest <- R6::R6Class(
  "UpdateProfilePhotoRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID integer
    CONSTRUCTOR_ID = 0x09e82039,

    #  @field SUBCLASS_OF_ID integer
    SUBCLASS_OF_ID = 0xc292bd24,

    #  @field id TLObject or NULL
    id = NULL,
    #  @field fallback logical or NULL
    fallback = NULL,
    #  @field bot TLObject or NULL
    bot = NULL,

    #  @description Initialize a new UpdateProfilePhotoRequest
    # 
    #  @param id TLObject or identifier for input photo
    #  @param fallback logical or NULL
    #  @param bot TLObject or identifier for input user or NULL
    initialize = function(id = NULL, fallback = NULL, bot = NULL) {
      self$id <- id
      self$fallback <- fallback
      self$bot <- bot
    },

    #  @description Resolve references (client + utils)
    # 
    #  Convert provided id into an input photo and bot into an input user using client and utils.
    #  @param client client with get_input_entity method
    #  @param utils helper with get_input_photo and get_input_user methods
    resolve = function(client, utils) {
      if (!is.null(self$id)) {
        self$id <- utils$get_input_photo(self$id)
      } else {
        stop("id must be provided")
      }

      if (!is.null(self$bot) && !identical(self$bot, FALSE)) {
        entity <- client$get_input_entity(self$bot)
        self$bot <- utils$get_input_user(entity)
      }
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return list representation of the request
    to_list = function() {
      list(
        `_` = "UpdateProfilePhotoRequest",
        id = if (!is.null(self$id) && inherits(self$id, "TLObject")) self$id$to_list() else self$id,
        fallback = self$fallback,
        bot = if (!is.null(self$bot) && inherits(self$bot, "TLObject")) self$bot$to_list() else self$bot
      )
    },

    #  @description Serialize to bytes (raw vector)
    # 
    #  Packs constructor id, flags and present fields in little-endian order.
    #  Relies on contained TLObject instances implementing to_bytes().
    #  @return raw vector
    to_bytes = function() {
      con <- rawConnection(raw(), "r+")
      on.exit(close(con))
      # constructor bytes for 0x09e82039 -> little-endian order of bytes
      writeBin(as.raw(c(0x39, 0x20, 0xe8, 0x09)), con)

      flags <- bitwOr(
        if (!is.null(self$fallback) && !identical(self$fallback, FALSE)) 1L else 0L,
        if (!is.null(self$bot) && !identical(self$bot, FALSE)) 2L else 0L
      )
      writeBin(as.integer(flags), con, size = 4, endian = "little")

      # optional bot first (if present)
      if (!is.null(self$bot) && !identical(self$bot, FALSE)) {
        if (!is.null(self$bot$to_bytes)) {
          writeBin(self$bot$to_bytes(), con)
        } else {
          stop("bot object must implement to_bytes()")
        }
      }

      # required id
      if (!is.null(self$id) && !is.null(self$id$to_bytes)) {
        writeBin(self$id$to_bytes(), con)
      } else {
        stop("id must be provided and implement to_bytes()")
      }

      rawConnectionValue(con)
    }
  ),
  active = list(
    # nothing active
  ),
  #  @field class Field.
  class = TRUE,
  private = list(
    # class-level helper to construct from reader
    from_reader_impl = function(reader) {
      flagsVal <- reader$read_int()
      fallbackFlag <- bitwAnd(flagsVal, 1L) != 0L

      if (bitwAnd(flagsVal, 2L) != 0L) {
        botObj <- reader$tgread_object()
      } else {
        botObj <- NULL
      }

      idObj <- reader$tgread_object()

      UpdateProfilePhotoRequest$new(
        id = idObj,
        fallback = fallbackFlag,
        bot = botObj
      )
    }
  ),
  portable = TRUE
)

# Construct UpdateProfilePhotoRequest from a reader
# @name UpdateProfilePhotoRequest_from_reader
#
# Class-level convenience wrapper around the private from_reader_impl.
# @param reader Reader object providing read_int, tgread_object, etc.
# @return UpdateProfilePhotoRequest instance
# @export
UpdateProfilePhotoRequest$from_reader <- function(reader) {
  UpdateProfilePhotoRequest$private_methods$from_reader_impl(reader)
}


#  UploadContactProfilePhotoRequest
# 
#  R6 translation of the TLRequest UploadContactProfilePhotoRequest.
# 
# 
#  @format A R6 object inheriting from TLRequest.
#  @section Methods:
#  - new(user_id = NULL, suggest = NULL, save = NULL, file = NULL, video = NULL, video_start_ts = NULL, video_emoji_markup = NULL):
#    Create a new UploadContactProfilePhotoRequest object.
#  - resolve(client, utils):
#    Resolve references (convert a user identifier to input user via utils).
#  - to_list():
#    Return a list representation suitable for JSON / introspection.
#  - to_bytes():
#    Serialize the object to a raw vector (little-endian packing).
#  - from_reader(reader):
#    Class method: read fields from a reader and construct an instance.
# 
#  @name UploadContactProfilePhotoRequest
#  @title UploadContactProfilePhotoRequest
#  @description Telegram API type UploadContactProfilePhotoRequest
#  @export
#  @noRd
#  @noRd
UploadContactProfilePhotoRequest <- R6::R6Class(
  "UploadContactProfilePhotoRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID integer
    CONSTRUCTOR_ID = 0xe14c4a71,

    #  @field SUBCLASS_OF_ID integer
    SUBCLASS_OF_ID = 0xc292bd24,

    #  @field user_id TLObject or NULL
    user_id = NULL,
    #  @field suggest logical (optional)
    suggest = NULL,
    #  @field save logical (optional)
    save = NULL,
    #  @field file TLObject or NULL
    file = NULL,
    #  @field video TLObject or NULL
    video = NULL,
    #  @field video_start_ts numeric or NULL
    video_start_ts = NULL,
    #  @field video_emoji_markup TLObject or NULL
    video_emoji_markup = NULL,

    #  @description Initialize a new UploadContactProfilePhotoRequest
    # 
    #  @param user_id TLObject or identifier for user
    #  @param suggest logical or NULL
    #  @param save logical or NULL
    #  @param file TLObject or NULL
    #  @param video TLObject or NULL
    #  @param video_start_ts numeric or NULL
    #  @param video_emoji_markup TLObject or NULL
    initialize = function(user_id = NULL, suggest = NULL, save = NULL, file = NULL,
                          video = NULL, video_start_ts = NULL, video_emoji_markup = NULL) {
      self$user_id <- user_id
      self$suggest <- suggest
      self$save <- save
      self$file <- file
      self$video <- video
      self$video_start_ts <- video_start_ts
      self$video_emoji_markup <- video_emoji_markup
    },

    #  @description Resolve references (client + utils)
    # 
    #  Convert provided user identifier into an input user using client and utils.
    #  @param client client with get_input_entity method
    #  @param utils helper with get_input_user method
    resolve = function(client, utils) {
      if (!is.null(self$user_id)) {
        # client$get_input_entity may be synchronous in this R binding
        entity <- client$get_input_entity(self$user_id)
        self$user_id <- utils$get_input_user(entity)
      }
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return list representation of the request
    to_list = function() {
      list(
        `_` = "UploadContactProfilePhotoRequest",
        user_id = if (!is.null(self$user_id) && inherits(self$user_id, "TLObject")) self$user_id$to_list() else self$user_id,
        suggest = self$suggest,
        save = self$save,
        file = if (!is.null(self$file) && inherits(self$file, "TLObject")) self$file$to_list() else self$file,
        video = if (!is.null(self$video) && inherits(self$video, "TLObject")) self$video$to_list() else self$video,
        video_start_ts = self$video_start_ts,
        video_emoji_markup = if (!is.null(self$video_emoji_markup) && inherits(self$video_emoji_markup, "TLObject")) self$video_emoji_markup$to_list() else self$video_emoji_markup
      )
    },

    #  @description Serialize to bytes (raw vector)
    # 
    #  Packs constructor id, flags and present fields in little-endian order.
    #  Relies on contained TLObject instances implementing to_bytes().
    #  @return raw vector
    to_bytes = function() {
      con <- rawConnection(raw(), "r+")
      on.exit(close(con))
      # constructor bytes for 0xe14c4a71 -> raw bytes (little-endian ordering as bytes in file)
      writeBin(as.raw(c(0x71, 0x4a, 0x4c, 0xe1)), con)
      flags <- Reduce(bitwOr, c(
        if (!is.null(self$suggest) && !identical(self$suggest, FALSE)) 8L else 0L,
        if (!is.null(self$save) && !identical(self$save, FALSE)) 16L else 0L,
        if (!is.null(self$file) && !identical(self$file, FALSE)) 1L else 0L,
        if (!is.null(self$video) && !identical(self$video, FALSE)) 2L else 0L,
        if (!is.null(self$video_start_ts) && !identical(self$video_start_ts, FALSE)) 4L else 0L,
        if (!is.null(self$video_emoji_markup) && !identical(self$video_emoji_markup, FALSE)) 32L else 0L
      ))
      # write flags as 32-bit little-endian integer
      writeBin(as.integer(flags), con, size = 4, endian = "little")
      # write required user_id
      if (!is.null(self$user_id) && !is.null(self$user_id$to_bytes)) {
        writeBin(self$user_id$to_bytes(), con)
      } else {
        stop("user_id must be provided and implement to_bytes()")
      }
      # optional fields in schema order
      if (!is.null(self$file) && !identical(self$file, FALSE)) {
        if (!is.null(self$file$to_bytes)) writeBin(self$file$to_bytes(), con) else stop("file must implement to_bytes()")
      }
      if (!is.null(self$video) && !identical(self$video, FALSE)) {
        if (!is.null(self$video$to_bytes)) writeBin(self$video$to_bytes(), con) else stop("video must implement to_bytes()")
      }
      if (!is.null(self$video_start_ts) && !identical(self$video_start_ts, FALSE)) {
        writeBin(as.double(self$video_start_ts), con, size = 8, endian = "little")
      }
      if (!is.null(self$video_emoji_markup) && !identical(self$video_emoji_markup, FALSE)) {
        if (!is.null(self$video_emoji_markup$to_bytes)) writeBin(self$video_emoji_markup$to_bytes(), con) else stop("video_emoji_markup must implement to_bytes()")
      }
      rawConnectionValue(con)
    }
  ),
  active = list(
    # nothing active
  ),
  #  @field class Field.
  class = TRUE,
  private = list(
    # class-level helper to construct from reader
    from_reader_impl = function(reader) {
      flags <- reader$read_int()
      suggest <- bitwAnd(flags, 8L) != 0L
      save <- bitwAnd(flags, 16L) != 0L

      userEntity <- reader$tgread_object()

      if (bitwAnd(flags, 1L) != 0L) {
        fileObj <- reader$tgread_object()
      } else {
        fileObj <- NULL
      }

      if (bitwAnd(flags, 2L) != 0L) {
        videoObj <- reader$tgread_object()
      } else {
        videoObj <- NULL
      }

      if (bitwAnd(flags, 4L) != 0L) {
        videoStartTs <- reader$read_double()
      } else {
        videoStartTs <- NULL
      }

      if (bitwAnd(flags, 32L) != 0L) {
        videoEmojiMarkupObj <- reader$tgread_object()
      } else {
        videoEmojiMarkupObj <- NULL
      }

      UploadContactProfilePhotoRequest$new(
        user_id = userEntity,
        suggest = suggest,
        save = save,
        file = fileObj,
        video = videoObj,
        video_start_ts = videoStartTs,
        video_emoji_markup = videoEmojiMarkupObj
      )
    }
  ),
  portable = TRUE
)

# @description Construct UploadContactProfilePhotoRequest from a reader
# @name UploadContactProfilePhotoRequest_from_reader
#
# Class-level convenience wrapper around the private from_reader_impl.
# @param reader Reader object providing read_int, tgread_object, read_double, etc.
# @return UploadContactProfilePhotoRequest instance
UploadContactProfilePhotoRequest$from_reader <- function(reader) {
  UploadContactProfilePhotoRequest$private_methods$from_reader_impl(reader)
}


#  UploadProfilePhotoRequest
# 
#  R6 translation of the TLRequest UploadProfilePhotoRequest.
# 
# 
#  @format A R6 object inheriting from TLRequest.
#  @section Methods:
#  - new(fallback = NULL, bot = NULL, file = NULL, video = NULL, video_start_ts = NULL, video_emoji_markup = NULL):
#    Create a new UploadProfilePhotoRequest object.
#  - resolve(client, utils):
#    Resolve references (e.g. convert a bot entity to input user via utils).
#  - to_list():
#    Return a list representation suitable for JSON / introspection.
#  - to_bytes():
#    Serialize the object to a raw vector (little-endian packing).
#  - from_reader(reader):
#    Class method: read fields from a reader and construct an instance.
# 
#  @name UploadProfilePhotoRequest
#  @title UploadProfilePhotoRequest
#  @description Telegram API type UploadProfilePhotoRequest
#  @export
#  @noRd
#  @noRd
UploadProfilePhotoRequest <- R6::R6Class(
  "UploadProfilePhotoRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID integer
    CONSTRUCTOR_ID = 0x0388a3b5,

    #  @field SUBCLASS_OF_ID integer
    SUBCLASS_OF_ID = 0xc292bd24,

    #  @field fallback logical (optional)
    fallback = NULL,
    #  @field bot TLObject or NULL
    bot = NULL,
    #  @field file TLObject or NULL
    file = NULL,
    #  @field video TLObject or NULL
    video = NULL,
    #  @field video_start_ts numeric or NULL
    video_start_ts = NULL,
    #  @field video_emoji_markup TLObject or NULL
    video_emoji_markup = NULL,

    #  @description Initialize a new UploadProfilePhotoRequest
    # 
    #  @param fallback logical or NULL
    #  @param bot TLObject or identifier for bot or NULL
    #  @param file TLObject or NULL
    #  @param video TLObject or NULL
    #  @param video_start_ts numeric or NULL
    #  @param video_emoji_markup TLObject or NULL
    initialize = function(fallback = NULL, bot = NULL, file = NULL, video = NULL,
                          video_start_ts = NULL, video_emoji_markup = NULL) {
      self$fallback <- fallback
      self$bot <- bot
      self$file <- file
      self$video <- video
      self$video_start_ts <- video_start_ts
      self$video_emoji_markup <- video_emoji_markup
    },

    #  @description Resolve references (client + utils)
    # 
    #  Convert provided bot identifier into an input user using client and utils.
    #  @param client client with get_input_entity method
    #  @param utils helper with get_input_user method
    resolve = function(client, utils) {
      if (!is.null(self$bot) && !identical(self$bot, FALSE)) {
        # client$get_input_entity may be synchronous in this R binding
        entity <- client$get_input_entity(self$bot)
        self$bot <- utils$get_input_user(entity)
      }
      invisible(self)
    },

    #  @description Convert object to a list
    # 
    #  @return list representation of the request
    to_list = function() {
      list(
        `_` = "UploadProfilePhotoRequest",
        fallback = self$fallback,
        bot = if (!is.null(self$bot) && inherits(self$bot, "TLObject")) self$bot$to_list() else self$bot,
        file = if (!is.null(self$file) && inherits(self$file, "TLObject")) self$file$to_list() else self$file,
        video = if (!is.null(self$video) && inherits(self$video, "TLObject")) self$video$to_list() else self$video,
        video_start_ts = self$video_start_ts,
        video_emoji_markup = if (!is.null(self$video_emoji_markup) && inherits(self$video_emoji_markup, "TLObject")) self$video_emoji_markup$to_list() else self$video_emoji_markup
      )
    },

    #  @description Serialize to bytes (raw vector)
    # 
    #  Packs constructor id, flags and present fields in little-endian order.
    #  Relies on contained TLObject instances implementing to_bytes().
    #  @return raw vector
    to_bytes = function() {
      con <- rawConnection(raw(), "r+")
      on.exit(close(con))
      # write constructor bytes (as in original: b'\xb5\xa3\x88\x03')
      writeBin(as.raw(c(0xb5, 0xa3, 0x88, 0x03)), con)
      flags <- Reduce(bitwOr, c(
        if (!is.null(self$fallback) && !identical(self$fallback, FALSE)) 8L else 0L,
        if (!is.null(self$bot) && !identical(self$bot, FALSE)) 32L else 0L,
        if (!is.null(self$file) && !identical(self$file, FALSE)) 1L else 0L,
        if (!is.null(self$video) && !identical(self$video, FALSE)) 2L else 0L,
        if (!is.null(self$video_start_ts) && !identical(self$video_start_ts, FALSE)) 4L else 0L,
        if (!is.null(self$video_emoji_markup) && !identical(self$video_emoji_markup, FALSE)) 16L else 0L
      ))
      # write flags as 32-bit little-endian integer
      writeBin(as.integer(flags), con, size = 4, endian = "little")
      # write optional fields in the same order as original
      if (!is.null(self$bot) && !identical(self$bot, FALSE)) {
        if (!is.null(self$bot$to_bytes)) {
          writeBin(self$bot$to_bytes(), con)
        } else {
          stop("bot object must implement to_bytes()")
        }
      }
      if (!is.null(self$file) && !identical(self$file, FALSE)) {
        if (!is.null(self$file$to_bytes)) writeBin(self$file$to_bytes(), con) else stop("file must implement to_bytes()")
      }
      if (!is.null(self$video) && !identical(self$video, FALSE)) {
        if (!is.null(self$video$to_bytes)) writeBin(self$video$to_bytes(), con) else stop("video must implement to_bytes()")
      }
      if (!is.null(self$video_start_ts) && !identical(self$video_start_ts, FALSE)) {
        writeBin(as.double(self$video_start_ts), con, size = 8, endian = "little")
      }
      if (!is.null(self$video_emoji_markup) && !identical(self$video_emoji_markup, FALSE)) {
        if (!is.null(self$video_emoji_markup$to_bytes)) writeBin(self$video_emoji_markup$to_bytes(), con) else stop("video_emoji_markup must implement to_bytes()")
      }
      rawConnectionValue(con)
    }
  ),
  active = list(
    # nothing active
  ),
  #  @field class Field.
  class = TRUE,
  private = list(
    # class-level helper to construct from reader
    from_reader_impl = function(reader) {
      flags <- reader$read_int()
      fallback <- bitwAnd(flags, 8L) != 0L
      if (bitwAnd(flags, 32L) != 0L) {
        bot <- reader$tgread_object()
      } else {
        bot <- NULL
      }
      if (bitwAnd(flags, 1L) != 0L) {
        file <- reader$tgread_object()
      } else {
        file <- NULL
      }
      if (bitwAnd(flags, 2L) != 0L) {
        video <- reader$tgread_object()
      } else {
        video <- NULL
      }
      if (bitwAnd(flags, 4L) != 0L) {
        video_start_ts <- reader$read_double()
      } else {
        video_start_ts <- NULL
      }
      if (bitwAnd(flags, 16L) != 0L) {
        video_emoji_markup <- reader$tgread_object()
      } else {
        video_emoji_markup <- NULL
      }
      UploadProfilePhotoRequest$new(
        fallback = fallback,
        bot = bot,
        file = file,
        video = video,
        video_start_ts = video_start_ts,
        video_emoji_markup = video_emoji_markup
      )
    }
  ),
  portable = TRUE
)

# @description Construct UploadProfilePhotoRequest from a reader
# @name UploadProfilePhotoRequest_from_reader
#
# Class-level convenience wrapper around the private from_reader_impl.
# @param reader Reader object providing read_int, tgread_object, read_double, etc.
# @return UploadProfilePhotoRequest instance
UploadProfilePhotoRequest$from_reader <- function(reader) {
  UploadProfilePhotoRequest$private_methods$from_reader_impl(reader)
}
