# Helper to skip integration tests unless explicitly enabled
skip_if_no_integration <- function() {
  if (!nzchar(Sys.getenv("TELEGRAMR_INTEGRATION"))) {
    testthat::skip("Integration tests disabled; set TELEGRAMR_INTEGRATION=1")
  }
}

