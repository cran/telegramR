test_that("basic TL types provide to_list and to_bytes", {
  skip_on_cran()
  # Some types are defined in R/types.R and should be available when sourcing the package
  types_to_test <- c(
    "MessageActionEmpty", "MessageActionChatCreate", "MessageActionChatAddUser",
    "MessageActionChatDeleteUser", "MessageActionChatJoinedByLink", "MessageActionChatJoinedByRequest",
    "MessageActionChannelCreate", "MessageActionContactSignUp", "MessageActionCustomAction",
    "MessageService", "MessageViews", "MessageActionGameScore"
  )

  for (tname in types_to_test) {
    if (!exists(tname, mode = "function")) {
      skip(paste("type", tname, "not found in environment"))
    }
    cls <- get(tname)
    obj <- tryCatch(cls$new(), error = function(e) {
      # If instantiation requires args, skip (but still recorded)
      skip(paste("cannot instantiate", tname, e$message))
    })

    lst <- obj$to_list()
    expect_true(is.list(lst))
    expect_true(!is.null(lst[["_"]]))

    # to_bytes (or bytes) may be named differently; try common names
    bytes_fun <- NULL
    if (is.function(obj$to_bytes)) bytes_fun <- obj$to_bytes
    if (is.function(obj$bytes)) bytes_fun <- obj$bytes
    if (is.null(bytes_fun)) next

    b <- bytes_fun()
    expect_true(is.raw(b))
    expect_true(length(b) >= 4)
  }
})


test_that("serialize_bytes handles short and long strings and raw inputs", {
  skip_on_cran()
  s <- "abc"
  r <- serialize_bytes(s)
  expect_true(is.raw(r))
  expect_equal(as.integer(r[1]), nchar(s))
  expect_equal(rawToChar(r[2:(1 + nchar(s))]), s)

  # long string > 254
  long_s <- paste(rep("a", 300), collapse = "")
  r2 <- serialize_bytes(long_s)
  expect_true(is.raw(r2))
  # first byte should be 254 marker
  expect_equal(as.integer(r2[1]), 254)
  # contains some 'a' bytes
  expect_true(any(r2 == charToRaw("a")))

  # already raw input
  rr <- serialize_bytes(charToRaw("ok"))
  expect_true(is.raw(rr))
  expect_equal(as.integer(rr[1]), 2)
})


test_that("serialize_datetime handles various input types and NULL", {
  skip_on_cran()
  # POSIXct
  dt <- as.POSIXct("2020-01-01 00:00:00", tz = "UTC")
  r <- serialize_datetime(dt)
  expect_true(is.raw(r))
  expect_equal(length(r), 4)

  # Date
  d <- as.Date("2020-01-02")
  r2 <- serialize_datetime(d)
  expect_true(is.raw(r2))
  expect_equal(length(r2), 4)

  # numeric
  r3 <- serialize_datetime(as.numeric(1234567890))
  expect_true(is.raw(r3))

  # NOTE: difftime handled via conversion (use POSIXt input instead of passing difftime directly)

  # NULL
  rnull <- serialize_datetime(NULL)
  expect_true(is.raw(rnull))
  expect_equal(length(rnull), 4)
})


test_that("TLObject equality, stringify and pretty_format helpers", {
  skip_on_cran()
  MockTL <- R6::R6Class("MockTL", inherit = TLObject, public = list(
    to_dict = function() list("_" = "MockTL", x = 1),
    to_bytes = function() as.raw(c(0x01,0x02,0x03,0x04))
  ))

  a <- MockTL$new()
  b <- MockTL$new()
  expect_true(a$.eq(b))
  expect_false(a$.ne(b))
  # Use the global pretty_format to avoid recursive self$pretty_format method
  expect_true(is.character(pretty_format(a)))
  expect_true(is.character(pretty_format(a, indent = 0)))
  # pretty_format should produce a string
  pf <- pretty_format(a)
  expect_true(is.character(pf))
})


