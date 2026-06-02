test_that("Connection parse_proxy maps protocols and rejects unknown", {
  skip_on_cran()
  conn <- Connection$new("127.0.0.1", 80, 1)
  parsed <- conn$.__enclos_env__$private$._parse_proxy("socks5", "127.0.0.1", 9050)
  expect_equal(parsed$protocol, 2)
  expect_equal(parsed$addr, "127.0.0.1")
  expect_equal(parsed$port, 9050)

  expect_error(
    conn$.__enclos_env__$private$._parse_proxy("badproto", "127.0.0.1", 1),
    "Unknown proxy protocol type"
  )
})

test_that("Connection connects in test mode and reports state", {
  skip_on_cran()
  old <- options()
  on.exit(options(old), add = TRUE)
  options(telegramR.test_mode = TRUE, telegramR.skip_background = TRUE)

  conn <- Connection$new("127.0.0.1", 80, 1)
  res <- future::value(conn$connect())
  expect_true(isTRUE(res))
  expect_true(conn$is_connected())
  expect_match(conn$to_string(), "127\\.0\\.0\\.1:80")

  # send should work when connected
  expect_silent(future::value(conn$send(as.raw(c(1, 2, 3)))))

  # disconnect and ensure recv errors
  future::value(conn$disconnect())
  expect_error(conn$recv(), "Not connected")
})

test_that("Reader readexactly reads bytes from socket", {
  skip_on_cran()
  con <- rawConnection(as.raw(1:5), open = "r+b")
  on.exit(close(con), add = TRUE)

  reader <- Reader$new()
  reader$socket <- con
  out <- future::value(reader$readexactly(5))
  expect_equal(out, as.raw(1:5))
})

test_that("Writer writes bytes to socket", {
  skip_on_cran()
  con <- rawConnection(raw(), open = "r+b")
  on.exit(close(con), add = TRUE)

  writer <- Writer$new()
  writer$socket <- con
  writer$write(as.raw(c(10, 20, 30)))
  seek(con, where = 0)
  out <- readBin(con, what = "raw", n = 3)
  expect_equal(out, as.raw(c(10, 20, 30)))
})

test_that("PacketCodec encodes and decodes a packet", {
  skip_on_cran()
  skip_future_on_rdevel()
  pc <- PacketCodec$new(list())
  payload <- list(a = 1, b = "x")
  bytes <- pc$encode_packet(payload)

  # Fake reader that returns length then payload
  idx <- 0L
  reader <- list(
    readexactly = function(n) {
      idx <<- idx + 1L
      if (idx == 1L) {
        return(promises::promise_resolve(bytes[1:4]))
      }
      return(promises::promise_resolve(bytes[5:length(bytes)]))
    }
  )

  out <- future::value(pc$read_packet(reader))
  expect_equal(out, payload)
})

test_that("async_open_connection works with provided socket", {
  skip_on_cran()
  con <- rawConnection(raw(), open = "r+b")
  on.exit(close(con), add = TRUE)

  res <- future::value(async_open_connection(sock = con))
  expect_true(is.list(res))
  expect_true(inherits(res$reader, "Reader"))
  expect_true(inherits(res$writer, "Writer"))
})
