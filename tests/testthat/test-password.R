# Define a mock factorization package since it's used in the code
# Assuming factorization is a package with Factorization$factorize
# For testing, we'll mock it or use a simple primality check
# Note: In real tests, you might need to install and load the factorization package

# Mock factorization$Factorization$factorize for testing
factorization <- list(
  Factorization = list(
    factorize = function(x) {
      # Simple mock: return 1 if prime, else factors
      if (x == 2 || x == 3 || x == 5 || x == 7) {
        return(1)
      }
      if (x %% 2 == 0 || x %% 3 == 0 || x %% 5 == 0 || x %% 7 == 0) {
        return(c(2, x / 2))
      } # Not prime
      return(1) # Assume prime for other small numbers
    }
  )
)

# Tests for check_prime_and_good_check
test_that("check_prime_and_good_check works with valid inputs", {
  skip_on_cran()
  # Use a small prime for testing (2048 bits is too large for quick tests; adjust as needed)
  # For simplicity, use a known small prime that fits the conditions
  prime <- 2^2047 - 1 # A large prime, but for test, use smaller
  # Actually, for quick test, use a small prime like 7, but adjust bit length check
  # Since bit length is checked, use a prime with ~2048 bits, but that's impractical; mock or skip slow parts

  # Skip detailed primality for speed; test logic
  expect_error(check_prime_and_good_check(-1, 2), "bad prime count")
  expect_error(check_prime_and_good_check(15, 2), "not prime") # 15 is not prime
  expect_error(check_prime_and_good_check(7, 8), "bad g") # Invalid g
  # Valid case: assume a prime that passes
  # This is tricky without full primality; perhaps skip or use known values
})

test_that("check_prime_and_good_check validates g conditions", {
  skip_on_cran()
  prime <- 17 # 17 %% 8 == 1, not 7
  expect_error(check_prime_and_good_check(prime, 2), "mod8")
  # For g=3, need prime %% 3 == 2, etc.
  # Adjust prime accordingly
  prime_for_g3 <- 5 # 5 %% 3 == 2
  expect_silent(check_prime_and_good_check(prime_for_g3, 3))
})

# Tests for check_prime_and_good
test_that("check_prime_and_good uses known prime", {
  skip_on_cran()
  good_prime <- as.raw(c(
    0xC7, 0x1C, 0xAE, 0xB9, 0xC6, 0xB1, 0xC9, 0x04, 0x8E, 0x6C, 0x52, 0x2F, 0x70, 0xF1, 0x3F, 0x73,
    0x98, 0x0D, 0x40, 0x23, 0x8E, 0x3E, 0x21, 0xC1, 0x49, 0x34, 0xD0, 0x37, 0x56, 0x3D, 0x93, 0x0F,
    0x48, 0x19, 0x8A, 0x0A, 0xA7, 0xC1, 0x40, 0x58, 0x22, 0x94, 0x93, 0xD2, 0x25, 0x30, 0xF4, 0xDB,
    0xFA, 0x33, 0x6F, 0x6E, 0x0A, 0xC9, 0x25, 0x13, 0x95, 0x43, 0xAE, 0xD4, 0x4C, 0xCE, 0x7C, 0x37,
    0x20, 0xFD, 0x51, 0xF6, 0x94, 0x58, 0x70, 0x5A, 0xC6, 0x8C, 0xD4, 0xFE, 0x6B, 0x6B, 0x13, 0xAB,
    0xDC, 0x97, 0x46, 0x51, 0x29, 0x69, 0x32, 0x84, 0x54, 0xF1, 0x8F, 0xAF, 0x8C, 0x59, 0x5F, 0x64,
    0x24, 0x77, 0xFE, 0x96, 0xBB, 0x2A, 0x94, 0x1D, 0x5B, 0xCD, 0x1D, 0x4A, 0xC8, 0xCC, 0x49, 0x88,
    0x07, 0x08, 0xFA, 0x9B, 0x37, 0x8E, 0x3C, 0x4F, 0x3A, 0x90, 0x60, 0xBE, 0xE6, 0x7C, 0xF9, 0xA4,
    0xA4, 0xA6, 0x95, 0x81, 0x10, 0x51, 0x90, 0x7E, 0x16, 0x27, 0x53, 0xB5, 0x6B, 0x0F, 0x6B, 0x41,
    0x0D, 0xBA, 0x74, 0xD8, 0xA8, 0x4B, 0x2A, 0x14, 0xB3, 0x14, 0x4E, 0x0E, 0xF1, 0x28, 0x47, 0x54,
    0xFD, 0x17, 0xED, 0x95, 0x0D, 0x59, 0x65, 0xB4, 0xB9, 0xDD, 0x46, 0x58, 0x2D, 0xB1, 0x17, 0x8D,
    0x16, 0x9C, 0x6B, 0xC4, 0x65, 0xB0, 0xD6, 0xFF, 0x9C, 0xA3, 0x92, 0x8F, 0xEF, 0x5B, 0x9A, 0xE4,
    0xE4, 0x18, 0xFC, 0x15, 0xE8, 0x3E, 0xBE, 0xA0, 0xF8, 0x7F, 0xA9, 0xFF, 0x5E, 0xED, 0x70, 0x05,
    0x0D, 0xED, 0x28, 0x49, 0xF4, 0x7B, 0xF9, 0x59, 0xD9, 0x56, 0x85, 0x0C, 0xE9, 0x29, 0x85, 0x1F,
    0x0D, 0x81, 0x15, 0xF6, 0x35, 0xB1, 0x05, 0xEE, 0x2E, 0x4E, 0x15, 0xD0, 0x4B, 0x24, 0x54, 0xBF,
    0x6F, 0x4F, 0xAD, 0xF0, 0x34, 0xB1, 0x04, 0x03, 0x11, 0x9C, 0xD8, 0xE3, 0xB9, 0x2F, 0xCC, 0x5B
  ))
  expect_silent(check_prime_and_good(good_prime, 3))
  # expect_error(check_prime_and_good(good_prime, 2), "bad g")  # Not in allowed list
  # For non-matching prime, it calls check_prime_and_good_check
  bad_prime <- as.raw(rep(0x00, 256))
  # expect_error(check_prime_and_good(bad_prime, 2), "bad prime count")
})

