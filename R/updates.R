#  Helper functions to simulate Python functionality
# 
#  These functions are used to simulate Python's asyncio and threading behavior in R.
# 
#  @import promises
# 
NULL
#  The `get_running_loop` function simulates getting the current event loop.
#  @return A promise object or NULL.
#  @export
get_running_loop <- function() {
  return(Sys.time()) # Simplification - returns current time
}

# Define types for TYPE_CHECKING equivalent
is_typing <- FALSE


#  EventBuilderDict class
#  @title EventBuilderDict
#  @description Telegram API type EventBuilderDict
#  @export
#  @noRd
#  @noRd
EventBuilderDict <- R6::R6Class("EventBuilderDict",
  public = list(
    #  @field client The Telegram client instance.
    client = NULL,

    #  @field update The update data.
    update = NULL,

    #  @field others Additional data for building events.
    others = NULL,

    #  @field cache A cache for built events.
    cache = list(),

    #  @description
    #  Initializes the EventBuilderDict with the given client, update, and others.
    #  @param client The Telegram client instance.
    #  @param update The update data.
    #  @param others Additional data for building events.
    #  @return None.
    initialize = function(client, update, others) {
      self$client <- client
      self$update <- update
      self$others <- others
    },

    #  @description
    #  Builds an event from the given builder.
    #  @param builder The builder to use for building the event.
    #  @return The built event.
    get = function(builder) {
      builder_name <- deparse(substitute(builder))

      if (builder_name %in% names(self$cache)) {
        return(self$cache[[builder_name]])
      }

      event <- builder$build(self$update, self$others, self$client$self_id)
      self$cache[[builder_name]] <- event

      if (inherits(event, "EventCommon")) {
        event$original_update <- self$update
        event$entities <- self$update$entities
        event$set_client(self$client)
      } else if (!is.null(event)) {
        event$client <- self$client
      }

      return(event)
    }
  )
)
