legend_pre <- function(p) {
  print_debug_info(p)
  p$legend_type  <- p$type
  p$legend_color <- p$color

  # Remove text labels from legend
  if (any(is_label(p$legend_type))) {
    index_label <- which(is_label(p$type))
    p$legend_type <- p$legend_type[-index_label]
    p$name        <- p$name[-index_label]
  }
  
  # # Reduce 'area' from two (lower, upper) to one
  # if (any(is_area(p$legend_type))) {
  #   index          <- even_elements(which(is_area(p$legend_type)))
  #   p$legend_type  <- p$legend_type[-index]
  #   p$name         <- p$name[-index]
  #   p$legend_color <- p$legend_color[-index]
  # }

  # area stack
  if (is_set(p$area_stack_name)) {
    p$name             <- c(p$name, p$area_stack_name)
    p$legend_type      <- c(p$legend_type, LEGEND_STACK)
    p$legend_stack_vec <- which(AREA_STACK == p$type)
  }
  
  # bar stack
  if (is_set(p$bar_stack_name)) {
    p$name             <- c(p$name, p$bar_stack_name)
    p$legend_type      <- c(p$legend_type, LEGEND_STACK)
    p$legend_stack_vec <- which(BAR_STACK == p$type)
  }
  
  # whiskers
  if (is_set(p$whisker_list) & 0 < p$whisker_legend_show_n) {
    whisker_name       <- unlist(lapply(p$whisker_list, function(v) v$name))[1:p$whisker_legend_show_n]
    index_insert       <- p$whisker_series[1:p$whisker_legend_show_n]
    p$name             <- mappend(p$name, whisker_name, index_insert)
    p$legend_type      <- mappend(p$legend_type,  LEGEND_WHISKER, index_insert)
    whisker_legend_col <- if (is_set(p$whisker_legend_col)) p$whisker_legend_col else p$whisker_col[1:p$whisker_legend_show_n]
    p$legend_color     <- mappend(p$legend_color, whisker_legend_col, index_insert)
  }
  
  # # forecast
  # if (is_set(p$forecast_x) & p$legend_forecast_show) {
  #   p$name <- c(p$name, p$legend_forecast_text)
  #   p$legend_type <- c(p$legend_type, LEGEND_FORECAST)
  # }
  
  p$name <- set_newline(p$name) # set newlines properly
  
  return(p)
}

scaling_factor <- function(p) {
  # Handle sub set
  # this_order <- if (is_set(p$legend_order)) p$legend_order else 1:(if (is_set(p$forecast_x) & p$legend_forecast_show) 1 + p$n_series else p$n_series)
  this_order <- if (is_set(p$legend_order)) p$legend_order else 1:p$n_series
  n_legend_items <- length(this_order)
  name     <- p$name[this_order]
  
  n_cols <- 1 + (n_legend_items - 1) %/% p$legend_n_per_column
  txt_width_per_col <- NULL
  for (i in 1:n_cols) txt_width_per_col[i] <- max(graphics::strwidth(name[(i-1) * p$legend_n_per_column + 1:p$legend_n_per_column], font = hack_font(p, p$legend_font_style), adj = 0, cex = p$legend_font_size, family = p$font), na.rm = T)
  
  width_available_for_text <- 1 - 2 * p$legend_x / p$width - n_cols * (p$legend_symbol_width + p$legend_space_symbol_txt) / p$width - (n_cols - 1) * p$legend_column_space / p$width  # same margins both sides, subtract symbols, margins between symbol and text, margin between columns
  width_needed_for_text    <- sum(txt_width_per_col)
    
  return(min(1, width_available_for_text / width_needed_for_text))
}

