test_that("initializes MTProtoState with valid authentication key", {
  skip_on_cran()
  auth_key <- list(key = raw(256), key_id = 123456789)
  loggers <- list(MTProtoState = function(...) NULL)
  state <- MTProtoState$new(auth_key, loggers)
  expect_equal(state$auth_key, auth_key)
  expect_equal(state$time_offset, 0)
  expect_equal(state$salt, 0)
  expect_true(!is.null(state$id))
})

test_that("resets MTProtoState correctly", {
  skip_on_cran()
  auth_key <- list(key = raw(256), key_id = 123456789)
  loggers <- list(MTProtoState = function(...) NULL)
  state <- MTProtoState$new(auth_key, loggers)
  state$reset()
  expect_equal(state$salt, 0)
  expect_true(!is.null(state$id))
})

test_that("generates unique message IDs", {
  skip_on_cran()
  auth_key <- list(key = raw(256), key_id = 123456789)
  loggers <- list(MTProtoState = function(...) NULL)
  state <- MTProtoState$new(auth_key, loggers)
  msg_id1 <- state$get_new_msg_id()
  msg_id2 <- state$get_new_msg_id()
  expect_true(msg_id2 > msg_id1)
})

test_that("throws error when decrypting with invalid auth key", {
  skip_on_cran()
  auth_key <- list(key = raw(256), key_id = 123456789)
  loggers <- list(MTProtoState = function(...) NULL)
  state <- MTProtoState$new(auth_key, loggers)
  # first 8 bytes = auth_key_id (wrong), next 8 bytes = session id (can be anything)
  body <- c(packInt64(987654321), packInt64(state$id), raw(100))
  expect_error(state$decrypt_message_data(body), "SecurityError: Server replied with an invalid auth key")
})

test_that("throws error when session ID is invalid during decryption", {
  skip_on_cran()
  auth_key <- list(key = raw(256), key_id = 123456789)
  loggers <- list(MTProtoState = function(...) NULL)
  state <- MTProtoState$new(auth_key, loggers)
  # first 8 bytes = correct auth_key_id, next 8 bytes = wrong session id
  body <- c(packInt64(state$auth_key$key_id), packInt64(as.integer(state$id) + 1), raw(100))
  expect_error(state$decrypt_message_data(body), "SecurityError: Server replied with a wrong session ID")
})

test_that("updates time offset correctly with valid message ID", {
  skip_on_cran()
  auth_key <- list(key = raw(256), key_id = 123456789)
  loggers <- list(MTProtoState = function(...) NULL)
  state <- MTProtoState$new(auth_key, loggers)
  correct_msg_id <- bitwShiftL(as.integer(Sys.time()) + 10, 32)
  offset <- state$update_time_offset(correct_msg_id)
  expect_equal(offset, 10, tolerance = 1)
})
