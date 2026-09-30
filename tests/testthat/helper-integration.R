# Helper to skip the (low-level, connection) integration tests unless enabled.
# High-level live smoke tests live in inst/integration/smoke.R and run outside
# testthat, because the package treats a testthat run as "no real network".
skip_if_no_integration <- function() {
  if (!nzchar(Sys.getenv("TELEGRAMR_INTEGRATION"))) {
    testthat::skip("Integration tests disabled; set TELEGRAMR_INTEGRATION=1")
  }
}
