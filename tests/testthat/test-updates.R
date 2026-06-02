test_that("get_running_loop returns a POSIXt-like time", {
  skip_on_cran()
  t <- get_running_loop()
  expect_true(inherits(t, "POSIXt") || inherits(t, "POSIXct"))
  # Should be recent (within 5 seconds)
  expect_true(as.numeric(difftime(Sys.time(), t, units = "secs")) < 5)
})


test_that("EventBuilderDict caches built events and handles EventCommon instances", {
  skip_on_cran()
  EventCommon <- R6::R6Class("EventCommon",
    public = list(
      original_update = NULL,
      entities = NULL,
      client_set = NULL,
      set_client = function(c) {
        self$client_set <- c
      }
    )
  )

  build_count <- 0
  builder <- list()
  builder$build <- function(update, others, self_id) {
    build_count <<- build_count + 1
    # reference parameters to avoid unused-parameter warnings
    invisible(update); invisible(others); invisible(self_id)
    # return a new EventCommon instance
    EventCommon$new()
  }

  client <- list(self_id = 999)
  update <- list(entities = list("e1"))
  others <- list()

  eb <- EventBuilderDict$new(client = client, update = update, others = others)

  ev1 <- eb$get(builder)
  expect_true(inherits(ev1, "EventCommon"))
  expect_equal(build_count, 1)
  # Fields should be set by get()
  expect_identical(ev1$original_update, update)
  expect_identical(ev1$entities, update$entities)
  expect_identical(ev1$client_set, client)

  # Second call should return cached object and not increase build_count
  ev2 <- eb$get(builder)
  expect_identical(ev1, ev2)
  expect_equal(build_count, 1)
})


test_that("EventBuilderDict assigns client to non-EventCommon objects and caches them", {
  skip_on_cran()
  build_count2 <- 0
  builder2 <- list()
  builder2$build <- function(update, others, self_id) {
    build_count2 <<- build_count2 + 1
    # reference parameters to avoid unused-parameter warnings
    invisible(update); invisible(others); invisible(self_id)
    # return a plain list-like event
    list(type = "plain", payload = update)
  }

  client <- list(self_id = 5)
  update <- list(entities = NULL)
  eb2 <- EventBuilderDict$new(client = client, update = update, others = list())
  ev_plain1 <- eb2$get(builder2)
  expect_equal(build_count2, 1)
  # plain event should have client set as a list element
  expect_identical(ev_plain1$client, client)

  # cached on second call: ensure build_count didn't increase and core data matches
  ev_plain2 <- eb2$get(builder2)
  expect_equal(build_count2, 1)
  expect_equal(ev_plain1$type, ev_plain2$type)
  expect_equal(ev_plain1$payload, ev_plain2$payload)
})
