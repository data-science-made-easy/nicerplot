start_preprocess_pipeline <- function(p) {
  print_debug_info(p)
  stopifnot(is.james(p))
  print_progress(p, "Starting preprocessing pipeline for figure [", tools::file_path_sans_ext(basename(p$pdf_file)), ".*]...")
  
  # Inject font
  # if ("rijk" == p$font) grDevices::quartzFonts(rijk = c("RijksoverheidSansText-Regular", "RijksoverheidSansText-Bold", "RijksoverheidSansText-Italic", "RijksoverheidSansText-BoldItalic"))

  # Determine which preprocessing pipeline to run
  preprocess_order <- if (is_map(p)) p$preprocess_order_geo else if (is_world_map(p)) p$preprocess_order_world else p$preprocess_order
  if (is_map(p)) print_info(p, "Starting 'geo' pipeline...") else if (is_world_map(p)) print_info(p, "Starting 'world-map' pipeline") else print_info(p, "Starting default pipeline...")
  
  # Prepare plot
  for (function_name in preprocess_order) {
    function_call <- paste0(function_name, "(p)")
    if (exists(function_name) && 1 == length(methods::formalArgs(function_name))) {
      p <- eval(parse(text = function_call))
      if (!is.james(p)) stop(error_msg(paste0("The return value of your preprocessing function '", function_call, "' should be of class 'james' but is of class '", class(p), "'.")))
    } else {
      print_warning(paste0("Preprocessing function '", function_call, "' does not exist yet!"))
    }
  }
  
  p
}