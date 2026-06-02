#' Send a Photo
#'
#' Convenience wrapper to send a photo to a target entity.
#'
#' @param client TelegramClient instance.
#' @param entity Target entity (username, id, or TLObject).
#' @param file Photo file path or file-like object.
#' @param ... Additional arguments passed to `TelegramClient$send_message()`
#'   (e.g., `message`, `parse_mode`, `buttons`).
#' @return The sent message object (or Updates result).
#' @export
send_photo <- function(client, entity, file, ...) {
  if (missing(client) || is.null(client)) {
    stop("client is required")
  }
  if (missing(entity) || is.null(entity)) {
    stop("entity is required")
  }
  if (missing(file) || is.null(file)) {
    stop("file is required")
  }
  res <- client$send_message(entity = entity, file = file, force_document = FALSE, ...)
  if (inherits(res, "promise") || inherits(res, "Future")) {
    res <- future::value(res)
  }
  res
}
