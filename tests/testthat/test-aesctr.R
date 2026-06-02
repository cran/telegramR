test_that("AESModeCTR initializes correctly", {
  key <- as.raw(1:16) # Example 16-byte key
  iv <- as.raw(1:16) # Example 16-byte IV

  aes <- AESModeCTR$new(key, iv)
  expect_true(!is.null(aes))
})

test_that("AESModeCTR encrypts and decrypts correctly", {
  key <- as.raw(1:16) # Example 16-byte key
  iv <- as.raw(1:16) # Example 16-byte IV
  data <- charToRaw("Hello, World!!!") # Example plaintext

  aes <- AESModeCTR$new(key, iv)
  encrypted <- aes$encrypt(data)
  expect_true(!is.null(encrypted))
  expect_true(is.raw(encrypted))

  decrypted <- aes$decrypt(encrypted)
  expect_equal(decrypted, data)
})

test_that("AESModeCTR fails with invalid key or IV", {
  invalid_key <- as.raw(1:15) # Invalid key (not 16 bytes)
  valid_iv <- as.raw(1:16) # Valid IV
  expect_error(AESModeCTR$new(invalid_key, valid_iv))

  valid_key <- as.raw(1:16) # Valid key
  invalid_iv <- as.raw(1:15) # Invalid IV (not 16 bytes)
  expect_error(AESModeCTR$new(valid_key, invalid_iv))
})
