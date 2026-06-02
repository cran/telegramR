# Tests for OpaqueRequest, packInt64, unpackInt64, write_data_as_message
# in mtprotostate.R

# --- OpaqueRequest ---

test_that("OpaqueRequest stores raw data and to_bytes returns it", {
  skip_on_cran()
  d <- as.raw(c(0x01, 0x02, 0x03))
  op <- OpaqueRequest$new(d)
  expect_equal(op$data, d)
  expect_equal(op$to_bytes(), d)
})

# --- packInt64 / unpackInt64 round-trips ---

test_that("packInt64/unpackInt64 round-trips positive value", {
  skip_on_cran()
  val <- 1234567890123456
  b   <- packInt64(val)
  expect_equal(length(b), 8L)
  back <- unpackInt64(b)
  expect_equal(back, val, tolerance = 1)
})

test_that("packInt64/unpackInt64 round-trips zero", {
  skip_on_cran()
  b <- packInt64(0)
  expect_equal(length(b), 8L)
  expect_equal(unpackInt64(b), 0)
})

test_that("packInt64 handles bigz input", {
  skip_on_cran()
  big <- gmp::as.bigz("9999999999999999")
  b   <- packInt64(big)
  expect_equal(length(b), 8L)
})

test_that("packInt64 handles negative value via two's-complement", {
  skip_on_cran()
  b <- packInt64(-1)
  expect_equal(length(b), 8L)
  # -1 in two's complement over 64 bits is all 0xFF bytes
  expect_true(all(b == as.raw(0xFF)))
})

test_that("packInt64 handles character input", {
  skip_on_cran()
  b <- packInt64("42")
  expect_equal(length(b), 8L)
  expect_equal(unpackInt64(b), 42)
})

test_that("unpackInt64 errors on wrong length", {
  skip_on_cran()
  expect_error(unpackInt64(as.raw(1:4)), "8 bytes")
})

# --- packInt32 ---

test_that("packInt32 produces 4 bytes for 0", {
  skip_on_cran()
  b <- packInt32(0L)
  expect_equal(length(b), 4L)
  expect_true(all(b == as.raw(0x00)))
})

test_that("packInt32 encodes 1 correctly (little-endian)", {
  skip_on_cran()
  b <- packInt32(1L)
  expect_equal(as.integer(b[1]), 1L)
  expect_equal(as.integer(b[2]), 0L)
})

# --- write_data_as_message ---

test_that("write_data_as_message writes to a rawConnection buffer", {
  skip_on_cran()
  auth_key <- AuthKey$new(NULL)
  state     <- MTProtoState$new(auth_key, NULL)

  buf <- rawConnection(raw(0), "w")
  on.exit(close(buf), add = TRUE)

  data     <- as.raw(rep(0x42, 16))
  msg_id   <- state$write_data_as_message(buf, data, content_related = FALSE)

  # get_new_msg_id() returns bigz; just verify it is positive
  expect_true(as.numeric(msg_id) > 0)

  written <- rawConnectionValue(buf)
  # Header is 8 (msg_id) + 4 (seq_no) + 4 (length) = 16 bytes
  expect_gte(length(written), 16L + length(data))
})

test_that("write_data_as_message increments seq_no for content-related messages", {
  skip_on_cran()
  auth_key <- AuthKey$new(NULL)
  state     <- MTProtoState$new(auth_key, NULL)

  buf1 <- rawConnection(raw(0), "w")
  buf2 <- rawConnection(raw(0), "w")
  on.exit({ close(buf1); close(buf2) }, add = TRUE)

  state$write_data_as_message(buf1, raw(8), content_related = TRUE)
  state$write_data_as_message(buf2, raw(8), content_related = TRUE)

  w1 <- rawConnectionValue(buf1)
  w2 <- rawConnectionValue(buf2)

  # seq_no is bytes 9-12; read as little-endian int
  seq_no_1 <- sum(as.integer(w1[9:12]) * 256^(0:3))
  seq_no_2 <- sum(as.integer(w2[9:12]) * 256^(0:3))
  expect_true(seq_no_2 > seq_no_1)
})
