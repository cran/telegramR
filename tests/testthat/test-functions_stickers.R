MockTLObject <- R6::R6Class("MockTLObject",
  inherit = TLObject,
  public = list(
    to_bytes = function() as.raw(c(1, 2, 3, 4)),
    to_list = function() list("_" = "MockTLObject")
  )
)

contains_seq <- function(vec, seq) {
  if (length(vec) < length(seq)) return(FALSE)
  for (i in seq_len(length(vec) - length(seq) + 1)) {
    if (all(vec[i:(i + length(seq) - 1)] == seq)) return(TRUE)
  }
  FALSE
}

test_that("AddStickerToSetRequest works correctly", {
  skip_on_cran()
  stickerset <- MockTLObject$new()
  sticker <- MockTLObject$new()
  req <- AddStickerToSetRequest$new(stickerset = stickerset, sticker = sticker)
  
  expect_s3_class(req, "AddStickerToSetRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "AddStickerToSetRequest")

  # bytes verification
  bytes_out <- req$to_bytes()
  expect_true(is.raw(bytes_out))
  # stickerset bytes (from mock): 01 02 03 04 present
  expect_true(contains_seq(bytes_out, as.raw(c(0x01,0x02,0x03,0x04))))
  # sticker bytes (from mock): 01 02 03 04 present at least twice
  # find occurrences
  occ <- 0
  for (i in seq_len(length(bytes_out) - 3)) {
    if (all(bytes_out[i:(i+3)] == as.raw(c(0x01,0x02,0x03,0x04)))) occ <- occ + 1
  }
  expect_true(occ >= 2)
})

test_that("CreateStickerSetRequest works correctly", {
  skip_on_cran()
  user_id <- MockTLObject$new()
  sticker_item <- MockTLObject$new()
  req <- CreateStickerSetRequest$new(
    user_id = user_id,
    title = "My Set",
    short_name = "myset",
    stickers = list(sticker_item),
    masks = TRUE
  )
  
  expect_s3_class(req, "CreateStickerSetRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "CreateStickerSetRequest")
  expect_equal(lst[["title"]], "My Set")
  expect_equal(lst[["short_name"]], "myset")
  expect_true(lst[["masks"]])

  # bytes verification
  bytes_out <- req$to_bytes()
  expect_true(is.raw(bytes_out))
  # flags: masks=TRUE -> int32 little-endian 1 -> 01 00 00 00 should appear
  expect_true(contains_seq(bytes_out, as.raw(c(0x01,0x00,0x00,0x00))))
})

test_that("RenameStickerSetRequest works correctly", {
  skip_on_cran()
  stickerset <- MockTLObject$new()
  req <- RenameStickerSetRequest$new(stickerset = stickerset, title = "New Title")
  
  expect_s3_class(req, "RenameStickerSetRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "RenameStickerSetRequest")
  expect_equal(lst[["title"]], "New Title")

  # bytes verification
  bytes_out <- req$to_bytes()
  # constructor: 0x124b1c00 -> 00 1c 4b 12
  expect_equal(bytes_out[1:4], as.raw(c(0x00, 0x1c, 0x4b, 0x12)))
})
