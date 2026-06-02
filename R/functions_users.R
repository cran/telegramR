#  GetFullUserRequest
# 
#  An R6 class representing a request to get full information about a user.
#  This class inherits from TLRequest and is used to construct and serialize
#  Telegram API requests for retrieving detailed user data.
# 
#    representation accepted by get_input_user. This field is resolved
#    during the request preparation.
#  @title GetFullUserRequest
#  @description Telegram API type GetFullUserRequest
#  @export
#  @noRd
#  @noRd
GetFullUserRequest <- R6::R6Class(
  "GetFullUserRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xb60f5918,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x83df9df5,
    #  @field id Field.
    id = NULL,

    #  @description Request to get full information about a user.
    #  @param id TLInputUser or a representation accepted by utils$get_input_user
    initialize = function(id = NULL) {
      self$id <- id
    },

    #  @description Resolves the id field using the provided client and utils.
    #  @param client A client object to resolve user references.
    #  @param utils A utils object with methods to get input user representations.
    resolve = function(client, utils) {
      if (!is.null(self$id)) {
        self$id <- get_input_user(client$get_input_entity(self$id))
      }
    },

    #  @description Converts the GetFullUserRequest to a dictionary (list).
    #  @return A list representation of the GetFullUserRequest.
    to_dict = function() {
      list(
        `_` = "GetFullUserRequest",
        id = if (!is.null(self$id) && inherits(self$id, "TLObject")) self$id$to_dict() else self$id
      )
    },

    #  @description Converts the GetFullUserRequest to raw bytes.
    #  @return A raw vector representing the GetFullUserRequest.
    bytes = function() {
      con <- rawConnection(raw(0), "r+")
      on.exit(close(con))

      # constructor id (little-endian bytes)
      writeBin(as.raw(c(0x18, 0x59, 0x0f, 0xb6)), con)

      # id bytes
      if (!is.null(self$id) && is.function(self$id$bytes)) {
        writeBin(self$id$bytes(), con)
      } else if (!is.null(self$id) && is.raw(self$id)) {
        writeBin(self$id, con)
      }

      rawConnectionValue(con)
    },

    #  @description Creates a GetFullUserRequest from a reader object.
    #  @param reader A reader object to read the response.
    #  @return A new instance of GetFullUserRequest.
    from_reader = function(reader) {
      id_obj <- reader$tgread_object()
      self$new(id = id_obj)
    }
  )
)


