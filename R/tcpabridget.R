#  @title AbridgedPacketCodec
#  @description An R6 class that implements the Abridged Packet Codec for encoding and decoding packets.
#  @inherit PacketCodec
#  @export
#  @noRd
#  @noRd
AbridgedPacketCodec <- R6::R6Class(
  "AbridgedPacketCodec",
  inherit = PacketCodec,
  public = list(
    #  @field tag A raw byte representing the tag for the codec.
    tag = as.raw(0xef),

    #  @field obfuscate_tag A raw vector used for obfuscation.
    obfuscate_tag = as.raw(c(0xef, 0xef, 0xef, 0xef)),

    #  @description Encodes a packet by adding a length prefix.
    #  @param data A raw vector representing the data to be encoded.
    #  @return A raw vector containing the encoded packet with the length prefix.
    encode_packet = function(data) {
      len_val <- bitwShiftR(length(data), 2)
      if (len_val < 127) {
        length_bytes <- as.raw(len_val)
      } else {
        b1 <- as.raw(bitwAnd(len_val, 0xff))
        b2 <- as.raw(bitwAnd(bitwShiftR(len_val, 8), 0xff))
        b3 <- as.raw(bitwAnd(bitwShiftR(len_val, 16), 0xff))
        length_bytes <- c(as.raw(0x7f), b1, b2, b3)
      }
      c(length_bytes, data)
    },

    #  @description Reads and decodes a packet from a reader.
    #  @param reader An object with a `readexactly` method to read a specific number of bytes.
    #  @return A promise that resolves to the decoded packet.
    read_packet = function(reader) {
      promise(function(resolve, reject) {
        to_promise <- function(x) {
          if (inherits(x, "promise")) x else promises::promise_resolve(x)
        }
        to_promise(reader$readexactly(1)) %...>% (function(first_byte) {
          len_val <- as.integer(first_byte[1])
          if (len_val >= 127) {
            to_promise(reader$readexactly(3)) %...>% (function(extra_bytes) {
              full_bytes <- c(extra_bytes, as.raw(0x00))
              len_val_new <- sum(as.integer(full_bytes) * c(1, 256, 65536, 16777216))
              to_promise(reader$readexactly(bitwShiftL(len_val_new, 2))) %...>% resolve %...!% reject
            }) %...!% reject
          } else {
            to_promise(reader$readexactly(bitwShiftL(len_val, 2))) %...>% resolve %...!% reject
          }
        }) %...!% reject
      })
    }
  )
)

#  @title ConnectionTcpAbridged
#  @description An R6 class that represents a TCP connection using the Abridged Packet Codec.
#  @inherit Connection
#  @export
#  @noRd
#  @noRd
ConnectionTcpAbridged <- R6::R6Class(
  "ConnectionTcpAbridged",
  inherit = Connection,
  public = list(
    #  @description Initializes the connection.
    #  @param ... Additional parameters passed to the parent class.
    #  @return None.
    initialize = function(...) {
      super$initialize(...)
      self$packet_codec <- AbridgedPacketCodec
    }
  )
)
