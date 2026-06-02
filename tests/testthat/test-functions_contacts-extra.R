test_that("DeleteByPhonesRequest covers empty and populated vectors", {
  skip_on_cran()
  req <- DeleteByPhonesRequest$new(c("1", "22"))
  expect_equal(
    req$to_list(),
    list("_" = "DeleteByPhonesRequest", phones = c("1", "22"))
  )
  expect_equal(
    req$to_bytes(),
    c(
      as.raw(c(0x9e, 0xfd, 0x13, 0x10)),
      as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
      writeBin(2L, raw(), size = 4, endian = "little"),
      serialize_bytes("1"),
      serialize_bytes("22")
    )
  )

  empty_req <- DeleteByPhonesRequest$new(NULL)
  expect_equal(
    empty_req$to_list(),
    list("_" = "DeleteByPhonesRequest", phones = character(0))
  )
  expect_equal(
    empty_req$to_bytes(),
    c(
      as.raw(c(0x9e, 0xfd, 0x13, 0x10)),
      as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
      writeBin(0L, raw(), size = 4, endian = "little")
    )
  )
})

test_that("GetContactIDsRequest handles read_result branches", {
  skip_on_cran()
  req <- GetContactIDsRequest$new(42)
  expect_equal(req$to_list(), list("_" = "GetContactIDsRequest", hash = 42))
  expect_equal(
    req$to_bytes(),
    as.raw(c(0x9d, 0x66, 0xdc, 0x7a, 0x2a, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00))
  )

  reader_empty <- new.env(parent = emptyenv())
  ints_empty <- c(0x1cb5c415L, 0L)
  idx_empty <- 0L
  reader_empty$read_int <- function() {
    idx_empty <<- idx_empty + 1L
    ints_empty[[idx_empty]]
  }
  expect_equal(GetContactIDsRequest$read_result(reader_empty), integer(0))

  reader_full <- new.env(parent = emptyenv())
  ints_full <- c(0x1cb5c415L, 3L, 7L, 8L, 9L)
  idx_full <- 0L
  reader_full$read_int <- function() {
    idx_full <<- idx_full + 1L
    ints_full[[idx_full]]
  }
  expect_equal(GetContactIDsRequest$read_result(reader_full), c(7L, 8L, 9L))
})

test_that("GetStatusesRequest remains a fixed request", {
  skip_on_cran()
  req <- GetStatusesRequest$new()
  expect_equal(req$to_list(), list("_" = "GetStatusesRequest"))
  expect_equal(req$to_bytes(), as.raw(c(0xee, 0x53, 0xa3, 0xc4)))
})
