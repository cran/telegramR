# Additional coverage tests for R/telegramclient.R
# Tests focus on pure/standalone methods that don't require a real connection.

# Helper: build a minimal TelegramClient in test mode (no real connection)
make_tc <- function() {
  withr::with_options(
    list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE),
    TelegramClient$new(session = NULL, api_id = 123L, api_hash = "abc")
  )
}

# ── sanitize_parse_mode ───────────────────────────────────────────────────────
test_that("sanitize_parse_mode returns NULL for NULL input", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    tc <- TelegramClient$new(session = NULL, api_id = 123L, api_hash = "abc")
    expect_null(tc$sanitize_parse_mode(NULL))
  })
})

test_that("sanitize_parse_mode accepts markdown/md/html/htm", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    tc <- TelegramClient$new(session = NULL, api_id = 123L, api_hash = "abc")
    expect_equal(tc$sanitize_parse_mode("markdown"), "markdown")
    expect_equal(tc$sanitize_parse_mode("md"),       "md")
    expect_equal(tc$sanitize_parse_mode("html"),     "html")
    expect_equal(tc$sanitize_parse_mode("htm"),      "htm")
  })
})

test_that("sanitize_parse_mode errors for unknown mode string", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    tc <- TelegramClient$new(session = NULL, api_id = 123L, api_hash = "abc")
    expect_error(tc$sanitize_parse_mode("rst"), "Invalid parse mode")
  })
})

# ── set_parse_mode / get_parse_mode ──────────────────────────────────────────
test_that("set_parse_mode and get_parse_mode round-trip", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    tc <- TelegramClient$new(session = NULL, api_id = 123L, api_hash = "abc")
    tc$set_parse_mode("html")
    expect_equal(tc$get_parse_mode(), "html")
  })
})

# ── parse_phone ───────────────────────────────────────────────────────────────
test_that("parse_phone strips non-digits and returns cleaned phone", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    tc <- TelegramClient$new(session = NULL, api_id = 123L, api_hash = "abc")
    expect_equal(tc$parse_phone("+1 (800) 555-1234"), "+18005551234")
    expect_equal(tc$parse_phone("380441234567"), "380441234567")
  })
})

test_that("parse_phone returns NULL for NULL input", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    tc <- TelegramClient$new(session = NULL, api_id = 123L, api_hash = "abc")
    expect_null(tc$parse_phone(NULL))
  })
})

test_that("parse_phone returns NULL for too-short number", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    tc <- TelegramClient$new(session = NULL, api_id = 123L, api_hash = "abc")
    expect_null(tc$parse_phone("123"))
  })
})

# ── get_display_name ──────────────────────────────────────────────────────────
test_that("get_display_name combines first_name and last_name", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    tc <- TelegramClient$new(session = NULL, api_id = 123L, api_hash = "abc")
    user <- list(first_name = "John", last_name = "Doe", username = "jdoe", id = 1L)
    expect_equal(tc$get_display_name(user), "John Doe")
  })
})

test_that("get_display_name uses first_name when no last_name", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    tc <- TelegramClient$new(session = NULL, api_id = 123L, api_hash = "abc")
    user <- list(first_name = "Alice", last_name = NULL, username = "alice", id = 2L)
    expect_equal(tc$get_display_name(user), "Alice")
  })
})

test_that("get_display_name falls back to username when no name", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    tc <- TelegramClient$new(session = NULL, api_id = 123L, api_hash = "abc")
    user <- list(first_name = NULL, last_name = NULL, username = "bot_user", id = 99L)
    expect_equal(tc$get_display_name(user), "bot_user")
  })
})

test_that("get_display_name falls back to id when no name or username", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    tc <- TelegramClient$new(session = NULL, api_id = 123L, api_hash = "abc")
    user <- list(first_name = NULL, last_name = NULL, username = NULL, id = 777L)
    expect_equal(tc$get_display_name(user), "777")
  })
})

# ── parse_message_text (no parse_mode → passthrough) ─────────────────────────
test_that("parse_message_text with NULL parse_mode returns raw message", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    tc <- TelegramClient$new(session = NULL, api_id = 123L, api_hash = "abc")
    tc$set_parse_mode(NULL)
    result <- tc$parse_message_text("Hello World")
    expect_equal(result$message, "Hello World")
    expect_equal(result$entities, list())
  })
})

# ── initialize sets default parse_mode to "markdown" ─────────────────────────
test_that("TelegramClient initializes with parse_mode = 'markdown'", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    tc <- TelegramClient$new(session = NULL, api_id = 123L, api_hash = "abc")
    expect_equal(tc$parse_mode, "markdown")
  })
})
