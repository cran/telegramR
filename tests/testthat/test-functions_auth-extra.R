test_that("auth request serializers cover simple branches", {
  skip_on_cran()
  accept <- AcceptLoginTokenRequest$new(charToRaw("abc"))
  expect_equal(accept$to_list(), list("_" = "AcceptLoginTokenRequest", token = charToRaw("abc")))
  expect_equal(
    accept$to_bytes(),
    c(as.raw(c(0x4D, 0xAD, 0x94, 0xE8)), serialize_bytes(charToRaw("abc")))
  )

  cancel <- CancelCodeRequest$new("123", "hash")
  expect_equal(
    cancel$to_list(),
    list("_" = "CancelCodeRequest", phone_number = "123", phone_code_hash = "hash")
  )
  expect_equal(
    cancel$to_bytes(),
    c(
      as.raw(c(0x78, 0x05, 0x04, 0x1F)),
      serialize_bytes("123"),
      serialize_bytes("hash")
    )
  )

  recovery <- CheckRecoveryPasswordRequest$new("secret")
  expect_equal(
    recovery$to_list(),
    list("_" = "CheckRecoveryPasswordRequest", code = "secret")
  )
  expect_equal(
    recovery$to_bytes(),
    c(as.raw(c(0x79, 0xBF, 0x36, 0x0D)), serialize_bytes("secret"))
  )

  export_auth <- ExportAuthorizationRequest$new(9L)
  expect_equal(
    export_auth$to_list(),
    list("_" = "ExportAuthorizationRequest", dc_id = 9L)
  )
  expect_equal(
    export_auth$to_bytes(),
    c(as.raw(c(0xCD, 0xFF, 0xBF, 0xE5)), writeBin(9L, raw(), size = 4, endian = "little"))
  )
})

test_that("BindTempAuthKeyRequest serializes datetimes via package helper", {
  skip_on_cran()
  expires_at <- as.POSIXct("2025-01-01 00:00:00", tz = "UTC")
  req <- BindTempAuthKeyRequest$new(
    perm_auth_key_id = 1,
    nonce = 2,
    expires_at = expires_at,
    encrypted_message = charToRaw("x")
  )

  expect_equal(
    req$to_list(),
    list(
      "_" = "BindTempAuthKeyRequest",
      perm_auth_key_id = 1,
      nonce = 2,
      expires_at = expires_at,
      encrypted_message = charToRaw("x")
    )
  )

  expect_equal(
    req$to_bytes(),
    c(
      as.raw(c(0x05, 0x2A, 0xD4, 0xCD)),
      writeBin(1, raw(), size = 8, endian = "little"),
      writeBin(2, raw(), size = 8, endian = "little"),
      serialize_datetime(expires_at),
      serialize_bytes(charToRaw("x"))
    )
  )
})

test_that("CheckPasswordRequest handles supported and unsupported password objects", {
  skip_on_cran()
  password_to_bytes <- new.env(parent = emptyenv())
  class(password_to_bytes) <- "R6"
  password_to_bytes$to_list <- function() list(kind = "to_bytes")
  password_to_bytes$to_bytes <- function() as.raw(c(0x01, 0x02))

  req <- CheckPasswordRequest$new(password_to_bytes)
  expect_equal(
    req$to_list(),
    list("_" = "CheckPasswordRequest", password = list(kind = "to_bytes"))
  )
  expect_equal(
    req$to_bytes(),
    c(as.raw(c(0x16, 0x4D, 0x8B, 0xD1)), as.raw(c(0x01, 0x02)))
  )

  password_bytes_alias <- new.env(parent = emptyenv())
  class(password_bytes_alias) <- "R6"
  password_bytes_alias$`_bytes` <- function() as.raw(c(0x03, 0x04))

  req_alias <- CheckPasswordRequest$new(password_bytes_alias)
  expect_equal(
    req_alias$to_bytes(),
    c(as.raw(c(0x16, 0x4D, 0x8B, 0xD1)), as.raw(c(0x03, 0x04)))
  )

  expect_error(
    CheckPasswordRequest$new(NULL)$to_bytes(),
    "password must be provided"
  )

  bad_password <- new.env(parent = emptyenv())
  class(bad_password) <- "R6"
  expect_error(
    CheckPasswordRequest$new(bad_password)$to_bytes(),
    "does not provide _bytes\\(\\) or to_bytes\\(\\)"
  )
})

