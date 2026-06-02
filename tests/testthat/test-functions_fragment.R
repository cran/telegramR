MockTLObject <- R6::R6Class("MockTLObject",
  inherit = TLObject,
  public = list(
    to_bytes = function() as.raw(c(1, 2, 3, 4)),
    to_list = function() list("_" = "MockTLObject")
  )
)

MockTLObjectLegacy <- R6::R6Class("MockTLObjectLegacy",
  inherit = TLObject,
  public = list(
    bytes = function() as.raw(c(5, 6, 7, 8)),
    toList = function() list("_" = "MockTLObjectLegacy")
  )
)

test_that("GetCollectibleInfoRequest works correctly with modern objects", {
  skip_on_cran()
  collectible <- MockTLObject$new()
  req <- GetCollectibleInfoRequest$new(collectible = collectible)
  
  expect_s3_class(req, "GetCollectibleInfoRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "GetCollectibleInfoRequest")
  expect_equal(lst[["collectible"]], list("_" = "MockTLObject"))

  bytes <- req$to_bytes()
  expect_true(is.raw(bytes))
  
  # constructor id: 0xbe1e85ba -> ba 85 1e be
  expect_equal(bytes[1:4], as.raw(c(0xba, 0x85, 0x1e, 0xbe)))
  
  # Mock object bytes follow
  expect_equal(bytes[5:8], as.raw(c(1, 2, 3, 4)))
})

test_that("GetCollectibleInfoRequest works correctly with legacy objects", {
  skip_on_cran()
  collectible <- MockTLObjectLegacy$new()
  req <- GetCollectibleInfoRequest$new(collectible = collectible)
  
  lst <- req$to_list()
  expect_equal(lst[["collectible"]], list("_" = "MockTLObjectLegacy"))

  bytes <- req$to_bytes()
  expect_equal(bytes[5:8], as.raw(c(5, 6, 7, 8)))
})

test_that("GetCollectibleInfoRequest works with raw vector", {
  skip_on_cran()
  collectible <- as.raw(c(9, 10, 11, 12))
  req <- GetCollectibleInfoRequest$new(collectible = collectible)
  
  lst <- req$to_list()
  expect_equal(lst[["collectible"]], collectible)

  bytes <- req$to_bytes()
  expect_equal(bytes[5:8], collectible)
})

test_that("GetCollectibleInfoRequest throws error on invalid object", {
  skip_on_cran()
  InvalidObject <- R6::R6Class("InvalidObject", inherit = TLObject)
  req <- GetCollectibleInfoRequest$new(collectible = InvalidObject$new())
  
  expect_error(req$to_list(), "collectible does not provide a to_list / toList method")
  expect_error(req$to_bytes(), "collectible does not provide a to_bytes / bytes method")
})
