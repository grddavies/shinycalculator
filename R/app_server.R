#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
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
  mod_calc_button_server("b=", "=", updateTextInput(session, "screen", value = tryCatch(interpret(input$screen), error = function(e){"ERROR"})))
  # Clear
  mod_calc_button_server("bC", "C", updateTextInput(session, "screen", value = ""))
}
