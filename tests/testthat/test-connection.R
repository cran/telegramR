port <- 443
ip <- "149.154.167.220"

test_that("initializes connection with valid parameters", {
  connection <- Connection$new(ip = ip, port = port, dc_id = 1)

  expect_equal(connection$.__enclos_env__$private$._ip, ip)
  expect_equal(connection$.__enclos_env__$private$._port, port)
  expect_equal(connection$.__enclos_env__$private$._dc_id, 1)
  expect_false(connection$.__enclos_env__$private$._connected)
  connection$disconnect()
})

test_that("connects to server successfully", {
  skip_on_cran()
  skip_if_no_integration()
  connection <- Connection$new(ip = ip, port = port, dc_id = 1)

  # result <- value(connection$connect())
  result <- connection$connect() %>%
    {
      .$then
    } %>%
    environment() %>%
    {
      .$private$value
    }
  expect_true(result)
  expect_true(connection$.__enclos_env__$private$._connected)
})

test_that("throws error when sending data while disconnected", {
  connection <- Connection$new(ip = ip, port = port, dc_id = 1)

  expect_error(connection$send("data"), "ConnectionError: Not connected")
})

test_that("disconnects successfully", {
  skip_on_cran()
  skip_if_no_integration()
  connection <- Connection$new(ip = ip, port = port, dc_id = 1)

  connection$connect()
  result <- value(connection$disconnect())
  expect_null(result)
  expect_false(connection$.__enclos_env__$private$._connected)
})

test_that("handles proxy configuration correctly", {
  skip_on_cran()
  skip_if_no_integration()
  proxy <- list(proxy_type = "socks5", addr = ip, port = 443)
  connection <- Connection$new(ip = ip, port = port, dc_id = 1, proxy = proxy)

  result <- value(connection$connect())
  expect_true(result)
})

test_that("receives data successfully", {
  skip_on_cran()
  skip_if_no_integration()
  connection <- Connection$new(ip = ip, port = port, dc_id = 1)

  connection$connect()
  promise <- connection$recv()
  expect_true(inherits(promise, "promise"))
})

test_that("throws error when receiving data while disconnected", {
  connection <- Connection$new(ip = ip, port = port, dc_id = 1)

  expect_error(value(connection$recv()), "ConnectionError: Not connected")
})

test_that("handles SSL configuration correctly", {
  skip_on_cran()
  skip_if_no_integration()
  connection <- Connection$new(ip = ip, port = port, dc_id = 1)

  result <- value(connection$connect(ssl = TRUE))
  expect_true(result)
})
