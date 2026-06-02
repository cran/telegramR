test_that("DestroyAuthKeyRequest serialization works", {
  skip_on_cran()
  req <- DestroyAuthKeyRequest$new()
  expect_equal(req$to_list(), list("_" = "DestroyAuthKeyRequest"))
  expect_equal(req$to_bytes(), as.raw(c(0x60, 0x51, 0x43, 0xd1)))
})

test_that("DestroySessionRequest serialization works", {
  skip_on_cran()
  session_id <- 1234567890123456789
  req <- DestroySessionRequest$new(session_id = session_id)
  expect_equal(req$to_list(), list("_" = "DestroySessionRequest", session_id = session_id))
  expect_equal(req$to_bytes(), c(as.raw(c(0x26, 0x21, 0x51, 0xe7)), writeBin(as.integer64(session_id), raw(), size = 8, endian = "little")))
})

test_that("GetFutureSaltsRequest serialization works", {
  skip_on_cran()
  num <- 5
  req <- GetFutureSaltsRequest$new(num = num)
  expect_equal(req$to_list(), list("_" = "GetFutureSaltsRequest", num = num))
  expect_equal(req$to_bytes(), c(as.raw(c(0x04, 0xbd, 0x21, 0xb9)), writeBin(as.integer(num), raw(), size = 4, endian = "little")))
})

test_that("InitConnectionRequest serialization works", {
  skip_on_cran()
  query <- DestroyAuthKeyRequest$new()
  req <- InitConnectionRequest$new(
    api_id = 12345,
    device_model = "TestDevice",
    system_version = "1.0",
    app_version = "1.0",
    system_lang_code = "en",
    lang_pack = "",
    lang_code = "en",
    query = query
  )
  expect_equal(req$to_list()$query, query$to_list())
  expect_true(is.raw(req$to_bytes()))
})

test_that("InvokeAfterMsgRequest serialization works", {
  skip_on_cran()
  msg_id <- 1234567890123456789
  query <- DestroyAuthKeyRequest$new()
  req <- InvokeAfterMsgRequest$new(msg_id = msg_id, query = query)
  expect_equal(req$to_list(), list("_" = "InvokeAfterMsgRequest", msg_id = msg_id, query = query$to_list()))
  expect_true(is.raw(req$to_bytes()))
})

test_that("InvokeAfterMsgsRequest serialization works", {
  skip_on_cran()
  msg_ids <- list(1234567890123456789, 9876543210987654321)
  query <- DestroyAuthKeyRequest$new()
  req <- InvokeAfterMsgsRequest$new(msg_ids = msg_ids, query = query)
  expect_equal(req$to_list()$msg_ids, msg_ids)
  expect_true(is.raw(req$to_bytes()))
})

test_that("PingRequest serialization works", {
  skip_on_cran()
  ping_id <- 1234567890123456789
  req <- PingRequest$new(ping_id = ping_id)
  expect_equal(req$to_list(), list("_" = "PingRequest", ping_id = ping_id))
  expect_true(is.raw(req$to_bytes()))
})

test_that("PingDelayDisconnectRequest serialization works", {
  skip_on_cran()
  ping_id <- 1234567890123456789
  disconnect_delay <- 10
  req <- PingDelayDisconnectRequest$new(ping_id = ping_id, disconnect_delay = disconnect_delay)
  expect_equal(req$to_list(), list("_" = "PingDelayDisconnectRequest", ping_id = ping_id, disconnect_delay = disconnect_delay))
  expect_true(is.raw(req$to_bytes()))
})

test_that("ReqPqRequest serialization works", {
  skip_on_cran()
  nonce <- as.raw(rep(0x01, 16))
  req <- ReqPqRequest$new(nonce = nonce)
  expect_equal(req$to_list(), list("_" = "ReqPqRequest", nonce = nonce))
  expect_true(is.raw(req$to_bytes()))
})

test_that("RpcDropAnswerRequest serialization works", {
  skip_on_cran()
  req_msg_id <- 1234567890123456789
  req <- RpcDropAnswerRequest$new(req_msg_id = req_msg_id)
  expect_equal(req$to_list(), list("_" = "RpcDropAnswerRequest", req_msg_id = req_msg_id))
  expect_true(is.raw(req$to_bytes()))
})
