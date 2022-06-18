# numeric_range <- function(vec) range(as.numeric(vec), na.rm = T)
linez_pre <- function(p) {
  print_debug_info(p)
  if (!any(is_line(p$type))) return(p)

  # Update y_lims
  for (j in 1:ncol(p$y)) if (is_line(p$type[j])) {
    if (!p$y_lim_by_user & is_yl(p, j)) p <- update_y_lims(p, j, p$y[, j])
    if (is_yr(p, j))                    p <- update_y_lims(p, j, p$y[, j])  # TODO NOT if user sets yr
  }

  # Assign line_lty to right position
  if (is_set(p$line_lty)) {
    line_lty <- rep(NA, ncol(p$y))
    line_lty[which(is_line(p$type))] <- p$line_lty
    p$line_lty <- line_lty
  }

  p
}

linez <- function(p) {
  print_debug_info(p)
  if (!any(is_line(p$type))) return(p)
  
  for (index_obs_fc in seq_along(p$index_lst)) {
    index <- p$index_lst[[index_obs_fc]]
    for (j in 1:ncol(p$y)) if (is_line(p$type[j])) {
      x <- if (p$turn) p$y[index, j] else p$x[index]
      y <- if (p$turn) p$x[index]    else p$y[index, j]
    
      if (1 != p$line_lty[j]) {
        this_lty <- p$line_lty[j]
      } else {
        this_lty <- p$line_obs_fc_lty[index_obs_fc]
      }
      
      graphics::lines(x, y, col = p$color[j], lwd = p$line_lwd[j], lty = fix_lty_vector_graphics(this_lty), xpd = T)
      
      # Add symbols
      if (0 != p$line_symbol[j]) {
        # Set col
        if (is_set(p$line_symbol_col)) {
          if (is_set(p$line_symbol_col[j])) {
            this_col <- p$line_symbol_col[j]
          } else {
            this_col <- p$color[j]
          }
        } else {
          this_col <- p$color[j]
        }
        this_col <- get_col_from_p(p, this_col)

        graphics::points(x, y, pch = p$line_symbol[j], col = this_col, cex = p$line_symbol_size[j], xpd = TRUE)
      }
    }
  }
  
  p
}