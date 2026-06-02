test_that("simple account requests serialize correctly", {
  skip_on_cran()
  clear_recent <- ClearRecentEmojiStatusesRequest$new()
  expect_equal(
    clear_recent$toDict(),
    list("_" = "ClearRecentEmojiStatusesRequest")
  )
  expect_equal(clear_recent$bytes(), as.raw(c(0xae, 0x1a, 0x20, 0x18)))

  confirm_password <- ConfirmPasswordEmailRequest$new("12345")
  expect_equal(
    confirm_password$toDict(),
    list("_" = "ConfirmPasswordEmailRequest", code = "12345")
  )
  expect_equal(
    confirm_password$bytes(),
    c(as.raw(c(0x20, 0x19, 0xdf, 0x8f)), serialize_bytes("12345"))
  )

  confirm_phone <- ConfirmPhoneRequest$new("hash", "0000")
  expect_equal(
    confirm_phone$toDict(),
    list("_" = "ConfirmPhoneRequest", phoneCodeHash = "hash", phoneCode = "0000")
  )
  expect_equal(
    confirm_phone$bytes(),
    c(
      as.raw(c(0xc3, 0x78, 0x21, 0x5f)),
      serialize_bytes("hash"),
      serialize_bytes("0000")
    )
  )
})

test_that("account requests can be reconstructed from readers", {
  skip_on_cran()
  reader <- new.env(parent = emptyenv())
  calls <- 0L
  reader$tgreadString <- function() {
    calls <<- calls + 1L
    if (calls == 1L) {
      "first"
    } else {
      "second"
    }
  }

  password_req <- ConfirmPasswordEmailRequest$new("ignored")$fromReader(reader)
  expect_equal(password_req$toDict(), list("_" = "ConfirmPasswordEmailRequest", code = "first"))

  phone_req <- ConfirmPhoneRequest$new("ignored", "ignored")$fromReader(reader)
  expect_equal(
    phone_req$toDict(),
    list("_" = "ConfirmPhoneRequest", phoneCodeHash = "second", phoneCode = "second")
  )
})
