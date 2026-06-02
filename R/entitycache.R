#  @noRd
#  @noRd
EntityCache <- R6::R6Class(
  "EntityCache",
  public = list(
    #  @field self_id Field.
    self_id = NULL,
    #  @field self_bot Field.
    self_bot = NULL,
    #  @field entities Field.
    entities = NULL,
    initialize = function() {
      self$self_id <- NULL
      self$self_bot <- NULL
      self$entities <- list()
    },
    size = function() {
      return(length(self$entities))
    },
    set_self_user = function(id, bot, access_hash = NULL) {
      self$self_id <- id
      self$self_bot <- bot
      invisible(TRUE)
    },
    get = function(id) {
      self$entities[[as.character(id)]]
    },
    extend = function(users = NULL, chats = NULL) {
      if (is.null(users)) users <- list()
      if (is.null(chats)) chats <- list()
      items <- c(users, chats)
      for (x in items) {
        id <- tryCatch(get_peer_id(x, add_mark = FALSE), error = function(e) NULL)
        if (!is.null(id)) {
          self$entities[[as.character(id)]] <- x
        }
      }
      invisible(TRUE)
    },
    retain = function(predicate) {
      if (is.null(predicate) || !is.function(predicate)) {
        return(invisible(FALSE))
      }
      ids <- names(self$entities)
      keep <- vapply(ids, predicate, logical(1))
      self$entities <- self$entities[keep]
      invisible(TRUE)
    }
  )
)