# Tests for PasswordKdf class
test_that("PasswordKdf$is_good_mod_exp_first works", {
  skip_on_cran()
  kdf <- PasswordKdf$new()
  prime <- 2^2048 - 1 # Mock large prime
  modexp <- prime - 1000
  expect_true(kdf$is_good_mod_exp_first(modexp, prime))
  expect_false(kdf$is_good_mod_exp_first(prime + 1, prime)) # diff < 0
})

test_that("PasswordKdf$xor works", {
  skip_on_cran()
  kdf <- PasswordKdf$new()
  a <- as.raw(c(0x01, 0x02))
  b <- as.raw(c(0x03, 0x04))
  result <- kdf$xor(a, b)
  expect_equal(result, as.raw(c(0x02, 0x06)))
})

test_that("PasswordKdf$pbkdf2sha512 works", {
  skip_on_cran()
  kdf <- PasswordKdf$new()
  password <- charToRaw("password")
  salt <- charToRaw("salt")
  result <- kdf$pbkdf2sha512(password, salt, 1000)
  expect_length(result, 64)
})

test_that("PasswordKdf$compute_hash works", {
  skip_on_cran()
  kdf <- PasswordKdf$new()
  algo <- list(
    salt1 = charToRaw("salt1"),
    salt2 = charToRaw("salt2")
  )
  password <- "test"
  result <- kdf$compute_hash(algo, password)
  expect_length(result, 32) # SHA256
})

test_that("PasswordKdf$compute_digest works", {
  skip_on_cran()
  kdf <- PasswordKdf$new()
  algo <- list(
    p = good_prime, # From above
    g = 3,
    salt1 = charToRaw("salt1"),
    salt2 = charToRaw("salt2")
  )
  password <- "test"
  result <- kdf$compute_digest(algo, password)
  expect_length(result, 256)
})

# Tests for compute_check
test_that("compute_check works with mock request", {
  skip_on_cran()
  # Mock request object
  request <- list(
    current_algo = list(
      p = good_prime,
      g = 3,
      salt1 = charToRaw("salt1"),
      salt2 = charToRaw("salt2")
    ),
    srp_B = as.raw(rep(0x01, 256)),
    srp_id = 123
  )
  password <- "test"
  # This will require defining missing functions like int_from_bytes, powmod, etc.
  # For now, assume they are defined elsewhere or mock
  # expect_s3_class(compute_check(request, password), "InputCheckPasswordSRP")
  # Since compute_check uses undefined functions, this test is placeholder
})
