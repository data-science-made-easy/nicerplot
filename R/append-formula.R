append_formula <- function(p) {
  print_debug_info(p)

  if (is_set(p$formula)) {
    if (is_set(p$data)) {
      p$data <- cbind(p$data, eval(parse(text = p$formula)))
    } else {
      p$data <- eval(parse(text = p$formula))
      if (is_set(rownames(p$data))) p$data <- cbind(as.numeric(rownames(p$data)), p$data)
    }
    colnames(p$data)[ncol(p$data)] <- p$formula_name
  }
  
  p
}
