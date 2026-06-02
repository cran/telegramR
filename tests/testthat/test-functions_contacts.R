MockTLObject <- R6::R6Class("MockTLObject",
  inherit = TLObject,
  public = list(
    to_bytes = function() as.raw(c(1, 2, 3, 4)),
    to_list = function() list("_" = "MockTLObject")
  )
)

test_that("AcceptContactRequest works correctly", {
  skip_on_cran()
  id <- MockTLObject$new()
  req <- AcceptContactRequest$new(id = id)
  
  expect_s3_class(req, "AcceptContactRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "AcceptContactRequest")
  expect_equal(lst[["id"]], list("_" = "MockTLObject"))

  bytes <- req$to_bytes()
  expect_true(is.raw(bytes))
  # constructor id: 0xf831a20f -> 0f a2 31 f8
  expect_equal(bytes[1:4], as.raw(c(0x0f, 0xa2, 0x31, 0xf8)))
  expect_equal(bytes[5:8], as.raw(c(1, 2, 3, 4)))
})

test_that("AddContactRequest works correctly", {
  skip_on_cran()
  id <- MockTLObject$new()
  req <- AddContactRequest$new(
    id = id,
    first_name = "John",
    last_name = "Doe",
    phone = "123456",
    add_phone_privacy_exception = TRUE
  )
  
  expect_s3_class(req, "AddContactRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["first_name"]], "John")
  expect_equal(lst[["last_name"]], "Doe")
  expect_true(lst[["add_phone_privacy_exception"]])

  bytes <- req$to_bytes()
  expect_true(is.raw(bytes))
  # constructor id: 0xe8f463d0 -> d0 63 f4 e8
  expect_equal(bytes[1:4], as.raw(c(0xd0, 0x63, 0xf4, 0xe8)))
})

test_that("BlockRequest works correctly", {
  skip_on_cran()
  id <- MockTLObject$new()
  req <- BlockRequest$new(id = id, my_stories_from = TRUE)
  
  expect_s3_class(req, "BlockRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "BlockRequest")
  expect_true(lst[["my_stories_from"]])

  bytes <- req$to_bytes()
  expect_true(is.raw(bytes))
  # constructor id: 0x2e2e8734 -> 34 87 2e 2e
  expect_equal(bytes[1:4], as.raw(c(0x34, 0x87, 0x2e, 0x2e)))
})
