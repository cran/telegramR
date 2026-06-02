MockTLObject <- R6::R6Class("MockTLObject",
  inherit = TLObject,
  public = list(
    to_raw = function() as.raw(c(1, 2, 3, 4)),
    to_list = function() list("_" = "MockTLObject")
  )
)

test_that("EditPeerFoldersRequest works correctly", {
  skip_on_cran()
  folder_peers <- list(MockTLObject$new(), MockTLObject$new())
  req <- EditPeerFoldersRequest$new(folder_peers = folder_peers)
  
  expect_s3_class(req, "EditPeerFoldersRequest")
  
  lst <- req$to_list()
  expect_equal(lst[["_"]], "EditPeerFoldersRequest")
  expect_length(lst[["folder_peers"]], 2)
  expect_equal(lst[["folder_peers"]][[1]], list("_" = "MockTLObject"))

  bytes <- req$to_raw()
  expect_true(is.raw(bytes))
  
  # constructor id: 0x6847d0ab -> ab d0 47 68
  expect_equal(bytes[1:4], as.raw(c(0xab, 0xd0, 0x47, 0x68)))
  
  # subclass id: 0x8af52aac -> ac 2a f5 8a
  expect_equal(bytes[5:8], as.raw(c(0xac, 0x2a, 0xf5, 0x8a)))
  
  # count: 2
  expect_equal(bytes[9:12], as.raw(c(2, 0, 0, 0)))
  
  # Mock object bytes follow
  expect_equal(bytes[13:16], as.raw(c(1, 2, 3, 4)))
})

test_that("EditPeerFoldersRequest handles empty folder_peers", {
  skip_on_cran()
  req <- EditPeerFoldersRequest$new(folder_peers = list())
  expect_length(req$folder_peers, 0)
  
  bytes <- req$to_raw()
  expect_equal(bytes[9:12], as.raw(c(0, 0, 0, 0)))
})

test_that("EditPeerFoldersRequest handles NULL folder_peers", {
  skip_on_cran()
  req <- EditPeerFoldersRequest$new(folder_peers = NULL)
  expect_length(req$folder_peers, 0)
})

test_that("EditPeerFoldersRequest throws error on invalid input", {
  skip_on_cran()
  expect_error(EditPeerFoldersRequest$new(folder_peers = "not a list"))
})
