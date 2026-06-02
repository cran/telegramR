test_that("CheckChatlistInviteRequest to_list and bytes serialize slug correctly", {
  skip_on_cran()
  req <- CheckChatlistInviteRequest$new(slug = "abc")
  lst <- req$to_list()
  expect_equal(lst$`_`, "CheckChatlistInviteRequest")
  expect_equal(lst$slug, "abc")

  b <- req$bytes()
  # constructor id
  expect_equal(b[1:4], as.raw(c(0xff, 0x0f, 0xc1, 0x41)))
  # length byte for 'abc'
  expect_equal(as.integer(b[5]), 3L)
  # characters 'a','b','c'
  expect_equal(rawToChar(b[6:8]), "abc")

  # when slug is NULL, bytes should only contain constructor id
  req2 <- CheckChatlistInviteRequest$new(slug = NULL)
  b2 <- req2$bytes()
  expect_equal(b2, as.raw(c(0xff, 0x0f, 0xc1, 0x41)))
})


test_that("DeleteExportedInviteRequest includes chatlist bytes and slug", {
  skip_on_cran()
  chatlist <- list(bytes = function() as.raw(c(0xAA)))
  req <- DeleteExportedInviteRequest$new(chatlist = chatlist, slug = "x")
  lst <- req$to_list()
  expect_equal(lst$`_`, "DeleteExportedInviteRequest")
  expect_equal(lst$slug, "x")

  b <- req$bytes()
  expect_equal(b[1:4], as.raw(c(0x5e, 0x5c, 0x9c, 0x71)))
  # chatlist bytes included next
  expect_equal(b[5], as.raw(0xAA))
  # slug length 1 and character
  expect_equal(as.integer(b[6]), 1L)
  expect_equal(rawToChar(b[7]), "x")
})


test_that("EditExportedInviteRequest flags, optional fields and resolve", {
  skip_on_cran()
  # create dummy chatlist and peer objects that implement bytes()
  chatlist <- list(bytes = function() as.raw(c(0x11)))
  peer1 <- list(bytes = function() as.raw(21))
  peer2 <- list(bytes = function() as.raw(22))

  # when title and peers provided, flags should include bits 2 and 4 (2 + 4 = 6)
  req <- EditExportedInviteRequest$new(chatlist = chatlist, slug = "s", title = "T", peers = list(peer1, peer2))
  b <- req$bytes()
  expect_equal(b[1:4], as.raw(c(0x3d, 0xb6, 0x3d, 0x65)))
  # flags low byte should be 6
  expect_equal(as.integer(b[5]), 6L)

  # resolve should call client$get_input_entity and utils$get_input_peer for each peer
  fake_client <- list(get_input_entity = function(x) {
    if (is.list(x) && is.function(x$bytes)) {
      b <- x$bytes()
      return(as.character(as.integer(b[1])))
    }
    paste0("ENT:", x)
  })
  fake_utils <- list(get_input_peer = function(x) paste0("IP:ENT:", x))
  req$resolve(fake_client, fake_utils)
  expect_true(is.list(req$peers))
  expect_equal(req$peers[[1]], "IP:ENT:21")
  expect_equal(req$peers[[2]], "IP:ENT:22")

  # when no title/peers, flags should be zero
  req2 <- EditExportedInviteRequest$new(chatlist = chatlist, slug = "s2")
  b2 <- req2$bytes()
  expect_equal(as.integer(b2[5]), 0L)
})


test_that("ExportChatlistInviteRequest resolve and to_list", {
  skip_on_cran()
  peer <- "p"
  req <- ExportChatlistInviteRequest$new(chatlist = NULL, title = "hello", peers = list(peer))
  # resolve should transform peers via client/get_input_entity and utils/get_input_peer
  fake_client <- list(get_input_entity = function(x) paste0("E:", x))
  fake_utils <- list(get_input_peer = function(x) paste0("IP:", x))
  req$resolve(fake_client, fake_utils)
  expect_equal(req$peers[[1]], "IP:E:p")

  lst <- req$to_list()
  expect_equal(lst$`_`, "ExportChatlistInviteRequest")
  expect_equal(lst$title, "hello")
})
