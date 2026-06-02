promise <- promises::promise
promise_resolve <- promises::promise_resolve
`%...>%` <- promises::`%...>%`
`%...!%` <- promises::`%...!%`
value <- function(x, ...) {
  future::value(x, ...)
}

await <- function(x) {
  if (inherits(x, "promise") || inherits(x, "Future")) {
    return(future::value(x))
  }
  x
}

skip_if_no_integration <- function() {
  if (!nzchar(Sys.getenv("TELEGRAMR_INTEGRATION"))) {
    if (requireNamespace("testthat", quietly = TRUE)) {
      testthat::skip("Integration tests disabled; set TELEGRAMR_INTEGRATION=1")
    }
  }
  invisible(NULL)
}
