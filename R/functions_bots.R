#  AddPreviewMediaRequest R6 class
# 
#  Represents the AddPreviewMediaRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title AddPreviewMediaRequest
#  @description Telegram API type AddPreviewMediaRequest
#  @export
#  @noRd
#  @noRd
AddPreviewMediaRequest <- R6::R6Class(
  "AddPreviewMediaRequest",
  public = list(
    #  @field bot Field.
    bot = NULL,
    #  @field lang_code Field.
    lang_code = NULL,
    #  @field media Field.
    media = NULL,

    #  @description Initialize AddPreviewMediaRequest
    # 
    #  @param bot TypeInputUser or identifier
    #  @param lang_code character
    #  @param media TypeInputMedia or object
    initialize = function(bot, lang_code, media) {
      self$bot <- bot
      self$lang_code <- as.character(lang_code)
      self$media <- media
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  Resolves bot via client$get_input_entity and utils$get_input_user,
    #  resolves media via utils$get_input_media if available.
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user and get_input_media
    #  @return invisible(self)
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$bot)
      self$bot <- utils$get_input_user(input_entity)
      if (!is.null(self$media) && !is.null(utils$get_input_media)) {
        self$media <- utils$get_input_media(self$media)
      }
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      media_val <- if (inherits(self$media, "R6") && "to_list" %in% names(self$media)) {
        self$media$to_list()
      } else {
        self$media
      }
      list(
        `_` = "AddPreviewMediaRequest",
        bot = bot_val,
        lang_code = self$lang_code,
        media = media_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'Z\xb7\xae\x17')
      ctor <- as.raw(c(0x5A, 0xB7, 0xAE, 0x17))

      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          bot_bytes <- serialize_string_simple(as.character(self$bot))
        }
      }

      lang_bytes <- serialize_string_simple(self$lang_code)

      media_bytes <- raw(0)
      if (!is.null(self$media)) {
        if (inherits(self$media, "R6") && "to_bytes" %in% names(self$media)) {
          media_bytes <- self$media$to_bytes()
        } else if (inherits(self$media, "R6") && "_bytes" %in% names(self$media)) {
          media_bytes <- self$media$`_bytes`()
        } else if (is.raw(self$media)) {
          media_bytes <- self$media
        } else {
          media_bytes <- serialize_string_simple(as.character(self$media))
        }
      }

      c(ctor, bot_bytes, lang_bytes, media_bytes)
    }
  )
)

# static-like constructor from reader
AddPreviewMediaRequest$from_reader <- function(reader) {
  bot_obj <- reader$tgread_object()
  lang_code_val <- reader$tgread_string()
  media_obj <- reader$tgread_object()
  AddPreviewMediaRequest$new(bot = bot_obj, lang_code = lang_code_val, media = media_obj)
}


#  AllowSendMessageRequest R6 class
# 
#  Represents the AllowSendMessageRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title AllowSendMessageRequest
#  @description Telegram API type AllowSendMessageRequest
#  @export
#  @noRd
#  @noRd
AllowSendMessageRequest <- R6::R6Class(
  "AllowSendMessageRequest",
  public = list(
    #  @field bot Field.
    bot = NULL,

    #  @description Initialize AllowSendMessageRequest
    # 
    #  @param bot TypeInputUser or identifier
    initialize = function(bot) {
      self$bot <- bot
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  Resolves bot via client$get_input_entity and utils$get_input_user.
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user
    #  @return invisible(self)
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$bot)
      self$bot <- utils$get_input_user(input_entity)
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      list(
        `_` = "AllowSendMessageRequest",
        bot = bot_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'\xef\xe32\xf1')
      ctor <- as.raw(c(0xEF, 0xE3, 0x32, 0xF1))

      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          bot_bytes <- serialize_string_simple(as.character(self$bot))
        }
      }

      c(ctor, bot_bytes)
    }
  )
)

# static-like constructor from reader
AllowSendMessageRequest$from_reader <- function(reader) {
  bot_obj <- reader$tgread_object()
  AllowSendMessageRequest$new(bot = bot_obj)
}


#  AnswerWebhookJSONQueryRequest R6 class
# 
#  Represents the AnswerWebhookJSONQueryRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title AnswerWebhookJSONQueryRequest
#  @description Telegram API type AnswerWebhookJSONQueryRequest
#  @export
#  @noRd
#  @noRd
AnswerWebhookJSONQueryRequest <- R6::R6Class(
  "AnswerWebhookJSONQueryRequest",
  public = list(
    #  @field query_id Field.
    query_id = NULL,
    #  @field data Field.
    data = NULL,

    #  @description Initialize AnswerWebhookJSONQueryRequest
    # 
    #  @param query_id numeric/integer (64-bit)
    #  @param data TypeDataJSON or representation
    initialize = function(query_id, data) {
      self$query_id <- as.numeric(query_id)
      self$data <- data
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      data_val <- if (inherits(self$data, "R6") && "to_list" %in% names(self$data)) {
        self$data$to_list()
      } else {
        self$data
      }
      list(
        `_` = "AnswerWebhookJSONQueryRequest",
        query_id = self$query_id,
        data = data_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      # pack 64-bit little-endian integer (uses numeric arithmetic; precise up to 2^53)
      pack_int64_le <- function(x) {
        if (is.null(x)) {
          return(raw(0))
        }
        xnum <- as.numeric(x)
        bytes <- raw(8)
        for (i in 0:7) {
          byte_val <- floor(xnum / (256^i)) %% 256
          bytes[i + 1] <- as.raw(byte_val)
        }
        bytes
      }

      # data serialization helper
      data_bytes <- raw(0)
      if (!is.null(self$data)) {
        if (inherits(self$data, "R6") && "to_bytes" %in% names(self$data)) {
          data_bytes <- self$data$to_bytes()
        } else if (inherits(self$data, "R6") && "_bytes" %in% names(self$data)) {
          data_bytes <- self$data$`_bytes`()
        } else if (is.raw(self$data)) {
          data_bytes <- self$data
        } else {
          # fallback: simple string serialization (4-byte length + bytes)
          pack_int32 <- function(x) {
            con <- rawConnection(raw(0), "r+")
            on.exit(close(con))
            if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
            rawConnectionValue(con)
          }
          s_raw <- charToRaw(enc2utf8(as.character(self$data)))
          data_bytes <- c(pack_int32(length(s_raw)), s_raw)
        }
      }

      # constructor id bytes (from Python: b'M?!\xe6' -> 0x4D 0x3F 0x21 0xE6)
      ctor <- as.raw(c(0x4D, 0x3F, 0x21, 0xE6))

      c(ctor, pack_int64_le(self$query_id), data_bytes)
    }
  )
)

# static-like constructor from reader
AnswerWebhookJSONQueryRequest$from_reader <- function(reader) {
  query_id_val <- reader$read_long()
  data_obj <- reader$tgread_object()
  AnswerWebhookJSONQueryRequest$new(query_id = query_id_val, data = data_obj)
}


#  CanSendMessageRequest R6 class
# 
#  Represents the CanSendMessageRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title CanSendMessageRequest
#  @description Telegram API type CanSendMessageRequest
#  @export
#  @noRd
#  @noRd
CanSendMessageRequest <- R6::R6Class(
  "CanSendMessageRequest",
  public = list(
    #  @field bot Field.
    bot = NULL,

    #  @description Initialize CanSendMessageRequest
    # 
    #  @param bot TypeInputUser or identifier
    initialize = function(bot) {
      self$bot <- bot
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  Resolves bot via client$get_input_entity and utils$get_input_user.
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user
    #  @return invisible(self)
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$bot)
      self$bot <- utils$get_input_user(input_entity)
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      list(
        `_` = "CanSendMessageRequest",
        bot = bot_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'\xe6\xf4Y\x13' -> 0xE6 0xF4 0x59 0x13)
      ctor <- as.raw(c(0xE6, 0xF4, 0x59, 0x13))

      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          bot_bytes <- serialize_string_simple(as.character(self$bot))
        }
      }

      c(ctor, bot_bytes)
    }
  )
)

# static-like constructor from reader
CanSendMessageRequest$from_reader <- function(reader) {
  bot_obj <- reader$tgread_object()
  CanSendMessageRequest$new(bot = bot_obj)
}


#  CheckDownloadFileParamsRequest R6 class
# 
#  Represents the CheckDownloadFileParamsRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title CheckDownloadFileParamsRequest
#  @description Telegram API type CheckDownloadFileParamsRequest
#  @export
#  @noRd
#  @noRd
CheckDownloadFileParamsRequest <- R6::R6Class(
  "CheckDownloadFileParamsRequest",
  public = list(
    #  @field bot Field.
    bot = NULL,
    #  @field file_name Field.
    file_name = NULL,
    #  @field url Field.
    url = NULL,

    #  @description Initialize CheckDownloadFileParamsRequest
    # 
    #  @param bot TypeInputUser or identifier
    #  @param file_name character
    #  @param url character
    initialize = function(bot, file_name, url) {
      self$bot <- bot
      self$file_name <- as.character(file_name)
      self$url <- as.character(url)
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  Resolves bot via client$get_input_entity and utils$get_input_user.
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user
    #  @return invisible(self)
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$bot)
      self$bot <- utils$get_input_user(input_entity)
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      list(
        `_` = "CheckDownloadFileParamsRequest",
        bot = bot_val,
        file_name = self$file_name,
        url = self$url
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'\x89u\x07P')
      ctor <- as.raw(c(0x89, 0x75, 0x07, 0x50))

      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          bot_bytes <- serialize_string_simple(as.character(self$bot))
        }
      }

      file_bytes <- serialize_string_simple(self$file_name)
      url_bytes <- serialize_string_simple(self$url)

      c(ctor, bot_bytes, file_bytes, url_bytes)
    }
  )
)

