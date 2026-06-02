#  AcceptContactRequest
# 
#  R6 representation of the TL request: AcceptContactRequest
# 
# 
#  @description
#  Methods:
#  - initialize(id): create new request
#  - resolve(client, utils): resolve id into input_user using client and utils
#  - to_list(): return a list representation suitable for JSON/dumping
#  - to_bytes(): return raw vector of bytes for the TL request
#  - from_reader(reader): read from reader and return new instance
#  @export
#  @noRd
#  @noRd
AcceptContactRequest <- R6::R6Class(
  "AcceptContactRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xf831a20f,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field id Field.
    id = NULL,

    #  @description Initialize AcceptContactRequest
    # 
    #  @param id input user object or identifier
    initialize = function(id) {
      self$id <- id
    },

    #  Resolve entities using client and utils
    # 
    #  Replaces `id` with utils$get_input_user(client$get_input_entity(id))
    #  @param client client object with method get_input_entity()
    #  @param utils utils object with method get_input_user()
    resolve = function(client, utils) {
      entity <- client$get_input_entity(self$id)
      self$id <- utils$get_input_user(entity)
      invisible(NULL)
    },

    #  Convert to list
    #  @return list
    to_list = function() {
      id_repr <- if (!is.null(self$id) && is.function(self$id$to_list)) self$id$to_list() else self$id
      list(`_` = "AcceptContactRequest", id = id_repr)
    },

    #  Serialize to bytes (raw vector)
    #  @return raw
    to_bytes = function() {
      # little-endian of 0xf831a20f -> 0x0f 0xa2 0x31 0xf8
      prefix <- as.raw(c(0x0f, 0xa2, 0x31, 0xf8))
      id_bytes <- NULL
      if (!is.null(self$id) && is.function(self$id$to_bytes)) {
        id_bytes <- self$id$to_bytes()
      } else if (!is.null(self$id) && is.raw(self$id)) {
        id_bytes <- self$id
      } else {
        stop("id must provide to_bytes() or be a raw vector")
      }
      c(prefix, id_bytes)
    }
  ),
  private = list(),
  active = list(),
  class = TRUE
)

# Create AcceptContactRequest from reader
# @name AcceptContactRequest_from_reader
#
# @param reader object with method tgread_object()
# @return AcceptContactRequest
AcceptContactRequest$from_reader <- function(reader) {
  id_val <- reader$tgread_object()
  AcceptContactRequest$new(id = id_val)
}


#  AddContactRequest
# 
#  R6 representation of the TL request: AddContactRequest
# 
# 
#  @description
#  Methods:
#  - initialize(id, first_name, last_name, phone, add_phone_privacy_exception = NULL): create new request
#  - resolve(client, utils): resolve id into input_user using client and utils
#  - to_list(): return a list representation suitable for JSON/dumping
#  - to_bytes(): return raw vector of bytes for the TL request
#  - from_reader(reader): read from reader and return new instance
#  @export
#  @noRd
#  @noRd
AddContactRequest <- R6::R6Class(
  "AddContactRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xe8f463d0,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field id Field.
    id = NULL,
    #  @field first_name Field.
    first_name = NULL,
    #  @field last_name Field.
    last_name = NULL,
    #  @field phone Field.
    phone = NULL,
    #  @field add_phone_privacy_exception Field.
    add_phone_privacy_exception = NULL,

    #  @description Initialize AddContactRequest
    # 
    #  @param id input user object or identifier
    #  @param first_name character
    #  @param last_name character
    #  @param phone character
    #  @param add_phone_privacy_exception logical or NULL
    initialize = function(id, first_name, last_name, phone, add_phone_privacy_exception = NULL) {
      self$id <- id
      self$first_name <- as.character(first_name)
      self$last_name <- as.character(last_name)
      self$phone <- as.character(phone)
      if (!is.null(add_phone_privacy_exception)) self$add_phone_privacy_exception <- as.logical(add_phone_privacy_exception) else self$add_phone_privacy_exception <- NULL
    },

    #  Resolve entities using client and utils
    # 
    #  Replaces `id` with utils$get_input_user(client$get_input_entity(id))
    #  @param client client object with method get_input_entity()
    #  @param utils utils object with method get_input_user()
    resolve = function(client, utils) {
      entity <- client$get_input_entity(self$id)
      self$id <- utils$get_input_user(entity)
      invisible(NULL)
    },

    #  Convert to list
    #  @return list
    to_list = function() {
      id_repr <- if (!is.null(self$id) && is.function(self$id$to_list)) self$id$to_list() else self$id
      list(
        `_` = "AddContactRequest",
        id = id_repr,
        first_name = self$first_name,
        last_name = self$last_name,
        phone = self$phone,
        add_phone_privacy_exception = self$add_phone_privacy_exception
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw
    to_bytes = function() {
      # little-endian of 0xe8f463d0 -> 0xd0 0x63 0xf4 0xe8
      prefix <- as.raw(c(0xd0, 0x63, 0xf4, 0xe8))
      flags_val <- 0L
      if (!is.null(self$add_phone_privacy_exception) && isTRUE(self$add_phone_privacy_exception)) flags_val <- bitwOr(flags_val, 1L)
      flags_raw <- private$int_to_le_raw(as.integer(flags_val), size = 4L)

      id_bytes <- NULL
      if (!is.null(self$id) && is.function(self$id$to_bytes)) {
        id_bytes <- self$id$to_bytes()
      } else if (!is.null(self$id) && is.raw(self$id)) {
        id_bytes <- self$id
      } else {
        stop("id must provide to_bytes() or be a raw vector")
      }

      first_name_bytes <- private$serialize_string_tl(self$first_name)
      last_name_bytes <- private$serialize_string_tl(self$last_name)
      phone_bytes <- private$serialize_string_tl(self$phone)

      c(prefix, flags_raw, id_bytes, first_name_bytes, last_name_bytes, phone_bytes)
    }
  ),
  private = list(
    #  Convert integer to little-endian raw vector of given size (bytes)
    int_to_le_raw = function(x, size = 4L) {
      xi <- as.integer(x)
      v <- raw(size)
      for (i in seq_len(size)) {
        v[i] <- as.raw(bitwAnd(bitwShiftR(xi, 8L * (i - 1L)), 0xff))
      }
      v
    },

    #  Serialize an R string to TL string bytes (per Telegram TL encoding)
    serialize_string_tl = function(s) {
      if (is.null(s)) {
        return(raw(0))
      }
      sb <- charToRaw(enc2utf8(as.character(s)))
      ln <- length(sb)
      if (ln < 254L) {
        header <- as.raw(ln)
        payload <- sb
        total <- 1 + ln
      } else {
        header <- as.raw(c(
          254L,
          as.raw(bitwAnd(ln, 0xff)),
          as.raw(bitwAnd(bitwShiftR(ln, 8L), 0xff)),
          as.raw(bitwAnd(bitwShiftR(ln, 16L), 0xff))
        ))
        payload <- sb
        total <- 4 + ln
      }
      pad_len <- (4L - (total %% 4L)) %% 4L
      padding <- if (pad_len > 0L) as.raw(rep(0, pad_len)) else raw(0)
      c(header, payload, padding)
    }
  ),
  active = list(),
  class = TRUE
)

# Create AddContactRequest from reader
# @name AddContactRequest_from_reader
#
# @param reader object with methods read_int(), tgread_object(), tgread_string()
# @return AddContactRequest
AddContactRequest$from_reader <- function(reader) {
  flagsVal <- reader$read_int()
  addPhonePrivacyExceptionFlag <- bitwAnd(flagsVal, 1L) != 0L
  id_val <- reader$tgread_object()
  firstNameVal <- reader$tgread_string()
  lastNameVal <- reader$tgread_string()
  phoneVal <- reader$tgread_string()
  AddContactRequest$new(
    id = id_val,
    first_name = firstNameVal,
    last_name = lastNameVal,
    phone = phoneVal,
    add_phone_privacy_exception = addPhonePrivacyExceptionFlag
  )
}


#  BlockRequest
# 
#  R6 representation of the TL request: BlockRequest
# 
# 
#  @description
#  Methods:
#  - initialize(id, my_stories_from = NULL): create new request
#  - resolve(client, utils): resolve id into input_peer using client and utils
#  - to_list(): return a list representation suitable for JSON/dumping
#  - to_bytes(): return raw vector of bytes for the TL request
#  @export
#  @noRd
#  @noRd
BlockRequest <- R6::R6Class(
  "BlockRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x2e2e8734,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field id Field.
    id = NULL,
    #  @field my_stories_from Field.
    my_stories_from = NULL,

    #  @description Initialize BlockRequest
    # 
    #  @param id input peer (object or identifier)
    #  @param my_stories_from logical or NULL
    initialize = function(id, my_stories_from = NULL) {
      self$id <- id
      if (!is.null(my_stories_from)) {
        self$my_stories_from <- as.logical(my_stories_from)
      } else {
        self$my_stories_from <- NULL
      }
    },

    #  Resolve entities using client and utils
    # 
    #  This will replace `id` with an input_peer object obtained via utils$get_input_peer(...)
    #  @param client client object with method get_input_entity()
    #  @param utils utils object with method get_input_peer()
    resolve = function(client, utils) {
      entity <- client$get_input_entity(self$id)
      self$id <- utils$get_input_peer(entity)
      invisible(NULL)
    },

    #  Convert to list
    # 
    #  @return list
    to_list = function() {
      id_repr <- if (inherits(self$id, "TLObject") || inherits(self$id, "R6")) {
        if (is.function(self$id$to_list)) self$id$to_list() else self$id
      } else {
        self$id
      }
      list(`_` = "BlockRequest", id = id_repr, my_stories_from = self$my_stories_from)
    },

    #  Serialize to bytes (raw vector)
    # 
    #  Packs flags as uint32 little-endian and appends id bytes.
    #  Assumes id has method to_bytes() which returns a raw vector or is a raw vector.
    # 
    #  @return raw
    to_bytes = function() {
      flags_val <- if (is.null(self$my_stories_from) || identical(self$my_stories_from, FALSE)) 0L else 1L
      prefix <- as.raw(c(0x34, 0x87, 0x2e, 0x2e)) # little-endian of 0x2e2e8734
      flags_raw <- private$int_to_le_raw(as.integer(flags_val), size = 4L)
      id_bytes <- NULL
      if (!is.null(self$id) && is.function(self$id$to_bytes)) {
        id_bytes <- self$id$to_bytes()
      } else if (!is.null(self$id) && is.raw(self$id)) {
        id_bytes <- self$id
      } else {
        stop("id must provide to_bytes() or be a raw vector")
      }
      c(prefix, flags_raw, id_bytes)
    }
  ),
  private = list(
    #  Convert integer to little-endian raw vector of given size (bytes)
    int_to_le_raw = function(x, size = 4L) {
      xi <- as.integer(x)
      v <- raw(size)
      for (i in seq_len(size)) {
        v[i] <- as.raw(bitwAnd(bitwShiftR(xi, 8L * (i - 1L)), 0xff))
      }
      v
    }
  ),
  active = list(),
  class = TRUE
)

