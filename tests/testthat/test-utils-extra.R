test_that("utils parse_phone handles numeric and formatted strings", {
  expect_equal(parse_phone(1234567890L), "1234567890")
  expect_equal(parse_phone("+1 (234) 567-890"), "1234567890")
  expect_null(parse_phone("invalid"))
})

test_that("utils parse_username handles usernames and joinchat links", {
  out <- parse_username("@UserName")
  expect_equal(out$username, "username")
  expect_false(out$is_join_chat)

  out2 <- parse_username("https://t.me/joinchat/abc123")
  expect_equal(out2$username, "abc123")
  expect_true(out2$is_join_chat)

  out3 <- parse_username("plainuser")
  expect_equal(out3$username, "plainuser")
  expect_false(out3$is_join_chat)
})

test_that("utils resolve_id and get_peer_id behave", {
  res <- resolve_id(-1000000000001)
  expect_equal(res[[1]], 1)
  expect_true(identical(res[[2]], PeerChannel))

  peer <- InputPeerChat$new(chat_id = 55)
  expect_equal(get_peer_id(peer, add_mark = FALSE), 55)
})

test_that("utils sanitize_parse_mode handles strings and functions", {
  md <- sanitize_parse_mode("markdown")
  expect_true(is.list(md) && is.function(md$parse))

  html <- sanitize_parse_mode("html")
  expect_true(is.list(html) && is.function(html$parse))

  fn <- function(x) x
  cm <- sanitize_parse_mode(fn)
  expect_true(inherits(cm, "CustomMode"))
  expect_error(cm$unparse("x", list()), "NotImplementedError")
})

test_that("utils file extension helpers work", {
  expect_equal(get_file_extension("a/b/c.txt"), "txt")
  doc <- structure(list(mime_type = "image/gif"), class = "Document")
  expect_true(is_gif(doc))
  doc2 <- structure(list(mime_type = "image/png"), class = "Document")
  expect_false(is_gif(doc2))
})

test_that("dialog_message_key includes channel id for PeerChannel", {
  peer <- PeerChannel$new(channel_id = 123)
  key <- dialog_message_key(peer, 10)
  expect_equal(key$channel_id, 123)
  expect_equal(key$message_id, 10)

  peer2 <- PeerUser$new(user_id = 1)
  key2 <- dialog_message_key(peer2, 7)
  expect_null(key2$channel_id)
})

# --- pack / unpack ---

test_that("pack/unpack round-trip for 'i' (signed 32-bit int)", {
  b <- pack("i", 42L)
  expect_equal(class(b), c("raw_bytes", "raw"))
  expect_equal(length(b), 4L)
  expect_equal(unpack("i", b)[[1]], 42L)
})

test_that("pack/unpack round-trip for 'I' (unsigned 32-bit small value)", {
  b <- pack("I", 1000L)
  expect_equal(length(b), 4L)
  val <- unpack("I", b)[[1]]
  expect_equal(val, 1000)
})

test_that("pack 'q' with bigz produces 8 bytes in little-endian order", {
  # 9999999999 = 0x00000002_540BE3FF little-endian: FF E3 0B 54 02 00 00 00
  big <- gmp::as.bigz("9999999999")
  b   <- pack("q", big)
  expect_equal(length(b), 8L)
  expect_equal(as.integer(b[1]), 0xFF)
  expect_equal(as.integer(b[5]), 0x02)
})

test_that("pack 'Q' with bigz produces 8 bytes", {
  big <- gmp::as.bigz("12345678901234")
  b   <- pack("Q", big)
  expect_equal(length(b), 8L)
  expect_equal(class(b), c("raw_bytes", "raw"))
})

test_that("pack/unpack round-trip for 'f' (float)", {
  b <- pack("f", 3.14)
  expect_equal(length(b), 4L)
  val <- unpack("f", b)[[1]]
  expect_true(abs(val - 3.14) < 0.001)
})

