#  RSA Utilities
# 
#  This module holds several utilities regarding RSA and server fingerprints.
# 
#  @importFrom digest digest
#  @importFrom openssl read_pubkey

# Mutable container for RSA server keys — avoids locked-binding manipulation
.rsa_env <- new.env(parent = emptyenv())
.rsa_env$keys <- list()

.strip_leading_zero <- function(x) {
  x <- as.raw(x)
  if (length(x) == 0) {
    return(x)
  }
  while (length(x) > 1 && identical(x[1], as.raw(0x00))) {
    x <- x[-1]
  }
  x
}

.coerce_key_components <- function(key) {
  if (is.character(key) && length(key) == 1L) {
    key <- openssl::read_pubkey(key)
  }
  if (inherits(key, "pubkey")) {
    info <- tryCatch(as.list(key), error = function(e) NULL)
    if (is.null(info) || is.null(info$data) || is.null(info$data$n) || is.null(info$data$e)) {
      stop("Invalid key for compute_fingerprint: cannot extract n/e")
    }
    return(list(
      n = .strip_leading_zero(as.raw(info$data$n)),
      e = .strip_leading_zero(as.raw(info$data$e)),
      pubkey = key
    ))
  }
  if (is.list(key) && !is.null(key$n) && !is.null(key$e)) {
    return(list(
      n = .strip_leading_zero(get_byte_array(key$n)),
      e = .strip_leading_zero(get_byte_array(key$e)),
      pubkey = NULL
    ))
  }
  stop("Invalid key for compute_fingerprint: expected PEM string, list(n, e), or openssl pubkey")
}

.fingerprint_raw_from_components <- function(n_bytes, e_bytes) {
  payload <- c(serialize_bytes(n_bytes), serialize_bytes(e_bytes))
  h <- digest::digest(payload, algo = "sha1", serialize = FALSE, raw = TRUE)
  h[(length(h) - 7):length(h)]
}

.int_from_le_raw <- function(x) {
  x <- as.raw(x)
  if (length(x) == 0) {
    return(gmp::as.bigz(0))
  }
  hex <- paste(sprintf("%02x", as.integer(rev(x))), collapse = "")
  gmp::as.bigz(paste0("0x", hex))
}

#  Converts an integer to a byte array.
# 
#  @param integer The integer to convert.
#  @return A raw vector representing the byte array.
#  @export
get_byte_array <- function(integer) {
  # Handle empty/NULL early
  if (is.null(integer) || length(integer) == 0) {
    return(raw(0))
  }

  # bignum from openssl
  if (inherits(integer, "bignum")) {
    ch <- as.character(integer)
    # Prefer hex strings if provided (0x...)
    if (grepl("^0x", ch)) {
      hex <- sub("^0x", "", ch)
      if ((nchar(hex) %% 2) == 1) hex <- paste0("0", hex)
      return(as.raw(strtoi(substring(hex, seq(1, nchar(hex), 2), seq(2, nchar(hex), 2)), 16L)))
    } else {
      # Fallback: use decimal string bytes (stable but not numeric bytes)
      return(charToRaw(ch))
    }
  }

  # Raw: return as-is
  if (is.raw(integer)) {
    return(integer)
  }

  # Numeric: convert to big-endian minimal-length bytes
  if (is.numeric(integer)) {
    x <- as.numeric(integer[1])
    if (!is.finite(x) || x < 0) stop("Unsupported numeric value in get_byte_array")
    if (x == 0) {
      return(as.raw(0))
    }
    bytes <- raw(0)
    while (x > 0) {
      # LSB-first (little-endian) order
      bytes <- c(bytes, as.raw(as.integer(x %% 256)))
      x <- floor(x / 256)
    }
    return(bytes)
  }

  stop("Unsupported type for get_byte_array")
}

#  Computes the fingerprint of an RSA key.
# 
#  @param key The RSA key as a list with `n` and `e` components, a PEM string, or an openssl pubkey.
#  @return The 8-byte fingerprint as a positive numeric.
compute_fingerprint <- function(key) {
  comps <- .coerce_key_components(key)
  tail8 <- .fingerprint_raw_from_components(comps$n, comps$e)
  # Return a signed little-endian numeric for compatibility with existing API/tests.
  val <- .int_from_le_raw(tail8)
  as.numeric(if (val > gmp::as.bigz(2^63 - 1)) val - gmp::as.bigz(2^64) else val)
}

#  Adds a new public key to the server keys.
# 
#  @param pub The public key in PEM format.
#  @param old Logical indicating if the key is old.
add_key <- function(pub, old = FALSE) {
  comps <- .coerce_key_components(pub)
  key <- if (is.null(comps$pubkey)) openssl::read_pubkey(pub) else comps$pubkey
  fingerprint <- compute_fingerprint(pub)
  fingerprint_raw <- .fingerprint_raw_from_components(comps$n, comps$e)
  entry <- list(
    key = key,
    old = old,
    n = comps$n,
    e = comps$e,
    fingerprint_raw = fingerprint_raw
  )

  .rsa_env$keys[[as.character(fingerprint)]] <- entry

  invisible(fingerprint)
}

