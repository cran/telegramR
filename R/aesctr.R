#  @title AESModeCTR
#  @description A wrapper around AES CTR mode with custom IV using the `digest` library.
#  This class provides methods to encrypt and decrypt data using AES CTR mode.
#  It initializes with a key and a 16-byte initialization vector (IV).
#  @export
#  @noRd
#  @noRd
AESModeCTR <- R6::R6Class(
  "AESModeCTR",
  public = list(
    #  @field key The encryption key as a raw vector.
    key = NULL,

    #  @field iv The initialization vector (IV) as a 16-byte raw vector.
    iv = NULL,

    #  @description
    #  Initialize the AES CTR mode with the given key and IV.
    #  @param key A raw vector representing the encryption key (16 bytes).
    #  @param iv A raw vector representing the initialization vector (16 bytes).
    initialize = function(key, iv) {
      stopifnot(is.raw(key))
      stopifnot(is.raw(iv))
      stopifnot(length(iv) == 16)
      stopifnot(length(key) %in% c(16, 24, 32))
      self$key <- key
      self$iv <- iv
    },

    #  @description
    #  Encrypt the given plain text using AES CTR mode.
    #  @param data A raw vector representing the plain text to encrypt.
    #  @return A raw vector representing the encrypted cipher text.
    encrypt = function(data) {
      aes <- digest::AES(self$key, mode = "CTR", IV = self$iv)
      aes$encrypt(data)
    },

    #  @description
    #  Decrypt the given cipher text using AES CTR mode.
    #  @param data A raw vector representing the cipher text to decrypt.
    #  @return A raw vector representing the decrypted plain text.
    decrypt = function(data) {
      aes <- digest::AES(self$key, mode = "CTR", IV = self$iv)
      aes$decrypt(data, raw = TRUE)
    }
  )
)
