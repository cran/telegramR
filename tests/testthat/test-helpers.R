test_that("EntityType constants are defined", {
  skip_on_cran()
  expect_equal(EntityType$USER, 0)
  expect_equal(EntityType$CHAT, 1)
  expect_equal(EntityType$CHANNEL, 2)
})

test_that("logg prints formatted message", {
  skip_on_cran()
  out <- capture.output(logg("num: %d", 7))
  expect_equal(out, "num: 7")
})

test_that("generate_random_long returns numeric scalar and unsigned is non-negative", {
  skip_on_cran()
  rl <- generate_random_long()
  expect_type(rl, "double")
  expect_length(rl, 1)
  # range check for signed 64-bit
  expect_true(rl >= -(2^63) && rl <= (2^63 - 1))

  rlu <- generate_random_long(signed = FALSE)
  expect_type(rlu, "double")
  expect_length(rlu, 1)
  expect_gte(rlu, 0)
})

test_that("ensure_parent_dir_exists creates parent directories", {
  skip_on_cran()
  td <- tempdir()
  nested <- file.path(td, "test_dir_for_helpers", "sub1", "sub2", "file.txt")
  parent <- dirname(nested)
  if (dir.exists(parent)) unlink(parent, recursive = TRUE, force = TRUE)
  ensure_parent_dir_exists(nested)
  expect_true(dir.exists(parent))
  unlink(file.path(td, "test_dir_for_helpers"), recursive = TRUE, force = TRUE)
})

test_that("add_surrogate and del_surrogate return expected types", {
  skip_on_cran()
  txt <- paste0("Hello ", intToUtf8(0x1F600), " World") # 😀
  a <- add_surrogate(txt)
  expect_type(a, "character")
  expect_length(a, 1)

  d <- del_surrogate(txt)
  expect_type(d, "character")
  expect_true(length(d) >= 1)
})

test_that("strip_text trims text even when entities provided", {
  skip_on_cran()
  expect_equal(strip_text("  abc  ", list()), "abc")

  ents <- list(list(offset = 1, length = 2))
  expect_equal(strip_text("  abc  ", ents), "abc")
})

test_that("TotalList to_string produces expected representation", {
  skip_on_cran()
  tl <- TotalList$new(items = list(1, "a", TRUE))
  tl$total <- 3
  expect_equal(tl$to_string(), "[1, a, TRUE, total=3]")
})

test_that("FileStream works with raw vectors", {
  skip_on_cran()
  rawv <- as.raw(1:10)
  fs <- FileStream$new(rawv)
  on.exit(fs$close(), add = TRUE)
  expect_equal(fs$get_file_size(), length(rawv))
  dat <- fs$read()
  expect_type(dat, "raw")
  expect_equal(dat, rawv)
  # raw-backed stream has no name set
  expect_null(fs$get_name())
})
