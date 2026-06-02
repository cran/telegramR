MockTLObject <- R6::R6Class("MockTLObject",
  inherit = TLObject,
  public = list(
    bytes = function() as.raw(c(1, 2, 3, 4)),
    to_dict = function() list("_" = "MockTLObject")
  )
)

test_that("AssignAppStoreTransactionRequest works correctly", {
  skip_on_cran()
  purpose <- MockTLObject$new()
  receipt <- as.raw(c(0x10, 0x20))
  req <- AssignAppStoreTransactionRequest$new(receipt = receipt, purpose = purpose)
  
  expect_s3_class(req, "AssignAppStoreTransactionRequest")
  
  dict <- req$to_dict()
  expect_equal(dict[["_"]], "AssignAppStoreTransactionRequest")
  expect_equal(dict[["receipt"]], receipt)
  expect_equal(dict[["purpose"]], list("_" = "MockTLObject"))

  bytes_out <- req$bytes()
  # constructor: 0x80ed747d -> 7d 74 ed 80
  expect_equal(bytes_out[1:4], as.raw(c(0x7d, 0x74, 0xed, 0x80)))
})

test_that("BotCancelStarsSubscriptionRequest works correctly", {
  skip_on_cran()
  user_id <- MockTLObject$new()
  req <- BotCancelStarsSubscriptionRequest$new(
    user_id = user_id,
    charge_id = "charge_123",
    restore = TRUE
  )
  
  expect_s3_class(req, "BotCancelStarsSubscriptionRequest")
  
  dict <- req$to_dict()
  expect_equal(dict[["charge_id"]], "charge_123")
  expect_true(dict[["restore"]])

  bytes_out <- req$bytes()
  # constructor: 0x6dfa0622 -> 22 06 fa 6d
  expect_equal(bytes_out[1:4], as.raw(c(0x22, 0x06, 0xfa, 0x6d)))
})

test_that("CanPurchaseStoreRequest works correctly", {
  skip_on_cran()
  purpose <- MockTLObject$new()
  req <- CanPurchaseStoreRequest$new(purpose = purpose)
  
  expect_s3_class(req, "CanPurchaseStoreRequest")
  
  dict <- req$to_dict()
  expect_equal(dict[["_"]], "CanPurchaseStoreRequest")

  bytes_out <- req$bytes()
  # constructor: 0x4fdc5ea7 -> a7 5e dc 4f
  expect_equal(bytes_out[1:4], as.raw(c(0xa7, 0x5e, 0xdc, 0x4f)))
})
