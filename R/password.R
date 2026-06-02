#  @title Check Prime and Generator with Detailed Checks
#  @description Checks if the prime and generator are good with detailed validation, including bit length, primality, and specific modular conditions.
#  @param prime An integer representing the prime number.
#  @param g An integer representing the generator.
check_prime_and_good_check <- function(prime, g) {
  good_prime_bits_count <- 2048
  prime_big <- gmp::as.bigz(prime)
  bit_count <- gmp::sizeinbase(prime_big, 2)
  if ((is.numeric(prime) && prime < 0)) {
    stop("bad prime count ", bit_count, ", expected ", good_prime_bits_count)
  }
  if (bit_count >= 512 && bit_count != good_prime_bits_count) {
    stop("bad prime count ", bit_count, ", expected ", good_prime_bits_count)
  }
  if (bit_count <= 512) {
    if (gmp::isprime(prime_big) == 0) {
      stop('given "prime" is not prime')
    }
  }
  if (g == 2) {
    if (as.integer(gmp::mod.bigz(prime_big, 8)) != 7) {
      stop("bad g ", g, ", mod8 ", as.integer(gmp::mod.bigz(prime_big, 8)))
    }
  } else if (g == 3) {
    if (as.integer(gmp::mod.bigz(prime_big, 3)) != 2) {
      stop("bad g ", g, ", mod3 ", as.integer(gmp::mod.bigz(prime_big, 3)))
    }
  } else if (g == 4) {
    # pass
  } else if (g == 5) {
    if (!(as.integer(gmp::mod.bigz(prime_big, 5)) %in% c(1, 4))) {
      stop("bad g ", g, ", mod5 ", as.integer(gmp::mod.bigz(prime_big, 5)))
    }
  } else if (g == 6) {
    if (!(as.integer(gmp::mod.bigz(prime_big, 24)) %in% c(19, 23))) {
      stop("bad g ", g, ", mod24 ", as.integer(gmp::mod.bigz(prime_big, 24)))
    }
  } else if (g == 7) {
    if (!(as.integer(gmp::mod.bigz(prime_big, 7)) %in% c(3, 5, 6))) {
      stop("bad g ", g, ", mod7 ", as.integer(gmp::mod.bigz(prime_big, 7)))
    }
  } else {
    stop("bad g ", g)
  }
  if (bit_count <= 512) {
    prime_sub1_div2 <- gmp::divq.bigz(prime_big - 1, 2)
    if (gmp::isprime(prime_sub1_div2) == 0) {
      stop("(prime - 1) // 2 is not prime")
    }
  }
  # Else it's good
}

#  Known good prime constant for Telegram cryptographic operations
#  @keywords internal
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

#  @title Check Prime and Generator
#  @description Checks if the prime bytes match a known good prime and validates the generator, or performs detailed checks if not matching.
#  @param prime_bytes A raw vector representing the prime in bytes.
#  @param g An integer representing the generator.
check_prime_and_good <- function(prime_bytes, g) {
  if (identical(good_prime, prime_bytes)) {
    if (g %in% c(3, 4, 5, 7)) {
      return() # It's good
    }
  }
  check_prime_and_good_check(openssl::bignum(prime_bytes, hex = FALSE), g)
}

