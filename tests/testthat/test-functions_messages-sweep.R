# Bulk-coverage sweep over the simpler request classes in functions_messages.R.
# Most generated R6 classes have lock_objects = TRUE with no field declarations,
# so $new() throws "cannot add bindings to a locked environment". We therefore
# call public_methods$bytes / public_methods$toDict directly with a hand-built
# `self`, which is the same pattern used in test-functions_messages-extra.R.

call_with_self <- function(fun, self_list) {
  fcopy <- fun
  newenv <- new.env(parent = environment(fun))
  environment(fcopy) <- newenv
  assign("self", self_list, envir = newenv)
  fcopy()
}

scalar_reader <- function(value) {
  r <- new.env(parent = emptyenv())
  r$readLong <- function() value
  r$readInt  <- function() value
  r
}

test_that("no-arg request classes expose stable wire format", {
  skip_on_cran()
  no_init <- c(
    "GetDefaultHistoryTTLRequest", "GetDialogFiltersRequest",
    "GetPaidReactionPrivacyRequest", "GetSplitRangesRequest",
    "GetSuggestedDialogFiltersRequest"
  )
  for (name in no_init) {
    cls <- get(name)
    req <- cls$new()
    expect_s3_class(req, name)
    b <- req$bytes()
    expect_true(is.raw(b))
    expect_length(b, 4)
    expect_equal(req$toDict()[["_"]], name)
    expect_s3_class(cls$fromReader(NULL), name)
  }
})

test_that("hash-only request classes (long) serialize and read back", {
  skip_on_cran()
  # Bytes are taken verbatim from each class's bytes() body so the test pins
  # the wire format regardless of the LE/BE conventions used in the generator.
  long_hash <- list(
    GetAllStickersRequest           = c(0xa8, 0xa1, 0xa0, 0xb8),
    GetAttachMenuBotsRequest        = c(0xcb, 0xc2, 0xfc, 0x16),
    GetDefaultTagReactionsRequest   = c(0xbd, 0xf9, 0x34, 0x28),
    GetEmojiStickersRequest         = c(0x8f, 0xa1, 0xfc, 0xfb),
    GetFavedStickersRequest         = c(0xa9, 0xaa, 0xf1, 0x04),
    GetFeaturedEmojiStickersRequest = c(0x36, 0x67, 0xcf, 0x0e),
    GetFeaturedStickersRequest      = c(0x14, 0x0b, 0x78, 0x64),
    GetMaskStickersRequest          = c(0xb8, 0x82, 0x0f, 0x64),
    GetQuickRepliesRequest          = c(0xa8, 0xf2, 0x83, 0xd4),
    GetSavedGifsRequest             = c(0x35, 0x96, 0xf0, 0x5c)
  )
  # Only classes with lock_objects = FALSE can round-trip through fromReader,
  # since fromReader hits Class$new(...) which fails on locked R6 envs.
  unlocked <- c("GetAllStickersRequest", "GetAttachMenuBotsRequest")
  for (name in names(long_hash)) {
    cls <- get(name)
    expected <- c(as.raw(long_hash[[name]]), pack("<q", 42))
    self_obj <- list(hash = 42)
    expect_equal(call_with_self(cls$public_methods$bytes, self_obj), expected,
                 info = paste("bytes mismatch for", name))
    d <- call_with_self(cls$public_methods$toDict, self_obj)
    expect_equal(d[["_"]], name)
    expect_equal(d[["hash"]], 42)

    if (name %in% unlocked) {
      rebuilt <- cls$fromReader(scalar_reader(7))
      expect_equal(rebuilt$hash, 7)
    }
  }
})

test_that("hash-only request classes (int) serialize and read back", {
  skip_on_cran()
  int_hash <- list(
    GetAvailableEffectsRequest        = c(0xde, 0xa2, 0x0a, 0x39),
    GetAvailableReactionsRequest      = c(0x18, 0xde, 0xa0, 0xac),
    GetEmojiGroupsRequest             = c(0x5b, 0xce, 0x88, 0x74),
    GetEmojiProfilePhotoGroupsRequest = c(0xf3, 0x48, 0xa5, 0x21),
    GetEmojiStatusGroupsRequest       = c(0xcd, 0x56, 0xcd, 0x2e),
    GetEmojiStickerGroupsRequest      = c(0xf5, 0x40, 0xd8, 0x1d)
  )
  for (name in names(int_hash)) {
    cls <- get(name)
    expected <- c(as.raw(int_hash[[name]]), pack("<i", 13L))
    self_obj <- list(hash = 13L)
    expect_equal(call_with_self(cls$public_methods$bytes, self_obj), expected,
                 info = paste("bytes mismatch for", name))
    expect_equal(call_with_self(cls$public_methods$toDict, self_obj)[["hash"]], 13L)
  }
})

