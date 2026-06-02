MockTLObject <- R6::R6Class("MockTLObject",
  inherit = TLObject,
  public = list(
    to_bytes = function() as.raw(c(1, 2, 3, 4)),
    to_list = function() list("_" = "MockTLObject")
  )
)

test_that("GetBroadcastStatsRequest works correctly", {
  skip_on_cran()
  channel <- MockTLObject$new()
  req <- GetBroadcastStatsRequest$new(channel = channel, dark = TRUE)
  
  expect_s3_class(req, "GetBroadcastStatsRequest")
  # Let's check inheritance.
  expect_true(inherits(req, "GetBroadcastStatsRequest"))
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "GetBroadcastStatsRequest")
  expect_true(lst[["dark"]])

  # bytes verification
  bytes_out <- req$to_bytes()
  # constructor: 0xab42441a -> 1a 44 42 ab
  expect_equal(bytes_out[1:4], as.raw(c(0x1a, 0x44, 0x42, 0xab)))
  # flags: dark=TRUE -> 1 -> 01 00 00 00
  expect_equal(bytes_out[5:8], as.raw(c(0x01, 0x00, 0x00, 0x00)))
})

test_that("GetMessagePublicForwardsRequest works correctly", {
  skip_on_cran()
  channel <- MockTLObject$new()
  req <- GetMessagePublicForwardsRequest$new(channel = channel, msg_id = 123L, offset = "off", limit = 10L)
  
  expect_true(inherits(req, "GetMessagePublicForwardsRequest"))
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "GetMessagePublicForwardsRequest")
  expect_equal(lst[["msg_id"]], 123L)
  expect_equal(lst[["offset"]], "off")
  expect_equal(lst[["limit"]], 10L)

  # bytes verification
  bytes_out <- req$to_bytes()
  # constructor: 0x5f150144 -> 44 01 15 5f
  expect_equal(bytes_out[1:4], as.raw(c(0x44, 0x01, 0x15, 0x5f)))
})

test_that("GetMessageStatsRequest works correctly", {
  skip_on_cran()
  channel <- MockTLObject$new()
  req <- GetMessageStatsRequest$new(channel = channel, msg_id = 456L, dark = FALSE)
  
  expect_true(inherits(req, "GetMessageStatsRequest"))
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "GetMessageStatsRequest")
  expect_equal(lst[["msg_id"]], 456L)
  expect_false(lst[["dark"]])

  # bytes verification
  bytes_out <- req$to_bytes()
  # constructor: 0xb6e0a3f5 -> f5 a3 e0 b6
  expect_equal(bytes_out[1:4], as.raw(c(0xf5, 0xa3, 0xe0, 0xb6)))
  # flags: dark=FALSE -> 0 -> 00 00 00 00
  expect_equal(bytes_out[5:8], as.raw(c(0x00, 0x00, 0x00, 0x00)))
})
