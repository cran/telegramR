test_that("initialize sets defaults", {
  skip_on_cran()
  it <- RequestIter$new(client = "cli")
  expect_equal(it$client, "cli")
  expect_false(it$reverse)
  expect_null(it$wait_time)
  expect_equal(it$kwargs, list())
  expect_equal(it$limit, Inf)
  expect_equal(it$left, Inf)
  expect_null(it$buffer)
  expect_equal(it$index, 0)
})

test_that("limit handling with NULL and negative values", {
  skip_on_cran()
  it_null <- RequestIter$new(client = NULL, limit = NULL)
  expect_equal(it_null$limit, Inf)

  it_neg <- RequestIter$new(client = NULL, limit = -5)
  expect_equal(it_neg$limit, 0)
  expect_equal(it_neg$left, 0)
})

test_that("abstract methods raise informative errors", {
  skip_on_cran()
  it <- RequestIter$new(client = 1)
  expect_error(it$async_init(), "async_init must be implemented in a subclass")
  expect_error(it$load_next_chunk(), "load_next_chunk must be implemented in a subclass")
})

test_that(".next returns items from the buffer and updates internal state", {
  skip_on_cran()
  it <- RequestIter$new(client = 1, limit = 5)
  # Pre-fill buffer to avoid async futures in this unit test
  it$buffer <- list("a", "b")
  it$left <- 5
  it$index <- 0

  expect_equal(it$.next(), "a")
  expect_equal(it$index, 1)
  expect_equal(it$left, 4)

  expect_equal(it$.next(), "b")
  expect_equal(it$index, 2)
  expect_equal(it$left, 3)

  # Next call should attempt to load next chunk, but since buffer will be empty, StopIteration is expected
  expect_error(it$.next(), "StopIteration")
})

test_that("collect gathers all buffered items until StopIteration", {
  skip_on_cran()
  it <- RequestIter$new(client = 1, limit = 2)
  it$buffer <- list(10, 20)
  it$left <- 2
  it$index <- 0

  res <- it$collect()
  expect_equal(res, list(10, 20))
})

test_that("reset restores initial iterator state", {
  skip_on_cran()
  it <- RequestIter$new(client = 1, limit = 3)
  it$buffer <- list(1)
  it$index <- 1
  it$last_load <- Sys.time()
  it$left <- 1

  it$reset()
  expect_null(it$buffer)
  expect_equal(it$index, 0)
  expect_equal(it$last_load, 0)
  expect_equal(it$left, it$limit)
})
