plot_james_internal <- function(p) {
  print_debug_info(p)

  # Determine which plot pipeline to run
  plot_order <- if (is_map(p)) p$plot_order_geo else if (is_world_map(p)) p$plot_order_world else p$plot_order

  # Plot components in given order
  for (type in plot_order) {
    function_call <- paste0(type, "(p)")
    if (exists(type)) if (1 == length(methods::formalArgs(type))) {
      p <- eval(parse(text = function_call))
      if (!is.james(p)) stop(error_msg(paste0("The return value of your plot function '", function_call, "' should be of class 'james' but is of class '", class(p), "'.")))
    } else {
      print_warning(paste0("Plot function '", function_call, "' does not exist yet!"))
    }
  }
  
  return(p)
}