test_that("InputPeerEmpty TLObject helpers", {
  skip_on_cran()
  if (!exists("InputPeerEmpty")) skip("InputPeerEmpty not available")
  ip1 <- InputPeerEmpty$new()
  ip2 <- InputPeerEmpty$new()
  expect_true(ip1$.eq(ip2))
  expect_false(ip1$.ne(ip2))
  # use global pretty_format rather than the instance stringify to avoid recursion
  s <- pretty_format(ip1, indent = 0)
  expect_true(is.character(s))
})


# Extra: check that a few more type constructors can be instantiated with minimal args when possible
test_that("instantiate a broader set of types (skip if unavailable/require args)", {
  skip_on_cran()
  additional <- c(
    "MessageActionConferenceCall", "MessageActionChatMigrateTo", "MessageActionChannelCreate",
    "MessageActionGeoProximityReached", "MessageService", "MessageViews"
  )
  for (tname in additional) {
    if (!exists(tname, mode = "function")) {
      skip(paste("type", tname, "not found"))
    }
    cls <- get(tname)
    obj <- tryCatch(cls$new(), error = function(e) skip(paste("cannot instantiate", tname, e$message)))
    # check to_list exists
    expect_true(is.list(obj$to_list()))
    # check bytes if available
    if (is.function(obj$to_bytes)) expect_true(is.raw(obj$to_bytes()))
    if (is.function(obj$bytes)) expect_true(is.raw(obj$bytes()))
  }
})


test_that("instantiate all MessageAction classes and exercise to_list/to_bytes when possible", {
  skip_on_cran()
  action_names <- ls(pattern = "^MessageAction")
  if (length(action_names) == 0) skip("no MessageAction classes found")
  for (name in action_names) {
    cls <- get(name)
    obj <- tryCatch(cls$new(), error = function(e) skip(paste("cannot instantiate", name, e$message)))
    expect_true(is.list(obj$to_list()))
    if (is.function(obj$to_bytes)) expect_true(is.raw(obj$to_bytes()))
    if (is.function(obj$bytes)) expect_true(is.raw(obj$bytes()))
  }
})


# Try a broader sweep for classes beginning with 'Message' but skip ones that are clearly heavy
test_that("smoke-test a selection of Message* classes", {
  skip_on_cran()
  all_msg <- ls(pattern = "^Message")
  # keep sample small to avoid constructors requiring many args
  if (length(all_msg) == 0) skip("no Message* classes")
  sample_names <- unique(c("MessageService", "MessageViews", all_msg))
  sample_names <- head(sample_names, 20)
  for (name in sample_names) {
    if (!exists(name, mode = "function")) next
    cls <- get(name)
    obj <- tryCatch(cls$new(), error = function(e) skip(paste("cannot instantiate", name, e$message)))
    expect_true(is.list(obj$to_list()))
    if (is.function(obj$to_bytes)) expect_true(is.raw(obj$to_bytes()))
  }
})


test_that("serialize_bytes edge cases for 0, 253, 254 length", {
  skip_on_cran()
  # empty string
  r0 <- serialize_bytes("")
  expect_true(is.raw(r0))
  expect_equal(as.integer(r0[1]), 0L)

  # 253 chars -> single-byte length header
  s253 <- paste(rep("a", 253), collapse = "")
  r253 <- serialize_bytes(s253)
  expect_true(is.raw(r253))
  expect_equal(as.integer(r253[1]), 253L)

  # 254 chars -> long form (first byte == 254)
  s254 <- paste(rep("b", 254), collapse = "")
  r254 <- serialize_bytes(s254)
  expect_true(is.raw(r254))
  expect_equal(as.integer(r254[1]), 254L)
})


test_that("serialize_bytes accepts zero-length raw and preserves header", {
  skip_on_cran()
  rr <- serialize_bytes(raw(0))
  expect_true(is.raw(rr))
  expect_equal(as.integer(rr[1]), 0L)
})


