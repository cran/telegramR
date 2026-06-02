#  Various helpers not related to the Telegram API itself
#  Enum for entity types
#  @export
EntityType <- list(
  USER = 0,
  CHAT = 1,
  CHANNEL = 2
)

#  Logging setup
#  A simple logging function that prints formatted messages to the console.
#  @param ... Arguments passed to sprintf for formatting the log message.
#  @return None. Prints the formatted message to the console.
#  @examples
#  \donttest{
#  logg("This is a log message with a number: %d", 42)
#  }
#  @export
logg <- function(...) cat(sprintf(...), "\n", sep = "")

#  Generate a random long integer (8 bytes), optionally signed
#  @param signed Logical indicating if the integer should be signed (default TRUE)
#  @return A random long integer
#  @examples
#  \donttest{
#  random_long <- generate_random_long()
#  print(random_long)
#  random_unsigned_long <- generate_random_long(signed = FALSE)
#  print(random_unsigned_long)
#  }
#  @export
generate_random_long <- function(signed = TRUE) {
  raw_bytes <- as.raw(sample(0:255, 8, replace = TRUE))
  int_value <- sum(as.integer(raw_bytes) * 256^(seq_along(raw_bytes) - 1))
  if (signed && int_value > 2^63 - 1) {
    int_value <- int_value - 2^64
  }
  return(int_value)
}

#  Ensure the parent directory exists
#  @param file_path The file path for which to ensure the parent directory exists.
#  @return None. Creates the parent directory if it does not exist.
#  @examples
#  \donttest{
#  ensure_parent_dir_exists("path/to/some/file.txt")
#  }
#  @export
ensure_parent_dir_exists <- function(file_path) {
  parent <- dirname(file_path)
  if (nzchar(parent)) {
    dir.create(parent, recursive = TRUE, showWarnings = FALSE)
  }
}

#  Add surrogate pairs to text
#  @param text The input text string.
#  @return The text string with surrogate pairs added.
#  @examples
#  \donttest{
#  text <- "Hello \U0001F600 World" # Contains a surrogate pair
#  surrogate_text <- add_surrogate(text)
#  print(surrogate_text) # "Hello 😀 World"
#  }
#  @export
add_surrogate <- function(text) {
  paste0(sapply(strsplit(text, NULL)[[1]], function(x) {
    code <- utf8ToInt(x)
    if (code >= 0x10000 && code <= 0x10FFFF) {
      high <- bitops::bitShiftR(code - 0x10000, 10) + 0xD800
      low <- bitops::bitAnd(code - 0x10000, 0x3FF) + 0xDC00
      return(intToUtf8(c(high, low)))
    } else {
      return(x)
    }
  }, USE.NAMES = FALSE), collapse = "")
}

#  Remove surrogate pairs from text
#  @param text The input text string.
#  @return The text string with surrogate pairs removed.
#  @examples
#  \donttest{
#  text <- "Hello \U0001F600 World" # Contains a surrogate pair
#  cleaned_text <- del_surrogate(text)
#  print(cleaned_text) # "Hello  World"
#  }
#  @export
del_surrogate <- function(text) {
  intToUtf8(utf8ToInt(text), multiple = TRUE)
}

#  Check if index is within a surrogate pair
#  @param text The input text string.
#  @param index The index to check (1-based).
#  @param text_length Optional length of the text; if NULL, computed from text.
#  @return Logical indicating if the index is within a surrogate pair.
#  @examples
#  \donttest{
#  text <- "\U0001F400"
#  within_surrogate(text, 2)
#  }
#  @export
within_surrogate <- function(text, index, text_length = NULL) {
  if (is.na(index)) {
    return(FALSE)
  }
  chars <- strsplit(text, "")[[1]]
  n <- if (is.null(text_length)) base::length(chars) else text_length
  if (index <= 1 || index >= n) {
    return(FALSE)
  }
  prev <- chars[index - 1]
  curr <- chars[index]
  if (is.na(prev) || is.na(curr)) {
    return(FALSE)
  }
  prev_code <- utf8ToInt(prev)
  curr_code <- utf8ToInt(curr)
  return(
    prev_code >= 0xD800 && prev_code <= 0xDBFF &&
      curr_code >= 0xDC00 && curr_code <= 0xDFFF
  )
}

