test_that("sanitize_parse_mode accepts valid modes and rejects invalid", {
  skip_on_cran()
  obj <- MessageParseMethods$new()
  expect_null(obj$sanitize_parse_mode(NULL))
  expect_equal(obj$sanitize_parse_mode("markdown"), "markdown")
  expect_equal(obj$sanitize_parse_mode("md"), "md")
  expect_equal(obj$sanitize_parse_mode("html"), "html")
  expect_equal(obj$sanitize_parse_mode("htm"), "htm")
  expect_error(obj$sanitize_parse_mode("plain"), "Invalid parse mode")
})

test_that("set_parse_mode and get_parse_mode work and initialize stores mode", {
  skip_on_cran()
  obj <- MessageParseMethods$new("md")
  expect_equal(obj$get_parse_mode(), "md")

  obj$set_parse_mode("html")
  expect_equal(obj$get_parse_mode(), "html")

  # setting invalid mode should error
  expect_error(obj$set_parse_mode("invalid"), "Invalid parse mode")
})

test_that("parse_message_text returns raw message when parse_mode is NULL and parses when set", {
  skip_on_cran()
  obj <- MessageParseMethods$new(NULL)
  res <- obj$parse_message_text("hello")
  expect_type(res, "list")
  expect_equal(res$message, "hello")
  expect_equal(length(res$entities), 0)

  # when parse_mode is provided as argument
  res2 <- obj$parse_message_text("hello", parse_mode = "markdown")
  expect_equal(res2$message, "hello")
  expect_equal(length(res2$entities), 0)

  # when parse_mode set on object and message empty -> error
  obj2 <- MessageParseMethods$new("md")
  expect_error(obj2$parse_message_text("", NULL), "Failed to parse message")
})

test_that("replace_with_mention returns TRUE on success and FALSE on invalid index", {
  skip_on_cran()
  obj <- MessageParseMethods$new()
  entities <- list(list(offset = 0L, length = 5L))
  # should return TRUE for valid replacement
  expect_true(obj$replace_with_mention(entities, 1, list(id = 42)))

  # invalid index should return FALSE (caught by tryCatch)
  expect_false(obj$replace_with_mention(list(), 1, list(id = 1)))
})

test_that("get_response_message handles different result classes and mappings", {
  skip_on_cran()
  obj <- MessageParseMethods$new()

  # Create updates: one maps random_id -> message id, another provides the message
  upd_map <- list(random_id = 123, id = 10)
  class(upd_map) <- "UpdateMessageID"

  msg <- list(id = 10, text = "mapped message")
  upd_msg <- list(message = msg)
  class(upd_msg) <- "UpdateNewMessage"

  result_updates <- list(updates = list(upd_map, upd_msg), users = list(), chats = list())
  class(result_updates) <- "Updates"

  # When request is NULL, should return all id_to_message entries (message keyed by id)
  all_msgs <- obj$get_response_message(NULL, result_updates, NULL)
  expect_true(is.list(all_msgs))
  # should contain the message under key "10"
  expect_equal(all_msgs[["10"]]$text, "mapped message")

  # When request provides a numeric random id, should return the corresponding message
  res_msg <- obj$get_response_message(123, result_updates, NULL)
  expect_equal(res_msg$text, "mapped message")

  # When request provides a list of random ids, should return a list of messages
  req_obj <- list(random_id = list(123))
  res_list <- obj$get_response_message(req_obj, result_updates, NULL)
  expect_type(res_list, "list")
  expect_equal(res_list[[1]]$text, "mapped message")

  # If result is UpdateShort wrapping a single update
  short_result <- list(update = upd_msg)
  class(short_result) <- "UpdateShort"
  # request NULL should return id_to_message with the one message
  short_msgs <- obj$get_response_message(NULL, short_result, NULL)
  expect_equal(short_msgs[["10"]]$text, "mapped message")

  # If result has unexpected class, should return NULL
  bad_result <- list(foo = "bar")
  class(bad_result) <- "SomethingElse"
  expect_null(obj$get_response_message(NULL, bad_result, NULL))

  # If request object has no random_id, a warning and NULL should occur
  req_no_rand <- list()
  expect_warning(res_null <- obj$get_response_message(req_no_rand, result_updates, NULL), "No random_id in request to map to, returning NULL")
  expect_null(res_null)
})
