# Extended coverage tests for R/functions_stories.R
# Classes cannot be instantiated with $new() due to the `class = list(...)` R6 bug.
# All tests use $public_methods$<method> + stories_call_method_with_self() instead.

# Local helper (mirrors the one in test-functions_stories-extra.R)
if (!exists("stories_call_method_with_self", inherits = FALSE)) {
  stories_call_method_with_self <- function(fun, self_list) {
    fcopy <- fun
    newenv <- new.env(parent = environment(fun))
    environment(fcopy) <- newenv
    assign("self", self_list, envir = newenv)
    fcopy()
  }
}

.sp <- function(bytes = as.raw(c(0x01, 0x02, 0x03))) {
  structure(
    list(
      to_bytes = function() bytes,
      bytes    = function() bytes,
      to_list  = function() list("_" = "TestPeer")
    ),
    class = c("TestPeer", "TLObject")
  )
}

# ── ActivateStealthModeRequest ────────────────────────────────────────────────
test_that("ActivateStealthModeRequest to_list works", {
  skip_on_cran()
  self_obj <- list(past = TRUE, future = NULL)
  result <- stories_call_method_with_self(
    ActivateStealthModeRequest$public_methods$to_list, self_obj)
  expect_equal(result[["_"]], "ActivateStealthModeRequest")
  expect_true(result$past)
  expect_null(result$future)
})

test_that("ActivateStealthModeRequest to_bytes encodes flags correctly", {
  skip_on_cran()
  # past=TRUE => flag bit 0; constructor 0x57bbd166
  b_past <- stories_call_method_with_self(
    ActivateStealthModeRequest$public_methods$to_bytes, list(past = TRUE, future = NULL))
  expect_equal(b_past[1:4], as.raw(c(0x66, 0xd1, 0xbb, 0x57)))
  flags_past <- readBin(b_past[5:8], integer(), n = 1, size = 4, endian = "little")
  expect_equal(bitwAnd(flags_past, 1L), 1L)
  expect_equal(bitwAnd(flags_past, 2L), 0L)

  # future=TRUE => flag bit 1
  b_future <- stories_call_method_with_self(
    ActivateStealthModeRequest$public_methods$to_bytes, list(past = NULL, future = TRUE))
  flags_future <- readBin(b_future[5:8], integer(), n = 1, size = 4, endian = "little")
  expect_equal(bitwAnd(flags_future, 1L), 0L)
  expect_equal(bitwAnd(flags_future, 2L), 2L)

  # both=NULL => flags=0
  b_none <- stories_call_method_with_self(
    ActivateStealthModeRequest$public_methods$to_bytes, list(past = NULL, future = NULL))
  flags_none <- readBin(b_none[5:8], integer(), n = 1, size = 4, endian = "little")
  expect_equal(flags_none, 0L)
})

# ── CanSendStoryRequest ───────────────────────────────────────────────────────
test_that("CanSendStoryRequest to_list works", {
  skip_on_cran()
  peer <- .sp()
  result <- stories_call_method_with_self(
    CanSendStoryRequest$public_methods$to_list, list(peer = peer))
  expect_equal(result[["_"]], "CanSendStoryRequest")
  expect_equal(result$peer, peer$to_list())
})

test_that("CanSendStoryRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0x30eb63f0 -> LE: f0 63 eb 30
  b <- stories_call_method_with_self(
    CanSendStoryRequest$public_methods$to_bytes, list(peer = .sp()))
  expect_equal(b[1:4], as.raw(c(0xf0, 0x63, 0xeb, 0x30)))
})

# ── CreateAlbumRequest ────────────────────────────────────────────────────────
test_that("CreateAlbumRequest to_list works", {
  skip_on_cran()
  peer <- .sp()
  result <- stories_call_method_with_self(
    CreateAlbumRequest$public_methods$to_list,
    list(peer = peer, title = "My Album", stories = c(1L, 2L)))
  expect_equal(result[["_"]], "CreateAlbumRequest")
  expect_equal(result$title, "My Album")
  expect_equal(result$stories, c(1L, 2L))
})

