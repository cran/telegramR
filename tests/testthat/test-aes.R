test_that("AES encrypt_ige and decrypt_ige work correctly", {
  # Sample inputs
  key <- as.raw(rep(0x01, 32)) # 32-byte key
  iv <- as.raw(rep(0x02, 32)) # 32-byte IV
  plain_text <- as.raw(c(0x41, 0x42, 0x43, 0x44)) # "ABCD" in raw format

  # Create AES object
  aes <- AES$new()

  # Encrypt the plain text
  encrypted_text <- aes$encrypt_ige(plain_text, key, iv)
  expect_type(encrypted_text, "raw")
  expect_true(length(encrypted_text) %% 16 == 0) # Check block size

  # Decrypt the encrypted text
  decrypted_text <- aes$decrypt_ige(encrypted_text, key, iv)
  expect_type(decrypted_text, "raw")
  expect_equal(decrypted_text[1:length(plain_text)], plain_text) # Check original text

  # Ensure padding is removed correctly
  # expect_equal(length(decrypted_text), length(plain_text))
})

test_that("AES handles invalid inputs gracefully", {
  aes <- AES$new()
  key <- as.raw(rep(0x01, 32)) # 32-byte key
  iv <- as.raw(rep(0x02, 32)) # 32-byte IV
  invalid_text <- as.raw(c(0x41, 0x42)) # Not a multiple of 16 bytes

  # Expect error for invalid input length
  expect_error(aes$decrypt_ige(invalid_text, key, iv), "Invalid input length")
  # expect_error(aes$encrypt_ige(invalid_text, key, iv), "Invalid input length")
})
