require(openssl)
require(digest)

# Test for get_byte_array
test_that("get_byte_array converts integer to byte array correctly", {
  result <- get_byte_array(255)
  expect_equal(result, as.raw(c(0xff)))

  result <- get_byte_array(256)
  expect_equal(result, as.raw(c(0x00, 0x01)))
})

# Test for compute_fingerprint
test_that("compute_fingerprint computes correct fingerprint", {
  key <- list(n = 12345, e = 65537)
  fingerprint <- compute_fingerprint(key)
  expect_true(is.numeric(fingerprint))
  expect_true(fingerprint > 0)
})

# Test for add_key
test_that("add_key adds a public key to server_keys", {
  pub <- "-----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEAruw2yP/BCcsJliRoW5eBVBVle9dtjJw+OYED160Wybum9SXtBBLX
riwt4rROd9csv0t0OHCaTmRqBcQ0J8fxhN6/cpR1GWgOZRUAiQxoMnlt0R93LCX/
j1dnVa/gVbCjdSxpbrfY2g2L4frzjJvdl84Kd9ORYjDEAyFnEA7dD556OptgLQQ2
e2iVNq8NZLYTzLp5YpOdO1doK+ttrltggTCy5SrKeLoCPPbOgGsdxJxyz5KKcZnS
Lj16yE5HvJQn0CNpRdENvRUXe6tBP78O39oJ8BTHp9oIjd6XWXAsp2CvK45Ol8wF
XGF710w9lwCGNbmNxNYhtIkdqfsEcwR5JwIDAQAB
-----END RSA PUBLIC KEY-----"
  add_key(pub, old = FALSE)
  expect_true(length(.rsa_env$keys) > 0)
})

# Test for encrypt
test_that("encrypt encrypts data correctly", {
  pub <- "-----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEAruw2yP/BCcsJliRoW5eBVBVle9dtjJw+OYED160Wybum9SXtBBLX
riwt4rROd9csv0t0OHCaTmRqBcQ0J8fxhN6/cpR1GWgOZRUAiQxoMnlt0R93LCX/
j1dnVa/gVbCjdSxpbrfY2g2L4frzjJvdl84Kd9ORYjDEAyFnEA7dD556OptgLQQ2
e2iVNq8NZLYTzLp5YpOdO1doK+ttrltggTCy5SrKeLoCPPbOgGsdxJxyz5KKcZnS
Lj16yE5HvJQn0CNpRdENvRUXe6tBP78O39oJ8BTHp9oIjd6XWXAsp2CvK45Ol8wF
XGF710w9lwCGNbmNxNYhtIkdqfsEcwR5JwIDAQAB
-----END RSA PUBLIC KEY-----"
  add_key(pub, old = FALSE)
  fingerprint <- names(.rsa_env$keys)[1]
  data <- as.raw(c(0x01, 0x02, 0x03))
  encrypted <- encrypt(fingerprint, data)
  expect_true(!is.null(encrypted))
  expect_true(length(encrypted) > 0)
})

# Test for odcstring
test_that("odcstring converts raw vector to string correctly", {
  raw_data <- as.raw(c(0x01, 0x02, 0x03))
  result <- odcstring(raw_data)
  expect_equal(result, "010203")
})
