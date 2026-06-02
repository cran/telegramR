MockTLObject <- R6::R6Class("MockTLObject",
  inherit = TLObject,
  public = list(
    to_bytes = function() as.raw(c(1, 2, 3, 4)),
    to_list = function() list("_" = "MockTLObject")
  )
)

test_that("AcceptTermsOfServiceRequest works correctly", {
  skip_on_cran()
  id <- MockTLObject$new()
  req <- AcceptTermsOfServiceRequest$new(id = id)
  
  expect_s3_class(req, "AcceptTermsOfServiceRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "AcceptTermsOfServiceRequest")
  expect_equal(lst[["id"]], list("_" = "MockTLObject"))

  bytes <- req$to_bytes()
  expect_true(is.raw(bytes))
  
  # constructor id: 0xee72f79a -> 9a f7 72 ee
  expect_equal(bytes[1:4], as.raw(c(0x9a, 0xf7, 0x72, 0xee)))
  expect_equal(bytes[5:8], as.raw(c(1, 2, 3, 4)))
})

test_that("DismissSuggestionRequest works correctly", {
  skip_on_cran()
  peer <- MockTLObject$new()
  req <- DismissSuggestionRequest$new(peer = peer, suggestion = "test_suggestion")
  
  expect_s3_class(req, "DismissSuggestionRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "DismissSuggestionRequest")
  expect_equal(lst[["suggestion"]], "test_suggestion")

  bytes <- req$to_bytes()
  expect_true(is.raw(bytes))
  
  # constructor id: 0xf50dbaa1 -> a1 ba 0d f5
  expect_equal(bytes[1:4], as.raw(c(0xa1, 0xba, 0x0d, 0xf5)))
})

test_that("GetAppConfigRequest works correctly", {
  skip_on_cran()
  req <- GetAppConfigRequest$new(hash = 123L)
  
  expect_s3_class(req, "GetAppConfigRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "GetAppConfigRequest")
  expect_equal(lst[["hash"]], 123L)

  bytes <- req$to_bytes()
  expect_true(is.raw(bytes))
  
  # constructor id: 0x61e3f854 -> 54 f8 e3 61
  expect_equal(bytes[1:4], as.raw(c(0x54, 0xf8, 0xe3, 0x61)))
})
