#  R6 Class Representing AES Encryption and Decryption
# 
# 
#  @details
#  A pure R implementation of AES IGE mode encryption and decryption.
#  @title AES
#  @description Telegram API type AES
#  @export
#  @noRd
#  @noRd
AES <- R6::R6Class(
  "AES",
  public = list(
    #  @description
    #  Decrypts the given text in 16-byte blocks using the provided key and IV.
    #  @param cipher_text A raw vector representing the encrypted text.
    #  @param key A raw vector representing the encryption key.
    #  @param iv A raw vector representing the 32-byte initialization vector.
    #  @return A raw vector representing the decrypted text.
    decrypt_ige = function(cipher_text, key, iv) {
      if (length(cipher_text) %% 16 != 0) {
        stop("Invalid input length: must be a multiple of 16 bytes.")
      }
      aes_ige_decrypt(key, iv, cipher_text)
    },

    #  @description
    #  Encrypts the given text in 16-byte blocks using the provided key and IV.
    #  @param plain_text A raw vector representing the text to encrypt.
    #  @param key A raw vector representing the encryption key.
    #  @param iv A raw vector representing the 32-byte initialization vector.
    #  @return A raw vector representing the encrypted text.
    encrypt_ige = function(plain_text, key, iv) {
      padding <- length(plain_text) %% 16
      if (padding > 0) {
        plain_text <- c(plain_text, as.raw(sample(0:255, 16 - padding, replace = TRUE)))
      }
      aes_ige_encrypt(key, iv, plain_text)
    }
  )
)
