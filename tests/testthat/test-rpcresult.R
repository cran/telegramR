test_that("RpcResult initializes correctly", {
  result <- RpcResult$new(req_msg_id = 12345, body = "test_body", error = NULL)
  expect_equal(result$req_msg_id, 12345)
  expect_equal(result$body, "test_body")
  expect_null(result$error)
})

test_that("RpcResult from_reader handles RpcError correctly", {
  mock_reader <- list(
    read_long = function() 12345,
    read_int = function(signed = TRUE) {
      if (isTRUE(!signed)) {
        return(0x2144ca19)
      }
      return(123L)
    },
    tgread_string = function() "FLOOD_WAIT_23",
    seek = function(offset) NULL,
    read = function() NULL
  )

  # Access from_reader via private_methods
  from_reader_fn <- RpcResult$private_methods$from_reader
  env <- new.env(parent = environment(from_reader_fn))
  env$RpcResult <- RpcResult
  env$RpcError <- if (exists("RpcError")) RpcError else NULL
  env$self <- list(new = function(...) RpcResult$new(...))
  environment(from_reader_fn) <- env

  result <- from_reader_fn(mock_reader)
  expect_equal(result$req_msg_id, 12345)
  expect_null(result$body)
  expect_true(!is.null(result$error))
})

test_that("RpcResult from_reader handles GzipPacked correctly", {
  compressed <- memCompress(charToRaw("mock_data"), type = "gzip")
  call_count <- 0L
  mock_reader <- list(
    read_long = function() 12345,
    read_int = function(signed = TRUE) {
      if (isTRUE(!signed)) {
        return(0x3072cfa1)
      }
      return(0L)
    },
    tgread_bytes = function() compressed,
    seek = function(offset) NULL,
    read = function() NULL
  )

  from_reader_fn <- RpcResult$private_methods$from_reader
  env <- new.env(parent = environment(from_reader_fn))
  env$RpcResult <- RpcResult
  env$RpcError <- if (exists("RpcError")) RpcError else NULL
  env$self <- list(new = function(...) RpcResult$new(...))
  environment(from_reader_fn) <- env

  result <- from_reader_fn(mock_reader)
  expect_equal(result$req_msg_id, 12345)
  expect_true(!is.null(result$body))
  expect_null(result$error)
})

test_that("RpcResult to_dict works correctly", {
  result <- RpcResult$new(req_msg_id = 12345, body = "test_body", error = "test_error")
  dict <- result$to_dict()
  expect_equal(dict$`_`, "RpcResult")
  expect_equal(dict$req_msg_id, 12345)
  expect_equal(dict$body, "test_body")
  expect_equal(dict$error, "test_error")
})
