#' Send a Video
#'
#' Convenience wrapper to send a video to a target entity.
#'
#' @param client TelegramClient instance.
#' @param entity Target entity (username, id, or TLObject).
#' @param file Video file path or file-like object.
#' @param ... Additional arguments passed to `TelegramClient$send_message()`
#'   (e.g., `message`, `supports_streaming`, `parse_mode`, `buttons`).
#' @return The sent message object (or Updates result).
#' @export
send_video <- function(client, entity, file, ...) {
  if (missing(client) || is.null(client)) {
    stop("client is required")
  }
  if (missing(entity) || is.null(entity)) {
    stop("entity is required")
  }
  if (missing(file) || is.null(file)) {
    stop("file is required")
  }
  res <- client$send_message(entity = entity, file = file, supports_streaming = TRUE, ...)
  if (inherits(res, "promise") || inherits(res, "Future")) {
    res <- future::value(res)
  }
  res
}
