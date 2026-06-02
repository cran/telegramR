test_that("packInt32 and packInt64 packing/unpacking works", {
  skip_on_cran()
  # Little-endian expectations
  expect_equal(packInt32(1), as.raw(c(1, 0, 0, 0)))
  expect_equal(packInt32(256), as.raw(c(0, 1, 0, 0)))

  expect_error(packInt32(c(1, 2)))
  expect_error(packInt32(NA))

  expect_equal(unpackInt64(packInt64(1)), 1)
  expect_equal(unpackInt64(packInt64(256)), 256)
})

test_that("OpaqueRequest stores bytes and returns them via to_bytes", {
  skip_on_cran()
  r <- as.raw(1:5)
  o <- OpaqueRequest$new(r)
  expect_equal(o$to_bytes(), r)
})

test_that("packRandomBytes and packRandomLong produce correct lengths and types", {
  skip_on_cran()
  expect_length(packRandomBytes(0), 0)
  rb <- packRandomBytes(10)
  expect_true(is.raw(rb))
  expect_length(rb, 10)

  rl <- packRandomLong()
  expect_true(is.raw(rl))
  expect_length(rl, 8)
})

test_that("unpackInt64 errors on wrong input length", {
  skip_on_cran()
  expect_error(unpackInt64(raw(7)))
  expect_error(unpackInt64(raw(9)))
})
