# Tests for the bellingcat-style phone-number / username checker.
# All tests use a fake client so no network calls happen.

make_user <- function(...) {
  defaults <- list(
    id = 1001L, username = "alice", first_name = "Alice", last_name = "Wonder",
    phone = "15551112222", fake = FALSE, verified = TRUE, premium = FALSE,
    mutual_contact = FALSE, bot = FALSE, bot_chat_history = NULL,
    restricted = FALSE, restriction_reason = NULL, usernames = NULL,
    status = NULL
  )
  u <- modifyList(defaults, list(...))
  class(u) <- "User"
  u
}

# A client whose invoke() responds based on the request class.
make_phone_client <- function(import_users = list(), delete_users = NULL,
                              download_path = NULL, throw_on_invoke = NULL) {
  env <- new.env(parent = emptyenv())
  env$invoked <- list()
  list(
    invoke = function(req) {
      env$invoked[[length(env$invoked) + 1L]] <- req
      if (!is.null(throw_on_invoke) && inherits(req, throw_on_invoke)) {
        stop("simulated RPC error")
      }
      if (inherits(req, "ImportContactsRequest")) {
        return(list(users = import_users))
      }
      if (inherits(req, "DeleteContactsRequest")) {
        return(list(users = delete_users %||% import_users))
      }
      list()
    },
    download_profile_photo = function(entity, file = NULL, download_big = TRUE) {
      if (is.null(download_path)) return(NULL)
      download_path
    },
    .env = env
  )
}

make_username_client <- function(entity = NULL, error = NULL,
                                 download_path = NULL) {
  list(
    get_entity = function(username) {
      if (!is.null(error)) stop(error)
      entity
    },
    download_profile_photo = function(entity, file = NULL, download_big = TRUE) {
      download_path
    }
  )
}

test_that("check_phone_on_telegram returns a populated record on a single match", {
  skip_on_cran()
  user <- make_user(id = 42L, username = "bob", first_name = "Bob",
                    last_name = "Lee", phone = "15550001111")
  client <- make_phone_client(import_users = list(user))

  res <- check_phone_on_telegram(client, "+15550001111")

  expect_type(res, "list")
  expect_null(res$error)
  expect_equal(res$id, 42L)
  expect_equal(res$username, "bob")
  expect_equal(res$first_name, "Bob")
  expect_equal(res$phone, "15550001111")
  expect_true(res$verified)
})

test_that("check_phone_on_telegram falls back to the supplied phone when User has none", {
  skip_on_cran()
  user <- make_user(phone = NULL)
  client <- make_phone_client(import_users = list(user))

  res <- check_phone_on_telegram(client, "+44123456")
  expect_equal(res$phone, "+44123456")
})

test_that("check_phone_on_telegram reports no-match", {
  skip_on_cran()
  client <- make_phone_client(import_users = list())
  res <- check_phone_on_telegram(client, "+15550000000")
  expect_match(res$error, "not on Telegram")
})

test_that("check_phone_on_telegram reports multiple matches", {
  skip_on_cran()
  client <- make_phone_client(
    import_users = list(make_user(id = 1L), make_user(id = 2L))
  )
  res <- check_phone_on_telegram(client, "+15551112222")
  expect_match(res$error, "multiple Telegram accounts")
})

test_that("check_phone_on_telegram surfaces RPC errors as an error field", {
  skip_on_cran()
  client <- make_phone_client(throw_on_invoke = "ImportContactsRequest")
  res <- check_phone_on_telegram(client, "+15550000000")
  expect_match(res$error, "Unexpected error")
})

test_that("check_phone_on_telegram validates input", {
  skip_on_cran()
  expect_error(check_phone_on_telegram(NULL, ""), "non-empty string")
  expect_error(check_phone_on_telegram(NULL, c("+1", "+2")), "non-empty string")
})

test_that("check_phone_on_telegram both invokes Import and Delete", {
  skip_on_cran()
  user <- make_user(id = 9L)
  client <- make_phone_client(import_users = list(user))
  check_phone_on_telegram(client, "+15550009999")
  classes <- vapply(client$.env$invoked, function(r) class(r)[[1]], character(1))
  expect_setequal(classes, c("ImportContactsRequest", "DeleteContactsRequest"))
})

test_that("check_phones_on_telegram returns one row per unique phone", {
  skip_on_cran()
  client <- make_phone_client(import_users = list(make_user(id = 7L)))
  out <- check_phones_on_telegram(client, "+1, +2, +1")
  expect_s3_class(out, "tbl_df")
  expect_equal(nrow(out), 2L)
  expect_setequal(out$phone_query, c("+1", "+2"))
})