# static-like constructor from reader
CheckDownloadFileParamsRequest$from_reader <- function(reader) {
  bot_obj <- reader$tgread_object()
  file_name_val <- reader$tgread_string()
  url_val <- reader$tgread_string()
  CheckDownloadFileParamsRequest$new(bot = bot_obj, file_name = file_name_val, url = url_val)
}


#  DeletePreviewMediaRequest R6 class
# 
#  Represents the DeletePreviewMediaRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title DeletePreviewMediaRequest
#  @description Telegram API type DeletePreviewMediaRequest
#  @export
#  @noRd
#  @noRd
DeletePreviewMediaRequest <- R6::R6Class(
  "DeletePreviewMediaRequest",
  public = list(
    #  @field bot Field.
    bot = NULL,
    #  @field lang_code Field.
    lang_code = NULL,
    #  @field media Field.
    media = NULL,

    #  @description Initialize DeletePreviewMediaRequest
    # 
    #  @param bot TypeInputUser or identifier
    #  @param lang_code character
    #  @param media list of TypeInputMedia or objects
    initialize = function(bot, lang_code, media) {
      self$bot <- bot
      self$lang_code <- as.character(lang_code)
      self$media <- if (is.null(media)) list() else media
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  Resolves bot via client$get_input_entity and utils$get_input_user.
    #  Resolves each media entry via utils$get_input_media.
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user and get_input_media
    #  @return invisible(self)
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$bot)
      self$bot <- utils$get_input_user(input_entity)
      if (!is.null(self$media) && length(self$media) > 0) {
        resolved_list <- lapply(self$media, function(m) {
          if (!is.null(utils$get_input_media)) {
            utils$get_input_media(m)
          } else {
            m
          }
        })
        self$media <- resolved_list
      }
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      media_val <- if (is.null(self$media)) {
        list()
      } else {
        lapply(self$media, function(x) {
          if (inherits(x, "R6") && "to_list" %in% names(x)) x$to_list() else x
        })
      }
      list(
        `_` = "DeletePreviewMediaRequest",
        bot = bot_val,
        lang_code = self$lang_code,
        media = media_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'\xb35\x01-')
      ctor <- as.raw(c(0xB3, 0x35, 0x01, 0x2D))

      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          bot_bytes <- serialize_string_simple(as.character(self$bot))
        }
      }

      lang_bytes <- serialize_string_simple(self$lang_code)

      # vector header for media: constructor 0x1cb5c415 stored little-endian as bytes b'\x15\xc4\xb5\x1c'
      vector_magic <- as.raw(c(0x15, 0xC4, 0xB5, 0x1C))
      count <- length(self$media)
      media_bytes <- raw(0)
      if (count > 0) {
        media_list_bytes <- lapply(self$media, function(m) {
          if (inherits(m, "R6") && "to_bytes" %in% names(m)) {
            m$to_bytes()
          } else if (inherits(m, "R6") && "_bytes" %in% names(m)) {
            m$`_bytes`()
          } else if (is.raw(m)) {
            m
          } else {
            # fallback: serialize as string blob
            s_raw <- charToRaw(enc2utf8(as.character(m)))
            c(pack_int32(length(s_raw)), s_raw)
          }
        })
        media_bytes <- do.call(c, media_list_bytes)
      }

      c(ctor, bot_bytes, lang_bytes, vector_magic, pack_int32(count), media_bytes)
    }
  )
)

# static-like constructor from reader
DeletePreviewMediaRequest$from_reader <- function(reader) {
  bot_obj <- reader$tgread_object()
  lang_code_val <- reader$tgread_string()
  # read vector magic then count
  reader$read_int()
  count_val <- reader$read_int()
  media_list <- list()
  if (count_val > 0) {
    for (i in seq_len(count_val)) {
      media_list[[i]] <- reader$tgread_object()
    }
  }
  DeletePreviewMediaRequest$new(bot = bot_obj, lang_code = lang_code_val, media = media_list)
}


#  EditPreviewMediaRequest R6 class
# 
#  Represents the EditPreviewMediaRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title EditPreviewMediaRequest
#  @description Telegram API type EditPreviewMediaRequest
#  @export
#  @noRd
#  @noRd
EditPreviewMediaRequest <- R6::R6Class(
  "EditPreviewMediaRequest",
  public = list(
    #  @field bot Field.
    bot = NULL,
    #  @field lang_code Field.
    lang_code = NULL,
    #  @field media Field.
    media = NULL,
    #  @field new_media Field.
    new_media = NULL,

    #  @description Initialize EditPreviewMediaRequest
    # 
    #  @param bot TypeInputUser or identifier
    #  @param lang_code character
    #  @param media TypeInputMedia or object
    #  @param new_media TypeInputMedia or object
    initialize = function(bot, lang_code, media, new_media) {
      self$bot <- bot
      self$lang_code <- as.character(lang_code)
      self$media <- media
      self$new_media <- new_media
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  Resolves bot via client$get_input_entity and utils$get_input_user;
    #  resolves media and new_media via utils$get_input_media.
    # 
    #  @param client client with get_input_entity method (synchronous)
    #  @param utils utils with get_input_user and get_input_media
    #  @return invisible(self)
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$bot)
      self$bot <- utils$get_input_user(input_entity)
      if (!is.null(self$media) && !is.null(utils$get_input_media)) {
        self$media <- utils$get_input_media(self$media)
      }
      if (!is.null(self$new_media) && !is.null(utils$get_input_media)) {
        self$new_media <- utils$get_input_media(self$new_media)
      }
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      media_val <- if (inherits(self$media, "R6") && "to_list" %in% names(self$media)) {
        self$media$to_list()
      } else {
        self$media
      }
      new_media_val <- if (inherits(self$new_media, "R6") && "to_list" %in% names(self$new_media)) {
        self$new_media$to_list()
      } else {
        self$new_media
      }
      list(
        `_` = "EditPreviewMediaRequest",
        bot = bot_val,
        lang_code = self$lang_code,
        media = media_val,
        new_media = new_media_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'o`%\x85')
      ctor <- as.raw(c(0x6F, 0x60, 0x25, 0x85))

      # bot bytes
      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          bot_bytes <- serialize_string_simple(as.character(self$bot))
        }
      }

      lang_bytes <- serialize_string_simple(self$lang_code)

      media_bytes <- raw(0)
      if (!is.null(self$media)) {
        if (inherits(self$media, "R6") && "to_bytes" %in% names(self$media)) {
          media_bytes <- self$media$to_bytes()
        } else if (inherits(self$media, "R6") && "_bytes" %in% names(self$media)) {
          media_bytes <- self$media$`_bytes`()
        } else if (is.raw(self$media)) {
          media_bytes <- self$media
        } else {
          media_bytes <- serialize_string_simple(as.character(self$media))
        }
      }

      new_media_bytes <- raw(0)
      if (!is.null(self$new_media)) {
        if (inherits(self$new_media, "R6") && "to_bytes" %in% names(self$new_media)) {
          new_media_bytes <- self$new_media$to_bytes()
        } else if (inherits(self$new_media, "R6") && "_bytes" %in% names(self$new_media)) {
          new_media_bytes <- self$new_media$`_bytes`()
        } else if (is.raw(self$new_media)) {
          new_media_bytes <- self$new_media
        } else {
          new_media_bytes <- serialize_string_simple(as.character(self$new_media))
        }
      }

      c(ctor, bot_bytes, lang_bytes, media_bytes, new_media_bytes)
    }
  )
)

# static-like constructor from reader
EditPreviewMediaRequest$from_reader <- function(reader) {
  bot_obj <- reader$tgread_object()
  lang_code_val <- reader$tgread_string()
  media_obj <- reader$tgread_object()
  new_media_obj <- reader$tgread_object()
  EditPreviewMediaRequest$new(bot = bot_obj, lang_code = lang_code_val, media = media_obj, new_media = new_media_obj)
}


#  @title GetAdminedBotsRequest R6 class
#  @description Represents the GetAdminedBotsRequest TL request.
#  @export
#  @noRd
#  @noRd
GetAdminedBotsRequest <- R6::R6Class(
  "GetAdminedBotsRequest",
  public = list(
    #  @description Initialize GetAdminedBotsRequest
    initialize = function() {
      invisible(self)
    },

    #  @description Convert to list (dictionary-like)
    #  @return list
    to_list = function() {
      list(`_` = "GetAdminedBotsRequest")
    },

    #  @description Serialize to bytes (raw vector)
    #  @return raw
    to_bytes = function() {
      # constructor id bytes (from Python: b'\x83\x1dq\xb0')
      ctor <- as.raw(c(0x83, 0x1D, 0x71, 0xB0))
      ctor
    }
  )
)