# Create BlockRequest from reader
# @name BlockRequest_from_reader
#
# @param reader object that implements read_int() and tgread_object()
# @return BlockRequest
BlockRequest$from_reader <- function(reader) {
  flagsVal <- reader$read_int()
  myStoriesFlag <- bitwAnd(flagsVal, 1L) != 0L
  id_obj <- reader$tgread_object()
  BlockRequest$new(id = id_obj, my_stories_from = myStoriesFlag)
}


#  BlockFromRepliesRequest
# 
#  R6 representation of the TL request: BlockFromRepliesRequest
# 
# 
#  @description
#  Methods:
#  - initialize(msg_id, delete_message = NULL, delete_history = NULL, report_spam = NULL): create new request
#  - to_list(): return a list representation
#  - to_bytes(): return raw vector of bytes for the TL request
#  @export
#  @noRd
#  @noRd
BlockFromRepliesRequest <- R6::R6Class(
  "BlockFromRepliesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x29a8962c,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field msg_id Field.
    msg_id = NULL,
    #  @field delete_message Field.
    delete_message = NULL,
    #  @field delete_history Field.
    delete_history = NULL,
    #  @field report_spam Field.
    report_spam = NULL,

    #  @description Initialize BlockFromRepliesRequest
    # 
    #  @param msg_id integer message id
    #  @param delete_message logical or NULL
    #  @param delete_history logical or NULL
    #  @param report_spam logical or NULL
    initialize = function(msg_id, delete_message = NULL, delete_history = NULL, report_spam = NULL) {
      self$msg_id <- as.integer(msg_id)
      if (!is.null(delete_message)) self$delete_message <- as.logical(delete_message) else self$delete_message <- NULL
      if (!is.null(delete_history)) self$delete_history <- as.logical(delete_history) else self$delete_history <- NULL
      if (!is.null(report_spam)) self$report_spam <- as.logical(report_spam) else self$report_spam <- NULL
    },

    #  Convert to list
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "BlockFromRepliesRequest",
        msg_id = self$msg_id,
        delete_message = self$delete_message,
        delete_history = self$delete_history,
        report_spam = self$report_spam
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  Packs flags (uint32 little-endian) and msg_id as int32 little-endian.
    # 
    #  @return raw
    to_bytes = function() {
      prefix <- as.raw(c(0x2c, 0x96, 0xa8, 0x29)) # little-endian of 0x29a8962c
      flags_val <- 0L
      if (!is.null(self$delete_message) && isTRUE(self$delete_message)) flags_val <- bitwOr(flags_val, 1L)
      if (!is.null(self$delete_history) && isTRUE(self$delete_history)) flags_val <- bitwOr(flags_val, 2L)
      if (!is.null(self$report_spam) && isTRUE(self$report_spam)) flags_val <- bitwOr(flags_val, 4L)
      flags_raw <- private$int_to_le_raw(as.integer(flags_val), size = 4L)
      msg_id_raw <- private$int_to_le_raw(as.integer(self$msg_id), size = 4L)
      c(prefix, flags_raw, msg_id_raw)
    }
  ),
  private = list(
    #  Convert integer to little-endian raw vector of given size (bytes)
    int_to_le_raw = function(x, size = 4L) {
      xi <- as.integer(x)
      v <- raw(size)
      for (i in seq_len(size)) {
        v[i] <- as.raw(bitwAnd(bitwShiftR(xi, 8L * (i - 1L)), 0xff))
      }
      v
    }
  ),
  active = list(),
  class = TRUE
)

# Create BlockFromRepliesRequest from reader
# @name BlockFromRepliesRequest_from_reader
#
# @param reader object with methods read_int()
# @return BlockFromRepliesRequest
BlockFromRepliesRequest$from_reader <- function(reader) {
  flagsVal <- reader$read_int()
  deleteMessageFlag <- bitwAnd(flagsVal, 1L) != 0L
  deleteHistoryFlag <- bitwAnd(flagsVal, 2L) != 0L
  reportSpamFlag <- bitwAnd(flagsVal, 4L) != 0L
  msgIdVal <- reader$read_int()
  BlockFromRepliesRequest$new(
    msg_id = msgIdVal,
    delete_message = deleteMessageFlag,
    delete_history = deleteHistoryFlag,
    report_spam = reportSpamFlag
  )
}


#  DeleteByPhonesRequest
# 
#  R6 representation of the TL request: DeleteByPhonesRequest
# 
# 
#  @description
#  Methods:
#  - initialize(phones): create new request where phones is a character vector
#  - to_list(): return list representation
#  - to_bytes(): serialize to raw TL bytes (constructor + vector + strings)
#  @export
#  @noRd
#  @noRd
DeleteByPhonesRequest <- R6::R6Class(
  "DeleteByPhonesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x1013fd9e,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field phones Field.
    phones = NULL,

    #  @description Initialize DeleteByPhonesRequest
    # 
    #  @param phones character vector of phone strings
    initialize = function(phones) {
      if (is.null(phones)) {
        self$phones <- character(0)
      } else {
        self$phones <- as.character(phones)
      }
    },

    #  Convert to list
    # 
    #  @return list
    to_list = function() {
      list(`_` = "DeleteByPhonesRequest", phones = if (is.null(self$phones)) character(0) else as.character(self$phones))
    },

    #  Serialize to bytes (raw vector)
    # 
    #  Packs constructor id, TL vector constructor, count and serialized TL strings.
    #  @return raw
    to_bytes = function() {
      prefix <- as.raw(c(0x9e, 0xfd, 0x13, 0x10)) # little-endian of 0x1013fd9e
      vector_constructor <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c)) # 0x1cb5c415 little-endian
      count_raw <- private$int_to_le_raw(as.integer(length(self$phones)), size = 4L)
      phones_bytes <- raw(0)
      if (length(self$phones) > 0L) {
        parts <- list()
        for (p in self$phones) {
          parts[[length(parts) + 1L]] <- private$serialize_string_tl(p)
        }
        phones_bytes <- do.call(c, parts)
      }
      c(prefix, vector_constructor, count_raw, phones_bytes)
    }
  ),
  private = list(
    #  Convert integer to little-endian raw vector of given size (bytes)
    int_to_le_raw = function(x, size = 4L) {
      xi <- as.integer(x)
      v <- raw(size)
      for (i in seq_len(size)) {
        v[i] <- as.raw(bitwAnd(bitwShiftR(xi, 8L * (i - 1L)), 0xff))
      }
      v
    },

    #  Serialize an R string to TL string bytes (per Telegram TL encoding)
    serialize_string_tl = function(s) {
      if (is.null(s)) {
        return(raw(0))
      }
      sb <- charToRaw(enc2utf8(as.character(s)))
      ln <- length(sb)
      if (ln < 254L) {
        header <- as.raw(ln)
        payload <- sb
        total <- 1 + ln
      } else {
        header <- as.raw(c(
          254L,
          as.raw(bitwAnd(ln, 0xff)),
          as.raw(bitwAnd(bitwShiftR(ln, 8L), 0xff)),
          as.raw(bitwAnd(bitwShiftR(ln, 16L), 0xff))
        ))
        payload <- sb
        total <- 4 + ln
      }
      pad_len <- (4L - (total %% 4L)) %% 4L
      padding <- if (pad_len > 0L) as.raw(rep(0, pad_len)) else raw(0)
      c(header, payload, padding)
    }
  ),
  active = list(),
  class = TRUE
)

# Create DeleteByPhonesRequest from reader
# @name DeleteByPhonesRequest_from_reader
#
# @param reader object with methods read_int() and tgread_string()
# @return DeleteByPhonesRequest
DeleteByPhonesRequest$from_reader <- function(reader) {
  # consume vector constructor id (typical TL format)
  reader$read_int()
  count <- reader$read_int()
  phones_list <- character(count)
  if (count > 0L) {
    for (i in seq_len(count)) {
      phones_list[i] <- reader$tgread_string()
    }
  }
  DeleteByPhonesRequest$new(phones = phones_list)
}


