test_that("BinaryReader works as expected", {
  # Sample binary data
  binary_data <- as.raw(c(0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A))

  # Initialize BinaryReader
  reader <- BinaryReader$new(binary_data)

  # Test read_byte
  expect_equal(reader$read_byte(), 1L)

  # Test read_int
  reader$set_position(0) # Reset position
  expect_equal(reader$read_int(), 67305985L) # Little-endian interpretation of 0x01, 0x02, 0x03, 0x04

  # Test read_long
  reader$set_position(0) # Reset position
  expect_equal(reader$read_long(), gmp::as.bigz("578437695752307201")) # Little-endian interpretation of 8 bytes

  # Test read
  reader$set_position(0) # Reset position
  expect_equal(reader$read(2), as.raw(c(0x01, 0x02)))

  # Test get_bytes
  expect_equal(reader$get_bytes(), binary_data)

  # Test tell_position
  expect_equal(reader$tell_position(), 2L)

  # Test set_position
  reader$set_position(4)
  expect_equal(reader$tell_position(), 4L)

  # Test seek
  reader$seek(2)
  expect_equal(reader$tell_position(), 6L)

  # Test close
  reader$close()
})