test_that("CreateAlbumRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0xa36396e5 -> LE: e5 96 63 a3
  b <- stories_call_method_with_self(
    CreateAlbumRequest$public_methods$to_bytes,
    list(peer = .sp(), title = "T", stories = integer(0)))
  expect_equal(b[1:4], as.raw(c(0xe5, 0x96, 0x63, 0xa3)))
})

# ── DeleteAlbumRequest ────────────────────────────────────────────────────────
test_that("DeleteAlbumRequest to_list works", {
  skip_on_cran()
  peer <- .sp()
  result <- stories_call_method_with_self(
    DeleteAlbumRequest$public_methods$to_list,
    list(peer = peer, album_id = 42L))
  expect_equal(result[["_"]], "DeleteAlbumRequest")
  expect_equal(result$album_id, 42L)
})

test_that("DeleteAlbumRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0x8d3456d0 -> LE: d0 56 34 8d
  b <- stories_call_method_with_self(
    DeleteAlbumRequest$public_methods$to_bytes,
    list(peer = .sp(), album_id = 1L))
  expect_equal(b[1:4], as.raw(c(0xd0, 0x56, 0x34, 0x8d)))
})

# ── EditStoryRequest ──────────────────────────────────────────────────────────
test_that("EditStoryRequest to_list works with minimal fields", {
  skip_on_cran()
  peer <- .sp()
  result <- stories_call_method_with_self(
    EditStoryRequest$public_methods$to_list,
    list(peer = peer, id = 5L, media = NULL, media_areas = NULL,
         caption = NULL, entities = NULL, privacy_rules = NULL))
  expect_equal(result[["_"]], "EditStoryRequest")
  expect_equal(result$id, 5L)
  expect_null(result$media)
})

test_that("EditStoryRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0xb583ba46 -> LE: 46 ba 83 b5
  b <- stories_call_method_with_self(
    EditStoryRequest$public_methods$to_bytes,
    list(peer = .sp(), id = 1L, media = NULL, media_areas = NULL,
         caption = NULL, entities = NULL, privacy_rules = NULL))
  expect_equal(b[1:4], as.raw(c(0x46, 0xba, 0x83, 0xb5)))
})

# ── ExportStoryLinkRequest ────────────────────────────────────────────────────
test_that("ExportStoryLinkRequest to_list works", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    ExportStoryLinkRequest$public_methods$to_list,
    list(peer = .sp(), id = 7L))
  expect_equal(result[["_"]], "ExportStoryLinkRequest")
  expect_equal(result$id, 7L)
})

test_that("ExportStoryLinkRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0x7b8def20 -> LE: 20 ef 8d 7b
  b <- stories_call_method_with_self(
    ExportStoryLinkRequest$public_methods$to_bytes,
    list(peer = .sp(), id = 1L))
  expect_equal(b[1:4], as.raw(c(0x20, 0xef, 0x8d, 0x7b)))
})

# ── GetAlbumStoriesRequest ────────────────────────────────────────────────────
test_that("GetAlbumStoriesRequest to_list works", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    GetAlbumStoriesRequest$public_methods$to_list,
    list(peer = .sp(), album_id = 3L, offset = 0L, limit = 20L))
  expect_equal(result[["_"]], "GetAlbumStoriesRequest")
  expect_equal(result$limit, 20L)
})

test_that("GetAlbumStoriesRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0xac806d61 -> LE: 61 6d 80 ac
  b <- stories_call_method_with_self(
    GetAlbumStoriesRequest$public_methods$to_bytes,
    list(peer = .sp(), album_id = 1L, offset = 0L, limit = 5L))
  expect_equal(b[1:4], as.raw(c(0x61, 0x6d, 0x80, 0xac)))
})

