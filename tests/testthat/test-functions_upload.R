test_that("GetCdnFileRequest to_list and to_bytes with character token", {
  skip_on_cran()
  req <- GetCdnFileRequest$new("abc", 123, 10)
  lst <- req$to_list()
  expect_equal(lst$`_`, "GetCdnFileRequest")
  expect_equal(lst$file_token, "abc")
  expect_equal(lst$offset, 123)
  expect_equal(lst$limit, 10L)

  b <- req$to_bytes()
  expect_true(is.raw(b))
  expect_equal(b[1:4], as.raw(c(0xda, 0x69, 0x5f, 0x39)))
})


test_that("GetCdnFileRequest numeric token serializes as single byte with length prefix", {
  skip_on_cran()
  req <- GetCdnFileRequest$new(257, 1, 2)
  b <- req$to_bytes()
  # constructor id (4 bytes) then serialized bytes length (4 bytes little-endian)
  expect_equal(as.integer(b[5:8]), c(1L, 0L, 0L, 0L))
  # the byte value is 257 %% 256 == 1
  expect_equal(b[9], as.raw(1))
})


test_that("GetCdnFileRequest to_bytes errors on unsupported token type", {
  skip_on_cran()
  req <- GetCdnFileRequest$new(list(a = 1), 0, 0)
  expect_error(req$to_bytes())
})


test_that("SaveFilePartRequest serializes bytes_data correctly", {
  skip_on_cran()
  req <- SaveFilePartRequest$new(12345, 0, "hi")
  lst <- req$to_list()
  expect_equal(lst$`_`, "SaveFilePartRequest")
  expect_equal(lst$file_id, 12345)
  expect_equal(lst$file_part, 0L)
  expect_equal(lst$bytes, "hi")

  b <- req$to_bytes()
  expect_equal(b[1:4], as.raw(c(0x21, 0xa6, 0x04, 0xb3)))
  # constructor(4) + file_id(8) + file_part(4) => serialized bytes start at byte 17
  expect_equal(as.integer(b[17:20]), c(2L, 0L, 0L, 0L))
  expect_equal(b[21:22], charToRaw("hi"))
})


test_that("GetFileRequest to_bytes uses flags and embeds location bytes; errors when location missing", {
  skip_on_cran()
  DummyLoc <- R6::R6Class("DummyLoc", public = list(
    to_bytes = function() as.raw(c(0xAA)),
    to_list = function() list(`_` = "DummyLoc")
  ))

  loc <- DummyLoc$new()
  req <- GetFileRequest$new(loc, 1, 2, precise = TRUE, cdn_supported = FALSE)
  b <- req$to_bytes()
  # constructor id
  expect_equal(b[1:4], as.raw(c(0xbe, 0x35, 0x53, 0xbe)))
  # flags (precise set -> 1)
  expect_equal(as.integer(b[5:8]), c(1L, 0L, 0L, 0L))
  # location bytes should appear immediately after flags
  expect_equal(b[9], as.raw(0xAA))

  # if location is not an R6 object with to_bytes(), to_bytes() should error
  bad <- GetFileRequest$new("not-an-r6", 0, 1)
  expect_error(bad$to_bytes(), "location must be an R6 TLObject-like with to_bytes()")
})