#  Encrypts data using the specified RSA key fingerprint.
# 
#  @param fingerprint The fingerprint of the RSA key.
#  @param data The data to encrypt as a raw vector (or coercible).
#  @param use_old Logical indicating if old keys should be used.
#  @return The encrypted data as a raw vector, or NULL if no matching key is found.
encrypt <- function(fingerprint, data, use_old = FALSE) {
  key_info <- .rsa_env$keys[[as.character(fingerprint)]]
  if (is.null(key_info) || (key_info$old && !use_old)) {
    return(NULL)
  }

  # Coerce input to raw
  data_raw <- if (is.raw(data)) {
    data
  } else if (is.character(data)) {
    charToRaw(paste0(data, collapse = ""))
  } else if (is.numeric(data)) {
    as.raw(as.integer(data))
  } else {
    stop("Unsupported data type for encrypt")
  }

  # Use PKCS#1 v1.5 padding (default) to produce a full-size RSA block
  openssl::rsa_encrypt(data_raw, key_info$key)
}

#  Converts a raw vector to an odd-length string.
# 
#  @param raw_data The raw vector to convert.
#  @return A string with odd-length characters.
odcstring <- function(raw_data) {
  # Coerce to integer vector for sprintf %02x
  bytes <- if (is.raw(raw_data)) {
    as.integer(raw_data)
  } else if (is.numeric(raw_data)) {
    as.integer(raw_data)
  } else {
    stop("Unsupported type for odcstring")
  }
  paste0(sprintf("%02x", bytes), collapse = "")
}

# Add default keys
default_keys <- list(
  "-----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEAruw2yP/BCcsJliRoW5eBVBVle9dtjJw+OYED160Wybum9SXtBBLX
riwt4rROd9csv0t0OHCaTmRqBcQ0J8fxhN6/cpR1GWgOZRUAiQxoMnlt0R93LCX/
j1dnVa/gVbCjdSxpbrfY2g2L4frzjJvdl84Kd9ORYjDEAyFnEA7dD556OptgLQQ2
e2iVNq8NZLYTzLp5YpOdO1doK+ttrltggTCy5SrKeLoCPPbOgGsdxJxyz5KKcZnS
Lj16yE5HvJQn0CNpRdENvRUXe6tBP78O39oJ8BTHp9oIjd6XWXAsp2CvK45Ol8wF
XGF710w9lwCGNbmNxNYhtIkdqfsEcwR5JwIDAQAB
-----END RSA PUBLIC KEY-----",
  "-----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEAvfLHfYH2r9R70w8prHblWt/nDkh+XkgpflqQVcnAfSuTtO05lNPs
pQmL8Y2XjVT4t8cT6xAkdgfmmvnvRPOOKPi0OfJXoRVylFzAQG/j83u5K3kRLbae
7fLccVhKZhY46lvsueI1hQdLgNV9n1cQ3TDS2pQOCtovG4eDl9wacrXOJTG2990V
jgnIKNA0UMoP+KF03qzryqIt3oTvZq03DyWdGK+AZjgBLaDKSnC6qD2cFY81UryR
WOab8zKkWAnhw2kFpcqhI0jdV5QaSCExvnsjVaX0Y1N0870931/5Jb9ICe4nweZ9
kSDF/gip3kWLG0o8XQpChDfyvsqB9OLV/wIDAQAB
-----END RSA PUBLIC KEY-----",
  "-----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEAs/ditzm+mPND6xkhzwFIz6J/968CtkcSE/7Z2qAJiXbmZ3UDJPGr
zqTDHkO30R8VeRM/Kz2f4nR05GIFiITl4bEjvpy7xqRDspJcCFIOcyXm8abVDhF+
th6knSU0yLtNKuQVP6voMrnt9MV1X92LGZQLgdHZbPQz0Z5qIpaKhdyA8DEvWWvS
Uwwc+yi1/gGaybwlzZwqXYoPOhwMebzKUk0xW14htcJrRrq+PXXQbRzTMynseCoP
Ioke0dtCodbA3qQxQovE16q9zz4Otv2k4j63cz53J+mhkVWAeWxVGI0lltJmWtEY
K6er8VqqWot3nqmWMXogrgRLggv/NbbooQIDAQAB
-----END RSA PUBLIC KEY-----",
  "-----BEGIN RSA PUBLIC KEY-----
MIIBCgKCAQEAvmpxVY7ld/8DAjz6F6q05shjg8/4p6047bn6/m8yPy1RBsvIyvuD
uGnP/RzPEhzXQ9UJ5Ynmh2XJZgHoE9xbnfxL5BXHplJhMtADXKM9bWB11PU1Eioc
3+AXBB8QiNFBn2XI5UkO5hPhbb9mJpjA9Uhw8EdfqJP8QetVsI/xrCEbwEXe0xvi
fRLJbY08/Gp66KpQvy7g8w7VB8wlgePexW3pT13Ap6vuC+mQuJPyiHvSxjEKHgqe
Pji9NP3tJUFQjcECqcm0yV7/2d0t/pbCm+ZH1sadZspQCEPPrtbkQBlvHb4OLiIW
PGHKSMeRFvp3IWcmdJqXahxLCUS1Eh6MAQIDAQAB
-----END RSA PUBLIC KEY-----"
)

for (pub in default_keys) {
  add_key(pub, old = FALSE)
}