# ── GetAlbumsRequest ──────────────────────────────────────────────────────────
test_that("GetAlbumsRequest to_list works", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    GetAlbumsRequest$public_methods$to_list,
    list(peer = .sp(), hash = 0))
  expect_equal(result[["_"]], "GetAlbumsRequest")
  expect_equal(result$hash, 0)
})

test_that("GetAlbumsRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0x25b3eac7 -> LE: c7 ea b3 25
  b <- stories_call_method_with_self(
    GetAlbumsRequest$public_methods$to_bytes,
    list(peer = .sp(), hash = 0))
  expect_equal(b[1:4], as.raw(c(0xc7, 0xea, 0xb3, 0x25)))
})

# ── GetPeerMaxIDsRequest ──────────────────────────────────────────────────────
test_that("GetPeerMaxIDsRequest to_list works with empty peer list", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    GetPeerMaxIDsRequest$public_methods$to_list,
    list(id = list()))
  expect_equal(result[["_"]], "GetPeerMaxIDsRequest")
  expect_equal(length(result$id), 0L)
})

test_that("GetPeerMaxIDsRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0x535983c3 -> LE: c3 83 59 53
  b <- stories_call_method_with_self(
    GetPeerMaxIDsRequest$public_methods$to_bytes,
    list(id = list()))
  expect_equal(b[1:4], as.raw(c(0xc3, 0x83, 0x59, 0x53)))
})

# ── GetPeerStoriesRequest ─────────────────────────────────────────────────────
test_that("GetPeerStoriesRequest to_list works", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    GetPeerStoriesRequest$public_methods$to_list,
    list(peer = .sp()))
  expect_equal(result[["_"]], "GetPeerStoriesRequest")
})

test_that("GetPeerStoriesRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0x2c4ada50 -> LE: 50 da 4a 2c
  b <- stories_call_method_with_self(
    GetPeerStoriesRequest$public_methods$to_bytes,
    list(peer = .sp()))
  expect_equal(b[1:4], as.raw(c(0x50, 0xda, 0x4a, 0x2c)))
})

# ── GetPinnedStoriesRequest ───────────────────────────────────────────────────
test_that("GetPinnedStoriesRequest to_list works", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    GetPinnedStoriesRequest$public_methods$to_list,
    list(peer = .sp(), offset_id = 0L, limit = 10L))
  expect_equal(result[["_"]], "GetPinnedStoriesRequest")
  expect_equal(result$limit, 10L)
})

test_that("GetPinnedStoriesRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0x5821a5dc -> LE: dc a5 21 58
  b <- stories_call_method_with_self(
    GetPinnedStoriesRequest$public_methods$to_bytes,
    list(peer = .sp(), offset_id = 0L, limit = 10L))
  expect_equal(b[1:4], as.raw(c(0xdc, 0xa5, 0x21, 0x58)))
})

# ── GetStoriesArchiveRequest ──────────────────────────────────────────────────
test_that("GetStoriesArchiveRequest to_list works", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    GetStoriesArchiveRequest$public_methods$to_list,
    list(peer = .sp(), offset_id = 0L, limit = 25L))
  expect_equal(result[["_"]], "GetStoriesArchiveRequest")
  expect_equal(result$limit, 25L)
})

test_that("GetStoriesArchiveRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0xb4352016 -> LE: 16 20 35 b4
  b <- stories_call_method_with_self(
    GetStoriesArchiveRequest$public_methods$to_bytes,
    list(peer = .sp(), offset_id = 0L, limit = 5L))
  expect_equal(b[1:4], as.raw(c(0x16, 0x20, 0x35, 0xb4)))
})

# ── GetStoriesByIDRequest ─────────────────────────────────────────────────────
test_that("GetStoriesByIDRequest to_list works", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    GetStoriesByIDRequest$public_methods$to_list,
    list(peer = .sp(), id = c(1L, 2L, 3L)))
  expect_equal(result[["_"]], "GetStoriesByIDRequest")
  expect_equal(result$id, c(1L, 2L, 3L))
})