test_that("pack/unpack round-trip for 'd' (double)", {
  b <- pack("d", 2.718281828)
  expect_equal(length(b), 8L)
  val <- unpack("d", b)[[1]]
  expect_true(abs(val - 2.718281828) < 1e-9)
})

test_that("pack/unpack round-trip for 'B' (unsigned byte)", {
  b <- pack("B", 255L)
  expect_equal(length(b), 1L)
  val <- unpack("B", b)[[1]]
  expect_equal(val, 255L)
})

test_that("pack strips leading endianness prefix", {
  b1 <- pack("<i", 7L)
  b2 <- pack("i", 7L)
  expect_equal(b1, b2)
})

test_that("pack handles multiple values with single format char", {
  b <- pack("i", 1L, 2L, 3L)
  expect_equal(length(b), 12L)
  vals <- unpack("iii", b)
  expect_equal(vals[[1]], 1L)
  expect_equal(vals[[2]], 2L)
  expect_equal(vals[[3]], 3L)
})

# --- +.raw_bytes ---

test_that("+.raw_bytes concatenates two raw_bytes objects", {
  a <- pack("i", 1L)
  b <- pack("i", 2L)
  ab <- a + b
  expect_equal(class(ab), c("raw_bytes", "raw"))
  expect_equal(length(ab), 8L)
  vals <- unpack("ii", ab)
  expect_equal(vals[[1]], 1L)
  expect_equal(vals[[2]], 2L)
})

# --- entity_type ---

test_that("entity_type returns USER for User-like objects", {
  for (cls_name in c("User", "UserEmpty", "InputUser", "InputPeerUser", "PeerUser")) {
    entity <- structure(list(), class = cls_name)
    expect_equal(entity_type(entity), EntityType$USER,
      label = sprintf("entity_type(%s)", cls_name))
  }
})

test_that("entity_type returns CHAT for Chat-like objects", {
  for (cls_name in c("Chat", "ChatForbidden", "ChatEmpty", "InputPeerChat", "PeerChat")) {
    entity <- structure(list(), class = cls_name)
    expect_equal(entity_type(entity), EntityType$CHAT,
      label = sprintf("entity_type(%s)", cls_name))
  }
})

test_that("entity_type returns CHANNEL for Channel-like objects", {
  for (cls_name in c("Channel", "ChannelForbidden", "ChannelEmpty",
                     "InputPeerChannel", "PeerChannel", "InputChannel")) {
    entity <- structure(list(), class = cls_name)
    expect_equal(entity_type(entity), EntityType$CHANNEL,
      label = sprintf("entity_type(%s)", cls_name))
  }
})

test_that("entity_type throws for unknown entity", {
  entity <- structure(list(), class = "UnknownFoo")
  expect_error(entity_type(entity), "Unknown entity type")
})

# --- get_extension ---

test_that("get_extension returns .jpg for Photo", {
  photo <- structure(list(), class = "Photo")
  expect_equal(get_extension(photo), ".jpg")
})

test_that("get_extension returns .jpg for MessageMediaPhoto", {
  mm <- structure(list(), class = "MessageMediaPhoto")
  expect_equal(get_extension(mm), ".jpg")
})

test_that("get_extension returns .jpg for UserProfilePhoto", {
  p <- structure(list(), class = "UserProfilePhoto")
  expect_equal(get_extension(p), ".jpg")
})

test_that("get_extension returns empty string for octet-stream Document", {
  doc <- structure(list(mime_type = "application/octet-stream"), class = "Document")
  expect_equal(get_extension(doc), "")
})

test_that("get_extension returns extension for known MIME Document", {
  doc <- structure(list(mime_type = "video/mp4"), class = "Document")
  ext <- get_extension(doc)
  expect_equal(ext, ".mp4")
})

test_that("get_extension returns empty string for unknown type", {
  other <- structure(list(), class = "SomethingElse")
  expect_equal(get_extension(other), "")
})

# --- guess_extension ---

test_that("guess_extension finds extension for image/png", {
  expect_equal(guess_extension("image/png"), ".png")
})

