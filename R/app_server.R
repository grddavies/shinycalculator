#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  shinyjs::disable("screen")
  purrr::map(c(0:9, "*", "+"), ~ mod_calc_button_server(paste0("b", .), ., updateTextInput(session, "screen", value = paste0(input$screen, .))))
  mod_calc_button_server("b=", "=", updateTextInput(session, "screen", value = (interpret(input$screen))))
}
