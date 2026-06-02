test_that("AuthKey initialization works correctly", {
  key_data <- as.raw(1:32)
  auth_key <- AuthKey$new(data = key_data)

  expect_true(auth_key$is_valid())
  expect_equal(auth_key$active_key, key_data)
})

test_that("AuthKey calc_new_nonce_hash works correctly", {
  key_data <- as.raw(1:32)
  auth_key <- AuthKey$new(data = key_data)
  auth_key$active_key <- key_data

  new_nonce <- as.raw(rep(1, 32))
  number <- 12345

  expect_error(auth_key$calc_new_nonce_hash(as.raw(1:16), number), "length\\(new_nonce\\) == 32")
  # expect_error(auth_key$calc_new_nonce_hash(new_nonce, "not_a_number"), "is.integer\\(number\\)")

  # Assuming sha1 and hash calculation are deterministic, you can test the output
  hash_result <- suppressWarnings(auth_key$calc_new_nonce_hash(new_nonce, number))
  expect_true(is.numeric(hash_result))
})

test_that("AuthKey equals method works correctly", {
  key_data1 <- as.raw(1:32)
  key_data2 <- as.raw(33:64)

  auth_key1 <- AuthKey$new(data = key_data1)
  auth_key2 <- AuthKey$new(data = key_data1)
  auth_key3 <- AuthKey$new(data = key_data2)

  expect_true(auth_key1$equals(auth_key2))
  expect_false(auth_key1$equals(auth_key3))
})

test_that("AuthKey active_key setter and getter work correctly", {
  key_data <- as.raw(1:32)
  auth_key <- AuthKey$new(data = key_data)

  # Test getter
  expect_equal(auth_key$active_key, key_data)

  # Test setter
  new_key_data <- as.raw(33:64)
  auth_key$active_key <- new_key_data
  expect_equal(auth_key$active_key, new_key_data)

  # Test setting to NULL
  auth_key$active_key <- NULL
  expect_null(auth_key$active_key)
  expect_false(auth_key$is_valid())
})

test_that("AuthKey key alias and derived accessors stay in sync", {
  key_data <- as.raw(1:32)
  auth_key <- AuthKey$new(data = key_data)

  expect_equal(auth_key$key, key_data)
  expect_equal(auth_key$return_aux_hash, auth_key$aux_hash)
  expect_equal(auth_key$return_key_id, auth_key$key_id)

  new_key_data <- as.raw(101:132)
  auth_key$key <- new_key_data
  expect_equal(auth_key$active_key, new_key_data)
  expect_equal(auth_key$key, new_key_data)
  expect_equal(auth_key$return_aux_hash, auth_key$aux_hash)
  expect_equal(auth_key$return_key_id, auth_key$key_id)
})
