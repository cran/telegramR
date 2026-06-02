# Extended coverage tests for R/utils.R

# ── bitwLength ──────────────────────────────────────────────────────────────
test_that("bitwLength returns 1 for 0", {
  expect_equal(bitwLength(0), 1)
})

test_that("bitwLength returns correct length for powers of 2", {
  expect_equal(bitwLength(1), 1)
  expect_equal(bitwLength(2), 2)
  expect_equal(bitwLength(4), 3)
  expect_equal(bitwLength(128), 8)
})

# ── int_to_raw_le ────────────────────────────────────────────────────────────
test_that("int_to_raw_le encodes small integer correctly", {
  r <- int_to_raw_le(1L, 4L)
  expect_equal(r, as.raw(c(0x01, 0x00, 0x00, 0x00)))
})

test_that("int_to_raw_le handles zero", {
  r <- int_to_raw_le(0L, 4L)
  expect_equal(r, as.raw(c(0x00, 0x00, 0x00, 0x00)))
})

# ── serialize_int ─────────────────────────────────────────────────────────────
test_that("serialize_int produces 4-byte little-endian", {
  r <- serialize_int(256L)
  expect_equal(length(r), 4L)
  expect_equal(r[1], as.raw(0x00))
  expect_equal(r[2], as.raw(0x01))
})

# ── serialize_string ──────────────────────────────────────────────────────────
test_that("serialize_string handles empty string", {
  r <- serialize_string("")
  expect_true(is.raw(r))
})

test_that("serialize_string handles NULL", {
  r <- serialize_string(NULL)
  expect_true(is.raw(r))
})

test_that("serialize_string produces raw vector for normal string", {
  r <- serialize_string("hello")
  expect_true(is.raw(r))
  expect_gt(length(r), 0)
})

# ── int_from_bytes ────────────────────────────────────────────────────────────
test_that("int_from_bytes with empty raw returns 0", {
  result <- int_from_bytes(raw(0))
  expect_equal(as.numeric(result), 0)
})

test_that("int_from_bytes big-endian decodes correctly", {
  # 0x00 0x01 -> 1
  result <- int_from_bytes(as.raw(c(0x00, 0x01)), "big")
  expect_equal(as.numeric(result), 1)
})

test_that("int_from_bytes little-endian decodes correctly", {
  # 0x01 0x00 -> 1 (little-endian)
  result <- int_from_bytes(as.raw(c(0x01, 0x00)), "little")
  expect_equal(as.numeric(result), 1)
})

# ── int_to_bytes ──────────────────────────────────────────────────────────────
test_that("int_to_bytes produces correct big-endian bytes", {
  r <- int_to_bytes(256, 4, "big")
  expect_equal(r, as.raw(c(0x00, 0x00, 0x01, 0x00)))
})

test_that("int_to_bytes round-trips with int_from_bytes", {
  original <- 12345
  b <- int_to_bytes(original, 4, "big")
  back <- int_from_bytes(b, "big")
  expect_equal(as.numeric(back), original)
})

# ── xor_bytes ─────────────────────────────────────────────────────────────────
test_that("xor_bytes returns correct XOR", {
  a <- as.raw(c(0xFF, 0x00))
  b <- as.raw(c(0x0F, 0xF0))
  result <- xor_bytes(a, b)
  expect_equal(result, as.raw(c(0xF0, 0xF0)))
})

test_that("xor_bytes with identical inputs yields zero vector", {
  v <- as.raw(c(0xAB, 0xCD))
  result <- xor_bytes(v, v)
  expect_equal(result, as.raw(c(0x00, 0x00)))
})

# ── sha1 ──────────────────────────────────────────────────────────────────────
test_that("sha1 returns 20-byte raw vector", {
  result <- sha1(charToRaw("test"))
  expect_length(result, 20L)
  expect_true(is.raw(result))
})

test_that("sha1 of empty is deterministic", {
  r1 <- sha1(raw(0))
  r2 <- sha1(raw(0))
  expect_equal(r1, r2)
})

# ── sha256 ────────────────────────────────────────────────────────────────────
test_that("sha256 returns 32-byte raw vector", {
  result <- sha256(charToRaw("hello"))
  expect_length(result, 32L)
  expect_true(is.raw(result))
})

test_that("sha256 concatenates multiple arguments", {
  combined <- sha256(charToRaw("a"), charToRaw("b"))
  direct <- sha256(charToRaw("ab"))
  expect_equal(combined, direct)
})

