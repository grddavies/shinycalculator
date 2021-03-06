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
          list("C", "lparen", "rparen", "slash"),
          list(7, 8, 9, "mult"),
          list(4, 5, 6, "minus"),
          list(1, 2, 3, "plus"),
          list("v", 0, "point", "eq")
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
      c(0:9),
      ~ mod_calc_button_server(
        id = paste0("b", .),
        label = .,
        callback = updateTextInput(session, "screen", value = paste0(input$screen, .))
      )
    )
    # Buttons that need a different id to what they write to be valid html
    purrr::map2(
      c("plus", "mult", "minus", "rparen", "lparen", "point"),
      c("+", "*", "-", ")", "(", "."),
      ~ mod_calc_button_server(
        id = paste0("b", .x),
        label = .y,
        callback = updateTextInput(session, "screen", value = paste0(input$screen, .y))
      )
    )
    # Divide/slash
    mod_calc_button_server("bslash", "\u00F7", updateTextInput(session, "screen", value = paste0(input$screen, "/")))
    # Sqrt
    mod_calc_button_server("bv", HTML("&radic;"), updateTextInput(session, "screen", value = paste0(input$screen, "sqrt(")))
    # Clear
    mod_calc_button_server("bC", "C", updateTextInput(session, "screen", value = ""))
    # Equals/Evaluate
    mod_calc_button_server("beq", "=", updateTextInput(session, "screen", value = tryCatch(interpret(input$screen), error = function(e) {
      "ERROR"
    })), class = "btn-warning")
  })
}

## To be copied in the UI
# mod_calculator_ui("calculator_ui_1")

## To be copied in the server
# mod_calculator_server("calculator_ui_1")
