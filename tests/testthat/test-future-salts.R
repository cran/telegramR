# Tests for MTProtoSender::update_salt_if_needed (future salt rotation)

make_sender <- function() {
  MTProtoSender$new()
}

make_future_salt <- function(valid_since, valid_until, salt) {
  FutureSalt$new(valid_since = valid_since, valid_until = valid_until, salt = salt)
}

test_that("update_salt_if_needed applies a currently-valid future salt", {
  skip_on_cran()
  sender <- make_sender()
  priv   <- sender$.__enclos_env__$private
  now    <- as.integer(Sys.time())

  priv$state$time_offset <- 0
  priv$state$salt        <- 0L
  priv$future_salts      <- list(
    make_future_salt(now - 100L, now + 3600L, 99999L)
  )

  priv$update_salt_if_needed()

  expect_equal(priv$state$salt, 99999L)
})

test_that("update_salt_if_needed does not change salt for expired future salt", {
  skip_on_cran()
  sender <- make_sender()
  priv   <- sender$.__enclos_env__$private
  now    <- as.integer(Sys.time())

  original_salt          <- priv$state$salt
  priv$state$time_offset <- 0
  priv$future_salts      <- list(
    make_future_salt(now - 7200L, now - 3600L, 11111L)  # expired 1 h ago
  )

  priv$update_salt_if_needed()

  expect_equal(priv$state$salt, original_salt)
})

test_that("update_salt_if_needed discards expired salts from the list", {
  skip_on_cran()
  sender <- make_sender()
  priv   <- sender$.__enclos_env__$private
  now    <- as.integer(Sys.time())

  priv$state$time_offset <- 0
  priv$future_salts      <- list(
    make_future_salt(now - 7200L, now - 3600L, 11111L)  # expired
  )

  priv$update_salt_if_needed()

  expect_equal(length(priv$future_salts), 0L)
})

test_that("update_salt_if_needed keeps not-yet-valid salts for later", {
  skip_on_cran()
  sender <- make_sender()
  priv   <- sender$.__enclos_env__$private
  now    <- as.integer(Sys.time())

  original_salt          <- priv$state$salt
  priv$state$time_offset <- 0
  priv$future_salts      <- list(
    make_future_salt(now + 3600L, now + 7200L, 22222L)  # valid in 1 h
  )

  priv$update_salt_if_needed()

  expect_equal(priv$state$salt, original_salt)   # no change yet
  expect_equal(length(priv$future_salts), 1L)    # kept for later
})

test_that("update_salt_if_needed picks the first valid salt when multiple exist", {
  skip_on_cran()
  sender <- make_sender()
  priv   <- sender$.__enclos_env__$private
  now    <- as.integer(Sys.time())

  priv$state$time_offset <- 0
  priv$state$salt        <- 0L
  # Two valid salts; update_salt_if_needed picks the first one it sees
  priv$future_salts <- list(
    make_future_salt(now - 200L, now + 1800L, 55555L),
    make_future_salt(now - 100L, now + 3600L, 66666L)
  )

  priv$update_salt_if_needed()

  expect_true(priv$state$salt %in% c(55555L, 66666L))
})

test_that("update_salt_if_needed is a no-op when future_salts is empty", {
  skip_on_cran()
  sender <- make_sender()
  priv   <- sender$.__enclos_env__$private

  priv$state$time_offset <- 0
  priv$state$salt        <- 42L
  priv$future_salts      <- list()

  priv$update_salt_if_needed()

  expect_equal(priv$state$salt, 42L)
})
