test_that("help request serializers cover string and empty requests", {
  skip_on_cran()
  countries <- GetCountriesListRequest$new(langCode = "en", hash = 7L)
  expect_equal(
    countries$to_list(),
    list("_" = "GetCountriesListRequest", lang_code = "en", hash = 7L)
  )
  expect_equal(
    countries$to_bytes(),
    c(
      packInt32(0x735787a8),
      serialize_bytes("en"),
      writeBin(7L, raw(), size = 4, endian = "little")
    )
  )

  deep_link <- GetDeepLinkInfoRequest$new("hello")
  expect_equal(
    deep_link$to_list(),
    list("_" = "GetDeepLinkInfoRequest", path = "hello")
  )
  expect_equal(
    deep_link$to_bytes(),
    c(packInt32(0x3fedc75f), serialize_bytes("hello"))
  )

  invite <- GetInviteTextRequest$new()
  expect_equal(invite$to_list(), list(type = "GetInviteTextRequest"))
  expect_equal(invite$to_bytes(), packInt32(0x4d392343))

  nearest_dc <- GetNearestDcRequest$new()
  expect_equal(nearest_dc$to_list(), list(type = "GetNearestDcRequest"))
  expect_equal(nearest_dc$to_bytes(), packInt32(0x1fb33026))
})

test_that("help request from_reader methods rebuild instances", {
  skip_on_cran()
  reader <- new.env(parent = emptyenv())
  string_values <- c("fr", "/start")
  int_values <- c(11L)
  s_idx <- 0L
  i_idx <- 0L
  reader$tgread_string <- function() {
    s_idx <<- s_idx + 1L
    string_values[[s_idx]]
  }
  reader$read_int <- function() {
    i_idx <<- i_idx + 1L
    int_values[[i_idx]]
  }

  countries <- GetCountriesListRequest$from_reader(reader)
  expect_equal(countries$to_list(), list("_" = "GetCountriesListRequest", lang_code = "fr", hash = 11L))

  deep_link <- GetDeepLinkInfoRequest$from_reader(reader)
  expect_equal(deep_link$to_list(), list("_" = "GetDeepLinkInfoRequest", path = "/start"))
})
