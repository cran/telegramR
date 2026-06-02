test_that(".MAX_CHUNK_SIZE is defined and correct", {
  skip_on_cran()
  expect_true(exists(".MAX_CHUNK_SIZE", envir = .GlobalEnv) || exists(".MAX_CHUNK_SIZE"))
  expect_equal(.MAX_CHUNK_SIZE, 100)
})

test_that("dialog_message_key returns channel_id for PeerChannel and message_id", {
  skip_on_cran()
  peer_channel <- structure(list(channel_id = 12345), class = "PeerChannel")
  res <- dialog_message_key(peer_channel, 7)
  expect_equal(res$channel_id, 12345)
  expect_equal(res$message_id, 7)
})

test_that("dialog_message_key returns NULL channel_id for non-channel peers", {
  skip_on_cran()
  peer_user <- structure(list(id = 1), class = "PeerUser")
  res2 <- dialog_message_key(peer_user, 42)
  expect_null(res2$channel_id)
  expect_equal(res2$message_id, 42)
})
