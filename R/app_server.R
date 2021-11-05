#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Buttons that write what they say on the tin
  purrr::map(
    c(0:9, "*", "+", "-", ")", "("),
    ~ mod_calc_button_server(
      id = paste0("b", .),
      buttonType = .,
      callback = updateTextInput(session, "screen", value = paste0(input$screen, .))
    )
  )
  # Divide button
  mod_calc_button_server("b/", "÷", updateTextInput(session, "screen", value = paste0(input$screen, "/")))
  # Equals/Evaluate
  mod_calc_button_server("b=", "=", updateTextInput(session, "screen", value = (interpret(input$screen))))
}
