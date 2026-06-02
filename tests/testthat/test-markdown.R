test_that("parses text with bold and italic delimiters", {
  skip_on_cran()
  message <- "This is **bold** and __italic__ text."
  result <- parse(message)

  expect_equal(result$message, "This is bold and italic text.")
  expect_equal(length(result$entities), 2)
  expect_equal(result$entities[[1]]$type, "MessageEntityBold")
  expect_equal(result$entities[[1]]$offset, 8)
  expect_equal(result$entities[[1]]$length, 4)
  expect_equal(result$entities[[2]]$type, "MessageEntityItalic")
  expect_equal(result$entities[[2]]$offset, 17)
  expect_equal(result$entities[[2]]$length, 6)
})

test_that("parses text with code and preformatted blocks", {
  skip_on_cran()
  message <- "Inline `code` and ```preformatted``` blocks."
  result <- parse(message)

  expect_equal(result$message, "Inline code and preformatted blocks.")
  expect_equal(length(result$entities), 2)
  expect_equal(result$entities[[1]]$type, "MessageEntityCode")
  expect_equal(result$entities[[1]]$offset, 7)
  expect_equal(result$entities[[1]]$length, 4)
  expect_equal(result$entities[[2]]$type, "MessageEntityPre")
  expect_equal(result$entities[[2]]$offset, 16)
  expect_equal(result$entities[[2]]$length, 11)
})

test_that("parses text with inline urls", {
  skip_on_cran()
  message <- "Visit [example](https://example.com) for details."
  result <- parse(message)

  expect_equal(result$message, "Visit example for details.")
  expect_equal(length(result$entities), 1)
  expect_equal(result$entities[[1]]$type, "MessageEntityTextUrl")
  expect_equal(result$entities[[1]]$offset, 6)
  expect_equal(result$entities[[1]]$length, 7)
  expect_equal(result$entities[[1]]$url, "https://example.com")
})

test_that("handles empty message input", {
  skip_on_cran()
  message <- ""
  result <- parse(message)

  expect_equal(result$message, "")
  expect_equal(result$entities, list())
})

test_that("handles message with no delimiters", {
  skip_on_cran()
  message <- "Plain text with no formatting."
  result <- parse(message)

  expect_equal(result$message, "Plain text with no formatting.")
  expect_equal(result$entities, list())
})

test_that("unparses text with bold and italic entities", {
  skip_on_cran()
  text <- "This is bold and italic text."
  entities <- list(
    list(type = "MessageEntityBold", offset = 8, length = 4),
    list(type = "MessageEntityItalic", offset = 17, length = 6)
  )
  result <- unparse(text, entities)

  expect_equal(result, "This is **bold** and __italic__ text.")
})

test_that("unparses text with code and preformatted entities", {
  skip_on_cran()
  text <- "Inline code and preformatted blocks."
  entities <- list(
    list(type = "MessageEntityCode", offset = 7, length = 4),
    list(type = "MessageEntityPre", offset = 16, length = 11)
  )
  result <- unparse(text, entities)

  expect_equal(result, "Inline `code` and ```preformatted``` blocks.")
})

test_that("unparses text with inline urls", {
  skip_on_cran()
  text <- "Visit example for details."
  entities <- list(
    list(type = "MessageEntityTextUrl", offset = 6, length = 7, url = "https://example.com")
  )
  result <- unparse(text, entities)

  expect_equal(result, "Visit [example](https://example.com) for details.")
})
