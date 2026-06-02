test_that("sends and receives valid request successfully", {
  skip_on_cran()
  connection <- list(
    send = function(data) invisible(data),
    recv = function() {
      header <- c(packInt64(0), packInt64(123456789), packInt32(4))
      body <- as.raw(c(0x01, 0x02, 0x03, 0x04))
      c(header, body)
    }
  )
  sender <- MTProtoPlainSender$new(connection)
  result <- value(sender$send(as.raw(c(0x01, 0x02, 0x03, 0x04))))
  expect_equal(result, as.raw(c(0x01, 0x02, 0x03, 0x04)))
})

test_that("throws error when buffer received is too small", {
  skip_on_cran()
  connection <- list(
    send = function(data) invisible(data),
    recv = function() raw(4)
  )
  sender <- MTProtoPlainSender$new(connection)
  expect_error(value(sender$send(as.raw(c(0x01, 0x02, 0x03, 0x04)))), "InvalidBufferError: Buffer too small")
})

test_that("throws error when auth_key_id is invalid", {
  skip_on_cran()
  connection <- list(
    send = function(data) invisible(data),
    recv = function() {
      header <- c(packInt64(1), packInt64(123456789), packInt32(4))
      body <- as.raw(c(0x01, 0x02, 0x03, 0x04))
      c(header, body)
    }
  )
  sender <- MTProtoPlainSender$new(connection)
  expect_error(value(sender$send(as.raw(c(0x01, 0x02, 0x03, 0x04)))), "Bad auth_key_id")
})

test_that("throws error when msg_id is invalid", {
  skip_on_cran()
  connection <- list(
    send = function(data) invisible(data),
    recv = function() {
      header <- c(packInt64(0), packInt64(0), packInt32(4))
      body <- as.raw(c(0x01, 0x02, 0x03, 0x04))
      c(header, body)
    }
  )
  sender <- MTProtoPlainSender$new(connection)
  expect_error(value(sender$send(as.raw(c(0x01, 0x02, 0x03, 0x04)))), "Bad msg_id")
})

test_that("throws error when length of received message is invalid", {
  skip_on_cran()
  connection <- list(
    send = function(data) invisible(data),
    recv = function() {
      header <- c(packInt64(0), packInt64(123456789), packInt32(-1))
      body <- as.raw(c(0x01, 0x02, 0x03, 0x04))
      c(header, body)
    }
  )
  sender <- MTProtoPlainSender$new(connection)
  expect_error(value(sender$send(as.raw(c(0x01, 0x02, 0x03, 0x04)))), "Bad length")
})
