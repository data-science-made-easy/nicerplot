preprocess_first <- function(p) {
  print_debug_info(p)

  # Update time series names
  if (!is_set(p$name)) p$name <- colnames(p$y)

  # Set total number of series
  p$n_series <- ncol(p$y)
  p$n_series_without_whiskers <- p$n_series - length(which(is_whisker(p$type)))

  # Is y_at set by user?
  p$y_at_by_user  <- is_set(p$y_at)

  # Are x_lim and y_lim user set?
  p$x_lim_by_user <- is_set(p$x_lim)
  p$y_lim_by_user <- is_set(p$y_lim)

  p$y_at_by_user    <- is_set(p$y_at)

  p$y_l_lim         <- p$y_lim
  p$y_l_lim_by_user <- is_set(p$y_l_lim)
  p$y_r_lim_by_user <- is_set(p$y_r_lim)
  
  # Is line_lty user set?
  p$line_lty_by_user <- is_set(p$line_lty)
  
  # Sort lims
  for (param in c("x_lim", "y_l_lim", "y_r_lim")) {
    if (is_set(p[[param]])) p[[param]] <- sort(p[[param]])
  }
  
  
  return(p)
}