#  DeleteContactsRequest
# 
#  R6 representation of the TL request: DeleteContactsRequest
# 
# 
#  @description
#  Methods:
#  - initialize(id): create new request where id is a list of input_user objects
#  - resolve(client, utils): resolve each id element into an input_user via client and utils
#  - to_list(): return list representation
#  - to_bytes(): serialize to raw TL bytes (constructor + vector + item bytes)
#  @export
#  @noRd
#  @noRd
DeleteContactsRequest <- R6::R6Class(
  "DeleteContactsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x096a0e00,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field id Field.
    id = NULL,

    #  @description Initialize DeleteContactsRequest
    # 
    #  @param id list of input_user objects or raw representations
    initialize = function(id) {
      if (!is.null(id) && !is.list(id)) stop("id must be a list")
      self$id <- id
    },

    #  Resolve entities using client and utils
    # 
    #  Replaces each element of id with utils$get_input_user(client$get_input_entity(element))
    # 
    #  @param client client object with method get_input_entity()
    #  @param utils utils object with method get_input_user()
    resolve = function(client, utils) {
      if (is.null(self$id)) {
        return(invisible(NULL))
      }
      tmp_list <- list()
      for (element in self$id) {
        entity <- client$get_input_entity(element)
        tmp_list[[length(tmp_list) + 1L]] <- utils$get_input_user(entity)
      }
      self$id <- tmp_list
      invisible(NULL)
    },

    #  Convert to list
    # 
    #  @return list
    to_list = function() {
      id_repr <- NULL
      if (!is.null(self$id)) {
        id_repr <- lapply(self$id, function(x) {
          if (inherits(x, "TLObject") || inherits(x, "R6")) {
            if (is.function(x$to_list)) x$to_list() else x
          } else {
            x
          }
        })
      }
      list(`_` = "DeleteContactsRequest", id = id_repr)
    },

    #  Serialize to bytes (raw vector)
    # 
    #  Packs constructor id, TL vector constructor, count and serialized items.
    #  Each item must provide to_bytes() or be a raw vector.
    # 
    #  @return raw
    to_bytes = function() {
      prefix <- as.raw(c(0x00, 0x0e, 0x6a, 0x09)) # little-endian of 0x096a0e00
      vector_constructor <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c)) # 0x1cb5c415 little-endian
      count_raw <- private$int_to_le_raw(as.integer(length(self$id)), size = 4L)
      items_bytes <- raw(0)
      if (!is.null(self$id) && length(self$id) > 0L) {
        parts <- list()
        for (element in self$id) {
          if (!is.null(element) && is.function(element$to_bytes)) {
            parts[[length(parts) + 1L]] <- element$to_bytes()
          } else if (!is.null(element) && is.raw(element)) {
            parts[[length(parts) + 1L]] <- element
          } else {
            stop("each id element must provide to_bytes() or be a raw vector")
          }
        }
        if (length(parts) > 0L) items_bytes <- do.call(c, parts)
      }
      c(prefix, vector_constructor, count_raw, items_bytes)
    }
  ),
  private = list(
    #  Convert integer to little-endian raw vector of given size (bytes)
    int_to_le_raw = function(x, size = 4L) {
      xi <- as.integer(x)
      v <- raw(size)
      for (i in seq_len(size)) {
        v[i] <- as.raw(bitwAnd(bitwShiftR(xi, 8L * (i - 1L)), 0xff))
      }
      v
    }
  ),
  active = list(),
  class = TRUE
)

# Create DeleteContactsRequest from reader
# @name DeleteContactsRequest_from_reader
#
# @param reader object with methods read_int() and tgread_object()
# @return DeleteContactsRequest
DeleteContactsRequest$from_reader <- function(reader) {
  # consume vector constructor id (typical TL format)
  reader$read_int()
  count <- reader$read_int()
  id_list <- vector("list", count)
  if (count > 0L) {
    for (i in seq_len(count)) {
      id_list[[i]] <- reader$tgread_object()
    }
  }
  DeleteContactsRequest$new(id = id_list)
}


#  EditCloseFriendsRequest
# 
#  R6 representation of the TL request: EditCloseFriendsRequest
# 
# 
#  @description
#  Methods:
#  - initialize(id): create new request where id is a numeric vector of 64-bit integers
#  - to_list(): return list representation
#  - to_bytes(): serialize to raw TL bytes (constructor + vector + int64 items)
#  @export
#  @noRd
#  @noRd
EditCloseFriendsRequest <- R6::R6Class(
  "EditCloseFriendsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xba6705f0,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field id Field.
    id = NULL,

    #  @description Initialize EditCloseFriendsRequest
    # 
    #  @param id numeric vector (64-bit integers)
    initialize = function(id) {
      if (is.null(id)) {
        self$id <- numeric(0)
      } else {
        # accept list or numeric; coerce to numeric
        if (!is.numeric(id) && !is.integer(id)) {
          stop("id must be a numeric vector")
        }
        self$id <- as.numeric(id)
      }
    },

    #  Convert to list
    # 
    #  @return list
    to_list = function() {
      list(`_` = "EditCloseFriendsRequest", id = if (is.null(self$id)) numeric(0) else as.numeric(self$id))
    },

    #  Serialize to bytes (raw vector)
    # 
    #  Packs constructor id, vector constructor, count and 64-bit little-endian items.
    #  @return raw
    to_bytes = function() {
      prefix <- as.raw(c(0xf0, 0x05, 0x67, 0xba)) # little-endian of 0xba6705f0
      vector_constructor <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c)) # 0x1cb5c415 little-endian
      count_raw <- private$int_to_le_raw(as.integer(length(self$id)), size = 4L)
      items_bytes <- raw(0)
      if (length(self$id) > 0L) {
        parts <- list()
        for (v in self$id) {
          parts[[length(parts) + 1L]] <- private$int64_to_le_raw(v)
        }
        items_bytes <- do.call(c, parts)
      }
      c(prefix, vector_constructor, count_raw, items_bytes)
    }
  ),
  private = list(
    #  Convert integer to little-endian raw vector of given size (bytes)
    int_to_le_raw = function(x, size = 4L) {
      xi <- as.integer(x)
      v <- raw(size)
      for (i in seq_len(size)) {
        v[i] <- as.raw(bitwAnd(bitwShiftR(xi, 8L * (i - 1L)), 0xff))
      }
      v
    },

    #  Convert 64-bit numeric to little-endian raw (8 bytes)
    int64_to_le_raw = function(x) {
      # split into lo and hi 32-bit parts
      val <- as.numeric(x)
      lo <- as.integer(val %% 2^32)
      hi <- as.integer((val %/% 2^32) %% 2^32)
      lo_raw <- raw(4)
      hi_raw <- raw(4)
      for (i in seq_len(4)) {
        lo_raw[i] <- as.raw(bitwAnd(bitwShiftR(lo, 8L * (i - 1L)), 0xff))
        hi_raw[i] <- as.raw(bitwAnd(bitwShiftR(hi, 8L * (i - 1L)), 0xff))
      }
      c(lo_raw, hi_raw)
    }
  ),
  active = list(),
  class = TRUE
)

# Create EditCloseFriendsRequest from reader
# @name EditCloseFriendsRequest_from_reader
#
# @param reader object with methods read_int() and read_long()
# @return EditCloseFriendsRequest
EditCloseFriendsRequest$from_reader <- function(reader) {
  # consume vector constructor id (typical TL format)
  reader$read_int()
  count <- reader$read_int()
  id_list <- numeric(count)
  if (count > 0L) {
    for (i in seq_len(count)) {
      id_list[i] <- reader$read_long()
    }
  }
  EditCloseFriendsRequest$new(id = id_list)
}


#  ExportContactTokenRequest
# 
#  R6 representation of the TL request: ExportContactTokenRequest
# 
# 
#  @description
#  Methods:
#  - initialize(): create new request
#  - to_list(): return list representation
#  - to_bytes(): serialize to raw TL bytes
#  @export
#  @noRd
#  @noRd
ExportContactTokenRequest <- R6::R6Class(
  "ExportContactTokenRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xf8654027,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x86ddbed1,

    #  @description Initialize ExportContactTokenRequest
    initialize = function() {
      invisible(NULL)
    },

    #  Convert to list
    to_list = function() {
      list(`_` = "ExportContactTokenRequest")
    },

    #  Serialize to bytes (raw vector)
    to_bytes = function() {
      # little-endian of 0xf8654027 -> 0x27 0x40 0x65 0xf8
      as.raw(c(0x27, 0x40, 0x65, 0xf8))
    }
  ),
  private = list(),
  active = list(),
  class = TRUE
)

# Create ExportContactTokenRequest from reader
# @name ExportContactTokenRequest_from_reader
#
# @param reader object (not used)
# @return ExportContactTokenRequest
ExportContactTokenRequest$from_reader <- function(reader) {
  ExportContactTokenRequest$new()
}


#  GetBirthdaysRequest
# 
#  R6 representation of the TL request: GetBirthdaysRequest
# 
# 
#  @description
#  Methods:
#  - initialize(): create new request
#  - to_list(): return list representation
#  - to_bytes(): serialize to raw TL bytes
#  @export
#  @noRd
#  @noRd
GetBirthdaysRequest <- R6::R6Class(
  "GetBirthdaysRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xdaeda864,
    SUBCLASS_OF_ID = 0x0e7aabff, # keep provided subclass id (from original) - note: original had 0xe7aabff; preserve numeric

    #  @description Initialize GetBirthdaysRequest
    initialize = function() {
      invisible(NULL)
    },

    #  Convert to list
    to_list = function() {
      list(`_` = "GetBirthdaysRequest")
    },

    #  Serialize to bytes (raw vector)
    to_bytes = function() {
      # little-endian of 0xdaeda864 -> 0x64 0xa8 0xed 0xda
      as.raw(c(0x64, 0xa8, 0xed, 0xda))
    }
  ),
  private = list(),
  active = list(),
  class = TRUE
)

# Create GetBirthdaysRequest from reader
# @name GetBirthdaysRequest_from_reader
#
# @param reader object (not used)
# @return GetBirthdaysRequest
GetBirthdaysRequest$from_reader <- function(reader) {
  GetBirthdaysRequest$new()
}


#  GetBlockedRequest
# 
#  R6 representation of the TL request: GetBlockedRequest
# 
# 
#  @description
#  Methods:
#  - initialize(offset, limit, my_stories_from = NULL): create new request
#  - to_list(): return list representation
#  - to_bytes(): serialize to raw TL bytes
#  @export
#  @noRd
#  @noRd
GetBlockedRequest <- R6::R6Class(
  "GetBlockedRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x9a868f80,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xffba4f4f,
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field my_stories_from Field.
    my_stories_from = NULL,

    #  @description Initialize GetBlockedRequest
    # 
    #  @param offset integer
    #  @param limit integer
    #  @param my_stories_from logical or NULL
    initialize = function(offset, limit, my_stories_from = NULL) {
      self$offset <- as.integer(offset)
      self$limit <- as.integer(limit)
      if (!is.null(my_stories_from)) {
        self$my_stories_from <- as.logical(my_stories_from)
      } else {
        self$my_stories_from <- NULL
      }
    },

    #  Convert to list
    # 
    #  @return list
    to_list = function() {
      list(
        `_` = "GetBlockedRequest",
        offset = self$offset,
        limit = self$limit,
        my_stories_from = self$my_stories_from
      )
    },

    #  Serialize to bytes (raw vector)
    # 
    #  Packs flags (uint32 little-endian) and offset/limit as int32 little-endian.
    # 
    #  @return raw
    to_bytes = function() {
      prefix <- as.raw(c(0x80, 0x8f, 0x86, 0x9a)) # little-endian of 0x9a868f80
      flags_val <- if (is.null(self$my_stories_from) || identical(self$my_stories_from, FALSE)) 0L else 1L
      flags_raw <- private$int_to_le_raw(as.integer(flags_val), size = 4L)
      offset_raw <- private$int_to_le_raw(as.integer(self$offset), size = 4L)
      limit_raw <- private$int_to_le_raw(as.integer(self$limit), size = 4L)
      c(prefix, flags_raw, offset_raw, limit_raw)
    }
  ),
  private = list(
    #  Convert integer to little-endian raw vector of given size (bytes)
    int_to_le_raw = function(x, size = 4L) {
      xi <- as.integer(x)
      v <- raw(size)
      for (i in seq_len(size)) {
        v[i] <- as.raw(bitwAnd(bitwShiftR(xi, 8L * (i - 1L)), 0xff))
      }
      v
    }
  ),
  active = list(),
  class = TRUE
)

