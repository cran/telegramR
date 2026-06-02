#  @importFrom openssl rand_bytes
#  @title ObfuscatedIO
#  @description Handles obfuscated I/O operations for Telegram obfuscation.
#  @export
#  @noRd
#  @noRd
ObfuscatedIO <- R6::R6Class("ObfuscatedIO",
  public = list(
    #  @field header The obfuscation header as a raw vector.
    header = NULL,

    #  @field .encrypt The AESModeCTR encryptor object.
    .encrypt = NULL,

    #  @field .decrypt The AESModeCTR decryptor object.
    .decrypt = NULL,

    #  @field .reader The reader connection object.
    .reader = NULL,

    #  @field .writer The writer connection object.
    .writer = NULL,

    #  @description Initialize ObfuscatedIO.
    #  @param connection A connection object with `.reader`, `.writer`, and `packet_codec` fields.
    initialize = function(connection) {
      self$.reader <- connection$`_reader`
      self$.writer <- connection$`_writer`
      res <- self$init_header(connection$packet_codec)
      self$header <- res$header
      self$.encrypt <- res$encryptor
      self$.decrypt <- res$decryptor
    },

    #  @description Reads exactly n bytes and decrypts them.
    #  @param n Number of bytes to read.
    #  @return A raw vector of decrypted bytes.
    readexactly = function(n) {
      data <- self$.reader$readexactly(n)
      self$.decrypt$encrypt(data)
    },

    #  @description Encrypts and writes data.
    #  @param data A raw vector of data.
    write = function(data) {
      self$.writer$write(self$.encrypt$encrypt(data))
    },

    #  @description Initializes the header, encryption, and decryption objects.
    #  @param packet_codec A packet codec object with an `obfuscate_tag` field.
    #  @return A list containing the header, encryptor, and decryptor.
    init_header = function(packet_codec) {
      # Define keywords that obfuscated messages cannot start with.
      keywords <- list(
        charToRaw("PVrG"),
        charToRaw("GET "),
        charToRaw("POST"),
        as.raw(c(0xee, 0xee, 0xee, 0xee))
      )

      repeat {
        random <- rand_bytes(64)
        cond1 <- random[1] != as.raw(0xef)
        cond2 <- !any(sapply(keywords, function(kw) identical(random[1:4], kw)))
        cond3 <- !identical(random[5:8], as.raw(rep(0, 4)))
        if (cond1 && cond2 && cond3) break
      }

      # Make a mutable copy of random bytes.
      random_mod <- random

      # In Python: random_reversed = random[55:7:-1]
      # In R (1-indexed): reverse bytes 9 to 56 (corresponding to Python indices 8 to 55).
      random_reversed <- rev(random_mod[9:56])

      # Encryption keys and IVs (adjusted for 1-indexing).
      encrypt_key <- random_mod[9:40] # corresponds to Python random[8:40]
      encrypt_iv <- random_mod[41:56] # corresponds to Python random[40:56]
      decrypt_key <- random_reversed[1:32] # first 32 bytes of reversed segment
      decrypt_iv <- random_reversed[33:48] # next 16 bytes

      encryptor <- AESModeCTR$new(encrypt_key, encrypt_iv)
      decryptor <- AESModeCTR$new(decrypt_key, decrypt_iv)

      # Set packet_codec obfuscate tag into random bytes.
      random_mod[57:60] <- packet_codec$obfuscate_tag
      # Encrypt block from positions 57 to 64.
      encrypted_full <- encryptor$encrypt(random_mod)
      random_mod[57:64] <- encrypted_full[57:64]

      list(header = random_mod, encryptor = encryptor, decryptor = decryptor)
    }
  )
)

#  @title ConnectionTcpObfuscated
#  @description Telegram obfuscated2 connection that encrypts every message with a randomly generated key using AES-CTR.
#  @export
#  @noRd
#  @noRd
ConnectionTcpObfuscated <- R6::R6Class("ConnectionTcpObfuscated",
  inherit = ObfuscatedConnection,
  public = list(
    #  @field obfuscated_io ObfuscatedIO class for handling obfuscated I/O operations.
    obfuscated_io = ObfuscatedIO,
    #  @field packet_codec Packet codec set to AbridgedPacketCodec.
    packet_codec = AbridgedPacketCodec
  )
)