test_that("single long-id request classes serialize and read back", {
  skip_on_cran()
  long_id <- list(
    list(name = "DeleteChatRequest",  cid = c(0x50, 0xee, 0xd0, 0x5b),
         arg = "chatId", dict = "chat_id"),
    list(name = "GetFullChatRequest", cid = c(0x34, 0x0b, 0xb0, 0xae),
         arg = "chatId", dict = "chat_id")
  )
  for (spec in long_id) {
    cls <- get(spec$name)
    self_obj <- setNames(list(123), spec$arg)
    expect_equal(
      call_with_self(cls$public_methods$bytes, self_obj),
      c(as.raw(spec$cid), pack("<q", 123)),
      info = paste("bytes mismatch for", spec$name)
    )
    expect_equal(call_with_self(cls$public_methods$toDict, self_obj)[[spec$dict]], 123)
  }
})

test_that("single int-id request classes serialize and read back", {
  skip_on_cran()
  int_id <- list(
    list(name = "DeleteQuickReplyShortcutRequest", cid = c(0x40, 0x47, 0xc0, 0x3c),
         arg = "shortcutId", dict = "shortcut_id"),
    list(name = "GetPinnedDialogsRequest",         cid = c(0xf2, 0x4d, 0xb9, 0xd6),
         arg = "folderId",   dict = "folder_id")
  )
  for (spec in int_id) {
    cls <- get(spec$name)
    self_obj <- setNames(list(5L), spec$arg)
    expect_equal(
      call_with_self(cls$public_methods$bytes, self_obj),
      c(as.raw(spec$cid), pack("<i", 5L)),
      info = paste("bytes mismatch for", spec$name)
    )
    expect_equal(call_with_self(cls$public_methods$toDict, self_obj)[[spec$dict]], 5L)
  }
})

test_that("single-string request classes serialize and read back", {
  skip_on_cran()
  string_arg <- list(
    list(name = "GetEmojiKeywordsRequest", cid = c(0x62, 0xe0, 0xa0, 0x35),
         arg = "langCode", dict = "lang_code"),
    list(name = "GetEmojiURLRequest",      cid = c(0x26, 0x0c, 0xb1, 0xd5),
         arg = "langCode", dict = "lang_code"),
    list(name = "ImportChatInviteRequest", cid = c(0x1c, 0x05, 0x50, 0x6c),
         arg = "hash",     dict = "hash")
  )
  for (spec in string_arg) {
    cls <- get(spec$name)
    self_obj <- c(setNames(list("xyz"), spec$arg),
                  list(serialize_bytes = serialize_bytes))
    expect_equal(
      call_with_self(cls$public_methods$bytes, self_obj),
      c(as.raw(spec$cid), serialize_bytes("xyz")),
      info = paste("bytes mismatch for", spec$name)
    )
    expect_equal(call_with_self(cls$public_methods$toDict, self_obj)[[spec$dict]], "xyz")
  }
})

test_that("two-scalar request classes serialize and dict-shape correctly", {
  skip_on_cran()
  # Each spec describes (name, constructor bytes, args list, body bytes builder).
  # The body builder closes over the scalar args we pass into self.
  specs <- list(
    list(name = "EditChatTitleRequest",
         cid  = c(0xfd, 0x3f, 0x78, 0x73),
         args = list(chatId = 7, title = "hi"),
         dict = list(chat_id = 7, title = "hi"),
         body = function(s) c(pack("<q", s$chatId), serialize_bytes(s$title))),
    list(name = "EditQuickReplyShortcutRequest",
         cid  = c(0xef, 0x3c, 0x00, 0x5c),
         args = list(shortcutId = 3L, shortcut = "n"),
         dict = list(shortcut_id = 3L, shortcut = "n"),
         body = function(s) c(pack("<i", s$shortcutId), serialize_bytes(s$shortcut))),
    list(name = "GetDhConfigRequest",
         cid  = c(0x26, 0xcf, 0x89, 0x50),
         args = list(version = 2L, randomLength = 256L),
         dict = list(version = 2L, random_length = 256L),
         body = function(s) c(pack("<i", s$version), pack("<i", s$randomLength))),
    list(name = "GetMyStickersRequest",
         cid  = c(0xfc, 0xe1, 0xb5, 0xd0),
         args = list(offsetId = 1, limit = 50L),
         dict = list(offset_id = 1, limit = 50L),
         body = function(s) c(pack("<q", s$offsetId), pack("<i", s$limit))),
    list(name = "GetRecentReactionsRequest",
         cid  = c(0xb2, 0x1d, 0x46, 0x39),
         args = list(limit = 10L, hash = 4),
         dict = list(limit = 10L, hash = 4),
         body = function(s) c(pack("<i", s$limit), pack("<q", s$hash))),
    list(name = "GetTopReactionsRequest",
         cid  = c(0xbb, 0x81, 0x25, 0xba),
         args = list(limit = 10L, hash = 4),
         dict = list(limit = 10L, hash = 4),
         body = function(s) c(pack("<i", s$limit), pack("<q", s$hash))),
    list(name = "GetWebPageRequest",
         cid  = c(0xa3, 0x92, 0x96, 0x8d),
         args = list(url = "https://x", hash = 0L),
         dict = list(url = "https://x", hash = 0L),
         body = function(s) c(serialize_bytes(s$url), pack("<i", s$hash))),
    list(name = "GetStickersRequest",
         cid  = c(0xd5, 0xa5, 0xd3, 0xa1),
         args = list(emoticon = ":)", hash = 8),
         dict = list(emoticon = ":)", hash = 8),
         body = function(s) c(serialize_bytes(s$emoticon), pack("<q", s$hash))),
    list(name = "GetEmojiKeywordsDifferenceRequest",
         cid  = c(0xaf, 0xb6, 0x08, 0x15),
         args = list(langCode = "en", fromVersion = 5L),
         dict = list(lang_code = "en", from_version = 5L),
         body = function(s) c(serialize_bytes(s$langCode), pack("<i", s$fromVersion)))
  )
  for (spec in specs) {
    cls <- get(spec$name)
    self_obj <- c(spec$args, list(serialize_bytes = serialize_bytes))
    expect_equal(
      call_with_self(cls$public_methods$bytes, self_obj),
      c(as.raw(spec$cid), spec$body(self_obj)),
      info = paste("bytes mismatch for", spec$name)
    )
    d <- call_with_self(cls$public_methods$toDict, self_obj)
    expect_equal(d[["_"]], spec$name)
    for (k in names(spec$dict)) {
      expect_equal(d[[k]], spec$dict[[k]],
                   info = paste(spec$name, "dict mismatch on", k))
    }
  }
})

