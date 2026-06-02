BotsExtraTLObject <- R6::R6Class(
  "BotsExtraTLObject",
  public = list(
    to_list = function() list("_" = "BotsExtraTLObject"),
    to_bytes = function() as.raw(c(0x0a, 0x0b, 0x0c))
  )
)

bots_string_bytes <- function(x) {
  raw_x <- charToRaw(enc2utf8(as.character(x)))
  c(writeBin(as.integer(length(raw_x)), raw(), size = 4, endian = "little"), raw_x)
}

test_that("AnswerWebhookJSONQueryRequest handles object and reader payloads", {
  skip_on_cran()
  data <- BotsExtraTLObject$new()
  req <- AnswerWebhookJSONQueryRequest$new(query_id = 258, data = data)

  expect_equal(
    req$to_list(),
    list("_" = "AnswerWebhookJSONQueryRequest", query_id = 258, data = data$to_list())
  )
  expect_equal(
    req$to_bytes(),
    c(
      as.raw(c(0x4d, 0x3f, 0x21, 0xe6)),
      as.raw(c(0x02, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00)),
      data$to_bytes()
    )
  )

  reader <- new.env(parent = emptyenv())
  reader$read_long <- function() 99
  reader$tgread_object <- function() data

  from_reader <- AnswerWebhookJSONQueryRequest$from_reader(reader)
  expect_equal(from_reader$query_id, 99)
  expect_identical(from_reader$data, data)
})

test_that("bot user request serializers cover string and resolved objects", {
  skip_on_cran()
  can_send <- CanSendMessageRequest$new("botname")
  expect_equal(can_send$to_list(), list("_" = "CanSendMessageRequest", bot = "botname"))
  expect_equal(
    can_send$to_bytes(),
    c(as.raw(c(0xe6, 0xf4, 0x59, 0x13)), bots_string_bytes("botname"))
  )

  client <- list(get_input_entity = function(x) paste0("entity:", x))
  utils <- list(get_input_user = function(x) BotsExtraTLObject$new())
  can_send$resolve(client, utils)
  expect_equal(can_send$to_list()$bot, BotsExtraTLObject$new()$to_list())
  expect_equal(
    can_send$to_bytes(),
    c(as.raw(c(0xe6, 0xf4, 0x59, 0x13)), BotsExtraTLObject$new()$to_bytes())
  )

  download <- CheckDownloadFileParamsRequest$new("bot", "file.txt", "https://example.test/file")
  expect_equal(download$to_list()$file_name, "file.txt")
  expect_equal(download$to_list()$url, "https://example.test/file")
  expect_equal(
    download$to_bytes(),
    c(
      as.raw(c(0x89, 0x75, 0x07, 0x50)),
      bots_string_bytes("bot"),
      bots_string_bytes("file.txt"),
      bots_string_bytes("https://example.test/file")
    )
  )
})

test_that("simple bot request serializers and readers are covered", {
  skip_on_cran()
  admined <- GetAdminedBotsRequest$new()
  expect_equal(admined$to_list(), list("_" = "GetAdminedBotsRequest"))
  expect_equal(admined$to_bytes(), as.raw(c(0x83, 0x1d, 0x71, 0xb0)))
  expect_s3_class(GetAdminedBotsRequest$from_reader(NULL), "GetAdminedBotsRequest")

  scope <- BotsExtraTLObject$new()
  commands <- GetBotCommandsRequest$new(scope = scope, lang_code = "en")
  expect_equal(
    commands$to_list(),
    list("_" = "GetBotCommandsRequest", scope = scope$to_list(), lang_code = "en")
  )
  expect_equal(
    commands$to_bytes(),
    c(as.raw(c(0xd6, 0x0d, 0x4c, 0xe3)), scope$to_bytes(), bots_string_bytes("en"))
  )

  reader <- new.env(parent = emptyenv())
  reader$tgread_object <- function() scope
  reader$tgread_string <- function() "uk"
  from_reader <- GetBotCommandsRequest$from_reader(reader)
  expect_equal(from_reader$to_list(), list("_" = "GetBotCommandsRequest", scope = scope$to_list(), lang_code = "uk"))
})

test_that("GetBotInfoRequest covers optional bot flags", {
  skip_on_cran()
  no_bot <- GetBotInfoRequest$new(lang_code = "en")
  expect_equal(no_bot$to_list(), list("_" = "GetBotInfoRequest", lang_code = "en", bot = NULL))
  expect_equal(
    no_bot$to_bytes(),
    c(
      as.raw(c(0xfd, 0x14, 0xd9, 0xdc)),
      writeBin(0L, raw(), size = 4, endian = "little"),
      bots_string_bytes("en")
    )
  )

  with_bot <- GetBotInfoRequest$new(lang_code = "en", bot = BotsExtraTLObject$new())
  expect_equal(
    with_bot$to_bytes(),
    c(
      as.raw(c(0xfd, 0x14, 0xd9, 0xdc)),
      writeBin(1L, raw(), size = 4, endian = "little"),
      BotsExtraTLObject$new()$to_bytes(),
      bots_string_bytes("en")
    )
  )

  client <- list(get_input_entity = function(x) paste0("entity:", x))
  utils <- list(get_input_user = function(x) BotsExtraTLObject$new())
  resolvable <- GetBotInfoRequest$new(lang_code = "fr", bot = "bot")
  resolvable$resolve(client, utils)
  expect_equal(resolvable$to_list()$bot, BotsExtraTLObject$new()$to_list())
})

test_that("preview bot requests serialize and rebuild from readers", {
  skip_on_cran()
  preview <- GetPreviewInfoRequest$new(bot = "bot", lang_code = "en")
  expect_equal(
    preview$to_bytes(),
    c(as.raw(c(0xad, 0xb3, 0x3a, 0x42)), bots_string_bytes("bot"), bots_string_bytes("en"))
  )

  medias <- GetPreviewMediasRequest$new(bot = BotsExtraTLObject$new())
  expect_equal(
    medias$to_bytes(),
    c(as.raw(c(0x4d, 0x59, 0xa5, 0xa2)), BotsExtraTLObject$new()$to_bytes())
  )

  reader <- new.env(parent = emptyenv())
  reader$tgread_object <- function() BotsExtraTLObject$new()
  reader$tgread_string <- function() "de"

  preview_from_reader <- GetPreviewInfoRequest$from_reader(reader)
  expect_equal(preview_from_reader$lang_code, "de")
  expect_equal(preview_from_reader$to_list()$bot, BotsExtraTLObject$new()$to_list())

  medias_from_reader <- GetPreviewMediasRequest$from_reader(reader)
  expect_equal(medias_from_reader$to_list()$bot, BotsExtraTLObject$new()$to_list())
})
