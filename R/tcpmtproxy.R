#  @title MTProxyIO
#  @description Handles MTProxy header initialization and I/O encryption/decryption.
#  @export
#  @noRd
#  @noRd
MTProxyIO <- R6::R6Class("MTProxyIO",
  public = list(
    #  @field header The MTProxy header.
    header = NULL,

    #  @field encryptor The AESModeCTR encryptor.
    encryptor = NULL,

    #  @field decryptor The AESModeCTR decryptor.
    decryptor = NULL,

    #  @field reader The reader object.
    reader = NULL,

    #  @field writer The writer object.
    writer = NULL,

    #  @description Initialize MTProxyIO.
    #  @param connection A connection object with fields: reader, writer, secret, dc_id, and packet_codec.
    initialize = function(connection) {
      self$reader <- connection$reader
      self$writer <- connection$writer
      header_info <- private$init_header(connection$secret, connection$dc_id, connection$packet_codec)
      self$header <- header_info$header
      self$encryptor <- header_info$encryptor
      self$decryptor <- header_info$decryptor
    },

    #  @description Asynchronously read exactly n bytes and decrypt them.
    #  @param n Number of bytes to read.
    #  @return A raw vector with decrypted data.
    readexactly = function(n) {
      run <- function() {
        data <- self$reader$readexactly(n)
        self$decryptor$encrypt(data)
      }
      if (isTRUE(getOption("telegramR.async", FALSE))) {
        return(future::value(future::future(run())))
      }
      run()
    },

    #  @description Encrypt and write data.
    #  @param data A raw vector to write.
    write = function(data) {
      encrypted <- self$encryptor$encrypt(data)
      self$writer$write(encrypted)
    }
  ),
  private = list(
    init_header = function(secret, dc_id, packet_codec) {
      # Validate dd-secret conditions.
      is_dd <- (length(secret) == 17 && secret[1] == as.raw(0xDD))
      is_rand_codec <- inherits(packet_codec, "RandomizedIntermediatePacketCodec")
      if (is_dd && !is_rand_codec) {
        stop("Only RandomizedIntermediate can be used with dd-secrets")
      }
      if (is_dd) {
        secret <- secret[-1]
      }
      if (length(secret) != 16) {
        stop("MTProxy secret must be a hex-string representing 16 bytes")
      }

      # Generate 64 random bytes.
      repeat {
        random <- as.raw(sample(0:255, 64, replace = TRUE))
        keywords <- list(
          as.raw(c(0x50, 0x56, 0x72, 0x47)),
          as.raw(c(0x47, 0x45, 0x54, 0x20)),
          as.raw(c(0x50, 0x4F, 0x53, 0x54)),
          as.raw(c(0xee, 0xee, 0xee, 0xee))
        )
        cond1 <- random[1] != as.raw(0xef)
        cond2 <- !any(sapply(keywords, function(kw) identical(random[1:4], kw)))
        cond3 <- !identical(random[5:8], as.raw(rep(0, 4)))
        if (cond1 && cond2 && cond3) break
      }

      # Prepare reversed random for decryption keys.
      random_reversed <- rev(random[8:55])
      encrypt_key <- openssl::sha256(c(random[9:40], secret))
      encrypt_iv <- random[41:56]
      decrypt_key <- openssl::sha256(c(random_reversed[1:32], secret))
      decrypt_iv <- random_reversed[33:48]

      encryptor <- AESModeCTR$new(encrypt_key, encrypt_iv)
      decryptor <- AESModeCTR$new(decrypt_key, decrypt_iv)

      # Set packet_codec obfuscate tag into random bytes.
      random[57:60] <- packet_codec$obfuscate_tag
      # Encode dc_id as 2 little-endian bytes.
      dc_id_bytes <- as.raw(c(bitwAnd(dc_id, 0xFF), bitwAnd(bitwShiftR(dc_id, 8), 0xFF)))
      random <- c(random[1:56], dc_id_bytes, random[63:64])
      # Encrypt block from positions 57 to 64.
      block <- random[57:64]
      random[57:64] <- encryptor$encrypt(block)

      list(header = random, encryptor = encryptor, decryptor = decryptor)
    }
  )
)