test_that("GetStoriesByIDRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0x5774ca74 -> LE: 74 ca 74 57
  b <- stories_call_method_with_self(
    GetStoriesByIDRequest$public_methods$to_bytes,
    list(peer = .sp(), id = integer(0)))
  expect_equal(b[1:4], as.raw(c(0x74, 0xca, 0x74, 0x57)))
})

# ── GetStoriesViewsRequest ────────────────────────────────────────────────────
test_that("GetStoriesViewsRequest to_list works", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    GetStoriesViewsRequest$public_methods$to_list,
    list(peer = .sp(), id = c(10L, 20L)))
  expect_equal(result[["_"]], "GetStoriesViewsRequest")
  expect_equal(result$id, c(10L, 20L))
})

test_that("GetStoriesViewsRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0x28e16cc8 -> LE: c8 6c e1 28... actually 0x28e16cc8
  # LE bytes: 0xc8 0x6c 0xe1 0x28
  b <- stories_call_method_with_self(
    GetStoriesViewsRequest$public_methods$to_bytes,
    list(peer = .sp(), id = integer(0)))
  expect_equal(b[1:4], as.raw(c(0xc8, 0x6c, 0xe1, 0x28)))
})

# ── GetStoryViewsListRequest ──────────────────────────────────────────────────
test_that("GetStoryViewsListRequest to_list works with no optional flags", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    GetStoryViewsListRequest$public_methods$to_list,
    list(peer = .sp(), id = 5L, limit = 20L,
         just_contacts = NULL, reactions_first = NULL, forwards_first = NULL,
         q = NULL, offset = ""))
  expect_equal(result[["_"]], "GetStoryViewsListRequest")
  expect_equal(result$limit, 20L)
})

# ── IncrementStoryViewsRequest ────────────────────────────────────────────────
test_that("IncrementStoryViewsRequest to_list works", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    IncrementStoryViewsRequest$public_methods$to_list,
    list(peer = .sp(), id = c(1L, 2L)))
  expect_equal(result[["_"]], "IncrementStoryViewsRequest")
  expect_equal(result$id, c(1L, 2L))
})

test_that("IncrementStoryViewsRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0xb2028afb -> LE: fb 8a 02 b2
  b <- stories_call_method_with_self(
    IncrementStoryViewsRequest$public_methods$to_bytes,
    list(peer = .sp(), id = integer(0)))
  expect_equal(b[1:4], as.raw(c(0xfb, 0x8a, 0x02, 0xb2)))
})

# ── ReadStoriesRequest ────────────────────────────────────────────────────────
test_that("ReadStoriesRequest to_list works", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    ReadStoriesRequest$public_methods$to_list,
    list(peer = .sp(), max_id = 99L))
  expect_equal(result[["_"]], "ReadStoriesRequest")
  expect_equal(result$max_id, 99L)
})

test_that("ReadStoriesRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0xa556dac8 -> LE: c8 da 56 a5
  b <- stories_call_method_with_self(
    ReadStoriesRequest$public_methods$to_bytes,
    list(peer = .sp(), max_id = 1L))
  expect_equal(b[1:4], as.raw(c(0xc8, 0xda, 0x56, 0xa5)))
})

# ── ReorderAlbumsRequest ──────────────────────────────────────────────────────
test_that("ReorderAlbumsRequest to_list works", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    ReorderAlbumsRequest$public_methods$to_list,
    list(peer = .sp(), order = c(3L, 1L, 2L)))
  expect_equal(result[["_"]], "ReorderAlbumsRequest")
  expect_equal(result$order, c(3L, 1L, 2L))
})

test_that("ReorderAlbumsRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0x8535fbd9 -> LE: d9 fb 35 85
  b <- stories_call_method_with_self(
    ReorderAlbumsRequest$public_methods$to_bytes,
    list(peer = .sp(), order = integer(0)))
  expect_equal(b[1:4], as.raw(c(0xd9, 0xfb, 0x35, 0x85)))
})

