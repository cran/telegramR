#' Send a File
#'
#' Convenience wrapper around `TelegramClient$send_message()` that sends a file
#' and resolves futures/promises.
#'
#' @param client TelegramClient instance.
#' @param entity Target entity (username, id, or TLObject).
#' @param file File path or file-like object.
#' @param ... Additional arguments passed to `TelegramClient$send_message()`
#'   (e.g., `message`, `force_document`, `attributes`, `thumb`, `parse_mode`).
#' @return The sent message object (or Updates result).
#' @export
send_file <- function(client, entity, file, ...) {
  if (missing(client) || is.null(client)) {
    stop("client is required")
  }
  if (missing(entity) || is.null(entity)) {
    stop("entity is required")
  }
  if (missing(file) || is.null(file)) {
    stop("file is required")
  }
  res <- client$send_message(entity = entity, file = file, ...)
  if (inherits(res, "promise") || inherits(res, "Future")) {
    res <- future::value(res)
  }
  res
}