test_that("vector-based auth requests serialize compact payloads", {
  skip_on_cran()
  drop_keys <- DropTempAuthKeysRequest$new(c(1, 2))
  expect_equal(
    drop_keys$to_list(),
    list("_" = "DropTempAuthKeysRequest", except_auth_keys = list(1, 2))
  )
  expect_equal(
    drop_keys$to_bytes(),
    c(
      as.raw(c(0x88, 0xA1, 0x48, 0x8E)),
      as.raw(c(0x15, 0xC4, 0xB5, 0x1C)),
      writeBin(2L, raw(), size = 4, endian = "little"),
      writeBin(1, raw(), size = 8, endian = "little"),
      writeBin(2, raw(), size = 8, endian = "little")
    )
  )

  export_login <- ExportLoginTokenRequest$new(123L, "hash", c(4, 5))
  expect_equal(
    export_login$to_list(),
    list(
      "_" = "ExportLoginTokenRequest",
      api_id = 123L,
      api_hash = "hash",
      except_ids = list(4, 5)
    )
  )
  expect_equal(
    export_login$to_bytes(),
    c(
      as.raw(c(0xFE, 0x85, 0xE0, 0xB7)),
      writeBin(123L, raw(), size = 4, endian = "little"),
      serialize_bytes("hash"),
      as.raw(c(0x15, 0xC4, 0xB5, 0x1C)),
      writeBin(2L, raw(), size = 4, endian = "little"),
      writeBin(4, raw(), size = 8, endian = "little"),
      writeBin(5, raw(), size = 8, endian = "little")
    )
  )
})

auth_extra_tl_object <- function(raw_bytes = as.raw(c(0xaa, 0xbb))) {
  obj <- new.env(parent = emptyenv())
  class(obj) <- "R6"
  obj$to_list <- function() list(kind = "auth-extra")
  obj$to_bytes <- function() raw_bytes
  obj
}

test_that("auth import and logout requests serialize", {
  skip_on_cran()
  import_auth <- ImportAuthorizationRequest$new(id = 7, bytes = charToRaw("abc"))
  expect_equal(
    import_auth$to_list(),
    list("_" = "ImportAuthorizationRequest", id = 7, bytes = charToRaw("abc"))
  )
  expect_equal(
    import_auth$to_bytes(),
    c(as.raw(c(0xad, 0x7d, 0x7a, 0xa5)), writeBin(7, raw(), size = 8, endian = "little"), serialize_bytes(charToRaw("abc")))
  )

  bot_auth <- ImportBotAuthorizationRequest$new(
    flags = 1L,
    api_id = 123L,
    api_hash = "hash",
    bot_auth_token = "token"
  )
  expect_equal(
    bot_auth$to_list(),
    list("_" = "ImportBotAuthorizationRequest", flags = 1L, api_id = 123L, api_hash = "hash", bot_auth_token = "token")
  )
  expect_equal(
    bot_auth$to_bytes(),
    c(
      as.raw(c(0x2c, 0xff, 0xa3, 0x67)),
      writeBin(1L, raw(), size = 4, endian = "little"),
      writeBin(123L, raw(), size = 4, endian = "little"),
      serialize_bytes("hash"),
      serialize_bytes("token")
    )
  )

  login_token <- ImportLoginTokenRequest$new(charToRaw("tok"))
  expect_equal(login_token$to_list(), list("_" = "ImportLoginTokenRequest", token = charToRaw("tok")))
  expect_equal(
    login_token$to_bytes(),
    c(as.raw(c(0xe4, 0x5c, 0xac, 0x95)), serialize_bytes(charToRaw("tok")))
  )

  web_token <- ImportWebTokenAuthorizationRequest$new(api_id = 321L, api_hash = "hash", web_auth_token = "web")
  expect_equal(
    web_token$to_bytes(),
    c(
      as.raw(c(0xa9, 0x73, 0xb8, 0x2d)),
      writeBin(321L, raw(), size = 4, endian = "little"),
      serialize_bytes("hash"),
      serialize_bytes("web")
    )
  )

  logout <- LogOutRequest$new()
  expect_equal(logout$to_list(), list("_" = "LogOutRequest"))
  expect_equal(logout$to_bytes(), as.raw(c(0x19, 0xba, 0x72, 0x3e)))
})

