test_that("binaryreader ctor normalization works for negative and NA", {
  expect_equal(.telegramR_norm_ctor_id(-1), sprintf("%.0f", 2^32 - 1))
  expect_true(is.na(.telegramR_norm_ctor_id(NA)))
})

test_that("binaryreader ctor map cache uses option when present", {
  old <- options()
  on.exit(options(old), add = TRUE)

  options(telegramR.debug_parse = FALSE, telegramR.ctor_map = list("x" = "y"))
  out <- .telegramR_get_ctor_map()
  expect_equal(out[["x"]], "y")
})