#  Strip text and adjust entities
#  @param text The original text string.
#  @param entities A list of entity objects, each with 'offset' and 'length
#  fields.
#  @return The stripped text with adjusted entities.
#  @examples
#  \donttest{
#  text <- "  Hello, World!  "
#  entities <- list(list(offset = 2, length = 5), list(offset = 10, length = 3))
#  stripped_text <- strip_text(text, entities)
#  print(stripped_text) # "Hello, World!"
#  print(entities) # Adjusted entities
#  }
#  @export
strip_text <- function(text, entities) {
  if (base::length(entities) == 0) {
    return(trimws(text))
  }

  len_ori <- nchar(text)
  text <- sub("^\\s+", "", text)
  left_offset <- len_ori - nchar(text)
  text <- sub("\\s+$", "", text)
  len_final <- nchar(text)

  for (i in seq_along(entities)) {
    e <- entities[[i]]
    if (e$length == 0) {
      entities[[i]] <- NULL
      next
    }

    if (e$offset + e$length > left_offset) {
      if (e$offset >= left_offset) {
        e$offset <- e$offset - left_offset
      } else {
        e$length <- e$offset + e$length - left_offset
        e$offset <- 0
      }
    } else {
      entities[[i]] <- NULL
      next
    }

    if (e$offset + e$length <= len_final) {
      next
    }
    if (e$offset >= len_final) {
      entities[[i]] <- NULL
    } else {
      e$length <- len_final - e$offset
    }
  }

  return(text)
}

#  Generate key data from nonce
#  @param server_nonce A raw vector representing the server nonce (16 bytes).
#  @param new_nonce A raw vector representing the new nonce (32 bytes).
#  @return A list containing 'key' and 'iv' as raw vectors.
#  @examples
#  \donttest{
#  server_nonce <- as.raw(sample(0:255, 16, replace = TRUE))
#  new_nonce <- as.raw(sample(0:255, 32, replace = TRUE))
#  key_data <- generate_key_data_from_nonce(server_nonce, new_nonce)
#  str(key_data)
#  }
#  @export
generate_key_data_from_nonce <- function(server_nonce, new_nonce) {
  server_nonce <- as.raw(server_nonce)
  new_nonce <- as.raw(new_nonce)

  hash1 <- sha1(c(new_nonce, server_nonce))
  hash2 <- sha1(c(server_nonce, new_nonce))
  hash3 <- sha1(c(new_nonce, new_nonce))

  key <- c(hash1, hash2[1:12])
  iv <- c(hash2[13:20], hash3, new_nonce[1:4])

  return(list(key = key, iv = iv))
}

#  TotalList R6 class
# 
# 
#  @details
#  The class keeps arbitrary R objects in the `items` field and a scalar numeric `total`
#  initialized to 0. It provides methods to construct an instance and to obtain
#  two textual representations: a human-readable form and a dput()-based reproducible form.
#  @title TotalList
#  @description Telegram API type TotalList
#  @export
#  @noRd
#  @noRd
TotalList <- R6::R6Class(
  "TotalList",
  public = list(
    #  @field items list List of objects contained in the instance.
    items = NULL,

    #  @field total numeric Numeric scalar representing the total associated with the items.
    total = 0,

    #  @description Initializes a TotalList instance.
    #  @param items (initialize) Optional list of items to store; defaults to an empty
    #  list. The `total` field is initialized to 0.
    #  @return A new TotalList instance.
    initialize = function(items = list()) {
      self$items <- items
      self$total <- 0
    },

    #  @description Returns a human-readable string representation of the TotalList.
    #  Each item is coerced to character and the total is appended.
    #  @return A string representation of the TotalList.
    to_string = function() {
      paste0("[", paste(sapply(self$items, as.character), collapse = ", "), ", total=", self$total, "]")
    },

    #  @description Returns a reproducible string representation of the TotalList.
    #  Each item is represented using dput() and the total is appended.
    #  @return A reproducible string representation of the TotalList.
    to_repr = function() {
      paste0("[", paste(sapply(self$items, function(x) dput(x)), collapse = ", "), ", total=", self$total, "]")
    }
  )
)

