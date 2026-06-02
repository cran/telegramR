#' Join a public channel by username
#'
#' @param client TelegramClient instance.
#' @param channel Public channel username or link (non-invite).
#' @return The API response.
#' @export
join_public_channel <- function(client, channel) {
  resolve_future <- function(x) {
    if (inherits(x, c("promise", "Future"))) {
      return(future::value(x))
    }
    x
  }

  ent <- resolve_future(client$get_entity(channel))
  input <- get_input_channel(ent)
  resolve_future(client$invoke(JoinChannelRequest$new(channel = input)))
}

#' Join a private chat or channel by invite link
#'
#' @param client TelegramClient instance.
#' @param invite_link Invite link (e.g. https://t.me/joinchat/... or https://t.me/+...).
#' @return The API response.
#' @export
join_private_chat <- function(client, invite_link) {
  resolve_future <- function(x) {
    if (inherits(x, c("promise", "Future"))) {
      return(future::value(x))
    }
    x
  }

  parsed <- parse_username(invite_link)
  if (!isTRUE(parsed$is_join_chat) || is.null(parsed$username)) {
    stop("Invite link is required for private chats/channels")
  }
  resolve_future(client$invoke(ImportChatInviteRequest$new(hash = parsed$username)))
}

#' Join a chat or channel by username or invite link
#'
#' @param client TelegramClient instance.
#' @param channel Username/link or invite link.
#' @return The API response.
#' @export
join_channel <- function(client, channel) {
  parsed <- parse_username(channel)
  if (isTRUE(parsed$is_join_chat)) {
    return(join_private_chat(client, channel))
  }
  join_public_channel(client, channel)
}
