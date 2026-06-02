# Extended coverage tests for R/telegrambaseclient.R

make_test_client <- function() {
  withr::local_options(list(
    telegramR.test_mode = TRUE,
    telegramR.skip_background = TRUE
  ))
  TelegramBaseClient$new(
    session = NULL,
    api_id = 1,
    api_hash = "hash",
    receive_updates = FALSE
  )
}

test_that("TelegramBaseClient$get_session_path returns NULL for in-memory session", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    client <- TelegramBaseClient$new(
      session = NULL,
      api_id = 1,
      api_hash = "hash",
      receive_updates = FALSE
    )
    expect_null(client$get_session_path())
  })
})

test_that("TelegramBaseClient$set_flood_sleep_threshold clamps value to 24h", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    client <- TelegramBaseClient$new(
      session = NULL,
      api_id = 1,
      api_hash = "hash",
      receive_updates = FALSE
    )
    client$set_flood_sleep_threshold(999999)
    expect_equal(client$get_flood_sleep_threshold(), 24 * 60 * 60)
  })
})

test_that("TelegramBaseClient$set_flood_sleep_threshold with NULL defaults to 0", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    client <- TelegramBaseClient$new(
      session = NULL,
      api_id = 1,
      api_hash = "hash",
      receive_updates = FALSE
    )
    client$set_flood_sleep_threshold(NULL)
    expect_equal(client$get_flood_sleep_threshold(), 0)
  })
})

test_that("TelegramBaseClient$clear_session_auth_key clears sender auth key", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    client <- TelegramBaseClient$new(
      session = NULL,
      api_id = 1,
      api_hash = "hash",
      receive_updates = FALSE
    )
    # Set an auth key on the sender
    priv <- client$.__enclos_env__$private
    priv$sender$auth_key$key <- as.raw(1:32)
    result <- client$clear_session_auth_key()
    expect_true(result)
    expect_null(priv$sender$auth_key$key)
    expect_null(priv$session$auth_key)
  })
})

test_that("TelegramBaseClient$is_connected returns FALSE before connect", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    client <- TelegramBaseClient$new(
      session = NULL,
      api_id = 1,
      api_hash = "hash",
      receive_updates = FALSE
    )
    expect_false(client$is_connected())
  })
})

test_that("TelegramBaseClient ExportState tracks borrows correctly", {
  skip_on_cran()
  state <- ExportState$new()
  expect_true(state$need_connect())
  state$add_borrow()
  expect_false(state$need_connect())
  state$add_return()
  expect_false(state$need_connect())
})

test_that("ExportState$should_disconnect returns FALSE immediately after return", {
  skip_on_cran()
  state <- ExportState$new()
  state$add_borrow()
  state$add_return()
  # Zero_ts is set to now, so should_disconnect needs 60 secs to elapse
  expect_false(state$should_disconnect())
})

test_that("ExportState$add_return errors when over-returned", {
  skip_on_cran()
  state <- ExportState$new()
  expect_error(state$add_return(), "Returned sender more than it was borrowed")
})

test_that("TelegramBaseClient$get_version returns a non-empty string", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    client <- TelegramBaseClient$new(
      session = NULL,
      api_id = 1,
      api_hash = "hash",
      receive_updates = FALSE
    )
    v <- client$get_version()
    expect_true(is.character(v))
    expect_true(nzchar(v))
  })
})

test_that("TelegramBaseClient$get_proxy returns proxy after set_proxy", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    client <- TelegramBaseClient$new(
      session = NULL,
      api_id = 1,
      api_hash = "hash",
      receive_updates = FALSE
    )
    px <- list("http", "127.0.0.1", 8080)
    client$set_proxy(px)
    result <- client$get_proxy()
    expect_identical(result, px)
  })
})

test_that("TelegramBaseClient construction with explicit session list", {
  skip_on_cran()
  withr::with_options(list(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE), {
    sess <- list(
      dc_id = 2L,
      server_address = "149.154.167.51",
      port = 443L,
      auth_key = NULL,
      memory = TRUE
    )
    client <- TelegramBaseClient$new(
      session = sess,
      api_id = 99,
      api_hash = "abc",
      receive_updates = FALSE
    )
    expect_false(client$is_connected())
    expect_null(client$get_session_path())
  })
})
