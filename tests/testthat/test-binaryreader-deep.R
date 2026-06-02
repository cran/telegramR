# Deep coverage for BinaryReader methods not covered by test-binaryreader.R

# Helper: build TG-encoded byte payload (short format, length < 254)
make_tg_bytes <- function(payload) {
  n <- length(payload)
  total_with_len <- n + 1L
  padding_needed <- if (total_with_len %% 4 == 0) 0L else 4L - (total_with_len %% 4)
  c(as.raw(n), payload, raw(padding_needed))
}

# Helper: build TG-encoded byte payload (long format, length >= 254)
make_tg_bytes_long <- function(payload) {
  n <- length(payload)
  padding_needed <- if (n %% 4 == 0) 0L else 4L - (n %% 4)
  c(
    as.raw(254L),
    as.raw(n %% 256L),
    as.raw((n %/% 256L) %% 256L),
    as.raw((n %/% 65536L) %% 256L),
    payload,
    raw(padding_needed)
  )
}

write_i32 <- function(x) {
  x_num <- as.numeric(x)
  if (is.na(x_num)) stop("x must be numeric")
  if (x_num < 0) x_num <- x_num + 2^32
  as.raw(c(
    x_num %% 256,
    (x_num %/% 256) %% 256,
    (x_num %/% 65536) %% 256,
    (x_num %/% 16777216) %% 256
  ))
}
write_i64 <- function(x) {
  x_num <- as.numeric(x)
  if (is.na(x_num) || x_num < 0) stop("x must be a non-negative numeric")
  bytes <- numeric(8)
  for (i in seq_len(8)) {
    bytes[i] <- x_num %% 256
    x_num <- floor(x_num / 256)
  }
  as.raw(bytes)
}
ctor_bytes <- function(id) write_i32(id)

peer_user_bytes <- function(user_id) {
  c(ctor_bytes(PeerUser$public_fields$CONSTRUCTOR_ID), write_i64(user_id))
}

peer_chat_bytes <- function(chat_id) {
  c(ctor_bytes(PeerChat$public_fields$CONSTRUCTOR_ID), write_i64(chat_id))
}

peer_channel_bytes <- function(channel_id) {
  c(ctor_bytes(PeerChannel$public_fields$CONSTRUCTOR_ID), write_i64(channel_id))
}

empty_vector_bytes <- function() {
  c(ctor_bytes(481674261L), write_i32(0L))
}

# --- read() edge cases ---

test_that("BinaryReader read(0) returns empty raw vector", {
  r <- BinaryReader$new(as.raw(c(0x01, 0x02)))
  expect_equal(r$read(0L), raw(0))
  expect_equal(r$tell_position(), 0L)
})

test_that("BinaryReader read(-1) returns all remaining bytes", {
  r <- BinaryReader$new(as.raw(c(0xAA, 0xBB, 0xCC)))
  r$set_position(1L)
  rest <- r$read(-1L)
  expect_equal(rest, as.raw(c(0xBB, 0xCC)))
  expect_equal(r$tell_position(), 3L)
})

test_that("BinaryReader read() past end throws error", {
  r <- BinaryReader$new(as.raw(c(0x01)))
  expect_error(r$read(5L), "No more data")
})

# --- read_float / read_double ---

test_that("BinaryReader read_float parses 4-byte float correctly", {
  # Pack 1.5 as little-endian 4-byte float
  b <- writeBin(1.5, raw(), size = 4L, endian = "little")
  r <- BinaryReader$new(b)
  expect_equal(r$read_float(), 1.5)
})

test_that("BinaryReader read_double parses 8-byte double correctly", {
  b <- writeBin(3.141592653589793, raw(), size = 8L, endian = "little")
  r <- BinaryReader$new(b)
  expect_true(abs(r$read_double() - pi) < 1e-12)
})

# --- bytes_to_int ---

