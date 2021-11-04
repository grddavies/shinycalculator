#' calc_button UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_calc_button_ui <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("btnUI"))
  )
}

#' calc_button Server Functions
#'
#' @noRd
mod_calc_button_server <- function(id, buttonType, callback) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    output$btnUI <- renderUI(actionButton(ns("btn"), buttonType))
    observeEvent(input$btn, {
      eval.parent(callback)
    })
  })
}
