#  @title TLMessage
#  @description A class representing a Telegram Layer (TL) message.
#  This class extends the TLObject class and provides functionality to store and manipulate TL message data.
#  @export
#  @noRd
#  @noRd
TLMessage <- R6::R6Class(
  "TLMessage",
  inherit = TLObject,
  public = list(
    #  @field msg_id The message ID (numeric).
    msg_id = NULL,

    #  @field seq_no The sequence number (numeric).
    seq_no = NULL,

    #  @field obj The object representing the content of the message.
    obj = NULL,

    #  @description
    #  Initialize a new `TLMessage` object.
    #  @param msg_id A numeric value for the message ID.
    #  @param seq_no A numeric value for the sequence number.
    #  @param obj An object representing the content of the message.
    #  @return A new `TLMessage` object.
    initialize = function(msg_id, seq_no, obj) {
      self$msg_id <- msg_id
      self$seq_no <- seq_no
      self$obj <- obj
    },

    #  @description
    #  Convert the `TLMessage` object to a dictionary representation.
    #  @return A list containing the fields of the `TLMessage` object in dictionary format.
    to_dict = function() {
      return(
        list(
          "_" = "TLMessage",
          "msg_id" = self$msg_id,
          "seq_no" = self$seq_no,
          "obj" = self$obj
        )
      )
    }
  )
)

# Class-level constant for message packing overhead (msg_id:8 + seq_no:4 + length:4 = 16, with padding overhead ~32).
TLMessage$SIZE_OVERHEAD <- 32L