# static-like constructor from reader
GetAdminedBotsRequest$from_reader <- function(reader) {
  GetAdminedBotsRequest$new()
}


#  GetBotCommandsRequest R6 class
# 
#  Represents the GetBotCommandsRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title GetBotCommandsRequest
#  @description Telegram API type GetBotCommandsRequest
#  @export
#  @noRd
#  @noRd
GetBotCommandsRequest <- R6::R6Class(
  "GetBotCommandsRequest",
  public = list(
    #  @field scope Field.
    scope = NULL,
    #  @field lang_code Field.
    lang_code = NULL,

    #  @description Initialize GetBotCommandsRequest
    # 
    #  @param scope TypeBotCommandScope or object
    #  @param lang_code character
    initialize = function(scope, lang_code) {
      self$scope <- scope
      self$lang_code <- as.character(lang_code)
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      scope_val <- if (inherits(self$scope, "R6") && "to_list" %in% names(self$scope)) {
        self$scope$to_list()
      } else {
        self$scope
      }
      list(
        `_` = "GetBotCommandsRequest",
        scope = scope_val,
        lang_code = self$lang_code
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'\xd6\rL\xe3')
      ctor <- as.raw(c(0xD6, 0x0D, 0x4C, 0xE3))

      scope_bytes <- raw(0)
      if (!is.null(self$scope)) {
        if (inherits(self$scope, "R6") && "to_bytes" %in% names(self$scope)) {
          scope_bytes <- self$scope$to_bytes()
        } else if (inherits(self$scope, "R6") && "_bytes" %in% names(self$scope)) {
          scope_bytes <- self$scope$`_bytes`()
        } else if (is.raw(self$scope)) {
          scope_bytes <- self$scope
        } else {
          scope_bytes <- serialize_string_simple(as.character(self$scope))
        }
      }

      lang_bytes <- serialize_string_simple(self$lang_code)

      c(ctor, scope_bytes, lang_bytes)
    }
  )
)

# static-like constructor from reader
GetBotCommandsRequest$from_reader <- function(reader) {
  scope_obj <- reader$tgread_object()
  lang_code_val <- reader$tgread_string()
  GetBotCommandsRequest$new(scope = scope_obj, lang_code = lang_code_val)
}


#  GetBotInfoRequest R6 class
# 
#  Represents the GetBotInfoRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title GetBotInfoRequest
#  @description Telegram API type GetBotInfoRequest
#  @export
#  @noRd
#  @noRd
GetBotInfoRequest <- R6::R6Class(
  "GetBotInfoRequest",
  public = list(
    #  @field lang_code Field.
    lang_code = NULL,
    #  @field bot Field.
    bot = NULL,

    #  @description Initialize GetBotInfoRequest
    # 
    #  @param lang_code character
    #  @param bot TypeInputUser or identifier (optional)
    initialize = function(lang_code, bot = NULL) {
      self$lang_code <- as.character(lang_code)
      self$bot <- if (!is.null(bot)) bot else NULL
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  If bot is provided, resolves it via client$get_input_entity and utils$get_input_user.
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user
    #  @return invisible(self)
    resolve = function(client, utils) {
      if (!is.null(self$bot)) {
        input_entity <- client$get_input_entity(self$bot)
        self$bot <- utils$get_input_user(input_entity)
      }
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      list(
        `_` = "GetBotInfoRequest",
        lang_code = self$lang_code,
        bot = bot_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  Writes flags (uint32) indicating presence of bot, optional bot bytes, then lang_code.
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      pack_uint32 <- pack_int32
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'\xfd\x14\xd9\xdc')
      ctor <- as.raw(c(0xFD, 0x14, 0xD9, 0xDC))

      flags_val <- 0L
      if (!is.null(self$bot)) flags_val <- bitwOr(flags_val, 1L)

      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          s_raw <- charToRaw(enc2utf8(as.character(self$bot)))
          bot_bytes <- c(pack_int32(length(s_raw)), s_raw)
        }
      }

      lang_bytes <- serialize_string_simple(self$lang_code)

      c(ctor, pack_uint32(flags_val), bot_bytes, lang_bytes)
    }
  )
)

# static-like constructor from reader
GetBotInfoRequest$from_reader <- function(reader) {
  flags_val <- reader$read_int()
  bot_obj <- if (bitwAnd(flags_val, 1L) != 0L) reader$tgread_object() else NULL
  lang_code_val <- reader$tgread_string()
  GetBotInfoRequest$new(lang_code = lang_code_val, bot = bot_obj)
}


#  GetBotMenuButtonRequest R6 class
# 
#  Represents the GetBotMenuButtonRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title GetBotMenuButtonRequest
#  @description Telegram API type GetBotMenuButtonRequest
#  @export
#  @noRd
#  @noRd
GetBotMenuButtonRequest <- R6::R6Class(
  "GetBotMenuButtonRequest",
  public = list(
    #  @field user_id Field.
    user_id = NULL,

    #  @description Initialize GetBotMenuButtonRequest
    # 
    #  @param user_id TypeInputUser or identifier
    initialize = function(user_id) {
      self$user_id <- user_id
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  Converts user_id via client$get_input_entity and utils$get_input_user.
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user
    #  @return invisible(self)
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$user_id)
      self$user_id <- utils$get_input_user(input_entity)
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      user_val <- if (inherits(self$user_id, "R6") && "to_list" %in% names(self$user_id)) {
        self$user_id$to_list()
      } else {
        self$user_id
      }
      list(
        `_` = "GetBotMenuButtonRequest",
        user_id = user_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      # helper to pack 4-byte little-endian integers
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'(\xeb`\x9c')
      ctor <- as.raw(c(0x28, 0xEB, 0x60, 0x9C))

      user_bytes <- raw(0)
      if (!is.null(self$user_id)) {
        if (inherits(self$user_id, "R6") && "to_bytes" %in% names(self$user_id)) {
          user_bytes <- self$user_id$to_bytes()
        } else if (inherits(self$user_id, "R6") && "_bytes" %in% names(self$user_id)) {
          user_bytes <- self$user_id$`_bytes`()
        } else if (is.raw(self$user_id)) {
          user_bytes <- self$user_id
        } else {
          user_bytes <- serialize_string_simple(as.character(self$user_id))
        }
      }

      c(ctor, user_bytes)
    }
  )
)

# static-like constructor from reader
GetBotMenuButtonRequest$from_reader <- function(reader) {
  user_obj <- reader$tgread_object()
  GetBotMenuButtonRequest$new(user_id = user_obj)
}


#  GetBotRecommendationsRequest R6 class
# 
#  Represents the GetBotRecommendationsRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title GetBotRecommendationsRequest
#  @description Telegram API type GetBotRecommendationsRequest
#  @export
#  @noRd
#  @noRd
GetBotRecommendationsRequest <- R6::R6Class(
  "GetBotRecommendationsRequest",
  public = list(
    #  @field bot Field.
    bot = NULL,

    #  @description Initialize GetBotRecommendationsRequest
    # 
    #  @param bot TypeInputUser or identifier
    initialize = function(bot) {
      self$bot <- bot
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  Resolves bot via client$get_input_entity and utils$get_input_user.
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user
    #  @return invisible(self)
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$bot)
      self$bot <- utils$get_input_user(input_entity)
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      list(
        `_` = "GetBotRecommendationsRequest",
        bot = bot_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'\x15\x08\xb7\xa1')
      ctor <- as.raw(c(0x15, 0x08, 0xB7, 0xA1))

      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          bot_bytes <- serialize_string_simple(as.character(self$bot))
        }
      }

      c(ctor, bot_bytes)
    }
  )
)

# static-like constructor from reader
GetBotRecommendationsRequest$from_reader <- function(reader) {
  bot_obj <- reader$tgread_object()
  GetBotRecommendationsRequest$new(bot = bot_obj)
}


#  GetPopularAppBotsRequest R6 class
# 
#  Represents the GetPopularAppBotsRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title GetPopularAppBotsRequest
#  @description Telegram API type GetPopularAppBotsRequest
#  @export
#  @noRd
#  @noRd
GetPopularAppBotsRequest <- R6::R6Class(
  "GetPopularAppBotsRequest",
  public = list(
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,

    #  @description Initialize GetPopularAppBotsRequest
    # 
    #  @param offset character offset
    #  @param limit integer
    initialize = function(offset, limit) {
      self$offset <- if (!is.null(offset)) as.character(offset) else NULL
      self$limit <- as.integer(limit)
      invisible(self)
    },

    #  Resolve references (no-op for this request)
    # 
    #  @param client unused
    #  @param utils unused
    #  @return invisible(self)
    resolve = function(client = NULL, utils = NULL) {
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "GetPopularAppBotsRequest",
        offset = self$offset,
        limit = self$limit
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'\x92\x01Q\xc2')
      ctor <- as.raw(c(0x92, 0x01, 0x51, 0xC2))

      offset_bytes <- serialize_string_simple(self$offset)
      limit_bytes <- pack_int32(self$limit)

      c(ctor, offset_bytes, limit_bytes)
    }
  )
)

# static-like constructor from reader
GetPopularAppBotsRequest$from_reader <- function(reader) {
  offset_val <- reader$tgread_string()
  limit_val <- reader$read_int()
  GetPopularAppBotsRequest$new(offset = offset_val, limit = limit_val)
}


