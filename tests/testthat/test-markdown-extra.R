# Extra markdown coverage: strike, surrogate helpers, NULL/empty edge cases,
# unparse with various entity types.

# --- parse: strike ---

test_that("parse recognises ~~strike~~ delimiter", {
  skip_on_cran()
  result <- parse("~~struck~~")
  expect_equal(result$message, "struck")
  expect_equal(length(result$entities), 1L)
  expect_equal(result$entities[[1]]$type, "MessageEntityStrike")
  expect_equal(result$entities[[1]]$offset, 0L)
  expect_equal(result$entities[[1]]$length, 6L)
})

test_that("parse handles NULL message", {
  skip_on_cran()
  result <- parse(NULL)
  expect_null(result$message)
  expect_equal(result$entities, list())
})

test_that("parse with custom empty delimiters returns message unchanged", {
  skip_on_cran()
  result <- parse("**bold**", delimiters = list())
  expect_equal(result$message, "**bold**")
  expect_equal(result$entities, list())
})

# --- unparse: strike and url ---

test_that("unparse produces ~~...~~ for MessageEntityStrike", {
  skip_on_cran()
  result <- unparse("hello", list(list(type = "MessageEntityStrike", offset = 0L, length = 5L)))
  expect_equal(result, "~~hello~~")
})

test_that("unparse returns plain text when no entities", {
  skip_on_cran()
  expect_equal(unparse("plain", list()), "plain")
})

test_that("unparse returns text unchanged when NULL entities length is 0", {
  skip_on_cran()
  expect_equal(unparse("x", list()), "x")
})

# --- add_surrogate / del_surrogate ---

test_that("add_surrogate is idempotent for ASCII", {
  skip_on_cran()
  expect_equal(add_surrogate("hello"), "hello")
})

test_that("del_surrogate returns character", {
  skip_on_cran()
  result <- del_surrogate("hello")
  expect_type(result, "character")
})

test_that("add_surrogate handles emoji without error", {
  skip_on_cran()
  emoji_str <- intToUtf8(0x1F600)  # 😀
  result <- add_surrogate(emoji_str)
  expect_type(result, "character")
  expect_length(result, 1L)
})

# --- make_entity (markdown version) ---

test_that("make_entity sets class and fields", {
  skip_on_cran()
  e <- make_entity("MessageEntityBold", 3L, 5L)
  expect_equal(class(e), "MessageEntityBold")
  expect_equal(e$offset, 3L)
  expect_equal(e$length, 5L)
  expect_equal(e$type, "MessageEntityBold")
})

test_that("make_entity passes extra fields", {
  skip_on_cran()
  e <- make_entity("MessageEntityTextUrl", 0L, 4L, url = "https://x.com")
  expect_equal(e$url, "https://x.com")
})

# --- DEFAULT_DELIMITERS ---

test_that("DEFAULT_DELIMITERS contains expected keys", {
  skip_on_cran()
  expect_true("**" %in% names(DEFAULT_DELIMITERS))
  expect_true("__" %in% names(DEFAULT_DELIMITERS))
  expect_true("~~" %in% names(DEFAULT_DELIMITERS))
  expect_true("`" %in% names(DEFAULT_DELIMITERS))
  expect_true("```" %in% names(DEFAULT_DELIMITERS))
})
