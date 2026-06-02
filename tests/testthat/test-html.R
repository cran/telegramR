test_that("parses simple html to plain text and entities", {
  skip_on_cran()
  html <- "<b>bold</b> and <i>italic</i>"
  result <- parse_html_to_telegram(html)

  expect_equal(result$text, "bold and italic")
  expect_equal(length(result$entities), 2)
  expect_equal(result$entities[[1]]$type, "bold")
  expect_equal(result$entities[[1]]$offset, 0)
  expect_equal(result$entities[[1]]$length, 4)
  expect_equal(result$entities[[2]]$type, "italic")
  expect_equal(result$entities[[2]]$offset, 9)
  expect_equal(result$entities[[2]]$length, 6)
})

test_that("handles empty html input", {
  skip_on_cran()
  html <- ""
  result <- parse_html_to_telegram(html)

  expect_equal(result$text, "")
  expect_equal(result$entities, list())
})

test_that("parses nested html tags correctly", {
  skip_on_cran()
  html <- "<b>bold <i>and italic</i></b>"
  result <- parse_html_to_telegram(html)

  expect_equal(result$text, "bold and italic")
  expect_equal(length(result$entities), 2)
  expect_equal(result$entities[[1]]$type, "bold")
  expect_equal(result$entities[[1]]$offset, 0)
  expect_equal(result$entities[[1]]$length, 14)
  expect_equal(result$entities[[2]]$type, "italic")
  expect_equal(result$entities[[2]]$offset, 5)
  expect_equal(result$entities[[2]]$length, 9)
})

test_that("parses links and emails correctly", {
  skip_on_cran()
  html <- "<a href='https://example.com'>example</a> and <a href='mailto:test@example.com'>email</a>"
  result <- parse_html_to_telegram(html)

  expect_equal(result$text, "example and email")
  expect_equal(length(result$entities), 2)
  expect_equal(result$entities[[1]]$type, "text_url")
  expect_equal(result$entities[[1]]$offset, 0)
  expect_equal(result$entities[[1]]$length, 7)
  expect_equal(result$entities[[1]]$url, "https://example.com")
  expect_equal(result$entities[[2]]$type, "email")
  expect_equal(result$entities[[2]]$offset, 12)
  expect_equal(result$entities[[2]]$length, 5)
  expect_equal(result$entities[[2]]$url, "test@example.com")
})

test_that("unparses plain text and entities to html", {
  skip_on_cran()
  text <- "bold and italic"
  entities <- list(
    list(type = "bold", offset = 0, length = 4),
    list(type = "italic", offset = 9, length = 6)
  )
  result <- unparse_telegram_to_html(text, entities)

  expect_equal(result, "<strong>bold</strong> and <em>italic</em>")
})

test_that("handles unparsing with no entities", {
  skip_on_cran()
  text <- "plain text"
  entities <- list()
  result <- unparse_telegram_to_html(text, entities)

  expect_equal(result, "plain text")
})

test_that("handles unparsing with special characters", {
  skip_on_cran()
  text <- "text with < and >"
  entities <- list(
    list(type = "bold", offset = 0, length = 4)
  )
  result <- unparse_telegram_to_html(text, entities)

  expect_equal(result, "<strong>text</strong> with &lt; and &gt;")
})
