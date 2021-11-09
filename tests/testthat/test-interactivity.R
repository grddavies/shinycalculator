# FIXME: Cant run module tests using:
# app <- shinytest::ShinyDriver$new(shinyApp(mod_calculator_ui, mod_calculator_server))
# see https://github.com/rstudio/shinytest/issues/421

# Initaite headless browser session
app <- shinytest::ShinyDriver$new("../..")

test_that("We can add to the screen with single button presses", {
  app$click("calculator-b1-btn")
  app$click("calculator-bplus-btn")
  app$click("calculator-b2-btn")
  expect_equal(app$getValue("calculator-screen"), "1+2")
})

test_that("We can add to the screen with repeat button presses", {
  app$setInputs(`calculator-screen` = "")
  app$click("calculator-b3-btn")
  app$click("calculator-bplus-btn")
  app$click("calculator-b3-btn")
  expect_equal(app$getValue("calculator-screen"), "3+3")
})

test_that("All screen-appending buttons work", {
  app$setInputs(`calculator-screen` = "")
  purrr::walk(
    c(1:9, "plus", "minus", "mult", "point", "lparen", "rparen", "v", "slash"),
    ~app$click(paste0("calculator-b", . ,"-btn"))
  )
  expect_equal(
    app$getValue("calculator-screen"), 
    "123456789+-*.()sqrt(/"
  )
})

test_that("We can evaluate expressions on the screen", {
  app$setInputs(`calculator-screen` = "1+11")
  app$click("calculator-beq-btn")
  expect_equal(app$getValue("calculator-screen"), "12")
})

test_that("We can clear the screen with the `C` button", {
  app$setInputs(`calculator-screen` = "1+1+1+1+1")
  app$click("calculator-bC-btn")
  expect_equal(app$getValue("calculator-screen"), "")
})

test_that("We show `ERROR` on screen with invalid input", {
  app$setInputs(`calculator-screen` = "foo")
  app$click("calculator-beq-btn")
  expect_equal(app$getValue("calculator-screen"), "ERROR")
})
