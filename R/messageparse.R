#  MessageParseMethods R6 class
# 
#  Lightweight helpers for parsing messages and handling response mapping.
#  @title MessageParseMethods
#  @description Telegram API type MessageParseMethods
#  @export
#  @noRd
#  @noRd
MessageParseMethods <- R6::R6Class(
  "MessageParseMethods",
  public = list(
    #  @field parse_mode Field.
    parse_mode = NULL,

    #  @description Initialize with an optional parse mode.
    #  @param mode Parse mode (e.g., "md", "markdown", "html", "htm") or NULL.
    initialize = function(mode = NULL) {
      self$set_parse_mode(mode)
    },

    #  @description Sanitize the parse mode input.
    #  @param mode The parse mode to sanitize.
    sanitize_parse_mode = function(mode) {
      if (is.null(mode)) {
        return(NULL)
      }
      if (mode %in% c("markdown", "md", "html", "htm")) {
        return(mode)
      }
      stop("Invalid parse mode")
    },

    #  @description Set the default parse mode.
    #  @param mode The parse mode to set.
    set_parse_mode = function(mode) {
      self$parse_mode <- self$sanitize_parse_mode(mode)
    },

    #  @description Get the current parse mode.
    get_parse_mode = function() {
      self$parse_mode
    },

    #  @description Parse a message text based on the parse mode.
    #  @param message The message text to parse.
    #  @param parse_mode Optional override parse mode.
    parse_message_text = function(message, parse_mode = NULL) {
      if (is.null(parse_mode)) {
        parse_mode <- self$parse_mode
      } else {
        parse_mode <- self$sanitize_parse_mode(parse_mode)
      }

      if (is.null(parse_mode)) {
        return(list(message = message, entities = list()))
      }

      parsed_message <- message
      entities <- list()

      if (nchar(parsed_message) == 0 && length(entities) == 0) {
        stop("Failed to parse message")
      }

      list(message = parsed_message, entities = entities)
    },

    #  @description Replace an entity with a mention of a user.
    #  @param entities The list of entities.
    #  @param i The index of the entity to replace.
    #  @param user The user to mention.
    replace_with_mention = function(entities, i, user) {
      tryCatch(
        {
          entities[[i]] <- list(
            #  @field type Field.
            type = "mention",
            offset = entities[[i]]$offset,
            length = entities[[i]]$length,
            user = user
          )
          TRUE
        },
        error = function(e) FALSE
      )
    },

    #  @description Extract the response message based on the request and result.
    #  @param request The original request.
    #  @param result The result from the API.
    #  @param input_chat The input chat entity (unused but kept for signature compatibility).
    get_response_message = function(request, result, input_chat) {
      updates <- list()

      if (inherits(result, "UpdateShort")) {
        updates <- list(result$update)
      } else if (inherits(result, c("Updates", "UpdatesCombined"))) {
        updates <- result$updates
      } else {
        return(NULL)
      }

      random_to_id <- list()
      id_to_message <- list()

      for (update in updates) {
        if (inherits(update, "UpdateMessageID")) {
          random_to_id[[as.character(update$random_id)]] <- update$id
        } else if (inherits(update, c("UpdateNewChannelMessage", "UpdateNewMessage"))) {
          id_to_message[[as.character(update$message$id)]] <- update$message
        }
      }

      if (is.null(request)) {
        return(id_to_message)
      }

      random_id <- if (is.numeric(request)) request else request$random_id
      if (is.null(random_id)) {
        warning("No random_id in request to map to, returning NULL")
        return(NULL)
      }

      if (!is.list(random_id)) {
        return(id_to_message[[as.character(random_to_id[[as.character(random_id)]])]])
      }

      lapply(random_id, function(rnd) id_to_message[[as.character(random_to_id[[as.character(rnd)]])]])
    }
  )
)
