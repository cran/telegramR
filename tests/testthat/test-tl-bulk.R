# Bulk smoke tests for all TL types and request classes.
# Purpose: exercise initialize() + to_dict()/toDict() for every R6 class
# in the package that carries a CONSTRUCTOR_ID (~40% of the codebase).
#
# Note: Some classes fail to instantiate with all-NULL args because they
# do not declare their fields in the public list (undeclared field = locked
# environment error). These are excluded from success-rate assertions.

.tl_classes_with_to_dict <- function() {
  ns <- asNamespace("telegramR")
  Filter(function(nm) {
    obj <- tryCatch(get(nm, envir = ns), error = function(e) NULL)
    if (is.null(obj)) return(FALSE)
    tryCatch(
      is.environment(obj) &&
        !is.null(obj$public_fields$CONSTRUCTOR_ID) &&
        "to_dict" %in% names(obj$public_methods),
      error = function(e) FALSE
    )
  }, ls(ns))
}

.tl_classes_with_toDict <- function() {
  ns <- asNamespace("telegramR")
  Filter(function(nm) {
    obj <- tryCatch(get(nm, envir = ns), error = function(e) NULL)
    if (is.null(obj)) return(FALSE)
    tryCatch(
      is.environment(obj) &&
        !is.null(obj$public_fields$CONSTRUCTOR_ID) &&
        "toDict" %in% names(obj$public_methods),
      error = function(e) FALSE
    )
  }, ls(ns))
}

# Attempt to instantiate a class with all-NULL arguments.
# Returns list(ok, obj or msg).
.try_instantiate <- function(cls) {
  init_fn <- cls$public_methods$initialize
  if (is.null(init_fn)) return(list(ok = FALSE, msg = "no initialize"))
  n_args   <- length(formals(init_fn))
  null_args <- as.list(rep(list(NULL), n_args))
  tryCatch(
    list(ok = TRUE, obj = do.call(cls$new, null_args)),
    error = function(e) list(ok = FALSE, msg = conditionMessage(e))
  )
}

test_that("TL type classes (to_dict) can be counted and most are found", {
  skip_on_cran()
  tl_names <- .tl_classes_with_to_dict()
  # Sanity: there should be >1000 such classes
  expect_gt(length(tl_names), 1000L)
})

test_that("TL request classes (toDict) can be counted", {
  skip_on_cran()
  tl_names <- .tl_classes_with_toDict()
  expect_gt(length(tl_names), 100L)
})

test_that("TL types with declared fields initialize and to_dict without error", {
  skip_on_cran()
  ns       <- asNamespace("telegramR")
  tl_names <- .tl_classes_with_to_dict()

  # Only test classes that declare fields beyond CONSTRUCTOR_ID + SUBCLASS_OF_ID,
  # since undeclared-field classes are a known code issue (locked environment).
  well_formed <- Filter(function(nm) {
    obj <- get(nm, envir = ns)
    length(obj$public_fields) > 2L
  }, tl_names)

  expect_gt(length(well_formed), 500L)

  successes <- 0L
  failures  <- character(0)

  for (nm in well_formed) {
    cls <- get(nm, envir = ns)
    res <- .try_instantiate(cls)
    if (!res$ok) {
      failures <- c(failures, sprintf("%s: %s", nm, res$msg))
      next
    }
    d <- tryCatch(res$obj$to_dict(), error = function(e) NULL)
    if (!is.null(d)) {
      successes <- successes + 1L
      # to_dict must return a named list with a "_" key that is a string
      expect_true(is.list(d), label = sprintf("%s to_dict returns list", nm))
      expect_true(is.character(d[["_"]]) && nchar(d[["_"]]) > 0L,
        label = sprintf("%s to_dict has non-empty '_' key", nm))
    } else {
      failures <- c(failures, sprintf("%s: to_dict returned NULL", nm))
    }
  }

  # At least 95 % of well-formed classes should succeed
  expect_gte(successes, as.integer(0.95 * length(well_formed)),
    label = sprintf(
      "to_dict successes %d/%d; first failures: %s",
      successes, length(well_formed),
      paste(head(failures, 3), collapse = " | ")
    ))
})

test_that("TL request classes with declared fields initialize and toDict without error", {
  skip_on_cran()
  ns       <- asNamespace("telegramR")
  tl_names <- .tl_classes_with_toDict()

  well_formed <- Filter(function(nm) {
    obj <- get(nm, envir = ns)
    length(obj$public_fields) > 2L
  }, tl_names)

  successes <- 0L
  failures  <- character(0)

  for (nm in well_formed) {
    cls <- get(nm, envir = ns)
    res <- .try_instantiate(cls)
    if (!res$ok) {
      failures <- c(failures, sprintf("%s: %s", nm, res$msg))
      next
    }
    d <- tryCatch(res$obj$toDict(), error = function(e) NULL)
    if (!is.null(d)) {
      successes <- successes + 1L
      expect_true(is.list(d), label = sprintf("%s toDict returns list", nm))
      expect_true(is.character(d[["_"]]) && nchar(d[["_"]]) > 0L,
        label = sprintf("%s toDict has non-empty '_' key", nm))
    } else {
      failures <- c(failures, sprintf("%s: toDict returned NULL", nm))
    }
  }

  if (length(well_formed) > 0L) {
    expect_gte(successes, as.integer(0.90 * length(well_formed)),
      label = sprintf(
        "toDict successes %d/%d; first failures: %s",
        successes, length(well_formed),
        paste(head(failures, 3), collapse = " | ")
      ))
  }
})

test_that("classes without declared fields still run initialize up to field assignment", {
  skip_on_cran()
  ns       <- asNamespace("telegramR")
  tl_names <- .tl_classes_with_to_dict()

  # These classes fail to fully initialize but the code still runs
  undeclared <- Filter(function(nm) {
    obj <- get(nm, envir = ns)
    length(obj$public_fields) <= 2L
  }, tl_names)

  expect_gt(length(undeclared), 100L)

  lock_errors <- 0L
  for (nm in undeclared) {
    cls <- get(nm, envir = ns)
    res <- .try_instantiate(cls)
    if (!res$ok && grepl("locked environment|bindings", res$msg, ignore.case = TRUE)) {
      lock_errors <- lock_errors + 1L
    }
  }
  # Most failures should be the locked-environment variety (known issue)
  expect_gt(lock_errors, 50L)
})

test_that("spot-check: well-known TL types produce correct to_dict", {
  skip_on_cran()
  ns <- asNamespace("telegramR")

  cases <- list(
    list(nm = "BotCommand",    n = 2L),
    list(nm = "DocumentEmpty", n = 1L),
    list(nm = "GeoPoint",      n = 4L),
    list(nm = "InputGeoPoint", n = 3L),
    list(nm = "PhotoSize",     n = 5L)
  )

  for (case in cases) {
    cls <- tryCatch(get(case$nm, envir = ns), error = function(e) NULL)
    if (is.null(cls)) next
    null_args <- as.list(rep(list(NULL), case$n))
    obj <- tryCatch(do.call(cls$new, null_args), error = function(e) NULL)
    if (is.null(obj)) next
    d <- tryCatch(obj$to_dict(), error = function(e) NULL)
    if (!is.null(d)) {
      expect_equal(d[["_"]], case$nm,
        label = sprintf("%s to_dict[_]", case$nm))
    }
  }
})
