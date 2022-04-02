user_line <- function(p) {
  print_debug_info(p)


  if (is_set(p$hline_bold)) {
    graphics::abline(h = if (p$turn) NULL else p$hline_bold, v = if (p$turn) p$hline_bold else NULL, lwd = p$hline_bold_lwd, col = get_col_from_p(p, p$hline_bold_col))
  }

  val <- NULL
  if (is_set(p$vline_dash_date)) {
    if (is_set(p$xlsx)) {
      input_date <- suppressWarnings(as.numeric(p$vline_dash_date))
      if (any(is.na(input_date))) input_date <- p$vline_dash_date
      val <- lubridate::decimal_date(as.Date(input_date, origin = "1899-12-30")) # strange number from Excel is date
    } else {
      val <- lubridate::decimal_date(as.Date(p$vline_dash_date)) # we deal with really a date
    }
  }
  
  if (is_set(p$vline_dash)) {
    val <- c(val, p$vline_dash)
  }
  
  if (is_set(val)) {
    graphics::abline(h = if (p$turn) val else NULL, v = if (p$turn) NULL else val, lwd = p$vline_dash_lwd, col = get_col_from_p(p, p$vline_dash_col), lty = p$vline_dash_lty)
  }  
  
  # TODO fix for dates
  if (is_set(p$hline_dash)) {
    graphics::abline(h = if (p$turn) NULL else p$hline_dash, v = if (p$turn) p$hline_dash else NULL, lwd = p$hline_dash_lwd, col = get_col_from_p(p, p$hline_dash_col), lty = p$hline_dash_lty)
  }
  
  p
}