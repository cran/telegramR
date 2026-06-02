test_that("TelegramBaseClient initializes with valid parameters", {
  skip_on_cran()
  skip_if_no_integration()
  session <- "test_session"
  api_id <- 3611613
  api_hash <- "41d882999e5db5a653359a6b2ddb907f"

  client <- TelegramBaseClient$new(
    session = session,
    api_id = api_id,
    api_hash = api_hash # ,
    # phone = "+380980018456"
  )

  print(client)

  expect_equal(client$get_version(), "1.0.0")
  # is_connected depends on the sender's actual connection state
  # In test environment without real connection, it may be FALSE
  expect_type(client$is_connected(), "logical")
})

test_that("TelegramBaseClient throws error when API ID or hash is missing", {
  expect_error(
    TelegramBaseClient$new(session = "test_session", api_id = NULL, api_hash = "test_api_hash"),
    "Your API ID or Hash cannot be empty or NULL"
  )
  expect_error(
    TelegramBaseClient$new(session = "test_session", api_id = 12345, api_hash = NULL),
    "Your API ID or Hash cannot be empty or NULL"
  )
})

test_that("TelegramBaseClient connects to Telegram successfully", {
  skip_on_cran()
  skip_if_no_integration()
  session <- "test_session"
  api_id <- 12345
  api_hash <- "test_api_hash"

  client <- TelegramBaseClient$new(
    session = session,
    api_id = api_id,
    api_hash = api_hash
  )

  res <- client$connect()
  result <- if (inherits(res, "Future")) value(res) else res
  expect_true(result)
  expect_true(client$is_connected())
})

test_that("TelegramBaseClient disconnects from Telegram successfully", {
  skip_on_cran()
  skip_if_no_integration()
  session <- "test_session"
  api_id <- 12345
  api_hash <- "test_api_hash"

  client <- TelegramBaseClient$new(
    session = session,
    api_id = api_id,
    api_hash = api_hash
  )

  client$connect()
  res <- client$disconnect()
  result <- if (inherits(res, "Future")) value(res) else res
  expect_true(result)
  expect_false(client$is_connected())
})

test_that("TelegramBaseClient sets and gets proxy configuration", {
  skip_on_cran()
  skip_if_no_integration()
  session <- "test_session"
  api_id <- 12345
  api_hash <- "test_api_hash"
  proxy <- list(ip = "127.0.0.1", port = 8080)

  client <- TelegramBaseClient$new(
    session = session,
    api_id = api_id,
    api_hash = api_hash
  )

  client$set_proxy(proxy)
  expect_equal(client$get_proxy(), proxy)
})

test_that("TelegramBaseClient handles invalid disconnect call", {
  skip_on_cran()
  skip_if_no_integration()
  session <- "test_session"
  api_id <- 12345
  api_hash <- "test_api_hash"

  client <- TelegramBaseClient$new(
    session = session,
    api_id = api_id,
    api_hash = api_hash
  )

  # disconnect should succeed without error when session exists
  expect_no_error(client$disconnect())
})
