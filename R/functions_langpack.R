#  GetDifferenceRequest R6 class
# 
#  TLRequest: GetDifferenceRequest
# 
#  @title GetDifferenceRequest
#  @description Telegram API type GetDifferenceRequest
#  @export
#  @noRd
#  @noRd
GetDifferenceRequest <- R6::R6Class(
  "GetDifferenceRequest",
  inherit = TLRequest,
  public = list(
    #  @field lang_pack Field.
    lang_pack = NULL,
    #  @field lang_code Field.
    lang_code = NULL,
    #  @field from_version Field.
    from_version = NULL,

    #  @description Initialize GetDifferenceRequest
    #  @param lang_pack character Language pack identifier
    #  @param lang_code character Language code
    #  @param from_version integer Version to get difference from
    initialize = function(lang_pack, lang_code, from_version) {
      self$lang_pack <- lang_pack
      self$lang_code <- lang_code
      self$from_version <- as.integer(from_version)
    },

    #  @description Convert to a serializable R list (similar to to_dict)
    #  @return list
    to_dict = function() {
      list(
        "_" = "GetDifferenceRequest",
        lang_pack = self$lang_pack,
        lang_code = self$lang_code,
        from_version = self$from_version
      )
    },

    #  @description Serialize to raw bytes
    #  @return raw vector
    bytes = function() {
      version_raw <- writeBin(as.integer(self$from_version), raw(), size = 4, endian = "little")
      c(
        as.raw(c(0xa5, 0x4a, 0x98, 0xcd)),
        self$serialize_bytes(self$lang_pack),
        self$serialize_bytes(self$lang_code),
        version_raw
      )
    },

    #  @description Create an instance from a reader
    #  @param reader A reader object with methods tgread_string() and read_int()
    #  @return A GetDifferenceRequest object
    from_reader = function(reader) {
      lang_pack <- reader$tgread_string()
      lang_code <- reader$tgread_string()
      from_version <- reader$read_int()
      GetDifferenceRequest$new(lang_pack = lang_pack, lang_code = lang_code, from_version = from_version)
    }
  )
)


#  GetLangPackRequest R6 class
# 
#  TLRequest: GetLangPackRequest
# 
#  @title GetLangPackRequest
#  @description Telegram API type GetLangPackRequest
#  @export
#  @noRd
#  @noRd
GetLangPackRequest <- R6::R6Class(
  "GetLangPackRequest",
  inherit = TLRequest,
  public = list(
    #  @field lang_pack Field.
    lang_pack = NULL,
    #  @field lang_code Field.
    lang_code = NULL,

    #  @description Initialize GetLangPackRequest
    #  @param lang_pack character Language pack identifier
    #  @param lang_code character Language code
    initialize = function(lang_pack, lang_code) {
      self$lang_pack <- lang_pack
      self$lang_code <- lang_code
    },

    #  @description Convert to a serializable R list (similar to to_dict)
    #  @return list
    to_dict = function() {
      list("_" = "GetLangPackRequest", lang_pack = self$lang_pack, lang_code = self$lang_code)
    },

    #  @description Serialize to raw bytes
    #  @return raw vector
    bytes = function() {
      c(
        as.raw(c(0x0a, 0x33, 0xf2, 0xf2)),
        self$serialize_bytes(self$lang_pack),
        self$serialize_bytes(self$lang_code)
      )
    },

    #  @description Create an instance from a reader
    #  @param reader A reader object with method tgread_string()
    #  @return A GetLangPackRequest object
    from_reader = function(reader) {
      lang_pack <- reader$tgread_string()
      lang_code <- reader$tgread_string()
      GetLangPackRequest$new(lang_pack = lang_pack, lang_code = lang_code)
    }
  )
)

#  GetLanguageRequest R6 class
# 
#  TLRequest: GetLanguageRequest
# 
#  @title GetLanguageRequest
#  @description Telegram API type GetLanguageRequest
#  @export
#  @noRd
#  @noRd
GetLanguageRequest <- R6::R6Class(
  "GetLanguageRequest",
  inherit = TLRequest,
  public = list(
    #  @field lang_pack Field.
    lang_pack = NULL,
    #  @field lang_code Field.
    lang_code = NULL,

    #  @description Initialize GetLanguageRequest
    #  @param lang_pack character Language pack identifier
    #  @param lang_code character Language code
    initialize = function(lang_pack, lang_code) {
      self$lang_pack <- lang_pack
      self$lang_code <- lang_code
    },

    #  @description Convert to a serializable R list (similar to to_dict)
    #  @return list
    to_dict = function() {
      list("_" = "GetLanguageRequest", lang_pack = self$lang_pack, lang_code = self$lang_code)
    },

    #  @description Serialize to raw bytes
    #  @return raw vector
    bytes = function() {
      c(
        as.raw(c(0x02, 0x65, 0x59, 0x6a)),
        self$serialize_bytes(self$lang_pack),
        self$serialize_bytes(self$lang_code)
      )
    },

    #  @description Create an instance from a reader
    #  @param reader A reader object with method tgread_string()
    #  @return A GetLanguageRequest object
    from_reader = function(reader) {
      lang_pack <- reader$tgread_string()
      lang_code <- reader$tgread_string()
      GetLanguageRequest$new(lang_pack = lang_pack, lang_code = lang_code)
    }
  )
)


