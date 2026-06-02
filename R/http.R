#  Constant for SSL Port
SSL_PORT <- 443

#  @title HTTP Packet Codec Class
#  @description
#  This class implements the HTTP packet codec for encoding and decoding packets.
#  @export
#  @noRd
#  @noRd
HttpPacketCodec <- R6::R6Class("HttpPacketCodec",
  inherit = PacketCodec,
  public = list(
    ._conn = NULL,

    #  @description Initialize the codec with an optional connection.
    #  @param connection Optional connection-like list with ip/port fields.
    initialize = function(connection = NULL) {
      if (is.null(connection)) {
        connection <- list(ip = "0.0.0.0", port = 0)
      }
      self$._conn <- connection
    },


    #  @field tag A raw vector representing the tag for the codec.
    tag = NULL,

    #  @field obfuscate_tag A raw vector used for obfuscation.
    obfuscate_tag = NULL,

    #  @description Encode a packet using HTTP format.
    #  @param data A raw vector containing the data to encode.
    #  @return A raw vector representing the full HTTP packet.
    encode_packet = function(data) {
      header <- sprintf(
        "POST /api HTTP/1.1\r\nHost: %s:%s\r\nContent-Type: application/x-www-form-urlencoded\r\nConnection: keep-alive\r\nKeep-Alive: timeout=100000, max=10000000\r\nContent-Length: %d\r\n\r\n",
        self$._conn$ip, self$._conn$port, length(data)
      )
      header_raw <- charToRaw(header)
      c(header_raw, data)
    },

    #  Asynchronously read an HTTP packet.
    # 
    #  This method repeatedly reads lines until a line beginning with "content-length: " is found,
    #  then reads exactly the specified number of bytes.
    # 
    #  @param reader An object providing the methods \code{readline()} and \code{readexactly(n)}.
    #  @return A future resolving to a raw vector containing the packet data.
    read_packet = function(reader) {
      future::future({
        repeat {
          line <- reader$readline()
          if (length(line) == 0 || tail(line, 1) != as.raw(10)) {
            stop("IncompleteReadError: no newline found")
          }
          line_str <- tolower(rawToChar(line))
          if (startsWith(line_str, "content-length: ")) {
            # Read the next 2 bytes (assumed to be \r\n)
            reader$readexactly(2)
            # Extract length value; remove header and trailing \r\n
            full_line <- rawToChar(line)
            len_str <- substr(full_line, 17, nchar(full_line) - 2)
            length_val <- as.integer(len_str)
            return(reader$readexactly(length_val))
          }
        }
      })
    }
  )
)

#  HTTP Connection Class
# 
#  @title ConnectionHttp
#  @description Telegram API type ConnectionHttp
#  @export
#  @noRd
#  @noRd
ConnectionHttp <- R6::R6Class("ConnectionHttp",
  inherit = Connection,
  public = list(
    packet_codec = HttpPacketCodec,

    #  @description This method connects to the server using SSL if the port equals \code{SSL_PORT}.
    #  @param timeout Optional timeout for the connection.
    #  @param ssl Optional SSL parameter (ignored in favor of port-based selection).
    #  @return A future resolving when the connection is established.
    connect = function(timeout = NULL, ssl = NULL) {
      ssl_flag <- self$port == SSL_PORT
      super$connect(timeout = timeout, ssl = ssl_flag)
    }
  )
)
