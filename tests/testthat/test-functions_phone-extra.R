test_that("phone request helpers cover fixed and resolving requests", {
  skip_on_cran()
  config <- GetCallConfigRequest$new()
  expect_equal(config$to_list(), list("_" = "GetCallConfigRequest"))
  expect_equal(config$bytes(), int_to_raw_le(0x55451fa9, 4L))

  call_obj <- new.env(parent = emptyenv())
  call_obj$bytes <- function() as.raw(c(0x01, 0x02, 0x03))
  call_obj$to_list <- function() list(kind = "call")

  req <- GetGroupCallRequest$new(call = "raw-call", limit = 5L)
  utils <- new.env(parent = emptyenv())
  utils$get_input_group_call <- function(x) {
    expect_equal(x, "raw-call")
    call_obj
  }

  req$resolve(client = NULL, utils = utils)
  expect_equal(req$to_list(), list("_" = "GetGroupCallRequest", call = list(kind = "call"), limit = 5L))
  expect_equal(
    req$bytes(),
    c(int_to_raw_le(0x041845db, 4L), as.raw(c(0x01, 0x02, 0x03)), int_to_raw_le(5L, 4L))
  )
})

test_that("phone requests warn when dependent objects cannot serialize", {
  skip_on_cran()
  bad_call_req <- GetGroupCallRequest$new(call = list(), limit = 1L)
  expect_warning(bad_call_req$bytes(), "call does not implement bytes")
  expect_equal(suppressWarnings(bad_call_req$bytes()), raw(0))

  peer_obj <- new.env(parent = emptyenv())
  peer_obj$bytes <- function() as.raw(c(0x09, 0x08))
  peer_obj$to_list <- function() list(kind = "peer")

  join_as <- GetGroupCallJoinAsRequest$new("peer-ref")
  utils <- new.env(parent = emptyenv())
  utils$get_input_peer <- function(x) {
    expect_equal(x, "peer-ref")
    peer_obj
  }

  join_as$resolve(client = NULL, utils = utils)
  expect_equal(join_as$to_list(), list("_" = "GetGroupCallJoinAsRequest", peer = list(kind = "peer")))
  expect_equal(join_as$bytes(), c(int_to_raw_le(0xef7c213a, 4L), as.raw(c(0x09, 0x08))))

  bad_peer_req <- GetGroupCallJoinAsRequest$new(list())
  expect_warning(bad_peer_req$bytes(), "peer does not implement bytes")
  expect_equal(suppressWarnings(bad_peer_req$bytes()), raw(0))
})