#  @title GetRequirementsToContactRequest
#  @description R6 request class to obtain a vector of RequirementToContact objects for multiple users. It serializes the request to Telegram TL bytes and can deserialize from a TL reader. The request resolves plain user references into TLInputUser objects before serialization.
#  @export
#  @noRd
#  @noRd
GetRequirementsToContactRequest <- R6::R6Class(
  "GetRequirementsToContactRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xd89a83a3,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x322623c3,
    #  @field id Field.
    id = NULL,

    #  @description Initialize a new GetRequirementsToContactRequest.
    #  @param id list|NULL List of user references (usernames, ids, TL objects) to be resolved to TLInputUser; NULL for an empty list.
    #  @return A new GetRequirementsToContactRequest object.
    initialize = function(id = NULL) {
      self$id <- id
    },

    #  @description Resolve plain user references in id to TLInputUser objects using the provided client/utilities.
    #  @param client An object exposing get_input_entity for resolving user references.
    #  @param utils Auxiliary utilities object (not directly used but kept for parity with other requests).
    #  @return NULL (modifies the object in place).
    resolve = function(client, utils) {
      if (!is.null(self$id) && length(self$id) > 0) {
        tmp_list <- list()
        for (i in seq_along(self$id)) {
          tmp_list[[i]] <- get_input_user(client$get_input_entity(self$id[[i]]))
        }
        self$id <- tmp_list
      }
    },

    #  @description Convert the request to a plain list (dictionary style) suitable for JSON/logging.
    #  @return list Representation with `_` discriminator and serialized id list.
    to_dict = function() {
      list(
        `_` = "GetRequirementsToContactRequest",
        id = if (is.null(self$id)) list() else lapply(self$id, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Serialize the request into a raw vector of TL-encoded bytes.
    #  @return raw Raw vector containing the TL serialization.
    bytes = function() {
      con <- rawConnection(raw(0), "r+")
      on.exit(close(con))

      # constructor id (little-endian)
      writeBin(as.raw(c(0xa3, 0x83, 0x9a, 0xd8)), con)

      # vector constructor for id (0x1cb5c415 little-endian)
      writeBin(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), con)

      # length of id vector (int32 little-endian)
      writeBin(as.integer(if (is.null(self$id)) 0L else length(self$id)), con, size = 4, endian = "little")

      # append each id object's bytes
      if (!is.null(self$id) && length(self$id) > 0) {
        for (elem in self$id) {
          if (!is.null(elem) && is.function(elem$bytes)) {
            writeBin(elem$bytes(), con)
          } else if (!is.null(elem) && is.raw(elem)) {
            writeBin(elem, con)
          }
        }
      }

      rawConnectionValue(con)
    },

    #  @description Deserialize a GetRequirementsToContactRequest from a TL reader.
    #  @param reader A TL reader object providing tgread_object(), read_int().
    #  @return GetRequirementsToContactRequest A newly constructed request object populated from the reader.
    from_reader = function(reader) {
      # read and ignore the vector constructor int
      reader$read_int()
      id_list <- list()
      count <- reader$read_int()
      if (count > 0) {
        for (i in seq_len(count)) {
          x <- reader$tgread_object()
          id_list[[i]] <- x
        }
      }
      self$new(id = id_list)
    }
  )
)


#  GetSavedMusicRequest
# 
#  Request to get saved music for a user.
# 
#  @title GetSavedMusicRequest
#  @description Telegram API type GetSavedMusicRequest
#  @export
#  @noRd
#  @noRd
GetSavedMusicRequest <- R6::R6Class(
  "GetSavedMusicRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x788d7fe3,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf813ae37,
    #  @field id Field.
    id = NULL,
    #  @field offset Field.
    offset = NULL,
    #  @field limit Field.
    limit = NULL,
    #  @field hash Field.
    hash = NULL,

    #  @description Request to get saved music for a user.
    #  @param id TLInputUser or a representation accepted by get_input_user
    #  @param offset Integer offset for pagination.
    #  @param limit Integer limit for the number of items to retrieve.
    #  @param hash Integer64 hash for caching purposes (may be represented as numeric in R
    initialize = function(id = NULL, offset = NULL, limit = NULL, hash = NULL) {
      self$id <- id
      self$offset <- offset
      self$limit <- limit
      self$hash <- hash
    },

    #  @description Converts the GetSavedMusicRequest to a dictionary (list).
    #  @param client A client object to resolve user references.
    #  @param utils A utils object with methods to get input user representations.
    #  @return A list representation of the GetSavedMusicRequest.
    resolve = function(client, utils) {
      if (!is.null(self$id)) {
        self$id <- get_input_user(client$get_input_entity(self$id))
      }
    },

    #  @description Resolves the id field using the provided client and utils.
    #  @return A raw vector representing the GetSavedMusicRequest.
    to_dict = function() {
      list(
        `_` = "GetSavedMusicRequest",
        id = if (!is.null(self$id) && inherits(self$id, "TLObject")) self$id$to_dict() else self$id,
        offset = self$offset,
        limit = self$limit,
        hash = self$hash
      )
    },

    #  @description Converts the GetSavedMusicRequest to raw bytes.
    #  @return A raw vector representing the GetSavedMusicRequest.
    bytes = function() {
      con <- rawConnection(raw(0), "r+")
      on.exit(close(con))

      # constructor id (little-endian)
      writeBin(as.raw(c(0xe3, 0x7f, 0x8d, 0x78)), con)

      # id bytes
      if (!is.null(self$id) && is.function(self$id$bytes)) {
        writeBin(self$id$bytes(), con)
      } else if (!is.null(self$id) && is.raw(self$id)) {
        writeBin(self$id, con)
      }

      # offset (int32 little-endian)
      writeBin(as.integer(self$offset), con, size = 4, endian = "little")

      # limit (int32 little-endian)
      writeBin(as.integer(self$limit), con, size = 4, endian = "little")

      # hash (int64 little-endian). Represented as numeric in R; may lose precision for very large values.
      writeBin(as.numeric(self$hash), con, size = 8, endian = "little")

      rawConnectionValue(con)
    },

    #  @description Initializes the GetSavedMusicRequest.
    #  @param reader A reader object to read the response.
    #  @return A new instance of GetSavedMusicRequest.
    from_reader = function(reader) {
      id_obj <- reader$tgread_object()
      offset_val <- reader$read_int()
      limit_val <- reader$read_int()
      hash_val <- reader$read_long()
      self$new(id = id_obj, offset = offset_val, limit = limit_val, hash = hash_val)
    }
  )
)