#  GetPreviewInfoRequest R6 class
# 
#  Represents the GetPreviewInfoRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title GetPreviewInfoRequest
#  @description Telegram API type GetPreviewInfoRequest
#  @export
#  @noRd
#  @noRd
GetPreviewInfoRequest <- R6::R6Class(
  "GetPreviewInfoRequest",
  public = list(
    #  @field bot Field.
    bot = NULL,
    #  @field lang_code Field.
    lang_code = NULL,

    #  @description Initialize GetPreviewInfoRequest
    # 
    #  @param bot TypeInputUser or identifier
    #  @param lang_code character
    initialize = function(bot, lang_code) {
      self$bot <- bot
      self$lang_code <- as.character(lang_code)
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  Resolves bot using client$get_input_entity and utils$get_input_user.
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user
    #  @return invisible(self)
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$bot)
      self$bot <- utils$get_input_user(input_entity)
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      list(
        `_` = "GetPreviewInfoRequest",
        bot = bot_val,
        lang_code = self$lang_code
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'\xad\xb3:B')
      ctor <- as.raw(c(0xAD, 0xB3, 0x3A, 0x42))

      # bot bytes
      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          bot_bytes <- serialize_string_simple(as.character(self$bot))
        }
      }

      lang_bytes <- serialize_string_simple(self$lang_code)

      c(ctor, bot_bytes, lang_bytes)
    }
  )
)

# static-like constructor from reader
GetPreviewInfoRequest$from_reader <- function(reader) {
  bot_obj <- reader$tgread_object()
  lang_code_val <- reader$tgread_string()
  GetPreviewInfoRequest$new(bot = bot_obj, lang_code = lang_code_val)
}


#  GetPreviewMediasRequest R6 class
# 
#  Represents the GetPreviewMediasRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title GetPreviewMediasRequest
#  @description Telegram API type GetPreviewMediasRequest
#  @export
#  @noRd
#  @noRd
GetPreviewMediasRequest <- R6::R6Class(
  "GetPreviewMediasRequest",
  public = list(
    #  @field bot Field.
    bot = NULL,

    #  @description Initialize GetPreviewMediasRequest
    # 
    #  @param bot TypeInputUser or identifier
    initialize = function(bot) {
      self$bot <- bot
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  Uses client$get_input_entity and utils$get_input_user to convert bot.
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user
    #  @return invisible(self)
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$bot)
      self$bot <- utils$get_input_user(input_entity)
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      list(
        `_` = "GetPreviewMediasRequest",
        bot = bot_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'MY\xa5\xa2')
      ctor <- as.raw(c(0x4D, 0x59, 0xA5, 0xA2))

      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          bot_bytes <- serialize_string_simple(as.character(self$bot))
        }
      }

      c(ctor, bot_bytes)
    }
  )
)

# static-like constructor from reader
GetPreviewMediasRequest$from_reader <- function(reader) {
  bot_obj <- reader$tgread_object()
  GetPreviewMediasRequest$new(bot = bot_obj)
}


#  InvokeWebViewCustomMethodRequest R6 class
# 
#  Represents the InvokeWebViewCustomMethodRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title InvokeWebViewCustomMethodRequest
#  @description Telegram API type InvokeWebViewCustomMethodRequest
#  @export
#  @noRd
#  @noRd
InvokeWebViewCustomMethodRequest <- R6::R6Class(
  "InvokeWebViewCustomMethodRequest",
  public = list(
    #  @field bot Field.
    bot = NULL,
    #  @field custom_method Field.
    custom_method = NULL,
    #  @field params Field.
    params = NULL,

    #  @description Initialize InvokeWebViewCustomMethodRequest
    # 
    #  @param bot TypeInputUser or identifier
    #  @param custom_method character
    #  @param params TypeDataJSON or object
    initialize = function(bot, custom_method, params) {
      self$bot <- bot
      self$custom_method <- as.character(custom_method)
      self$params <- params
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  Resolves bot via client$get_input_entity and utils$get_input_user.
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user
    #  @return invisible(self)
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$bot)
      self$bot <- utils$get_input_user(input_entity)
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      params_val <- if (inherits(self$params, "R6") && "to_list" %in% names(self$params)) {
        self$params$to_list()
      } else {
        self$params
      }
      list(
        `_` = "InvokeWebViewCustomMethodRequest",
        bot = bot_val,
        custom_method = self$custom_method,
        params = params_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'\xe7\xc5\x7f\x08')
      ctor <- as.raw(c(0xE7, 0xC5, 0x7F, 0x08))

      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          bot_bytes <- serialize_string_simple(as.character(self$bot))
        }
      }

      method_bytes <- serialize_string_simple(self$custom_method)

      params_bytes <- raw(0)
      if (!is.null(self$params)) {
        if (inherits(self$params, "R6") && "to_bytes" %in% names(self$params)) {
          params_bytes <- self$params$to_bytes()
        } else if (inherits(self$params, "R6") && "_bytes" %in% names(self$params)) {
          params_bytes <- self$params$`_bytes`()
        } else if (is.raw(self$params)) {
          params_bytes <- self$params
        } else {
          params_bytes <- serialize_string_simple(as.character(self$params))
        }
      }

      c(ctor, bot_bytes, method_bytes, params_bytes)
    }
  )
)

# static-like constructor from reader
InvokeWebViewCustomMethodRequest$from_reader <- function(reader) {
  bot_obj <- reader$tgread_object()
  custom_method_val <- reader$tgread_string()
  params_obj <- reader$tgread_object()
  InvokeWebViewCustomMethodRequest$new(bot = bot_obj, custom_method = custom_method_val, params = params_obj)
}


#  ReorderPreviewMediasRequest R6 class
# 
#  Represents the ReorderPreviewMediasRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title ReorderPreviewMediasRequest
#  @description Telegram API type ReorderPreviewMediasRequest
#  @export
#  @noRd
#  @noRd
ReorderPreviewMediasRequest <- R6::R6Class(
  "ReorderPreviewMediasRequest",
  public = list(
    #  @field bot Field.
    bot = NULL,
    #  @field lang_code Field.
    lang_code = NULL,
    #  @field order Field.
    order = NULL,

    #  @description Initialize ReorderPreviewMediasRequest
    # 
    #  @param bot TypeInputUser or identifier
    #  @param lang_code character
    #  @param order list of TypeInputMedia or objects
    initialize = function(bot, lang_code, order) {
      self$bot <- bot
      self$lang_code <- as.character(lang_code)
      self$order <- if (is.null(order)) list() else order
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user / get_input_media
    #  @return invisible(self)
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$bot)
      self$bot <- utils$get_input_user(input_entity)
      if (!is.null(self$order) && length(self$order) > 0) {
        resolved <- lapply(self$order, function(x) {
          # if x is an R6 object that already represents input media, keep it
          if (!is.null(utils$get_input_media) && !inherits(x, "raw")) {
            utils$get_input_media(x)
          } else {
            x
          }
        })
        self$order <- resolved
      }
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      order_val <- if (is.null(self$order)) {
        list()
      } else {
        lapply(self$order, function(x) {
          if (inherits(x, "R6") && "to_list" %in% names(x)) x$to_list() else x
        })
      }
      list(
        `_` = "ReorderPreviewMediasRequest",
        bot = bot_val,
        lang_code = self$lang_code,
        order = order_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b"\xaa\xf3'\xb6")
      ctor <- as.raw(c(0xAA, 0xF3, 0x27, 0xB6))

      # bot bytes
      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          bot_bytes <- serialize_string_simple(as.character(self$bot))
        }
      }

      lang_bytes <- serialize_string_simple(self$lang_code)

      # vector header for order: constructor 0x1cb5c415 stored as b'\x15\xc4\xb5\x1c'
      vector_magic <- as.raw(c(0x15, 0xC4, 0xB5, 0x1C))
      count <- length(self$order)
      order_bytes <- raw(0)
      if (count > 0) {
        media_bytes_list <- lapply(self$order, function(m) {
          if (inherits(m, "R6") && "to_bytes" %in% names(m)) {
            m$to_bytes()
          } else if (inherits(m, "R6") && "_bytes" %in% names(m)) {
            m$`_bytes`()
          } else if (is.raw(m)) {
            m
          } else {
            # fallback: serialize as string
            s_raw <- charToRaw(enc2utf8(as.character(m)))
            c(pack_int32(length(s_raw)), s_raw)
          }
        })
        order_bytes <- do.call(c, media_bytes_list)
      }

      c(ctor, bot_bytes, lang_bytes, vector_magic, pack_int32(count), order_bytes)
    }
  )
)

# static-like constructor from reader
ReorderPreviewMediasRequest$from_reader <- function(reader) {
  bot_obj <- reader$tgread_object()
  lang_code_val <- reader$tgread_string()
  # read vector magic then count
  reader$read_int()
  count_val <- reader$read_int()
  order_list <- list()
  if (count_val > 0) {
    for (i in seq_len(count_val)) {
      media_obj <- reader$tgread_object()
      order_list[[i]] <- media_obj
    }
  }
  ReorderPreviewMediasRequest$new(bot = bot_obj, lang_code = lang_code_val, order = order_list)
}


