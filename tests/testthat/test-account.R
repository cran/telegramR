test_that("handles successful takeout initialization", {
  skip_on_cran()
  client <- new.env()
  session <- new.env()
  request <- new.env()

  client$session <- session
  session$takeout_id <- NULL
  request$id <- 12345

  client$invoke <- function(req) request

  takeout <- TakeoutClient$new(TRUE, client, request)
  result <- takeout$aenter()

  expect_equal(client$session$takeout_id, 12345)
  expect_equal(result, takeout)
})

test_that("handles successful takeout exit", {
  skip_on_cran()
  client <- new.env()
  session <- new.env()

  client$session <- session
  session$takeout_id <- 12345

  client$invoke <- function(req) TRUE

  takeout <- TakeoutClient$new(TRUE, client, NULL)
  takeout$aexit(NULL, NULL, NULL)

  expect_null(client$session$takeout_id)
})

test_that("throws error when takeout exit fails", {
  skip_on_cran()
  client <- new.env()
  session <- new.env()

  client$session <- session
  session$takeout_id <- 12345

  client$invoke <- function(req) FALSE

  takeout <- TakeoutClient$new(TRUE, client, NULL)

  expect_error(takeout$aexit(NULL, NULL, NULL), "Failed to finish the takeout.")
})
