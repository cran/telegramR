value <- function(x, ...) {
  future::value(x, ...)
}

promise_resolve <- function(x) {
  promises::promise_resolve(x)
}

promise <- promises::promise
`%...>%` <- promises::`%...>%`
`%...!%` <- promises::`%...!%`

# Use sequential plan for all tests to prevent multicore/multisession hangs.
# With multicore plan, futures run in forked child processes that have their
# own copy of R environments, causing shared-state tests to spin forever.
future::plan("sequential")

# Skip tests that call future::future() on R-devel.
# future v1.70.0 + R-devel triggers a FutureLaunchError in evalFuture()
# due to a SET_STRING_ELT()/CHARSXP type-safety change in R.
skip_future_on_rdevel <- function() {
  if (isTRUE(grepl("devel", R.version$status, ignore.case = TRUE))) {
    testthat::skip("future::future() tests fail on R-devel (future v1.70.0 incompatibility)")
  }
}