#  ReorderUsernamesRequest R6 class
# 
#  @title ReorderUsernamesRequest
#  @description Telegram API type ReorderUsernamesRequest
#  @export
#  @noRd
#  @noRd
ReorderUsernamesRequest <- R6::R6Class(
  "ReorderUsernamesRequest",
  public = list(
    #  @field bot Field.
    bot = NULL,
    #  @field order Field.
    order = NULL,

    #  @description Initialize ReorderUsernamesRequest
    # 
    #  @param bot TypeInputUser or identifier
    #  @param order list of character
    initialize = function(bot, order) {
      self$bot <- bot
      self$order <- if (is.null(order)) list() else order
      invisible(self)
    },

    #  @description Resolve references (convert entities via client/utils)
    # 
    #  @param client client with get_input_entity method
    #  @return invisible(self)
    resolve = function(client) {
      input_entity <- client$get_input_entity(self$bot)
      self$bot <- get_input_user(input_entity)
      invisible(self)
    },

    #  @description Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      list(
        `_` = "ReorderUsernamesRequest",
        bot = bot_val,
        order = self$order
      )
    },

    #  @description Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'\xc2\xb1\t\x97')
      ctor <- as.raw(c(0xC2, 0xB1, 0x09, 0x97))

      # bot bytes
      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          bot_bytes <- serialize_string_simple(as.character(self$bot))
        }
      }

      # vector header for order: constructor 0x1cb5c415 stored as b'\x15\xc4\xb5\x1c'
      vector_magic <- as.raw(c(0x15, 0xC4, 0xB5, 0x1C))
      count <- length(self$order)
      order_bytes <- raw(0)
      if (count > 0) {
        name_bytes_list <- lapply(self$order, function(nm) {
          serialize_string_simple(as.character(nm))
        })
        order_bytes <- do.call(c, name_bytes_list)
      }

      c(ctor, bot_bytes, vector_magic, pack_int32(count), order_bytes)
    }
  )
)

# static-like constructor from reader
ReorderUsernamesRequest$from_reader <- function(reader) {
  bot_obj <- reader$tgread_object()
  # read vector magic then count
  reader$read_int()
  count_val <- reader$read_int()
  name_list <- list()
  if (count_val > 0) {
    for (i in seq_len(count_val)) {
      name_list[[i]] <- reader$tgread_string()
    }
  }
  ReorderUsernamesRequest$new(bot = bot_obj, order = name_list)
}


