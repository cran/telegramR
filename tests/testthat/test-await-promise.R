# Tests for await_promise()

test_that("await_promise returns non-promise values immediately", {
  skip_on_cran()
  expect_equal(await_promise(42), 42)
  expect_null(await_promise(NULL))
  expect_equal(await_promise("hello"), "hello")
})

test_that("await_promise returns value of fulfilled promise", {
  skip_on_cran()
  p <- promises::promise(function(resolve, reject) resolve(99))
  expect_equal(await_promise(p, timeout = 5), 99)
})

test_that("await_promise returns complex value from fulfilled promise", {
  skip_on_cran()
  p <- promises::promise(function(resolve, reject) resolve(list(a = 1, b = 2)))
  result <- await_promise(p, timeout = 5)
  expect_equal(result$a, 1)
  expect_equal(result$b, 2)
})

test_that("await_promise re-raises error from rejected promise", {
  skip_on_cran()
  p <- promises::promise(function(resolve, reject) reject(simpleError("boom")))
  expect_error(await_promise(p, timeout = 5), "boom")
})

test_that("await_promise re-raises non-condition rejection as error", {
  skip_on_cran()
  p <- promises::promise(function(resolve, reject) reject("string error"))
  expect_error(await_promise(p, timeout = 5), "string error")
})

test_that("await_promise throws ReadTimeoutError when promise never resolves", {
  skip_on_cran()
  p <- promises::promise(function(resolve, reject) NULL)  # never resolves
  expect_error(await_promise(p, timeout = 0.01), "ReadTimeoutError")
})

test_that("await_promise timeout message includes the timeout duration", {
  skip_on_cran()
  p <- promises::promise(function(resolve, reject) NULL)
  expect_error(await_promise(p, timeout = 0.01), "0.0 seconds", fixed = TRUE)
})
