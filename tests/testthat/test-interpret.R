test_that("We can interpret syntactic literals", {
  expect_equal(interpret("2"), 2)
})

  
test_that("We can interpret simple mathematical expressions using default whitelist", {
  expect_equal(interpret("1 + 1"), 2)
  expect_equal(interpret("4 - 2"), 2)
  expect_equal(interpret("1 * 2"), 2)
  expect_equal(interpret("4 / 2"), 2)
})


test_that("We dont try to evaluate multiple expressions", {
  expect_error(interpret("1+1; 2+2"), "More than one expression parsed")
})


test_that("We can add custom functions to the whitelist", {
  expect_equal(
    interpret("intersect(c(1, 5), c(3, 5))", whitelist = c("c", "intersect")),
    5
  )
  expect_equal(
    interpret("setdiff(c(1, 5), c(3, 5))", whitelist = c("c", "setdiff")),
    1
  )
})

test_that("We can't evaluate dangerous code", {
  expect_error(
    interpret('system("mkdir evildir")'),
    "Disallowed function: system"
  )
})

test_that("We can't evaluate expressions exceeding `max_length`", {
  expect_error(
    interpret("1 + 1 + 2 + 3 + 5 + 8 + 13", max_length = 10),
    "Expression too long:"
  )
})
