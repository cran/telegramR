MockTLObject <- R6::R6Class("MockTLObject",
  inherit = TLObject,
  public = list(
    bytes = function() as.raw(c(1, 2, 3, 4)),
    to_list = function() list("_" = "MockTLObject")
  )
)

test_that("ApplyBoostRequest works correctly", {
  skip_on_cran()
  peer <- MockTLObject$new()
  req <- ApplyBoostRequest$new(peer = peer, slots = list(1L))
  
  expect_s3_class(req, "ApplyBoostRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "ApplyBoostRequest")
  expect_equal(lst[["slots"]], 1L)

  # bytes verification
  bytes_out <- req$bytes()
  # constructor: 0x6b7da746 -> 46 a7 7d 6b
  expect_equal(bytes_out[1:4], as.raw(c(0x46, 0xa7, 0x7d, 0x6b)))
})

test_that("GetBoostsListRequest works correctly", {
  skip_on_cran()
  peer <- MockTLObject$new()
  req <- GetBoostsListRequest$new(peer = peer, offset = "abc", limit = 10L)
  
  expect_s3_class(req, "GetBoostsListRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "GetBoostsListRequest")
  expect_equal(lst[["offset"]], "abc")
  expect_equal(lst[["limit"]], 10L)

  # bytes verification
  bytes_out <- req$bytes()
  # constructor: 0x60f67660 -> 60 76 f6 60
  expect_equal(bytes_out[1:4], as.raw(c(0x60, 0x76, 0xf6, 0x60)))
})

test_that("GetBoostsStatusRequest works correctly", {
  skip_on_cran()
  peer <- MockTLObject$new()
  req <- GetBoostsStatusRequest$new(peer = peer)
  
  expect_s3_class(req, "GetBoostsStatusRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "GetBoostsStatusRequest")

  # bytes verification
  bytes_out <- req$bytes()
  # constructor: 0x061f2f04 -> 04 2f 1f 06 (wait, outline said b'a\x1f/\x04' -> 61 1f 2f 04)
  # Let's check the outline again: 0x061f2f04 is mentioned, but bytes b'a\x1f/\x04' -> 0x61 0x1f 0x2f 0x04.
  # Let's re-read the file to be sure.
  expect_equal(bytes_out[1:4], as.raw(c(0x61, 0x1f, 0x2f, 0x04)))
})
