#' calc_button UI Function
#'
#' @description UI module to render calculator buttons.
#'
#' @param id the ID of the `mod_calc_button_server` to render
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

#' calc_button Server Function
#'
#' @description Server side logic for calculator buttons
#' 
#' @param id the button id
#' @param label the label to render on the button
#' @param callback function to be evaluated on press
#' 
#' @noRd
mod_calc_button_server <- function(id, label, callback) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    callback <- rlang::enquo(callback)
    output$btnUI <- renderUI(actionButton(ns("btn"), label, width = "50px"))
    observeEvent(input$btn, {
      rlang::eval_tidy(callback)
    })
  })
}
