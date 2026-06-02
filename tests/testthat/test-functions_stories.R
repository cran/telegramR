MockTLObject <- R6::R6Class("MockTLObject",
  inherit = TLObject,
  public = list(
    to_bytes = function() as.raw(c(0x01, 0x02, 0x03, 0x04)), # Dummy bytes
    bytes = function() as.raw(c(0x01, 0x02, 0x03, 0x04)),
    to_list = function() list("_" = "MockTLObject")
  )
)

# Helper to call an R6 public method function with a temporary environment that provides `self`
call_method_with_self <- function(fun, self_list) {
  fcopy <- fun
  newenv <- new.env(parent = environment(fun))
  environment(fcopy) <- newenv
  assign("self", self_list, envir = newenv)
  fcopy()
}

test_that("ActivateStealthModeRequest works correctly", {
  skip_on_cran()
  # Avoid constructing the R6 object directly because some generated classes include a non-logical
  # `class` argument that older/new R6 versions may not accept; instead call its public methods
  to_list_fun <- ActivateStealthModeRequest$public_methods$to_list
  to_bytes_fun <- ActivateStealthModeRequest$public_methods$to_bytes

  self_obj <- list(past = TRUE, future = FALSE)
  lst <- call_method_with_self(to_list_fun, self_obj)
  expect_equal(lst[["_"]], "ActivateStealthModeRequest")
  expect_true(lst[["past"]])
  expect_false(lst[["future"]])

  bytes_out <- call_method_with_self(to_bytes_fun, self_obj)
  expect_true(is.raw(bytes_out))
  # constructor: 0x57bbd166 -> 66 d1 bb 57
  expect_equal(bytes_out[1:4], as.raw(c(0x66, 0xd1, 0xbb, 0x57)))
  # flags: bit 0 = past=TRUE -> 1 -> 01 00 00 00
  expect_equal(bytes_out[5:8], as.raw(c(0x01, 0x00, 0x00, 0x00)))
})


test_that("ActivateStealthModeRequest handles both flags", {
  skip_on_cran()
  to_bytes_fun <- ActivateStealthModeRequest$public_methods$to_bytes
  self_obj <- list(past = TRUE, future = TRUE)
  bytes_out <- call_method_with_self(to_bytes_fun, self_obj)
  expect_true(is.raw(bytes_out))
  # flags: bit 0=TRUE, bit 1=TRUE -> 3 -> 03 00 00 00
  expect_equal(bytes_out[5:8], as.raw(c(0x03, 0x00, 0x00, 0x00)))
})


test_that("CanSendStoryRequest works correctly", {
  skip_on_cran()
  # Use public method with synthetic self
  to_list_fun <- CanSendStoryRequest$public_methods$to_list
  to_bytes_fun <- CanSendStoryRequest$public_methods$to_bytes

  peer <- MockTLObject$new()
  self_obj <- list(peer = peer)

  lst <- call_method_with_self(to_list_fun, self_obj)
  expect_equal(lst[["_"]], "CanSendStoryRequest")
  expect_equal(lst[["peer"]][["_"]], "MockTLObject")

  bytes_out <- call_method_with_self(to_bytes_fun, self_obj)
  expect_true(is.raw(bytes_out))
  # constructor: 0x30eb63f0 -> f0 63 eb 30
  expect_equal(bytes_out[1:4], as.raw(c(0xf0, 0x63, 0xeb, 0x30)))
  # peer bytes follow constructor: 01 02 03 04
  expect_equal(bytes_out[5:8], as.raw(c(0x01, 0x02, 0x03, 0x04)))
})


test_that("IncrementStoryViewsRequest works correctly", {
  skip_on_cran()
  to_list_fun <- IncrementStoryViewsRequest$public_methods$to_list
  to_bytes_fun <- IncrementStoryViewsRequest$public_methods$to_bytes

  peer <- MockTLObject$new()
  self_obj <- list(peer = peer, id = c(101L, 102L))

  lst <- call_method_with_self(to_list_fun, self_obj)
  expect_equal(lst[["_"]], "IncrementStoryViewsRequest")
  expect_equal(lst[["id"]], c(101L, 102L))

  bytes_out <- call_method_with_self(to_bytes_fun, self_obj)
  expect_true(is.raw(bytes_out))
  # constructor: 0xb2028afb -> fb 8a 02 b2
  expect_equal(bytes_out[1:4], as.raw(c(0xfb, 0x8a, 0x02, 0xb2)))
  # peer bytes: 01 02 03 04
  expect_equal(bytes_out[5:8], as.raw(c(0x01, 0x02, 0x03, 0x04)))
  # vector tag: 15 c4 b5 1c
  expect_equal(bytes_out[9:12], as.raw(c(0x15, 0xc4, 0xb5, 0x1c)))
  # length: 2 -> 02 00 00 00
  expect_equal(bytes_out[13:16], as.raw(c(0x02, 0x00, 0x00, 0x00)))
  # first id: 101 -> 65 00 00 00
  expect_equal(bytes_out[17:20], as.raw(c(0x65, 0x00, 0x00, 0x00)))
  # second id: 102 -> 66 00 00 00
  expect_equal(bytes_out[21:24], as.raw(c(0x66, 0x00, 0x00, 0x00)))
})