#  GetLanguagesRequest R6 class
# 
#  TLRequest: GetLanguagesRequest
# 
#  @title GetLanguagesRequest
#  @description Telegram API type GetLanguagesRequest
#  @export
#  @noRd
#  @noRd
GetLanguagesRequest <- R6::R6Class(
  "GetLanguagesRequest",
  inherit = TLRequest,
  public = list(
    #  @field lang_pack Field.
    lang_pack = NULL,

    #  @description Initialize GetLanguagesRequest
    #  @param lang_pack character Language pack identifier
    initialize = function(lang_pack) {
      self$lang_pack <- lang_pack
    },

    #  @description Convert to a serializable R list (similar to to_dict)
    #  @return list
    to_dict = function() {
      list("_" = "GetLanguagesRequest", lang_pack = self$lang_pack)
    },

    #  @description Serialize to raw bytes
    #  @return raw vector
    bytes = function() {
      c(
        as.raw(c(0x8f, 0x97, 0xc6, 0x42)),
        self$serialize_bytes(self$lang_pack)
      )
    },

    #  @description Create an instance from a reader
    #  @param reader A reader object with method tgread_string()
    #  @return A GetLanguagesRequest object
    from_reader = function(reader) {
      lang_pack <- reader$tgread_string()
      GetLanguagesRequest$new(lang_pack = lang_pack)
    }
  )
)

#  GetStringsRequest R6 class
# 
#  TLRequest: GetStringsRequest
# 
#  @title GetStringsRequest
#  @description Telegram API type GetStringsRequest
#  @export
#  @noRd
#  @noRd
GetStringsRequest <- R6::R6Class(
  "GetStringsRequest",
  inherit = TLRequest,
  public = list(
    #  @field lang_pack Field.
    lang_pack = NULL,
    #  @field lang_code Field.
    lang_code = NULL,
    #  @field keys Field.
    keys = NULL,

    #  @description Initialize GetStringsRequest
    #  @param lang_pack character Language pack identifier
    #  @param lang_code character Language code
    #  @param keys character Vector of keys to request
    initialize = function(lang_pack, lang_code, keys) {
      self$lang_pack <- lang_pack
      self$lang_code <- lang_code
      self$keys <- keys
    },

    #  @description Convert to a serializable R list (similar to to_dict)
    #  @return list
    to_dict = function() {
      list(
        "_" = "GetStringsRequest",
        lang_pack = self$lang_pack,
        lang_code = self$lang_code,
        keys = if (is.null(self$keys)) character() else as.character(self$keys)
      )
    },

    #  @description Serialize to raw bytes
    #  @return raw vector
    bytes = function() {
      # vector constructor (little-endian): 0x1cb5c415 -> bytes 15 c4 b5 1c
      len_raw <- writeBin(as.integer(length(self$keys)), raw(), size = 4, endian = "little")
      keys_raw <- if (length(self$keys) == 0) raw() else do.call(c, lapply(self$keys, self$serialize_bytes))
      c(
        as.raw(c(0x03, 0x38, 0xea, 0xef)),
        self$serialize_bytes(self$lang_pack),
        self$serialize_bytes(self$lang_code),
        as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
        len_raw,
        keys_raw
      )
    },

    #  @description Create an instance from a reader
    #  @param reader A reader object with methods tgread_string() and read_int()
    #  @return A GetStringsRequest object
    from_reader = function(reader) {
      lang_pack <- reader$tgread_string()
      lang_code <- reader$tgread_string()
      # expecting vector constructor then count
      vector_magic <- reader$read_int()
      count <- reader$read_int()
      keys <- character(count)
      for (i in seq_len(count)) {
        keys[i] <- reader$tgread_string()
      }
      GetStringsRequest$new(lang_pack = lang_pack, lang_code = lang_code, keys = keys)
    }
  )
)