test_that("bytes_to_int handles unsigned 32-bit values > INT_MAX", {
  r <- BinaryReader$new(raw(0))
  bytes <- as.raw(c(0xFF, 0xFF, 0xFF, 0xFF))  # 4294967295
  val <- r$bytes_to_int(bytes, signed = FALSE)
  expect_equal(val, 4294967295)
})

test_that("bytes_to_int handles negative signed 32-bit values", {
  r <- BinaryReader$new(raw(0))
  # -1 in little-endian 4 bytes
  bytes <- as.raw(c(0xFF, 0xFF, 0xFF, 0xFF))
  val <- r$bytes_to_int(bytes, signed = TRUE)
  expect_equal(val, -1L)
})

test_that("bytes_to_int handles 8-byte signed value", {
  r <- BinaryReader$new(raw(0))
  # -1 in 8 bytes
  bytes <- as.raw(rep(0xFF, 8))
  val <- r$bytes_to_int(bytes, signed = TRUE)
  expect_equal(as.numeric(val), -1)
})

test_that("bytes_to_int handles 8-byte unsigned large value", {
  r <- BinaryReader$new(raw(0))
  # 2^63 in little-endian
  bytes <- c(as.raw(rep(0x00, 7)), as.raw(0x80))
  val <- r$bytes_to_int(bytes, signed = FALSE)
  expect_equal(as.numeric(val), 2^63)
})

# --- read_large_int ---

test_that("BinaryReader read_large_int reads 128-bit value", {
  b <- c(as.raw(rep(0x01, 16)))  # 16 bytes = 128 bits
  r <- BinaryReader$new(b)
  val <- r$read_large_int(128L)
  expect_true(inherits(val, "bigz") || is.numeric(val))
  expect_gt(as.numeric(val), 0)
})

test_that("BinaryReader read_large_int reads 256-bit value", {
  b <- c(as.raw(rep(0x01, 32)))  # 32 bytes = 256 bits
  r <- BinaryReader$new(b)
  val <- r$read_large_int(256L)
  expect_true(inherits(val, "bigz") || is.numeric(val))
})

# --- tgread_bytes ---

test_that("BinaryReader tgread_bytes reads short format (< 254 bytes)", {
  payload <- charToRaw("hello")
  encoded <- make_tg_bytes(payload)
  r <- BinaryReader$new(encoded)
  expect_equal(r$tgread_bytes(), payload)
})

test_that("BinaryReader tgread_bytes handles short format with zero padding", {
  payload <- as.raw(c(0x01, 0x02, 0x03))
  encoded <- make_tg_bytes(payload)
  r <- BinaryReader$new(encoded)
  expect_equal(r$tgread_bytes(), payload)
  expect_equal(r$tell_position(), length(encoded))
})

test_that("BinaryReader tgread_bytes reads long format (>= 254 bytes)", {
  payload <- as.raw(seq_len(300) %% 256)
  encoded <- make_tg_bytes_long(payload)
  r <- BinaryReader$new(encoded)
  result <- r$tgread_bytes()
  expect_equal(result, payload)
})

test_that("BinaryReader tgreadbytes alias works", {
  payload <- charToRaw("test")
  encoded <- make_tg_bytes(payload)
  r <- BinaryReader$new(encoded)
  expect_equal(r$tgreadbytes(), payload)
})

# --- tgread_string ---

test_that("BinaryReader tgread_string decodes UTF-8 string", {
  s       <- "Привіт"
  payload <- charToRaw(s)
  encoded <- make_tg_bytes(payload)
  r <- BinaryReader$new(encoded)
  expect_equal(r$tgread_string(), s)
})

test_that("BinaryReader tgread_string decodes empty string", {
  encoded <- make_tg_bytes(raw(0))
  r <- BinaryReader$new(encoded)
  expect_equal(r$tgread_string(), "")
})

# --- tgread_date ---

test_that("BinaryReader tgread_date returns NULL for timestamp 0", {
  b <- writeBin(0L, raw(), size = 4L, endian = "little")
  r <- BinaryReader$new(b)
  expect_null(r$tgread_date())
})

