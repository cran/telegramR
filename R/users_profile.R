#' Retrieve full information about a user
#'
#' @param client TelegramClient instance.
#' @param user User (username, id, link) or "me".
#' @return The API response (UserFull).
#' @export
get_full_user <- function(client, user = "me") {
  resolve_future <- function(x) {
    if (inherits(x, c("promise", "Future"))) {
      return(future::value(x))
    }
    x
  }

  ent <- resolve_future(client$get_entity(user))
  input_user <- get_input_user(ent)
  resolve_future(client$call(GetFullUserRequest$new(input_user)))
}

#' Update your name and/or bio
#'
#' @param client TelegramClient instance.
#' @param first_name First name (optional).
#' @param last_name Last name (optional).
#' @param bio About/bio text (optional).
#' @return The API response.
#' @export
update_profile <- function(client, first_name = NULL, last_name = NULL, bio = NULL) {
  resolve_future <- function(x) {
    if (inherits(x, c("promise", "Future"))) {
      return(future::value(x))
    }
    x
  }

  req <- UpdateProfileRequest$new(
    firstName = first_name,
    lastName = last_name,
    about = bio
  )
  resolve_future(client$call(req))
}

#' Update your username
#'
#' @param client TelegramClient instance.
#' @param username New username (without @).
#' @return The API response.
#' @export
update_username <- function(client, username) {
  resolve_future <- function(x) {
    if (inherits(x, c("promise", "Future"))) {
      return(future::value(x))
    }
    x
  }

  if (!is.character(username) || length(username) != 1 || nchar(username) == 0) {
    stop("username must be a non-empty string")
  }

  # Use a local request object to avoid name clashes with channel UpdateUsernameRequest.
  req <- new.env(parent = emptyenv())
  req$CONSTRUCTOR_ID <- as.integer(0x7cdd0b3e)
  req$username <- username
  req$toDict <- function() {
    list("_" = "UpdateUsernameRequest", username = req$username)
  }
  req$bytes <- function() {
    c(
      as.raw(c(0x3e, 0x0b, 0xdd, 0x7c)),
      serialize_bytes(req$username)
    )
  }
  class(req) <- c("UpdateUsernameRequest", "TLRequest")

  resolve_future(client$call(req))
}

#' Update your profile photo
#'
#' @param client TelegramClient instance.
#' @param file Path to image file.
#' @param progress_callback Optional callback (pos, total).
#' @return The API response.
#' @export
update_profile_photo <- function(client, file, progress_callback = NULL) {
  resolve_future <- function(x) {
    if (inherits(x, c("promise", "Future"))) {
      return(future::value(x))
    }
    x
  }

  upload <- client$upload_file(file, progress_callback = progress_callback)
  handle <- resolve_future(upload)
  req <- UploadProfilePhotoRequest$new(file = handle)
  resolve_future(client$call(req))
}
