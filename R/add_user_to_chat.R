#' Add a user to a chat or channel
#'
#' @param client TelegramClient instance.
#' @param chat Chat/channel (username, link, or entity).
#' @param user User (username, link, or entity).
#' @param fwd_limit Forward limit for basic chats. Default is 10.
#' @return The API response.
#' @export
add_user_to_chat <- function(client, chat, user, fwd_limit = 10) {
  resolve_future <- function(x) {
    if (inherits(x, c("promise", "Future"))) {
      return(future::value(x))
    }
    x
  }

  chat_ent <- resolve_future(client$get_entity(chat))
  user_ent <- resolve_future(client$get_entity(user))

  if (inherits(chat_ent, "Channel")) {
    input_channel <- get_input_channel(chat_ent)
    input_user <- get_input_user(user_ent)
    return(resolve_future(client$invoke(InviteToChannelRequest$new(
      channel = input_channel,
      users = list(input_user)
    ))))
  }

  if (inherits(chat_ent, "Chat")) {
    input_user <- get_input_user(user_ent)
    return(resolve_future(client$invoke(AddChatUserRequest$new(
      chatId = chat_ent$id,
      userId = input_user,
      fwdLimit = fwd_limit
    ))))
  }

  stop("Chat must be a basic chat or channel")
}