#  GetSavedMusicByIDRequest
# 
#  Request to get saved music by document IDs for a user.
# 
#  @title GetSavedMusicByIDRequest
#  @description Telegram API type GetSavedMusicByIDRequest
#  @export
#  @noRd
#  @noRd
GetSavedMusicByIDRequest <- R6::R6Class(
  "GetSavedMusicByIDRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x7573a4e9,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf813ae37,
    #  @field id Field.
    id = NULL,
    #  @field documents Field.
    documents = NULL,

    #  @description Request to get saved music by document IDs for a user.
    #  @param id TLInputUser or a representation accepted by get_input_user
    #  @param documents List of TLInputDocument or representations accepted by get_input_document
    initialize = function(id = NULL, documents = NULL) {
      self$id <- id
      self$documents <- documents
    },

    #  @description Converts the GetSavedMusicByIDRequest to a dictionary (list).
    #  @param client A client object to resolve user references.
    #  @param utils A utils object with methods to get input user and document representations.
    resolve = function(client, utils) {
      # Translate asynchronous style to synchronous calls expected in R.
      if (!is.null(self$id)) {
        self$id <- get_input_user(client$get_input_entity(self$id))
      }
      if (!is.null(self$documents) && length(self$documents) > 0) {
        tmp_list <- list()
        for (i in seq_along(self$documents)) {
          tmp_list[[i]] <- get_input_document(self$documents[[i]])
        }
        self$documents <- tmp_list
      }
    },

    #  @description Converts the GetSavedMusicByIDRequest to raw bytes.
    #  @return A raw vector representing the GetSavedMusicByIDRequest.
    to_dict = function() {
      list(
        `_` = "GetSavedMusicByIDRequest",
        id = if (!is.null(self$id) && inherits(self$id, "TLObject")) self$id$to_dict() else self$id,
        documents = if (is.null(self$documents)) list() else lapply(self$documents, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Initializes the GetSavedMusicByIDRequest.
    #  @return A raw vector representing the GetSavedMusicByIDRequest.
    bytes = function() {
      con <- rawConnection(raw(0), "r+")
      on.exit(close(con))

      # constructor id (little-endian bytes)
      writeBin(as.raw(c(0xe9, 0xa4, 0x73, 0x75)), con)

      # id bytes
      if (!is.null(self$id) && is.function(self$id$bytes)) {
        writeBin(self$id$bytes(), con)
      } else if (!is.null(self$id) && is.raw(self$id)) {
        writeBin(self$id, con)
      }

      # vector constructor for documents (0x1cb5c415 little-endian: b'\x15\xc4\xb5\x1c')
      writeBin(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), con)

      # length of documents vector (int32 little-endian)
      writeBin(as.integer(if (is.null(self$documents)) 0L else length(self$documents)), con, size = 4, endian = "little")

      # append each document object's bytes
      if (!is.null(self$documents) && length(self$documents) > 0) {
        for (elem in self$documents) {
          if (!is.null(elem) && is.function(elem$bytes)) {
            writeBin(elem$bytes(), con)
          } else if (!is.null(elem) && is.raw(elem)) {
            writeBin(elem, con)
          }
        }
      }

      rawConnectionValue(con)
    },

    #  @description Request to get saved music by document IDs for a user.
    #  @param reader A reader object to read the response.
    #  @return A new instance of GetSavedMusicByIDRequest.
    from_reader = function(reader) {
      id_obj <- reader$tgread_object()
      # read and ignore the vector constructor int (present in Python-generated code)
      reader$read_int()
      docs_list <- list()
      count <- reader$read_int()
      if (count > 0) {
        for (i in seq_len(count)) {
          x <- reader$tgread_object()
          docs_list[[i]] <- x
        }
      }
      self$new(id = id_obj, documents = docs_list)
    }
  )
)


#  @title GetUsersRequest
#  @description Request to get a vector of users by input user references.
#  @export
#  @noRd
#  @noRd
GetUsersRequest <- R6::R6Class(
  "GetUsersRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x0d91a548,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x406da4d,
    #  @field id Field.
    id = NULL,

    #  @description Initializes the GetUsersRequest.
    #  @param id List of TLInputUser or representations accepted by get_input_user
    initialize = function(id = NULL) {
      self$id <- id
    },

    #  @description Resolves the id field using the provided client and utils.
    #  @param client A client object to resolve user references.
    #  @param utils A utils object with methods to get input user representations.
    resolve = function(client, utils) {
      # Translate asynchronous style to synchronous calls expected in R.
      if (!is.null(self$id) && length(self$id) > 0) {
        tmp_list <- list()
        for (i in seq_along(self$id)) {
          ent <- client$get_input_entity(self$id[[i]])
          if (inherits(ent, "Future")) {
            ent <- future::value(ent)
          }
          tmp_list[[i]] <- get_input_user(ent)
        }
        self$id <- tmp_list
      }
    },

    #  @description Request to get a vector of users by input user references.
    #  @return List of resolved id objects.
    to_dict = function() {
      list(
        `_` = "GetUsersRequest",
        id = if (is.null(self$id)) list() else lapply(self$id, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Initializes the GetUsersRequest.
    #  @return List of resolved id objects.
    bytes = function() {
      con <- rawConnection(raw(0), "r+")
      on.exit(close(con))

      # constructor id (little-endian bytes)
      writeBin(as.raw(c(0x48, 0xa5, 0x91, 0x0d)), con)

      # vector constructor (0x1cb5c415 little-endian)
      writeBin(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), con)

      # length of id vector (int32 little-endian)
      writeBin(as.integer(if (is.null(self$id)) 0L else length(self$id)), con, size = 4, endian = "little")

      # append each id object's bytes
      if (!is.null(self$id) && length(self$id) > 0) {
        for (elem in self$id) {
          if (!is.null(elem) && is.function(elem$bytes)) {
            writeBin(elem$bytes(), con)
          } else if (!is.null(elem) && is.raw(elem)) {
            writeBin(elem, con)
          }
        }
      }

      rawConnectionValue(con)
    },

    #  @description Converts the GetUsersRequest to raw bytes.
    #  @param reader A reader object to read the response.
    #  @return A raw vector representing the GetUsersRequest.
    from_reader = function(reader) {
      # read and ignore the vector constructor int (present in Python-generated code)
      reader$read_int()
      id_list <- list()
      count <- reader$read_int()
      if (count > 0) {
        for (i in seq_len(count)) {
          x <- reader$tgread_object()
          id_list[[i]] <- x
        }
      }
      self$new(id = id_list)
    }
  )
)


#  @title SetSecureValueErrorsRequest
#  @description Represents a request to set secure value errors for a Telegram user.
#  @export
#  @noRd
#  @noRd
SetSecureValueErrorsRequest <- R6::R6Class(
  "SetSecureValueErrorsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x90c894b5,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xf5b399ac,
    #  @field id Field.
    id = NULL,
    #  @field errors Field.
    errors = NULL,

    #  @description Request to set secure value errors for a user.
    #  @param id TLInputUser or a representation accepted by get_input_user
    #  @param errors List of TLSecureValueError or representations accepted by get_secure_value_error
    initialize = function(id = NULL, errors = NULL) {
      self$id <- id
      self$errors <- errors
    },

    #  @description Initializes the SetSecureValueErrorsRequest.
    #  @param id TLInputUser or a representation accepted by get_input_user
    #  @param errors List of TLSecureValueError or representations accepted by get_secure_value
    resolve = function(client, utils) {
      # translate await/async style to synchronous calls expected in R
      self$id <- get_input_user(client$get_input_entity(self$id))
    },

    #  @description Resolves the id and errors fields using the provided client and utils.
    #  @return List with resolved id and errors.
    to_dict = function() {
      list(
        `_` = "SetSecureValueErrorsRequest",
        id = if (!is.null(self$id) && inherits(self$id, "TLObject")) self$id$to_dict() else self$id,
        errors = if (is.null(self$errors)) list() else lapply(self$errors, function(x) if (inherits(x, "TLObject")) x$to_dict() else x)
      )
    },

    #  @description Converts the SetSecureValueErrorsRequest to a dictionary (list).
    #  @return A list representation of the SetSecureValueErrorsRequest.
    bytes = function() {
      # build raw bytes similar to Python implementation
      con <- rawConnection(raw(0), "r+")
      on.exit(close(con))

      # constructor id (little-endian bytes as in Python)
      writeBin(as.raw(c(0xb5, 0x94, 0xc8, 0x90)), con)

      # id bytes
      if (!is.null(self$id) && is.function(self$id$bytes)) {
        writeBin(self$id$bytes(), con)
      } else if (!is.null(self$id) && is.raw(self$id)) {
        writeBin(self$id, con)
      }

      # vector constructor (0x1cb5c415 in little-endian: b'\x15\xc4\xb5\x1c')
      writeBin(as.raw(c(0x15, 0xc4, 0xb5, 0x1c)), con)

      # length of errors (int32 little-endian)
      writeBin(as.integer(length(self$errors)), con, size = 4, endian = "little")

      # append each error object's bytes
      if (!is.null(self$errors) && length(self$errors) > 0) {
        for (err in self$errors) {
          if (!is.null(err) && is.function(err$bytes)) {
            writeBin(err$bytes(), con)
          }
        }
      }

      rawConnectionValue(con)
    },

    #  @description Converts the SetSecureValueErrorsRequest to raw bytes.
    #  @param reader A reader object to read the response.
    #  @return A raw vector representing the SetSecureValueErrorsRequest.
    from_reader = function(reader) {
      id <- reader$tgread_object()
      # read and ignore the vector constructor int (Python code called reader.read_int())
      reader$read_int()
      errors <- list()
      count <- reader$read_int()
      if (count > 0) {
        for (i in seq_len(count)) {
          x <- reader$tgread_object()
          errors[[i]] <- x
        }
      }
      self$new(id = id, errors = errors)
    }
  )
)
