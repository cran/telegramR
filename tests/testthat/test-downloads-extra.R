test_that("upload.File stores chunk metadata", {
  skip_on_cran()
  file <- upload.File$new(mtime = 123L, bytes = as.raw(c(0x01, 0x02)))

  expect_equal(
    file$to_list(),
    list("_" = "upload.File", mtime = 123L, bytes = as.raw(c(0x01, 0x02)))
  )
})

test_that("DirectDownloadIter initializes local and exported senders", {
  skip_on_cran()
  client <- new.env(parent = emptyenv())
  client$session <- new.env(parent = emptyenv())
  client$session$dc_id <- 2L
  client$sender <- "home-sender"

  iter <- DirectDownloadIter$new(client = client)
  iter$init(
    file = "location",
    dc_id = 2L,
    offset = 4L,
    stride = 8L,
    chunk_size = 8L,
    request_size = 16L,
    file_size = 100L,
    msg_data = list("chat", 1L)
  )

  expect_equal(iter$total, 100L)
  expect_equal(iter$stride, 8L)
  expect_equal(iter$chunk_size, 8L)
  expect_false(iter$exported)
  expect_identical(iter$sender, "home-sender")
  expect_s3_class(iter$request_data, "GetFileRequest")
  expect_equal(iter$request_data$offset, 4L)
  expect_equal(iter$request_data$limit, 16L)

  returned <- FALSE
  exported_client <- new.env(parent = emptyenv())
  exported_client$session <- new.env(parent = emptyenv())
  exported_client$session$dc_id <- 1L
  exported_client$sender <- "home-sender"
  exported_client$borrow_exported_sender <- function(dc_id) paste0("exported-", dc_id)
  exported_client$return_exported_sender <- function(sender) {
    returned <<- identical(sender, "exported-3")
  }

  exported_iter <- DirectDownloadIter$new(client = exported_client)
  exported_iter$init(
    file = "location",
    dc_id = 3L,
    offset = 0L,
    stride = 8L,
    chunk_size = 8L,
    request_size = 16L,
    file_size = 50L,
    msg_data = NULL
  )

  expect_true(exported_iter$exported)
  expect_identical(exported_iter$sender, "exported-3")
  exported_iter$close()
  expect_true(returned)
  expect_null(exported_iter$sender)
})

test_that("DirectDownloadIter request and chunk loading use fake client responses", {
  skip_on_cran()
  client <- new.env(parent = emptyenv())
  calls <- 0L
  client$call_internal <- function(sender, request) {
    calls <<- calls + 1L
    structure(list(bytes = as.raw(c(0x01, 0x02, 0x03))), class = "upload.File")
  }

  iter <- DirectDownloadIter$new(client = client)
  iter$sender <- NULL
  iter$request_data <- new.env(parent = emptyenv())
  iter$request_data$limit <- 10L
  iter$request_data$offset <- 0L
  iter$stride <- 10L
  iter$buffer <- list()

  expect_equal(iter$request(), as.raw(c(0x01, 0x02, 0x03)))
  expect_false(iter$timed_out)

  iter$load_next_chunk()
  expect_equal(calls, 2L)
  expect_equal(iter$buffer, list(as.raw(c(0x01, 0x02, 0x03))))
  expect_equal(iter$left, 1L)
  expect_equal(iter$request_data$offset, 0L)
})

test_that("GenericDownloadIter chunks offset-aligned data", {
  skip_on_cran()
  client <- new.env(parent = emptyenv())
  calls <- 0L
  client$call_internal <- function(sender, request) {
    calls <<- calls + 1L
    structure(
      list(bytes = if (calls == 1L) as.raw(1:6) else as.raw(7:8)),
      class = "upload.File"
    )
  }

  iter <- GenericDownloadIter$new(client = client)
  iter$sender <- NULL
  iter$request_data <- new.env(parent = emptyenv())
  iter$request_data$limit <- 6L
  iter$request_data$offset <- 2L
  iter$stride <- 3L
  iter$chunk_size <- 3L
  iter$buffer <- list()

  iter$load_next_chunk()

  expect_equal(iter$buffer, list(as.raw(c(0x03, 0x04, 0x05))))
  expect_equal(iter$request_data$offset, 5L)
  expect_equal(iter$last_part, as.raw(0x06))
})