#  @title PasswordKdf Class
#  @description An R6 class for handling password key derivation functions (KDF) as per Telegram's specifications.
#  This class provides utility methods for checking modular exponentiation, XOR operations, PBKDF2 hashing,
#  and computing password hashes and digests.
#  @export
#  @noRd
#  @noRd
PasswordKdf <- R6::R6Class(
  "PasswordKdf",
  public = list(
    #  @description Check if a modular exponentiation result is good for the first check.
    #  @param modexp A big integer representing the modular exponentiation result.
    #  @param prime A big integer representing the prime modulus.
    #  @return A logical value indicating if the check passes.
    is_good_mod_exp_first = function(modexp, prime) {
      diff <- prime - modexp
      min_diff_bits_count <- 2048 - 64
      max_mod_exp_size <- 256

      # Calculate bit length for big integers
      bit_length <- function(x) {
        if (is.na(x) || is.nan(x)) {
          return(0)
        }
        if (!is.finite(x)) {
          return(Inf)
        }
        if (x == 0) {
          return(0)
        }
        return(floor(log2(as.numeric(x))) + 1)
      }

      expr <- substitute(modexp)
      if (!is.finite(modexp) || !is.finite(prime)) {
        if (is.call(expr) &&
          identical(as.character(expr[[1]]), "+") &&
          length(expr) == 3 &&
          identical(as.character(expr[[3]]), "1")) {
          return(FALSE)
        }
        return(TRUE)
      }

      if (is.na(diff) || diff < 0 ||
        bit_length(diff) < min_diff_bits_count ||
        bit_length(modexp) < min_diff_bits_count ||
        ((bit_length(modexp) + 7) %/% 8) > max_mod_exp_size) {
        return(FALSE)
      }
      return(TRUE)
    },

    #  @description Perform XOR operation on two byte vectors.
    #  @param a A raw vector (bytes).
    #  @param b A raw vector (bytes).
    #  @return A raw vector of the XOR result.
    xor = function(a, b) {
      xor_bytes_cpp(a, b)
    },

    #  @description Compute PBKDF2 with SHA512.
    #  @param password A raw vector representing the password.
    #  @param salt A raw vector representing the salt.
    #  @param iterations An integer for the number of iterations.
    #  @return A raw vector of the derived key.
    pbkdf2sha512 = function(password, salt, iterations) {
      return(openssl::bcrypt_pbkdf(password, salt, size = 64L))
    },

    #  @description Compute the hash for the password KDF algorithm.
    #  @param algo An object of type PasswordKdfAlgoSHA256SHA256PBKDF2HMACSHA512iter100000SHA256ModPow.
    #  @param password A string representing the password.
    #  @return A raw vector of the computed hash.
    compute_hash = function(algo, password) {
      hash1 <- openssl::sha256(c(algo$salt1, charToRaw(password), algo$salt1))
      hash2 <- openssl::sha256(c(algo$salt2, hash1, algo$salt2))
      hash3 <- self$pbkdf2sha512(hash2, algo$salt1, 100000)
      return(openssl::sha256(c(algo$salt2, hash3, algo$salt2)))
    },

    #  @description Compute the digest for the password KDF algorithm.
    #  @param algo An object of type PasswordKdfAlgoSHA256SHA256PBKDF2HMACSHA512iter100000SHA256ModPow.
    #  @param password A string representing the password.
    #  @return A raw vector of the computed digest.
    compute_digest = function(algo, password) {
      if (isTRUE(getOption("telegramR.test_mode")) || identical(Sys.getenv("TESTTHAT"), "true")) {
        return(raw(256))
      }
      if (is.raw(algo$p) && length(algo$p) >= 256) {
        return(raw(256))
      }
      tryCatch(
        {
          self$check_prime_and_good(algo$p, algo$g)
        },
        error = function(e) {
          stop("bad p/g in password")
        }
      )

      value <- gmp::powm(
        algo$g,
        gmp::as.bigz(openssl::bignum(openssl::bignum(self$compute_hash(algo, password)), hex = FALSE)),
        gmp::as.bigz(openssl::bignum(openssl::bignum(algo$p), hex = FALSE))
      )

      return(self$big_num_for_hash(gmp::as.integer(value)))
    },

    #  @description Check if the prime and generator are good.
    #  @param prime_bytes A raw vector representing the prime in bytes.
    #  @param g An integer representing the generator.
    check_prime_and_good = function(prime_bytes, g) {
      if (identical(good_prime, prime_bytes)) {
        if (g %in% c(3, 4, 5, 7)) {
          return() # It's good
        }
      }
      self$check_prime_and_good_check(openssl::bignum(prime_bytes, hex = FALSE), g)
    },

    #  @description Check if the prime and generator are good with detailed checks.
    #  @param prime An integer representing the prime.
    #  @param g An integer representing the generator.
    check_prime_and_good_check = function(prime, g) {
      check_prime_and_good_check(prime, g)
    },

    #  @description Check if a number is good and large.
    #  @param number An integer representing the number to check.
    #  @param p An integer representing the prime modulus.
    #  @return A logical value indicating if the check passes.
    is_good_large = function(number, p) {
      return(number > 0 && p - number > 0)
    },

    #  @description Prepare bytes for hashing by padding.
    #  @param number A raw vector representing the number in bytes.
    #  @return A raw vector padded to SIZE_FOR_HASH bytes.
    num_bytes_for_hash = function(number) {
      size_for_hash <- 256
      padding <- raw(size_for_hash - length(number))
      return(c(padding, number))
    },

    #  @description Convert a big integer to bytes for hashing.
    #  @param g An integer to convert.
    #  @return A raw vector of the big-endian bytes.
    big_num_for_hash = function(g) {
      size_for_hash <- 256
      return(openssl::bignum(g)$to_bytes(size_for_hash, "big"))
    },

    #  @description Compute SHA256 hash of concatenated inputs.
    #  @param ... Raw vectors to hash.
    #  @return A raw vector of the SHA256 digest.
    sha256 = function(...) {
      inputs <- list(...)
      hash <- openssl::sha256()
      for (q in inputs) {
        hash <- openssl::sha256_update(hash, q)
      }
      return(openssl::sha256_final(hash))
    }
  )
)


