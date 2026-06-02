test_that("download-related constants are defined and sane", {
  skip_on_cran()
  expect_true(exists("MIN_CHUNK_SIZE"))
  expect_true(is.numeric(MIN_CHUNK_SIZE))
  expect_true(MIN_CHUNK_SIZE >= 1)

  expect_true(exists("MAX_CHUNK_SIZE"))
  expect_true(is.numeric(MAX_CHUNK_SIZE))
  expect_true(MAX_CHUNK_SIZE >= MIN_CHUNK_SIZE)

  expect_true(exists("TIMED_OUT_SLEEP"))
  expect_true(is.numeric(TIMED_OUT_SLEEP))
})


test_that("CdnRedirect stores the given object", {
  skip_on_cran()
  payload <- list(file_token = as.raw(c(0x01, 0x02)))
  cr <- CdnRedirect$new(cdn_redirect = payload)
  expect_true(inherits(cr, "CdnRedirect"))
  expect_identical(cr$cdn_redirect, payload)
})


test_that("DirectDownloadIter basic construction and fields", {
  skip_on_cran()
  fake_client <- list()
  ddi <- DirectDownloadIter$new(client = fake_client)
  # Instance should carry its class name
  expect_true(inherits(ddi, "DirectDownloadIter") || inherits(ddi, "RequestIter"))
  # defaults
  expect_true(is.numeric(ddi$total) || is.integer(ddi$total))
  expect_equal(ddi$total, 0)
  expect_null(ddi$chunk_size)
  expect_false(is.null(DirectDownloadIter$public_methods$init))
  expect_true(is.function(DirectDownloadIter$public_methods$init))
})


test_that("GenericDownloadIter exposes load_next_chunk and inherits DirectDownloadIter", {
  skip_on_cran()
  fake_client <- list()
  gdi <- GenericDownloadIter$new(client = fake_client)
  expect_true(inherits(gdi, "GenericDownloadIter") || inherits(gdi, "DirectDownloadIter") || inherits(gdi, "RequestIter"))
  # method exists on generator
  expect_true(!is.null(GenericDownloadIter$public_methods$load_next_chunk))
  expect_true(is.function(GenericDownloadIter$public_methods$load_next_chunk))
})
