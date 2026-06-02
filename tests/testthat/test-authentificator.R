test_that("executes authentication successfully with valid sender", {
  skip_on_cran()
  sender <- list(
    send = function(request) {
      if (inherits(request, "ReqPqMultiRequest")) {
        return(list(
          nonce = request$nonce,
          pq = as.raw(c(0x01, 0x02, 0x03, 0x04)),
          server_public_key_fingerprints = c(12345)
        ))
      } else if (inherits(request, "ReqDHParamsRequest")) {
        return(list(
          nonce = request$nonce,
          server_nonce = request$server_nonce,
          encrypted_answer = raw(256),
          class = "ServerDHParamsOk"
        ))
      } else if (inherits(request, "SetClientDHParamsRequest")) {
        return(list(
          nonce = request$nonce,
          server_nonce = request$server_nonce,
          new_nonce_hash1 = as.raw(c(0x01, 0x02, 0x03, 0x04)),
          class = "DhGenOk"
        ))
      }
    }
  )
  result <- do_authentication(sender)
  expect_true(inherits(result$auth_key, "AuthKey"))
  expect_true(is.numeric(result$time_offset))
})

test_that("throws error when nonce mismatch occurs in PQ response", {
  skip_on_cran()
  sender <- list(
    send = function(request) {
      if (inherits(request, "ReqPqMultiRequest")) {
        return(list(
          nonce = as.integer(12345),
          pq = as.raw(c(0x01, 0x02, 0x03, 0x04)),
          server_public_key_fingerprints = c(12345)
        ))
      }
    }
  )
  expect_error(do_authentication(sender), "Step 1: invalid nonce from server")
})

test_that("throws error when no valid key is found for fingerprints", {
  skip_on_cran()
  sender <- list(
    send = function(request) {
      if (inherits(request, "ReqPqMultiRequest")) {
        return(list(
          nonce = request$nonce,
          pq = as.raw(c(0x01, 0x02, 0x03, 0x04)),
          server_public_key_fingerprints = c()
        ))
      }
    }
  )
  expect_error(do_authentication(sender), "Step 2: could not find a valid key for the provided fingerprints")
})

test_that("throws error when AES block size mismatch occurs", {
  skip_on_cran()
  sender <- list(
    send = function(request) {
      if (inherits(request, "ReqPqMultiRequest")) {
        return(list(
          nonce = request$nonce,
          pq = as.raw(c(0x01, 0x02, 0x03, 0x04)),
          server_public_key_fingerprints = c(12345)
        ))
      } else if (inherits(request, "ReqDHParamsRequest")) {
        return(list(
          nonce = request$nonce,
          server_nonce = request$server_nonce,
          encrypted_answer = raw(255),
          class = "ServerDHParamsOk"
        ))
      }
    }
  )
  expect_error(do_authentication(sender), "Step 3: AES block size mismatch")
})

test_that("throws error when Diffie-Hellman values are out of range", {
  skip_on_cran()
  sender <- list(
    send = function(request) {
      if (inherits(request, "ReqPqMultiRequest")) {
        return(list(
          nonce = request$nonce,
          pq = as.raw(c(0x01, 0x02, 0x03, 0x04)),
          server_public_key_fingerprints = c(12345)
        ))
      } else if (inherits(request, "ReqDHParamsRequest")) {
        return(list(
          nonce = request$nonce,
          server_nonce = request$server_nonce,
          encrypted_answer = raw(256),
          class = "ServerDHParamsOk"
        ))
      }
    }
  )
  mock_modexp <- function(base, exp, mod) {
    if (base == 2) {
      return(mod + 1)
    } else {
      return(as.integer((base^exp) %% mod))
    }
  }
  with_mocked_bindings(modexp = mock_modexp, {
    expect_error(do_authentication(sender), "Diffie-Hellman values are not in the valid range")
  })
})
