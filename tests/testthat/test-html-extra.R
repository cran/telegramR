# Extra HTML coverage: more entity types, escape_html, make_entity,
# unparse_telegram_to_html branches.

# --- escape_html ---

test_that("escape_html replaces & < > and double quote", {
  skip_on_cran()
  expect_equal(escape_html("a & b"), "a &amp; b")
  expect_equal(escape_html("<tag>"), "&lt;tag&gt;")
  expect_equal(escape_html('"quoted"'), "&quot;quoted&quot;")
  expect_equal(escape_html("plain"), "plain")
})

# --- parse_html_to_telegram: more entity types ---

test_that("parses <u> underline", {
  skip_on_cran()
  r <- parse_html_to_telegram("<u>under</u>")
  expect_equal(r$text, "under")
  expect_equal(r$entities[[1]]$type, "underline")
  expect_equal(r$entities[[1]]$length, 5L)
})

test_that("parses <s> and <del> as strike", {
  skip_on_cran()
  r1 <- parse_html_to_telegram("<s>strike</s>")
  expect_equal(r1$entities[[1]]$type, "strike")

  r2 <- parse_html_to_telegram("<del>del</del>")
  expect_equal(r2$entities[[1]]$type, "strike")
})

test_that("parses <blockquote> as blockquote", {
  skip_on_cran()
  r <- parse_html_to_telegram("<blockquote>quote</blockquote>")
  expect_equal(r$entities[[1]]$type, "blockquote")
  expect_equal(r$text, "quote")
})

test_that("parses <code> as code entity", {
  skip_on_cran()
  r <- parse_html_to_telegram("before <code>fn()</code> after")
  code_ents <- Filter(function(e) e$type == "code", r$entities)
  expect_equal(length(code_ents), 1L)
  expect_equal(code_ents[[1]]$length, 4L)
})

test_that("parses <pre> as pre entity", {
  skip_on_cran()
  r <- parse_html_to_telegram("<pre>block</pre>")
  pre_ents <- Filter(function(e) e$type == "pre", r$entities)
  expect_equal(length(pre_ents), 1L)
})

test_that("parses <pre><code class='language-r'> and stores language", {
  skip_on_cran()
  r <- parse_html_to_telegram("<pre><code class='language-r'>x <- 1</code></pre>")
  pre_ents <- Filter(function(e) e$type == "pre", r$entities)
  expect_equal(length(pre_ents), 1L)
  # language field should be 'r'
  expect_equal(pre_ents[[1]]$language, "r")
})

test_that("parses <tg-emoji> as custom_emoji entity", {
  skip_on_cran()
  r <- parse_html_to_telegram('<tg-emoji emoji-id="12345">😀</tg-emoji>')
  ce <- Filter(function(e) e$type == "custom_emoji", r$entities)
  expect_equal(length(ce), 1L)
  expect_equal(ce[[1]]$document_id, 12345L)
})

# --- unparse_telegram_to_html: more entity types ---

test_that("unparse underline produces <u> tags", {
  skip_on_cran()
  result <- unparse_telegram_to_html("hello", list(list(type = "underline", offset = 0L, length = 5L)))
  expect_true(grepl("<u>hello</u>", result))
})

test_that("unparse strike produces <del> tags", {
  skip_on_cran()
  result <- unparse_telegram_to_html("gone", list(list(type = "strike", offset = 0L, length = 4L)))
  expect_true(grepl("<del>gone</del>", result))
})

test_that("unparse blockquote produces <blockquote> tags", {
  skip_on_cran()
  result <- unparse_telegram_to_html("cited", list(list(type = "blockquote", offset = 0L, length = 5L)))
  expect_true(grepl("<blockquote>cited</blockquote>", result))
})

test_that("unparse code produces <code> tags", {
  skip_on_cran()
  result <- unparse_telegram_to_html("fn()", list(list(type = "code", offset = 0L, length = 4L)))
  expect_true(grepl("<code>fn\\(\\)</code>", result))
})

test_that("unparse text_url produces <a> tag with href", {
  skip_on_cran()
  result <- unparse_telegram_to_html(
    "click",
    list(list(type = "text_url", offset = 0L, length = 5L, url = "https://example.com"))
  )
  expect_true(grepl('href="https://example.com"', result))
  expect_true(grepl(">click</a>", result))
})

test_that("unparse url produces <a> tag from text content", {
  skip_on_cran()
  result <- unparse_telegram_to_html(
    "https://x.com",
    list(list(type = "url", offset = 0L, length = 13L))
  )
  expect_true(grepl("<a href=", result))
})

test_that("unparse custom_emoji produces <tg-emoji> tag", {
  skip_on_cran()
  result <- unparse_telegram_to_html(
    "😀",
    list(list(type = "custom_emoji", offset = 0L, length = 1L, document_id = 9876L))
  )
  expect_true(grepl('tg-emoji emoji-id="9876"', result))
})

test_that("unparse with no entities just escapes HTML", {
  skip_on_cran()
  result <- unparse_telegram_to_html("a < b", list())
  expect_equal(result, "a &lt; b")
})

test_that("unparse with NULL text returns NULL", {
  skip_on_cran()
  result <- unparse_telegram_to_html(NULL, list())
  expect_null(result)
})

test_that("unparse with empty text returns empty string", {
  skip_on_cran()
  result <- unparse_telegram_to_html("", list())
  expect_equal(result, "")
})
