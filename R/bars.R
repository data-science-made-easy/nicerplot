is_bar       <- function(type) is.element(type, BAR_SET)
is_bar_next  <- function(type) is.element(type, BAR_NEXT)
is_bar_stack <- function(type) is.element(type, BAR_STACK)

bars_pre <- function(p) {
  print_debug_info(p)
  if (!any(p$type %in% BAR_SET)) return(p)

  # Example with two x locations (n_bar_sets = 2) holding four block sets (n_stacks_per_set = 4) (stacks of) bars
  #    #  #  #  #
  #    ## #  ## #
  #   -####--####-
  # g/2____g_____g/2 half gap, block set, gap, block set, half gap
  #     bs    bs     

  stack_exists       <- any(is_bar_stack(p$type))

  # 
  if (stack_exists) p$y_force_include_zero <- TRUE # must do so for stacked bars.

  p$n_bar_sets       <- length(p$x) # N
  p$n_stacks_per_set <- length(which(p$type %in% BAR_NEXT)) + stack_exists # n_bar-- + 1_bar=

  if (!is_set(p$bar_stack_index)) p$bar_stack_index <- p$n_stacks_per_set # If not user set, then place right

  factor             <- if (1 == length(p$x)) 1 else min(diff(p$x))
  p$bar_set_width    <- (1 - p$bar_gap_fraction) * factor
  p$gap_width        <- p$bar_gap_fraction * factor
  p$bar_width        <- p$bar_set_width / p$n_stacks_per_set
  p$stack_x_left     <- -p$bar_set_width / 2 + 0:(p$n_stacks_per_set - 1) * p$bar_width
  p$stack_x_right    <- p$stack_x_left + p$bar_width
  
  # Update x_lim
  if (!p$x_lim_by_user) {
    if (1 == length(p$x)) {
      p$x_lim <- c(0, 2)
    } else {
      p$x_lim[1] <- p$x[1] - (p$bar_set_width + p$gap_width) / 2 
      p$x_lim[2] <- tail(p$x, 1) + (p$bar_set_width + p$gap_width) / 2
      
      # adjust x_lim for first group if labels are vertical
      if (is_set(p$group_x) & p$turn) p$x_lim[1] <- min(p$x_lim[1], p$group_x[1])
    }
  }
  
  #### HACK START
  this_type <- p$type
  index_whisker <- which(WHISKER == this_type)
  if (length(index_whisker)) this_type <- this_type[-index_whisker] 
  #### HACK STOP
  
  # # Update y_lim for bar--
  # if (!p$y_lim_by_user & any(is_bar_next(p$type))) {
  #   index <- which(is_bar_next(p$type))
  #   vec   <- as.vector(unlist(p$y[,index]))
  #   p     <- update_y_lims(p, index, vec) # range(as.numeric(c(p$y_lim, vec)), na.rm = T) # TODO Try just simpler
  #   # Update y_lim max if we want to show labels (#ugly hack, but we don't know label dims before plotting...)
  #   if (p$bar_lab_show & p$bar_lab_top) {
  #     todo(p, "y-lim zou alleen bijgewerkt moeten worden als hoogste BAR + x% boven huidige y-lim uitschiet. en dan apart voor yleft en yright as...")
  #     if (any(0 < vec)) p$y_lim[2] <- p$y_lim[2] + p$bar_lab_increase_y_lim_2 * diff(p$y_lim)
  #     if (any(vec < 0)) p$y_lim[1] <- p$y_lim[1] - p$bar_lab_increase_y_lim_2 * diff(p$y_lim)
  #   }
  # }
  #
  # # Update y_lim for stacks
  # if (!p$y_lim_by_user & stack_exists) {
  #   stack_pos <- stack_neg <- rep(0, length(p$x))
  #   index_stack <- which(is_bar_stack(p$type))
  #   for (j in index_stack) {
  #     for (i in 1:length(p$x)) {
  #       if (p$y[i, j] < 0) stack_neg[i] <- stack_neg[i] + p$y[i, j]
  #         else             stack_pos[i] <- stack_pos[i] + p$y[i, j]
  #     }
  #   }
  #
  #   y_bar_next <- NULL
  #   for (j in seq_along(p$type)) if (is_bar_next(p$type[j])) y_bar_next <- c(y_bar_next, p$y[, j])
  #
  #   # p$y_lim[1] <- min(p$y_lim[1], stack_neg, y_bar_next, na.rm = T) # min(stack_neg)
  #   # p$y_lim[2] <- max(p$y_lim[2], stack_pos, y_bar_next, na.rm = T) # max(stack_pos)
  #
  #   p <- update_y_lims(p, index_stack, c(stack_neg, stack_pos)) # Yoyoyo alles op de schop wbt (groepen van) stacks
  #
  #   if (p$bar_lab_show & p$bar_lab_top) {
  #     todo(p, "y-lim zou alleen bijgewerkt moeten worden als hoogste STACK + x% boven huidige y-lim uitschiet. en dan apart voor yleft en yright as...")
  #     if (any(0 < stack_pos)) p$y_lim[2] <- p$y_lim[2] + p$bar_lab_increase_y_lim_2 * diff(p$y_lim)
  #     if (any(stack_neg < 0)) p$y_lim[1] <- p$y_lim[1] - p$bar_lab_increase_y_lim_2 * diff(p$y_lim)
  #   }
  # }
    
  p
}

