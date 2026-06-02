#  @import base64enc
#  @import jsonlite
NULL
EPOCH_NAIVE <- as.POSIXct("1970-01-01 00:00:00", tz = "UTC")
EPOCH_NAIVE_LOCAL <- as.POSIXct(format(Sys.time(), "%Y-%m-%d %H:%M:%S"), tz = Sys.timezone())
EPOCH <- EPOCH_NAIVE

#  Convert a datetime object to a timestamp.
# 
#  This function converts a datetime object to a timestamp in seconds since the epoch.
#  It handles both UTC and local timezones.
# 
#  @param dt A datetime object to be converted.
#  @return A numeric value representing the timestamp in seconds since the epoch.
#  @examples
#  \donttest{
#  datetime_to_timestamp(as.POSIXct("2023-01-01 12:00:00", tz = "UTC"))
#  datetime_to_timestamp(as.POSIXct("2023-01-01 12:00:00"))
#  }
#  @export
datetime_to_timestamp <- function(dt) {
  if (is.na(attr(dt, "tzone"))) {
    attr(dt, "tzone") <- "UTC"
  }
  secs <- as.numeric(difftime(dt, EPOCH, units = "secs"))
  return(secs %% 2^32)
}

#  Default JSON serialization function.
# 
#  This function is used to serialize various data types to JSON format.
#  It handles raw data, POSIXt objects, and other types.
# 
#  @param value The value to be serialized.
#  @return A character string representing the serialized value.
#  @examples
#  \donttest{
#  json_default(charToRaw("test"))
#  json_default(as.POSIXct("2023-01-01 12:00:00", tz = "UTC"))
#  json_default(123)
#  }
#  @export
json_default <- function(value) {
  if (is.raw(value)) {
    return(base64enc::base64encode(value))
  } else if (inherits(value, "POSIXt")) {
    return(format(value, "%Y-%m-%dT%H:%M:%S"))
  } else {
    return(as.character(value))
  }
}

#  Pretty format a TL object.
# 
#  This function formats a TL object for pretty printing. It handles nested lists,
#  vectors, and other data types.
# 
#  @param obj The object to be formatted.
#  @param indent The current indentation level (used for recursive calls).
#  @return A character string representing the formatted object.
#  @examples
#  \donttest{
#  pretty_format(list(a = 1, b = "test", c = list(d = 2)))
#  pretty_format(c(1, 2, 3))
#  }
#  @export
pretty_format <- function(obj, indent = NULL) {
  if (is.null(indent)) {
    if (inherits(obj, "TLObject")) {
      obj <- obj$to_dict()
    }
    if (is.list(obj)) {
      return(paste0("{", paste(
        sapply(names(obj), function(k) {
          v <- obj[[k]]
          if (inherits(v, "TLObject") && !identical(v, obj)) {
            paste0(k, "=", pretty_format(v$to_dict()))
          } else {
            paste0(k, "=", pretty_format(v))
          }
        }),
        collapse = ", "
      ), "}"))
    } else if (is.character(obj) || is.raw(obj)) {
      return(obj)
    } else if (is.vector(obj)) {
      if (length(obj) == 1) {
        return(as.character(obj))
      }
      return(paste0("[", paste(
        sapply(obj, pretty_format),
        collapse = ", "
      ), "]"))
    } else {
      return(as.character(obj))
    }
  } else {
    result <- list()
    if (inherits(obj, "TLObject")) {
      obj <- obj$to_dict()
    }
    if (is.list(obj)) {
      result <- append(result, list(""))
      if (length(obj) > 0) {
        indent <- indent + 1
        for (k in names(obj)) {
          result <- append(result, list(
            paste0(
              rep("\t", indent),
              collapse = "",
              k,
              "=",
              pretty_format(obj[[k]], indent),
              ","
            )
          ))
        }
        result <- result[-length(result)]
        indent <- indent - 1
      }
      result <- append(result, list(paste0(rep("\t", indent), collapse = "", "")))
    } else if (is.character(obj) || is.raw(obj)) {
      result <- append(result, list(obj))
    } else if (is.vector(obj)) {
      if (length(obj) == 1) {
        result <- append(result, list(as.character(obj)))
      } else {
        result <- append(result, list("["))
        indent <- indent + 1
        for (x in obj) {
          result <- append(result, list(paste0(
            rep("\t", indent),
            collapse = "",
            pretty_format(x, indent),
            ","
          )))
        }
        indent <- indent - 1
        result <- append(result, list(paste0(rep("\t", indent), collapse = "", "]")))
      }
    } else {
      result <- append(result, list(as.character(obj)))
    }
    return(paste(result, collapse = ""))
  }
}

