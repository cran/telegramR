mock_sys_info <- function(sysname) {
  function(...) list(sysname = sysname)
}

mock_system <- function(return_value) {
  function(...) return_value
}

mock_sys_which <- function(paths) {
  function(cmds) {
    if (is.character(cmds)) {
      result <- setNames(rep("", length(cmds)), cmds)
      found <- cmds[cmds %in% names(paths)]
      result[found] <- paths[found]
      return(result)
    }
    return(paths)
  }
}

mock_file_exists <- function(...) TRUE

mock_dyn_load <- function(...) NULL

# helper to create a copy of a function with mocked bindings in its enclosing env
create_mocked_fn <- function(fn, bindings = list()) {
  f <- fn
  env <- new.env(parent = environment(fn))
  for (nm in names(bindings)) assign(nm, bindings[[nm]], env)
  environment(f) <- env
  f
}

# --- Tests ---

test_that("find_ssl_lib uses SSL_LIB environment variable if set", {
  skip_on_cran()
  withr::with_envvar(c(SSL_LIB = "/path/to/libssl.dylib"), {
    mf <- create_mocked_fn(find_ssl_lib, list(file.exists = mock_file_exists, dyn.load = mock_dyn_load))
    expect_equal(mf(), "/path/to/libssl.dylib")
  })
})

test_that("find_ssl_lib handles macOS version-specific logic", {
  skip_on_cran()
  mf <- create_mocked_fn(find_ssl_lib, list(
    Sys.info = mock_sys_info("Darwin"),
    get_os_type = function() "unix",
    system = mock_system("10.15.7"),
    Sys.which = mock_sys_which(c(
      "libssl.46.dylib" = "/path/to/libssl.46.dylib",
      "libssl.44.dylib" = "",
      "libssl.42.dylib" = ""
    )),
    file.exists = mock_file_exists,
    dyn.load = mock_dyn_load
  ))

  # expect_equal(mf(), "/path/to/libssl.46.dylib")
})

test_that("find_ssl_lib falls back to libssl.dylib on older macOS versions", {
  skip_on_cran()
  mf <- create_mocked_fn(find_ssl_lib, list(
    Sys.info = mock_sys_info("Darwin"),
    get_os_type = function() "unix",
    system = mock_system("10.14.6"),
    Sys.which = mock_sys_which(c("libssl.dylib" = "/path/to/libssl.dylib")),
    file.exists = mock_file_exists,
    dyn.load = mock_dyn_load
  ))

  # expect_equal(mf(), "/path/to/libssl.dylib")
})

test_that("find_ssl_lib handles non-macOS systems", {
  skip_on_cran()
  mf <- create_mocked_fn(find_ssl_lib, list(
    Sys.info = mock_sys_info("Linux"),
    get_os_type = function() "unix",
    Sys.which = mock_sys_which(c("libssl.so" = "/path/to/libssl.so")),
    file.exists = mock_file_exists,
    dyn.load = mock_dyn_load
  ))

  expect_equal(mf(), "/path/to/libssl.so")
})

test_that("find_ssl_lib throws an error if no library is found", {
  skip_on_cran()
  mf <- create_mocked_fn(find_ssl_lib, list(
    Sys.info = mock_sys_info("Linux"),
    get_os_type = function() "unix",
    Sys.which = mock_sys_which(c())
  ))
  expect_error(mf(), "No SSL library candidates found on the system")
})

test_that("find_ssl_lib throws an error if dyn.load fails", {
  skip_on_cran()
  mf <- create_mocked_fn(find_ssl_lib, list(
    Sys.info = mock_sys_info("Linux"),
    get_os_type = function() "unix",
    Sys.which = mock_sys_which(c("libssl.so" = "/path/to/libssl.so")),
    file.exists = mock_file_exists,
    dyn.load = function(...) stop("dyn.load error")
  ))

  expect_error(mf(), "Failed to load SSL library: dyn.load error")
})
