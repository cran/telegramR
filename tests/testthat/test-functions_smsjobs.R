test_that("FinishJobRequest works correctly", {
  skip_on_cran()
  req <- FinishJobRequest$new(job_id = "job123", error = "some error")
  
  expect_s3_class(req, "FinishJobRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "FinishJobRequest")
  expect_equal(lst[["job_id"]], "job123")
  expect_equal(lst[["error"]], "some error")

  # bytes verification
  bytes_out <- req$bytes()
  # constructor: 0x4f1ebf24 -> 24 bf 1e 4f
  expect_equal(bytes_out[1:4], as.raw(c(0x24, 0xbf, 0x1e, 0x4f)))
  # flags: error is present -> 1 -> 01 00 00 00
  expect_equal(bytes_out[5:8], as.raw(c(0x01, 0x00, 0x00, 0x00)))
})

test_that("GetSmsJobRequest works correctly", {
  skip_on_cran()
  req <- GetSmsJobRequest$new(job_id = "job456")
  
  expect_s3_class(req, "GetSmsJobRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "GetSmsJobRequest")
  expect_equal(lst[["job_id"]], "job456")

  # bytes verification
  bytes_out <- req$bytes()
  # constructor: 0x778d902f -> 2f 90 8d 77
  expect_equal(bytes_out[1:4], as.raw(c(0x2f, 0x90, 0x8d, 0x77)))
})

test_that("UpdateSettingsRequest works correctly", {
  skip_on_cran()
  req <- UpdateSettingsRequest$new(allow_international = TRUE)
  
  expect_s3_class(req, "UpdateSettingsRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "UpdateSettingsRequest")
  expect_true(lst[["allow_international"]])

  # bytes verification
  bytes_out <- req$bytes()
  # constructor: 0x093fa0bf -> bf a0 3f 09
  expect_equal(bytes_out[1:4], as.raw(c(0xbf, 0xa0, 0x3f, 0x09)))
  # flags: allow_international=TRUE -> 1 -> 01 00 00 00
  expect_equal(bytes_out[5:8], as.raw(c(0x01, 0x00, 0x00, 0x00)))
})