#  Serialize data to bytes.
# 
#  This function serializes data to a byte array. It handles both raw data and character strings.
# 
#  @param data The data to be serialized.
#  @return A raw vector representing the serialized data.
#  @examples
#  \donttest{
#  serialize_bytes(charToRaw("test"))
#  serialize_bytes("test")
#  }
#  @export
serialize_bytes <- function(data) {
  if (!is.raw(data)) {
    if (is.character(data)) {
      data <- charToRaw(data)
    } else {
      stop("bytes or str expected, not ", typeof(data))
    }
  }
  # NOTE: serialize_bytes_cpp is compiled and available, but this wrapper stays
  # pure R because rsa.R calls serialize_bytes() at package load time — before
  # the Rcpp DLL is registered in devtools::load_all() mode.
  r <- list()
  if (length(data) < 254) {
    padding <- (length(data) + 1) %% 4
    if (padding != 0) {
      padding <- 4 - padding
    }
    r <- append(r, list(as.raw(length(data))))
    r <- append(r, list(data))
  } else {
    padding <- length(data) %% 4
    if (padding != 0) {
      padding <- 4 - padding
    }
    r <- append(r, list(as.raw(c(
      254,
      length(data) %% 256,
      (length(data) %/% 256) %% 256,
      (length(data) %/% (256^2)) %% 256
    ))))
    r <- append(r, list(data))
  }
  r <- append(r, list(as.raw(rep(0, padding))))
  return(do.call(c, r))
}

#  Serialize a datetime object to bytes.
# 
#  This function serializes a datetime object to a byte array. It handles various datetime formats,
#  including POSIXct, Date, numeric, and difftime.
# 
#  @param dt The datetime object to be serialized.
#  @return A raw vector representing the serialized datetime.
#  @examples
#  \donttest{
#  serialize_datetime(as.POSIXct("2023-01-01 12:00:00", tz = "UTC"))
#  serialize_datetime(as.Date("2023-01-01"))
#  serialize_datetime(as.numeric(1234567890))
#  serialize_datetime(as.difftime(3600, units = "secs"))
#  }
#  @export
serialize_datetime <- function(dt) {
  if (is.null(dt)) {
    return(as.raw(rep(0, 4)))
  }
  if (inherits(dt, "POSIXt")) {
    dt <- datetime_to_timestamp(dt)
  } else if (inherits(dt, "Date")) {
    dt <- datetime_to_timestamp(as.POSIXct(dt))
  } else if (inherits(dt, "difftime")) {
    dt <- datetime_to_timestamp(Sys.time() + dt)
  }
  if (is.numeric(dt)) {
    dt <- as.integer(dt)
  }
  if (is.integer(dt)) {
    return(packBits(intToBits(dt), "raw"))
  }
  stop("Cannot interpret '", dt, "' as a date.")
}