test_that("auth fixed and simple phone-code requests serialize", {
  skip_on_cran()
  password_recovery <- RequestPasswordRecoveryRequest$new()
  expect_equal(password_recovery$to_list(), list("_" = "RequestPasswordRecoveryRequest"))
  expect_equal(password_recovery$to_bytes(), as.raw(c(0x66, 0xbc, 0x97, 0xd8)))

  reset_auth <- ResetAuthorizationsRequest$new()
  expect_equal(reset_auth$to_list(), list("_" = "ResetAuthorizationsRequest"))
  expect_equal(reset_auth$to_bytes(), as.raw(c(0x1a, 0x0d, 0xab, 0x9f)))

  missing <- ReportMissingCodeRequest$new("111", "hash", "01")
  expect_equal(
    missing$to_list(),
    list("_" = "ReportMissingCodeRequest", phone_number = "111", phone_code_hash = "hash", mnc = "01")
  )
  expect_equal(
    missing$to_bytes(),
    c(as.raw(c(0xf6, 0xef, 0x9d, 0xcb)), serialize_bytes("111"), serialize_bytes("hash"), serialize_bytes("01"))
  )

  reset_email <- ResetLoginEmailRequest$new("111", "hash")
  expect_equal(
    reset_email$to_bytes(),
    c(as.raw(c(0x93, 0x01, 0x96, 0x7e)), serialize_bytes("111"), serialize_bytes("hash"))
  )
})

test_that("auth flag-based password recovery and firebase requests serialize", {
  skip_on_cran()
  settings <- auth_extra_tl_object(as.raw(c(0x01, 0x02)))

  recover_plain <- RecoverPasswordRequest$new(code = "code")
  expect_equal(
    recover_plain$to_bytes(),
    c(as.raw(c(0x70, 0x6c, 0x09, 0x37)), writeBin(0L, raw(), size = 4, endian = "little"), serialize_bytes("code"))
  )

  recover_settings <- RecoverPasswordRequest$new(code = "code", new_settings = settings)
  expect_equal(recover_settings$to_list()$new_settings, settings$to_list())
  expect_equal(
    recover_settings$to_bytes(),
    c(as.raw(c(0x70, 0x6c, 0x09, 0x37)), writeBin(1L, raw(), size = 4, endian = "little"), serialize_bytes("code"), settings$to_bytes())
  )

  expect_error(
    RecoverPasswordRequest$new(code = "code", new_settings = list())$to_bytes(),
    "new_settings object does not provide"
  )

  firebase <- RequestFirebaseSmsRequest$new(
    phone_number = "111",
    phone_code_hash = "hash",
    safety_net_token = "safety",
    play_integrity_token = "play",
    ios_push_secret = "ios"
  )
  expect_equal(
    firebase$to_list(),
    list(
      "_" = "RequestFirebaseSmsRequest",
      phone_number = "111",
      phone_code_hash = "hash",
      safety_net_token = "safety",
      play_integrity_token = "play",
      ios_push_secret = "ios"
    )
  )
  expect_equal(
    firebase$to_bytes(),
    c(
      as.raw(c(0x1e, 0x26, 0x39, 0x8e)),
      writeBin(7L, raw(), size = 4, endian = "little"),
      serialize_bytes("111"),
      serialize_bytes("hash"),
      serialize_bytes("safety"),
      serialize_bytes("play"),
      serialize_bytes("ios")
    )
  )
})

