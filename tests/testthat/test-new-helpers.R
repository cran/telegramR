library(testthat)

make_capture_client <- function() {
  state <- new.env(parent = emptyenv())
  state$last_call <- NULL
  state$last_invoke <- NULL
  state$last_send <- NULL
  state$upload_result <- list(type = "InputFile", id = "1", parts = 1, name = "x")

  client <- list(
    get_entity = function(x) x,
    get_input_entity = function(x) x,
    call = function(req) {
      state$last_call <- req
      list(ok = TRUE, req = req)
    },
    invoke = function(req) {
      state$last_invoke <- req
      list(ok = TRUE, req = req)
    },
    upload_file = function(file, progress_callback = NULL) {
      state$last_upload <- file
      state$upload_result
    },
    send_message = function(...) {
      state$last_send <- list(...)
      "ok"
    },
    .state = state
  )
  class(client) <- "FakeClient"
  client
}

test_that("join_public_channel invokes JoinChannelRequest", {
  skip_on_cran()
  client <- make_capture_client()
  input <- InputChannel$new(channel_id = 1, access_hash = 2)

  join_public_channel(client, input)
  expect_true(inherits(client$.state$last_invoke, "JoinChannelRequest"))
  expect_true(inherits(client$.state$last_invoke$channel, "InputChannel"))
})

test_that("join_private_chat invokes ImportChatInviteRequest", {
  skip_on_cran()
  client <- make_capture_client()
  join_private_chat(client, "https://t.me/+abc123")
  expect_true(inherits(client$.state$last_invoke, "ImportChatInviteRequest"))
})

test_that("join_channel routes by invite vs username", {
  skip_on_cran()
  client <- make_capture_client()
  join_channel(client, "https://t.me/+abc123")
  expect_true(inherits(client$.state$last_invoke, "ImportChatInviteRequest"))

  client <- make_capture_client()
  client$get_entity <- function(x) {
    structure(list(id = 1, access_hash = 2, min = FALSE), class = "Channel")
  }
  join_channel(client, "publicchannel")
  expect_true(inherits(client$.state$last_invoke, "JoinChannelRequest"))
})

test_that("add_user_to_chat uses correct request type", {
  skip_on_cran()
  client <- make_capture_client()
  chat <- structure(list(id = 10, access_hash = 2), class = "Channel")
  user <- InputUser$new(user_id = 5, access_hash = 7)

  add_user_to_chat(client, chat, user)
  expect_true(inherits(client$.state$last_invoke, "InviteToChannelRequest"))

  client <- make_capture_client()
  chat2 <- structure(list(id = 20), class = "Chat")
  add_user_to_chat(client, chat2, user)
  expect_true(inherits(client$.state$last_invoke, "AddChatUserRequest"))
})

test_that("check_invite_link calls CheckChatInviteRequest", {
  skip_on_cran()
  client <- make_capture_client()
  check_invite_link(client, "https://t.me/+abc123")
  expect_true(inherits(client$.state$last_call, "CheckChatInviteRequest"))
})

test_that("increase_view_count calls GetMessagesViewsRequest", {
  skip_on_cran()
  client <- make_capture_client()
  ch <- InputChannel$new(channel_id = 1, access_hash = 2)
  client$get_entity <- function(x) ch
  increase_view_count(client, ch, c(1, 2))
  expect_true(inherits(client$.state$last_call, "GetMessagesViewsRequest"))
})

test_that("get_full_user calls GetFullUserRequest", {
  skip_on_cran()
  client <- make_capture_client()
  user <- InputUser$new(user_id = 1, access_hash = 2)
  get_full_user(client, user)
  expect_true(inherits(client$.state$last_call, "GetFullUserRequest"))
})

test_that("update_profile and update_username call account requests", {
  skip_on_cran()
  client <- make_capture_client()
  update_profile(client, first_name = "A", last_name = "B", bio = "C")
  expect_true(inherits(client$.state$last_call, "UpdateProfileRequest"))

  client <- make_capture_client()
  update_username(client, "newname")
  expect_true(inherits(client$.state$last_call, "UpdateUsernameRequest"))
  expect_equal(client$.state$last_call$username, "newname")
})

test_that("update_profile_photo uploads and calls UploadProfilePhotoRequest", {
  skip_on_cran()
  client <- make_capture_client()
  update_profile_photo(client, "file.jpg")
  expect_equal(client$.state$last_upload, "file.jpg")
  expect_true(inherits(client$.state$last_call, "UploadProfilePhotoRequest"))
})

test_that("send_* wrappers pass through to send_message", {
  skip_on_cran()
  client <- make_capture_client()
  send_message(client, entity = "me", message = "hi")
  expect_equal(client$.state$last_send$entity, "me")

  send_file(client, entity = "me", file = "f.bin")
  expect_equal(client$.state$last_send$file, "f.bin")

  send_photo(client, entity = "me", file = "a.jpg")
  expect_equal(client$.state$last_send$file, "a.jpg")

  send_video(client, entity = "me", file = "v.mp4")
  expect_equal(client$.state$last_send$file, "v.mp4")

  send_document(client, entity = "me", file = "d.pdf")
  expect_equal(client$.state$last_send$file, "d.pdf")

  send_audio(client, entity = "me", file = "a.mp3")
  expect_equal(client$.state$last_send$file, "a.mp3")
})
