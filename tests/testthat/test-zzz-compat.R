test_that(".onLoad sets default options when missing", {
  skip_on_cran()
  old <- options()
  on.exit(options(old), add = TRUE)

  options(
    telegramR.debug_parse = NULL,
    telegramR.debug_pump = NULL,
    telegramR.debug_process = NULL,
    telegramR.auth_status_message = NULL
  )

  telegramR:::.onLoad(NULL, "telegramR")

  expect_identical(getOption("telegramR.debug_parse"), FALSE)
  expect_identical(getOption("telegramR.debug_pump"), FALSE)
  expect_identical(getOption("telegramR.debug_process"), FALSE)
  expect_identical(getOption("telegramR.auth_status_message"), TRUE)
})

test_that("compat_promises value unwraps Future", {
  skip_on_cran()
  skip_future_on_rdevel()
  future::plan("sequential")
  # future >= 1.70.0 added connection-tracking which can segfault on R devel
  # when invalid (closed) connection objects remain in the table.  Suppress the
  # check by disabling it for this isolated call; the option is a no-op on
  # older versions that don't implement it.
  old_opt <- options(future.connections = FALSE)
  on.exit(options(old_opt), add = TRUE)
  f <- future::future(1, seed = NULL)
  expect_equal(telegramR:::value(f), 1)
})

test_that("skip_if_no_integration skips when env is not set", {
  skip_on_cran()
  old <- Sys.getenv("TELEGRAMR_INTEGRATION", unset = "")
  on.exit(Sys.setenv(TELEGRAMR_INTEGRATION = old), add = TRUE)
  Sys.setenv(TELEGRAMR_INTEGRATION = "")
  testthat::expect_condition(telegramR:::skip_if_no_integration(), class = "skip")
})
