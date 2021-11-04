


#' Interpret input and evaluate if not-too-spicy
#'
#' @description A utility to interpret calculator input
#'
#' @return The return value from evaluating the expression
#'
#' @noRd
interpret <- function(expr_str, max_length = 32, whitelist = c("/", "*", "^", "+", "sqrt")) {
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
  stopifnot(length(expr_str) < max_length)
  safer_eval(rlang::parse_expr(expr_str))
}
