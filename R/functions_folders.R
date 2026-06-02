#  EditPeerFoldersRequest R6 class
# 
#  Represents the TL request EditPeerFoldersRequest.
# 
#  @return An R6 object of class EditPeerFoldersRequest
#  @title EditPeerFoldersRequest
#  @description Telegram API type EditPeerFoldersRequest
#  @export
#  @noRd
#  @noRd
EditPeerFoldersRequest <- R6::R6Class(
  "EditPeerFoldersRequest",
  public = list(
    #  @field CONSTRUCTOR_ID Constructor identifier for this TL object.
    CONSTRUCTOR_ID = 0x6847d0ab,
    #  @field SUBCLASS_OF_ID Subclass identifier for this TL object.
    SUBCLASS_OF_ID = 0x8af52aac,
    #  @field folder_peers Field.
    folder_peers = NULL,

    #  @description Initialize EditPeerFoldersRequest
    #  @param folder_peers list List of InputFolderPeer objects
    initialize = function(folder_peers = list()) {
      if (is.null(folder_peers)) folder_peers <- list()
      if (!is.list(folder_peers)) stop("folder_peers must be a list")
      self$folder_peers <- folder_peers
    },

    #  @description Convert to a serializable R list (similar to to_dict)
    #  @return list
    to_list = function() {
      list(
        `_` = "EditPeerFoldersRequest",
        folder_peers = lapply(self$folder_peers, function(x) {
          if (inherits(x, "TLObject") && is.function(x$to_list)) {
            x$to_list()
          } else {
            x
          }
        })
      )
    },

    #  @description Serialize to raw bytes. Expects folder_peers elements to provide to_raw()
    #  @return raw vector
    to_raw = function() {
      parts <- list()
      parts[[1]] <- private$int_to_raw_le(self$CONSTRUCTOR_ID)
      parts[[2]] <- private$int_to_raw_le(self$SUBCLASS_OF_ID)
      parts[[3]] <- private$int_to_raw_le(length(self$folder_peers))
      if (length(self$folder_peers) > 0) {
        for (elem in self$folder_peers) {
          if (inherits(elem, "TLObject") && is.function(elem$to_raw)) {
            parts[[length(parts) + 1]] <- elem$to_raw()
          } else if (is.raw(elem)) {
            parts[[length(parts) + 1]] <- elem
          } else {
            stop("Each folder_peers element must be a TLObject with to_raw() or a raw vector")
          }
        }
      }
      do.call(c, parts)
    }
  ),
  private = list(
    int_to_raw_le = function(x) {
      if (!is.null(x) && x > 2147483647) {
        x <- x - 4294967296
      }
      if (!is.na(x) && x > 2147483647) x <- x - 4294967296
        writeBin(as.integer(x), con = raw(), size = 4, endian = "little")
    }
  )
)

# Read EditPeerFoldersRequest from a reader
# @name EditPeerFoldersRequest_read_from
#
# reader must implement read_int() and tgread_object()
#
# @param reader Reader object with methods read_int() and tgread_object()
# @return EditPeerFoldersRequest
EditPeerFoldersRequest$read_from <- function(reader) {
  # consume constructor id (if present)
  reader$read_int()
  count <- reader$read_int()
  folder_peers_list <- vector("list", count)
  for (i in seq_len(count)) {
    folder_peers_list[[i]] <- reader$tgread_object()
  }
  EditPeerFoldersRequest$new(folder_peers = folder_peers_list)
}
