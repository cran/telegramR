stories_call_method_with_self <- function(fun, self_list) {
  fcopy <- fun
  newenv <- new.env(parent = environment(fun))
  environment(fcopy) <- newenv
  assign("self", self_list, envir = newenv)
  fcopy()
}

stories_peer <- function(bytes = as.raw(c(0x01, 0x02, 0x03))) {
  structure(
    list(
      to_bytes = function() bytes,
      bytes = function() bytes,
      to_list = function() list("_" = "StoriesExtraPeer")
    ),
    class = c("StoriesExtraPeer", "TLObject")
  )
}

test_that("fixed stories requests serialize without constructing generated R6 classes", {
  skip_on_cran()
  read_peer <- stories_call_method_with_self(
    GetAllReadPeerStoriesRequest$public_methods$to_list,
    list()
  )
  expect_equal(read_peer, list("_" = "GetAllReadPeerStoriesRequest"))
  expect_equal(
    stories_call_method_with_self(GetAllReadPeerStoriesRequest$public_methods$to_bytes, list()),
    as.raw(c(0xf9, 0xe7, 0x5a, 0x9b))
  )

  chats <- stories_call_method_with_self(
    GetChatsToSendRequest$public_methods$to_list,
    list()
  )
  expect_equal(chats, list("_" = "GetChatsToSendRequest"))
  expect_equal(
    stories_call_method_with_self(GetChatsToSendRequest$public_methods$to_bytes, list()),
    as.raw(c(0x60, 0x8b, 0x6a, 0xa5))
  )
})

test_that("GetAllStoriesRequest covers flag combinations", {
  skip_on_cran()
  self_obj <- list(
    .next = TRUE,
    hidden = TRUE,
    state = "cursor",
    serialize_bytes = serialize_bytes
  )

  expect_equal(
    stories_call_method_with_self(GetAllStoriesRequest$public_methods$to_list, self_obj),
    list("_" = "GetAllStoriesRequest", .next = TRUE, hidden = TRUE, state = "cursor")
  )
  expect_equal(
    stories_call_method_with_self(GetAllStoriesRequest$public_methods$to_bytes, self_obj),
    c(
      as.raw(c(0x25, 0xd6, 0xb0, 0xee)),
      writeBin(7L, raw(), size = 4, endian = "little"),
      serialize_bytes("cursor")
    )
  )

  no_flags <- list(.next = NULL, hidden = NULL, state = NULL)
  expect_equal(
    stories_call_method_with_self(GetAllStoriesRequest$public_methods$to_bytes, no_flags),
    c(as.raw(c(0x25, 0xd6, 0xb0, 0xee)), writeBin(0L, raw(), size = 4, endian = "little"))
  )
})

test_that("DeleteStoriesRequest serializes peers and story ids", {
  skip_on_cran()
  peer <- stories_peer()
  self_obj <- list(peer = peer, id = c(3L, 4L))

  expect_equal(
    stories_call_method_with_self(DeleteStoriesRequest$public_methods$to_list, self_obj),
    list("_" = "DeleteStoriesRequest", peer = peer$to_list(), id = c(3L, 4L))
  )
  expect_equal(
    stories_call_method_with_self(DeleteStoriesRequest$public_methods$to_bytes, self_obj),
    c(
      as.raw(c(0x5f, 0xdb, 0x59, 0xae)),
      peer$to_bytes(),
      as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
      writeBin(2L, raw(), size = 4, endian = "little"),
      writeBin(3L, raw(), size = 4, endian = "little"),
      writeBin(4L, raw(), size = 4, endian = "little")
    )
  )

  expect_error(
    stories_call_method_with_self(DeleteStoriesRequest$public_methods$to_bytes, list(peer = list(), id = 1L)),
    "peer object must provide"
  )
})

test_that("story class helpers read vector results", {
  skip_on_cran()
  reader_empty <- new.env(parent = emptyenv())
  ints_empty <- c(0L)
  i_empty <- 0L
  reader_empty$read_int <- function() {
    i_empty <<- i_empty + 1L
    ints_empty[[i_empty]]
  }
  expect_equal(DeleteStoriesRequest$class$read_result(reader_empty), integer(0))

  reader_full <- new.env(parent = emptyenv())
  ints_full <- c(2L, 10L, 11L)
  i_full <- 0L
  reader_full$read_int <- function() {
    i_full <<- i_full + 1L
    ints_full[[i_full]]
  }
  expect_equal(DeleteStoriesRequest$class$read_result(reader_full), c(10L, 11L))
})

test_that("GetStoryReactionsListRequest covers optional reaction and offset flags", {
  skip_on_cran()
  peer <- stories_peer(as.raw(c(0xaa)))
  reaction <- stories_peer(as.raw(c(0xbb, 0xcc)))
  self_obj <- list(
    peer = peer,
    id = 5L,
    limit = 20L,
    forwards_first = TRUE,
    reaction = reaction,
    offset = "page",
    serialize_bytes = serialize_bytes
  )

  expect_equal(
    stories_call_method_with_self(GetStoryReactionsListRequest$public_methods$to_list, self_obj),
    list(
      "_" = "GetStoryReactionsListRequest",
      peer = peer$to_list(),
      id = 5L,
      limit = 20L,
      forwards_first = TRUE,
      reaction = reaction$to_list(),
      offset = "page"
    )
  )
  expect_equal(
    stories_call_method_with_self(GetStoryReactionsListRequest$public_methods$to_bytes, self_obj),
    c(
      as.raw(c(0x1f, 0x88, 0xb2, 0xb9)),
      writeBin(7L, raw(), size = 4, endian = "little"),
      peer$to_bytes(),
      writeBin(5L, raw(), size = 4, endian = "little"),
      reaction$to_bytes(),
      serialize_bytes("page"),
      writeBin(20L, raw(), size = 4, endian = "little")
    )
  )
})
