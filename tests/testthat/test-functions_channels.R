test_that("CheckUsernameRequest to_dict and bytes and resolve", {
  skip_on_cran()
  # Dummy channel that provides bytes()
  channel <- list(bytes = function() as.raw(c(0x01)))
  req <- CheckUsernameRequest$new(channel = channel, username = "abc")
  d <- req$to_dict()
  expect_equal(d$`_`, "CheckUsernameRequest")
  expect_equal(d$username, "abc")

  b <- req$bytes()
  # header
  expect_equal(b[1:4], as.raw(c(0x2c, 0xbd, 0xe6, 0x10)))
  # channel bytes inserted next
  expect_equal(b[5], as.raw(0x01))
  # next is serialized username: length 3 then 'a','b','c'
  expect_equal(b[6], as.raw(3))
  expect_equal(rawToChar(b[7:9]), "abc")

  # resolve should call client$get_input_entity and utils$get_input_channel
  fake_client <- list(get_input_entity = function(x) paste0("ent:", x))
  fake_utils <- list(get_input_channel = function(x) paste0("input:", x))
  req2 <- CheckUsernameRequest$new(channel = "chan", username = "u")
  req2$resolve(fake_client, fake_utils)
  expect_equal(req2$channel, "input:ent:chan")
})


test_that("ConvertToGigagroupRequest bytes and CreateChannelRequest to_dict", {
  skip_on_cran()
  ch <- list(bytes = function() as.raw(c(0x02)))
  conv <- ConvertToGigagroupRequest$new(channel = ch)
  cb <- conv$bytes()
  expect_equal(cb[1:4], as.raw(c(0x69, 0x0c, 0x29, 0x0b)))
  expect_equal(cb[5], as.raw(0x02))

  creq <- CreateChannelRequest$new("MyTitle", "About", broadcast = TRUE, megagroup = FALSE, forum = TRUE, address = "addr")
  d <- creq$to_dict()
  expect_equal(d$`_`, "CreateChannelRequest")
  expect_equal(d$title, "MyTitle")
  expect_equal(d$about, "About")
  expect_true(d$broadcast)
  expect_false(d$megagroup)
  expect_true(d$forum)
  expect_equal(d$address, "addr")
})


test_that("GetInactiveChannelsRequest bytes and GetChannelsRequest to_dict", {
  skip_on_cran()
  gin <- GetInactiveChannelsRequest$new()
  b <- gin$bytes()
  expect_equal(b, as.raw(c(0xee, 0x31, 0xe8, 0x11)))

  # GetChannelsRequest with simple id list
  gch <- GetChannelsRequest$new(id = list(1L, 2L))
  d <- gch$to_dict()
  expect_equal(d$`_`, "GetChannelsRequest")
  expect_equal(d$id, list(1L, 2L))
})
