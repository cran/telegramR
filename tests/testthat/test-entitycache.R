test_that("EntityCache initializes correctly", {
  skip_on_cran()
  cache <- EntityCache$new()
  expect_null(cache$self_id)
  expect_null(cache$self_bot)
  expect_equal(length(cache$entities), 0)
  expect_equal(cache$size(), 0)
})

test_that("EntityCache set_self_user sets self arguments", {
  skip_on_cran()
  cache <- EntityCache$new()
  cache$set_self_user(12345, TRUE)
  expect_equal(cache$self_id, 12345)
  expect_equal(cache$self_bot, TRUE)
})

test_that("EntityCache extend adds users and chats and get retrieves them", {
  skip_on_cran()
  cache <- EntityCache$new()
  
  # Mock user and chat using basic lists but adding class "User" and "Chat"
  # They need to have an id or be resolvable by get_peer_id.
  user1 <- list(id = 111, SUBCLASS_OF_ID = 0)
  class(user1) <- c("UserEmpty", "list")
  user2 <- list(id = 222, SUBCLASS_OF_ID = 0)
  class(user2) <- c("UserEmpty", "list")
  chat1 <- list(id = 333, title = "Test Chat", SUBCLASS_OF_ID = 0)
  class(chat1) <- c("ChatEmpty", "list")
  chat2 <- list(id = 444, SUBCLASS_OF_ID = 0)
  class(chat2) <- c("ChatEmpty", "list")
  
  cache$extend(users = list(user1, user2), chats = list(chat1, chat2))
  
  expect_equal(cache$size(), 4)
  
  res_user1 <- cache$get(111)
  expect_equal(res_user1$id, 111)
  expect_true(inherits(res_user1, "UserEmpty"))
  
  res_chat1 <- cache$get(333)
  expect_equal(res_chat1$id, 333)
  expect_equal(res_chat1$title, "Test Chat")
  
  expect_null(cache$get(999))
})

test_that("EntityCache retain filters items correctly", {
  skip_on_cran()
  cache <- EntityCache$new()
  user1 <- list(id = 1, SUBCLASS_OF_ID = 0)
  class(user1) <- c("UserEmpty", "list")
  user2 <- list(id = 2, SUBCLASS_OF_ID = 0)
  class(user2) <- c("UserEmpty", "list")
  user3 <- list(id = 3, SUBCLASS_OF_ID = 0)
  class(user3) <- c("UserEmpty", "list")
  
  cache$extend(users = list(user1, user2, user3))
  expect_equal(cache$size(), 3)
  
  # retain only IDs < 3
  cache$retain(function(id_str) {
    as.numeric(id_str) < 3
  })
  
  expect_equal(cache$size(), 2)
  expect_false(is.null(cache$get(1)))
  expect_false(is.null(cache$get(2)))
  expect_null(cache$get(3))
})
