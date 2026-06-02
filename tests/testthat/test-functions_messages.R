MockTLObject <- R6::R6Class("MockTLObject",
  inherit = TLObject,
  public = list(
    bytes = function() as.raw(c(1, 2, 3, 4)),
    toDict = function() list("_" = "MockTLObject")
  )
)

test_that("AcceptEncryptionRequest works correctly", {
  skip_on_cran()
  peer <- MockTLObject$new()
  req <- AcceptEncryptionRequest$new(peer = peer, gB = as.raw(c(0x11, 0x22)), keyFingerprint = 12345)
  
  expect_s3_class(req, "AcceptEncryptionRequest")
  
  # bytes verification
  bytes_out <- req$bytes()
  # constructor: 0x3dbc0415 -> 15 04 bc 3d
  expect_equal(bytes_out[1:4], as.raw(c(0x15, 0x04, 0xbc, 0x3d)))
})

test_that("AcceptUrlAuthRequest works correctly", {
  skip_on_cran()
  peer <- MockTLObject$new()
  req <- AcceptUrlAuthRequest$new(
    writeAllowed = TRUE,
    peer = peer,
    msgId = 100L,
    buttonId = 200L,
    url = "https://example.com"
  )
  
  expect_s3_class(req, "AcceptUrlAuthRequest")
  
  dict <- req$toDict()
  expect_true(dict[["write_allowed"]])
  expect_equal(dict[["url"]], "https://example.com")

  # bytes check (basic)
  bytes_out <- req$bytes()
  # constructor ID is not explicitly c(...) in bytes() method, it's dynamic based on flags
  # but we can check if it returns raw
  expect_true(is.raw(bytes_out))
})

test_that("AddChatUserRequest works correctly", {
  skip_on_cran()
  userId <- MockTLObject$new()
  req <- AddChatUserRequest$new(chatId = 12345, userId = userId, fwdLimit = 50)
  
  expect_s3_class(req, "AddChatUserRequest")
  
  bytes_out <- req$bytes()
  # constructor: 0xcbc6d107 -> 07 d1 c6 cb
  expect_equal(bytes_out[1:4], as.raw(c(0x07, 0xd1, 0xc6, 0xcb)))
})