# ── ReportRequest ─────────────────────────────────────────────────────────────
test_that("ReportRequest to_list works", {
  skip_on_cran()
  .option_peer <- structure(
    list(to_bytes = function() as.raw(c(0xAA)), bytes = function() as.raw(c(0xAA)),
         to_list = function() list("_" = "ReportOption")),
    class = c("ReportOption", "TLObject"))
  result <- stories_call_method_with_self(
    ReportRequest$public_methods$to_list,
    list(peer = .sp(), id = c(1L), option = .option_peer, message = "spam"))
  expect_equal(result[["_"]], "ReportRequest")
  expect_equal(result$message, "spam")
})

# ── SearchPostsRequest ────────────────────────────────────────────────────────
test_that("SearchPostsRequest to_list works with no optional fields", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    SearchPostsRequest$public_methods$to_list,
    list(offset = "", limit = 20L, hashtag = NULL, area = NULL, peer = NULL))
  expect_equal(result[["_"]], "SearchPostsRequest")
  expect_equal(result$limit, 20L)
  expect_null(result$hashtag)
})

test_that("SearchPostsRequest to_list includes optional hashtag", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    SearchPostsRequest$public_methods$to_list,
    list(offset = "", limit = 10L, hashtag = "#rust", area = NULL, peer = NULL))
  expect_equal(result$hashtag, "#rust")
})

# ── SendReactionRequest ───────────────────────────────────────────────────────
test_that("SendReactionRequest to_list works with no add_to_recent", {
  skip_on_cran()
  .reaction <- structure(
    list(to_bytes = function() as.raw(c(0xBB)), bytes = function() as.raw(c(0xBB)),
         to_list = function() list("_" = "ReactionEmoji")),
    class = c("ReactionEmoji", "TLObject"))
  result <- stories_call_method_with_self(
    SendReactionRequest$public_methods$to_list,
    list(peer = .sp(), story_id = 5L, reaction = .reaction, add_to_recent = NULL))
  expect_equal(result[["_"]], "SendReactionRequest")
  expect_equal(result$story_id, 5L)
  expect_null(result$add_to_recent)
})

test_that("SendReactionRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0x7fd736b2 -> LE: b2 36 d7 7f
  .reaction <- structure(
    list(to_bytes = function() as.raw(c(0xBB)), bytes = function() as.raw(c(0xBB)),
         to_list = function() list("_" = "ReactionEmoji")),
    class = c("ReactionEmoji", "TLObject"))
  b <- stories_call_method_with_self(
    SendReactionRequest$public_methods$to_bytes,
    list(peer = .sp(), story_id = 5L, reaction = .reaction, add_to_recent = NULL))
  expect_equal(b[1:4], as.raw(c(0xb2, 0x36, 0xd7, 0x7f)))
})

# ── SendStoryRequest ──────────────────────────────────────────────────────────
test_that("SendStoryRequest to_list works with minimal fields", {
  skip_on_cran()
  .media <- structure(
    list(to_bytes = function() as.raw(c(0x11)), bytes = function() as.raw(c(0x11)),
         to_list = function() list("_" = "InputMediaEmpty")),
    class = c("InputMediaEmpty", "TLObject"))
  result <- stories_call_method_with_self(
    SendStoryRequest$public_methods$to_list,
    list(peer = .sp(), media = .media, privacy_rules = list(),
         pinned = NULL, noforwards = NULL, fwd_modified = NULL,
         fwd_from_id = NULL, fwd_from_story = NULL, period = NULL,
         caption = NULL, entities = NULL, media_areas = NULL,
         random_id = 12345L))
  expect_equal(result[["_"]], "SendStoryRequest")
  expect_equal(result$random_id, 12345L)
})

