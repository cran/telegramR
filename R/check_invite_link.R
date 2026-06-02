#' Check a chat invite link without joining
#'
#' @param client TelegramClient instance.
#' @param invite_link Invite link or invite hash.
#' @return The API response.
#' @export
check_invite_link <- function(client, invite_link) {
  resolve_future <- function(x) {
    if (inherits(x, c("promise", "Future"))) {
      return(future::value(x))
    }
    x
  }

  parsed <- parse_username(invite_link)
  if (isTRUE(parsed$is_join_chat) && !is.null(parsed$username)) {
    hash <- parsed$username
  } else {
    hash <- invite_link
  }

  if (!is.character(hash) || length(hash) != 1 || nchar(hash) == 0) {
    stop("Invite link or hash is required")
  }

  resolve_future(client$call(CheckChatInviteRequest$new(hash = hash)))
}
