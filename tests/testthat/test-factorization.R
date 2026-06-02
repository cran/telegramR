# Create an instance of the Factorization class
factorization <- Factorization$new()

# Test the factorize method
test_that("factorize method factors correctly", {
  skip_on_cran()
  # Test with a product of two primes
  result <- factorization$factorize(15) # 15 = 3 * 5
  expect_equal(as.integer(result$p), 3)
  expect_equal(as.integer(result$q), 5)

  # Test with an even number
  result <- factorization$factorize(18) # 18 = 2 * 9
  expect_equal(as.integer(result$p), 2)
  expect_equal(as.integer(result$q), 9)
})

# Test the gcd method
test_that("gcd method calculates correctly", {
  skip_on_cran()
  expect_equal(as.integer(factorization$gcd(48, 18)), 6) # GCD of 48 and 18 is 6
  expect_equal(as.integer(factorization$gcd(101, 103)), 1) # GCD of two primes is 1
})
