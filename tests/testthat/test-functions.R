test_that("xor_bytes behaves correctly", {
  # basic XOR of two equal-length vectors
  expect_equal(xor_bytes(as.raw(c(0xff, 0x0f)), as.raw(c(0x0f, 0x00))), as.raw(c(0xf0, 0x0f)))
  # zero-length input
  expect_equal(xor_bytes(raw(0), raw(0)), raw(0))
  # different lengths: result length is min length
  expect_equal(xor_bytes(as.raw(c(0x01)), as.raw(c(0x02, 0x03))), as.raw(0x03))
})

test_that("AES encrypt/decrypt roundtrip for single block", {
  # Use deterministic data: a single 16-byte block (no padding)
  key <- as.raw(as.integer(seq_len(32)))
  iv  <- as.raw(as.integer(seq_len(32)))
  plain <- as.raw(as.integer(seq_len(16)))

  aes_obj <- AES$new()
  cipher <- aes_obj$encrypt_ige(plain, key, iv)
  decrypted <- aes_obj$decrypt_ige(cipher, key, iv)
  expect_equal(decrypted, plain)
})

test_that("big_num_for_hash returns 256 bytes and encodes small numbers correctly", {
  bn1 <- big_num_for_hash(1)
  expect_length(bn1, 256)
  expect_equal(tail(bn1, 1), as.raw(1))
})

test_that("AES class is exported and is an R6 generator", {
  expect_true(exists("AES"))
  expect_true(inherits(AES, "R6ClassGenerator"))
})