test_that("auth resend, send-code, sign-in and sign-up requests serialize", {
  skip_on_cran()
  resend <- ResendCodeRequest$new("111", "hash", reason = "missed")
  expect_equal(
    resend$to_bytes(),
    c(
      as.raw(c(0x23, 0x75, 0xe4, 0xca)),
      writeBin(1L, raw(), size = 4, endian = "little"),
      serialize_bytes("111"),
      serialize_bytes("hash"),
      serialize_bytes("missed")
    )
  )

  settings <- auth_extra_tl_object(as.raw(c(0x10, 0x11)))
  send_code <- SendCodeRequest$new("111", api_id = 123L, api_hash = "hash", settings = settings)
  expect_equal(
    send_code$to_list(),
    list("_" = "SendCodeRequest", phone_number = "111", api_id = 123L, api_hash = "hash", settings = settings$to_list())
  )
  expect_equal(
    send_code$to_bytes(),
    c(
      as.raw(c(0x4f, 0x24, 0x77, 0xa6)),
      serialize_bytes("111"),
      writeBin(123L, raw(), size = 4, endian = "little"),
      serialize_bytes("hash"),
      settings$to_bytes()
    )
  )

  email_verification <- auth_extra_tl_object(as.raw(c(0x20, 0x21)))
  sign_in <- SignInRequest$new("111", "hash", phone_code = "12345", email_verification = email_verification)
  expect_equal(sign_in$to_list()$email_verification, email_verification$to_list())
  expect_equal(
    sign_in$to_bytes(),
    c(
      as.raw(c(0x51, 0xa9, 0x52, 0x8d)),
      writeBin(3L, raw(), size = 4, endian = "little"),
      serialize_bytes("111"),
      serialize_bytes("hash"),
      serialize_bytes("12345"),
      email_verification$to_bytes()
    )
  )

  expect_error(
    SignInRequest$new("111", "hash", email_verification = list())$to_bytes(),
    "email_verification object does not provide"
  )

  sign_up <- SignUpRequest$new(
    phone_number = "111",
    phone_code_hash = "hash",
    first_name = "First",
    last_name = "Last",
    no_joined_notifications = TRUE
  )
  expect_equal(
    sign_up$to_bytes(),
    c(
      as.raw(c(0x17, 0xb7, 0xc7, 0xaa)),
      writeBin(1L, raw(), size = 4, endian = "little"),
      serialize_bytes("111"),
      serialize_bytes("hash"),
      serialize_bytes("First"),
      serialize_bytes("Last")
    )
  )
})

test_that("auth from_reader methods rebuild representative requests", {
  skip_on_cran()
  obj <- auth_extra_tl_object(as.raw(c(0x01)))
  strings <- c(
    "111", "hash", "mnc",
    "222", "firebase_hash", "safety", "play", "ios",
    "333", "resend_hash", "reason"
  )
  bytes_values <- list(charToRaw("bytes"), charToRaw("token"))
  ints <- c(7L, 1L)
  longs <- c(42)
  s_idx <- 0L
  b_idx <- 0L
  i_idx <- 0L
  l_idx <- 0L

  reader <- new.env(parent = emptyenv())
  reader$tgread_string <- function() {
    s_idx <<- s_idx + 1L
    strings[[s_idx]]
  }
  reader$tgread_bytes <- function() {
    b_idx <<- b_idx + 1L
    bytes_values[[b_idx]]
  }
  reader$read_int <- function() {
    i_idx <<- i_idx + 1L
    ints[[i_idx]]
  }
  reader$read_long <- function() {
    l_idx <<- l_idx + 1L
    longs[[l_idx]]
  }
  reader$tgread_object <- function() obj

  import_auth <- ImportAuthorizationRequest$new(0, raw())$from_reader(reader)
  expect_equal(import_auth$id, 42)
  expect_equal(import_auth$bytes, charToRaw("bytes"))

  import_login <- ImportLoginTokenRequest$new(raw())$from_reader(reader)
  expect_equal(import_login$token, charToRaw("token"))

  missing <- ReportMissingCodeRequest$new("", "", "")$from_reader(reader)
  expect_equal(missing$to_list()$mnc, "mnc")

  firebase <- RequestFirebaseSmsRequest$new("", "")$from_reader(reader)
  expect_equal(firebase$safety_net_token, "safety")
  expect_equal(firebase$play_integrity_token, "play")
  expect_equal(firebase$ios_push_secret, "ios")

  resend <- ResendCodeRequest$new("", "")$from_reader(reader)
  expect_equal(resend$reason, "reason")
})