test_that("single-TLObject request classes delegate to obj$bytes()", {
  skip_on_cran()
  # Both to_dict and toDict are present because the generator emits both
  # snake_case and camelCase wrappers across different classes.
  dict_fn <- function() list("_" = "Fake")
  fake_obj <- structure(
    list(
      bytes   = function() as.raw(c(0xaa, 0xbb, 0xcc, 0xdd)),
      toDict  = dict_fn,
      to_dict = dict_fn
    ),
    class = c("Fake", "TLObject")
  )
  obj_specs <- list(
    list(name = "CheckHistoryImportPeerRequest", cid = c(0x03, 0x0f, 0xc6, 0x5d), arg = "peer"),
    list(name = "GetAdminsWithInvitesRequest",   cid = c(0xef, 0xe6, 0x20, 0x39), arg = "peer"),
    list(name = "GetAttachMenuBotRequest",       cid = c(0x92, 0x61, 0x21, 0x77), arg = "bot"),
    list(name = "GetAttachedStickersRequest",    cid = c(0xcc, 0x67, 0x5b, 0xcc), arg = "media"),
    list(name = "GetOnlinesRequest",             cid = c(0x50, 0xe0, 0x2b, 0x6e), arg = "peer"),
    list(name = "GetPeerSettingsRequest",        cid = c(0xa2, 0xa6, 0xd9, 0xef), arg = "peer"),
    list(name = "HidePeerSettingsBarRequest",    cid = c(0x38, 0xb1, 0xac, 0x4f), arg = "peer"),
    list(name = "ReportEncryptedSpamRequest",    cid = c(0x0f, 0x8c, 0x0c, 0x4b), arg = "peer"),
    list(name = "ReportSpamRequest",             cid = c(0xdb, 0x92, 0x15, 0xcf), arg = "peer"),
    list(name = "SetDefaultReactionRequest",     cid = c(0x16, 0xa0, 0x47, 0x4f), arg = "reaction"),
    list(name = "UninstallStickerSetRequest",    cid = c(0xde, 0x55, 0x6e, 0xf9), arg = "stickerset")
  )
  # Some generated classes use camelCase toDict, others use snake_case to_dict.
  pick_dict <- function(pm) if (is.function(pm$toDict)) pm$toDict else pm$to_dict
  for (spec in obj_specs) {
    cls <- get(spec$name)
    self_obj <- setNames(list(fake_obj), spec$arg)
    expect_equal(
      call_with_self(cls$public_methods$bytes, self_obj),
      c(as.raw(spec$cid), fake_obj$bytes()),
      info = paste("bytes mismatch for", spec$name)
    )
    d <- call_with_self(pick_dict(cls$public_methods), self_obj)
    expect_equal(d[["_"]], spec$name)
    expect_equal(d[[spec$arg]], fake_obj$toDict())
  }
})

test_that("vector-of-long request classes serialize the inner vector marker", {
  skip_on_cran()
  # GetCustomEmojiDocumentsRequest emits Vector<long>: 1cb5c415 + count + items
  cls <- GetCustomEmojiDocumentsRequest
  self_obj <- list(documentId = list(11, 22, 33))
  expected <- c(
    as.raw(c(0xd9, 0xab, 0x0f, 0x54)),
    as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
    pack("<i", 3L),
    pack("<q", 11), pack("<q", 22), pack("<q", 33)
  )
  expect_equal(call_with_self(cls$public_methods$bytes, self_obj), expected)
  d <- call_with_self(cls$public_methods$toDict, list(documentId = NULL))
  expect_equal(d[["document_id"]], list())
  d2 <- call_with_self(cls$public_methods$toDict, self_obj)
  expect_equal(d2[["document_id"]], self_obj$documentId)
})