test_that("BinaryReader tgread_date returns POSIXct for non-zero timestamp", {
  ts <- 1700000000L
  b  <- writeBin(ts, raw(), size = 4L, endian = "little")
  r  <- BinaryReader$new(b)
  dt <- r$tgread_date()
  expect_s3_class(dt, "POSIXct")
  expect_equal(as.integer(dt), ts)
})

# --- read_int signed/unsigned ---

test_that("BinaryReader read_int unsigned returns numeric for value > INT_MAX", {
  b <- as.raw(c(0xFF, 0xFF, 0xFF, 0xFF))
  r <- BinaryReader$new(b)
  val <- r$read_int(signed = FALSE)
  expect_equal(val, 4294967295)
})

test_that("BinaryReader read_int signed returns negative for 0xFFFFFFFF", {
  b <- as.raw(c(0xFF, 0xFF, 0xFF, 0xFF))
  r <- BinaryReader$new(b)
  val <- r$read_int(signed = TRUE)
  expect_equal(val, -1L)
})

# --- tgread_object: Vector ---

test_that("BinaryReader tgread_object parses empty Vector (0x1cb5c415)", {
  # Vector constructor: 0x1cb5c415, count = 0
  b <- c(
    as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),  # Vector constructor (little-endian)
    writeBin(0L, raw(), size = 4L, endian = "little")
  )
  r   <- BinaryReader$new(b)
  obj <- r$tgread_object()
  expect_true(is.list(obj))
  expect_equal(length(obj), 0L)
})

test_that("BinaryReader tgread_object falls back when Vector count is impossible", {
  b <- c(
    as.raw(c(0x15, 0xc4, 0xb5, 0x1c)),
    writeBin(99L, raw(), size = 4L, endian = "little"),
    as.raw(c(0xAA, 0xBB))
  )
  r <- BinaryReader$new(b)
  obj <- r$tgread_object()
  expect_true(is.list(obj))
  expect_equal(obj$CONSTRUCTOR_ID, 481674261)
  expect_equal(obj$data, as.raw(c(0xAA, 0xBB)))
})

# --- tgread_object: unknown constructor ---

test_that("BinaryReader tgread_object returns list with CONSTRUCTOR_ID for unknown ctor", {
  # Use a constructor id that is very unlikely to match any known type
  # 0xDEADBEEF in little-endian bytes (avoids non-integer L suffix warning)
  b <- as.raw(c(0xEF, 0xBE, 0xAD, 0xDE))
  r   <- BinaryReader$new(b)
  obj <- r$tgread_object()
  expect_true(is.list(obj))
  expect_true(!is.null(obj$CONSTRUCTOR_ID))
})

test_that("BinaryReader tgread_object returns empty payload for unknown ctor at EOF", {
  b <- as.raw(c(0xEF, 0xBE, 0xAD, 0xDE))
  r <- BinaryReader$new(b)
  obj <- r$tgread_object()
  expect_equal(obj$data, raw(0))
})

test_that("BinaryReader tgread_object falls back for invalid gzip payload", {
  payload <- as.raw(c(0x01, 0x02, 0x03, 0x04))
  packed <- make_tg_bytes(payload)
  b <- c(
    as.raw(c(0xA1, 0xCF, 0x72, 0x30)), # GzipPacked constructor 0x3072cfa1 little-endian
    packed
  )
  r <- BinaryReader$new(b)
  obj <- r$tgread_object()
  expect_equal(obj$CONSTRUCTOR_ID, 812830625)
  expect_equal(obj$data, payload)
})