# ── powmod ────────────────────────────────────────────────────────────────────
test_that("powmod computes 2^10 mod 1000 = 24", {
  result <- powmod(2, 10, 1000)
  expect_equal(as.numeric(result), 24)
})

test_that("powmod handles base=0", {
  result <- powmod(0, 5, 7)
  expect_equal(as.numeric(result), 0)
})

# ── num_bytes_for_hash / big_num_for_hash ─────────────────────────────────────
test_that("num_bytes_for_hash pads to 256 bytes", {
  r <- num_bytes_for_hash(as.raw(c(0x01, 0x02)))
  expect_length(r, 256L)
  expect_equal(r[255], as.raw(0x01))
  expect_equal(r[256], as.raw(0x02))
})

test_that("big_num_for_hash produces 256-byte vector", {
  r <- big_num_for_hash(255)
  expect_length(r, 256L)
  expect_equal(r[256], as.raw(0xFF))
})

# ── is_good_large ─────────────────────────────────────────────────────────────
test_that("is_good_large returns TRUE when number is in valid range", {
  expect_true(is_good_large(1, 100))
  expect_true(is_good_large(50, 100))
  expect_true(is_good_large(99, 100))
})

test_that("is_good_large returns FALSE for zero or negative", {
  expect_false(is_good_large(0, 100))
  expect_false(is_good_large(-1, 100))
})

test_that("is_good_large returns FALSE when number >= prime", {
  expect_false(is_good_large(100, 100))
  expect_false(is_good_large(150, 100))
})

# ── is_good_mod_exp_first ─────────────────────────────────────────────────────
test_that("is_good_mod_exp_first returns FALSE for diff = 0", {
  p <- gmp::as.bigz(2)^2048 - 1
  # modexp == prime → diff == 0, bit_count_diff = 1 < 1984
  expect_false(is_good_mod_exp_first(p, p))
})

test_that("is_good_mod_exp_first returns FALSE for modexp = 0", {
  p <- gmp::as.bigz(2)^2048 - 1
  expect_false(is_good_mod_exp_first(0, p))
})

test_that("is_good_mod_exp_first returns TRUE for a valid mid-range value", {
  p <- gmp::as.bigz(2)^2048 - 1
  modexp <- gmp::as.bigz(2)^1984 + 1
  expect_true(is_good_mod_exp_first(modexp, p))
})

# ── raise_cast_fail ───────────────────────────────────────────────────────────
test_that("raise_cast_fail throws with expected message", {
  entity <- structure(list(), class = "FakeEntity")
  expect_error(raise_cast_fail(entity, "InputPeer"), "Cannot cast FakeEntity to any kind of InputPeer")
})

# ── get_input_channel ─────────────────────────────────────────────────────────
test_that("get_input_channel converts Channel to InputChannel", {
  ch <- structure(list(id = 42L, access_hash = 99L, min = FALSE), class = "Channel")
  result <- get_input_channel(ch)
  expect_true(inherits(result, "InputChannel"))
  expect_equal(result$channel_id, 42L)
  expect_equal(result$access_hash, 99L)
})

test_that("get_input_channel converts InputPeerChannel to InputChannel", {
  ipc <- InputPeerChannel$new(channel_id = 10L, access_hash = 20L)
  result <- get_input_channel(ipc)
  expect_true(inherits(result, "InputChannel"))
  expect_equal(result$channel_id, 10L)
})

test_that("get_input_channel errors on unknown type", {
  bad <- structure(list(), class = "Unknown")
  expect_error(get_input_channel(bad), "Cannot cast")
})

# ── get_input_user ─────────────────────────────────────────────────────────────
test_that("get_input_user converts User (non-self) to InputUser", {
  u <- structure(list(id = 7L, access_hash = 55L, is_self = FALSE, min = FALSE, SUBCLASS_OF_ID = 0L), class = "User")
  result <- get_input_user(u)
  expect_true(inherits(result, "InputUser"))
  expect_equal(result$user_id, 7L)
})

test_that("get_input_user converts self User to InputUserSelf", {
  u <- structure(list(id = 1L, access_hash = 0L, is_self = TRUE, min = FALSE, SUBCLASS_OF_ID = 0L), class = "User")
  result <- get_input_user(u)
  expect_true(inherits(result, "InputUserSelf"))
})

test_that("get_input_user converts InputPeerSelf to InputUserSelf", {
  ip <- InputPeerSelf$new()
  result <- get_input_user(ip)
  expect_true(inherits(result, "InputUserSelf"))
})

