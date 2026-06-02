#' Send a Message
#'
#' Convenience wrapper around `TelegramClient$send_message()` that resolves
#' futures/promises and returns the sent message (or Updates object).
#'
#' @param client TelegramClient instance.
#' @param entity Target entity (username, id, or TLObject).
#' @param ... Passed to `TelegramClient$send_message()`.
#' @return The sent message object (or Updates result).
#' @export
send_message <- function(client, entity, ...) {
  if (missing(client) || is.null(client)) {
    stop("client is required")
  }
  if (missing(entity) || is.null(entity)) {
    stop("entity is required")
  }
  res <- client$send_message(entity = entity, ...)
  if (inherits(res, "promise") || inherits(res, "Future")) {
    res <- future::value(res)
  }
  res
}
