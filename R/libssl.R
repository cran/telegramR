#  @title Finds and loads the system's SSL library.
#  @description
#  This function attempts to locate the system's SSL library and load it using R's
#  `dyn.load` function. On macOS, it handles versioning issues for compatibility.
#  @return A reference (path) to the loaded SSL library.
#  @export
find_ssl_lib <- function() {
  try_load_ssl <- function(path) {
    tryCatch(
      {
        dyn.load(path)
        path
      },
      error = function(e) {
        stop("Failed to load SSL library: ", e$message)
      }
    )
  }

  is_valid <- function(path) !is.null(path) && path != "" && file.exists(path)

  # Step 1: Environment variable
  env_lib <- Sys.getenv("SSL_LIB", unset = "")
  if (is_valid(env_lib)) {
    return(try_load_ssl(env_lib))
  }

  # Step 2: Platform-specific discovery
  sysname <- Sys.info()[["sysname"]]
  os_type <- .Platform$OS.type

  lib_candidates <- character()

  if (os_type == "unix" && sysname == "Darwin") {
    release_str <- system("sw_vers -productVersion", intern = TRUE)
    release <- as.numeric(strsplit(release_str, "\\.")[[1]])
    major <- release[1]
    minor <- ifelse(length(release) > 1, release[2], 0)

    if (major > 10 || (major == 10 && minor > 14)) {
      lib_candidates <- Sys.which(c("libssl.46.dylib", "libssl.44.dylib", "libssl.42.dylib"))
    } else {
      lib_candidates <- Sys.which("libssl.dylib")
    }
  } else {
    lib_candidates <- Sys.which("libssl.so")
  }

  lib_candidates <- lib_candidates[lib_candidates != ""]

  for (candidate in lib_candidates) {
    if (is_valid(candidate)) {
      return(try_load_ssl(candidate))
    }
  }

  stop("No SSL library candidates found on the system.")
}