test_that("get_input_user converts UserEmpty to InputUserEmpty", {
  ue <- structure(list(SUBCLASS_OF_ID = 0L), class = "UserEmpty")
  result <- get_input_user(ue)
  expect_true(inherits(result, "InputUserEmpty"))
})

test_that("get_input_user converts InputPeerUser to InputUser", {
  ipu <- InputPeerUser$new(user_id = 5L, access_hash = 10L)
  result <- get_input_user(ipu)
  expect_true(inherits(result, "InputUser"))
  expect_equal(result$user_id, 5L)
})

# ── get_input_document ────────────────────────────────────────────────────────
test_that("get_input_document converts Document to InputDocument", {
  doc <- structure(list(id = 1L, access_hash = 2L, file_reference = raw(0), SUBCLASS_OF_ID = 0L), class = "Document")
  result <- get_input_document(doc)
  expect_true(inherits(result, "InputDocument"))
})

test_that("get_input_document converts DocumentEmpty to InputDocumentEmpty", {
  de <- structure(list(SUBCLASS_OF_ID = 0L), class = "DocumentEmpty")
  result <- get_input_document(de)
  expect_true(inherits(result, "InputDocumentEmpty"))
})

test_that("get_input_document errors on unknown type", {
  bad <- structure(list(SUBCLASS_OF_ID = 0L), class = "FooBarBaz")
  expect_error(get_input_document(bad), "Cannot cast")
})

# ── get_input_peer ─────────────────────────────────────────────────────────────
test_that("get_input_peer converts Chat to InputPeerChat", {
  chat <- structure(list(id = 100L, SUBCLASS_OF_ID = 0L), class = "Chat")
  result <- get_input_peer(chat)
  expect_true(inherits(result, "InputPeerChat"))
  expect_equal(result$chat_id, 100L)
})

test_that("get_input_peer converts UserEmpty to InputPeerEmpty", {
  ue <- structure(list(SUBCLASS_OF_ID = 0L), class = "UserEmpty")
  result <- get_input_peer(ue)
  expect_true(inherits(result, "InputPeerEmpty"))
})

test_that("get_input_peer converts ChannelForbidden to InputPeerChannel", {
  cf <- structure(list(id = 200L, access_hash = 300L, SUBCLASS_OF_ID = 0L), class = "ChannelForbidden")
  result <- get_input_peer(cf)
  expect_true(inherits(result, "InputPeerChannel"))
})

test_that("get_input_peer converts PeerChat to InputPeerChat", {
  pc <- PeerChat$new(chat_id = 55L)
  result <- get_input_peer(pc)
  expect_true(inherits(result, "InputPeerChat"))
  expect_equal(result$chat_id, 55L)
})

# ── get_input_message ─────────────────────────────────────────────────────────
test_that("get_input_message converts integer to InputMessageID", {
  result <- get_input_message(42L)
  expect_true(inherits(result, "InputMessageID"))
  expect_equal(result$id, 42L)
})

# ── get_message_id ────────────────────────────────────────────────────────────
test_that("get_message_id returns NULL for NULL", {
  expect_null(get_message_id(NULL))
})

test_that("get_message_id returns integer as-is", {
  expect_equal(get_message_id(7L), 7L)
})

test_that("get_message_id extracts id from InputMessageID", {
  m <- InputMessageID$new(id = 99L)
  expect_equal(get_message_id(m), 99L)
})

test_that("get_message_id errors on unsupported type", {
  expect_error(get_message_id("invalid"), "Invalid message type")
})

# ── get_file_extension ────────────────────────────────────────────────────────
test_that("get_file_extension extracts extension from path string", {
  expect_equal(get_file_extension("photo.jpg"), "jpg")
  expect_equal(get_file_extension("document.pdf"), "pdf")
})

test_that("get_file_extension returns empty string for no extension", {
  expect_equal(get_file_extension("noext"), "")
})

# ── is_gif ────────────────────────────────────────────────────────────────────
test_that("is_gif returns TRUE for Photo-like objects (no .gif ext)", {
  photo <- structure(list(), class = "Photo")
  # get_extension for Photo returns ".jpg", so is_gif returns FALSE
  expect_false(is_gif(photo))
})

# ── sanitize_parse_mode ───────────────────────────────────────────────────────
test_that("sanitize_parse_mode returns NULL for NULL input", {
  expect_null(sanitize_parse_mode(NULL))
})

test_that("sanitize_parse_mode returns object unchanged when it has parse/unparse", {
  mode <- list(parse = identity, unparse = identity)
  result <- sanitize_parse_mode(mode)
  expect_identical(result, mode)
})