j_legend <- function(p) {
  print_debug_info(p)
  # Return if nothing to do
  if (is_no(p$legend_show)) return(p)
  
  scaling <- scaling_factor(p) # scale if legend too wide

  # TITLE SCALING LOCKED
  if (is_yes(p$lock) & scaling < 1) error_msg("Your legend is too wide. Please think of a shorter legend. Or change the number of columns in the legend (parameter legend_n_per_column). Alternative solutions are (i) the use of a newline '\\n', (ii) the use of 'style = wide' for a broader figure, (iii) or the removal of the lock by setting parameter 'lock = no' after which James will squeeze the legend.")

  x_left            <- p$legend_x / p$width
  symbol_width      <- p$legend_symbol_width / p$width
  legend_txt_length <- 0
  this_order        <- if (is_set(p$legend_order)) p$legend_order else if (is_set(p$legend_type)) 1:length(p$legend_type) else NULL
  for (j in this_order) {
    n_th_item <- which(j == this_order)
    col_j <- (n_th_item - 1) %/% p$legend_n_per_column
    if (0 < col_j & 0 == (n_th_item - 1) %% p$legend_n_per_column) {
      x_left <- x_left + symbol_width + p$legend_space_symbol_txt / p$width + scaling * legend_txt_length + p$legend_column_space / p$width
      legend_txt_length <- 0
      y_line <- 0
    }
    y_line <- p$legend_y / p$height - ((n_th_item - 1) %% p$legend_n_per_column) * p$legend_line_distance / p$height
    symbol_height <- p$legend_line_distance * p$legend_symbol_height / p$height

    # Legend line  
    if (is.element(p$legend_type[j], LINE_SET)) {
      graphics::lines(x_left + c(0, symbol_width), rep(y_line, 2), col = get_col_from_p(p, p$legend_color[j]), lwd = p$line_lwd[j], lty = fix_lty_vector_graphics(p$line_lty[j]))
      
      # TODO move color_pre to start of pipeline so color determination of symbols can be in linez_pre available for legend
      # TODO code below is duplicated from linez.R; please keep only one copy
      if (0 != p$line_symbol[j]) {
        # Set col
        if (is_set(p$line_symbol_col)) {
          if (is_set(p$line_symbol_col[j])) {
            this_col <- p$line_symbol_col[j]
          } else {
            this_col <- p$legend_color[j]
          }
        } else {
          this_col <- p$legend_color[j]
        }
        this_col <- get_col_from_p(p, this_col)
        
        graphics::points(x_left + symbol_width / 2, y_line, pch = p$line_symbol[j], col = this_col, cex = p$line_symbol_size[j])
      }
    }
      
    # Legend block
    if (is.element(p$legend_type[j], LEGEND_BLOCK)) graphics::polygon(x = c(x_left, x_left + symbol_width, x_left + symbol_width, x_left), y = c(y_line, y_line, y_line + symbol_height, y_line + symbol_height) - symbol_height / 2, col = get_col_from_p(p, p$legend_color[j]), border = NA)
    
    # Legend box
    if (BOX == p$legend_type[j]) {
      this_col <- get_col_from_p(p, p$legend_color[j])
      if (p$turn) {
        box_width      <- symbol_width / 2
        whisker_length <- (symbol_width - box_width) / 2
        graphics::lines(x_left + c(0, whisker_length), rep(y_line, 2), col = this_col, lwd = p$line_lwd)
        graphics::lines(x_left + symbol_width - c(0, whisker_length), rep(y_line, 2), col = this_col, lwd = p$line_lwd)
        x <- c(x_left + whisker_length, x_left + symbol_width - whisker_length)
        x <- c(x, rev(x))
        y <- c(y_line, y_line, y_line + symbol_height, y_line + symbol_height) - symbol_height / 2      
        graphics::polygon(x = x, y = y, col = this_col, border = NA)
      } else {
        box_height     <- symbol_height / 2
        whisker_length <- (symbol_height - box_height) / 2
        graphics::lines(rep(x_left + symbol_width / 2, 2), c(y_line, y_line + whisker_length) - symbol_height / 2, col = this_col, lwd = p$line_lwd)
        graphics::lines(rep(x_left + symbol_width / 2, 2), c(y_line + whisker_length + box_height, y_line + symbol_height) - symbol_height / 2, col = this_col, lwd = p$line_lwd)
        x <- c(x_left, x_left + symbol_width)
        x <- c(x, rev(x))
        y <- rep(y_line + whisker_length, 2) - symbol_height / 2
        y <- c(y, y + box_height)
        graphics::polygon(x = x, y = y, col = this_col, border = NA)
      }
    }
    
    # Legend stack
    if (is.element(p$legend_type[j], LEGEND_STACK)) {
      piece_height <- symbol_height / length(p$legend_stack_vec)
      y0 <- y_line - symbol_height / 2
      for (j_stack in seq_along(p$legend_stack_vec)) {
        this_col <- get_col_from_p(p, p$legend_color[p$legend_stack_vec[j_stack]])
        graphics::rect(x_left, y0, x_left + symbol_width, y0 <- y0 + piece_height, col = this_col, border = NA)
      }
    }
    
    # Legend dot
    if (is_dot(p$legend_type[j])) {
      this_pch <- if (1 == length(p$dot_shape)) p$dot_shape else p$dot_shape[is_nth_dot(j, p)]
      if ("." == this_pch) this_pch <- 20
      this_col <- get_col_from_p(p, p$legend_color[j])
      if (!p$legend_dot_col_trans)
        this_col <- stringr::str_sub(this_col, 1, 7)
      
      graphics::points(x_left + symbol_width / 2, y_line, col = this_col, pch = this_pch, lwd = if (1 == length(p$dot_lwd)) p$dot_lwd else p$dot_lwd[is_nth_dot(j, p)], cex = p$dot_size) # , cex = p$dot_size ... or  keep constant cex constant?
    }
    
    if (LEGEND_WHISKER == p$legend_type[j]) {
      whisk_line <- function(x, y) graphics::lines(x, y, col = get_col_from_p(p, p$legend_color[j]), lwd = p$whisker_lwd)
      if (p$turn) {
        whisk_line(x_left + c(0, symbol_width), rep(y_line, 2))
        whisk_line(c(x_left, x_left), c(y_line - symbol_height / 4, y_line + symbol_height / 4))
        whisk_line(c(x_left + symbol_width, x_left + symbol_width), c(y_line - symbol_height / 4, y_line + symbol_height / 4))
      } else {
        whisk_line(rep(x_left + symbol_width / 2, 2), c(y_line - symbol_height / 2, y_line + symbol_height / 2))
        whisk_line(c(x_left + symbol_width / 4, x_left + symbol_width * 3 / 4), rep(y_line + symbol_height / 2, 2))
        whisk_line(c(x_left + symbol_width / 4, x_left + symbol_width * 3 / 4), rep(y_line - symbol_height / 2, 2))
      }
    }

    # # Legend forecast
    # if (is.element(p$legend_type[j], LEGEND_FORECAST)) { # TODO Rewrite with ==
    #   # forecast bg
    #   if (p$forecast_bg_show) {
    #     graphics::polygon(x = c(x_left, x_left + symbol_width, x_left + symbol_width, x_left), y = c(y_line, y_line, y_line + symbol_height, y_line + symbol_height) - symbol_height / 2, col = p$forecast_bg_col, border = NA)
    #   }
    #   # graphics::polygon(x = c(x_left, x_left + symbol_width, x_left + symbol_width, x_left), y = c(y_line, y_line, y_line + symbol_height, y_line + symbol_height) - symbol_height / c(4, 4, 2, 2), col = "black", border = NA, density = cm(1) * p$forecast_shading_density, angle = p$forecast_shading_angle)
    #   #
    #   # lines(x_left + c(0, symbol_width), rep(y_line, 2) - symbol_height / 2, col = "black", lwd = 1, lty = p$line_obs_fc_lty[2])
    #
    #   # lines(rep(x_left, 2), y = c(y_line - symbol_height / 2, y_line - symbol_height / 4), lwd = 2, col = get_col_from_p(p, "sun"))
    #   # lines(x = c(x_left, x_left + symbol_width), y = rep(y_line - symbol_height / 4, 2), lwd = 2, col = get_col_from_p(p, "sun"))
    # }

    # Legend text
    # Enable 'expressions' with ^super and mu and [lowerscript]
    this_label <- if (is_yes(p$legend_math)) parse(text = p$name[j]) else p$name[j] # TODO generalise to all text labels

    graphics::text(x_left + symbol_width + p$legend_space_symbol_txt / p$width, y_line, labels = this_label, font = hack_font(p, p$legend_font_style), adj = 0, cex = scaling * p$legend_font_size, family = p$font)
    
    legend_txt_length <- max(legend_txt_length, graphics::strwidth(p$name[j], font = hack_font(p, p$legend_font_style), cex = p$legend_font_size, family = p$font))
  }
  
  p
}


































