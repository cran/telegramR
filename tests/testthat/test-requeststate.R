test_that("creates RequestState with character request", {
  request <- "test request"
  state <- RequestState$new(request)
  expect_equal(state$request, request)
  expect_equal(state$data, charToRaw(request))
  expect_null(state$container_id)
  expect_null(state$msg_id)
  expect_null(state$after)
})

test_that("creates RequestState with raw request", {
  request <- charToRaw("test request")
  state <- RequestState$new(request)
  expect_equal(state$request, request)
  expect_equal(state$data, request)
  expect_null(state$container_id)
  expect_null(state$msg_id)
  expect_null(state$after)
})

test_that("creates RequestState with non-character non-raw request", {
  request <- list(a = 1, b = 2)
  state <- RequestState$new(request)
  expect_equal(state$request, request)
  expect_equal(state$data, serialize(request, NULL))
  expect_null(state$container_id)
  expect_null(state$msg_id)
  expect_null(state$after)
})

test_that("creates RequestState with after parameter", {
  request <- "test request"
  after <- "dependency"
  state <- RequestState$new(request, after)
  expect_equal(state$request, request)
  expect_equal(state$data, charToRaw(request))
  expect_equal(state$after, after)
  expect_null(state$container_id)
  expect_null(state$msg_id)
})

test_that("throws error when request is NULL", {
  expect_error(RequestState$new(NULL), "argument \"request\" is missing, with no default")
})
