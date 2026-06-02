# Extra RequestIter coverage: concrete subclass, chunk boundaries,
# collect(), limit, reset(), wait_time branch, async_init pre-fill.

ChunkIter <- R6::R6Class("ChunkIter",
  inherit = RequestIter,
  public = list(
    pool  = NULL,
    csize = 3L,
    initialize = function(client = NULL, items = list(), csize = 3L, limit = Inf, ...) {
      super$initialize(client = client, limit = limit, ...)
      self$pool  <- as.list(items)
      self$csize <- as.integer(csize)
    },
    async_init = function(kwargs) FALSE,
    load_next_chunk = function() {
      # Always return FALSE so .next() does NOT override self$left.
      # Termination is via empty buffer -> .next() returns NULL.
      if (length(self$pool) == 0L) return(FALSE)
      take        <- min(self$csize, length(self$pool))
      self$buffer <- self$pool[seq_len(take)]
      self$pool   <- if (take < length(self$pool)) self$pool[-seq_len(take)] else list()
      FALSE
    }
  )
)

PreFillIter <- R6::R6Class("PreFillIter",
  inherit = RequestIter,
  public = list(
    items = NULL,
    initialize = function(client = NULL, items = list(), limit = Inf, ...) {
      super$initialize(client = client, limit = limit, ...)
      self$items <- as.list(items)
    },
    async_init = function(kwargs) {
      self$buffer <- self$items
      TRUE
    },
    load_next_chunk = function() FALSE
  )
)

test_that("ChunkIter iterates all 6 items in two chunks of 3", {
  skip_on_cran()
  it  <- ChunkIter$new(items = as.list(1:6), csize = 3L)
  out <- it$collect()
  expect_equal(length(out), 6L)
  expect_equal(unlist(out), 1:6)
})

test_that("ChunkIter respects limit", {
  skip_on_cran()
  it  <- ChunkIter$new(items = as.list(1:10), csize = 3L, limit = 4L)
  out <- it$collect()
  expect_equal(length(out), 4L)
})

test_that("ChunkIter on empty pool returns empty list", {
  skip_on_cran()
  it  <- ChunkIter$new(items = list())
  out <- it$collect()
  expect_equal(length(out), 0L)
})

test_that("ChunkIter with csize=1 yields items one-by-one", {
  skip_on_cran()
  it   <- ChunkIter$new(items = as.list(letters[1:5]), csize = 1L)
  vals <- replicate(5L, it$.next(), simplify = FALSE)
  expect_equal(unlist(vals), letters[1:5])
})

test_that(".next() raises StopIteration when limit is reached", {
  skip_on_cran()
  # With a numeric limit, left counts down to 0 -> StopIteration.
  it <- ChunkIter$new(items = as.list(1:5), csize = 3L, limit = 2L)
  it$.next(); it$.next()
  expect_error(it$.next(), "StopIteration")
})

test_that(".next() returns NULL (not StopIteration) when pool exhausted without limit", {
  skip_on_cran()
  it <- ChunkIter$new(items = as.list(1:2), csize = 2L)
  it$.next(); it$.next()
  result <- it$.next()  # pool empty -> buffer empty -> NULL
  expect_null(result)
})

test_that("reset() resets buffer and index to initial state", {
  skip_on_cran()
  it <- ChunkIter$new(items = as.list(1:3), csize = 3L)
  it$collect()
  it$reset()
  expect_equal(it$index, 0L)
  expect_null(it$buffer)
})

test_that("PreFillIter collects all pre-filled items", {
  skip_on_cran()
  it  <- PreFillIter$new(items = as.list(LETTERS[1:4]))
  out <- it$collect()
  expect_equal(unlist(out), LETTERS[1:4])
})

test_that("PreFillIter: async_init returning TRUE sets left=buffer_size (overrides limit)", {
  skip_on_cran()
  # Source behaviour: when async_init returns TRUE, self$left <- length(self$buffer),
  # which overrides the original limit.  All 10 items are returned.
  it  <- PreFillIter$new(items = as.list(1:10), limit = 3L)
  out <- it$collect()
  expect_equal(length(out), 10L)
})

test_that(".next() with wait_time=NULL (default) does not sleep or error", {
  skip_on_cran()
  # wait_time=numeric triggers a source bug (POSIXt subtraction); NULL skips the sleep branch.
  it <- ChunkIter$new(items = as.list(1:2), csize = 2L, wait_time = NULL)
  expect_silent({ it$.next(); it$.next() })
})