# Create GetBlockedRequest from reader
# @name GetBlockedRequest_from_reader
#
# @param reader object with method read_int()
# @return GetBlockedRequest
GetBlockedRequest$from_reader <- function(reader) {
  flagsVal <- reader$read_int()
  myStoriesFlag <- bitwAnd(flagsVal, 1L) != 0L
  offsetVal <- reader$read_int()
  limitVal <- reader$read_int()
  GetBlockedRequest$new(offset = offsetVal, limit = limitVal, my_stories_from = myStoriesFlag)
}


#  GetContactIDsRequest
# 
#  R6 representation of the TL request: GetContactIDsRequest
# 
# 
#  @description
#  Methods:
#  - initialize(hash): create new request
#  - to_list(): return list representation
#  - to_bytes(): serialize to raw TL bytes (constructor + int64 hash)
#  - read_result(reader): static helper to read the result vector of ints from reader
#  @export
#  @noRd
#  @noRd
GetContactIDsRequest <- R6::R6Class(
  "GetContactIDsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x7adc669d,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x5026710f,
    #  @field hash Field.
    hash = NULL,

    #  @description Initialize GetContactIDsRequest
    # 
    #  @param hash numeric/integer (64-bit)
    initialize = function(hash) {
      self$hash <- as.numeric(hash)
    },

    #  Convert to list
    # 
    #  @return list
    to_list = function() {
      list(`_` = "GetContactIDsRequest", hash = self$hash)
    },

    #  Serialize to bytes (raw vector)
    # 
    #  Packs constructor id and 64-bit little-endian hash.
    # 
    #  @return raw
    to_bytes = function() {
      prefix <- as.raw(c(0x9d, 0x66, 0xdc, 0x7a)) # little-endian of 0x7adc669d
      hash_raw <- private$int64_to_le_raw(self$hash)
      c(prefix, hash_raw)
    }
  ),
  private = list(
    #  Convert 64-bit numeric to little-endian raw (8 bytes)
    int64_to_le_raw = function(x) {
      val <- as.numeric(x)
      lo <- as.integer(val %% 2^32)
      hi <- as.integer((val %/% 2^32) %% 2^32)
      lo_raw <- raw(4)
      hi_raw <- raw(4)
      for (i in seq_len(4)) {
        lo_raw[i] <- as.raw(bitwAnd(bitwShiftR(lo, 8L * (i - 1L)), 0xff))
        hi_raw[i] <- as.raw(bitwAnd(bitwShiftR(hi, 8L * (i - 1L)), 0xff))
      }
      c(lo_raw, hi_raw)
    }
  ),
  active = list(),
  class = TRUE
)

# Create GetContactIDsRequest from reader
# @name GetContactIDsRequest_from_reader
#
# @param reader object with method read_long()
# @return GetContactIDsRequest
GetContactIDsRequest$from_reader <- function(reader) {
  hash_val <- reader$read_long()
  GetContactIDsRequest$new(hash = hash_val)
}

# Read result for GetContactIDsRequest
# @name GetContactIDsRequest_read_result
#
# Static helper to read Vector<int> returned by the server for this request.
#
# @param reader object with methods read_int()
# @return integer vector
GetContactIDsRequest$read_result <- function(reader) {
  # consume vector constructor id
  reader$read_int()
  count <- reader$read_int()
  if (count <= 0L) {
    return(integer(0))
  }
  res <- integer(count)
  for (i in seq_len(count)) {
    res[i] <- reader$read_int()
  }
  res
}


#  GetContactsRequest
# 
#  R6 representation of the TL request: GetContactsRequest
# 
# 
#  @description
#  Methods:
#  - initialize(hash): create new request
#  - to_list(): return a list representation suitable for JSON/dumping
#  - to_bytes(): return raw vector of bytes for the TL request
#  @export
#  @noRd
#  @noRd
GetContactsRequest <- R6::R6Class(
  "GetContactsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x5dd69e12,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x38be25f6,
    #  @field hash Field.
    hash = NULL,

    #  @description Initialize GetContactsRequest
    # 
    #  @param hash numeric/integer (64-bit)
    initialize = function(hash) {
      self$hash <- as.numeric(hash)
    },

    #  Convert to list
    #  @return list
    to_list = function() {
      list(`_` = "GetContactsRequest", hash = self$hash)
    },

    #  Serialize to bytes (raw vector)
    #  @return raw
    to_bytes = function() {
      # little-endian of 0x5dd69e12 -> 0x12 0x9e 0xd6 0x5d
      prefix <- as.raw(c(0x12, 0x9e, 0xd6, 0x5d))
      hash_raw <- private$int64_to_le_raw(self$hash)
      c(prefix, hash_raw)
    }
  ),
  private = list(
    #  Convert 64-bit integer (numeric) to little-endian raw vector (8 bytes)
    int64_to_le_raw = function(x) {
      # Split numeric into lo and hi 32-bit parts in a reasonably robust way.
      # Use integer division / modulo on numeric; careful with large values.
      val <- as.numeric(x)
      lo <- as.integer(val %% 2^32)
      hi <- as.integer((val %/% 2^32) %% 2^32)
      lo_raw <- raw(4)
      hi_raw <- raw(4)
      for (i in seq_len(4)) {
        lo_raw[i] <- as.raw(bitwAnd(bitwShiftR(lo, 8L * (i - 1L)), 0xff))
        hi_raw[i] <- as.raw(bitwAnd(bitwShiftR(hi, 8L * (i - 1L)), 0xff))
      }
      c(lo_raw, hi_raw)
    }
  ),
  active = list(),
  class = TRUE
)

# Create GetContactsRequest from reader
# @name GetContactsRequest_from_reader
#
# @param reader object with method read_long()
# @return GetContactsRequest
GetContactsRequest$from_reader <- function(reader) {
  hash_val <- reader$read_long()
  GetContactsRequest$new(hash = hash_val)
}


#  GetLocatedRequest
# 
#  R6 representation of the TL request: GetLocatedRequest
# 
# 
#  @description
#  Methods:
#  - initialize(geo_point, background = NULL, self_expires = NULL): create new request
#  - to_list(): return a list representation suitable for JSON/dumping
#  - to_bytes(): return raw vector of bytes for the TL request
#  - from_reader(reader): read from reader and return a new instance
#  @export
#  @noRd
#  @noRd
GetLocatedRequest <- R6::R6Class(
  "GetLocatedRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xd348bc44,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field geo_point Field.
    geo_point = NULL,
    #  @field background Field.
    background = NULL,
    #  @field self_expires Field.
    self_expires = NULL,

    #  @description Initialize GetLocatedRequest
    # 
    #  @param geo_point input geo point object (TL)
    #  @param background logical or NULL
    #  @param self_expires integer or NULL
    initialize = function(geo_point, background = NULL, self_expires = NULL) {
      self$geo_point <- geo_point
      if (!is.null(background)) self$background <- as.logical(background) else self$background <- NULL
      if (!is.null(self_expires)) self$self_expires <- as.integer(self_expires) else self$self_expires <- NULL
    },

    #  Convert to list
    #  @return list
    to_list = function() {
      geo_repr <- if (!is.null(self$geo_point) && is.function(self$geo_point$to_list)) self$geo_point$to_list() else self$geo_point
      list(`_` = "GetLocatedRequest", geo_point = geo_repr, background = self$background, self_expires = self$self_expires)
    },

    #  Serialize to bytes (raw vector)
    #  @return raw
    to_bytes = function() {
      # little-endian of 0xd348bc44 -> 0x44 0xbc 0x48 0xd3
      prefix <- as.raw(c(0x44, 0xbc, 0x48, 0xd3))
      flags_val <- 0L
      if (!is.null(self$background) && isTRUE(self$background)) flags_val <- bitwOr(flags_val, 2L)
      if (!is.null(self$self_expires)) flags_val <- bitwOr(flags_val, 1L)
      flags_raw <- private$int_to_le_raw(as.integer(flags_val), size = 4L)

      geo_bytes <- NULL
      if (!is.null(self$geo_point) && is.function(self$geo_point$to_bytes)) {
        geo_bytes <- self$geo_point$to_bytes()
      } else if (!is.null(self$geo_point) && is.raw(self$geo_point)) {
        geo_bytes <- self$geo_point
      } else {
        stop("geo_point must provide to_bytes() or be a raw vector")
      }

      expires_raw <- raw(0)
      if (!is.null(self$self_expires)) {
        expires_raw <- private$int_to_le_raw(as.integer(self$self_expires), size = 4L)
      }
      c(prefix, flags_raw, geo_bytes, expires_raw)
    }
  ),
  private = list(
    #  Convert integer to little-endian raw vector of given size (bytes)
    int_to_le_raw = function(x, size = 4L) {
      xi <- as.integer(x)
      v <- raw(size)
      for (i in seq_len(size)) {
        v[i] <- as.raw(bitwAnd(bitwShiftR(xi, 8L * (i - 1L)), 0xff))
      }
      v
    }
  ),
  active = list(),
  class = TRUE
)

# Create GetLocatedRequest from reader
# @name GetLocatedRequest_from_reader
#
# @param reader object with methods read_int() and tgread_object()
# @return GetLocatedRequest
GetLocatedRequest$from_reader <- function(reader) {
  flags_val <- reader$read_int()
  background_flag <- bitwAnd(flags_val, 2L) != 0L
  geo_point_val <- reader$tgread_object()
  self_expires_val <- if (bitwAnd(flags_val, 1L) != 0L) reader$read_int() else NULL
  GetLocatedRequest$new(geo_point = geo_point_val, background = background_flag, self_expires = self_expires_val)
}