bars <- function(p) {
  print_debug_info(p)
  if (!any(p$type %in% BAR_SET)) return(p)
  
  p_return <- p # Don't pass the modified p (e.g. with swap) on to next function (bit of hack)
  p <- swap_xy(p)
  
  #
  ## Prepare for bar labels
  #
  # Auto adjust text size
  # Auto rotate text
  if (p$bar_lab_show) {
    if (p$bar_lab_rotation == DO_NOT_CHANGE) p$bar_lab_rotation <- 0    
    max_label_width_horizontal <- 0
    max_label_width_vertical   <- 0
    max_label_height           <- 0
    # First bar--
    for (j in 1:ncol(p$y)) if (is_bar(p$type[j])) for (i in seq_along(p$x)) {
      label <- fix_numbers(p$y[i, j], n_decimals = p$bar_lab_n_decimals, p$decimal_mark, big_mark = if (p$bar_lab_big_mark_show) p$big_mark else "")
      label_width_horizontal     <- get_str_dim(p, label, horizontal = T, font = p$bar_lab_font_style, family = p$font)$h
      max_label_width_horizontal <- max(max_label_width_horizontal, label_width_horizontal)
      label_width_vertical       <- get_str_dim(p, label, horizontal = F, font = p$bar_lab_font_style, family = p$font)$h
      max_label_width_vertical   <- max(max_label_width_vertical, label_width_vertical)
      # for turn:
      max_label_height <- max(max_label_height, -get_str_dim(p, label, horizontal = T, font = p$bar_lab_font_style, family = p$font)$v)
    }
    # Next bar= ? TODO ?
    todo(p, "bars opnieuw: schaling houdt geen rekening met stacks; eigenlijk alles opnieuw schrijvne, stacks en bar-- kunnen niet apart berekend worden... Ms meteen ook meerdere stacksgroepen?")
    todo(p, "OOK marge bij horizontale labels (in bars)")

    # Need to flip?
    scale_for_margin <- 0.9
    p$bar_lab_font_scaling <- min(1, p$bar_width / if (p$turn) max_label_height / scale_for_margin else max_label_width_horizontal)
    if (p$turn) {
      p$margin_between_bar_lab_and_txt <- p$bar_lab_font_scaling * get_str_dim(p, "m", horizontal = T, font = p$bar_lab_font_style, family = p$font)$h / 2
    } else {
      p$margin_between_bar_lab_and_txt <- p$bar_lab_font_scaling * get_str_dim(p, "m", horizontal = T, font = p$bar_lab_font_style, family = p$font)$v 
    }
    
    if (!p$turn & p$bar_lab_font_scaling < .7) { # Flip labels
      if (p$bar_lab_rotation == DO_NOT_CHANGE) p$bar_lab_rotation <- 90
      # Base scaling on 'new' label_width
      p$bar_lab_font_scaling <- min(1, scale_for_margin * p$bar_width / max_label_width_vertical)
      p$margin_between_bar_lab_and_txt <- p$margin_between_bar_lab_and_txt / 2
    }
  }

  #
  ## Draw bars and write labels
  #
  yl_stack_neg <- rep(0, length(p$x))
  yl_stack_pos <- rep(0, length(p$x))
  for (j in 1:ncol(p$y)) if (is_bar(p$type[j])) for (i in seq_along(p$x)) {
    
    bar_next_number <- which(j == which(BAR_NEXT == p$type))
    if (length(bar_next_number)) { # This is easy, just a bar--
      # +1 if stack should be here
      bar_next_number <- bar_next_number + if (any(is_bar_stack(p$type)) & p$bar_stack_index <= bar_next_number) 1 else 0
      
      xl <- p$x[i] + p$stack_x_left[bar_next_number]
      xr <- p$x[i] + p$stack_x_right[bar_next_number]
      yl <- 0
      yh <- p$y[i, j]
      if (is.na(yh)) yh <- 0 # set 0 if user did not fill in value
      this_col <- p$color[j]
    } else {
      if (is_bar_stack(p$type[j])) { # Now da real stuff: bar=
        # j_this_bar <- which(j == which(BAR_STACK == p$type))
        xl <- p$x[i] + p$stack_x_left[p$bar_stack_index]
        xr <- p$x[i] + p$stack_x_right[p$bar_stack_index]
        if (p$y[i, j] < 0) { # negative bars
          yl <- yl_stack_neg[i]
          yh <- yl + p$y[i, j]
          yl_stack_neg[i] <- yh
        } else { # positive bars
          yl <- yl_stack_pos[i]
          yh <- yl + p$y[i, j]
          yl_stack_pos[i] <- yh
        }
        this_col <- p$color[j]
      }
    }
    
    if (is_set(p$highlight_series) & is_set(p[[HIGHLIGHT_X]])) {
      if (j == p$highlight_series) {
        # if (p$x[i] == get_x(p, p[[HIGHLIGHT_X]], HIGHLIGHT_X)) { # Check highlight only this x
        if (is.element(p$x[i], get_parsed(p, HIGHLIGHT_X))) { # Check highlight only this x
          this_col <- get_col_from_p(p, p$highlight_col[1])
        }
      }
    } 

    in_forecast <- is_set(p$forecast_x)
    if (in_forecast) in_forecast <- p$forecast_x < p$x[i] #is_set(p$forecast_x < xr) & p$forecast_x < xr
    if (in_forecast) this_col <- make_transparent(this_col, 1 - p$forecast_col_transparency)
    
    if (p$turn) { # swap coordinates
      xl_ <- xl; xr_ <- xr; yl_ <- yl; yh_ <- yh
      xl <- yl_
      yl <- xr_
      xr <- yh_
      yh <- xl_
    }
    
    #
    ## Plot da barzzzsss OR symbols
    #
    graphics::rect(xl, yl, xr, yh, col = this_col, border = NA)
    if (in_forecast & p$forecast_shading_show) {
      this_col <- get_col_from_p(p, p$forecast_shading_col)
      this_col <- make_transparent(this_col, p$forecast_shading_col_transparency)
      graphics::rect(xl, yl, xr, yh, col = this_col, border = NA, density = grDevices::cm(1) * p$forecast_shading_density, angle = p$forecast_shading_angle)
    }

    #
    ## Draw da labels
    #
    if (p$bar_lab_show) {
      show_this_lab    <- TRUE

      is_bar_stack_last <- function(sign_neg) {
        j_is_this_sign_stack <- which(is_bar_stack(p$type) & if (sign_neg) p$y[i, ] < 0 else 0 < p$y[i, ])
        if (length(j_is_this_sign_stack)) return(tail(j_is_this_sign_stack,1) == j) else return(FALSE)
      }
      
      # If stack, only show 'last' except when !bar_lab_top and labels in middle of bar
      stack_exists <- any(is_bar_stack(p$type))
      if (stack_exists & is_bar_stack(p$type[j])) {
        show_this_lab <- !p$bar_lab_top | is_bar_stack_last(T) | is_bar_stack_last(F)
      }
      
      if (show_this_lab) {
        bar_lab <- if (p$bar_lab_top) if (p$turn) xr else yh else p$y[i, j]
        bar_lab <- fix_numbers(bar_lab, n_decimals = p$bar_lab_n_decimals, p$decimal_mark, big_mark = if (p$bar_lab_big_mark_show) p$big_mark else "")
      
        if (!p$turn) {
          if (p$bar_lab_top) {
            if (is_bar_next(p$type[j]) | is_bar_stack_last(F) | is_bar_stack_last(T)) {
              if (yh < 0) { # for negative
                this_y <- yh - p$margin_between_bar_lab_and_txt
                if (45 <= p$bar_lab_rotation) align <- 1 else align = .5
              } else { # for positive
                this_y <- yh + p$margin_between_bar_lab_and_txt
                if (45 <= p$bar_lab_rotation) align <- 0 else align = .5
              }            
            }
          } else {
            this_y <- (yl + yh) / 2 
            align  <- NULL
          }
          # print text for 'not turned' plot:
          this_cex <- if (is_set(p$bar_lab_font_size)) p$bar_lab_font_size else p$bar_lab_font_scaling
          graphics::text((xl + xr) / 2, this_y, bar_lab, srt = p$bar_lab_rotation, adj = align, cex = this_cex, font = p$bar_lab_font_style, col = p$bar_lab_col)
        } else {
          if (p$bar_lab_top) {
            if (is_bar_next(p$type[j]) | is_bar_stack_last(F) | is_bar_stack_last(T)) {
              if (is_bar_stack_last(T)) {
                this_x <- xr - p$margin_between_bar_lab_and_txt
              } else {
                this_x <- xr + p$margin_between_bar_lab_and_txt 
              }
              align <- if (xr < 0) 1.5 else 0
              this_cex <- if (is_set(p$bar_lab_font_size)) p$bar_lab_font_size else p$bar_lab_font_scaling
              graphics::text(this_x, (yl + yh) / 2, bar_lab, adj = align, cex = this_cex, font = p$bar_lab_font_style, col = p$bar_lab_col)
            }
          } else { # plot in middle of bar
            this_x <- (xl + xr) / 2
            align  <- NULL
          }
          # print text horizontally for 'turned' plot
          this_cex <- if (is_set(p$bar_lab_font_size)) p$bar_lab_font_size else p$bar_lab_font_scaling
          graphics::text(this_x, (yl + yh) / 2, bar_lab, adj = align, cex = this_cex, font = p$bar_lab_font_style, col = p$bar_lab_col)
        }
      }
    }
  }
  
  p_return
}

































