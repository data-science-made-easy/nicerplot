# TODO Fix get_col_from_p for all colors
is_box  <- function(type) is.element(type, BOX)

box_pre <- function(p) {
  print_debug_info(p)

  index_box <- which(is_box(p$type))
  if (!length(index_box)) return(p)
    
  # Determine the quantiles
  quantile_matrix <- NULL
  for (j in index_box) {
    new_quantiles     <- stats::quantile(p$y[, j], p$box_quantiles, na.rm = TRUE)
    quantile_matrix <- rbind(quantile_matrix, new_quantiles)
    
    # Update y_lim
    if (!p$y_lim_by_user & is_yl(p, j)) p <- update_y_lims(p, j, new_quantiles)
    if (is_yr(p, j))                    p <- update_y_lims(p, j, new_quantiles) # TODO NOT if user sets yr
  }

  # Determine where to show boxes
  group_x <- NULL
  if (!is_set(p$box_x)) { # box_x are the x-positions for boxes to show up
    if (is_set(p$group)) { # TODO this is not really prepared to deal with non-box type of series
      this_x  <- 1
      i       <- 1
      while (i <= nrow(quantile_matrix)) {
        if (is_no(duplicated(p$group)[i])) { # place group header here
          group_x <- c(group_x, this_x)
          if (is_set(p$name[i])) this_x <- 1 + this_x # Don't add newline if there is no series name (usually there is only one item in such cases)
        } 
        # just a box
        p$box_x[i] <- this_x
        this_x     <- 1 + this_x
        i          <- 1 + i
        if (is_no(duplicated(p$group)[i])) this_x <- this_x + p$group_spacing
      }
      p$x_at  <- p$box_x
      p$x_lab <- colnames(p$y)[which(is_box(p$type))]
    } else {
      p$box_x <- if (is_set(p$x)) p$x[1:nrow(quantile_matrix)] else 1:nrow(quantile_matrix)
    }
  }
   
  factor          <- if (1 == length(p$x)) 1 else min(diff(p$x))
  p$box_width     <- (1 - p$box_gap_fraction) * factor
  p$box_gap_width <- p$box_gap_fraction * factor
  
  # Update x_lim
  if (!p$x_lim_by_user) {
    if (1 == length(p$box_x)) {
      p$x_lim <- range(c(p$x_lim, c(0, 2)), na.rm = T)
    } else {
      p$x_lim[1] <- min(p$x_lim[1], min(group_x, p$box_x[1]) - (p$box_width + p$box_gap_width) / if (p$box_median_lab_show) 1.5 else 2, na.rm = T)
      p$x_lim[2] <- max(p$x_lim[2], tail(p$box_x, 1) + (p$box_width + p$box_gap_width) / if (p$box_median_lab_show) 1.5 else 2, na.rm = T)
    }
  }
  
  # Export parameters
  p$quantile_matrix <- quantile_matrix
  p$group_x         <- group_x
  
  p
}

turn_coordinates <- function(co) list(xl = co$yl, xr = co$yh, yl = co$xl, yh = co$xr)

jbox <- function(p) {
  print_debug_info(p)
  index_box <- which(is_box(p$type))
  if (!length(index_box)) return(p)
  
  for (j in seq_along(index_box)) {
    co <- list()
    co$xl <- p$box_x[j] - p$box_width / 2
    co$xr <- p$box_x[j] + p$box_width / 2
    co$yl <- p$quantile_matrix[j, 2]
    co$yh <- p$quantile_matrix[j, 4]
    
    if (p$turn) co <- turn_coordinates(co)
    
    this_col <- p$color[index_box[j]]
    
    # First da box
    if (co$xl != co$xr & co$yl != co$yh) graphics::rect(co$xl, co$yl, co$xr, co$yh, col = this_col, border = NA)

    if (!p$turn) error_msg("Box plots are only implemented for 'turned plots'. Please add turn = y to your parameters.")
    
    # Next da whiskers
    for (w in c(0, 3)) {
      co$xl <- co$xr <- p$box_x[j]
      co$yl <- p$quantile_matrix[j, 1 + w]
      co$yh <- p$quantile_matrix[j, 2 + w]
    
      if (p$turn) co <- turn_coordinates(co)

      graphics::lines(x = c(co$xl, co$xr), y = c(co$yl, co$yh), col = this_col, lwd = p$line_lwd)
    }
    
    # Now the median
    y_delta <- abs(co$yh - co$yl) * p$box_median_line_extension_factor
    median_col <- if (is_set(p$box_median_col)) get_col_from_p(p, p$box_median_col) else this_col # same as box
    if (0 == p$box_median_shape) {
      graphics::lines(x = rep(p$quantile_matrix[j, 3], 2), y = c(co$yl - y_delta, co$yh + y_delta), col = median_col)
    } else {
      graphics::points(x = p$quantile_matrix[j, 3], y = mean(c(co$yl, co$yh)), col = median_col, pch = p$box_median_shape, cex = p$box_median_shape_size)
    }
    y_box_median_lab_below <- co$yh # remember, low value is above high value on y-axis if turn==T
    y_box_median_lab_middle <- mean(c(co$yl, co$yh))

    # And put the median as text on top
    if (p$box_median_lab_show) {
      median_lab <- fix_numbers(p$quantile_matrix[j, 3], n_decimals = p$box_median_lab_n_decimals, p$decimal_mark, big_mark = if (p$box_lab_big_mark_show) p$big_mark else "")
      median_lab_height <- graphics::strheight(median_lab, cex = p$box_median_lab_font_size)

      if (0 == p$box_median_shape) { # adapt to line
        graphics::text(x = p$quantile_matrix[j, 3], y = y_box_median_lab_below - median_lab_height, labels = median_lab, pos = 4, cex = p$box_median_lab_font_size, offset = 0.15)
      } else { # adapt to symbol
        graphics::text(x = p$quantile_matrix[j, 3], y = y_box_median_lab_middle + 1.5 * median_lab_height, labels = median_lab, cex = p$box_median_lab_font_size, offset = 0)
      }
    }
  }
  
  p
}





