test_that("sanitize_parse_mode errors on unknown string", {
  expect_error(sanitize_parse_mode("xml"), "Unknown parse mode")
})

test_that("sanitize_parse_mode errors on invalid type", {
  expect_error(sanitize_parse_mode(42L), "Invalid parse mode type")
})

test_that("sanitize_parse_mode wraps callable in CustomMode", {
  fn <- function(text) list(text, list())
  result <- sanitize_parse_mode(fn)
  expect_true(inherits(result, "CustomMode"))
  expect_identical(result$parse, fn)
})

# ── get_peer_id / resolve_id ──────────────────────────────────────────────────
test_that("resolve_id returns PeerUser for positive ID", {
  r <- resolve_id(123L)
  expect_equal(r[[1]], 123L)
  expect_identical(r[[2]], PeerUser)
})

test_that("resolve_id returns PeerChat for small negative ID", {
  r <- resolve_id(-50L)
  expect_equal(r[[1]], 50L)
  expect_identical(r[[2]], PeerChat)
})

test_that("resolve_id returns PeerChannel for large negative ID", {
  r <- resolve_id(-(1000000000000 + 100))
  expect_equal(r[[1]], 100L)
  expect_identical(r[[2]], PeerChannel)
})

test_that("get_peer_id returns user_id for PeerUser", {
  pu <- PeerUser$new(user_id = 77L)
  expect_equal(get_peer_id(pu), 77L)
})

test_that("get_peer_id returns negative chat_id for PeerChat", {
  pc <- PeerChat$new(chat_id = 50L)
  expect_equal(get_peer_id(pc), -50L)
})

# ── parse_phone ───────────────────────────────────────────────────────────────
test_that("parse_phone strips formatting from phone string", {
  expect_equal(parse_phone("+1 (234) 567-890"), "1234567890")
})

test_that("parse_phone accepts plain integer", {
  expect_equal(parse_phone(1234567890L), "1234567890")
})

test_that("parse_phone returns NULL for non-numeric string", {
  expect_null(parse_phone("notaphone"))
})

# ── parse_username ────────────────────────────────────────────────────────────
test_that("parse_username strips @ prefix", {
  r <- parse_username("@durov")
  expect_equal(r$username, "durov")
  expect_false(r$is_join_chat)
})

test_that("parse_username detects joinchat links", {
  r <- parse_username("https://t.me/joinchat/abcXYZ123")
  expect_true(r$is_join_chat)
})

test_that("parse_username returns NULL username for invalid input", {
  r <- parse_username("not-a-user")
  expect_null(r$username)
})

# ── get_inner_text ─────────────────────────────────────────────────────────────
test_that("get_inner_text extracts entity spans correctly", {
  # del_surrogate uses intToUtf8(..., multiple=TRUE) returning one char per element
  entity <- list(offset = 6L, length = 5L)
  result <- get_inner_text("Hello world!", list(entity))
  expect_equal(length(result), 5L)
  expect_equal(result[[1]], "w")
  expect_equal(result[[5]], "d")
})

# ── get_extension ────────────────────────────────────────────────────────────
test_that("get_extension returns .jpg for Photo", {
  p <- structure(list(), class = "Photo")
  expect_equal(get_extension(p), ".jpg")
})

test_that("get_extension returns .jpg for ChatPhoto", {
  cp <- structure(list(), class = "ChatPhoto")
  expect_equal(get_extension(cp), ".jpg")
})

test_that("get_extension returns empty string for unknown media", {
  x <- structure(list(), class = "UnknownMediaType")
  expect_equal(get_extension(x), "")
})

# ── decode/encode_telegram_base64 ────────────────────────────────────────────
test_that("encode and decode telegram base64 are inverses", {
  original <- as.raw(c(0xDE, 0xAD, 0xBE, 0xEF))
  encoded <- encode_telegram_base64(original)
  decoded <- decode_telegram_base64(encoded)
  expect_equal(decoded, original)
})

# ── get_file_info ─────────────────────────────────────────────────────────────
test_that("get_file_info returns location and dc_id for InputDocumentFileLocation", {
  loc <- structure(list(), class = "InputDocumentFileLocation")
  result <- get_file_info(loc)
  expect_null(result$dc_id)
  expect_identical(result$location, loc)
})

test_that("get_file_info raises on unknown type", {
  bad <- structure(list(), class = "RandomClass")
  expect_error(get_file_info(bad), "Cannot cast")
})
