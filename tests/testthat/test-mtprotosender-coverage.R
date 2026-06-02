# Extended coverage tests for R/mtprotosender.R

test_that("MTProtoSender$set_auth_key_callback stores callback", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE), {
    sender <- MTProtoSender$new()
    called_with <- NULL
    cb <- function(key) {
      called_with <<- key
    }
    sender$set_auth_key_callback(cb)
    # Access private field to verify storage
    priv <- sender$.__enclos_env__$private
    expect_true(is.function(priv$auth_key_callback))
  })
})

test_that("MTProtoSender$set_update_callback stores callback", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE), {
    sender <- MTProtoSender$new()
    cb <- function(update) NULL
    sender$set_update_callback(cb)
    priv <- sender$.__enclos_env__$private
    expect_true(is.function(priv$update_callback))
  })
})

test_that("MTProtoSender$transport_connected returns FALSE when no connection", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE), {
    sender <- MTProtoSender$new()
    expect_false(sender$transport_connected())
  })
})

test_that("MTProtoSender$transport_connected returns FALSE when disconnected", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE), {
    connection <- list(
      connect = function(timeout) TRUE,
      disconnect = function() TRUE,
      connected = FALSE,
      to_string = function() "MockConnection"
    )
    sender <- MTProtoSender$new()
    value(sender$connect(connection))
    # transport_connected uses connection$connected field
    expect_false(sender$transport_connected())
  })
})

test_that("MTProtoSender$is_connected reflects connection state", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE), {
    sender <- MTProtoSender$new()
    expect_false(sender$is_connected())
    connection <- list(
      connect = function(timeout) TRUE,
      to_string = function() "MockConnection"
    )
    value(sender$connect(connection))
    expect_true(sender$is_connected())
  })
})

test_that("MTProtoSender$update_time_offset handles NA msg_id", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE), {
    sender <- MTProtoSender$new()
    offset <- sender$update_time_offset(NA)
    # Should not error; offset should be ~10
    expect_gte(offset, 5)
  })
})

test_that("MTProtoSender$get_new_msg_id generates monotonically increasing IDs", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE), {
    sender <- MTProtoSender$new()
    ids <- vapply(1:10, function(i) as.numeric(sender$get_new_msg_id()), numeric(1))
    expect_true(all(diff(ids) > 0))
  })
})

test_that("MTProtoSender$disconnected returns promise when disconnected_future is NULL", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE), {
    sender <- MTProtoSender$new()
    priv <- sender$.__enclos_env__$private
    priv$disconnected_future <- NULL
    p <- sender$disconnected()
    expect_true(inherits(p, "promise"))
  })
})

test_that("retry_range returns sequence 1:n", {
  skip_on_cran()
  expect_equal(retry_range(3), 1:3)
})

test_that("retry_range with n=0 returns 1", {
  skip_on_cran()
  expect_equal(retry_range(0), 1L)
})

test_that("retry_range with force_retry=TRUE and n=0 returns 1", {
  skip_on_cran()
  expect_equal(retry_range(0, force_retry = TRUE), 1)
})

test_that("retry_range errors on negative n", {
  skip_on_cran()
  expect_error(retry_range(-1), "non-negative")
})

test_that("msg_id_key returns '0' for NULL", {
  skip_on_cran()
  expect_equal(msg_id_key(NULL), "0")
})

test_that("msg_id_key normalizes numeric value", {
  skip_on_cran()
  expect_equal(msg_id_key(42.0), "42")
})

test_that("await_promise returns plain value immediately", {
  skip_on_cran()
  result <- await_promise(42L)
  expect_equal(result, 42L)
})

test_that("clone_error preserves class and message", {
  skip_on_cran()
  orig <- simpleError("test error")
  class(orig) <- c("MyError", "error", "condition")
  cloned <- clone_error(orig)
  expect_equal(cloned$message, "test error")
  expect_true(inherits(cloned, "MyError"))
})

test_that("clone_error errors on non-error input", {
  skip_on_cran()
  expect_error(clone_error("not an error"), "must be an error object")
})

test_that("get_traceback returns a string", {
  skip_on_cran()
  err <- simpleError("test")
  result <- get_traceback(err)
  expect_true(is.character(result))
  expect_true(nzchar(result))
})
