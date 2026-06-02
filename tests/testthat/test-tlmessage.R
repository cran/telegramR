test_that("TLMessage initializes correctly", {
  msg <- TLMessage$new(msg_id = 12345, seq_no = 1, obj = "example_object")

  expect_equal(msg$msg_id, 12345)
  expect_equal(msg$seq_no, 1)
  expect_equal(msg$obj, "example_object")
})

test_that("TLMessage to_dict method works correctly", {
  msg <- TLMessage$new(msg_id = 12345, seq_no = 1, obj = "example_object")
  dict <- msg$to_dict()

  expect_equal(dict$`_`, "TLMessage")
  expect_equal(dict$msg_id, 12345)
  expect_equal(dict$seq_no, 1)
  expect_equal(dict$obj, "example_object")
})

test_that("TLMessage handles different object types", {
  msg <- TLMessage$new(msg_id = 67890, seq_no = 2, obj = list(a = 1, b = 2))

  expect_equal(msg$obj, list(a = 1, b = 2))
  dict <- msg$to_dict()
  expect_equal(dict$obj, list(a = 1, b = 2))
})
