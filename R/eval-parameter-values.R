eval_parameter_values <- function(p) {
  print_debug_info(p)

  current_var_names <- names(p)
  index <- grep("_r$", current_var_names)
  
  # Derive values for each x_r and assign to x
  var_list <- list()
  if (length(index)) for (i in index) {
    var_name <- stringr::str_sub(string = current_var_names[i], end = -3)
    
    # check
    if (STYLE != var_name & is.element(var_name, current_var_names) & is_set(p[[var_name]]) & is_set(p[[current_var_names[i]]])) error_msg("Variable occurs twice: ", var_name, " and ", var_name, "_r. Please remove one.")

    # Determine value
    value <- eval(parse(text = p[[current_var_names[i]]]))
    
    is_list <- param_is_list_type(var_name)
    if (!is_list & 1 < length(value)) error_msg("Parameter '", var_name, "_r' leads to > 1 values, while parameter '", var_name, "' is not of type list.")
    
    # If set, add value to p
    if (is_set(value)) {
      # print what you do
      print_progress(p, "[", p$id, "]", " Assignment: p$", var_name, " <- ", if (is_list) paste0(value, collapse = paste0(get_param_list_sep(var_name), " ")) else value)
      # do it
      p[[var_name]] <- value
    }
  }
  
  # Remove the *_r vars
  if (length(index)) {
    p <- p[-index]
    attr(p, "class") <- "james"
  }

  return(p)
}