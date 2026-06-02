# Extra tests for MTProtoState — get_new_msg_id monotonicity

test_that("MTProtoState get_new_msg_id is strictly monotonic across 20 rapid calls", {
  skip_on_cran()
  state <- MTProtoState$new(auth_key = AuthKey$new(NULL), loggers = NULL)
  ids <- lapply(seq_len(20), function(i) state$get_new_msg_id())

  for (i in seq(2, 20)) {
    expect_true(
      ids[[i]] > ids[[i - 1]],
      label = sprintf("id[%d] > id[%d]", i, i - 1)
    )
  }
})

test_that("MTProtoState get_new_msg_id stays monotonic after a backward time offset", {
  skip_on_cran()
  state <- MTProtoState$new(auth_key = AuthKey$new(NULL), loggers = NULL)
  id_before <- state$get_new_msg_id()

  # Simulate a server-corrected time that is 30 s in the past
  state$time_offset <- -30

  id_after <- state$get_new_msg_id()
  expect_true(id_after > id_before)
})

test_that("MTProtoState get_new_msg_id stays monotonic after a forward time offset", {
  skip_on_cran()
  state <- MTProtoState$new(auth_key = AuthKey$new(NULL), loggers = NULL)
  id_before <- state$get_new_msg_id()

  state$time_offset <- 60

  id_after <- state$get_new_msg_id()
  expect_true(id_after > id_before)
})
