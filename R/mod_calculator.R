#' calculator UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_calculator_ui <- function(id) {
  ns <- NS(id)
  tagList(
    wellPanel(
      class = "calc-outer",
      textInput(ns("screen"), NULL, width = "200px"),
      # Buttonpad Layout
      purrr::map(
        list(
          list("C", "(", ")", "/"),
          list(7, 8, 9, "*"),
          list(4, 5, 6, "-"),
          list(1, 2, 3, "+"),
          list("v", 0, ".", "=")
        ),
        ~ {
          div(
            class = "calc-row",
            purrr::map(., ~ mod_calc_button_ui(ns(paste0("b", .))))
          )
        }
      )
    )
  )
}

#' calculator Server Functions
#'
#' @noRd
mod_calculator_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    # Buttons that write what they say on the tin
    purrr::map(
      c(0:9, "*", "+", "-", ")", "(", "."),
      ~ mod_calc_button_server(
        id = paste0("b", .),
        label = .,
        callback = updateTextInput(session, "screen", value = paste0(input$screen, .))
      )
    )
    # Divide button
    mod_calc_button_server("b/", "\u00F7", updateTextInput(session, "screen", value = paste0(input$screen, "/")))
    mod_calc_button_server("bv", HTML("&radic;"), updateTextInput(session, "screen", value = paste0(input$screen, "sqrt(")))
    # Equals/Evaluate
    mod_calc_button_server("b=", "=", updateTextInput(session, "screen", value = tryCatch(interpret(input$screen), error = function(e) {
      "ERROR"
    })))
    # Clear
    mod_calc_button_server("bC", "C", updateTextInput(session, "screen", value = ""))
  })
}

## To be copied in the UI
# mod_calculator_ui("calculator_ui_1")

## To be copied in the server
# mod_calculator_server("calculator_ui_1")
