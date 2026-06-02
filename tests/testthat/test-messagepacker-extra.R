# Extra MessagePacker coverage: multi-message container path, item-too-big
# put-back branch, MAXIMUM_LENGTH boundary.

make_packer_with_state <- function() {
  set.seed(77)
  ak    <- AuthKey$new(as.raw(sample(0:255, 256, replace = TRUE)))
  state <- MTProtoState$new(ak, NULL)
  MessagePacker$new(state = state)
}

# --- single message path (batch size 1) ---

test_that("get with 1 item returns non-empty data and batch of length 1", {
  skip_on_cran()
  packer <- make_packer_with_state()
  packer$append(list(data = as.raw(rep(0x01, 8)), request = list()))

  result <- packer$get()

  expect_equal(length(result[[1]]), 1L)   # batch has 1 element
  expect_type(result[[2]], "raw")
  expect_gt(length(result[[2]]), 0L)
})

# --- multi-message container path (batch size > 1) ---

test_that("get with 3 items builds a container and returns batch of 3", {
  skip_on_cran()
  packer <- make_packer_with_state()
  for (i in seq_len(3)) {
    packer$append(list(data = as.raw(rep(as.integer(i), 8)), request = list()))
  }

  result <- packer$get()

  expect_equal(length(result[[1]]), 3L)   # all 3 in batch
  expect_type(result[[2]], "raw")
  # Container adds header bytes; output should be larger than just the 3 raw payloads
  expect_gt(length(result[[2]]), 24L)
})

# --- item-too-large: single oversized item returns NULL batch ---

test_that("get with oversized single item returns NULL batch and NULL data", {
  skip_on_cran()
  packer  <- make_packer_with_state()
  big_data <- as.raw(rep(0xFF, MessageContainer$MAXIMUM_SIZE + 1L))
  packer$append(list(data = big_data, request = list()))

  result <- packer$get()

  expect_null(result[[1]])
  expect_null(result[[2]])
})

# --- item-too-large with existing batch items triggers put-back ---

test_that("second item exceeding size is put back; only first item in batch", {
  skip_on_cran()
  packer    <- make_packer_with_state()
  small_d   <- as.raw(rep(0x01, 8))
  big_d     <- as.raw(rep(0xFF, MessageContainer$MAXIMUM_SIZE + 1L))

  # Put a small item first, then an oversized one
  packer$append(list(data = small_d, request = list()))
  packer$append(list(data = big_d,   request = list()))

  result <- packer$get()

  # Only the small item is batched
  expect_equal(length(result[[1]]), 1L)
  # The oversized item remains in the deque
  expect_equal(length(packer$deque), 1L)
})

# --- MAXIMUM_LENGTH boundary ---

test_that("get batches at most MAXIMUM_LENGTH items (100)", {
  skip_on_cran()
  packer  <- make_packer_with_state()
  n_items <- MessageContainer$MAXIMUM_LENGTH + 5L  # 105

  for (i in seq_len(n_items)) {
    packer$append(list(data = as.raw(rep(as.integer(i %% 256), 4)), request = list()))
  }

  result <- packer$get()

  # Batch must not exceed MAXIMUM_LENGTH
  expect_lte(length(result[[1]]), MessageContainer$MAXIMUM_LENGTH)
  # Remaining items should still be in the deque
  expect_gt(length(packer$deque), 0L)
})

# --- request class determines content_related (MsgsAck is not content-related) ---

test_that("get with MsgsAck request is handled without error", {
  skip_on_cran()
  packer <- make_packer_with_state()
  # Simulate a non-content-related request by naming its class MsgsAck
  req <- structure(list(), class = "MsgsAck")
  packer$append(list(data = as.raw(rep(0x00, 4)), request = req))

  result <- packer$get()
  expect_equal(length(result[[1]]), 1L)
})
