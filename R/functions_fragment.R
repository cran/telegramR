#  GetCollectibleInfoRequest R6 class
# 
#  Request to retrieve collectible information (fragment.CollectibleInfo).
# 
#  @return R6 object of class GetCollectibleInfoRequest
#  @title GetCollectibleInfoRequest
#  @description Telegram API type GetCollectibleInfoRequest
#  @export
#  @noRd
#  @noRd
GetCollectibleInfoRequest <- R6::R6Class(
  "GetCollectibleInfoRequest",
  inherit = TLRequest,
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0xbe1e85ba,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0xd4ea5790,
    #  @field collectible Field.
    collectible = NULL,

    #  @description Initializes a new GetCollectibleInfoRequest.
    #  @param collectible TLObject-like R6 object (must provide to_list/to_bytes or
    initialize = function(collectible) {
      self$collectible <- collectible
    },

    #  @description convert to a list representation (analogous to to_dict)
    #  @return A raw vector representing the serialized request.
    to_list = function() {
      collectible_value <- if (inherits(self$collectible, "TLObject")) {
        if (!is.null(self$collectible$to_list)) {
          self$collectible$to_list()
        } else if (!is.null(self$collectible$toList)) {
          self$collectible$toList()
        } else {
          stop("collectible does not provide a to_list / toList method")
        }
      } else {
        self$collectible
      }

      list(
        `_` = "GetCollectibleInfoRequest",
        collectible = collectible_value
      )
    },

    #  @description raw bytes for the request (constructor id + collectible bytes)
    #  @return A raw vector representing the serialized request.
    to_bytes = function() {
      constructor_raw <- as.raw(c(0xba, 0x85, 0x1e, 0xbe)) # little-endian bytes for 0xbe1e85ba

      collectible_bytes <- if (inherits(self$collectible, "TLObject")) {
        if (!is.null(self$collectible$to_bytes)) {
          self$collectible$to_bytes()
        } else if (!is.null(self$collectible$bytes)) {
          self$collectible$bytes()
        } else {
          stop("collectible does not provide a to_bytes / bytes method")
        }
      } else if (is.raw(self$collectible)) {
        self$collectible
      } else {
        stop("collectible must be a TLObject-like R6 or raw vector")
      }

      c(constructor_raw, collectible_bytes)
    }
  )
)

#  from_reader for GetCollectibleInfoRequest
#  @param reader reader
#  @export
GetCollectibleInfoRequest$from_reader <- function(reader) {
  collectible_obj <- reader$tgread_object()
  GetCollectibleInfoRequest$new(collectible = collectible_obj)
}