#  @title TcpMTProxy
#  @description Connector for MTProxy, handling proxy connections and secret normalization.
#  @export
#  @noRd
#  @noRd
TcpMTProxy <- R6::R6Class("TcpMTProxy",
  public = list(
    #  @field secret The MTProxy secret.
    secret = NULL,

    #  @field dc_id The data center identifier.
    dc_id = NULL,

    #  @field reader The reader object.
    reader = NULL,

    #  @field writer The writer object.
    writer = NULL,

    #  @field loggers Optional loggers.
    loggers = NULL,

    #  @field packet_codec The packet codec used for this connection.
    packet_codec = NULL,

    #  @description Initialize TcpMTProxy.
    #  @param ip IP address as character.
    #  @param port Port number as integer.
    #  @param dc_id Data center identifier as integer.
    #  @param loggers Optional logger.
    #  @param proxy A list containing proxy_host, proxy_port, and secret.
    initialize = function(ip, port, dc_id, loggers = NULL, proxy = NULL) {
      if (is.null(proxy)) {
        stop("No proxy info specified for MTProxy connection")
      }
      proxy_host <- proxy[[1]]
      proxy_port <- proxy[[2]]
      self$secret <- private$normalize_secret(proxy[[3]])
      self$dc_id <- dc_id
      self$loggers <- loggers

      # Setup dummy reader and writer for illustration.
      self$reader <- list(
        readexactly = function(n) {
          as.raw(sample(0:255, n, replace = TRUE))
        }
      )
      self$writer <- list(
        write = function(data) {
          invisible(data)
        }
      )
    },

    #  @description Asynchronously connect to the proxy.
    #  @param timeout Timeout value in seconds.
    #  @param ssl Logical indicating whether to use SSL.
    connect = function(timeout = NULL, ssl = NULL) {
      fut <- future::future({
        # Simulate connection delay.
        Sys.sleep(2)
        # This is where additional connection logic would be placed.
        NULL
      })
      future::value(fut)
    }
  ),
  private = list(
    normalize_secret = function(secret) {
      if (startsWith(secret, "ee") || startsWith(secret, "dd")) {
        secret <- substring(secret, 3)
      }
      secret_bytes <- tryCatch(
        {
          hex_vec <- as.integer(sapply(seq(1, nchar(secret), 2), function(i) {
            strtoi(substr(secret, i, i + 1), base = 16L)
          }))
          as.raw(hex_vec)
        },
        error = function(e) {
          base64enc::base64decode(secret)
        }
      )
      secret_bytes[1:16]
    }
  )
)

#  @title ConnectionTcpMTProxyAbridged
#  @description Connects to an MTProxy server using the abridged protocol.
#  @export
#  @noRd
#  @noRd
ConnectionTcpMTProxyAbridged <- R6::R6Class("ConnectionTcpMTProxyAbridged",
  inherit = TcpMTProxy,
  public = list(
    #  @field packet_codec The packet codec used for this connection.
    packet_codec = NULL,

    #  @description Initialize connection using the abridged protocol.
    #  @param ip IP address as character.
    #  @param port Port number as integer.
    #  @param dc_id Data center identifier as integer.
    #  @param loggers Optional logger.
    #  @param proxy A list containing proxy_host, proxy_port, and secret.
    initialize = function(ip, port, dc_id, loggers = NULL, proxy = NULL) {
      super$initialize(ip, port, dc_id, loggers, proxy)
      # Assume AbridgedPacketCodec is defined elsewhere.
      # Store the codec class; Connection will instantiate it with this connection.
      self$packet_codec <- AbridgedPacketCodec
    }
  )
)

#  @title ConnectionTcpMTProxyIntermediate
#  @description Connects to an MTProxy server using the intermediate protocol.
#  @export
#  @noRd
#  @noRd
ConnectionTcpMTProxyIntermediate <- R6::R6Class("ConnectionTcpMTProxyIntermediate",
  inherit = TcpMTProxy,
  public = list(
    #  @field packet_codec The packet codec used for this connection.
    packet_codec = NULL,

    #  @description Initialize connection using the intermediate protocol.
    #  @param ip IP address as character.
    #  @param port Port number as integer.
    #  @param dc_id Data center identifier as integer.
    #  @param loggers Optional logger.
    #  @param proxy A list containing proxy_host, proxy_port, and secret.
    initialize = function(ip, port, dc_id, loggers = NULL, proxy = NULL) {
      super$initialize(ip, port, dc_id, loggers, proxy)
      # Assume IntermediatePacketCodec is defined elsewhere.
      # Store the codec class; Connection will instantiate it with this connection.
      self$packet_codec <- IntermediatePacketCodec
    }
  )
)

#  @title ConnectionTcpMTProxyRandomizedIntermediate
#  @description Connects to an MTProxy server using the randomized intermediate protocol.
#  @export
#  @noRd
#  @noRd
ConnectionTcpMTProxyRandomizedIntermediate <- R6::R6Class("ConnectionTcpMTProxyRandomizedIntermediate",
  inherit = TcpMTProxy,
  public = list(
    #  @field packet_codec The packet codec used for this connection.
    packet_codec = NULL,

    #  @description Initialize connection using the randomized intermediate protocol.
    #  @param ip IP address as character.
    #  @param port Port number as integer.
    #  @param dc_id Data center identifier as integer.
    #  @param loggers Optional logger.
    #  @param proxy A list containing proxy_host, proxy_port, and secret.
    initialize = function(ip, port, dc_id, loggers = NULL, proxy = NULL) {
      super$initialize(ip, port, dc_id, loggers, proxy)
      # Assume RandomizedIntermediatePacketCodec is defined elsewhere.
      # Store the codec class; Connection will instantiate it with this connection.
      self$packet_codec <- RandomizedIntermediatePacketCodec
    }
  )
)