#  GetSavedRequest
# 
#  R6 representation of the TL request: GetSavedRequest
# 
#  @description
#  Methods:
#  - initialize(): create new request
#  - to_list(): return a list representation suitable for JSON/dumping
#  - to_bytes(): return raw vector of bytes for the TL request
#  @export
#  @noRd
#  @noRd
GetSavedRequest <- R6::R6Class(
  "GetSavedRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x82f1e39f,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x975dbef,

    #  @description Initialize GetSavedRequest
    initialize = function() {
      invisible(NULL)
    },

    #  Convert to list
    #  @return list
    to_list = function() {
      list(`_` = "GetSavedRequest")
    },

    #  Serialize to bytes (raw vector)
    #  @return raw
    to_bytes = function() {
      # little-endian of 0x82f1e39f -> 0x9f 0xe3 0xf1 0x82
      as.raw(c(0x9f, 0xe3, 0xf1, 0x82))
    }
  ),
  private = list(),
  active = list(),
  class = TRUE
)

# Create GetSavedRequest from reader
# @name GetSavedRequest_from_reader
#
# @param reader object (not used for this constructor)
# @return GetSavedRequest
GetSavedRequest$from_reader <- function(reader) {
  GetSavedRequest$new()
}


#  GetSponsoredPeersRequest
# 
#  R6 representation of the TL request: GetSponsoredPeersRequest
# 
# 
#  @description
#  Methods:
#  - initialize(q): create new request
#  - to_list(): return a list representation suitable for JSON/dumping
#  - to_bytes(): return raw vector of bytes for the TL request
#  @export
#  @noRd
#  @noRd
GetSponsoredPeersRequest <- R6::R6Class(
  "GetSponsoredPeersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xb6c8c393,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xb45d5ccc,
    #  @field q Field.
    q = NULL,

    #  @description Initialize GetSponsoredPeersRequest
    # 
    #  @param q character query string
    initialize = function(q) {
      self$q <- as.character(q)
    },

    #  Convert to list
    #  @return list
    to_list = function() {
      list(`_` = "GetSponsoredPeersRequest", q = self$q)
    },

    #  Serialize to bytes (raw vector)
    #  @return raw
    to_bytes = function() {
      # little-endian of 0xb6c8c393 -> 0x93 0xc3 0xc8 0xb6
      prefix <- as.raw(c(0x93, 0xc3, 0xc8, 0xb6))
      q_bytes <- private$serialize_string_tl(self$q)
      c(prefix, q_bytes)
    }
  ),
  private = list(
    #  Serialize an R string to TL string bytes (per Telegram TL encoding)
    serialize_string_tl = function(s) {
      if (is.null(s)) {
        return(raw(0))
      }
      sb <- charToRaw(enc2utf8(as.character(s)))
      ln <- length(sb)
      if (ln < 254L) {
        header <- as.raw(ln)
        payload <- sb
        total <- 1 + ln
      } else {
        header <- as.raw(c(
          254L,
          as.raw(bitwAnd(ln, 0xff)),
          as.raw(bitwAnd(bitwShiftR(ln, 8L), 0xff)),
          as.raw(bitwAnd(bitwShiftR(ln, 16L), 0xff))
        ))
        payload <- sb
        total <- 4 + ln
      }
      pad_len <- (4L - (total %% 4L)) %% 4L
      padding <- if (pad_len > 0L) as.raw(rep(0, pad_len)) else raw(0)
      c(header, payload, padding)
    }
  ),
  active = list(),
  class = TRUE
)

# Create GetSponsoredPeersRequest from reader
# @name GetSponsoredPeersRequest_from_reader
#
# @param reader object with method tgread_string()
# @return GetSponsoredPeersRequest
GetSponsoredPeersRequest$from_reader <- function(reader) {
  q_val <- reader$tgread_string()
  GetSponsoredPeersRequest$new(q = q_val)
}


#  GetStatusesRequest
# 
#  R6 representation of the TL request: GetStatusesRequest
# 
#  @description
#  Methods:
#  - initialize(): create new request
#  - to_list(): return a list representation suitable for JSON/dumping
#  - to_bytes(): return raw vector of bytes for the TL request
#  @export
#  @noRd
#  @noRd
GetStatusesRequest <- R6::R6Class(
  "GetStatusesRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xc4a353ee,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xdf815c90,

    #  @description Initialize GetStatusesRequest
    initialize = function() {
      invisible(NULL)
    },

    #  Convert to list
    #  @return list
    to_list = function() {
      list(`_` = "GetStatusesRequest")
    },

    #  Serialize to bytes (raw vector)
    #  @return raw
    to_bytes = function() {
      # little-endian of 0xc4a353ee -> 0xee 0x53 0xa3 0xc4
      as.raw(c(0xee, 0x53, 0xa3, 0xc4))
    }
  ),
  private = list(),
  active = list(),
  class = TRUE
)

# Create GetStatusesRequest from reader
# @name GetStatusesRequest_from_reader
#
# @param reader object (not used for this constructor)
# @return GetStatusesRequest
GetStatusesRequest$from_reader <- function(reader) {
  GetStatusesRequest$new()
}


#  GetTopPeersRequest
# 
#  R6 representation of the TL request: GetTopPeersRequest
# 
# 
#  @description
#  Methods:
#  - initialize(offset, limit, hash, ...): create new request
#  - to_list(): return a list representation suitable for JSON/dumping
#  - to_bytes(): return raw vector of bytes for the TL request
#  - from_reader(reader): read from reader and return a new instance
#  @export
#  @noRd
#  @noRd
GetTopPeersRequest <- R6::R6Class(
  "GetTopPeersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x973478b6,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x9ee8bb88,
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field hash Field.
    hash = NULL,
    #  @field correspondents Field.
    correspondents = NULL,
    #  @field bots_pm Field.
    bots_pm = NULL,
    #  @field bots_inline Field.
    bots_inline = NULL,
    #  @field phone_calls Field.
    phone_calls = NULL,
    #  @field forward_users Field.
    forward_users = NULL,
    #  @field forward_chats Field.
    forward_chats = NULL,
    #  @field groups Field.
    groups = NULL,
    #  @field channels Field.
    channels = NULL,
    #  @field bots_app Field.
    bots_app = NULL,

    #  @description Initialize GetTopPeersRequest
    # 
    #  @param offset integer
    #  @param limit integer
    #  @param hash numeric/integer (64-bit)
    #  @param correspondents logical|NULL
    #  @param bots_pm logical|NULL
    #  @param bots_inline logical|NULL
    #  @param phone_calls logical|NULL
    #  @param forward_users logical|NULL
    #  @param forward_chats logical|NULL
    #  @param groups logical|NULL
    #  @param channels logical|NULL
    #  @param bots_app logical|NULL
    initialize = function(offset, limit, hash,
                          correspondents = NULL, bots_pm = NULL, bots_inline = NULL,
                          phone_calls = NULL, forward_users = NULL, forward_chats = NULL,
                          groups = NULL, channels = NULL, bots_app = NULL) {
      self$offset <- as.integer(offset)
      self$limit <- as.integer(limit)
      self$hash <- as.numeric(hash)
      self$correspondents <- if (!is.null(correspondents)) as.logical(correspondents) else NULL
      self$bots_pm <- if (!is.null(bots_pm)) as.logical(bots_pm) else NULL
      self$bots_inline <- if (!is.null(bots_inline)) as.logical(bots_inline) else NULL
      self$phone_calls <- if (!is.null(phone_calls)) as.logical(phone_calls) else NULL
      self$forward_users <- if (!is.null(forward_users)) as.logical(forward_users) else NULL
      self$forward_chats <- if (!is.null(forward_chats)) as.logical(forward_chats) else NULL
      self$groups <- if (!is.null(groups)) as.logical(groups) else NULL
      self$channels <- if (!is.null(channels)) as.logical(channels) else NULL
      self$bots_app <- if (!is.null(bots_app)) as.logical(bots_app) else NULL
    },

    #  Convert to list
    #  @return list
    to_list = function() {
      list(
        `_` = "GetTopPeersRequest",
        offset = self$offset,
        limit = self$limit,
        hash = self$hash,
        correspondents = self$correspondents,
        bots_pm = self$bots_pm,
        bots_inline = self$bots_inline,
        phone_calls = self$phone_calls,
        forward_users = self$forward_users,
        forward_chats = self$forward_chats,
        groups = self$groups,
        channels = self$channels,
        bots_app = self$bots_app
      )
    },

    #  Serialize to bytes (raw vector)
    #  @return raw
    to_bytes = function() {
      # constructor little-endian of 0x973478b6 -> 0xb6 0x78 0x34 0x97
      prefix <- as.raw(c(0xb6, 0x78, 0x34, 0x97))

      flags_val <- 0L
      if (!is.null(self$correspondents) && isTRUE(self$correspondents)) flags_val <- bitwOr(flags_val, 1L)
      if (!is.null(self$bots_pm) && isTRUE(self$bots_pm)) flags_val <- bitwOr(flags_val, 2L)
      if (!is.null(self$bots_inline) && isTRUE(self$bots_inline)) flags_val <- bitwOr(flags_val, 4L)
      if (!is.null(self$phone_calls) && isTRUE(self$phone_calls)) flags_val <- bitwOr(flags_val, 8L)
      if (!is.null(self$forward_users) && isTRUE(self$forward_users)) flags_val <- bitwOr(flags_val, 16L)
      if (!is.null(self$forward_chats) && isTRUE(self$forward_chats)) flags_val <- bitwOr(flags_val, 32L)
      if (!is.null(self$groups) && isTRUE(self$groups)) flags_val <- bitwOr(flags_val, 1024L)
      if (!is.null(self$channels) && isTRUE(self$channels)) flags_val <- bitwOr(flags_val, 32768L)
      if (!is.null(self$bots_app) && isTRUE(self$bots_app)) flags_val <- bitwOr(flags_val, 65536L)

      flags_raw <- private$int_to_le_raw(as.integer(flags_val), size = 4L)
      offset_raw <- private$int_to_le_raw(as.integer(self$offset), size = 4L)
      limit_raw <- private$int_to_le_raw(as.integer(self$limit), size = 4L)
      hash_raw <- private$int64_to_le_raw(as.numeric(self$hash))

      c(prefix, flags_raw, offset_raw, limit_raw, hash_raw)
    }
  ),
  private = list(
    #  Convert integer to little-endian raw vector of given size (bytes)
    int_to_le_raw = function(x, size = 4L) {
      xi <- as.integer(x)
      v <- raw(size)
      for (i in seq_len(size)) {
        v[i] <- as.raw(bitwAnd(bitwShiftR(xi, 8L * (i - 1L)), 0xff))
      }
      v
    },

    #  Convert 64-bit integer (numeric) to little-endian raw vector (8 bytes)
    int64_to_le_raw = function(x) {
      # Coerce to integer64-like via bit operations on double is unsafe; treat via splitting
      hi <- bitwAnd(as.integer(bitwShiftR(as.integer(x %/% 2^32), 0L)), 0xffffffff)
      lo <- bitwAnd(as.integer(x %% 2^32), 0xffffffff)
      # pack lo (4 bytes) then hi (4 bytes) little-endian order
      lo_raw <- raw(4)
      hi_raw <- raw(4)
      for (i in seq_len(4)) {
        lo_raw[i] <- as.raw(bitwAnd(bitwShiftR(lo, 8L * (i - 1L)), 0xff))
        hi_raw[i] <- as.raw(bitwAnd(bitwShiftR(hi, 8L * (i - 1L)), 0xff))
      }
      c(lo_raw, hi_raw)
    }
  ),
  active = list(),
  class = TRUE
)

