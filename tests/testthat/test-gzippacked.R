test_that("initialize sets data correctly", {
  skip_on_cran()
  obj <- GzipPacked$new(data = raw(0))
  expect_equal(obj$data, raw(0))
})

test_that("gzip_if_smaller compresses data if smaller", {
  skip_on_cran()
  obj <- GzipPacked$new(data = raw(0))
  data <- charToRaw(paste(rep("a", 600), collapse = ""))
  compressed <- obj$gzip_if_smaller(TRUE, data)
  expect_true(length(compressed) < length(data))
})

test_that("gzip_if_smaller does not compress if not content related", {
  skip_on_cran()
  obj <- GzipPacked$new(data = raw(0))
  data <- charToRaw(paste(rep("a", 600), collapse = ""))
  result <- obj$gzip_if_smaller(FALSE, data)
  expect_equal(result, data)
})

test_that("to_bytes serializes correctly", {
  skip_on_cran()
  obj <- GzipPacked$new(data = charToRaw("test"))
  bytes <- obj$to_bytes()
  expect_true(length(bytes) > 0)
})

test_that("read decompresses data correctly", {
  skip_on_cran()
  reader <- list(
    read_int = function(signed) 0x3072cfa1,
    tgread_bytes = function() memCompress(charToRaw("test"), type = "gzip")
  )
  obj <- GzipPacked$new(data = raw(0))
  decompressed <- obj$read(reader)
  expect_equal(rawToChar(decompressed), "test")
})

test_that("from_reader creates object correctly", {
  skip_on_cran()
  reader <- list(
    tgread_bytes = function() memCompress(charToRaw("test"), type = "gzip")
  )
  obj <- GzipPacked$new(NULL)$from_reader(reader)
  expect_equal(rawToChar(obj$data), "test")
})

test_that("to_dict converts object to dictionary", {
  skip_on_cran()
  obj <- GzipPacked$new(data = charToRaw("test"))
  dict <- obj$to_dict()
  expect_equal(dict$`_`, "GzipPacked")
  expect_equal(rawToChar(dict$data), "test")
})
