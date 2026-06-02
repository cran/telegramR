test_that("MessageContainer initializes correctly", {
  skip_on_cran()
  container <- MessageContainer$new(messages = list("message1", "message2"))
  expect_equal(container$messages, list("message1", "message2"))
})

test_that("MessageContainer to_dict works correctly", {
  skip_on_cran()
  mock_message <- R6::R6Class(
    "MockMessage",
    public = list(
      to_dict = function() {
        return(list("key" = "value"))
      }
    )
  )$new()

  container <- MessageContainer$new(messages = list(mock_message))
  dict <- container$to_dict()

  expect_equal(dict$`_`, "MessageContainer")
  expect_equal(dict$messages, list(list("key" = "value")))
})

test_that("MessageContainer from_reader works correctly", {
  skip_on_cran()
  mock_reader <- R6::R6Class(
    "MockReader",
    public = list(
      index = 0,
      data = list(
        list(msg_id = 1, seq_no = 100, length = 10, obj = list("key" = "value")),
        list(msg_id = 2, seq_no = 200, length = 20, obj = list("key2" = "value2"))
      ),
      read_int = function() {
        if (self$index == 0) {
          return(length(self$data))
        } else {
          return(self$data[[self$index]]$seq_no)
        }
      },
      read_long = function() {
        return(self$data[[self$index]]$msg_id)
      },
      tell_position = function() {
        return(0)
      },
      set_position = function(pos) {
        # Mock implementation
      },
      tgread_object = function() {
        return(self$data[[self$index]]$obj)
      },
      snext = function() {
        self$index <- self$index + 1
      }
    )
  )$new()

  mock_reader$snext()
  mock_reader$snext()

  container <- MessageContainer$new()
  container$from_reader(mock_reader)

  expect_equal(length(container$messages), 200)
  expect_equal(container$messages[[1]]$msg_id, 2)
  expect_equal(container$messages[[2]]$seq_no, 200)
})
