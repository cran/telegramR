#  AuthKey Class
# 
# 
#  @title AuthKey
#  @description Telegram API type AuthKey
#  @export
#  @noRd
#  @noRd
AuthKey <- R6::R6Class(
  "AuthKey",
  public = list(
    #  @field key_id Field.
    key_id = NULL,
    #  @field key_id_raw Field.
    key_id_raw = NULL,
    #  @field aux_hash Field.
    aux_hash = NULL,
    #  @field aux_hash_raw Field.
    aux_hash_raw = NULL,

    #  @description
    #  Initializes a new authorization key.
    # 
    #  @param data A raw vector representing the authorization key data.
    #  @return None.
    initialize = function(data) {
      if (inherits(data, "AuthKey")) {
        data <- data$active_key
      }
      self$active_key <- data
    },

    #  @description
    #  Calculates the new nonce hash based on the current attributes.
    # 
    #  @param new_nonce A raw vector representing the new nonce.
    #  @param number An integer to prepend before the hash.
    #  @return An integer representing the hash for the given new nonce.
    calc_new_nonce_hash = function(new_nonce, number) {
      stopifnot(is.raw(new_nonce), length(new_nonce) == 32)
      new_nonce <- as.raw(new_nonce)
      data <- c(
        new_nonce, writeBin(as.integer(number), raw(), size = 8, endian = "little"),
        writeBin(as.integer(self$aux_hash), raw(), size = 8, endian = "little")
      )
      hash <- sha1(data)
      return(sum(as.integer(hash[5:20]) * 256^(seq_along(hash[5:20]) - 1)))
    },

    #  @description
    #  Checks if the authorization key is valid.
    # 
    #  @return A logical value indicating whether the key is valid.
    is_valid = function() {
      return(!is.null(private$.key))
    },

    #  @description
    #  Compares the current key with another key.
    # 
    #  @param other An instance of AuthKey to compare with.
    #  @return A logical value indicating whether the keys are equal.
    equals = function(other) {
      return(inherits(other, "AuthKey") && identical(other$active_key, private$.key))
    }
  ),
  active = list(
    #  @field key Field.
    #  Direct accessor used across sender/state code.
    key = function(value) {
      if (missing(value)) {
        return(private$.key)
      }
      self$active_key <- value
    },

    #  @field active_key Field.
    #  Gets or sets the authorization key.
    active_key = function(value) {
      if (missing(value)) {
        return(private$.key)
      }
      if (is.null(value)) {
        private$.key <- NULL
        private$.aux_hash <- NULL
        private$.key_id <- NULL
        private$.aux_hash_raw <- NULL
        private$.key_id_raw <- NULL
        self$aux_hash <- NULL
        self$key_id <- NULL
        self$aux_hash_raw <- NULL
        self$key_id_raw <- NULL
      } else {
        private$.key <- value
        hash <- sha1(private$.key)
        # Keep exact 64-bit identifiers as raw bytes to avoid numeric precision loss.
        private$.aux_hash_raw <- hash[1:8]
        private$.key_id_raw <- hash[13:20]
        reader <- BinaryReader$new(hash)
        private$.aux_hash <- reader$read_long(signed = FALSE)
        reader$read(4)
        private$.key_id <- reader$read_long(signed = FALSE)
        reader$close()
        self$aux_hash <- private$.aux_hash
        self$key_id <- private$.key_id
        self$aux_hash_raw <- private$.aux_hash_raw
        self$key_id_raw <- private$.key_id_raw
      }
    },

    #  @field return_aux_hash Field.
    #  Gets the auxiliary hash derived from the key.
    return_aux_hash = function() {
      return(private$.aux_hash)
    },

    #  @field return_key_id Field.
    #  Gets the key identifier derived from the key.
    return_key_id = function() {
      return(private$.key_id)
    }
  ),
  private = list(
    .key = NULL,
    .aux_hash = NULL,
    .key_id = NULL,
    .aux_hash_raw = NULL,
    .key_id_raw = NULL
  )
)