#  TLObject Class
# 
# 
#  @title TLObject
#  @description Telegram API type TLObject
#  @export
#  @noRd
#  @noRd
TLObject <- R6::R6Class(
  "TLObject",
  public = list(
    #  @field CONSTRUCTOR_ID A unique identifier for the TL object.
    CONSTRUCTOR_ID = NULL,

    #  @field SUBCLASS_OF_ID A unique identifier for the subclass of the TL object.
    SUBCLASS_OF_ID = NULL,

    #  @description
    #  Pretty format the object for display.
    #  @param obj The object to be formatted.
    #  @param indent The current indentation level (used for recursive calls).
    #  @return A character string representing the formatted object.
    pretty_format = function(obj, indent = NULL) {
      if (is.null(indent)) {
        if (inherits(obj, "TLObject")) {
          obj <- obj$to_dict()
        }
        if (is.list(obj)) {
          return(paste0("{", paste(
            sapply(names(obj), function(k) {
              paste0(k, "=", self$pretty_format(obj[[k]]))
            }),
            #  @field collapse Field.
            collapse = ", "
          ), "}"))
        } else if (is.character(obj) || is.raw(obj)) {
          return(obj)
        } else if (is.vector(obj)) {
          return(paste0("[", paste(
            sapply(obj, self$pretty_format),
            #  @field collapse Field.
            collapse = ", "
          ), "]"))
        } else {
          return(as.character(obj))
        }
      } else {
        result <- list()
        if (inherits(obj, "TLObject")) {
          obj <- obj$to_dict()
        }
        if (is.list(obj)) {
          result <- append(result, list(""))
          if (length(obj) > 0) {
            indent <- indent + 1
            for (k in names(obj)) {
              result <- append(result, list(
                paste0(
                  rep("\t", indent),
                  #  @field collapse Field.
                  collapse = "",
                  k,
                  "=",
                  self$pretty_format(obj[[k]], indent),
                  ","
                )
              ))
            }
            result <- result[-length(result)]
            indent <- indent - 1
          }
          result <- append(result, list(paste0(rep("\t", indent), collapse = "", "")))
        } else if (is.character(obj) || is.raw(obj)) {
          result <- append(result, list(obj))
        } else if (is.vector(obj)) {
          result <- append(result, list("["))
          indent <- indent + 1
          for (x in obj) {
            result <- append(result, list(paste0(
              rep("\t", indent),
              #  @field collapse Field.
              collapse = "",
              self$pretty_format(x, indent),
              ","
            )))
          }
          indent <- indent - 1
          result <- append(result, list(paste0(rep("\t", indent), collapse = "", "]")))
        } else {
          result <- append(result, list(as.character(obj)))
        }
        return(paste(result, collapse = ""))
      }
    },

    #  @description
    #  Serialize data to bytes.
    #  @param data The data to be serialized.
    #  @return A raw vector representing the serialized data.
    serialize_bytes = function(data) {
      if (!is.raw(data)) {
        if (is.character(data)) {
          data <- charToRaw(data)
        } else {
          stop("bytes or str expected, not ", typeof(data))
        }
      }
      r <- list()
      if (length(data) < 254) {
        padding <- (length(data) + 1) %% 4
        if (padding != 0) {
          padding <- 4 - padding
        }
        r <- append(r, list(as.raw(length(data))))
        r <- append(r, list(data))
      } else {
        padding <- length(data) %% 4
        if (padding != 0) {
          padding <- 4 - padding
        }
        r <- append(r, list(as.raw(c(
          254,
          length(data) %% 256,
          (length(data) %/% 256) %% 256,
          (length(data) %/% (256^2)) %% 256
        ))))
        r <- append(r, list(data))
      }
      r <- append(r, list(as.raw(rep(0, padding))))
      return(do.call(c, r))
    },

    #  @description
    #  Serialize a datetime object to bytes.
    #  @param dt The datetime object to be serialized.
    #  @return A raw vector representing the serialized datetime.
    serialize_datetime = function(dt) {
      if (is.null(dt)) {
        return(as.raw(rep(0, 4)))
      }
      if (inherits(dt, "POSIXt")) {
        dt <- datetime_to_timestamp(dt)
      } else if (inherits(dt, "Date")) {
        dt <- datetime_to_timestamp(as.POSIXct(dt))
      } else if (inherits(dt, "difftime")) {
        dt <- datetime_to_timestamp(Sys.time() + dt)
      }
      if (is.numeric(dt)) {
        dt <- as.integer(dt)
      }
      if (is.integer(dt)) {
        return(packBits(intToBits(dt), "raw"))
      }
      stop("Cannot interpret '", dt, "' as a date.")
    },

    #  @description
    #  Convert the object to a dictionary representation.
    #  @return A list representing the object.
    to_dict = function() {
      stop("Not implemented")
    },

    #  @description
    #  Convert the object to a JSON representation.
    #  @param fp A file path to write the JSON to (optional).
    #  @param default A function to handle custom serialization (default: json_default).
    #  @param ... Additional arguments to pass to the JSON serialization function.
    #  @return A character string representing the JSON representation of the object.
    to_json = function(fp = NULL, default = json_default, ...) {
      d <- self$to_dict()
      if (!is.null(fp)) {
        writeLines(jsonlite::toJSON(d, auto_unbox = TRUE, ...), con = fp)
      } else {
        return(jsonlite::toJSON(d, auto_unbox = TRUE, ...))
      }
    },

    #  @description
    #  Convert the object to a byte array.
    #  @return A raw vector representing the byte array.
    .bytes = function() {
      stop("Not implemented")
    },

    #  @description
    #  Create a new object from a binary reader.
    #  @param reader A binary reader object.
    #  @return A new object created from the binary reader.
    from_reader = function(reader) {
      stop("Not implemented")
    },

    #  @description
    #  Check if the object is equal to another object.
    #  @param o The object to compare with.
    #  @return A logical value indicating whether the objects are equal.
    .eq = function(o) {
      inherits(o, "TLObject") && identical(self$to_dict(), o$to_dict())
    },

    #  @description
    #  Check if the object is not equal to another object.
    #  @param o The object to compare with.
    #  @return A logical value indicating whether the objects are not equal.
    .ne = function(o) {
      !inherits(o, "TLObject") || !identical(self$to_dict(), o$to_dict())
    },

    #  @description
    #  Convert the object to a string representation.
    #  @return A character string representing the object.
    .str = function() {
      self$pretty_format(self)
    },

    #  @description
    #  Convert the object to a JSON string representation.
    #  @return A character string representing the JSON representation of the object.
    stringify = function() {
      self$pretty_format(self, indent = 0)
    }
  )
)