# Create GetTopPeersRequest from reader
# @name GetTopPeersRequest_from_reader
#
# @param reader object with methods read_int() and read_long()
# @return GetTopPeersRequest
GetTopPeersRequest$from_reader <- function(reader) {
  flagsVal <- reader$read_int()
  correspondentsFlag <- bitwAnd(flagsVal, 1L) != 0L
  botsPmFlag <- bitwAnd(flagsVal, 2L) != 0L
  botsInlineFlag <- bitwAnd(flagsVal, 4L) != 0L
  phoneCallsFlag <- bitwAnd(flagsVal, 8L) != 0L
  forwardUsersFlag <- bitwAnd(flagsVal, 16L) != 0L
  forwardChatsFlag <- bitwAnd(flagsVal, 32L) != 0L
  groupsFlag <- bitwAnd(flagsVal, 1024L) != 0L
  channelsFlag <- bitwAnd(flagsVal, 32768L) != 0L
  botsAppFlag <- bitwAnd(flagsVal, 65536L) != 0L

  offsetVal <- reader$read_int()
  limitVal <- reader$read_int()
  hashVal <- reader$read_long()

  GetTopPeersRequest$new(
    offset = offsetVal,
    limit = limitVal,
    hash = hashVal,
    correspondents = correspondentsFlag,
    bots_pm = botsPmFlag,
    bots_inline = botsInlineFlag,
    phone_calls = phoneCallsFlag,
    forward_users = forwardUsersFlag,
    forward_chats = forwardChatsFlag,
    groups = groupsFlag,
    channels = channelsFlag,
    bots_app = botsAppFlag
  )
}


#  ImportContactTokenRequest
# 
#  R6 representation of the TL request: ImportContactTokenRequest
# 
# 
#  @description
#  Methods:
#  - initialize(token): create new request
#  - to_list(): return a list representation suitable for JSON/dumping
#  - to_bytes(): return raw vector of bytes for the TL request
#  @export
#  @noRd
#  @noRd
ImportContactTokenRequest <- R6::R6Class(
  "ImportContactTokenRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x13005788,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x2da17977,
    #  @field token Field.
    token = NULL,

    #  @description Initialize ImportContactTokenRequest
    # 
    #  @param token character token string
    initialize = function(token) {
      self$token <- as.character(token)
    },

    #  Convert to list
    # 
    #  @return list
    to_list = function() {
      list(`_` = "ImportContactTokenRequest", token = self$token)
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      prefix <- as.raw(c(0x88, 0x57, 0x00, 0x13)) # little-endian of 0x13005788
      token_bytes <- private$serialize_string_tl(self$token)
      c(prefix, token_bytes)
    }
  ),
  private = list(
    #  Convert integer to little-endian raw vector of given size (bytes)
    int_to_le_raw = function(x, size = 4L) {
      xi <- as.integer(x)
      v <- raw(size)
      for (i in seq_len(size)) {
        v[i] <- as.raw(bitwAnd(bitwShiftR(xi, 8L * (i - 1L)), 0xff))
      }
      v
    },

    #  Serialize an R string to TL string bytes (per Telegram TL encoding)
    serialize_string_tl = function(s) {
      if (is.null(s)) {
        return(raw(0))
      }
      sb <- charToRaw(enc2utf8(as.character(s)))
      ln <- length(sb)
      if (ln < 254L) {
        header <- as.raw(ln)
        payload <- sb
        total <- 1 + ln
      } else {
        header <- as.raw(c(
          254L,
          as.raw(bitwAnd(ln, 0xff)),
          as.raw(bitwAnd(bitwShiftR(ln, 8L), 0xff)),
          as.raw(bitwAnd(bitwShiftR(ln, 16L), 0xff))
        ))
        payload <- sb
        total <- 4 + ln
      }
      pad_len <- (4L - (total %% 4L)) %% 4L
      padding <- if (pad_len > 0L) as.raw(rep(0, pad_len)) else raw(0)
      c(header, payload, padding)
    }
  ),
  active = list(),
  class = TRUE
)

# Create ImportContactTokenRequest from reader
# @name ImportContactTokenRequest_from_reader
#
# @param reader object with method tgread_string()
# @return ImportContactTokenRequest
ImportContactTokenRequest$from_reader <- function(reader) {
  token_val <- reader$tgread_string()
  ImportContactTokenRequest$new(token = token_val)
}


#  ImportContactsRequest
# 
#  R6 representation of the TL request: ImportContactsRequest
# 
# 
#  @description
#  Methods:
#  - initialize(contacts): create new request
#  - to_list(): return a list representation suitable for JSON/dumping
#  - to_bytes(): return raw vector of bytes for the TL request
#  @export
#  @noRd
#  @noRd
ImportContactsRequest <- R6::R6Class(
  "ImportContactsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x2c800be5,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8172ad93,
    #  @field contacts Field.
    contacts = NULL,

    #  @description Initialize ImportContactsRequest
    # 
    #  @param contacts list of input_contact objects or raw representations
    initialize = function(contacts) {
      if (!is.null(contacts) && !is.list(contacts)) {
        stop("contacts must be a list")
      }
      self$contacts <- contacts
    },

    #  Convert to list
    # 
    #  @return list
    to_list = function() {
      contacts_repr <- NULL
      if (!is.null(self$contacts)) {
        contacts_repr <- lapply(self$contacts, function(x) {
          if (inherits(x, "TLObject") || inherits(x, "R6")) {
            if (is.function(x$to_list)) x$to_list() else x
          } else {
            x
          }
        })
      }
      list(`_` = "ImportContactsRequest", contacts = contacts_repr)
    },

    #  Serialize to bytes (raw vector)
    # 
    #  Creates TL vector of contacts (constructor + length + concatenated items).
    #  Each contact is expected to provide to_bytes() or be a raw vector.
    # 
    #  @return raw
    to_bytes = function() {
      prefix <- as.raw(c(0xe5, 0x0b, 0x80, 0x2c)) # little-endian of 0x2c800be5
      vector_constructor <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c)) # 0x1cb5c415 little-endian
      contacts_len_raw <- private$int_to_le_raw(length(self$contacts), size = 4L)
      contacts_bytes <- raw(0)
      if (!is.null(self$contacts) && length(self$contacts) > 0L) {
        parts <- list()
        for (item in self$contacts) {
          if (!is.null(item) && is.function(item$to_bytes)) {
            parts[[length(parts) + 1L]] <- item$to_bytes()
          } else if (!is.null(item) && is.raw(item)) {
            parts[[length(parts) + 1L]] <- item
          } else {
            stop("each contacts element must provide to_bytes() or be a raw vector")
          }
        }
        if (length(parts) > 0L) contacts_bytes <- do.call(c, parts)
      }
      c(prefix, vector_constructor, contacts_len_raw, contacts_bytes)
    }
  ),
  private = list(
    #  Convert integer to little-endian raw vector of given size (bytes)
    int_to_le_raw = function(x, size = 4L) {
      xi <- as.integer(x)
      v <- raw(size)
      for (i in seq_len(size)) {
        v[i] <- as.raw(bitwAnd(bitwShiftR(xi, 8L * (i - 1L)), 0xff))
      }
      v
    }
  ),
  active = list(),
  class = TRUE
)

# Create ImportContactsRequest from reader
# @name ImportContactsRequest_from_reader
#
# @param reader object with methods read_int() and tgread_object()
# @return ImportContactsRequest
ImportContactsRequest$from_reader <- function(reader) {
  # consume vector constructor id (typical TL format)
  reader$read_int()
  count <- reader$read_int()
  contacts_list <- vector("list", count)
  if (count > 0L) {
    for (i in seq_len(count)) {
      contacts_list[[i]] <- reader$tgread_object()
    }
  }
  ImportContactsRequest$new(contacts = contacts_list)
}


#  ResetSavedRequest
# 
#  R6 representation of the TL request: ResetSavedRequest
# 
#  @description
#  Methods:
#  - initialize(): create new request
#  - to_list(): return a list representation suitable for JSON/dumping
#  - to_bytes(): return raw vector of bytes for the TL request
#  @export
#  @noRd
#  @noRd
ResetSavedRequest <- R6::R6Class(
  "ResetSavedRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x879537f1,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,

    #  @description Initialize ResetSavedRequest
    # 
    #  No parameters.
    initialize = function() {
      invisible(NULL)
    },

    #  Convert to list
    # 
    #  @return list
    to_list = function() {
      list(`_` = "ResetSavedRequest")
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      # little-endian of 0x879537f1 -> 0xf1 0x37 0x95 0x87
      as.raw(c(0xf1, 0x37, 0x95, 0x87))
    }
  ),
  private = list(),
  active = list(),
  class = TRUE
)