test_that("check_phones_on_telegram accepts a character vector", {
  skip_on_cran()
  client <- make_phone_client(import_users = list(make_user(id = 7L)))
  out <- check_phones_on_telegram(client, c("+1", "+2"))
  expect_equal(nrow(out), 2L)
})

test_that("check_username_on_telegram returns a populated record for a User", {
  skip_on_cran()
  user <- make_user(id = 100L, username = "charlie", first_name = "Charlie")
  client <- make_username_client(entity = user)
  res <- check_username_on_telegram(client, "@charlie")
  expect_null(res$error)
  expect_equal(res$id, 100L)
  expect_equal(res$username, "charlie")
})

test_that("check_username_on_telegram strips a leading @", {
  skip_on_cran()
  user <- make_user(username = "dora")
  client <- make_username_client(entity = user)
  res <- check_username_on_telegram(client, "@dora")
  expect_equal(res$username, "dora")
})

test_that("check_username_on_telegram refuses channels and chats", {
  skip_on_cran()
  channel <- structure(list(id = 1L, title = "A Channel"), class = "Channel")
  chat    <- structure(list(id = 2L, title = "A Chat"),    class = "Chat")

  res_ch <- check_username_on_telegram(make_username_client(entity = channel), "ch")
  expect_match(res_ch$error, "channel or supergroup")

  res_chat <- check_username_on_telegram(make_username_client(entity = chat), "gc")
  expect_match(res_chat$error, "group chat")
})

test_that("check_username_on_telegram maps Telethon-style errors", {
  skip_on_cran()
  res1 <- check_username_on_telegram(
    make_username_client(error = "UsernameNotOccupiedError: ..."), "ghost")
  expect_match(res1$error, "does not exist")

  res2 <- check_username_on_telegram(
    make_username_client(error = "UsernameInvalidError"), "!!")
  expect_match(res2$error, "is invalid")

  res3 <- check_username_on_telegram(
    make_username_client(error = "boom"), "anybody")
  expect_match(res3$error, "Unexpected error")
})

test_that("check_username_on_telegram validates input", {
  skip_on_cran()
  expect_error(check_username_on_telegram(NULL, ""), "non-empty string")
  expect_error(check_username_on_telegram(NULL, c("a", "b")), "non-empty string")
})

test_that("check_usernames_on_telegram aggregates results into a tibble", {
  skip_on_cran()
  user <- make_user(username = "eve")
  client <- make_username_client(entity = user)
  # Matching upstream's behaviour, the leading "@" is part of the dedupe key,
  # so "@eve" and "eve" are treated as separate queries.
  out <- check_usernames_on_telegram(client, "@eve, eve, frank, eve")
  expect_s3_class(out, "tbl_df")
  expect_equal(nrow(out), 3L)
  expect_setequal(out$username_query, c("@eve", "eve", "frank"))
})

test_that("user status helper handles all known classes", {
  skip_on_cran()
  expect_equal(.tg_user_status_string(NULL), NA_character_)
  expect_equal(.tg_user_status_string(structure(list(), class = "UserStatusOnline")),
               "Currently online")
  expect_equal(.tg_user_status_string(structure(list(), class = "UserStatusRecently")),
               "Last seen recently")
  expect_equal(.tg_user_status_string(structure(list(), class = "UserStatusLastWeek")),
               "Last seen last week")
  expect_equal(.tg_user_status_string(structure(list(), class = "UserStatusLastMonth")),
               "Last seen last month")
  expect_equal(.tg_user_status_string(structure(list(), class = "UserStatusEmpty")),
               "Unknown")
  off <- structure(list(was_online = "2025-01-02 03:04:05"),
                   class = "UserStatusOffline")
  expect_equal(.tg_user_status_string(off), "2025-01-02 03:04:05")
})

test_that(".tg_split_targets normalises both vectors and comma strings", {
  skip_on_cran()
  expect_equal(.tg_split_targets(NULL), character(0))
  expect_equal(.tg_split_targets("  +1 , +2,  +3 "), c("+1", "+2", "+3"))
  expect_equal(.tg_split_targets(c(" a ", "b")), c("a", "b"))
  expect_equal(.tg_split_targets(c("", " ")), character(0))
})

test_that("check_phone_on_telegram triggers profile-photo download when requested", {
  skip_on_cran()
  tmp <- tempfile()
  user <- make_user(id = 12L, phone = "+19998887777")
  client <- make_phone_client(import_users = list(user),
                              download_path = tmp)
  res <- check_phone_on_telegram(client, "+19998887777",
                                 download_profile_photo = TRUE,
                                 photo_dir = tempdir())
  expect_equal(res$profile_photo_path, tmp)
})
