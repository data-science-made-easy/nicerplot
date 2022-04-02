is_whisker <- function(type) type == WHISKER

whisker_pre <- function(p) {
  print_debug_info(p)
  if (!any(is_whisker(p$type))) return(p)

  index_whisker <- which(is_whisker(p$type))
  if (0 != length(index_whisker) %% 2) error_msg("Parameter 'type' should contain an even number of the term 'whisker'. Currenly, type = ", paste0(p$type, collapse = ", "), ".")
  whisker_list <- list() # list elt i has data for whisker i
  n <- 0 # each iteration considers the n'th whisker
  for (i in 1:(length(index_whisker) / 2)) { # So i = 1, 3, 5, ..., n - 1
    n <- n + 1 # consider next whisker
    
    # Set the x-values
    ref_series <- p$whisker_series[n]
    if (is_bar(p$type[ref_series])) { # figure out the x-pos of this bar
      if (is_bar_next(p$type[ref_series])) { # bar--
        bar_next_number <- which(ref_series == which(BAR_NEXT == p$type))
        bar_next_number <- bar_next_number + if (any(is_bar_stack(p$type)) & p$bar_stack_index <= bar_next_number) 1 else 0 # correct for bar= inbetween
        x <- p$x + (p$stack_x_left[bar_next_number] + p$stack_x_right[bar_next_number]) / 2 # middle of the bar
      } else { # assume bar=
        x <- p$x + (p$stack_x_left[p$bar_stack_index] + p$stack_x_right[p$bar_stack_index]) / 2 # middle of stacked bars
      }
    } else { # no special treatment
      x <- p$x      
    }
    
    # Set the y-values
    low  <- p$y[,  odd_elements(index_whisker)[i]]
    high <- p$y[, even_elements(index_whisker)[i]]
    
    # Put in list
    whisker_list[[n]] <- list(x = x, low = low, high = high, name = p$name[odd_elements(index_whisker)[i]], y_axis = p$y_axis[odd_elements(index_whisker)[i]])
    
    # Fix y_lim
    if (!p$y_lim_by_user & is_yl(p, ref_series)) p$y_lim  <- range(c(p$y_lim,  low, high), na.rm = T)
    if (is_yr(p, ref_series)) p$y_r_lim <- range(c(p$y_r_lim, low, high), na.rm = T)
  }
  
  # Remove whiskers from our data
  p$y      <- p$y[, -index_whisker, drop = F]
  p$type   <- p$type[-index_whisker]
  p$name   <- p$name[-index_whisker]
  p$y_axis <- p$y_axis[-index_whisker]
  
  # Export
  p$whisker_list <- whisker_list
  
  # Update x_lim
  if (!p$x_lim_by_user) {
    if (1 == length(p$x)) {
      p$x_lim <- c(p$x - p$whisker_edge_length, p$x + p$whisker_edge_length)
    } else {
      p$x_lim[1] <- min(c(p$x_lim[1], p$x[1] - p$whisker_edge_length), na.rm = T)
      p$x_lim[2] <- max(c(p$x_lim[2], tail(p$x, 1) + p$whisker_edge_length), na.rm = T)
      
      # adjust x_lim for first group if labels are vertical FIX THIS TODO
      if (is_set(p$group_x) & p$turn) p$x_lim[1] <- min(p$x_lim[1], p$group_x[1])
    }
  }
  
  return(p)
}

whisker <- function(p) {
  print_debug_info(p)
  
  if (!is_set(p$whisker_list)) return(p)

  for (j in seq_along(p$whisker_list)) {
    x0 <- p$whisker_list[[j]]$x
    x1 <- p$whisker_list[[j]]$x
    y0 <- p$whisker_list[[j]]$low
    y1 <- p$whisker_list[[j]]$high
    if (p$turn) { # swap coordinates
      x0_ <- x0; x1_ <- x1; y0_ <- y0; y1_ <- y1
      x0 <- y0_
      x1 <- y1_
      y0 <- x0_
      y1 <- x1_
    }
    
    # auto correct width of whiskers to max bar width
    whisker_edge_length_inch <- p$whisker_edge_length
    if (any(is_bar(p$type))) {
      if (p$turn) {
        whisker_edge_length_inch <- min(whisker_edge_length_inch, p$bar_width / diff(graphics::par("usr")[c(4,3)]) * graphics::par("pin")[2])
      } else {
        whisker_edge_length_inch <- min(whisker_edge_length_inch, p$bar_width / diff(graphics::par("usr")[1:2]) * graphics::par("pin")[1])
      }
    }
    
    # retrieve color
    this_col <- if (1 < length(p$whisker_col)) get_col_from_p(p, p$whisker_col[j]) else get_col_from_p(p, p$whisker_col)
    
    # suppress warning if whisker is too small to plot  
    suppressWarnings(graphics::arrows(x0 = x0, y0 = y0, x1 = x1, y1, code = 3, col = this_col, angle = 90, length = whisker_edge_length_inch / grDevices::cm(1), lwd = p$whisker_lwd))
  }
  
  p
}





