test_that("telegramR_read_peer parses known peer constructors", {
  r_user <- BinaryReader$new(peer_user_bytes(123))
  out_user <- .telegramR_read_peer(r_user)
  expect_true(inherits(out_user, "PeerUser"))
  expect_equal(as.numeric(out_user$user_id), 123)

  r_chat <- BinaryReader$new(peer_chat_bytes(456))
  out_chat <- .telegramR_read_peer(r_chat)
  expect_true(inherits(out_chat, "PeerChat"))
  expect_equal(as.numeric(out_chat$chat_id), 456)

  r_channel <- BinaryReader$new(peer_channel_bytes(789))
  out_channel <- .telegramR_read_peer(r_channel)
  expect_true(inherits(out_channel, "PeerChannel"))
  expect_equal(as.numeric(out_channel$channel_id), 789)
})

test_that("telegramR_read_user_profile_photo parses populated and empty variants", {
  stripped <- charToRaw("ab")
  b_full <- c(
    ctor_bytes(UserProfilePhoto$public_fields$CONSTRUCTOR_ID),
    write_i32(3L),   # has_video + stripped_thumb
    write_i64(12345),
    make_tg_bytes(stripped),
    write_i32(7L)
  )
  r_full <- BinaryReader$new(b_full)
  out_full <- .telegramR_read_user_profile_photo(r_full)
  expect_true(inherits(out_full, "UserProfilePhoto"))
  expect_equal(as.numeric(out_full$photo_id), 12345)
  expect_equal(out_full$dc_id, 7)
  expect_true(out_full$has_video)
  expect_equal(out_full$stripped_thumb, stripped)

  b_empty <- ctor_bytes(UserProfilePhotoEmpty$public_fields$CONSTRUCTOR_ID)
  r_empty <- BinaryReader$new(b_empty)
  out_empty <- .telegramR_read_user_profile_photo(r_empty)
  expect_true(inherits(out_empty, "UserProfilePhotoEmpty"))
})

test_that("telegramR_read_peer falls back on unknown constructor", {
  r <- BinaryReader$new(as.raw(c(0xEF, 0xBE, 0xAD, 0xDE)))
  out <- .telegramR_read_peer(r)
  expect_true(is.list(out))
  expect_equal(out$CONSTRUCTOR_ID, 3735928559)
})

test_that("telegramR_read_contacts_resolved_peer handles empty vectors", {
  b <- c(
    peer_user_bytes(123),
    empty_vector_bytes(),
    empty_vector_bytes()
  )
  r <- BinaryReader$new(b)
  out <- .telegramR_read_contacts_resolved_peer(r)
  expect_true(inherits(out, "ContactsResolvedPeer"))
  expect_true(inherits(out$peer, "PeerUser"))
  expect_length(out$users, 0)
  expect_length(out$chats, 0)
})

test_that("telegramR_read_messages_chat_full returns partial structure on invalid vectors", {
  b <- c(
    as.raw(c(0xEF, 0xBE, 0xAD, 0xDE)), # unknown full_chat ctor
    write_i32(481674261L),             # chats vector ctor
    write_i32(999L)                    # impossible chats length for remaining bytes
  )
  r <- BinaryReader$new(b)
  out <- .telegramR_read_messages_chat_full(r)
  expect_equal(out$`_`, "messages.ChatFull")
  expect_true(is.list(out$full_chat))
  expect_length(out$chats, 0)
  expect_length(out$users, 0)
})

test_that("telegramR_read_channel returns fallback channel on insufficient data", {
  b <- c(
    write_i32(0L),  # flags
    write_i32(0L)   # flags2
  )
  r <- BinaryReader$new(b)
  out <- .telegramR_read_channel(r)
  expect_true(inherits(out, "Channel"))
  expect_true(is.null(out$id) || (length(out$id) == 1 && is.na(out$id)))
  expect_true(is.null(out$title) || (length(out$title) == 1 && is.na(out$title)))
  expect_null(out$date)
})

test_that("telegramR_read_channel_full returns fallback object on insufficient data", {
  b <- c(
    write_i32(0L),  # flags
    write_i32(0L)   # flags2
  )
  r <- BinaryReader$new(b)
  out <- .telegramR_read_channel_full(r)
  expect_true(inherits(out, "ChannelFull"))
  expect_true(is.null(out$id) || (length(out$id) == 1 && is.na(out$id)))
  expect_true(is.null(out$about) || (length(out$about) == 1 && is.na(out$about)))
  expect_length(out$bot_info, 0)
})