test_that("guess_extension returns NULL for unknown MIME", {
  expect_null(guess_extension("application/x-completely-made-up"))
})

# --- get_input_photo ---

test_that("get_input_photo returns InputPhoto unchanged", {
  # Use structure() because InputPhoto$new() requires declared public fields
  ip <- structure(list(id = 1L, access_hash = 2L), class = "InputPhoto")
  expect_identical(get_input_photo(ip), ip)
})

test_that("get_input_photo converts PhotoEmpty to InputPhotoEmpty", {
  pe <- structure(list(), class = "PhotoEmpty")
  result <- get_input_photo(pe)
  expect_true(inherits(result, "InputPhotoEmpty"))
})

test_that("get_input_photo errors for unsupported type", {
  x <- structure(list(), class = "RandomThing")
  expect_error(get_input_photo(x), "Cannot convert")
})

# --- get_input_geo ---

test_that("get_input_geo returns InputGeoPoint unchanged", {
  igp <- InputGeoPoint$new(60.0, 24.0)
  expect_identical(get_input_geo(igp), igp)
})

test_that("get_input_geo converts GeoPoint to InputGeoPoint", {
  gp <- structure(list(lat = 60.0, long = 24.0), class = "GeoPoint")
  result <- get_input_geo(gp)
  expect_true(inherits(result, "InputGeoPoint"))
  expect_equal(result$lat, 60.0)
})

test_that("get_input_geo converts GeoPointEmpty to InputGeoPointEmpty", {
  ge <- structure(list(), class = "GeoPointEmpty")
  result <- get_input_geo(ge)
  expect_true(inherits(result, "InputGeoPointEmpty"))
})

test_that("get_input_geo errors for unsupported type", {
  x <- structure(list(), class = "Xyz")
  expect_error(get_input_geo(x), "Cannot convert")
})

# --- get_display_name ---

test_that("get_display_name returns first + last for User", {
  u <- structure(list(first_name = "Ada", last_name = "Lovelace"), class = "User")
  expect_equal(get_display_name(u), "Ada Lovelace")
})

test_that("get_display_name returns first name only when no last_name", {
  u <- structure(list(first_name = "Ada", last_name = NULL), class = "User")
  expect_equal(get_display_name(u), "Ada")
})

test_that("get_display_name returns last name only when no first_name", {
  u <- structure(list(first_name = NULL, last_name = "Lovelace"), class = "User")
  expect_equal(get_display_name(u), "Lovelace")
})

test_that("get_display_name returns empty string for User with no name", {
  u <- structure(list(first_name = NULL, last_name = NULL), class = "User")
  expect_equal(get_display_name(u), "")
})

test_that("get_display_name returns title for Chat", {
  c <- structure(list(title = "My Group"), class = "Chat")
  expect_equal(get_display_name(c), "My Group")
})

test_that("get_display_name returns title for Channel", {
  ch <- structure(list(title = "News Channel"), class = "Channel")
  expect_equal(get_display_name(ch), "News Channel")
})

test_that("get_display_name returns empty string for unknown type", {
  expect_equal(get_display_name(list()), "")
})

# --- FileInfo class ---

test_that("FileInfo stores fields correctly", {
  fi <- FileInfo$new(dc_id = 2L, location = "somewhere", size = 1024L)
  expect_equal(fi$dc_id, 2L)
  expect_equal(fi$location, "somewhere")
  expect_equal(fi$size, 1024L)
})

# --- chunks edge cases ---

test_that("chunks returns single chunk when size >= length", {
  expect_equal(chunks(1:3, 10), list(c(1L, 2L, 3L)))
})

test_that("chunks handles length-1 input", {
  expect_equal(chunks(42L, 5), list(42L))
})

test_that("chunks exact multiple produces no partial chunk", {
  result <- chunks(1:6, 3)
  expect_equal(length(result), 2L)
  expect_equal(result[[2]], c(4L, 5L, 6L))
})
