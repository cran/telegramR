#' Check whether phone numbers or usernames belong to Telegram accounts
#'
#' These helpers port the functionality of bellingcat's
#' \emph{telegram-phone-number-checker} Python tool to R. They use the
#' currently authenticated [TelegramClient] to look up users by phone
#' number (via `ImportContactsRequest` / `DeleteContactsRequest`) or by
#' username (via `client$get_entity()`), and return the public profile
#' fields Telegram returns about the matched user.
#'
#' Phone-number lookups briefly add the number to your contact list and
#' then delete it. Telegram throttles abusive callers — Bellingcat
#' recommends using a fresh, residential-IP account rather than a
#' personal one.
#'
#' @name phone_number_checker
NULL

.tg_resolve_future <- function(x) {
  if (inherits(x, c("promise", "Future"))) {
    return(future::value(x))
  }
  x
}

# Build an InputPhoneContact stand-in. The generated R6 class in types.R has
# locked fields and cannot be instantiated, so we hand-roll a minimal TL
# object exposing the same wire format (constructor 0xf392b7f4 + client_id:long
# + phone/first_name/last_name as TL strings).
.tg_make_input_phone_contact <- function(client_id, phone, first_name = "",
                                         last_name = "") {
  obj <- list(
    CONSTRUCTOR_ID = 0xf392b7f4,
    SUBCLASS_OF_ID = 0xae696a82,
    client_id  = client_id,
    phone      = phone,
    first_name = first_name,
    last_name  = last_name,
    to_list = function() {
      list(`_` = "InputPhoneContact",
           client_id = client_id, phone = phone,
           first_name = first_name, last_name = last_name)
    },
    to_bytes = function() {
      c(
        as.raw(c(0xf4, 0xb7, 0x92, 0xf3)),
        packInt64(client_id),
        serialize_bytes(phone),
        serialize_bytes(first_name),
        serialize_bytes(last_name)
      )
    }
  )
  class(obj) <- c("InputPhoneContact", "TLObject")
  obj
}

# Format a TypeUserStatus into a short human-readable string. Mirrors
# get_human_readable_user_status() in the upstream Python tool.
.tg_user_status_string <- function(status) {
  if (is.null(status)) return(NA_character_)
  cls <- class(status)
  if ("UserStatusOnline" %in% cls) return("Currently online")
  if ("UserStatusOffline" %in% cls) {
    was <- status$was_online
    if (is.null(was)) return("Offline")
    if (inherits(was, c("POSIXct", "POSIXt", "Date"))) {
      return(format(was, "%Y-%m-%d %H:%M:%S %Z"))
    }
    return(as.character(was))
  }
  if ("UserStatusRecently" %in% cls) return("Last seen recently")
  if ("UserStatusLastWeek" %in% cls) return("Last seen last week")
  if ("UserStatusLastMonth" %in% cls) return("Last seen last month")
  if ("UserStatusEmpty" %in% cls) return("Unknown")
  "Unknown"
}

# Pull the subset of fields we surface from a User object.
.tg_user_to_record <- function(user, phone = NULL) {
  if (is.null(user)) return(list())
  usernames <- user$usernames
  usernames_chr <- if (is.null(usernames) || length(usernames) == 0L) {
    NULL
  } else {
    vapply(usernames, function(u) {
      val <- if (is.list(u)) u$username else u$username
      if (is.null(val)) NA_character_ else as.character(val)
    }, character(1))
  }
  restriction_reason <- user$restriction_reason
  restriction_chr <- if (is.null(restriction_reason) || length(restriction_reason) == 0L) {
    NULL
  } else {
    vapply(restriction_reason, function(r) {
      reason <- if (is.list(r)) r$reason else r$reason
      txt    <- if (is.list(r)) r$text   else r$text
      paste(c(reason, txt), collapse = ": ")
    }, character(1))
  }

  list(
    id                = user$id,
    username          = user$username,
    usernames         = usernames_chr,
    first_name        = user$first_name,
    last_name         = user$last_name,
    fake              = user$fake,
    verified          = user$verified,
    premium           = user$premium,
    mutual_contact    = user$mutual_contact,
    bot               = user$bot,
    bot_chat_history  = user$bot_chat_history,
    restricted        = user$restricted,
    restriction_reason = restriction_chr,
    user_was_online   = .tg_user_status_string(user$status),
    phone             = user$phone %||% phone
  )
}

