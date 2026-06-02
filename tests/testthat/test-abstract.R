test_that("Session class methods work as expected", {
  skip_on_cran()
  # Test initialization
  session <- Session$new()
  expect_true(!is.null(session), "Session object should be created successfully")

  # Test no-op close method
  expect_null(session$close())

  # Test clone passthrough when explicit instance supplied
  target <- list(name = "target")
  expect_identical(session$.clone(target), target)

  # Test set_dc method
  expect_error(session$set_dc(1, "127.0.0.1", 80), "Not implemented")

  # Test get_update_state method
  expect_error(session$get_update_state(123), "Not implemented")

  # Test set_update_state method
  expect_error(session$set_update_state(123, "state"), "Not implemented")

  # Test get_update_states method
  expect_error(session$get_update_states(), "Not implemented")

  # Test save method
  expect_error(session$save(), "Not implemented")

  # Test delete method
  expect_error(session$delete(), "Not implemented")

  # Test process_entities method
  expect_error(session$process_entities("TLObject"), "Not implemented")

  # Test get_input_entity method
  expect_error(session$get_input_entity("key"), "Not implemented")

  # Test cache_file method
  expect_error(session$cache_file("md5", 1024, "instance"), "Not implemented")

  # Test get_file method
  expect_error(session$get_file("md5", 1024, "cls"), "Not implemented")
})