#  FileStream Class
#  A class to handle file streams from various sources.
#  @title FileStream
#  @description Telegram API type FileStream
#  @export
#  @noRd
#  @noRd
FileStream <- R6::R6Class(
  "FileStream",
  public = list(
    #  @field file The original file input (path, raw vector, or connection).
    file = NULL,

    #  @field file_size The size of the file in bytes.
    file_size = NULL,

    #  @field name The name of the file (if applicable).
    name = NULL,

    #  @field stream The underlying connection or raw connection.
    stream = NULL,

    #  @field close_stream Logical indicating if the stream should be closed on cleanup.
    close_stream = NULL,

    #  @description Initializes the FileStream.
    #  @param file A file path (character), raw vector, or connection.
    #  @param file_size Optional size of the file in bytes (if known).
    #  @return A new FileStream instance.
    initialize = function(file, file_size = NULL) {
      if (is.character(file)) {
        self$file <- normalizePath(file)
        self$name <- basename(self$file)
        self$file_size <- if (is.null(file_size)) file.info(self$file)$size else file_size
        self$stream <- base::file(self$file, "rb")
        self$close_stream <- TRUE
      } else if (is.raw(file)) {
        self$file <- file
        self$name <- "unnamed"
        self$file_size <- if (is.null(file_size)) base::length(file) else file_size
        self$stream <- rawConnection(file, "rb")
        self$close_stream <- TRUE
      } else if (inherits(file, "connection")) {
        self$file <- file
        self$name <- summary(file)$description
        self$stream <- file
        self$close_stream <- FALSE
      } else {
        stop("Unsupported file type")
      }
    },

    #  @description Reads data from the stream.
    #  @param n Number of bytes to read; defaults to -1 (read all remaining).
    #  @return A raw vector containing the read data.
    read = function(n = -1) {
      if (is.numeric(n) && n < 0) {
        cur <- tryCatch(seek(self$stream, where = NA), error = function(e) NA_real_)
        if (!is.na(cur) && !is.null(self$file_size)) {
          n <- max(0, self$file_size - cur)
        }
      }
      readBin(self$stream, "raw", n = n)
    },

    #  @description Closes the stream if it was opened by the class.
    #  @return None.
    close = function() {
      if (self$close_stream && !is.null(self$stream)) {
        base::close(self$stream)
      }
    },

    #  @description Gets the size of the file.
    #  @return The size of the file in bytes.
    get_file_size = function() {
      self$file_size
    },

    #  @description Gets the name of the file.
    #  @return The name of the file.
    get_name = function() {
      if (is.raw(self$file)) {
        return(NULL)
      }
      self$name
    }
  )
)

#  get_running_loop function
#  Get or create a running event loop (cluster) for asynchronous operations.
#  @return A cluster object representing the running event loop.
#  @export
get_running_loop <- function() {
  if (getRversion() >= "3.7.0") {
    tryCatch(
      {
        getDefaultCluster()
      },
      error = function(e) {
        makeCluster(detectCores())
      }
    )
  } else {
    makeCluster(detectCores())
  }
}

#  fmt_flood
# 
#  @description ftm_flood - Format flood wait message
#  @param delay Delay time in seconds
#  @param request The request object
#  @param early Boolean indicating if the message is for an early flood wait
#  @param td Function to convert delay to time difference
#  @return Formatted flood wait message
#  @export
fmt_flood <- function(delay, request, early = FALSE, td = as.difftime) {
  sprintf(
    "Sleeping%s for %ds (%s) on %s flood wait",
    if (early) " early" else "",
    delay,
    as.character(td(delay, units = "secs")),
    class(request)[1]
  )
}