# ── ToggleAllStoriesHiddenRequest ─────────────────────────────────────────────
test_that("ToggleAllStoriesHiddenRequest to_list works", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    ToggleAllStoriesHiddenRequest$public_methods$to_list,
    list(hidden = TRUE))
  expect_equal(result[["_"]], "ToggleAllStoriesHiddenRequest")
  expect_true(result$hidden)
})

test_that("ToggleAllStoriesHiddenRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0x7c2557c4 -> LE: c4 57 25 7c
  b <- stories_call_method_with_self(
    ToggleAllStoriesHiddenRequest$public_methods$to_bytes,
    list(hidden = FALSE))
  expect_equal(b[1:4], as.raw(c(0xc4, 0x57, 0x25, 0x7c)))
})

# ── TogglePeerStoriesHiddenRequest ────────────────────────────────────────────
test_that("TogglePeerStoriesHiddenRequest to_list works", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    TogglePeerStoriesHiddenRequest$public_methods$to_list,
    list(peer = .sp(), hidden = FALSE))
  expect_equal(result[["_"]], "TogglePeerStoriesHiddenRequest")
  expect_false(result$hidden)
})

test_that("TogglePeerStoriesHiddenRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0xbd0415c4 -> LE: c4 15 04 bd
  b <- stories_call_method_with_self(
    TogglePeerStoriesHiddenRequest$public_methods$to_bytes,
    list(peer = .sp(), hidden = TRUE))
  expect_equal(b[1:4], as.raw(c(0xc4, 0x15, 0x04, 0xbd)))
})

# ── TogglePinnedRequest ───────────────────────────────────────────────────────
test_that("TogglePinnedRequest to_list works", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    TogglePinnedRequest$public_methods$to_list,
    list(peer = .sp(), id = c(10L), pinned = TRUE))
  expect_equal(result[["_"]], "TogglePinnedRequest")
  expect_true(result$pinned)
})

test_that("TogglePinnedRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0x9a75a1ef -> LE: ef a1 75 9a
  b <- stories_call_method_with_self(
    TogglePinnedRequest$public_methods$to_bytes,
    list(peer = .sp(), id = integer(0), pinned = FALSE))
  expect_equal(b[1:4], as.raw(c(0xef, 0xa1, 0x75, 0x9a)))
})

# ── TogglePinnedToTopRequest ──────────────────────────────────────────────────
test_that("TogglePinnedToTopRequest to_list works", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    TogglePinnedToTopRequest$public_methods$to_list,
    list(peer = .sp(), id = c(5L)))
  expect_equal(result[["_"]], "TogglePinnedToTopRequest")
})

test_that("TogglePinnedToTopRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0x0b297e9b -> LE: 9b 7e 29 0b
  b <- stories_call_method_with_self(
    TogglePinnedToTopRequest$public_methods$to_bytes,
    list(peer = .sp(), id = integer(0)))
  expect_equal(b[1:4], as.raw(c(0x9b, 0x7e, 0x29, 0x0b)))
})

# ── UpdateAlbumRequest ────────────────────────────────────────────────────────
test_that("UpdateAlbumRequest to_list works with title only", {
  skip_on_cran()
  result <- stories_call_method_with_self(
    UpdateAlbumRequest$public_methods$to_list,
    list(peer = .sp(), album_id = 1L, title = "Updated",
         delete_stories = NULL, add_stories = NULL, order = NULL))
  expect_equal(result[["_"]], "UpdateAlbumRequest")
  expect_equal(result$title, "Updated")
})

test_that("UpdateAlbumRequest to_bytes starts with correct constructor", {
  skip_on_cran()
  # CONSTRUCTOR_ID = 0x5e5259b6 -> LE: b6 59 52 5e
  b <- stories_call_method_with_self(
    UpdateAlbumRequest$public_methods$to_bytes,
    list(peer = .sp(), album_id = 1L, title = NULL,
         delete_stories = NULL, add_stories = NULL, order = NULL,
         serialize_bytes = serialize_bytes))
  expect_equal(b[1:4], as.raw(c(0xb6, 0x59, 0x52, 0x5e)))
})
