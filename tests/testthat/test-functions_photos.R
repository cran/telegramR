MockTLObject <- R6::R6Class("MockTLObject",
  inherit = TLObject,
  public = list(
    to_bytes = function() as.raw(c(1, 2, 3, 4)),
    to_list = function() list("_" = "MockTLObject")
  )
)

test_that("GetUserPhotosRequest works correctly", {
  skip_on_cran()
  user_id <- MockTLObject$new()
  req <- GetUserPhotosRequest$new(
    user_id = user_id,
    offset = 10L,
    max_id = 999,
    limit = 20L
  )
  
  expect_s3_class(req, "GetUserPhotosRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "GetUserPhotosRequest")
  expect_equal(lst[["offset"]], 10L)
  expect_equal(lst[["max_id"]], 999)
  expect_equal(lst[["limit"]], 20L)

  # bytes verification
  bytes_out <- req$to_bytes()
  # constructor: 0x91cd32a8 -> a8 32 cd 91
  expect_equal(bytes_out[1:4], as.raw(c(0xa8, 0x32, 0xcd, 0x91)))
})

test_that("UpdateProfilePhotoRequest works correctly", {
  skip_on_cran()
  photo_id <- MockTLObject$new()
  bot_id <- MockTLObject$new()
  req <- UpdateProfilePhotoRequest$new(
    id = photo_id,
    fallback = TRUE,
    bot = bot_id
  )
  
  expect_s3_class(req, "UpdateProfilePhotoRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "UpdateProfilePhotoRequest")
  expect_true(lst[["fallback"]])

  # bytes verification
  bytes_out <- req$to_bytes()
  # constructor: 0x09e82039 -> 39 20 e8 09
  expect_equal(bytes_out[1:4], as.raw(c(0x39, 0x20, 0xe8, 0x09)))
})

test_that("UploadContactProfilePhotoRequest works correctly", {
  skip_on_cran()
  user_id <- MockTLObject$new()
  file_obj <- MockTLObject$new()
  req <- UploadContactProfilePhotoRequest$new(
    user_id = user_id,
    suggest = TRUE,
    save = FALSE,
    file = file_obj
  )
  
  expect_s3_class(req, "UploadContactProfilePhotoRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "UploadContactProfilePhotoRequest")
  expect_true(lst[["suggest"]])
  expect_false(lst[["save"]])

  # bytes verification
  bytes_out <- req$to_bytes()
  # constructor: 0xe14c4a71 -> 71 4a 4c e1
  expect_equal(bytes_out[1:4], as.raw(c(0x71, 0x4a, 0x4c, 0xe1)))
})