test_that("telegramR_read_user parses minimal payload", {
  b <- c(
    write_i32(0L),  # flags
    write_i32(0L),  # flags2
    write_i64(123L)
  )
  r <- BinaryReader$new(b)
  out <- .telegramR_read_user(r)
  expect_true(inherits(out, "User"))
  expect_equal(as.numeric(out$id), 123)
  expect_false(out$bot)
  expect_null(out$username)
  expect_null(out$photo)
})

test_that("telegramR_read_contacts_resolved_peer returns partial result on malformed user vector", {
  b <- c(
    peer_user_bytes(123),
    as.raw(c(0xEF, 0xBE, 0xAD, 0xDE))
  )
  r <- BinaryReader$new(b)
  out <- .telegramR_read_contacts_resolved_peer(r)
  expect_true(is.list(out))
  expect_true(inherits(out$peer, "PeerUser"))
  expect_length(out$users, 0)
  expect_length(out$chats, 0)
})

test_that("telegramR_read_messages_not_modified returns expected shape", {
  r <- BinaryReader$new(write_i32(7L))
  out <- .telegramR_read_messages_not_modified(r)
  expect_equal(out$`_`, "MessagesNotModified")
  expect_equal(out$count, 7)
})

test_that("telegramR_read_messages_slice parses minimal empty payload", {
  b <- c(
    write_i32(0L),  # flags
    write_i32(5L),  # count
    empty_vector_bytes(),
    empty_vector_bytes(),
    empty_vector_bytes(),
    empty_vector_bytes()
  )
  r <- BinaryReader$new(b)
  out <- .telegramR_read_messages_slice(r)
  expect_equal(out$count, 5)
  expect_false(out$inexact)
  expect_null(out$next_rate)
  expect_length(out$messages, 0)
  expect_length(out$topics, 0)
  expect_length(out$chats, 0)
  expect_length(out$users, 0)
})

test_that("telegramR_read_messages parses minimal empty payload", {
  b <- c(
    empty_vector_bytes(),
    empty_vector_bytes(),
    empty_vector_bytes(),
    empty_vector_bytes()
  )
  r <- BinaryReader$new(b)
  out <- .telegramR_read_messages(r)
  expect_length(out$messages, 0)
  expect_length(out$topics, 0)
  expect_length(out$chats, 0)
  expect_length(out$users, 0)
})

test_that("telegramR_read_channel_messages returns partial result when topics vector is truncated", {
  b <- c(
    write_i32(0L),            # flags
    write_i32(10L),           # pts
    write_i32(2L),            # count
    empty_vector_bytes(),     # messages
    write_i32(481674261L)     # topics vector ctor without count -> partial return
  )
  r <- BinaryReader$new(b)
  out <- .telegramR_read_channel_messages(r)
  expect_equal(out$pts, 10)
  expect_equal(out$count, 2)
  expect_length(out$messages, 0)
  expect_length(out$topics, 0)
  expect_length(out$chats, 0)
  expect_length(out$users, 0)
})

test_that("telegramR_read_message_service parses minimal service message", {
  b <- c(
    write_i32(0L),                 # flags
    write_i32(42L),                # id
    peer_user_bytes(123),          # peer_id
    write_i32(1700000000L),        # date
    as.raw(c(0xEF, 0xBE, 0xAD, 0xDE)) # unknown action ctor
  )
  r <- BinaryReader$new(b)
  out <- .telegramR_read_message_service(r)
  expect_equal(out$`_`, "MessageService")
  expect_equal(out$id, 42)
  expect_false(is.null(out$peer_id))
  expect_s3_class(out$date, "POSIXct")
  expect_true(is.list(out$action))
})