#  ResetBotCommandsRequest R6 class
# 
#  Represents the ResetBotCommandsRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title ResetBotCommandsRequest
#  @description Telegram API type ResetBotCommandsRequest
#  @export
#  @noRd
#  @noRd
ResetBotCommandsRequest <- R6::R6Class(
  "ResetBotCommandsRequest",
  public = list(
    #  @field scope Field.
    scope = NULL,
    #  @field lang_code Field.
    lang_code = NULL,

    #  @description Initialize ResetBotCommandsRequest
    # 
    #  @param scope TypeBotCommandScope or object
    #  @param lang_code character
    initialize = function(scope, lang_code) {
      self$scope <- scope
      self$lang_code <- as.character(lang_code)
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  Some request types require resolving entities via client/utils.
    #  For this request there is no standard entity resolution required,
    #  so this is a no-op but kept for API consistency.
    # 
    #  @param client client (unused)
    #  @param utils utils (unused)
    resolve = function(client = NULL, utils = NULL) {
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      scope_val <- if (inherits(self$scope, "R6") && "to_list" %in% names(self$scope)) {
        self$scope$to_list()
      } else {
        self$scope
      }
      list(
        `_` = "ResetBotCommandsRequest",
        scope = scope_val,
        lang_code = self$lang_code
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'\xf9\xe0\x8d=')
      ctor <- as.raw(c(0xF9, 0xE0, 0x8D, 0x3D))

      # scope bytes
      scope_bytes <- raw(0)
      if (!is.null(self$scope)) {
        if (inherits(self$scope, "R6") && "to_bytes" %in% names(self$scope)) {
          scope_bytes <- self$scope$to_bytes()
        } else if (inherits(self$scope, "R6") && "_bytes" %in% names(self$scope)) {
          scope_bytes <- self$scope$`_bytes`()
        } else if (is.raw(self$scope)) {
          scope_bytes <- self$scope
        } else {
          scope_bytes <- serialize_string_simple(as.character(self$scope))
        }
      }

      lang_bytes <- serialize_string_simple(self$lang_code)

      c(ctor, scope_bytes, lang_bytes)
    }
  )
)

# static-like constructor from reader
ResetBotCommandsRequest$from_reader <- function(reader) {
  scope_obj <- reader$tgread_object()
  lang_code_val <- reader$tgread_string()
  ResetBotCommandsRequest$new(scope = scope_obj, lang_code = lang_code_val)
}


#  SendCustomRequestRequest R6 class
# 
#  Represents the SendCustomRequestRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title SendCustomRequestRequest
#  @description Telegram API type SendCustomRequestRequest
#  @export
#  @noRd
#  @noRd
SendCustomRequestRequest <- R6::R6Class(
  "SendCustomRequestRequest",
  public = list(
    #  @field custom_method Field.
    custom_method = NULL,
    #  @field params Field.
    params = NULL,

    #  @description Initialize SendCustomRequestRequest
    # 
    #  @param custom_method character
    #  @param params TypeDataJSON or object
    initialize = function(custom_method, params) {
      self$custom_method <- as.character(custom_method)
      self$params <- params
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  For this request no entity resolution is required; kept for API consistency.
    # 
    #  @param client client (unused)
    #  @param utils utils (unused)
    resolve = function(client = NULL, utils = NULL) {
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      params_val <- if (inherits(self$params, "R6") && "to_list" %in% names(self$params)) {
        self$params$to_list()
      } else {
        self$params
      }
      list(
        `_` = "SendCustomRequestRequest",
        custom_method = self$custom_method,
        params = params_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'\xed i'\xaa' -> b'\xed i'\x27\xaa' )
      ctor <- as.raw(c(0xED, 0x69, 0x27, 0xAA))

      method_bytes <- serialize_string_simple(self$custom_method)

      params_bytes <- raw(0)
      if (!is.null(self$params)) {
        if (inherits(self$params, "R6") && "to_bytes" %in% names(self$params)) {
          params_bytes <- self$params$to_bytes()
        } else if (inherits(self$params, "R6") && "_bytes" %in% names(self$params)) {
          params_bytes <- self$params$`_bytes`()
        } else if (is.raw(self$params)) {
          params_bytes <- self$params
        } else {
          # fallback: serialize as string
          params_bytes <- serialize_string_simple(as.character(self$params))
        }
      }

      c(ctor, method_bytes, params_bytes)
    }
  )
)

# static-like constructor from reader
SendCustomRequestRequest$from_reader <- function(reader) {
  custom_method_val <- reader$tgread_string()
  params_obj <- reader$tgread_object()
  SendCustomRequestRequest$new(custom_method = custom_method_val, params = params_obj)
}


#  SetBotBroadcastDefaultAdminRightsRequest R6 class
# 
#  Represents the SetBotBroadcastDefaultAdminRightsRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title SetBotBroadcastDefaultAdminRightsRequest
#  @description Telegram API type SetBotBroadcastDefaultAdminRightsRequest
#  @export
#  @noRd
#  @noRd
SetBotBroadcastDefaultAdminRightsRequest <- R6::R6Class(
  "SetBotBroadcastDefaultAdminRightsRequest",
  public = list(
    #  @field admin_rights Field.
    admin_rights = NULL,

    #  @description Initialize SetBotBroadcastDefaultAdminRightsRequest
    # 
    #  @param admin_rights TypeChatAdminRights or object
    initialize = function(admin_rights) {
      self$admin_rights <- admin_rights
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      admin_val <- if (inherits(self$admin_rights, "R6") && "to_list" %in% names(self$admin_rights)) {
        self$admin_rights$to_list()
      } else {
        self$admin_rights
      }
      list(
        `_` = "SetBotBroadcastDefaultAdminRightsRequest",
        admin_rights = admin_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }

      # constructor id bytes (from Python: b'\xe1d\x84x')
      ctor <- as.raw(c(0xE1, 0x64, 0x84, 0x78))

      admin_bytes <- raw(0)
      if (!is.null(self$admin_rights)) {
        if (inherits(self$admin_rights, "R6") && "to_bytes" %in% names(self$admin_rights)) {
          admin_bytes <- self$admin_rights$to_bytes()
        } else if (inherits(self$admin_rights, "R6") && "_bytes" %in% names(self$admin_rights)) {
          admin_bytes <- self$admin_rights$`_bytes`()
        } else if (is.raw(self$admin_rights)) {
          admin_bytes <- self$admin_rights
        } else {
          s_raw <- charToRaw(enc2utf8(as.character(self$admin_rights)))
          admin_bytes <- c(pack_int32(length(s_raw)), s_raw)
        }
      }

      c(ctor, admin_bytes)
    }
  )
)

# static-like constructor from reader
SetBotBroadcastDefaultAdminRightsRequest$from_reader <- function(reader) {
  admin_obj <- reader$tgread_object()
  SetBotBroadcastDefaultAdminRightsRequest$new(admin_rights = admin_obj)
}


#  SetBotCommandsRequest R6 class
# 
#  Represents the SetBotCommandsRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title SetBotCommandsRequest
#  @description Telegram API type SetBotCommandsRequest
#  @export
#  @noRd
#  @noRd
SetBotCommandsRequest <- R6::R6Class(
  "SetBotCommandsRequest",
  public = list(
    #  @field scope Field.
    scope = NULL,
    #  @field lang_code Field.
    lang_code = NULL,
    #  @field commands Field.
    commands = NULL,

    #  @description Initialize SetBotCommandsRequest
    # 
    #  @param scope TypeBotCommandScope or object
    #  @param lang_code character
    #  @param commands list of TypeBotCommand or objects
    initialize = function(scope, lang_code, commands) {
      self$scope <- scope
      self$lang_code <- as.character(lang_code)
      self$commands <- if (is.null(commands)) list() else commands
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  Some request types require resolving entities via client/utils.
    #  For this request there is no standard entity resolution required,
    #  so this is a no-op but kept for API consistency.
    # 
    #  @param client client (unused)
    #  @param utils utils (unused)
    resolve = function(client = NULL, utils = NULL) {
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      scope_val <- if (inherits(self$scope, "R6") && "to_list" %in% names(self$scope)) {
        self$scope$to_list()
      } else {
        self$scope
      }
      commands_val <- if (is.null(self$commands)) {
        list()
      } else {
        lapply(self$commands, function(x) {
          if (inherits(x, "R6") && "to_list" %in% names(x)) x$to_list() else x
        })
      }
      list(
        `_` = "SetBotCommandsRequest",
        scope = scope_val,
        lang_code = self$lang_code,
        commands = commands_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'Z\x16\x17\x05')
      ctor <- as.raw(c(0x5A, 0x16, 0x17, 0x05))

      # scope bytes
      scope_bytes <- raw(0)
      if (!is.null(self$scope)) {
        if (inherits(self$scope, "R6") && "to_bytes" %in% names(self$scope)) {
          scope_bytes <- self$scope$to_bytes()
        } else if (inherits(self$scope, "R6") && "_bytes" %in% names(self$scope)) {
          scope_bytes <- self$scope$`_bytes`()
        } else if (is.raw(self$scope)) {
          scope_bytes <- self$scope
        } else {
          scope_bytes <- serialize_string_simple(as.character(self$scope))
        }
      }

      lang_bytes <- serialize_string_simple(self$lang_code)

      # vector header for commands: constructor 0x1cb5c415 stored little-endian as bytes b'\x15\xc4\xb5\x1c'
      vector_magic <- as.raw(c(0x15, 0xC4, 0xB5, 0x1C))
      count <- length(self$commands)
      commands_bytes <- raw(0)
      if (count > 0) {
        cmd_list_bytes <- lapply(self$commands, function(cmd) {
          if (inherits(cmd, "R6") && "to_bytes" %in% names(cmd)) {
            cmd$to_bytes()
          } else if (inherits(cmd, "R6") && "_bytes" %in% names(cmd)) {
            cmd$`_bytes`()
          } else if (is.raw(cmd)) {
            cmd
          } else {
            # fallback: serialize as string blob
            s_raw <- charToRaw(enc2utf8(as.character(cmd)))
            c(pack_int32(length(s_raw)), s_raw)
          }
        })
        commands_bytes <- do.call(c, cmd_list_bytes)
      }

      c(ctor, scope_bytes, lang_bytes, vector_magic, pack_int32(count), commands_bytes)
    }
  )
)

# static-like constructor from reader
SetBotCommandsRequest$from_reader <- function(reader) {
  scope_obj <- reader$tgread_object()
  lang_code_val <- reader$tgread_string()
  # read vector magic then count
  vector_magic_val <- reader$read_int()
  count_val <- reader$read_int()
  commands_list <- list()
  if (count_val > 0) {
    for (i in seq_len(count_val)) {
      cmd_obj <- reader$tgread_object()
      commands_list[[i]] <- cmd_obj
    }
  }
  SetBotCommandsRequest$new(scope = scope_obj, lang_code = lang_code_val, commands = commands_list)
}


#  SetBotGroupDefaultAdminRightsRequest R6 class
# 
#  Represents the SetBotGroupDefaultAdminRightsRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title SetBotGroupDefaultAdminRightsRequest
#  @description Telegram API type SetBotGroupDefaultAdminRightsRequest
#  @export
#  @noRd
#  @noRd
SetBotGroupDefaultAdminRightsRequest <- R6::R6Class(
  "SetBotGroupDefaultAdminRightsRequest",
  public = list(
    #  @field admin_rights Field.
    admin_rights = NULL,

    #  @description Initialize SetBotGroupDefaultAdminRightsRequest
    # 
    #  @param admin_rights TypeChatAdminRights or object
    initialize = function(admin_rights) {
      self$admin_rights <- admin_rights
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      admin_val <- if (inherits(self$admin_rights, "R6") && "to_list" %in% names(self$admin_rights)) {
        self$admin_rights$to_list()
      } else {
        self$admin_rights
      }
      list(
        `_` = "SetBotGroupDefaultAdminRightsRequest",
        admin_rights = admin_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      # constructor id bytes (from Python: b'\xea\xc9^\x92')
      ctor <- as.raw(c(0xEA, 0xC9, 0x5E, 0x92))

      admin_bytes <- raw(0)
      if (!is.null(self$admin_rights)) {
        if (inherits(self$admin_rights, "R6") && "to_bytes" %in% names(self$admin_rights)) {
          admin_bytes <- self$admin_rights$to_bytes()
        } else if (inherits(self$admin_rights, "R6") && "_bytes" %in% names(self$admin_rights)) {
          admin_bytes <- self$admin_rights$`_bytes`()
        } else if (is.raw(self$admin_rights)) {
          admin_bytes <- self$admin_rights
        } else {
          # fallback: serialize as string
          s_raw <- charToRaw(enc2utf8(as.character(self$admin_rights)))
          admin_bytes <- c(pack_int32(length(s_raw)), s_raw)
        }
      }

      c(ctor, admin_bytes)
    }
  )
)

# static-like constructor from reader
SetBotGroupDefaultAdminRightsRequest$from_reader <- function(reader) {
  admin_rights_obj <- reader$tgread_object()
  SetBotGroupDefaultAdminRightsRequest$new(admin_rights = admin_rights_obj)
}


#  SetBotInfoRequest R6 class
# 
#  Represents the SetBotInfoRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title SetBotInfoRequest
#  @description Telegram API type SetBotInfoRequest
#  @export
#  @noRd
#  @noRd
SetBotInfoRequest <- R6::R6Class(
  "SetBotInfoRequest",
  public = list(
    #  @field lang_code Field.
    lang_code = NULL,
    #  @field bot Field.
    bot = NULL,
    #  @field name Field.
    name = NULL,
    #  @field about Field.
    about = NULL,
    #  @field description Field.
    description = NULL,

    #  @description Initialize SetBotInfoRequest
    # 
    #  @param lang_code character
    #  @param bot TypeInputUser or identifier (optional)
    #  @param name character (optional)
    #  @param about character (optional)
    #  @param description character (optional)
    initialize = function(lang_code, bot = NULL, name = NULL, about = NULL, description = NULL) {
      self$lang_code <- as.character(lang_code)
      self$bot <- if (!is.null(bot)) bot else NULL
      self$name <- if (!is.null(name)) as.character(name) else NULL
      self$about <- if (!is.null(about)) as.character(about) else NULL
      self$description <- if (!is.null(description)) as.character(description) else NULL
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user
    resolve = function(client, utils) {
      if (!is.null(self$bot)) {
        input_entity <- client$get_input_entity(self$bot)
        self$bot <- utils$get_input_user(input_entity)
      }
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      list(
        `_` = "SetBotInfoRequest",
        lang_code = self$lang_code,
        bot = bot_val,
        name = self$name,
        about = self$about,
        description = self$description
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'#1\xcf\x10')
      ctor <- as.raw(c(0x23, 0x31, 0xCF, 0x10))

      flags_val <- 0L
      if (!is.null(self$bot)) flags_val <- bitwOr(flags_val, 4L)
      if (!is.null(self$name)) flags_val <- bitwOr(flags_val, 8L)
      if (!is.null(self$about)) flags_val <- bitwOr(flags_val, 1L)
      if (!is.null(self$description)) flags_val <- bitwOr(flags_val, 2L)

      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          s_raw <- charToRaw(enc2utf8(as.character(self$bot)))
          bot_bytes <- c(pack_int32(length(s_raw)), s_raw)
        }
      }

      lang_bytes <- serialize_string_simple(self$lang_code)
      name_bytes <- if (!is.null(self$name)) serialize_string_simple(self$name) else raw(0)
      about_bytes <- if (!is.null(self$about)) serialize_string_simple(self$about) else raw(0)
      description_bytes <- if (!is.null(self$description)) serialize_string_simple(self$description) else raw(0)

      c(ctor, pack_int32(flags_val), bot_bytes, lang_bytes, name_bytes, about_bytes, description_bytes)
    }
  )
)

# static-like constructor from reader
SetBotInfoRequest$from_reader <- function(reader) {
  flags_val <- reader$read_int()
  bot_obj <- if (bitwAnd(flags_val, 4L) != 0L) reader$tgread_object() else NULL
  lang_code_val <- reader$tgread_string()
  name_val <- if (bitwAnd(flags_val, 8L) != 0L) reader$tgread_string() else NULL
  about_val <- if (bitwAnd(flags_val, 1L) != 0L) reader$tgread_string() else NULL
  description_val <- if (bitwAnd(flags_val, 2L) != 0L) reader$tgread_string() else NULL
  SetBotInfoRequest$new(lang_code = lang_code_val, bot = bot_obj, name = name_val, about = about_val, description = description_val)
}


#  SetBotMenuButtonRequest R6 class
# 
#  Represents the SetBotMenuButtonRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title SetBotMenuButtonRequest
#  @description Telegram API type SetBotMenuButtonRequest
#  @export
#  @noRd
#  @noRd
SetBotMenuButtonRequest <- R6::R6Class(
  "SetBotMenuButtonRequest",
  public = list(
    #  @field user_id Field.
    user_id = NULL,
    #  @field button Field.
    button = NULL,

    #  @description Initialize SetBotMenuButtonRequest
    # 
    #  @param user_id TypeInputUser or identifier
    #  @param button TypeBotMenuButton or object
    initialize = function(user_id, button) {
      self$user_id <- user_id
      self$button <- button
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$user_id)
      self$user_id <- utils$get_input_user(input_entity)
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      user_val <- if (inherits(self$user_id, "R6") && "to_list" %in% names(self$user_id)) {
        self$user_id$to_list()
      } else {
        self$user_id
      }
      button_val <- if (inherits(self$button, "R6") && "to_list" %in% names(self$button)) {
        self$button$to_list()
      } else {
        self$button
      }
      list(
        `_` = "SetBotMenuButtonRequest",
        user_id = user_val,
        button = button_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'O\xd5\x04E')
      ctor <- as.raw(c(0x4F, 0xD5, 0x04, 0x45))

      # user_id bytes
      user_bytes <- raw(0)
      if (!is.null(self$user_id)) {
        if (inherits(self$user_id, "R6") && "to_bytes" %in% names(self$user_id)) {
          user_bytes <- self$user_id$to_bytes()
        } else if (inherits(self$user_id, "R6") && "_bytes" %in% names(self$user_id)) {
          user_bytes <- self$user_id$`_bytes`()
        } else if (is.raw(self$user_id)) {
          user_bytes <- self$user_id
        } else {
          user_bytes <- serialize_string_simple(as.character(self$user_id))
        }
      }

      # button bytes
      button_bytes <- raw(0)
      if (!is.null(self$button)) {
        if (inherits(self$button, "R6") && "to_bytes" %in% names(self$button)) {
          button_bytes <- self$button$to_bytes()
        } else if (inherits(self$button, "R6") && "_bytes" %in% names(self$button)) {
          button_bytes <- self$button$`_bytes`()
        } else if (is.raw(self$button)) {
          button_bytes <- self$button
        } else {
          button_bytes <- serialize_string_simple(as.character(self$button))
        }
      }

      c(ctor, user_bytes, button_bytes)
    }
  )
)

# static-like constructor from reader
SetBotMenuButtonRequest$from_reader <- function(reader) {
  user_obj <- reader$tgread_object()
  button_obj <- reader$tgread_object()
  SetBotMenuButtonRequest$new(user_id = user_obj, button = button_obj)
}


#  SetCustomVerificationRequest R6 class
# 
#  Represents the SetCustomVerificationRequest TL request.
# 
# 
# 
#  @title SetCustomVerificationRequest
#  @description Telegram API type SetCustomVerificationRequest
#  @export
#  @noRd
#  @noRd
SetCustomVerificationRequest <- R6::R6Class(
  "SetCustomVerificationRequest",
  public = list(
    #  @field peer Field.
    peer = NULL,
    #  @field enabled Field.
    enabled = NULL,
    #  @field bot Field.
    bot = NULL,
    #  @field custom_description Field.
    custom_description = NULL,

    #  @description Initialize SetCustomVerificationRequest
    # 
    #  @param peer TypeInputPeer or identifier
    #  @param enabled logical|null
    #  @param bot TypeInputUser or identifier|null
    #  @param custom_description character|null
    initialize = function(peer, enabled = NULL, bot = NULL, custom_description = NULL) {
      self$peer <- peer
      if (!is.null(enabled)) self$enabled <- as.logical(enabled)
      self$bot <- bot
      if (!is.null(custom_description)) self$custom_description <- as.character(custom_description)
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user / get_input_peer
    resolve = function(client, utils) {
      input_peer <- client$get_input_entity(self$peer)
      self$peer <- utils$get_input_peer(input_peer)
      if (!is.null(self$bot)) {
        input_bot <- client$get_input_entity(self$bot)
        self$bot <- utils$get_input_user(input_bot)
      }
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      peer_val <- if (inherits(self$peer, "R6") && "to_list" %in% names(self$peer)) {
        self$peer$to_list()
      } else {
        self$peer
      }
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      list(
        `_` = "SetCustomVerificationRequest",
        peer = peer_val,
        enabled = self$enabled,
        bot = bot_val,
        custom_description = self$custom_description
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      pack_uint32 <- pack_int32
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'\xbd\xdf\x89\x8b')
      ctor <- as.raw(c(0xBD, 0xDF, 0x89, 0x8B))

      flags_val <- 0L
      if (!is.null(self$enabled)) flags_val <- bitwOr(flags_val, 2L)
      if (!is.null(self$bot)) flags_val <- bitwOr(flags_val, 1L)
      if (!is.null(self$custom_description)) flags_val <- bitwOr(flags_val, 4L)

      # bot bytes (optional)
      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          bot_bytes <- serialize_string_simple(as.character(self$bot))
        }
      }

      # peer bytes (required)
      peer_bytes <- raw(0)
      if (!is.null(self$peer)) {
        if (inherits(self$peer, "R6") && "to_bytes" %in% names(self$peer)) {
          peer_bytes <- self$peer$to_bytes()
        } else if (inherits(self$peer, "R6") && "_bytes" %in% names(self$peer)) {
          peer_bytes <- self$peer$`_bytes`()
        } else if (is.raw(self$peer)) {
          peer_bytes <- self$peer
        } else {
          peer_bytes <- serialize_string_simple(as.character(self$peer))
        }
      }

      desc_bytes <- raw(0)
      if (!is.null(self$custom_description)) {
        desc_bytes <- serialize_string_simple(self$custom_description)
      }

      c(ctor, pack_uint32(flags_val), bot_bytes, peer_bytes, desc_bytes)
    }
  )
)

# static-like constructor from reader
SetCustomVerificationRequest$from_reader <- function(reader) {
  flags_val <- reader$read_int()
  enabled_val <- bitwAnd(flags_val, 2L) != 0L
  bot_obj <- if (bitwAnd(flags_val, 1L) != 0L) reader$tgread_object() else NULL
  peer_obj <- reader$tgread_object()
  custom_description <- if (bitwAnd(flags_val, 4L) != 0L) reader$tgread_string() else NULL
  SetCustomVerificationRequest$new(peer = peer_obj, enabled = enabled_val, bot = bot_obj, custom_description = custom_description)
}

#  ToggleUserEmojiStatusPermissionRequest R6 class
# 
#  Represents the ToggleUserEmojiStatusPermissionRequest TL request.
# 
# 
# 
#  Each method is documented inline below.
# 
#  @title ToggleUserEmojiStatusPermissionRequest
#  @description Telegram API type ToggleUserEmojiStatusPermissionRequest
#  @export
#  @noRd
#  @noRd
ToggleUserEmojiStatusPermissionRequest <- R6::R6Class(
  "ToggleUserEmojiStatusPermissionRequest",
  public = list(
    #  @field bot Field.
    bot = NULL,
    #  @field enabled Field.
    enabled = NULL,

    #  @description Initialize ToggleUserEmojiStatusPermissionRequest
    # 
    #  @param bot TypeInputUser or identifier
    #  @param enabled logical
    initialize = function(bot, enabled) {
      self$bot <- bot
      self$enabled <- as.logical(enabled)
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$bot)
      self$bot <- utils$get_input_user(input_entity)
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      list(
        `_` = "ToggleUserEmojiStatusPermissionRequest",
        bot = bot_val,
        enabled = self$enabled
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b'\x92c\xde\x06')
      ctor <- as.raw(c(0x92, 0x63, 0xDE, 0x06))

      # bot bytes
      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          bot_bytes <- serialize_string_simple(as.character(self$bot))
        }
      }

      # enabled: append 4-byte constructor-like constants
      enabled_bytes <- if (isTRUE(self$enabled)) {
        as.raw(c(0xB5, 0x75, 0x72, 0x99)) # b'\xb5ur\x99'
      } else {
        as.raw(c(0x37, 0x97, 0x79, 0xBC)) # b'7\x97y\xbc'
      }

      c(ctor, bot_bytes, enabled_bytes)
    }
  )
)

