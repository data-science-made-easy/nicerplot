replicate_params <- function(p) {
  print_debug_info(p)

  # Fill 'TYPE' with line if > 1 but < all are specified
  if (1 < length(p$type) & length(p$type) < p$n_series) p[[TYPE]] <- c(p[[TYPE]], rep(LINE, p$n_series - length(p$type))) # p$type terugzetten naar p[[TYPE]]

  # # Make sure we have enough colors
  # if (length(p$col_default) <  p$n_series) p$col_default <- rep(p$col_default, 1 + p$n_series %/% length(p$col_default))[1:p$n_series]
    
  # Replicate other parameters
  for (param in get_param_replicate()) {
    if (!is_set(p[[param]])) p[[param]] <- get_parsed(p, param)#get_param(param)

    n_lines <- length(which(is_line(p$type)))
    n_rep   <- if ("line_lty" == param) n_lines else p$n_series# p$n_series_without_whiskers
    if (1 == length(get_parsed(p, param))) p[[param]] <- rep(p[[param]], n_rep)
    
    # Ugly exception
    ugly_exception <- "line_lty" == param & 0 == length(p[[param]])
    
    # CHECK
    use_this_n_series <- if (TYPE == param | Y_AXIS == param) p$n_series else n_rep
    if (use_this_n_series != length(get_parsed(p, param)) & !ugly_exception) error_msg("Parameter '", param, "' has ", length(get_parsed(p, param)), " values, while you have ", use_this_n_series, " time series. Parameter '", param, "' should have ONE value OR ", use_this_n_series, " values!")
  }
  
  p
}