#  TLRequest Class
# 
# 
#  @title TLRequest
#  @description Telegram API type TLRequest
#  @export
#  @noRd
#  @noRd
TLRequest <- R6::R6Class(
  "TLRequest",
  inherit = TLObject,
  public = list(
    #  @description
    #  Read the result from a binary reader.
    #  @param reader A binary reader object to read the result from.
    #  @return The result read from the binary reader.
    read_result = function(reader) {
      reader$tgread_object()
    },

    #  @description
    #  Resolve the request using a client and utility functions.
    #  @param client A client object to resolve the request.
    #  @param utils A utility object to assist in resolving the request.
    #  @return The resolved result.
    resolve = function(client, utils) {
      stop("Not implemented")
    }
  )
)

#  PQInnerData Class
# 
# 
#  @title PQInnerData
#  @description Telegram API type PQInnerData
#  @export
#  @noRd
#  @noRd
PQInnerData <- R6::R6Class(
  "PQInnerData",
  inherit = TLObject,
  public = list(
    #  @field CONSTRUCTOR_ID A unique identifier for the TL object.
    CONSTRUCTOR_ID = 0x83c95aec,

    #  @field SUBCLASS_OF_ID A unique identifier for the subclass of the TL object.
    SUBCLASS_OF_ID = 0x41701377,

    #  @field pq The `pq` value as a raw vector.
    pq = NULL,

    #  @field p The `p` value as a raw vector.
    p = NULL,

    #  @field q The `q` value as a raw vector.
    q = NULL,

    #  @field nonce The `nonce` value as an integer.
    nonce = NULL,

    #  @field server_nonce The `server_nonce` value as an integer.
    server_nonce = NULL,

    #  @field new_nonce The `new_nonce` value as an integer.
    new_nonce = NULL,

    #  @description
    #  Initialize a new `PQInnerData` object.
    # 
    #  @param pq The `pq` value as a raw vector.
    #  @param p The `p` value as a raw vector.
    #  @param q The `q` value as a raw vector.
    #  @param nonce The `nonce` value as an integer.
    #  @param server_nonce The `server_nonce` value as an integer.
    #  @param new_nonce The `new_nonce` value as an integer.
    initialize = function(pq, p, q, nonce, server_nonce, new_nonce) {
      self$pq <- pq
      self$p <- p
      self$q <- q
      self$nonce <- nonce
      self$server_nonce <- server_nonce
      self$new_nonce <- new_nonce
    },

    #  @description
    #  Convert the object to a dictionary representation.
    # 
    #  @return A list representing the object.
    to_dict = function() {
      list(
        `_` = "PQInnerData",
        pq = self$pq,
        p = self$p,
        q = self$q,
        nonce = self$nonce,
        server_nonce = self$server_nonce,
        new_nonce = self$new_nonce
      )
    },

    #  @description
    #  Serialize the object to a byte array.
    # 
    #  @return A raw vector representing the serialized object.
    .bytes = function() {
      c(
        as.raw(c(0xec, 0x5a, 0xc9, 0x83)),
        serialize_bytes(self$pq),
        serialize_bytes(self$p),
        serialize_bytes(self$q),
        packBits(intToBits(self$nonce), "raw"),
        packBits(intToBits(self$server_nonce), "raw"),
        packBits(intToBits(self$new_nonce), "raw")
      )
    },

    #  @description
    #  Create a new object from a binary reader.
    # 
    #  @param reader A binary reader object.
    #  @return A new `PQInnerData` object created from the binary reader.
    from_reader = function(reader) {
      pq <- reader$tgread_bytes()
      p <- reader$tgread_bytes()
      q <- reader$tgread_bytes()
      nonce <- reader$read_large_int(bits = 128)
      server_nonce <- reader$read_large_int(bits = 128)
      new_nonce <- reader$read_large_int(bits = 256)
      self$new(pq = pq, p = p, q = q, nonce = nonce, server_nonce = server_nonce, new_nonce = new_nonce)
    }
  )
)

