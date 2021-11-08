#' Evaluate an expression if functions are whitelisted
#'
#' @param expr an expression to evaluate
#' @param whitelist list or character vector of allowed functions
#'
#' @references https://community.rstudio.com/t/secure-way-to-accept-user-input-for-shiny-apps/13554
#' @return The return value from evaluating the expression
safer_eval <- function(expr, whitelist) {
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


#' Interpret input string and evaluate if not-too-spicy
#'
#' @param expr_str a character string containing an expression to evaluate
#' @param max_length hard limit on expression string length
#' @param whitelist list or character vector functions allowed in \code{expr}
#' 
#' @description A utility to interpret calculator input
interpret <- function(expr_str, max_length = 32, whitelist = c("/", "*", "^", "+", "sqrt", "(", ")")) {
  if (length(expr_str) > max_length) {
    stop("Expression too long: ", length(expr_str), " > ", max_length, "characters")
  }
  safer_eval(rlang::parse_expr(expr_str), whitelist)
}
