MockTLObject <- R6::R6Class("MockTLObject",
  inherit = TLObject,
  public = list(
    bytes = function() as.raw(c(1, 2, 3, 4)),
    to_list = function() list("_" = "MockTLObject")
  )
)

test_that("AcceptCallRequest works correctly", {
  skip_on_cran()
  peer <- MockTLObject$new()
  protocol <- MockTLObject$new()
  g_b <- as.raw(c(0x11, 0x22))
  req <- AcceptCallRequest$new(peer = peer, g_b = g_b, protocol = protocol)
  
  expect_s3_class(req, "AcceptCallRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "AcceptCallRequest")
  expect_equal(lst[["g_b"]], g_b)

  # bytes verification
  bytes_out <- req$bytes()
  # constructor: 0x3bd2b4a0 -> a0 b4 d2 3b
  expect_equal(bytes_out[1:4], as.raw(c(0xa0, 0xb4, 0xd2, 0x3b)))
})

test_that("CheckGroupCallRequest works correctly", {
  skip_on_cran()
  call <- MockTLObject$new()
  sources <- list(1, 2, 3)
  req <- CheckGroupCallRequest$new(call = call, sources = sources)
  
  expect_s3_class(req, "CheckGroupCallRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "CheckGroupCallRequest")
  expect_equal(lst[["sources"]], sources)

  # bytes verification
  bytes_out <- req$bytes()
  # constructor: 0xb59cf977 -> 77 f9 9c b5
  expect_equal(bytes_out[1:4], as.raw(c(0x77, 0xf9, 0x9c, 0xb5)))
})

test_that("ConfirmCallRequest works correctly", {
  skip_on_cran()
  peer <- MockTLObject$new()
  protocol <- MockTLObject$new()
  g_a <- as.raw(c(0x33, 0x44))
  req <- ConfirmCallRequest$new(peer = peer, g_a = g_a, key_fingerprint = 12345, protocol = protocol)
  
  expect_s3_class(req, "ConfirmCallRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "ConfirmCallRequest")
  expect_equal(lst[["g_a"]], g_a)
  expect_equal(lst[["key_fingerprint"]], 12345L)

  # bytes verification
  bytes_out <- req$bytes()
  # constructor: 0x2efe1722 -> 22 17 fe 2e
  expect_equal(bytes_out[1:4], as.raw(c(0x22, 0x17, 0xfe, 0x2e)))
})