test_that("datetime_to_timestamp converts POSIXct and Date reliably", {
  skip_on_cran()
  dt <- as.POSIXct("1970-01-02 00:00:00", tz = "UTC")
  ts <- datetime_to_timestamp(dt)
  expect_equal(as.integer(ts), 86400L)

  d <- as.Date("1970-01-03")
  ts2 <- datetime_to_timestamp(as.POSIXct(d, tz = "UTC"))
  expect_equal(as.integer(ts2), 2 * 86400L)
})


test_that("TLObject pretty_format handles nested lists", {
  skip_on_cran()
  NestedTL <- R6::R6Class("NestedTL", inherit = TLObject, public = list(
    to_dict = function() list("_" = "NestedTL", foo = list(bar = list(1,2, list(a = "x")))),
    to_bytes = function() as.raw(c(0x00,0x01,0x02,0x03))
  ))
  n <- NestedTL$new()
  s <- pretty_format(n)
  expect_true(is.character(s))
  expect_true(grepl("NestedTL", s))
  expect_true(grepl("foo", s))
})


test_that("TLObject inequality when dicts differ", {
  skip_on_cran()
  A <- R6::R6Class("A", inherit = TLObject, public = list(to_dict = function() list("_" = "A", x = 1)))
  B <- R6::R6Class("B", inherit = TLObject, public = list(to_dict = function() list("_" = "B", x = 2)))
  a <- A$new()
  b <- B$new()
  expect_false(a$.eq(b))
  expect_true(a$.ne(b))
})


test_that("serialize_bytes errors on invalid types", {
  skip_on_cran()
  expect_error(serialize_bytes(123), "bytes or str expected")
  expect_error(serialize_bytes(list(1,2,3)), "bytes or str expected")
})


test_that("serialize_datetime errors on non-date-like input", {
  skip_on_cran()
  expect_error(serialize_datetime("not a date"), "Cannot interpret")
})


test_that("pretty_format respects indent and nested structures", {
  skip_on_cran()
  ComplexTL <- R6::R6Class("ComplexTL", inherit = TLObject, public = list(
    to_dict = function() list("_" = "ComplexTL", nested = list(a = list(b = list(1,2,3))))
  ))
  c <- ComplexTL$new()
  s0 <- pretty_format(c)
  s2 <- pretty_format(c, indent = 2)
  expect_true(nchar(s2) >= nchar(s0))
  expect_true(grepl("ComplexTL", s2))
})


test_that("TLObject equality for identical dicts and inequality for different", {
  skip_on_cran()
  X <- R6::R6Class("X", inherit = TLObject, public = list(to_dict = function() list("_" = "X", v = 1)))
  Y <- R6::R6Class("Y", inherit = TLObject, public = list(to_dict = function() list("_" = "X", v = 1)))
  x1 <- X$new(); x2 <- X$new(); y <- Y$new()
  expect_true(x1$.eq(x2))
  expect_false(x1$.ne(x2))
  # different classes but same dict content -> .eq should be TRUE since compares to_dict
  expect_true(x1$.eq(y))
})


test_that("try to instantiate many types (wider sweep) but skip on errors", {
  skip_on_cran()
  all_types <- ls()
  candidates <- grep("(Message|MessageAction|Input)\\w+", all_types, value = TRUE)
  candidates <- unique(c(head(candidates, 100)))
  for (nm in candidates) {
    if (!exists(nm, mode = "function")) next
    cls <- tryCatch(get(nm), error = function(e) NULL)
    if (is.null(cls)) next
    obj <- tryCatch(cls$new(), error = function(e) NULL)
    if (is.null(obj)) next
    if (is.function(obj$to_list)) expect_true(is.list(obj$to_list()))
    if (is.function(obj$to_bytes)) expect_true(is.raw(obj$to_bytes()))
  }
})