# Create ResetSavedRequest from reader
# @name ResetSavedRequest_from_reader
#
# @param reader object (not used for this constructor)
# @return ResetSavedRequest
ResetSavedRequest$from_reader <- function(reader) {
  ResetSavedRequest$new()
}


#  ResetTopPeerRatingRequest
# 
#  R6 representation of the TL request: ResetTopPeerRatingRequest
# 
# 
#  @description
#  Methods:
#  - initialize(category, peer): create new request
#  - resolve(client, utils): resolve peer into input_peer using client/utils
#  - to_list(): return a list representation suitable for JSON/dumping
#  - to_bytes(): return raw vector of bytes for the TL request
#  @export
#  @noRd
#  @noRd
ResetTopPeerRatingRequest <- R6::R6Class(
  "ResetTopPeerRatingRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x1ae373ac,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field category Field.
    category = NULL,
    #  @field peer Field.
    peer = NULL,

    #  @description Initialize ResetTopPeerRatingRequest
    # 
    #  @param category TL object for TopPeerCategory
    #  @param peer input_peer object or identifier
    initialize = function(category, peer) {
      self$category <- category
      self$peer <- peer
    },

    #  Resolve entities using client and utils
    # 
    #  This will replace `peer` with an input_peer object obtained via utils$get_input_peer(...)
    #  @param client client object with method get_input_entity()
    #  @param utils utils object with method get_input_peer()
    resolve = function(client, utils) {
      entity <- client$get_input_entity(self$peer)
      self$peer <- utils$get_input_peer(entity)
      invisible(NULL)
    },

    #  Convert to list
    # 
    #  @return list
    to_list = function() {
      category_repr <- if (!is.null(self$category) && is.function(self$category$to_list)) self$category$to_list() else self$category
      peer_repr <- if (!is.null(self$peer) && is.function(self$peer$to_list)) self$peer$to_list() else self$peer
      list(`_` = "ResetTopPeerRatingRequest", category = category_repr, peer = peer_repr)
    },

    #  Serialize to bytes (raw vector)
    # 
    #  Concatenates constructor id and serialized bytes of category and peer.
    #  Expects category and peer to provide to_bytes() or be raw vectors.
    # 
    #  @return raw
    to_bytes = function() {
      # little-endian of 0x1ae373ac -> 0xac 0x73 0xe3 0x1a
      prefix <- as.raw(c(0xac, 0x73, 0xe3, 0x1a))

      category_bytes <- NULL
      if (!is.null(self$category) && is.function(self$category$to_bytes)) {
        category_bytes <- self$category$to_bytes()
      } else if (!is.null(self$category) && is.raw(self$category)) {
        category_bytes <- self$category
      } else {
        stop("category must provide to_bytes() or be a raw vector")
      }

      peer_bytes <- NULL
      if (!is.null(self$peer) && is.function(self$peer$to_bytes)) {
        peer_bytes <- self$peer$to_bytes()
      } else if (!is.null(self$peer) && is.raw(self$peer)) {
        peer_bytes <- self$peer
      } else {
        stop("peer must provide to_bytes() or be a raw vector")
      }

      c(prefix, category_bytes, peer_bytes)
    }
  ),
  private = list(),
  active = list(),
  class = TRUE
)

# Create ResetTopPeerRatingRequest from reader
# @name ResetTopPeerRatingRequest_from_reader
#
# @param reader object with method tgread_object()
# @return ResetTopPeerRatingRequest
ResetTopPeerRatingRequest$from_reader <- function(reader) {
  category_val <- reader$tgread_object()
  peer_val <- reader$tgread_object()
  ResetTopPeerRatingRequest$new(category = category_val, peer = peer_val)
}


#  ResolvePhoneRequest
# 
#  R6 representation of the TL request: ResolvePhoneRequest
# 
# 
#  @description
#  Methods:
#  - initialize(phone): create new request
#  - to_list(): return a list representation suitable for JSON/dumping
#  - to_bytes(): return raw vector of bytes for the TL request
#  @export
#  @noRd
#  @noRd
ResolvePhoneRequest <- R6::R6Class(
  "ResolvePhoneRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x8af94344,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf065b3a8,
    #  @field phone Field.
    phone = NULL,

    #  @description Initialize ResolvePhoneRequest
    # 
    #  @param phone character phone string
    initialize = function(phone) {
      self$phone <- as.character(phone)
    },

    #  Convert to list
    # 
    #  @return list
    to_list = function() {
      list(`_` = "ResolvePhoneRequest", phone = self$phone)
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      prefix <- as.raw(c(0x44, 0x43, 0xf9, 0x8a)) # little-endian of 0x8af94344
      phone_bytes <- private$serialize_string_tl(self$phone)
      c(prefix, phone_bytes)
    }
  ),
  private = list(
    #  Convert integer to little-endian raw vector of given size (bytes)
    int_to_le_raw = function(x, size = 4L) {
      xi <- as.integer(x)
      v <- raw(size)
      for (i in seq_len(size)) {
        v[i] <- as.raw(bitwAnd(bitwShiftR(xi, 8L * (i - 1L)), 0xff))
      }
      v
    },

    #  Serialize an R string to TL string bytes (per Telegram TL encoding)
    serialize_string_tl = function(s) {
      if (is.null(s)) {
        return(raw(0))
      }
      sb <- charToRaw(enc2utf8(as.character(s)))
      ln <- length(sb)
      if (ln < 254L) {
        header <- as.raw(ln)
        payload <- sb
        total <- 1 + ln
      } else {
        header <- as.raw(c(
          254L,
          as.raw(bitwAnd(ln, 0xff)),
          as.raw(bitwAnd(bitwShiftR(ln, 8L), 0xff)),
          as.raw(bitwAnd(bitwShiftR(ln, 16L), 0xff))
        ))
        payload <- sb
        total <- 4 + ln
      }
      pad_len <- (4L - (total %% 4L)) %% 4L
      padding <- if (pad_len > 0L) as.raw(rep(0, pad_len)) else raw(0)
      c(header, payload, padding)
    }
  ),
  active = list(),
  class = TRUE
)

# Create ResolvePhoneRequest from reader
# @name ResolvePhoneRequest_from_reader
#
# @param reader object with method tgread_string()
# @return ResolvePhoneRequest
ResolvePhoneRequest$from_reader <- function(reader) {
  phone_val <- reader$tgread_string()
  ResolvePhoneRequest$new(phone = phone_val)
}


#  ResolveUsernameRequest
# 
#  R6 representation of the TL request: ResolveUsernameRequest
# 
# 
#  @description
#  Methods:
#  - initialize(username, referer = NULL): create new request
#  - to_list(): return a list representation suitable for JSON/dumping
#  - to_bytes(): return raw vector of bytes for the TL request
#  @export
#  @noRd
#  @noRd
ResolveUsernameRequest <- R6::R6Class(
  "ResolveUsernameRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x725afbbc,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf065b3a8,
    #  @field username Field.
    username = NULL,
    #  @field referer Field.
    referer = NULL,

    #  @description Initialize ResolveUsernameRequest
    # 
    #  @param username character username
    #  @param referer character or NULL referer
    initialize = function(username, referer = NULL) {
      self$username <- as.character(username)
      if (!is.null(referer)) self$referer <- as.character(referer) else self$referer <- NULL
    },

    #  Convert to list
    # 
    #  @return list
    to_list = function() {
      list(`_` = "ResolveUsernameRequest", username = self$username, referer = self$referer)
    },

    #  Serialize to bytes (raw vector)
    # 
    #  Packs flags indicating presence of referer and serializes username and optional referer.
    #  @return raw
    to_bytes = function() {
      prefix <- as.raw(c(0xbc, 0xfb, 0x5a, 0x72)) # little-endian of 0x725afbbc
      flags_val <- if (is.null(self$referer) || identical(self$referer, FALSE)) 0L else 1L
      flags_raw <- private$int_to_le_raw(as.integer(flags_val), size = 4L)
      username_bytes <- private$serialize_string_tl(self$username)
      referer_bytes <- if (flags_val == 1L) private$serialize_string_tl(self$referer) else raw(0)
      c(prefix, flags_raw, username_bytes, referer_bytes)
    }
  ),
  private = list(
    #  Convert integer to little-endian raw vector of given size (bytes)
    int_to_le_raw = function(x, size = 4L) {
      xi <- as.integer(x)
      v <- raw(size)
      for (i in seq_len(size)) {
        v[i] <- as.raw(bitwAnd(bitwShiftR(xi, 8L * (i - 1L)), 0xff))
      }
      v
    },

    #  Serialize an R string to TL string bytes (per Telegram TL encoding)
    serialize_string_tl = function(s) {
      if (is.null(s)) {
        return(raw(0))
      }
      sb <- charToRaw(enc2utf8(as.character(s)))
      ln <- length(sb)
      if (ln < 254L) {
        header <- as.raw(ln)
        payload <- sb
        total <- 1 + ln
      } else {
        header <- as.raw(c(
          254L,
          as.raw(bitwAnd(ln, 0xff)),
          as.raw(bitwAnd(bitwShiftR(ln, 8L), 0xff)),
          as.raw(bitwAnd(bitwShiftR(ln, 16L), 0xff))
        ))
        payload <- sb
        total <- 4 + ln
      }
      pad_len <- (4L - (total %% 4L)) %% 4L
      padding <- if (pad_len > 0L) as.raw(rep(0, pad_len)) else raw(0)
      c(header, payload, padding)
    }
  ),
  active = list(),
  class = TRUE
)

# Create ResolveUsernameRequest from reader
# @name ResolveUsernameRequest_from_reader
#
# @param reader object with methods read_int() and tgread_string()
# @return ResolveUsernameRequest
ResolveUsernameRequest$from_reader <- function(reader) {
  flags_val <- reader$read_int()
  username_val <- reader$tgread_string()
  referer_val <- if (bitwAnd(flags_val, 1L) != 0L) reader$tgread_string() else NULL
  ResolveUsernameRequest$new(username = username_val, referer = referer_val)
}


