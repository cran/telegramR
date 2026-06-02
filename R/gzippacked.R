#  R6 Class Representing GzipPacked
# 
# 
#  @details
#  This class provides methods to initialize, compress, decompress, serialize, and convert gzipped data to various formats.
# 
# 
#  @title GzipPacked
#  @description Telegram API type GzipPacked
#  @export
#  @noRd
#  @noRd
GzipPacked <- R6::R6Class(
  "GzipPacked",
  inherit = TLObject,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for GzipPacked (0x3072cfa1).
    CONSTRUCTOR_ID = 0x3072cfa1,
    #  @field SUBCLASS_OF_ID The subclass ID for GzipPacked.
    SUBCLASS_OF_ID = 0x3072cfa1,

    #  @field data Field.
    data = NULL,

    #  @description
    #  Initialize a new `GzipPacked` object.
    #  @param data \code{raw} The raw gzipped data.
    initialize = function(data) {
      self$data <- data
    },

    #  @description
    #  Optionally gzip the data if it is content-related and smaller when compressed.
    #  @param content_related \code{logical} Whether the data is content-related.
    #  @param data \code{raw} The data to be gzipped.
    #  @return \code{raw} The gzipped data if smaller, otherwise the original data.
    gzip_if_smaller = function(content_related, data) {
      # Calls serialize_bytes, and based on a certain threshold,
      # optionally gzips the resulting data. If the gzipped data is
      # smaller than the original byte array, this is returned instead.
      # Note that this only applies to content related requests.
      if (content_related && length(data) > 512) {
        gzipped <- gzcon(rawConnection(data, "r"))
        if (object.size(gzipped) < object.size(data)) {
          return(gzipped)
        }
      }
      return(data)
    },

    #  @description
    #  Serialize the object to a byte array.
    #  @return \code{raw} A byte array representing the serialized object.
    to_bytes = function() {
      # Serialize the object to bytes
      constructor_id <- as.raw(c(0xa1, 0xcf, 0x72, 0x30)) # 0x3072cfa1 in little-endian
      compressed_data <- serialize_bytes(memCompress(self$data, type = "gzip"))
      return(c(constructor_id, compressed_data))
    },

    #  @description
    #  Read and decompress the gzipped data from a binary reader.
    #  @param reader A binary reader object.
    #  @return \code{raw} The decompressed data.
    read = function(reader) {
      # Read and decompress the data
      constructor <- reader$read_int(signed = FALSE)
      stopifnot(constructor == 0x3072cfa1)
      return(memDecompress(reader$tgread_bytes(), type = "gzip"))
    },

    #  @description
    #  Convert the object to a dictionary representation.
    #  @return \code{list} A dictionary representation of the object.
    to_dict = function() {
      # Convert the object to a dictionary
      return(list("_" = "GzipPacked", "data" = self$data))
    },

    #  @description
    #  Create a GzipPacked object from a binary reader.
    #  @param reader A binary reader object.
    #  @return A new GzipPacked object.
    from_reader = function(reader) {
      return(GzipPacked$new(data = memDecompress(reader$tgread_bytes(), type = "gzip")))
    }
  )
)
