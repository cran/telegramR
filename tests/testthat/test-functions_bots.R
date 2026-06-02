test_that("AddPreviewMediaRequest to_list, to_bytes and resolve", {
  skip_on_cran()
  MockUser <- R6::R6Class("MockUser", public = list(
    to_list = function() list(`_` = "MockUser"),
    to_bytes = function() as.raw(c(0xAA))
  ))
  MockMedia <- R6::R6Class("MockMedia", public = list(
    to_list = function() list(`_` = "MockMedia"),
    to_bytes = function() as.raw(c(0xBB))
  ))

  bot <- MockUser$new()
  media <- MockMedia$new()
  req <- AddPreviewMediaRequest$new(bot = bot, lang_code = "en", media = media)

  lst <- req$to_list()
  expect_true(is.list(lst))
  expect_equal(lst$`_`, "AddPreviewMediaRequest")
  expect_equal(lst$lang_code, "en")
  expect_true(!is.null(lst$bot))
  expect_true(!is.null(lst$media))

  b <- req$to_bytes()
  expect_true(is.raw(b))
  # constructor id 0x17aeb75a -> bytes as declared in code
  expect_equal(b[1:4], as.raw(c(0x5A, 0xB7, 0xAE, 0x17)))
  # bot/media bytes included
  expect_true(any(b == as.raw(0xAA)))
  expect_true(any(b == as.raw(0xBB)))
  # lang_code 'e' and 'n' should appear somewhere in the raw bytes
  expect_true(any(as.integer(b) == as.integer(charToRaw("e"))))
  expect_true(any(as.integer(b) == as.integer(charToRaw("n"))))

  # resolve with fake client/utils when bot and media are simple identifiers
  fake_client <- list(get_input_entity = function(x) paste0("IN:", x))
  fake_utils <- list(
    get_input_user = function(x) paste0("U:", x),
    get_input_media = function(x) paste0("M:", x)
  )

  req2 <- AddPreviewMediaRequest$new(bot = "bob", lang_code = "ru", media = "filex")
  req2$resolve(fake_client, fake_utils)
  expect_equal(req2$bot, "U:IN:bob")
  expect_equal(req2$media, "M:filex")
})


test_that("AllowSendMessageRequest to_list, to_bytes and resolve", {
  skip_on_cran()
  MockUser <- R6::R6Class("MockUser2", public = list(
    to_list = function() list(`_` = "MockUser2"),
    to_bytes = function() as.raw(c(0xCC))
  ))

  bot <- MockUser$new()
  req <- AllowSendMessageRequest$new(bot = bot)

  lst <- req$to_list()
  expect_true(is.list(lst))
  expect_equal(lst$`_`, "AllowSendMessageRequest")
  expect_true(!is.null(lst$bot))

  b <- req$to_bytes()
  expect_true(is.raw(b))
  expect_equal(b[1:4], as.raw(c(0xEF, 0xE3, 0x32, 0xF1)))
  expect_true(any(b == as.raw(0xCC)))

  fake_client <- list(get_input_entity = function(x) paste0("IN:", x))
  fake_utils <- list(get_input_user = function(x) paste0("U:", x))
  req2 <- AllowSendMessageRequest$new(bot = "alice")
  req2$resolve(fake_client, fake_utils)
  expect_equal(req2$bot, "U:IN:alice")
})