# Try to download a user's profile photo. Errors are swallowed and
# turned into a warning so a single I/O failure does not abort a batch.
.tg_try_download_profile_photo <- function(client, user, label, photo_dir) {
  if (is.null(client$download_profile_photo)) {
    warning("client does not support download_profile_photo()", call. = FALSE)
    return(NA_character_)
  }
  out_dir <- photo_dir %||% tempdir()
  if (!dir.exists(out_dir)) {
    dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  }
  safe_label <- gsub("[^A-Za-z0-9._+-]", "_", label)
  uid <- user$id %||% "unknown"
  out_file <- file.path(out_dir, sprintf("%s_%s_photo.jpeg", uid, safe_label))
  tryCatch({
    res <- .tg_resolve_future(client$download_profile_photo(
      user, file = out_file, download_big = TRUE
    ))
    if (is.null(res)) return(NA_character_)
    as.character(res)
  }, error = function(e) {
    warning(sprintf("Could not download profile photo for %s: %s",
                    label, conditionMessage(e)), call. = FALSE)
    NA_character_
  })
}

#' Check whether a single phone number is registered on Telegram
#'
#' Adds the phone number to the authenticated account's contacts via
#' `ImportContactsRequest`, captures any matching user, then removes
#' the contact via `DeleteContactsRequest`. The contact addition is
#' transient — Telegram users are not notified.
#'
#' @param client An authenticated [TelegramClient] instance.
#' @param phone Phone number string in international format
#'   (e.g. `"+15551234567"`).
#' @param download_profile_photo If `TRUE`, attempt to download the
#'   matched user's profile photo into `photo_dir`
#'   (default: `tempdir()`). Failures are reported as warnings.
#' @param photo_dir Directory to save downloaded profile photos; created
#'   if it doesn't exist. Ignored when `download_profile_photo` is
#'   `FALSE`.
#' @return A named list with the user's public fields, or a list with
#'   an `error` field describing why the lookup failed (no match,
#'   multiple matches, RPC error, ...).
#' @seealso [check_phones_on_telegram()] for batch lookups.
#' @export
check_phone_on_telegram <- function(client, phone,
                                    download_profile_photo = FALSE,
                                    photo_dir = NULL) {
  if (!is.character(phone) || length(phone) != 1L || !nzchar(phone)) {
    stop("phone must be a single non-empty string", call. = FALSE)
  }

  contact <- .tg_make_input_phone_contact(
    client_id = 0, phone = phone, first_name = "", last_name = ""
  )

  imported <- tryCatch(
    .tg_resolve_future(client$invoke(
      ImportContactsRequest$new(contacts = list(contact))
    )),
    error = function(e) {
      list(error = sprintf("Unexpected error: %s.", conditionMessage(e)))
    }
  )
  if (!is.null(imported$error)) return(imported)

  users <- imported$users %||% list()
  n_match <- length(users)

  if (n_match == 0L) {
    return(list(error = paste0(
      "No response, the phone number is not on Telegram or has blocked ",
      "contact adding."
    )))
  }
  if (n_match > 1L) {
    return(list(error = paste0(
      "This phone number matched multiple Telegram accounts, which is ",
      "unexpected."
    )))
  }

  matched <- users[[1]]
  uid <- if (is.list(matched)) matched$id else matched$id

  delete_resp <- tryCatch(
    .tg_resolve_future(client$invoke(
      DeleteContactsRequest$new(id = list(uid))
    )),
    error = function(e) {
      list(error = sprintf(
        "TypeError: %s. --> The error might have occurred due to the inability to delete the phone=%s from the contact list.",
        conditionMessage(e), phone))
    }
  )
  if (!is.null(delete_resp$error)) return(delete_resp)

  user <- (delete_resp$users %||% list(matched))[[1]]

  result <- .tg_user_to_record(user, phone = phone)

  if (isTRUE(download_profile_photo)) {
    result$profile_photo_path <- .tg_try_download_profile_photo(
      client, user, label = phone, photo_dir = photo_dir
    )
  }

  result
}

# Coerce a comma-separated string OR character vector into a clean
# vector of trimmed, non-empty entries.
.tg_split_targets <- function(x) {
  if (is.null(x)) return(character(0))
  if (is.character(x) && length(x) == 1L && grepl(",", x)) {
    x <- strsplit(x, ",", fixed = TRUE)[[1]]
  }
  x <- gsub("\\s+", "", as.character(x), perl = TRUE)
  x[nzchar(x)]
}

# Glue per-target result lists into a tibble, padding missing fields
# with NA so columns stay aligned.
.tg_records_to_tibble <- function(records, target_col, targets) {
  if (length(records) == 0L) return(tibble::tibble())
  all_names <- unique(unlist(lapply(records, names)))
  rows <- lapply(seq_along(records), function(i) {
    rec <- records[[i]]
    row <- stats::setNames(
      lapply(all_names, function(nm) rec[[nm]] %||% NA),
      all_names
    )
    c(stats::setNames(list(targets[[i]]), target_col), row)
  })
  dplyr::bind_rows(rows)
}

