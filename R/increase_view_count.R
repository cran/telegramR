#' Increase view count for channel messages
#'
#' @param client TelegramClient instance.
#' @param channel Channel (username, link, or entity).
#' @param message_ids Numeric vector of message IDs.
#' @return The API response (views).
#' @export
increase_view_count <- function(client, channel, message_ids) {
  resolve_future <- function(x) {
    if (inherits(x, c("promise", "Future"))) {
      return(future::value(x))
    }
    x
  }

  if (is.null(message_ids) || length(message_ids) == 0) {
    stop("message_ids must contain at least one message ID")
  }

  entity <- resolve_future(client$get_entity(channel))
  peer <- get_input_peer(entity, check_hash = FALSE)
  ids <- as.integer(message_ids)
  resolve_future(client$call(GetMessagesViewsRequest$new(peer = peer, id = ids, increment = TRUE)))
}
