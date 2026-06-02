test_that("ReadCancelledError initializes correctly", {
  error <- ReadCancelledError$new()
  expect_equal(error$message, "The read operation was cancelled.")
})

test_that("TypeNotFoundError initializes correctly", {
  error <- TypeNotFoundError$new(0x12345678, "remaining_bytes")
  expect_equal(error$message, "Could not find a matching Constructor ID for the TLObject that was supposed to be read with ID 12345678. See the FAQ for more details. Remaining bytes: remaining_bytes")
  expect_equal(error$invalid_constructor_id, 0x12345678)
  expect_equal(error$remaining, "remaining_bytes")
})

test_that("InvalidChecksumError initializes correctly", {
  error <- InvalidChecksumError$new("1234", "5678")
  expect_equal(error$message, "Invalid checksum (1234 when 5678 was expected). This packet should be skipped.")
  expect_equal(error$checksum, "1234")
  expect_equal(error$valid_checksum, "5678")
})

test_that("InvalidBufferError initializes correctly with short payload", {
  error <- InvalidBufferError$new("short")
  expect_equal(error$message, "Invalid response buffer (too short short)")
  expect_null(error$code)
})

test_that("AuthKeyNotFound initializes correctly", {
  error <- AuthKeyNotFound$new()
  expect_equal(error$message, "The server claims it doesn't know about the authorization key. If the issue persists, you may need to recreate the session file and login again.")
})

test_that("SecurityError initializes correctly", {
  error <- SecurityError$new("Custom security error")
  expect_equal(error$message, "Custom security error")
})

test_that("CdnFileTamperedError initializes correctly", {
  error <- CdnFileTamperedError$new()
  expect_equal(error$message, "The CDN file has been altered and its download cancelled.")
})

test_that("AlreadyInConversationError initializes correctly", {
  error <- AlreadyInConversationError$new()
  expect_equal(error$message, "Cannot open exclusive conversation in a chat that already has one open conversation.")
})

test_that("BadMessageError initializes correctly with known code", {
  error <- BadMessageError$new("request", 16)
  expect_equal(error$message, "Bad message error: msg_id too low (most likely, client time is wrong).")
  expect_equal(error$request, "request")
  expect_equal(error$code, 16)
})

test_that("BadMessageError initializes correctly with unknown code", {
  error <- BadMessageError$new("request", 999)
  expect_equal(error$message, "Bad message error: Unknown error code: 999")
  expect_equal(error$request, "request")
  expect_equal(error$code, 999)
})

# --- rpc_message_to_error / FloodWait ---

test_that("rpc_message_to_error creates FloodWaitError condition for FLOOD_WAIT_N", {
  err <- rpc_message_to_error(
    list(error_code = 420L, error_message = "FLOOD_WAIT_60"),
    request = NULL
  )
  expect_s3_class(err, "FloodWaitError")
  expect_s3_class(err, "RPCError")
  expect_s3_class(err, "error")
  expect_equal(err$seconds, 60L)
  expect_match(err$message, "60 seconds")
})

test_that("rpc_message_to_error FloodWaitError works for zero-second waits", {
  err <- rpc_message_to_error(
    list(error_code = 420L, error_message = "FLOOD_WAIT_0"),
    request = NULL
  )
  expect_s3_class(err, "FloodWaitError")
  expect_equal(err$seconds, 0L)
})

test_that("rpc_message_to_error creates plain RPCError for non-flood messages", {
  err <- rpc_message_to_error(
    list(error_code = 400L, error_message = "USERNAME_INVALID"),
    request = NULL
  )
  expect_s3_class(err, "RPCError")
  expect_false(inherits(err, "FloodWaitError"))
})

test_that("rpc_message_to_error handles NULL message/code gracefully", {
  err <- rpc_message_to_error(list(), request = NULL)
  expect_s3_class(err, "RPCError")
  expect_false(inherits(err, "FloodWaitError"))
})

test_that("rpc_message_to_error attaches request to condition", {
  fake_req <- list(type = "GetHistoryRequest")
  err <- rpc_message_to_error(
    list(error_code = 400L, error_message = "PEER_ID_INVALID"),
    request = fake_req
  )
  expect_identical(err$request, fake_req)
})

# --- DC migration errors ---

test_that("rpc_message_to_error creates PhoneMigrateError for PHONE_MIGRATE_N", {
  err <- rpc_message_to_error(
    list(error_code = 303L, error_message = "PHONE_MIGRATE_5"),
    request = NULL
  )
  expect_s3_class(err, "PhoneMigrateError")
  expect_s3_class(err, "RPCError")
  expect_equal(err$new_dc, 5L)
})

test_that("rpc_message_to_error creates NetworkMigrateError for NETWORK_MIGRATE_N", {
  err <- rpc_message_to_error(
    list(error_code = 303L, error_message = "NETWORK_MIGRATE_2"),
    request = NULL
  )
  expect_s3_class(err, "NetworkMigrateError")
  expect_equal(err$new_dc, 2L)
})

test_that("rpc_message_to_error creates UserMigrateError for USER_MIGRATE_N", {
  err <- rpc_message_to_error(
    list(error_code = 303L, error_message = "USER_MIGRATE_4"),
    request = NULL
  )
  expect_s3_class(err, "UserMigrateError")
  expect_equal(err$new_dc, 4L)
})

# --- Malformed / edge-case FLOOD_WAIT ---

test_that("rpc_message_to_error falls back to RPCError for malformed FLOOD_WAIT", {
  # Non-numeric suffix — should NOT produce FloodWaitError
  err <- rpc_message_to_error(
    list(error_code = 420L, error_message = "FLOOD_WAIT_abc"),
    request = NULL
  )
  expect_false(inherits(err, "FloodWaitError"))
  expect_s3_class(err, "RPCError")
})

test_that("rpc_message_to_error handles AUTH_KEY_UNREGISTERED by enriching message", {
  err <- rpc_message_to_error(
    list(error_code = 401L, error_message = "AUTH_KEY_UNREGISTERED"),
    request = NULL
  )
  expect_s3_class(err, "RPCError")
  expect_match(err$message, "(?i)reconnect", perl = TRUE)
})
