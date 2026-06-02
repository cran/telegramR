test_that("encodes packet with random padding correctly", {
  skip_on_cran()
  codec <- RandomizedIntermediatePacketCodec$new()
  data <- raw(10)
  result <- codec$encode_packet(data)
  # Length prefix is 4 bytes little-endian, value = data + padding length
  total_len <- readBin(result[1:4], integer(), n = 1, size = 4, endian = "little")
  expect_equal(total_len, length(result) - 4)
  # Result should include original data plus 0-3 bytes of random padding
  expect_true(length(result) >= 14 && length(result) <= 17)
})

test_that("reads packet with random padding successfully", {
  skip_on_cran()
  skip_future_on_rdevel()
  codec <- RandomizedIntermediatePacketCodec$new()
  padded_data <- c(raw(10), as.raw(c(0x01, 0x02)))
  reader <- list(
    readexactly = function(n) {
      if (n == 4) {
        writeBin(as.integer(length(padded_data)), raw(), size = 4, endian = "little")
      } else {
        padded_data
      }
    }
  )
  result <- value(codec$read_packet(reader))
  expect_equal(length(result), 12) # 12 bytes padded_data, no padding stripped since 12 %% 4 == 0
})

test_that("throws error when reader fails to provide length prefix", {
  skip_on_cran()
  skip_future_on_rdevel()
  codec <- RandomizedIntermediatePacketCodec$new()
  reader <- list(
    readexactly = function(n) stop("ReadError: failed to read length prefix")
  )
  expect_error(value(codec$read_packet(reader)), "ReadError: failed to read length prefix")
})

test_that("throws error when reader fails to provide full packet data", {
  skip_on_cran()
  skip_future_on_rdevel()
  codec <- RandomizedIntermediatePacketCodec$new()
  reader <- list(
    readexactly = function(n) {
      if (n == 4) {
        writeBin(as.integer(20), raw(), size = 4, endian = "little")
      } else {
        stop("ReadError: failed to read full packet data")
      }
    }
  )
  expect_error(value(codec$read_packet(reader)), "ReadError: failed to read full packet data")
})
