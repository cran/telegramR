# /Users/romankyrychenko/telegramR/tests/testthat/test-mtprotosender.R

test_that("connects successfully with valid connection", {
  skip_on_cran()
  connection <- list(
    connect = function(timeout) TRUE,
    to_string = function() "MockConnection"
  )
  sender <- MTProtoSender$new()
  result <- value(sender$connect(connection))
  expect_true(result)
  expect_true(sender$is_connected())
})

test_that("throws error when connection fails after retries", {
  skip_on_cran()
  connection <- list(
    connect = function(timeout) stop("Connection failed"),
    to_string = function() "MockConnection"
  )
  sender <- MTProtoSender$new()
  expect_error(value(sender$connect(connection)), "ConnectionError: Connection to Telegram failed")
})

test_that("disconnects cleanly when connected", {
  skip_on_cran()
  connection <- list(
    connect = function(timeout) TRUE,
    disconnect = function() TRUE,
    to_string = function() "MockConnection"
  )
  sender <- MTProtoSender$new()
  value(sender$connect(connection))
  result <- value(sender$disconnect())
  expect_null(result)
  expect_false(sender$is_connected())
})

test_that("throws error when sending request while disconnected", {
  skip_on_cran()
  sender <- MTProtoSender$new()
  expect_error(sender$send("request"), "ConnectionError: Cannot send requests while disconnected")
})

test_that("generates unique message IDs sequentially", {
  skip_on_cran()
  sender <- MTProtoSender$new()
  msg_id1 <- sender$get_new_msg_id()
  msg_id2 <- sender$get_new_msg_id()
  expect_true(msg_id2 > msg_id1)
})

test_that("updates time offset correctly with valid message ID", {
  skip_on_cran()
  sender <- MTProtoSender$new()
  correct_msg_id <- bitwShiftL(as.integer(Sys.time()) + 10, 32)
  offset <- sender$update_time_offset(correct_msg_id)
  expect_equal(offset, 10, tolerance = 1)
})

test_that("handles reconnection after connection loss", {
  skip_on_cran()
  connection <- list(
    connect = function(timeout) TRUE,
    disconnect = function() TRUE,
    to_string = function() "MockConnection"
  )
  sender <- MTProtoSender$new()
  value(sender$connect(connection))
  sender$disconnect()
  expect_false(sender$is_connected())
  expect_error(sender$send("request"), "ConnectionError: Cannot send requests while disconnected")
})
