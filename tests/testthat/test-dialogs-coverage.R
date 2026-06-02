# Additional coverage tests for R/dialogs.R

test_that("dialog_message_key works with PeerChat peer (no channel_id)", {
  skip_on_cran()
  peer_chat <- structure(list(chat_id = 99L), class = "PeerChat")
  res <- dialog_message_key(peer_chat, 100L)
  expect_null(res$channel_id)
  expect_equal(res$message_id, 100L)
})

test_that("dialog_message_key zero message_id is preserved", {
  skip_on_cran()
  peer <- structure(list(id = 1L), class = "PeerUser")
  res <- dialog_message_key(peer, 0L)
  expect_null(res$channel_id)
  expect_equal(res$message_id, 0L)
})

test_that("dialog_message_key PeerChannel extracts channel_id", {
  skip_on_cran()
  peer_channel <- structure(list(channel_id = 555L), class = "PeerChannel")
  res <- dialog_message_key(peer_channel, 10L)
  expect_equal(res$channel_id, 555L)
  expect_equal(res$message_id, 10L)
})

test_that(".MAX_CHUNK_SIZE is 100", {
  skip_on_cran()
  expect_equal(.MAX_CHUNK_SIZE, 100)
})
