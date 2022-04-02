format_labs_set_margin_west <- function(p) {
  print_debug_info(p)

  # x_lab
  if (!is_set(p$x_lab)) {
    if (is_yes(p$x_lab_date_show)) { # x_lab_date_show may not be set, so use is_yes
      error_msg("This code should never happen: in case of dates x_lab should be set already.")
      # p$x_lab <- get_pretty_date_lab(p)
    } else { # consider x_lab as an ordinary number
      p$x_lab <- fix_numbers(p$x_at, p$x_n_decimals, p$decimal_mark, big_mark = if (p$x_lab_big_mark_show) p$big_mark else "")
    }

    # put box names at x-axis
    if (any(is_box(p$type)) & p$box_name_as_x_lab) {
      # first handle boxes
      box_x_absent <- setdiff(p$box_x, p$x_at) # which to add
      p$x_at       <- sort(union(p$x_at, box_x_absent)) # add them
      index_added  <- which(p$x_at %in% box_x_absent) # get index of added elements
      for (i in index_added) p$x_lab <- append(p$x_lab, NA, after = i)
      # put labels at corresponding places
      p$x_lab[which(p$x_at %in% p$box_x)] <- colnames(p$y)[which(is_box(p$type))]
      # now handle group names
      if (is_set(p$group_x)) {
        group_x_absent <- setdiff(p$group_x, p$x_at) # which to add
        p$x_at         <- sort(union(p$x_at, group_x_absent)) # add them
        index_added    <- which(p$x_at %in% group_x_absent) # get index of added elements
        for (i in index_added) p$x_lab <- append(p$x_lab, NA, after = i)
        # put labels at corresponding places
        p$x_lab[which(p$x_at %in% p$group_x)] <- NA
      }
    }
  }
  p$x_lab <- set_newline(p$x_lab)

  # ticks x
  if (!is_set(p$x_ticks)) {
    p$x_ticks <- p$x_at
  }

  # y_lab
  if (!is_set(p$y_lab)) {
    p$y_lab <- fix_numbers(p$y_at, p$y_n_decimals, p$decimal_mark, big_mark = if (p$y_lab_big_mark_show) p$big_mark else "")
  } else {
    p$y_lab <- set_newline(p$y_lab)
  }
  
  # TODO y_lab right here?

  y_lab_max_width <- max(graphics::strwidth(if (p$turn) p$x_lab else p$y_lab, cex = if (p$turn) p$x_lab_font_size else p$y_lab_font_size, units = "inches", family = p$font)) * grDevices::cm(1)

  y_lab_margin_right_total <- (p$y_lab_margin_right + p$margin_west_delta) * p$width # convert to cm
  p$margin_west <- p$labels_margin_left + y_lab_max_width + y_lab_margin_right_total # normal margins, one column of labels

  if (is_set(p$group) & p$turn) {
    group_lab_width <- max(graphics::strwidth(unique(p$group), cex = p$group_font_size, units = "inches", font = hack_font(p, p$group_font), family = p$font)) * grDevices::cm(1)
    practical_increase   <- max(p$labels_margin_add_for_groups, group_lab_width - y_lab_max_width)
    p$margin_west        <- p$margin_west + practical_increase
    p$group_label_offset <- practical_increase + y_lab_max_width + y_lab_margin_right_total      
  }

  return(p)
}