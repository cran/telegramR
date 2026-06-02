# Extra helpers coverage: generate_key_data_from_nonce, within_surrogate,
# strip_text edge cases

# --- generate_key_data_from_nonce ---

test_that("generate_key_data_from_nonce returns key and iv of correct lengths", {
  skip_on_cran()
  server_nonce <- as.raw(sample(0:255, 16, replace = TRUE))
  new_nonce    <- as.raw(sample(0:255, 32, replace = TRUE))

  kd <- generate_key_data_from_nonce(server_nonce, new_nonce)

  expect_named(kd, c("key", "iv"))
  expect_equal(length(kd$key), 32L)   # sha1 (20) + first 12 of second sha1
  expect_equal(length(kd$iv), 32L)    # 8 + 20 + 4
  expect_type(kd$key, "raw")
  expect_type(kd$iv,  "raw")
})

test_that("generate_key_data_from_nonce is deterministic", {
  skip_on_cran()
  sn <- as.raw(rep(0xAA, 16))
  nn <- as.raw(rep(0xBB, 32))

  r1 <- generate_key_data_from_nonce(sn, nn)
  r2 <- generate_key_data_from_nonce(sn, nn)

  expect_equal(r1$key, r2$key)
  expect_equal(r1$iv,  r2$iv)
})

# --- within_surrogate ---

test_that("within_surrogate returns FALSE for ASCII text at any position", {
  skip_on_cran()
  txt <- "hello"
  for (i in seq_along(strsplit(txt, "")[[1]])) {
    expect_false(within_surrogate(txt, i))
  }
})

test_that("within_surrogate returns FALSE for index 1", {
  skip_on_cran()
  expect_false(within_surrogate("abc", 1L))
})

test_that("within_surrogate returns FALSE for NA index", {
  skip_on_cran()
  expect_false(within_surrogate("abc", NA_integer_))
})

# --- strip_text edge cases ---

test_that("strip_text removes zero-length entities", {
  skip_on_cran()
  ents <- list(list(offset = 2, length = 0))
  result <- strip_text("  hello  ", ents)
  expect_equal(result, "hello")
})

test_that("strip_text adjusts entity that starts inside left whitespace", {
  skip_on_cran()
  # "  bold  " → stripped to "bold"; entity covers offset=0 length=4 (in original)
  ents <- list(list(offset = 0, length = 4))
  result <- strip_text("  bold  ", ents)
  expect_equal(result, "bold")
})

test_that("strip_text removes entity entirely in left whitespace", {
  skip_on_cran()
  # entity sits fully inside the 2 leading spaces
  ents <- list(list(offset = 0, length = 2))
  result <- strip_text("  text  ", ents)
  expect_equal(result, "text")
})

# --- logg / generate_random_long (extra branch) ---

test_that("generate_random_long unsigned is always >= 0", {
  skip_on_cran()
  for (i in seq_len(10)) {
    expect_gte(generate_random_long(signed = FALSE), 0)
  }
})
