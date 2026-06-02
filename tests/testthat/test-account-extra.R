test_that("AccountMethods initializes", {
  skip_on_cran()
  acc <- AccountMethods$new(client = list())
  expect_true(is.list(acc$client))
})

test_that("TakeoutClient success accessors work", {
  skip_on_cran()
  tc <- TakeoutClient$new(finalize = FALSE, client = list(session = list()), request = NULL)

  expect_null(tc$get_success())
  tc$set_success(TRUE)
  expect_true(tc$get_success())
})

test_that("TakeoutClient aenter/aexit and call work with fake client", {
  skip_on_cran()
  calls <- list()
  fake_client <- new.env(parent = emptyenv())
  fake_client$session <- list(takeout_id = NULL)
  fake_client$invoke <- function(req, ordered = FALSE) {
    calls[[length(calls) + 1L]] <<- req
    if (is.list(req) && !is.null(req$id)) return(req)
    TRUE
  }

  request <- list(id = 1)
  tc <- TakeoutClient$new(finalize = TRUE, client = fake_client, request = request)

  tc$aenter()
  expect_true(!is.null(fake_client$session$takeout_id))

  req <- new.env(parent = emptyenv())
  class(req) <- "TLRequest"
  req$resolve <- function(self, utils) NULL
  fake_client$invoke <- function(req, ordered = FALSE) {
    calls[[length(calls) + 1L]] <<- req
    TRUE
  }
  tc$call(req)

  tc$aexit(NULL, NULL, NULL)
  expect_true(is.null(fake_client$session$takeout_id))
})

test_that("TakeoutClient aenter rejects nested request on active takeout", {
  skip_on_cran()
  fake_client <- new.env(parent = emptyenv())
  fake_client$session <- list(takeout_id = 123)
  fake_client$invoke <- function(req, ordered = FALSE) TRUE

  tc <- TakeoutClient$new(finalize = TRUE, client = fake_client, request = list(id = 1))
  expect_error(tc$aenter(), "another takeout")
})

test_that("TakeoutClient aexit sets success from exception state", {
  skip_on_cran()
  local({
    FinishTakeoutSessionRequest <- function(success) list(kind = "finish", success = success)

    seen <- list()
    fake_client <- new.env(parent = emptyenv())
    fake_client$session <- list(takeout_id = 999)
    fake_client$invoke <- function(req, ordered = FALSE) {
      seen[[length(seen) + 1L]] <<- req
      TRUE
    }

    tc <- TakeoutClient$new(finalize = TRUE, client = fake_client, request = NULL)
    tc$aexit("error", NULL, NULL)

    expect_false(tc$get_success())
    expect_true(is.null(fake_client$session$takeout_id))
    expect_equal(seen[[1]]$success, FALSE)
  })
})

test_that("TakeoutClient aexit errors when finish request fails", {
  skip_on_cran()
  local({
    FinishTakeoutSessionRequest <- function(success) list(kind = "finish", success = success)

    fake_client <- new.env(parent = emptyenv())
    fake_client$session <- list(takeout_id = 999)
    fake_client$invoke <- function(req, ordered = FALSE) FALSE

    tc <- TakeoutClient$new(finalize = TRUE, client = fake_client, request = NULL)
    tc$set_success(TRUE)

    expect_error(tc$aexit(NULL, NULL, NULL), "Failed to finish the takeout")
  })
})

test_that("TakeoutClient call validates takeout mode and request types", {
  skip_on_cran()
  fake_client <- new.env(parent = emptyenv())
  fake_client$session <- list(takeout_id = NULL)
  fake_client$invoke <- function(req, ordered = FALSE) TRUE

  tc <- TakeoutClient$new(finalize = FALSE, client = fake_client, request = NULL)
  expect_error(tc$call(list()), "Takeout mode has not been initialized")

  fake_client$session$takeout_id <- 321
  expect_error(tc$call(list(list())), "_NOT_A_REQUEST")
})

test_that("TakeoutClient delegates get_attr and set_attr to client", {
  skip_on_cran()
  store <- new.env(parent = emptyenv())
  store$plain <- 5

  fake_client <- new.env(parent = emptyenv())
  fake_client$session <- list(takeout_id = 1)
  fake_client$invoke <- function(req, ordered = FALSE) TRUE
  fake_client$get_attr <- function(name) {
    if (identical(name, "plain")) return(store$plain)
    if (identical(name, "adder")) return(function(self, x) x + 1)
    NULL
  }
  fake_client$set_attr <- function(name, value) {
    store[[name]] <- value
  }

  tc <- TakeoutClient$new(finalize = FALSE, client = fake_client, request = NULL)
  expect_equal(tc$get_attr("plain"), 5)
  expect_equal(tc$get_attr("adder")(10), 11)

  tc$set_attr("plain", 9)
  expect_equal(store$plain, 9)
})

test_that("TakeoutClient aexit is a no-op when not finalizing and success unset", {
  skip_on_cran()
  fake_client <- new.env(parent = emptyenv())
  fake_client$session <- list(takeout_id = 555)
  invoked <- FALSE
  fake_client$invoke <- function(req, ordered = FALSE) {
    invoked <<- TRUE
    TRUE
  }

  tc <- TakeoutClient$new(finalize = FALSE, client = fake_client, request = NULL)
  expect_null(tc$aexit(NULL, NULL, NULL))
  expect_false(invoked)
  expect_equal(fake_client$session$takeout_id, 555)
})
