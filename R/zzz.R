#' @useDynLib telegramR, .registration = TRUE
#' @importFrom Rcpp sourceRcpp
NULL

.onLoad <- function(libname, pkgname) {
  defaults <- list(
    telegramR.async = FALSE,
    telegramR.debug_parse = FALSE,
    telegramR.debug_pump = FALSE,
    telegramR.debug_process = FALSE,
    telegramR.auth_status_message = TRUE
  )
  for (k in names(defaults)) {
    if (is.null(getOption(k, NULL))) {
      options(structure(list(defaults[[k]]), names = k))
    }
  }
  if (is.null(getOption("future.rng.onMisuse", NULL))) {
    options(future.rng.onMisuse = "ignore")
  }
  invisible(NULL)
}
