# Additional coverage tests for R/chats.R

test_that(".MAX_PARTICIPANTS_CHUNK_SIZE and other constants are correct", {
  skip_on_cran()
  expect_equal(.MAX_PARTICIPANTS_CHUNK_SIZE, 200)
  expect_equal(.MAX_ADMIN_LOG_CHUNK_SIZE, 100)
  expect_equal(.MAX_PROFILE_PHOTO_CHUNK_SIZE, 100)
})

test_that("_ChatAction initializes all fields correctly via R6", {
  skip_on_cran()
  fake_client <- list()
  chat <- list(id = 42L)
  act <- telegramR:::.ChatAction$new(
    client = fake_client,
    chat = chat,
    action = "typing",
    delay = 8,
    auto_cancel = FALSE
  )
  expect_equal(act$chat, chat)
  expect_equal(act$delay, 8)
  expect_false(act$auto_cancel)
  expect_false(act$running)
  expect_null(act$request)
})

test_that("_ChatAction progress updates action$progress field", {
  skip_on_cran()
  fake_client <- list()
  act <- telegramR:::.ChatAction$new(
    client = fake_client,
    chat = list(id = 1L),
    action = list(progress = 0)
  )
  act$progress(100, 100)
  expect_equal(act$action$progress, 100)

  act$progress(0, 100)
  expect_equal(act$action$progress, 0)
})

test_that("_ChatAction progress does nothing when action has no progress field", {
  skip_on_cran()
  fake_client <- list()
  act <- telegramR:::.ChatAction$new(
    client = fake_client,
    chat = list(id = 1L),
    action = list()
  )
  # Should not error even though no progress field
  expect_no_error(act$progress(10, 100))
})

test_that("_ChatAction clone produces independent copy", {
  skip_on_cran()
  fake_client <- list()
  act1 <- telegramR:::.ChatAction$new(
    client = fake_client,
    chat = list(id = 1L),
    action = "typing"
  )
  act2 <- act1$clone()
  act2$running <- TRUE
  expect_false(act1$running)
  expect_true(act2$running)
})
