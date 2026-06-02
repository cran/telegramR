#  R6 Class Representing a MessageContainer
# 
#  @description
#  Represents a container for multiple Telegram API messages.
# 
#  @details
#  The `MessageContainer` class is used to group multiple Telegram API messages together.
#  It provides methods to initialize the container, convert it to a dictionary representation,
#  and read messages from a binary reader.

#  @noRd
#  @noRd
MessageContainer <- R6::R6Class(
  "MessageContainer",
  inherit = TLObject,
  public = list(
    #  @field CONSTRUCTOR_ID The constructor ID for MessageContainer (0x73f1f8dc).
    CONSTRUCTOR_ID = 0x73f1f8dc,
    #  @field SUBCLASS_OF_ID The subclass ID for MessageContainer.
    SUBCLASS_OF_ID = 0x73f1f8dc,

    #  @field messages A list of messages contained in the container.
    messages = NULL,

    #  @description
    #  Initialize a new `MessageContainer` object.
    #  @param messages A list of messages to initialize the container with. Defaults to an empty list.
    #  @return A new `MessageContainer` object.
    initialize = function(messages = list()) {
      self$messages <- messages
    },

    #  @description
    #  Convert the `MessageContainer` object to a dictionary representation.
    #  @return A list containing the fields of the `MessageContainer` object in dictionary format.
    to_dict = function() {
      return(
        list(
          "_" = "MessageContainer",
          "messages" = if (is.null(self$messages)) {
            list()
          } else {
            lapply(self$messages, function(x) {
              if (is.null(x)) NULL else x$to_dict()
            })
          }
        )
      )
    },

    #  @param reader A binary reader object to read the messages from.
    #  @return The updated `MessageContainer` object with the parsed messages.
    #  @description
    #  Read and parse a `MessageContainer` object from a binary reader.
    #  @param reader A binary reader object to read the messages from.
    #  @return The updated `MessageContainer` object with the parsed messages.
    from_reader = function(reader) {
      messages <- list()
      count <- reader$read_int()
      for (i in seq_len(count)) {
        msg_id <- reader$read_long()
        seq_no <- reader$read_int()
        length <- reader$read_int()
        before <- reader$tell_position()
        obj <- reader$tgread_object()
        reader$set_position(before + length)
        messages <- append(messages, list(TLMessage$new(msg_id, seq_no, obj)))
      }
      self$messages <- messages
      return(self)
    }
  )
)

# Class-level constants for message packing limits.
MessageContainer$MAXIMUM_LENGTH <- 100L
MessageContainer$MAXIMUM_SIZE <- 1048576L
MessageContainer$CONSTRUCTOR_ID_VALUE <- 0x73f1f8dc