# static-like constructor from reader
ToggleUserEmojiStatusPermissionRequest$from_reader <- function(reader) {
  bot_obj <- reader$tgread_object()
  enabled_val <- reader$tgread_bool()
  ToggleUserEmojiStatusPermissionRequest$new(bot = bot_obj, enabled = enabled_val)
}


#  ToggleUsernameRequest R6 class
# 
#  Represents the ToggleUsernameRequest TL request.
# 
# 
# 
#  @title ToggleUsernameRequest
#  @description Telegram API type ToggleUsernameRequest
#  @export
#  @noRd
#  @noRd
ToggleUsernameRequest <- R6::R6Class(
  "ToggleUsernameRequest",
  public = list(
    #  @field bot Field.
    bot = NULL,
    #  @field username Field.
    username = NULL,
    #  @field active Field.
    active = NULL,

    #  @description Initialize ToggleUsernameRequest
    # 
    #  @param bot TypeInputUser or identifier
    #  @param username character
    #  @param active logical
    initialize = function(bot, username, active) {
      self$bot <- bot
      self$username <- as.character(username)
      self$active <- as.logical(active)
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$bot)
      self$bot <- utils$get_input_user(input_entity)
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      list(
        `_` = "ToggleUsernameRequest",
        bot = bot_val,
        username = self$username,
        active = self$active
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (from Python: b's\xa9<\x05')
      ctor <- as.raw(c(0x73, 0xA9, 0x3C, 0x05))

      # bot bytes
      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          bot_bytes <- serialize_string_simple(as.character(self$bot))
        }
      }

      username_bytes <- serialize_string_simple(self$username)

      active_bytes <- if (isTRUE(self$active)) {
        as.raw(c(0xB5, 0x75, 0x72, 0x99)) # b'\xb5ur\x99'
      } else {
        as.raw(c(0x37, 0x97, 0x79, 0xBC)) # b'7\x97y\xbc'
      }

      c(ctor, bot_bytes, username_bytes, active_bytes)
    }
  )
)

