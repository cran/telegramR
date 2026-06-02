test_that("MessagePacker initializes with valid state and loggers", {
  skip_on_cran()
  state <- list(write_data_as_message = function(...) {})
  loggers <- list(messagepacker = list(debug = function(...) {}, warning = function(...) {}))
  packer <- MessagePacker$new(state, loggers)

  expect_equal(packer$state, state)
  expect_equal(packer$log, loggers$messagepacker)
  expect_equal(packer$ready, FALSE)
  expect_equal(length(packer$deque), 0)
})

test_that("appends a single state item to the queue", {
  skip_on_cran()
  packer <- MessagePacker$new(state = NULL)
  state_item <- list(data = "test")

  packer$append(state_item)

  expect_equal(length(packer$deque), 1)
  expect_equal(packer$deque[[1]], state_item)
  expect_true(packer$ready)
})

test_that("extends the queue with multiple state items", {
  skip_on_cran()
  packer <- MessagePacker$new(state = NULL)
  state_items <- list(list(data = "item1"), list(data = "item2"))

  packer$extend(state_items)

  expect_equal(length(packer$deque), 2)
  expect_equal(packer$deque[[1]], state_items[[1]])
  expect_equal(packer$deque[[2]], state_items[[2]])
  expect_true(packer$ready)
})

test_that("get method returns queued items", {
  skip_on_cran()
  state <- list(write_data_as_message = function(...) 12345)
  packer <- MessagePacker$new(state = state)

  packer$append(list(data = raw(10)))
  result <- packer$get()

  expect_equal(length(result[[1]]), 1)
  expect_equal(result[[1]][[1]]$msg_id, 12345)
  expect_true(is.raw(result[[2]]))
})

test_that("get method handles oversized payloads", {
  skip_on_cran()
  state <- list(write_data_as_message = function(...) 12345)
  log <- list(warning = function(...) {})
  packer <- MessagePacker$new(state = state, loggers = list(messagepacker = log))
  oversized_item <- list(data = raw(MessageContainer$MAXIMUM_SIZE + 1))

  packer$append(oversized_item)
  result <- packer$get()

  expect_null(result[[1]])
  expect_null(result[[2]])
})

test_that("batches multiple messages into a container", {
  skip_on_cran()
  state <- list(write_data_as_message = function(...) 12345)
  packer <- MessagePacker$new(state = state)
  items <- list(
    list(data = raw(10)),
    list(data = raw(10))
  )

  packer$extend(items)
  result <- packer$get()

  expect_equal(length(result[[1]]), 2)
  expect_true(is.raw(result[[2]]))
})
