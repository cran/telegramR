# Extra branch coverage for tlobject.R: serialize_bytes, serialize_datetime,
# pretty_format, TLObject/TLRequest methods.

# --- serialize_bytes: long format (>= 254 bytes) ---

test_that("serialize_bytes long format uses 4-byte header for 300-byte input", {
  skip_on_cran()
  data <- as.raw(rep(0xAB, 300))
  result <- serialize_bytes(data)
  # First byte must be 0xFE (254) to signal long format
  expect_equal(as.integer(result[[1]]), 254L)
  # Next 3 bytes encode length 300 little-endian: 300 = 0x12C → 0x2C, 0x01, 0x00
  expect_equal(as.integer(result[[2]]), 300L %% 256L)
  expect_equal(as.integer(result[[3]]), (300L %/% 256L) %% 256L)
  expect_equal(as.integer(result[[4]]), 0L)
  # Total length is 4 (header) + 300 (data) + padding to multiple of 4
  padding <- if (300 %% 4 == 0) 0L else 4L - (300L %% 4L)
  expect_equal(length(result), 4L + 300L + padding)
})

test_that("serialize_bytes exactly 254 bytes uses long format", {
  skip_on_cran()
  data <- as.raw(rep(0x01, 254))
  result <- serialize_bytes(data)
  expect_equal(as.integer(result[[1]]), 254L)
})

test_that("serialize_bytes accepts character string", {
  skip_on_cran()
  result <- serialize_bytes("hello")
  expect_type(result, "raw")
  expect_gt(length(result), 0L)
})

test_that("serialize_bytes rejects non-string non-raw", {
  skip_on_cran()
  expect_error(serialize_bytes(42L), "bytes or str expected")
})

# --- serialize_datetime: branches ---

test_that("serialize_datetime accepts Date object", {
  skip_on_cran()
  d <- as.Date("2023-06-15")
  result <- serialize_datetime(d)
  expect_type(result, "raw")
  expect_equal(length(result), 4L)
})

test_that("serialize_datetime accepts numeric (unix timestamp)", {
  skip_on_cran()
  result <- serialize_datetime(1700000000)
  expect_type(result, "raw")
  expect_equal(length(result), 4L)
})

test_that("serialize_datetime returns 4 zero bytes for NULL", {
  skip_on_cran()
  result <- serialize_datetime(NULL)
  expect_equal(result, as.raw(rep(0, 4)))
})

test_that("serialize_datetime errors for unsupported type", {
  skip_on_cran()
  expect_error(serialize_datetime(list(x = 1)), "Cannot interpret")
})

# --- pretty_format: standalone function (not method) ---

test_that("pretty_format handles raw input", {
  skip_on_cran()
  b <- as.raw(c(0x41, 0x42))
  result <- pretty_format(b)
  expect_type(result, "raw")  # raw is returned unchanged
})

test_that("pretty_format handles character input", {
  skip_on_cran()
  result <- pretty_format("hello")
  expect_equal(result, "hello")
})

test_that("pretty_format handles single numeric", {
  skip_on_cran()
  result <- pretty_format(42)
  expect_equal(result, "42")
})

test_that("pretty_format handles numeric vector", {
  skip_on_cran()
  result <- pretty_format(c(1, 2, 3))
  expect_equal(result, "[1, 2, 3]")
})

test_that("pretty_format handles nested list", {
  skip_on_cran()
  result <- pretty_format(list(a = 1, b = list(c = 2)))
  expect_true(grepl("a=1", result))
  expect_true(grepl("b=", result))
})

# --- TLObject method coverage ---

test_that("TLObject pretty_format method with indent=0 on a named list", {
  skip_on_cran()
  obj <- TLObject$new()
  # Only test named-list path; bare-vector path has infinite recursion (known source bug)
  result <- obj$pretty_format(list(x = "a", y = "b"), indent = 0L)
  expect_type(result, "character")
  expect_true(grepl("x=a", result))
})

test_that("TLObject pretty_format method with indent on character", {
  skip_on_cran()
  obj <- TLObject$new()
  # character scalars terminate without recursion
  result <- obj$pretty_format("hi", indent = 0L)
  expect_equal(result, "hi")
})

test_that("TLObject pretty_format method with indent on empty list", {
  skip_on_cran()
  obj <- TLObject$new()
  result <- obj$pretty_format(list(), indent = 0L)
  expect_type(result, "character")
})

# --- json_default ---

test_that("json_default handles list/other by as.character", {
  skip_on_cran()
  expect_equal(json_default(TRUE), "TRUE")
  expect_equal(json_default(3.14), "3.14")
})
