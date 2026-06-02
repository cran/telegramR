MockTLObject <- R6::R6Class("MockTLObject",
  inherit = TLObject,
  public = list(
    bytes = function() as.raw(c(1, 2, 3, 4)),
    to_dict = function() list("_" = "MockTLObject")
  )
)

test_that("GetFullUserRequest works correctly", {
  skip_on_cran()
  userId <- MockTLObject$new()
  req <- GetFullUserRequest$new(id = userId)
  
  expect_s3_class(req, "GetFullUserRequest")
  
  dict <- req$to_dict()
  expect_equal(dict[["_"]], "GetFullUserRequest")
  expect_equal(dict[["id"]], list("_" = "MockTLObject"))

  bytes <- req$bytes()
  expect_true(is.raw(bytes))
  # constructor id: 0xb60f5918 -> 18 59 0f b6
  expect_equal(bytes[1:4], as.raw(c(0x18, 0x59, 0x0f, 0xb6)))
  # Mock object bytes follow
  expect_equal(bytes[5:8], as.raw(c(1, 2, 3, 4)))
})

test_that("GetRequirementsToContactRequest works correctly", {
  skip_on_cran()
  ids <- list(MockTLObject$new(), MockTLObject$new())
  req <- GetRequirementsToContactRequest$new(id = ids)
  
  expect_s3_class(req, "GetRequirementsToContactRequest")
  
  dict <- req$to_dict()
  expect_equal(dict[["_"]], "GetRequirementsToContactRequest")
  expect_length(dict[["id"]], 2)

  bytes <- req$bytes()
  expect_true(is.raw(bytes))
  # constructor id: 0xd89a83a3 -> a3 83 9a d8
  expect_equal(bytes[1:4], as.raw(c(0xa3, 0x83, 0x9a, 0xd8)))
  # vector constructor: 15 c4 b5 1c
  expect_equal(bytes[5:8], as.raw(c(0x15, 0xc4, 0xb5, 0x1c)))
  # count: 2
  expect_equal(bytes[9:12], as.raw(c(2, 0, 0, 0)))
})

test_that("GetUsersRequest works correctly", {
  skip_on_cran()
  ids <- list(MockTLObject$new())
  req <- GetUsersRequest$new(id = ids)
  
  expect_s3_class(req, "GetUsersRequest")
  
  dict <- req$to_dict()
  expect_equal(dict[["_"]], "GetUsersRequest")
  expect_length(dict[["id"]], 1)

  bytes <- req$bytes()
  expect_true(is.raw(bytes))
  # constructor id: 0x0d91a548 -> 48 a5 91 0d
  expect_equal(bytes[1:4], as.raw(c(0x48, 0xa5, 0x91, 0x0d)))
})