#  ClientDHInnerData Class
# 
# 
#  @title ClientDHInnerData
#  @description Telegram API type ClientDHInnerData
#  @export
#  @noRd
#  @noRd
ClientDHInnerData <- R6::R6Class(
  "ClientDHInnerData",
  inherit = TLObject,
  public = list(
    #  @field CONSTRUCTOR_ID A unique identifier for the TL object.
    CONSTRUCTOR_ID = 0x6643b654,

    #  @field SUBCLASS_OF_ID A unique identifier for the subclass of the TL object.
    SUBCLASS_OF_ID = 0xf8eeef6a,

    #  @field nonce The `nonce` value as an integer.
    nonce = NULL,

    #  @field server_nonce The `server_nonce` value as an integer.
    server_nonce = NULL,

    #  @field retry_id The `retry_id` value as an integer.
    retry_id = NULL,

    #  @field g_b The `g_b` value as a raw vector.
    g_b = NULL,

    #  @description
    #  Initialize a new `ClientDHInnerData` object.
    # 
    #  @param nonce The `nonce` value as an integer.
    #  @param server_nonce The `server_nonce` value as an integer.
    #  @param retry_id The `retry_id` value as an integer.
    #  @param g_b The `g_b` value as a raw vector.
    initialize = function(nonce, server_nonce, retry_id, g_b) {
      self$nonce <- nonce
      self$server_nonce <- server_nonce
      self$retry_id <- retry_id
      self$g_b <- g_b
    },

    #  @description
    #  Convert the object to a dictionary representation.
    # 
    #  @return A list representing the object.
    to_dict = function() {
      list(
        `_` = "ClientDHInnerData",
        nonce = self$nonce,
        server_nonce = self$server_nonce,
        retry_id = self$retry_id,
        g_b = self$g_b
      )
    },

    #  @description
    #  Serialize the object to a byte array.
    # 
    #  @return A raw vector representing the serialized object.
    .bytes = function() {
      c(
        as.raw(c(0x54, 0xb6, 0x43, 0x66)),
        packBits(intToBits(self$nonce), "raw"),
        packBits(intToBits(self$server_nonce), "raw"),
        packBits(intToBits(self$retry_id), "raw"),
        serialize_bytes(self$g_b)
      )
    },

    #  @description
    #  Create a new object from a binary reader.
    # 
    #  @param reader A binary reader object.
    #  @return A new `ClientDHInnerData` object created from the binary reader.
    from_reader = function(reader) {
      nonce <- reader$read_large_int(bits = 128)
      server_nonce <- reader$read_large_int(bits = 128)
      retry_id <- reader$read_long()
      g_b <- reader$tgread_bytes()
      self$new(nonce = nonce, server_nonce = server_nonce, retry_id = retry_id, g_b = g_b)
    }
  )
)

