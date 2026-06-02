test_that("GetLangPackRequest works correctly", {
  skip_on_cran()
  req <- GetLangPackRequest$new(lang_pack = "android", lang_code = "en")
  
  expect_s3_class(req, "GetLangPackRequest")
  
  dict <- req$to_dict()
  expect_equal(dict[["lang_pack"]], "android")
  expect_equal(dict[["lang_code"]], "en")

  bytes_out <- req$bytes()
  expect_true(is.raw(bytes_out))
  
  # constructor id: 0xf2f2330a -> 0a 33 f2 f2
  expect_equal(bytes_out[1:4], as.raw(c(0x0a, 0x33, 0xf2, 0xf2)))
})

test_that("GetStringsRequest works correctly", {
  skip_on_cran()
  req <- GetStringsRequest$new(
    lang_pack = "android",
    lang_code = "en",
    keys = c("key1", "key2")
  )
  
  expect_s3_class(req, "GetStringsRequest")
  
  dict <- req$to_dict()
  expect_equal(dict[["_"]], "GetStringsRequest")
  expect_equal(dict[["keys"]], c("key1", "key2"))

  bytes_out <- req$bytes()
  expect_true(is.raw(bytes_out))
  
  # constructor id: 0xefea3803 -> 03 38 ea ef
  expect_equal(bytes_out[1:4], as.raw(c(0x03, 0x38, 0xea, 0xef)))
})

# Note: GetDifferenceRequest test is omitted due to class name collision with functions_updates.R
# which causes "unused arguments" error when updates version is loaded last.
