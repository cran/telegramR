#  @title FullPacketCodec
#  @description A codec for full TCP packets for Telegram.
#  @param connection A connection object.
#  @export
#  @noRd
#  @noRd
FullPacketCodec <- R6::R6Class("FullPacketCodec",
  inherit = PacketCodec,
  public = list(
    #  @field .send_counter Counter for sent packets.
    .send_counter = NULL,

    #  @description Initialize a new FullPacketCodec.
    #  @param connection A connection object.
    initialize = function(connection) {
      super$initialize(connection)
      self$.send_counter <- 0L
    },

    #  @description Encode a packet.
    #  @param data A raw vector containing the packet data.
    #  @return A raw vector representing the full packet.
    encode_packet = function(data) {
      if (is.null(data)) {
        stop("invalid 'length' argument")
      }
      total_length <- as.integer(length(data) + 12L)
      header <- c(
        writeBin(total_length, raw(), size = 4, endian = "little"),
        writeBin(as.integer(self$.send_counter), raw(), size = 4, endian = "little")
      )
      packet <- c(header, data)
      crc_value <- crc32(packet)
      crc_raw <- writeBin(as.integer(crc_value), raw(), size = 4, endian = "little")
      self$.send_counter <- self$.send_counter + 1L
      c(packet, crc_raw)
    },

    #  @description Read a packet.
    #  @param reader An object with a `readexactly` method.
    #  @return A raw vector representing the packet body.
    read_packet = function(reader) {
      promise(function(resolve, reject) {
        tryCatch(
          {
            packet_len_seq <- reader$readexactly(8L)
            nums <- readBin(packet_len_seq, integer(), n = 2, size = 4, endian = "little")
            packet_length <- nums[1]
            seq <- nums[2]
            if (packet_length < 0L && seq < 0L) {
              body <- reader$readexactly(4L)
              stop("InvalidBufferError: ", paste(body, collapse = " "))
            } else if (packet_length < 8L) {
              stop("InvalidBufferError: packet length less than 8: ", paste(packet_len_seq, collapse = " "))
            }
            body <- reader$readexactly(as.integer(packet_length - 8L))
            crc_section <- body[(length(body) - 3):length(body)]
            read_crc <- readBin(crc_section, integer(), n = 1, size = 4, endian = "little")
            body <- body[1:(length(body) - 4)]
            valid_crc <- crc32(c(packet_len_seq, body))
            if (read_crc != valid_crc) {
              stop("InvalidChecksumError: expected ", valid_crc, " but got ", read_crc)
            }
            resolve(body)
          },
          error = function(e) reject(e)
        )
      })
    }
  )
)

#  @title ConnectionTcpFull
#  @description Default Telegram mode. Sends 12 additional bytes and calculates the CRC for each packet.
#  @param ... Additional parameters passed to the parent connection.
#  @export
#  @noRd
#  @noRd
ConnectionTcpFull <- R6::R6Class("ConnectionTcpFull",
  inherit = Connection,
  public = list(
    #  @description Initialize the TCP full connection.
    #  @param ... Additional parameters.
    initialize = function(...) {
      super$initialize(...)
      # Store the codec class; Connection will instantiate it with this connection.
      self$packet_codec <- FullPacketCodec
    }
  )
)