#  SetClientDHParamsRequest Class
# 
# 
#  @title SetClientDHParamsRequest
#  @description Telegram API type SetClientDHParamsRequest
#  @export
#  @noRd
#  @noRd
SetClientDHParamsRequest <- R6::R6Class(
  "SetClientDHParamsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID A unique identifier for the TL object.
    CONSTRUCTOR_ID = 0xf5045f1f,

    #  @field SUBCLASS_OF_ID A unique identifier for the subclass of the TL object.
    SUBCLASS_OF_ID = 0x55dd6cdb,

    #  @field nonce The `nonce` value as an integer.
    nonce = NULL,

    #  @field server_nonce The `server_nonce` value as an integer.
    server_nonce = NULL,

    #  @field encrypted_data The `encrypted_data` value as a raw vector.
    encrypted_data = NULL,

    #  @description
    #  Initialize a new `SetClientDHParamsRequest` object.
    # 
    #  @param nonce The `nonce` value as an integer.
    #  @param server_nonce The `server_nonce` value as an integer.
    #  @param encrypted_data The `encrypted_data` value as a raw vector.
    initialize = function(nonce, server_nonce, encrypted_data) {
      self$nonce <- nonce
      self$server_nonce <- server_nonce
      self$encrypted_data <- encrypted_data
    },

    #  @description
    #  Convert the object to a dictionary representation.
    # 
    #  @return A list representing the object.
    to_dict = function() {
      list(
        `_` = "SetClientDHParamsRequest",
        nonce = self$nonce,
        server_nonce = self$server_nonce,
        encrypted_data = self$encrypted_data
      )
    },

    #  @description
    #  Serialize the object to a byte array.
    # 
    #  @return A raw vector representing the serialized object.
    .bytes = function() {
      c(
        as.raw(c(0xf5, 0x04, 0x5f, 0x1f)),
        packBits(intToBits(self$nonce), "raw"),
        packBits(intToBits(self$server_nonce), "raw"),
        serialize_bytes(self$encrypted_data)
      )
    }
  ),
  private = list(
    #  Create a new object from a binary reader.
    # 
    from_reader = function(reader) {
      nonce <- reader$read_large_int(bits = 128)
      server_nonce <- reader$read_large_int(bits = 128)
      encrypted_data <- reader$tgread_bytes()
      self$new(nonce = nonce, server_nonce = server_nonce, encrypted_data = encrypted_data)
    }
  )
)

#  ReqPqMultiRequest Class
# 
# 
#  @title ReqPqMultiRequest
#  @description Telegram API type ReqPqMultiRequest
#  @export
#  @noRd
#  @noRd
ReqPqMultiRequest <- R6::R6Class(
  "ReqPqMultiRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID A unique identifier for the TL object.
    CONSTRUCTOR_ID = 0xbe7e8ef1,

    #  @field SUBCLASS_OF_ID A unique identifier for the subclass of the TL object.
    SUBCLASS_OF_ID = 0x786986b8,

    #  @field nonce The `nonce` value as an integer.
    nonce = NULL,

    #  @description
    #  Initialize a new `ReqPqMultiRequest` object.
    # 
    #  @param nonce The `nonce` value as an integer.
    initialize = function(nonce) {
      self$nonce <- nonce
    },

    #  @description
    #  Convert the object to a dictionary representation.
    # 
    #  @return A list representing the object.
    to_dict = function() {
      list(
        `_` = "ReqPqMultiRequest",
        nonce = self$nonce
      )
    },

    #  @description
    #  Serialize the object to a byte array.
    # 
    #  @return A raw vector representing the serialized object.
    .bytes = function() {
      c(
        as.raw(c(0xf1, 0x8e, 0x7e, 0xbe)),
        packBits(intToBits(self$nonce), "raw")
      )
    }
  ),
  private = list(
    #  Create a new object from a binary reader.
    # 
    from_reader = function(reader) {
      nonce <- reader$read_large_int(bits = 128)
      self$new(nonce = nonce)
    }
  )
)

