test_that("FileStream works with raw input and read/getters", {
  skip_on_cran()
  fs <- FileStream$new(as.raw(c(0x01, 0x02, 0x03)))
  expect_equal(fs$get_file_size(), 3)
  expect_null(fs$get_name())
  # Read all
  data <- fs$read()
  expect_true(is.raw(data))
  expect_equal(data, as.raw(c(0x01, 0x02, 0x03)))
  # reading again returns empty raw
  expect_equal(fs$read(), raw(0))
  fs$close()
})


test_that("generate_key_data_from_nonce returns 32-byte key and iv", {
  skip_on_cran()
  server_nonce <- as.raw(sample(0:255, 16, replace = TRUE))
  new_nonce <- as.raw(sample(0:255, 32, replace = TRUE))
  kd <- generate_key_data_from_nonce(server_nonce, new_nonce)
  expect_true(is.list(kd))
  expect_true(is.raw(kd$key))
  expect_true(is.raw(kd$iv))
  expect_equal(length(kd$key), 32)
  expect_equal(length(kd$iv), 32)
})


test_that("GetStateRequest.bytes returns expected constructor id bytes", {
  skip_on_cran()
  req <- GetStateRequest$new()
  b <- req$bytes()
  expect_true(is.raw(b))
  # If the class exposes CONSTRUCTOR_ID, compute expected little-endian bytes
  cid <- NULL
  if (!is.null(GetStateRequest$public_fields) && "CONSTRUCTOR_ID" %in% names(GetStateRequest$public_fields)) {
    cid <- GetStateRequest$public_fields$CONSTRUCTOR_ID
  } else if (!is.null(GetStateRequest$public_fields) && "CONSTRUCTOR_ID" %in% names(GetStateRequest$public_fields)) {
    cid <- GetStateRequest$public_fields$CONSTRUCTOR_ID
  }
  if (!is.null(cid)) {
    # cid may be raw or numeric
    cid_int <- as.integer(cid)
    expected <- as.raw(c(
      bitwAnd(cid_int, 0xFF),
      bitwAnd(bitwShiftR(cid_int, 8), 0xFF),
      bitwAnd(bitwShiftR(cid_int, 16), 0xFF),
      bitwAnd(bitwShiftR(cid_int, 24), 0xFF)
    ))
    expect_equal(b[1:4], expected)
  } else {
    # fallback: ensure raw vector has at least 4 bytes
    expect_true(length(b) >= 4)
  }
})


test_that("GetDifferenceRequest packs flags correctly based on optional limits", {
  skip_on_cran()
  # no optional limits -> flags == 0
  req1 <- GetDifferenceRequest$new(1, NULL, 2)
  b1 <- req1$bytes()
  # constructor id first 4 bytes
  expect_equal(b1[1:4], private_pack <- as.raw(private_pack <- as.raw(c(0x63, 0xf7, 0xc2, 0x19))))
  # flags are bytes 5:8 and should be zeros
  expect_equal(as.integer(b1[5:8]), c(0L, 0L, 0L, 0L))

  # with pts_limit (bit 2) and pts_total_limit (bit 1) and qts_limit (bit 4)
  req2 <- GetDifferenceRequest$new(10, NULL, 20, pts_limit = 5, pts_total_limit = 7, qts_limit = 9)
  b2 <- req2$bytes()
  # flags byte should be (bits 1 + 2 + 4) -> 1 + 2 + 4 = 7
  expect_equal(as.integer(b2[5]), 7L)
})


test_that("GetChannelDifferenceRequest embeds channel/filter bytes and flag 'force'", {
  skip_on_cran()
  DummyObj <- R6::R6Class("DummyObj", public = list(
    bytes = function() as.raw(c(0xAA)),
    to_bytes = function() as.raw(c(0xAA))
  ))
  ch <- DummyObj$new()
  filt <- DummyObj$new()
  req <- GetChannelDifferenceRequest$new(ch, filt, 123, 10, force = TRUE)
  b <- req$bytes()
  # constructor id is at bytes 1:4 (little-endian), flags at 5:8
  expect_true(is.raw(b))
  # flags low byte should have bit 1 set because force = TRUE
  expect_equal(as.integer(b[5]), 1L)
  # embedded channel bytes immediately after flags (byte 9)
  expect_equal(b[9], as.raw(0xAA))
})


test_that("strip_text trims text when entities empty and leaves adjusted text returned", {
  skip_on_cran()
  text <- "  Hello World  "
  entities <- list()
  out <- strip_text(text, entities)
  expect_equal(out, "Hello World")

  # if entities include an entity entirely in trimmed left region, it should be removed internally
  text2 <- "  ABC"
  entities2 <- list(list(offset = 0, length = 1))
  out2 <- strip_text(text2, entities2)
  expect_equal(out2, "ABC")
})


test_that("fmt_flood formats messages correctly", {
  skip_on_cran()
  msg <- fmt_flood(10, request = GetStateRequest$new(), early = TRUE, td = function(d, units) as.difftime(d, units = units))
  expect_true(grepl("Sleeping early for 10s", msg))
  expect_true(grepl("GetStateRequest", msg))
})


test_that("TotalList to_string produces expected format", {
  skip_on_cran()
  tl <- TotalList$new(list(1, "a"))
  tl$total <- 5
  s <- tl$to_string()
  expect_true(grepl("\\[1, a, total=5\\]", s))
})