# static-like constructor from reader
ToggleUsernameRequest$from_reader <- function(reader) {
  bot_obj <- reader$tgread_object()
  username_val <- reader$tgread_string()
  active_val <- reader$tgread_bool()
  ToggleUsernameRequest$new(bot = bot_obj, username = username_val, active = active_val)
}


#  UpdateStarRefProgramRequest R6 class
# 
#  Represents the UpdateStarRefProgramRequest TL request.
# 
# 
# 
#  @title UpdateStarRefProgramRequest
#  @description Telegram API type UpdateStarRefProgramRequest
#  @export
#  @noRd
#  @noRd
UpdateStarRefProgramRequest <- R6::R6Class(
  "UpdateStarRefProgramRequest",
  public = list(
    #  @field bot Field.
    bot = NULL,
    #  @field commission_permille Field.
    commission_permille = NULL,
    #  @field duration_months Field.
    duration_months = NULL,

    #  @description Initialize UpdateStarRefProgramRequest
    # 
    #  @param bot TypeInputUser or identifier
    #  @param commission_permille integer
    #  @param duration_months integer|null
    initialize = function(bot, commission_permille, duration_months = NULL) {
      self$bot <- bot
      self$commission_permille <- as.integer(commission_permille)
      if (!is.null(duration_months)) self$duration_months <- as.integer(duration_months)
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user
    resolve = function(client, utils) {
      # assumes client$get_input_entity and utils$get_input_user are synchronous functions
      input_entity <- client$get_input_entity(self$bot)
      self$bot <- utils$get_input_user(input_entity)
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      bot_val <- if (inherits(self$bot, "R6") && "to_list" %in% names(self$bot)) {
        self$bot$to_list()
      } else {
        self$bot
      }
      list(
        `_` = "UpdateStarRefProgramRequest",
        bot = bot_val,
        commission_permille = self$commission_permille,
        duration_months = self$duration_months
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      # helpers
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }
      pack_uint32 <- pack_int32
      serialize_string_simple <- function(s) {
        if (is.null(s)) {
          return(raw(0))
        }
        s_raw <- charToRaw(enc2utf8(as.character(s)))
        # naive serialization: 4-byte length + bytes (OK for many use-cases)
        c(pack_int32(length(s_raw)), s_raw)
      }

      # constructor id bytes (little-endian sequence as in Python file)
      ctor <- as.raw(c(0xb3, 0x5a, 0x8b, 0x77))
      flags_val <- if (is.null(self$duration_months)) 0L else 1L

      # bot bytes (attempt common methods)
      bot_bytes <- raw(0)
      if (!is.null(self$bot)) {
        if (inherits(self$bot, "R6") && "to_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$to_bytes()
        } else if (inherits(self$bot, "R6") && "_bytes" %in% names(self$bot)) {
          bot_bytes <- self$bot$`_bytes`()
        } else if (is.raw(self$bot)) {
          bot_bytes <- self$bot
        } else {
          # fallback: to_list -> serialize as string
          bot_bytes <- serialize_string_simple(as.character(self$bot))
        }
      }

      commission_bytes <- pack_int32(self$commission_permille)
      duration_bytes <- if (flags_val == 1L) pack_int32(self$duration_months) else raw(0)

      c(ctor, pack_uint32(flags_val), bot_bytes, commission_bytes, duration_bytes)
    }
  )
)

# static-like constructor from reader for UpdateStarRefProgramRequest
UpdateStarRefProgramRequest$from_reader <- function(reader) {
  # reader is expected to implement read_int() and tgread_object()
  flags_val <- reader$read_int()
  bot_obj <- reader$tgread_object()
  commission_val <- reader$read_int()
  duration_val <- if (bitwAnd(flags_val, 1L) != 0L) reader$read_int() else NULL
  UpdateStarRefProgramRequest$new(bot = bot_obj, commission_permille = commission_val, duration_months = duration_val)
}


#  UpdateUserEmojiStatusRequest R6 class
# 
#  Represents the UpdateUserEmojiStatusRequest TL request.
# 
# 
# 
#  @title UpdateUserEmojiStatusRequest
#  @description Telegram API type UpdateUserEmojiStatusRequest
#  @export
#  @noRd
#  @noRd
UpdateUserEmojiStatusRequest <- R6::R6Class(
  "UpdateUserEmojiStatusRequest",
  public = list(
    #  @field user_id Field.
    user_id = NULL,
    #  @field emoji_status Field.
    emoji_status = NULL,

    #  @description Initialize UpdateUserEmojiStatusRequest
    # 
    #  @param user_id TypeInputUser or identifier
    #  @param emoji_status TypeEmojiStatus object
    initialize = function(user_id, emoji_status) {
      self$user_id <- user_id
      self$emoji_status <- emoji_status
      invisible(self)
    },

    #  Resolve references (convert entities via client/utils)
    # 
    #  @param client client with get_input_entity method
    #  @param utils utils with get_input_user / get_input_media etc
    resolve = function(client, utils) {
      input_entity <- client$get_input_entity(self$user_id)
      self$user_id <- utils$get_input_user(input_entity)
      invisible(self)
    },

    #  Convert to list (dictionary-like)
    # 
    #  @return list
    to_list = function() {
      user_val <- if (inherits(self$user_id, "R6") && "to_list" %in% names(self$user_id)) {
        self$user_id$to_list()
      } else {
        self$user_id
      }
      emoji_val <- if (inherits(self$emoji_status, "R6") && "to_list" %in% names(self$emoji_status)) {
        self$emoji_status$to_list()
      } else {
        self$emoji_status
      }
      list(
        `_` = "UpdateUserEmojiStatusRequest",
        user_id = user_val,
        emoji_status = emoji_val
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      pack_int32 <- function(x) {
        con <- rawConnection(raw(0), "r+")
        on.exit(close(con))
        if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con, size = 4L, endian = "little")
        rawConnectionValue(con)
      }

      ctor <- as.raw(c(0xc5, 0x30, 0x9f, 0xed)) # bytes from Python (b'\xc50\x9f\xed') note ordering
      # user_id bytes
      user_bytes <- raw(0)
      if (!is.null(self$user_id)) {
        if (inherits(self$user_id, "R6") && "to_bytes" %in% names(self$user_id)) {
          user_bytes <- self$user_id$to_bytes()
        } else if (inherits(self$user_id, "R6") && "_bytes" %in% names(self$user_id)) {
          user_bytes <- self$user_id$`_bytes`()
        } else {
          user_bytes <- pack_int32(as.integer(self$user_id))
        }
      }

      emoji_bytes <- raw(0)
      if (!is.null(self$emoji_status)) {
        if (inherits(self$emoji_status, "R6") && "to_bytes" %in% names(self$emoji_status)) {
          emoji_bytes <- self$emoji_status$to_bytes()
        } else if (inherits(self$emoji_status, "R6") && "_bytes" %in% names(self$emoji_status)) {
          emoji_bytes <- self$emoji_status$`_bytes`()
        } else {
          emoji_bytes <- charToRaw(as.character(self$emoji_status))
        }
      }

      c(ctor, user_bytes, emoji_bytes)
    }
  )
)

# static-like constructor from reader for UpdateUserEmojiStatusRequest
UpdateUserEmojiStatusRequest$from_reader <- function(reader) {
  user_obj <- reader$tgread_object()
  emoji_obj <- reader$tgread_object()
  UpdateUserEmojiStatusRequest$new(user_id = user_obj, emoji_status = emoji_obj)
}
