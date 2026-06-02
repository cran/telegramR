# Mocking classes for tests if needed, but since we load_all we can use real classes or helper mocks
MockTLObject <- R6::R6Class("MockTLObject",
  inherit = TLObject,
  public = list(
    bytes = function() as.raw(c(1, 2, 3, 4)),
    toDict = function() list("_" = "MockTLObject")
  )
)

test_that("AcceptAuthorizationRequest works correctly", {
  skip_on_cran()
  botId <- 12345
  scope <- "user_info"
  publicKey <- "pubkey"
  valueHashes <- list(MockTLObject$new(), MockTLObject$new())
  credentials <- MockTLObject$new()

  req <- AcceptAuthorizationRequest$new(
    botId = botId,
    scope = scope,
    publicKey = publicKey,
    valueHashes = valueHashes,
    credentials = credentials
  )

  expect_s3_class(req, "AcceptAuthorizationRequest")
  
  dict <- req$toDict()
  expect_equal(dict[["_"]], "AcceptAuthorizationRequest")
  expect_equal(dict[["bot_id"]], botId)
  expect_equal(dict[["scope"]], scope)
  expect_equal(dict[["public_key"]], publicKey)

  bytes <- req$bytes()
  expect_true(is.raw(bytes))
  expect_equal(bytes[1:4], as.raw(c(0x73, 0x4c, 0xed, 0xf3)))
})

test_that("CancelPasswordEmailRequest works correctly", {
  skip_on_cran()
  req <- CancelPasswordEmailRequest$new()
  expect_s3_class(req, "CancelPasswordEmailRequest")
  
  dict <- req$toDict()
  expect_equal(dict[["_"]], "CancelPasswordEmailRequest")

  bytes <- req$bytes()
  expect_true(is.raw(bytes))
  expect_equal(bytes[1:4], as.raw(c(0xb6, 0xd5, 0xcb, 0xc1)))
})

test_that("ChangeAuthorizationSettingsRequest works correctly", {
  skip_on_cran()
  hash <- 987654321
  req <- ChangeAuthorizationSettingsRequest$new(
    hash = hash,
    confirmed = TRUE,
    encryptedRequestsDisabled = FALSE,
    callRequestsDisabled = TRUE
  )

  expect_s3_class(req, "ChangeAuthorizationSettingsRequest")
  
  dict <- req$toDict()
  expect_equal(dict[["hash"]], hash)
  expect_true(dict[["confirmed"]])
  expect_false(dict[["encrypted_requests_disabled"]])
  expect_true(dict[["call_requests_disabled"]])

  bytes <- req$bytes()
  expect_true(is.raw(bytes))
  expect_equal(bytes[1:4], as.raw(c(0x62, 0x84, 0xf4, 0x40)))
})

test_that("ChangePhoneRequest works correctly", {
  skip_on_cran()
  phoneNumber <- "1234567890"
  phoneCodeHash <- "hash123"
  phoneCode <- "12345"
  
  req <- ChangePhoneRequest$new(
    phoneNumber = phoneNumber,
    phoneCodeHash = phoneCodeHash,
    phoneCode = phoneCode
  )

  expect_s3_class(req, "ChangePhoneRequest")
  
  dict <- req$toDict()
  expect_equal(dict[["phoneNumber"]], phoneNumber)
  expect_equal(dict[["phoneCodeHash"]], phoneCodeHash)
  expect_equal(dict[["phoneCode"]], phoneCode)

  bytes <- req$bytes()
  expect_true(is.raw(bytes))
  expect_equal(bytes[1:4], as.raw(c(0xdb, 0x2e, 0xc3, 0x70)))
})

test_that("UpdateProfileRequest works correctly", {
  skip_on_cran()
  firstName <- "John"
  lastName <- "Doe"
  about <- "About me"
  
  req <- UpdateProfileRequest$new(
    firstName = firstName,
    lastName = lastName,
    about = about
  )

  expect_s3_class(req, "UpdateProfileRequest")
  
  dict <- req$toDict()
  expect_equal(dict[["firstName"]], firstName)
  expect_equal(dict[["lastName"]], lastName)
  expect_equal(dict[["about"]], about)

  bytes <- req$bytes()
  expect_true(is.raw(bytes))
  expect_equal(bytes[1:4], as.raw(c(0x75, 0x57, 0x51, 0x78)))
})
