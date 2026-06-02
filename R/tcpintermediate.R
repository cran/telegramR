#  @title IntermediatePacketCodec
#  @description A codec for intermediate TCP packets.
#  @details Encodes packets by prepending a 4-byte little-endian length prefix.
#  @inherit PacketCodec
#  @return A raw vector representing the packet data.
#  @export
#  @noRd
#  @noRd
IntermediatePacketCodec <- R6::R6Class("IntermediatePacketCodec",
  inherit = PacketCodec,
  public = list(
    #  @description Initialize codec with optional connection.
    #  @param connection Optional connection object.
    initialize = function(connection = NULL) {
      super$initialize(connection)
    },

    #  @field tag A raw vector representing the tag for the codec.
    tag = as.raw(c(0xee, 0xee, 0xee, 0xee)),

    #  @field obfuscate_tag A raw vector used for obfuscation.
    obfuscate_tag = as.raw(c(0xee, 0xee, 0xee, 0xee)),

    #  @description Encodes the packet.
    #  @param data A raw vector containing the packet data.
    #  @return A raw vector that starts with a 4-byte little-endian length prefix followed by the data.
    encode_packet = function(data) {
      length_bytes <- writeBin(as.integer(length(data)), raw(), size = 4, endian = "little")
      c(length_bytes, data)
    },

    #  @description Reads and decodes a packet from a reader.
    #  @param reader An object with a `readexactly` method.
    #  @return A promise resolving to packet data.
    read_packet = function(reader) {
      promise(function(resolve, reject) {
        to_promise <- function(x) {
          if (inherits(x, "promise")) x else promises::promise_resolve(x)
        }
        to_promise(reader$readexactly(4)) %...>% (function(length_bytes) {
          packet_length <- readBin(length_bytes, integer(), n = 1, size = 4, endian = "little")
          to_promise(reader$readexactly(packet_length)) %...>% resolve %...!% reject
        }) %...!% reject
      })
    }
  )
)

#  @title RandomizedIntermediatePacketCodec
#  @description A codec that adds random padding to align packets to 4 bytes.
#  @inherit IntermediatePacketCodec
#  @export
#  @noRd
#  @noRd
RandomizedIntermediatePacketCodec <- R6::R6Class("RandomizedIntermediatePacketCodec",
  inherit = IntermediatePacketCodec,
  public = list(
    #  @field tag A raw vector representing the tag for the codec.
    tag = NULL,

    #  @field obfuscate_tag A raw vector used for obfuscation.
    obfuscate_tag = as.raw(c(0xdd, 0xdd, 0xdd, 0xdd)),

    #  @description Encodes the packet with random padding.
    #  @param data A raw vector containing the packet data.
    #  @return A raw vector with a 4-byte length prefix and random padding.
    encode_packet = function(data) {
      pad_size <- sample(0:3, 1)
      if (pad_size > 0) {
        padding <- as.raw(sample(0:255, pad_size, replace = TRUE))
        data <- c(data, padding)
      }
      super$encode_packet(data)
    },

    #  @description Reads a packet and removes any trailing random padding.
    #  @param reader An object with a `readexactly` method.
    #  @return A promise resolving to packet data without random padding.
    read_packet = function(reader) {
      super$read_packet(reader) %...>% (function(packet_with_padding) {
        pad_size <- length(packet_with_padding) %% 4
        if (pad_size > 0) {
          packet_with_padding[1:(length(packet_with_padding) - pad_size)]
        } else {
          packet_with_padding
        }
      })
    }
  )
)

#  @title ConnectionTcpIntermediate
#  @description Intermediate mode between ConnectionTcpFull and ConnectionTcpAbridged.
#  @details Always sends 4 extra bytes for the packet length.
#  @inherit Connection
#  @export
#  @noRd
#  @noRd
ConnectionTcpIntermediate <- R6::R6Class("ConnectionTcpIntermediate",
  inherit = Connection,
  public = list(
    #  @description Initializes the intermediate TCP connection.
    #  @param ... Additional parameters passed to the parent constructor.
    initialize = function(...) {
      super$initialize(...)
      # Store the codec class; Connection will instantiate it with this connection.
      self$packet_codec <- IntermediatePacketCodec
    }
  )
)
