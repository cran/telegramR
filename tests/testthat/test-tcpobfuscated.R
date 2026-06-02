test_that("initializes ObfuscatedIO with valid connection parameters", {
  skip_on_cran()
  connection <- list(
    `_reader` = list(readexactly = function(n) raw(n)),
    `_writer` = list(write = function(data) invisible(data)),
    packet_codec = list(obfuscate_tag = as.raw(c(0xee, 0xee, 0xee, 0xee)))
  )

  io <- ObfuscatedIO$new(connection)
  expect_equal(length(io$header), 64)
  expect_true(inherits(io$.encrypt, "AESModeCTR"))
  expect_true(inherits(io$.decrypt, "AESModeCTR"))
})

test_that("throws error when ObfuscatedIO is initialized without packet codec", {
  skip_on_cran()
  connection <- list(
    `_reader` = list(readexactly = function(n) raw(n)),
    `_writer` = list(write = function(data) invisible(data))
  )

  expect_error(ObfuscatedIO$new(connection))
})

test_that("reads and decrypts data correctly in ObfuscatedIO", {
  skip_on_cran()
  connection <- list(
    `_reader` = list(readexactly = function(n) raw(n)),
    `_writer` = list(write = function(data) invisible(data)),
    packet_codec = list(obfuscate_tag = as.raw(c(0xee, 0xee, 0xee, 0xee)))
  )

  io <- ObfuscatedIO$new(connection)
  result <- io$readexactly(10)
  expect_equal(length(result), 10)
})

test_that("encrypts and writes data correctly in ObfuscatedIO", {
  skip_on_cran()
  connection <- list(
    `_reader` = list(readexactly = function(n) raw(n)),
    `_writer` = list(write = function(data) data),
    packet_codec = list(obfuscate_tag = as.raw(c(0xee, 0xee, 0xee, 0xee)))
  )

  io <- ObfuscatedIO$new(connection)
  data <- raw(10)
  result <- io$write(data)
  expect_equal(length(result), 10)
})

test_that("throws error when header initialization fails due to invalid random bytes", {
  skip_on_cran()
  connection <- list(
    `_reader` = list(readexactly = function(n) raw(n)),
    `_writer` = list(write = function(data) invisible(data)),
    packet_codec = list(obfuscate_tag = as.raw(c(0xee, 0xee, 0xee, 0xee)))
  )

  # Replace rand_bytes in the package namespace temporarily.
  pkg_ns <- asNamespace("telegramR")
  if (!exists("rand_bytes", envir = pkg_ns, inherits = FALSE)) {
    skip("rand_bytes not found in package namespace; cannot run this test")
  }

  orig_rand <- get("rand_bytes", envir = pkg_ns)
  mock_rand_bytes <- function(n) as.raw(rep(0xef, n))

  # inject mock and ensure restore on exit
  assignInNamespace("rand_bytes", mock_rand_bytes, ns = "telegramR")
  on.exit(assignInNamespace("rand_bytes", orig_rand, ns = "telegramR"), add = TRUE)

  expect_error(ObfuscatedIO$new(connection), "Failed to generate valid header")
})
