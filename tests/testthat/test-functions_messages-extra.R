messages_call_method_with_self <- function(fun, self_list) {
  fcopy <- fun
  newenv <- new.env(parent = environment(fun))
  environment(fcopy) <- newenv
  assign("self", self_list, envir = newenv)
  fcopy()
}

test_that("message invite and import requests serialize strings", {
  skip_on_cran()
  invite <- CheckChatInviteRequest$new("invitehash")
  expect_equal(invite$toDict(), list("_" = "CheckChatInviteRequest", hash = "invitehash"))
  expect_equal(
    invite$bytes(),
    c(as.raw(c(0xbb, 0xb1, 0xad, 0x3e)), serialize_bytes("invitehash"))
  )

  import_self <- list(importHead = "import head", serialize_bytes = serialize_bytes)
  expect_equal(
    messages_call_method_with_self(CheckHistoryImportRequest$public_methods$toDict, import_self),
    list("_" = "CheckHistoryImportRequest", import_head = "import head")
  )
  expect_equal(
    messages_call_method_with_self(CheckHistoryImportRequest$public_methods$bytes, import_self),
    c(as.raw(c(0xf3, 0x19, 0xfe, 0x43)), serialize_bytes("import head"))
  )

  shortcut_self <- list(shortcut = "hello", serialize_bytes = serialize_bytes)
  expect_equal(
    messages_call_method_with_self(CheckQuickReplyShortcutRequest$public_methods$toDict, shortcut_self),
    list("_" = "CheckQuickReplyShortcutRequest", shortcut = "hello")
  )
  expect_equal(
    messages_call_method_with_self(CheckQuickReplyShortcutRequest$public_methods$bytes, shortcut_self),
    c(as.raw(c(0xd3, 0xfb, 0xd0, 0xf1)), serialize_bytes("hello"))
  )
})

test_that("message string request fromReader methods rebuild instances", {
  skip_on_cran()
  reader <- new.env(parent = emptyenv())
  strings <- c("hash", "head", "shortcut")
  idx <- 0L
  reader$tgreadString <- function() {
    idx <<- idx + 1L
    strings[[idx]]
  }

  expect_equal(CheckChatInviteRequest$fromReader(reader)$toDict()$hash, "hash")
})

test_that("fixed message requests serialize and read back", {
  skip_on_cran()
  clear_drafts <- ClearAllDraftsRequest$new()
  expect_equal(clear_drafts$toDict(), list("_" = "ClearAllDraftsRequest"))
  expect_equal(clear_drafts$bytes(), as.raw(c(0x9c, 0xee, 0x58, 0x7e)))
  expect_s3_class(ClearAllDraftsRequest$fromReader(NULL), "ClearAllDraftsRequest")

  clear_reactions <- ClearRecentReactionsRequest$new()
  expect_equal(clear_reactions$toDict(), list("_" = "ClearRecentReactionsRequest"))
  expect_equal(clear_reactions$bytes(), as.raw(c(0xb4, 0xef, 0xfe, 0x9d)))

  drafts <- GetAllDraftsRequest$new()
  expect_equal(drafts$toDict(), list("_" = "GetAllDraftsRequest"))
  expect_equal(drafts$bytes(), as.raw(c(0x65, 0x8d, 0x3f, 0x6a)))
  expect_s3_class(GetAllDraftsRequest$fromReader(NULL), "GetAllDraftsRequest")
})

test_that("DeleteMessagesRequest covers revoke flags and reader vectors", {
  skip_on_cran()
  self_obj <- list(id = list(10L, 11L), revoke = TRUE)
  expect_equal(
    messages_call_method_with_self(DeleteMessagesRequest$public_methods$toDict, self_obj),
    list("_" = "DeleteMessagesRequest", id = list(10L, 11L), revoke = TRUE)
  )
  expect_equal(
    messages_call_method_with_self(DeleteMessagesRequest$public_methods$bytes, self_obj),
    c(
      as.raw(c(0xd2, 0x95, 0x8e, 0xe5)),
      pack("<I", 1L),
      as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
      pack("<i", 2L),
      pack("<i", 10L),
      pack("<i", 11L)
    )
  )

  no_revoke <- list(id = list(12L), revoke = FALSE)
  expect_equal(
    messages_call_method_with_self(DeleteMessagesRequest$public_methods$bytes, no_revoke)[5:8],
    as.raw(pack("<I", 0L))
  )
})

test_that("sticker message requests cover integer and flag fields", {
  skip_on_cran()
  stickers <- GetAllStickersRequest$new(hash = 42)
  expect_equal(stickers$toDict(), list("_" = "GetAllStickersRequest", hash = 42))
  expect_equal(
    stickers$bytes(),
    c(as.raw(c(0xa8, 0xa1, 0xa0, 0xb8)), pack("<q", 42))
  )

  archived <- list(offsetId = 100, limit = 25L, masks = TRUE, emojis = TRUE)
  expect_equal(
    messages_call_method_with_self(GetArchivedStickersRequest$public_methods$toDict, archived),
    list("_" = "GetArchivedStickersRequest", offset_id = 100, limit = 25L, masks = TRUE, emojis = TRUE)
  )
  expect_equal(
    messages_call_method_with_self(GetArchivedStickersRequest$public_methods$bytes, archived),
    c(as.raw(c(0x92, 0x76, 0xf1, 0x57)), pack("<I", 3L), pack("<q", 100), pack("<i", 25L))
  )

  no_flags <- list(offsetId = 101, limit = 10L, masks = FALSE, emojis = NULL)
  expect_equal(
    messages_call_method_with_self(GetArchivedStickersRequest$public_methods$bytes, no_flags)[5:8],
    as.raw(pack("<I", 0L))
  )
})

test_that("GetChatsRequest covers 64-bit id vectors", {
  skip_on_cran()
  self_obj <- list(id = list(1, 2))
  expect_equal(
    messages_call_method_with_self(GetChatsRequest$public_methods$toDict, self_obj),
    list("_" = "GetChatsRequest", id = list(1, 2))
  )
  expect_equal(
    messages_call_method_with_self(GetChatsRequest$public_methods$bytes, self_obj),
    c(
      as.raw(c(0x49, 0xe9, 0x52, 0x8f)),
      as.raw(c(0x1c, 0xb5, 0xc4, 0x15)),
      pack("<i", 2L),
      pack("<q", 1),
      pack("<q", 2)
    )
  )
})