#' Check several phone numbers in one call
#'
#' Convenience wrapper around [check_phone_on_telegram()] that accepts
#' either a character vector or a single comma-separated string (matching
#' the upstream Python CLI). Duplicates are silently de-duplicated.
#'
#' @param client An authenticated [TelegramClient] instance.
#' @param phones Character vector of phone numbers, or a single
#'   comma-separated string.
#' @param download_profile_photo,photo_dir See [check_phone_on_telegram()].
#' @return A tibble with one row per unique phone number. Successful
#'   lookups expose the user's public fields; failures expose an `error`
#'   column.
#' @seealso [check_phone_on_telegram()] for the single-phone variant.
#' @export
check_phones_on_telegram <- function(client, phones,
                                     download_profile_photo = FALSE,
                                     photo_dir = NULL) {
  targets <- unique(.tg_split_targets(phones))
  records <- lapply(targets, function(p) {
    check_phone_on_telegram(client, p,
                            download_profile_photo = download_profile_photo,
                            photo_dir = photo_dir)
  })
  .tg_records_to_tibble(records, "phone_query", targets)
}

#' Check whether a single username belongs to a Telegram user
#'
#' Looks up the username via `client$get_entity()`. Channels and group
#' chats produce an `error` row — this helper is for user accounts only.
#'
#' @param client An authenticated [TelegramClient] instance.
#' @param username Username, with or without a leading `@`.
#' @param download_profile_photo,photo_dir See [check_phone_on_telegram()].
#' @return A named list with the user's public fields, or a list with
#'   an `error` field.
#' @seealso [check_usernames_on_telegram()] for batch lookups.
#' @export
check_username_on_telegram <- function(client, username,
                                       download_profile_photo = FALSE,
                                       photo_dir = NULL) {
  if (!is.character(username) || length(username) != 1L || !nzchar(username)) {
    stop("username must be a single non-empty string", call. = FALSE)
  }
  clean <- sub("^@", "", username)

  entity <- tryCatch(
    .tg_resolve_future(client$get_entity(clean)),
    error = function(e) {
      msg <- conditionMessage(e)
      if (grepl("UsernameNotOccupied|No user has", msg, ignore.case = TRUE)) {
        return(list(error = sprintf(
          "Username @%s does not exist on Telegram.", clean)))
      }
      if (grepl("UsernameInvalid", msg, ignore.case = TRUE)) {
        return(list(error = sprintf("Username @%s is invalid.", clean)))
      }
      list(error = sprintf(
        "Unexpected error while searching for @%s: %s.", clean, msg))
    }
  )
  if (!is.null(entity$error)) return(entity)

  cls <- class(entity)
  if (any(c("Channel", "ChannelForbidden") %in% cls)) {
    title <- entity$title %||% clean
    return(list(error = sprintf(
      "@%s is a channel or supergroup ('%s'), not a user account.",
      clean, title)))
  }
  if ("Chat" %in% cls) {
    title <- entity$title %||% clean
    return(list(error = sprintf(
      "@%s is a group chat ('%s'), not a user account.", clean, title)))
  }
  if (!any(c("User", "UserEmpty") %in% cls)) {
    return(list(error = sprintf(
      "@%s returned an unexpected entity type: %s",
      clean, cls[[1]])))
  }

  result <- .tg_user_to_record(entity)
  if (isTRUE(download_profile_photo)) {
    result$profile_photo_path <- .tg_try_download_profile_photo(
      client, entity, label = clean, photo_dir = photo_dir
    )
  }
  result
}

#' Check several usernames in one call
#'
#' Convenience wrapper around [check_username_on_telegram()].
#'
#' @param client An authenticated [TelegramClient] instance.
#' @param usernames Character vector of usernames, or a single
#'   comma-separated string. Leading `@` is optional and stripped.
#' @param download_profile_photo,photo_dir See [check_phone_on_telegram()].
#' @return A tibble with one row per unique username.
#' @seealso [check_username_on_telegram()] for the single-username variant.
#' @export
check_usernames_on_telegram <- function(client, usernames,
                                        download_profile_photo = FALSE,
                                        photo_dir = NULL) {
  targets <- unique(.tg_split_targets(usernames))
  records <- lapply(targets, function(u) {
    check_username_on_telegram(client, u,
                               download_profile_photo = download_profile_photo,
                               photo_dir = photo_dir)
  })
  .tg_records_to_tibble(records, "username_query", targets)
}