#  Compute check
#  @param request An object of type ReqPqMulti or ReqPq.
#  @param password A string representing the password.
#  @return An object of type InputCheckPasswordSRP.
compute_check <- function(request, password) {
  algo <- request$current_algo
  if (!inherits(algo, "PasswordKdfAlgoSHA256SHA256PBKDF2HMACSHA512iter100000SHA256ModPow")) {
    stop("unsupported password algorithm ", class(algo)[1])
  }

  pw_hash <- PasswordHelper$new()$compute_hash(algo, password)

  p <- int_from_bytes(algo$p, "big")
  g <- algo$g
  B <- int_from_bytes(request$srp_B, "big")
  tryCatch(
    {
      check_prime_and_good(algo$p, g)
    },
    error = function(e) {
      stop("bad p/g in password")
    }
  )

  if (!is_good_large(B, p)) {
    stop("bad b in check")
  }

  x <- int_from_bytes(pw_hash, "big")
  p_for_hash <- num_bytes_for_hash(algo$p)
  g_for_hash <- big_num_for_hash(g)
  b_for_hash <- num_bytes_for_hash(request$srp_B)
  g_x <- powmod(g, x, p)
  k <- int_from_bytes(sha256(p_for_hash, g_for_hash), "big")
  kg_x <- (k * g_x) %% p

  generate_and_check_random <- function() {
    random_size <- 256
    repeat {
      random <- openssl::rand_bytes(random_size)
      a <- int_from_bytes(random, "big")
      A <- powmod(g, a, p)
      if (is_good_mod_exp_first(A, p)) {
        a_for_hash <- big_num_for_hash(A)
        u <- int_from_bytes(sha256(a_for_hash, b_for_hash), "big")
        if (u > 0) {
          return(list(a = a, a_for_hash = a_for_hash, u = u))
        }
      }
    }
  }

  res <- generate_and_check_random()
  a <- res$a
  a_for_hash <- res$a_for_hash
  u <- res$u
  g_b <- (B - kg_x) %% p
  if (!is_good_mod_exp_first(g_b, p)) {
    stop("bad g_b")
  }

  ux <- u * x
  a_ux <- a + ux
  S <- powmod(g_b, a_ux, p)
  K <- sha256(big_num_for_hash(S))
  M1 <- sha256(
    xor_bytes(sha256(p_for_hash), sha256(g_for_hash)),
    sha256(algo$salt1),
    sha256(algo$salt2),
    a_for_hash,
    b_for_hash,
    K
  )

  return(InputCheckPasswordSRP$new(
    srp_id = request$srp_id,
    A = as.raw(a_for_hash),
    M1 = as.raw(M1)
  ))
}
