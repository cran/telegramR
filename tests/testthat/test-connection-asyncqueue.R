test_that("AsyncQueue put/get works for bounded and unbounded queues", {
  skip_on_cran()
  testthat::skip_if_not_installed("later")
  library(later)

  q <- AsyncQueue$new()
  future::value(q$put(1))
  expect_equal(future::value(q$get()), 1)

  q2 <- AsyncQueue$new(maxsize = 1)
  future::value(q2$put("a"))
  # enqueue second item; should wait until space
  p <- q2$put("b")
  expect_equal(future::value(q2$get()), "a")
  expect_true(isTRUE(future::value(p)))
  expect_equal(future::value(q2$get()), "b")
})