#  SetBlockedRequest
# 
#  R6 representation of the TL request: SetBlockedRequest
# 
# 
#  @description
#  Methods:
#  - initialize(id, limit, my_stories_from = NULL): create new request
#  - resolve(client, utils): resolve id list into input_peer objects using client/utils
#  - to_list(): return a list representation
#  - to_bytes(): return raw vector of bytes for the TL request
#  - from_reader(reader): class method to read from a reader and return a new instance
#  @export
#  @noRd
#  @noRd
SetBlockedRequest <- R6::R6Class(
  "SetBlockedRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x94c65c76,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field id Field.
    id = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field my_stories_from Field.
    my_stories_from = NULL,

    #  @description Initialize SetBlockedRequest
    # 
    #  @param id list of input peer objects or raw representations
    #  @param limit integer
    #  @param my_stories_from logical or NULL
    initialize = function(id, limit, my_stories_from = NULL) {
      # Expect id to be a list
      if (!is.null(id) && !is.list(id)) {
        stop("id must be a list")
      }
      self$id <- id
      self$limit <- as.integer(limit)
      if (!is.null(my_stories_from)) {
        self$my_stories_from <- as.logical(my_stories_from)
      } else {
        self$my_stories_from <- NULL
      }
    },

    #  Resolve entities using client and utils
    # 
    #  This will replace each element of `id` with an input_peer object obtained via utils$get_input_peer(...)
    # 
    #  @param client client object with method get_input_entity()
    #  @param utils utils object with method get_input_peer()
    resolve = function(client, utils) {
      if (is.null(self$id)) {
        return(invisible(NULL))
      }
      tmp <- list()
      for (x in self$id) {
        entity <- client$get_input_entity(x)
        tmp[[length(tmp) + 1L]] <- utils$get_input_peer(entity)
      }
      self$id <- tmp
      invisible(NULL)
    },

    #  Convert to list
    # 
    #  @return list
    to_list = function() {
      id_repr <- NULL
      if (!is.null(self$id)) {
        id_repr <- lapply(self$id, function(x) {
          if (inherits(x, "TLObject") || inherits(x, "R6")) {
            if (is.function(x$to_list)) x$to_list() else x
          } else {
            x
          }
        })
      }
      list(`_` = "SetBlockedRequest", id = id_repr, limit = self$limit, my_stories_from = self$my_stories_from)
    },

    #  Serialize to bytes (raw vector)
    # 
    #  Packs flags as uint32 little-endian and appends id sequence and limit.
    #  Assumes each element in id has method to_bytes() which returns a raw vector or is a raw vector.
    # 
    #  @return raw
    to_bytes = function() {
      flags_val <- if (is.null(self$my_stories_from) || identical(self$my_stories_from, FALSE)) 0L else 1L
      prefix <- as.raw(c(0x76, 0x5c, 0xc6, 0x94))
      flags_raw <- private$int_to_le_raw(as.integer(flags_val), size = 4L)
      # Vector constructor id for TL vectors (0x1cb5c415) little-endian
      vector_constructor <- as.raw(c(0x15, 0xc4, 0xb5, 0x1c))
      # length of id list
      id_len_raw <- private$int_to_le_raw(length(self$id), size = 4L)
      id_bytes <- raw(0)
      if (!is.null(self$id)) {
        parts <- list()
        for (element in self$id) {
          if (!is.null(element) && is.function(element$to_bytes)) {
            parts[[length(parts) + 1L]] <- element$to_bytes()
          } else if (!is.null(element) && is.raw(element)) {
            parts[[length(parts) + 1L]] <- element
          } else {
            stop("each id element must provide to_bytes() or be a raw vector")
          }
        }
        if (length(parts) > 0L) id_bytes <- do.call(c, parts)
      }
      limit_raw <- private$int_to_le_raw(as.integer(self$limit), size = 4L)
      c(prefix, flags_raw, vector_constructor, id_len_raw, id_bytes, limit_raw)
    }
  ),
  private = list(
    #  Convert integer to little-endian raw vector of given size (bytes)
    int_to_le_raw = function(x, size = 4L) {
      xi <- as.integer(x)
      v <- raw(size)
      for (i in seq_len(size)) {
        v[i] <- as.raw(bitwAnd(bitwShiftR(xi, 8L * (i - 1L)), 0xff))
      }
      v
    }
  ),
  active = list(),
  class = TRUE
)

# Create SetBlockedRequest from reader
# @name SetBlockedRequest_from_reader
#
# @param reader object that implements read_int() and tgread_object()
# @return SetBlockedRequest
SetBlockedRequest$from_reader <- function(reader) {
  flagsVal <- reader$read_int()
  myStoriesFlag <- bitwAnd(flagsVal, 1L) != 0L
  # consume vector constructor id (typical TL format)
  # vectorConstructor <- reader$read_int()
  count <- reader$read_int()
  id_list <- vector("list", count)
  if (count > 0L) {
    for (i in seq_len(count)) {
      id_list[[i]] <- reader$tgread_object()
    }
  }
  limit_val <- reader$read_int()
  SetBlockedRequest$new(id = id_list, limit = limit_val, my_stories_from = myStoriesFlag)
}


#  ToggleTopPeersRequest
# 
#  R6 representation of the TL request: ToggleTopPeersRequest
# 
# 
#  @description
#  Methods:
#  - initialize(enabled): create new request
#  - to_list(): return a list representation suitable for JSON/dumping
#  - to_bytes(): return raw vector of bytes for the TL request
#  - from_reader(reader): class method to read from a reader and return a new instance
#  @export
#  @noRd
#  @noRd
ToggleTopPeersRequest <- R6::R6Class(
  "ToggleTopPeersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x8514bdda,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field enabled Field.
    enabled = NULL,

    #  @description Initialize ToggleTopPeersRequest
    # 
    #  @param enabled logical
    initialize = function(enabled) {
      self$enabled <- as.logical(enabled)
    },

    #  Convert to list
    # 
    #  @return list
    to_list = function() {
      list(`_` = "ToggleTopPeersRequest", enabled = self$enabled)
    },

    #  Serialize to bytes (raw vector)
    # 
    #  @return raw
    to_bytes = function() {
      prefix <- as.raw(c(0xda, 0xbd, 0x14, 0x85))
      true_bytes <- as.raw(c(0xb5, 0x75, 0x72, 0x99))
      false_bytes <- as.raw(c(0x37, 0x97, 0x79, 0xbc))
      c(prefix, if (isTRUE(self$enabled)) true_bytes else false_bytes)
    }
  ),
  active = list(),
  private = list(),
  class = TRUE
)

# Create ToggleTopPeersRequest from reader
# @name ToggleTopPeersRequest_from_reader
#
# @param reader object with method tgread_bool() that returns logical
# @return ToggleTopPeersRequest
ToggleTopPeersRequest$from_reader <- function(reader) {
  enabled_val <- reader$tgread_bool()
  ToggleTopPeersRequest$new(enabled = enabled_val)
}


#  UnblockRequest
# 
#  R6 representation of the TL request: UnblockRequest
# 
# 
#  @description
#  Methods:
#  - initialize(id, my_stories_from = NULL): create new request
#  - resolve(client, utils): resolve id into input peer using client/utils
#  - to_list(): return a list representation
#  - to_bytes(): return raw vector of bytes for the TL request (little-endian integer packing used)
#  - from_reader(reader): class method to read from a reader and return a new instance
#  @export
#  @noRd
#  @noRd
UnblockRequest <- R6::R6Class(
  "UnblockRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xb550d328,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field id Field.
    id = NULL,
    #  @field my_stories_from Field.
    my_stories_from = NULL,

    #  @description Initialize UnblockRequest
    # 
    #  @param id input peer (object or identifier)
    #  @param my_stories_from logical or NULL
    initialize = function(id, my_stories_from = NULL) {
      self$id <- id
      if (!is.null(my_stories_from)) {
        self$my_stories_from <- as.logical(my_stories_from)
      } else {
        self$my_stories_from <- NULL
      }
    },

    #  Resolve entities using client and utils
    # 
    #  This will replace `id` with an input_peer object obtained via utils$get_input_peer(...)
    # 
    #  @param client client object with method get_input_entity()
    #  @param utils utils object with method get_input_peer()
    resolve = function(client, utils) {
      # Expect client$get_input_entity to return an entity; utils$get_input_peer converts it
      entity <- client$get_input_entity(self$id)
      self$id <- utils$get_input_peer(entity)
      invisible(NULL)
    },

    #  Convert to list
    # 
    #  @return list
    to_list = function() {
      id_repr <- if (inherits(self$id, "TLObject") || inherits(self$id, "R6")) {
        if (is.function(self$id$to_list)) self$id$to_list() else self$id
      } else {
        self$id
      }
      list(`_` = "UnblockRequest", id = id_repr, my_stories_from = self$my_stories_from)
    },

    #  Serialize to bytes (raw vector)
    # 
    #  Packs flags as uint32 little-endian and appends id bytes.
    #  Assumes id has method to_bytes() which returns raw vector.
    # 
    #  @return raw
    to_bytes = function() {
      flags_val <- if (is.null(self$my_stories_from) || identical(self$my_stories_from, FALSE)) 0L else 1L
      prefix <- as.raw(c(0x28, 0xd3, 0x50, 0xb5))
      flags_raw <- private$int_to_le_raw(flags_val, size = 4L)
      id_bytes <- NULL
      if (!is.null(self$id) && is.function(self$id$to_bytes)) {
        id_bytes <- self$id$to_bytes()
      } else if (!is.null(self$id) && is.raw(self$id)) {
        id_bytes <- self$id
      } else {
        stop("id must provide to_bytes() or be a raw vector")
      }
      c(prefix, flags_raw, id_bytes)
    }
  ),
  private = list(
    #  Convert integer to little-endian raw vector of given size (bytes)
    # 
    int_to_le_raw = function(x, size = 4L) {
      xi <- as.integer(x)
      v <- raw(size)
      for (i in seq_len(size)) {
        v[i] <- as.raw(bitwAnd(bitwShiftR(xi, 8L * (i - 1L)), 0xff))
      }
      v
    }
  ),
  class = TRUE
)

# Create UnblockRequest from reader
# @name UnblockRequest_from_reader
#
# @param reader object that implements read_int() and tgread_object()
# @return UnblockRequest
UnblockRequest$from_reader <- function(reader) {
  flags <- reader$read_int()
  myStoriesFlag <- bitwAnd(flags, 1L) != 0L
  id_obj <- reader$tgread_object()
  UnblockRequest$new(id = id_obj, my_stories_from = myStoriesFlag)
}
