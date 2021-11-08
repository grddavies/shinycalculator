#' Interpret input string and evaluate if not-too-spicy
#' 
#' @description A utility to interpret calculator input
#'
#' @param expr_str a character string containing an expression to evaluate
#' @param max_length hard limit on expression string length
#' @param whitelist list or character vector functions allowed in \code{expr_str}
#' 
#' @return The return value after safely evaluating the expression
#' 
#' @references https://community.rstudio.com/t/secure-way-to-accept-user-input-for-shiny-apps/13554
interpret <- function(expr_str, max_length = 32, whitelist = c("/", "*", "^", "+", "-", "sqrt", "(", ")")) {
  safer_eval <- function(expr) {
    if (rlang::is_call(expr)) {
      fn_name <- rlang::call_name(expr)
      if (!fn_name %in% whitelist) stop("Disallowed function: ", fn_name)
      do.call(get(fn_name, baseenv()), Map(safer_eval, rlang::call_args(expr)))
    } else if (rlang::is_syntactic_literal(expr)) {
      expr
    } else {
      stop("Unknown expression: ", expr)
    }
  }
  expr <- rlang::parse_expr(expr_str)
  if (nchar(expr_str) > max_length) {
    stop("Expression too long: ", nchar(expr_str), " > ", max_length, "characters")
  }
  safer_eval(expr)
}
