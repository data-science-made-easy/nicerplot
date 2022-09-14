linez_pre <- function(p) {
  print_debug_info(p)
  if (!any(is_line(p$type))) return(p)

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
  
  # Add arrows
  if (arrows_exist(p)) {
    p <- get_arrow_xy(p)
    if (is_set(p$arrow_list)) for (i in seq_along(p$arrow_list)) {
      ar <- p$arrow_list[[i]]
      if (is_set(p$arrow_col)) {
        if (1 == length(p$arrow_col)) {
          this_col <- p$arrow_col
        } else {
          if (is_set(p$arrow_col[i])) this_col <- p$arrow_col[i] else print_warning(paste("Not enough colours for the arrows. Please (i) leave parameter 'arrow_col' empty, (ii) provide one colour for all arrows, or (iii) set a colour for each individual arrow (in this case, the number of colours you supply should match the number of arrows on your curve)."))
        }
      } else {
        this_col <- p$color[ar$j]
      }
      this_col <- get_col_from_p(p, this_col)
      
      # Draw 'arrow' line segment LEFT side of curve
      x <- c(ar$xl, ar$x_end)
      y <- c(ar$yl, ar$y_end)
      graphics::lines(x, y, col = this_col, lwd = p$line_lwd[j], lty = fix_lty_vector_graphics(this_lty), xpd = T)
      
      # Draw 'arrow' line segment RIGHT side of curve
      x <- c(ar$xr, ar$x_end)
      y <- c(ar$yr, ar$y_end)
      graphics::lines(x, y, col = this_col, lwd = p$line_lwd[j], lty = fix_lty_vector_graphics(this_lty), xpd = T)
    }
  }
  
  p
}
