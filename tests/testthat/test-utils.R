# Test for chunks function
test_that("chunks splits iterable into chunks of specified size", {
  expect_equal(chunks(1:10, 3), list(c(1, 2, 3), c(4, 5, 6), c(7, 8, 9), c(10)))
  expect_equal(chunks(1:5, 2), list(c(1, 2), c(3, 4), c(5)))
  expect_equal(chunks(c(), 3), list())
})

# Test for get_display_name function
test_that("get_display_name returns correct display name", {
  user <- list(first_name = "John", last_name = "Doe")
  class(user) <- "User"
  expect_equal(get_display_name(user), "John Doe")

  user <- list(first_name = "Jane")
  class(user) <- "User"
  expect_equal(get_display_name(user), "Jane")

  chat <- list(title = "Test Chat")
  class(chat) <- "Chat"
  expect_equal(get_display_name(chat), "Test Chat")

  expect_equal(get_display_name(list()), "")
})

# Test for parse_phone function
test_that("parse_phone parses phone numbers correctly", {
  expect_equal(parse_phone(1234567890), "1234567890")
  expect_equal(parse_phone("+1 (234) 567-890"), "1234567890")
  expect_null(parse_phone("invalid"))
  expect_null(parse_phone("abc"))
})

# Test for parse_username function
test_that("parse_username parses usernames and links", {
  expect_equal(parse_username("@username"), list(username = "username", is_join_chat = FALSE))
  expect_equal(parse_username("https://t.me/joinchat/abc123"), list(username = "abc123", is_join_chat = TRUE))
})

# Test for is_list_like function
test_that("is_list_like identifies list-like objects", {
  expect_true(is_list_like(list(1, 2, 3)))
  expect_true(is_list_like(1:10))
  expect_false(is_list_like("string"))
  expect_true(is_list_like(as.raw(c(1, 2))))
  expect_false(is_list_like(data.frame(a = 1:3)))
  expect_true(is_list_like(data.frame(a = 1:3), allow_data_frames = TRUE))
})

# Test for resolve_id function
test_that("resolve_id resolves marked IDs", {
  # Assuming types$PeerUser and types$PeerChat are defined
  # For simplicity, mock or assume
  result_pos <- resolve_id(123)
  expect_equal(result_pos[[1]], 123)
  expect_true(identical(result_pos[[2]], PeerUser))
  result_neg <- resolve_id(-456)
  expect_equal(result_neg[[1]], 456)
  expect_true(identical(result_neg[[2]], PeerChat))
})

# Test for rle_decode and rle_encode
test_that("rle_decode and rle_encode are inverses", {
  data <- as.raw(c(0x01, 0x00, 0x03, 0x02))
  encoded <- rle_encode(data)
  decoded <- rle_decode(encoded)
  expect_equal(decoded, data)
})

# Test for decode_telegram_base64 and encode_telegram_base64
test_that("decode_telegram_base64 and encode_telegram_base64 are inverses", {
  original <- as.raw(c(0x01, 0x02, 0x03))
  encoded <- encode_telegram_base64(original)
  decoded <- decode_telegram_base64(encoded)
  expect_equal(decoded, original)
})

# Test for get_appropriated_part_size
test_that("get_appropriated_part_size returns correct sizes", {
  expect_equal(get_appropriated_part_size(50000000), 128) # < 100MB
  expect_equal(get_appropriated_part_size(200000000), 256) # 100MB to 750MB
  expect_equal(get_appropriated_part_size(1000000000), 512) # > 750MB
})

# Test for photo_size_byte_count
test_that("photo_size_byte_count calculates byte counts", {
  size <- list(size = 1024)
  class(size) <- "PhotoSize"
  expect_equal(photo_size_byte_count(size), 1024)

  size <- list(bytes = as.raw(c(0x01, 0x02, 0x03)))
  class(size) <- "PhotoStrippedSize"
  expect_equal(photo_size_byte_count(size), 625) # 3 bytes + 622 JPEG overhead when first byte is 0x01

  size <- list()
  class(size) <- "PhotoSizeEmpty"
  expect_equal(photo_size_byte_count(size), 0)
})

# Add more tests as needed for other functions, but keep concise
