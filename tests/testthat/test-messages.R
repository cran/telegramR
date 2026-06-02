test_that("MessagesIter selects proper request types", {
  skip_on_cran()
  # global search when entity is NULL
  it1 <- MessagesIter$new(client = NULL, entity = NULL)
  expect_equal(it1$request$type, "search_global")

  # scheduled when entity provided and scheduled = TRUE
  it2 <- MessagesIter$new(client = NULL, entity = "x", scheduled = TRUE)
  expect_equal(it2$request$type, "scheduled")

  # replies when reply_to provided
  it3 <- MessagesIter$new(client = NULL, entity = "x", reply_to = 5)
  expect_equal(it3$request$type, "replies")

  # search when search arg provided
  it4 <- MessagesIter$new(client = NULL, entity = "x", search = "hello")
  expect_equal(it4$request$type, "search")

  # history is default
  it5 <- MessagesIter$new(client = NULL, entity = "x")
  expect_equal(it5$request$type, "history")
})


test_that("MessagesIter marks exhausted when limit <= 0 and has_next/buffer behavior", {
  skip_on_cran()
  it <- MessagesIter$new(client = NULL, entity = NULL, limit = 0)
  expect_true(it$exhausted)
  expect_false(it$has_next())
  # when buffer has items, has_next should be TRUE
  it$buffer <- list(list(id = 1))
  expect_true(it$has_next())
})


test_that("MessagesIter load_next_chunk and iteration with dummy client", {
  skip_on_cran()
  # dummy client returning two messages
  client <- list()
  client$iter_messages <- function(...) {
    # iterator placeholder
    list()
  }
  client$collect <- function(it) {
    list(list(id = 10L, sender_id = 2L), list(id = 11L, sender_id = 2L))
  }

  mit <- MessagesIter$new(client = client, entity = NULL, limit = 10)
  out <- mit$load_next_chunk()
  expect_true(is.list(out))
  expect_equal(length(out), 2)
  # buffer should now contain messages
  expect_equal(length(mit$buffer), 2)

  # .next should return first item and decrease buffer
  first <- mit$.next()
  expect_equal(first$id, 10L)
  expect_equal(length(mit$buffer), 1)

  # Simulate client collect error => exhausted and NULL returned
  bad_client <- list()
  bad_client$iter_messages <- function(...) list()
  bad_client$collect <- function(it) stop("boom")
  mit2 <- MessagesIter$new(client = bad_client, entity = NULL)
  res <- mit2$load_next_chunk()
  expect_null(res)
  expect_true(mit2$exhausted)
})


test_that("IDsIter loads messages by ids and respects peer filtering", {
  skip_on_cran()
  # client that returns messages list in 'messages' field
  client <- list()
  client$get_messages <- function(ids) {
    # return messages with id equal to input ids
    msgs <- lapply(ids, function(i) list(id = i, peer_id = 123L))
    list(messages = msgs)
  }
  client$get_peer <- function(entity_input) 123L

  ids <- c(5L, 6L, 7L)
  iit <- IDsIter$new(client = client, entity = "ent", ids = ids)
  out <- iit$load_next_chunk()
  expect_equal(length(out), length(ids))
  expect_true(all(sapply(out, function(x) !is.null(x) && x$id %in% ids)))

  # If peer does not match, messages should be NULL in results
  client2 <- list()
  client2$get_messages <- function(ids) lapply(ids, function(i) list(id = i, peer_id = 999L))
  client2$get_peer <- function(entity_input) 123L
  iit2 <- IDsIter$new(client = client2, entity = "ent", ids = c(1L, 2L))
  out2 <- iit2$load_next_chunk()
  expect_true(all(sapply(out2, is.null)))

  # If client has neither method, loading should error
  client3 <- list()
  iit3 <- IDsIter$new(client = client3, entity = NULL, ids = c(1L))
  expect_error(iit3$load_next_chunk(), "No suitable client method to get messages by ids")
})
