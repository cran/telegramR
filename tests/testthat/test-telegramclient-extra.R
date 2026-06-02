test_that("TelegramClient parse mode helpers behave", {
  skip_on_cran()
  old <- options()
  on.exit(options(old), add = TRUE)
  options(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE)

  client <- TelegramClient$new("sess_test", api_id = 1, api_hash = "hash")

  expect_null(client$sanitize_parse_mode(NULL))
  expect_equal(client$sanitize_parse_mode("markdown"), "markdown")
  expect_error(client$sanitize_parse_mode("bad"), "Invalid parse mode")

  client$set_parse_mode("markdown")
  expect_equal(client$get_parse_mode(), "markdown")

  out <- client$parse_message_text("hi", parse_mode = NULL)
  expect_equal(out$message, "hi")
  expect_true(is.list(out$entities))

  expect_error(client$parse_message_text("", parse_mode = "markdown"), "Failed to parse message")
})

test_that("TelegramClient build_reply_markup handles basic inputs", {
  skip_on_cran()
  old <- options()
  on.exit(options(old), add = TRUE)
  options(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE)

  client <- TelegramClient$new("sess_test2", api_id = 1, api_hash = "hash")

  # Single atomic button -> keyboard markup
  mk <- client$build_reply_markup("OK")
  expect_equal(mk[["_type"]], "ReplyKeyboardMarkup")
  expect_true(length(mk$rows) == 1)

  # Non-inline button with inline_only should error
  expect_error(client$build_reply_markup("OK", inline_only = TRUE), "non-inline")
})

test_that("TelegramClient event handler add/remove/list works", {
  skip_on_cran()
  old <- options()
  on.exit(options(old), add = TRUE)
  options(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE)

  client <- TelegramClient$new("sess_evt", api_id = 1, api_hash = "hash")

  old_events <- NULL
  if (exists("events", envir = .GlobalEnv, inherits = FALSE)) {
    old_events <- get("events", envir = .GlobalEnv)
  }
  on.exit({
    if (is.null(old_events)) {
      if (exists("events", envir = .GlobalEnv, inherits = FALSE)) {
        rm("events", envir = .GlobalEnv)
      }
    } else {
      assign("events", old_events, envir = .GlobalEnv)
    }
  }, add = TRUE)

  assign("events", list(get_handlers = function(cb) NULL, Raw = function() list()), envir = .GlobalEnv)

  client$client <- new.env(parent = emptyenv())
  client$client$event_builders <- list()

  cb <- function(ev) ev
  client$add_event_handler(cb)
  expect_equal(length(client$list_event_handlers()), 1)

  removed <- client$remove_event_handler(cb)
  expect_equal(removed, 1)
  expect_equal(length(client$list_event_handlers()), 0)
})