#  ReqDHParamsRequest Class
# 
# 
#  @title ReqDHParamsRequest
#  @description Telegram API type ReqDHParamsRequest
#  @export
#  @noRd
#  @noRd
ReqDHParamsRequest <- R6::R6Class(
  "ReqDHParamsRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID A unique identifier for the TL object.
    CONSTRUCTOR_ID = 0xd712e4be,

    #  @field SUBCLASS_OF_ID A unique identifier for the subclass of the TL object.
    SUBCLASS_OF_ID = 0xa6188d9e,

    #  @field nonce The `nonce` value as an integer.
    nonce = NULL,

    #  @field server_nonce The `server_nonce` value as an integer.
    server_nonce = NULL,

    #  @field p The `p` value as a raw vector.
    p = NULL,

    #  @field q The `q` value as a raw vector.
    q = NULL,

    #  @field public_key_fingerprint The `public_key_fingerprint` value as an integer.
    public_key_fingerprint = NULL,

    #  @field encrypted_data The `encrypted_data` value as a raw vector.
    encrypted_data = NULL,

    #  @description
    #  Initialize a new `ReqDHParamsRequest` object.
    # 
    #  @param nonce The `nonce` value as an integer.
    #  @param server_nonce The `server_nonce` value as an integer.
    #  @param p The `p` value as a raw vector.
    #  @param q The `q` value as a raw vector.
    #  @param public_key_fingerprint The `public_key_fingerprint` value as an integer.
    #  @param encrypted_data The `encrypted_data` value as a raw vector.
    initialize = function(nonce, server_nonce, p, q, public_key_fingerprint, encrypted_data) {
      self$nonce <- nonce
      self$server_nonce <- server_nonce
      self$p <- p
      self$q <- q
      self$public_key_fingerprint <- public_key_fingerprint
      self$encrypted_data <- encrypted_data
    },

    #  @description
    #  Convert the object to a dictionary representation.
    # 
    #  @return A list representing the object.
    to_dict = function() {
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

    #  @description
    #  Serialize the object to a byte array.
    # 
    #  @return A raw vector representing the serialized object.
    .bytes = function() {
      c(
        as.raw(c(0xbe, 0xe4, 0x12, 0xd7)),
        packBits(intToBits(self$nonce), "raw"),
        packBits(intToBits(self$server_nonce), "raw"),
        serialize_bytes(self$p),
        serialize_bytes(self$q),
        packBits(intToBits(self$public_key_fingerprint), "raw"),
        serialize_bytes(self$encrypted_data)
      )
    }
  ),
  private = list(
    #  Create a new object from a binary reader.
    # 
    from_reader = function(reader) {
      nonce <- reader$read_large_int(bits = 128)
      server_nonce <- reader$read_large_int(bits = 128)
      p <- reader$tgread_bytes()
      q <- reader$tgread_bytes()
      public_key_fingerprint <- reader$read_long()
      encrypted_data <- reader$tgread_bytes()
      self$new(
        nonce = nonce,
        server_nonce = server_nonce,
        p = p,
        q = q,
        public_key_fingerprint = public_key_fingerprint,
        encrypted_data = encrypted_data
      )
    }
  )
)

#  InputPeerEmpty Class
# 
# 
#  @title InputPeerEmpty
#  @description Telegram API type InputPeerEmpty
#  @export
#  @noRd
#  @noRd
InputPeerEmpty <- R6::R6Class(
  "InputPeerEmpty",
  inherit = TLObject,
  public = list(
    #  @field CONSTRUCTOR_ID A unique identifier for the TL object.
    CONSTRUCTOR_ID = 0x7f3b18ea,

    #  @field SUBCLASS_OF_ID A unique identifier for the subclass of the TL object.
    SUBCLASS_OF_ID = 0xc91c90b6,

    #  @description
    #  Convert the object to a dictionary representation.
    #  @return A list representing the object.
    to_dict = function() {
      list(
        `_` = "InputPeerEmpty"
      )
    },

    #  @description
    #  Serialize the object to a byte array.
    #  @return A raw vector representing the serialized object.
    .bytes = function() {
      as.raw(c(0xea, 0x18, 0x3b, 0x7f))
    }
  ),
  private = list(
    #  Create a new object from a binary reader.
    from_reader = function(reader) {
      self$new()
    }
  )
)
