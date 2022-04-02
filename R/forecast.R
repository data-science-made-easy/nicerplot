forecast_pre <- function(p) {
  print_debug_info(p)

  # Indices for forecast
  if (is_set(p$forecast_x)) {
    p$index_lst <- list(observed = which(p$x <= p$forecast_x), forecast = which(p$forecast_x <= p$x))

    # Add previous point to forecast if forecast starts in between two x-values
    obs_tail <- tail(p$index_lst[["observed"]], 1)
    fct_head <- head(p$index_lst[["forecast"]], 1)
    if (obs_tail != fct_head) {
      p$index_lst[["forecast"]] <- c(obs_tail, p$index_lst[["forecast"]])
    }
  } else {
    p$index_lst <- list(observed = seq_along(p$x))
  }
  
  return(p)
}

forecast_bg <- function(p) {
  print_debug_info(p)  
  if (!is_set(p$forecast_x) | !is_set(p$forecast_bg_col)) return(p)
  if (!p$forecast_bg_show) return(p)
  
  # p <- swap_xy(p)
  xl <- p$forecast_x
  xr <- p$x_lim[2]
  yl <- p$y_l_lim[1]
  yh <- p$y_l_lim[2]
    
  if (p$turn) {
    graphics::rect(yl, xr, yh, xl, col = p$forecast_bg_col, border = NA)
  } else {
    graphics::rect(xl, yl, xr, yh, col = p$forecast_bg_col, border = NA)
  }
  
  return(p)
}

forecast <- function(p) {
  print_debug_info(p)
  if (!is_set(p$forecast_x) | !p$forecast_text_show) return(p)

  p_return <- p # Don't pass the modified p (e.g. with swap) on to next function (bit of hack)
  p <- swap_xy(p)
    
  # abline(v = if (p$turn) NULL else p$x_forecast, h = if (p$turn) p$x_forecast else NULL, lty = 1, col = p$forecast_bg_col)

  # determine x
  x <- mean(c(p$forecast_x, if (p$turn) p$y_lim[1] else p$x_lim[2]))
  str_dim <- graphics::strwidth(p$forecast_text, cex = p$forecast_font_size, font = hack_font(p, p$forecast_font_style), units = "user", family = p$font)

  if (p$turn) str_dim <- str_dim / diff(p$x_lim) * abs(diff(p$y_lim))
  if (p$turn) {
    x_exceed <- x + str_dim / 2 - p$y_lim[1]
  } else {
    x_exceed <- x + str_dim / 2 - p$x_lim[2]
  }
  if (0 < x_exceed) x <- x - x_exceed
  
  y_high <- tail(p$y_at, 1)
  y_low  <- p$y_at[1]
    
  # determine x, y
  if (p$turn) {
    tmp <- x # max(x, p$x_lim[2])
    x   <- tail(p$x_at, 1)
    y   <- tmp
  } else {
    x <- max(x, p$x_lim[1])
    y <- y_high
  } 

  graphics::text(x = x, y = y, p$forecast_text, xpd = TRUE, adj= c(0.5, p$forecast_below_gridline), cex = p$forecast_font_size, font = hack_font(p, p$forecast_font_style), col = get_col_from_p(p, p$forecast_text_col), srt = if (p$turn) 270 else 0, family = p$font)

  # lines(x = c(p$forecast_x, p$forecast_x), y = c(y_high + 0.02 * (y_high - y_low), y_high), col = get_col_from_p(p, "sun"), xpd = T, lwd = 2)
  #
  # lines(x = c(p$forecast_x, p$forecast_x + .05 * diff(p$x_lim)), y = rep(y_high, 2), lwd = 2, col = get_col_from_p(p, "sun"), xpd = T)
  #
  #
  #
  # lines(x = c(p$forecast_x, p$forecast_x), y = c(y_low - 0.02 * (y_high - y_low), y_low), col = get_col_from_p(p, "sun"), xpd = T, lwd = 2)
  #
  # lines(x = c(p$forecast_x, p$forecast_x + .05 * diff(p$x_lim)), y = rep(y_low, 2), lwd = 2, col = get_col_from_p(p, "sun"), xpd = T)
  
  p_return
}























