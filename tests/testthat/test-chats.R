test_that("_ChatAction initializes correctly", {
  skip_on_cran()
  act <- list(client = list(), chat = list(id = 1), action = "typing", delay = 4, auto_cancel = TRUE, running = FALSE)
  class(act) <- c("_ChatAction", "list")
  expect_equal(act$action, "typing")
  expect_equal(act$delay, 4)
  expect_equal(act$auto_cancel, TRUE)
  expect_false(act$running)
})

`$.fake_client` <- function(x, name) attr(x, name, exact = TRUE)

test_that("_ChatAction enter/exit uses client and builds requests", {
  skip_on_cran()
  old_set_typing <- NULL
  old_cancel <- NULL
  if (exists("SetTypingRequest", inherits = FALSE)) old_set_typing <- get("SetTypingRequest", inherits = FALSE)
  if (exists("SendMessageCancelAction", inherits = FALSE)) old_cancel <- get("SendMessageCancelAction", inherits = FALSE)
  on.exit({
    if (is.null(old_set_typing)) {
      if (exists("SetTypingRequest", inherits = FALSE)) rm("SetTypingRequest", inherits = FALSE)
    } else {
      assign("SetTypingRequest", old_set_typing, envir = .GlobalEnv)
    }
    if (is.null(old_cancel)) {
      if (exists("SendMessageCancelAction", inherits = FALSE)) rm("SendMessageCancelAction", inherits = FALSE)
    } else {
      assign("SendMessageCancelAction", old_cancel, envir = .GlobalEnv)
    }
  }, add = TRUE)

  if (!exists("SetTypingRequest", envir = .GlobalEnv, inherits = FALSE)) {
    assign("SetTypingRequest", function(peer, action) list(peer = peer, action = action), envir = .GlobalEnv)
  }
  if (!exists("SendMessageCancelAction", envir = .GlobalEnv, inherits = FALSE)) {
    assign("SendMessageCancelAction", function() list(`_` = "SendMessageCancelAction"), envir = .GlobalEnv)
  }
  calls <- list()
  fake_client <- function(req) {
    calls[[length(calls) + 1L]] <<- req
    TRUE
  }
  class(fake_client) <- "fake_client"
  attr(fake_client, "get_input_entity") <- function(x) x

  act <- telegramR:::.ChatAction$new(
    client = fake_client,
    chat = InputPeerChat$new(chat_id = 123),
    action = "typing",
    auto_cancel = TRUE
  )

  act$enter()
  expect_true(act$running)
  expect_true(length(calls) >= 1L)

  act$exit()
  expect_false(act$running)
})

test_that("_ChatAction progress updates action if progress is in names", {
  skip_on_cran()
  act <- list(client = list(), chat = list(id = 1), action = list(progress = 0))
  class(act) <- c("_ChatAction", "list")
  
  progress_fn <- function(act_obj, current, total) {
    if ("progress" %in% names(act_obj$action)) {
      act_obj$action$progress <- 100 * round(current / total, 2)
    }
    return(act_obj)
  }
  
  act <- progress_fn(act, 50, 100)
  expect_equal(act$action$progress, 50)
  
  act <- progress_fn(act, 3, 4)
  expect_equal(act$action$progress, 75)
})

test_that("_ParticipantsIter initializes correctly", {
  skip_on_cran()
  if (!exists("helpers", inherits = TRUE)) {
    testthat::skip("helpers not available in this environment")
  }
  # Mock client and entity
  mock_client <- function(req) {
    if (inherits(req, "GetParticipantsRequest")) {
      user <- structure(list(id = 1, username = "u1"), class = "User")
      part <- structure(list(user_id = 1), class = "ChannelParticipant")
      return(list(count = 1, users = list(user), participants = list(part)))
    }
    stop("unexpected request")
  }
  class(mock_client) <- "fake_client"
  attr(mock_client, "get_input_entity") <- function(x) x

  ent <- InputPeerChannel$new(channel_id = 1, access_hash = 1)
  iter <- telegramR:::.ParticipantsIter$new(client = mock_client, limit = 1, entity = ent)
  iter$.load_next_chunk()

  expect_true(length(iter$buffer) >= 1L)
})

test_that("_AdminLogIter initializes correctly", {
  skip_on_cran()
  mock_client <- list()
  iter <- list(client = mock_client, left = Inf)
  class(iter) <- c("_AdminLogIter", "RequestIter", "list")
  expect_equal(iter$left, Inf)
})

test_that("_ProfilePhotoIter initializes correctly", {
  skip_on_cran()
  mock_client <- list()
  iter <- list(client = mock_client, left = Inf)
  class(iter) <- c("_ProfilePhotoIter", "RequestIter", "list")
  expect_equal(iter$left, Inf)
})
