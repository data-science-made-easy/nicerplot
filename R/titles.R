titles <- function(p) {
  print_debug_info(p)
  if (is_world_map_www(p)) return(p) # Has its own title
  
  p_return <- p # Don't pass the modified p (e.g. with swap) on to next function (bit of hack)
  p <- swap_xy(p)

  x_position_left   <- p$labels_margin_left / p$width
  x_position_right  <- 1 - (p$labels_margin_right / p$width)
  x_position_middle <- .5
  
  get_adj <- function(aln) {
    index <- which(aln == ALIGNMENT)
    x   <- c(x_position_left, x_position_middle, x_position_right)[index]
    adj <- c(0, .5, 1)[index]
    list(x = x, adj = adj)
  }
  
  # Warn if user wants 'no-title'
  if (is_set(p$title) & is.element(NO_TITLE, p$style)) print_warning("While your style includes 'no-title', you have specified a title. This seems contradictionary.")

  # title, scale such that it does not exceed margin right
  if (is_set(p$title) & !is.element(NO_TITLE, p$style)) {
    p$title <- set_newline(p$title)
    title_width <- graphics::strwidth(p$title, font = hack_font(p, 2), cex = p$title_font_size, units = "inches", family = p$font) * grDevices::cm(1)
    title_scale_factor <- min(1, (p$width - 2 * p$labels_margin_left) / title_width)

    # TITLE SCALING LOCKED
    if (is_yes(p$lock) & title_scale_factor < 1) error_msg("Your title is too wide. Please think of a shorter title. Alternative solutions are (i) the use of a newline '\\n', (ii) the use of 'style = wide' for a broader figure, (iii) or the removal of the lock by setting parameter 'lock = no' after which James will squeeze the title.")

    # Correct for logo
    if (is_yes(p$logo)) p$title_v_shift <- p$title_v_shift + p$logo_height

    # Main title
    y_position_top <- 1 - p$title_v_shift / p$height
    graphics::text(get_adj(p$title_align)$x, 1 - p$title_v_shift / p$height, labels = p$title, adj = get_adj(p$title_align)$adj, font = hack_font(p, 2), cex = p$title_font_size * title_scale_factor, col = get_col_from_p(p, p$title_col), family = p$font)
  }
  
  # x-title
  graphics::text(get_adj(if (p$turn) p$y_title_align else p$x_title_align)$x, (p$margin_south - p$x_title_v_shift) / p$height, labels = set_newline(p$x_title), adj = get_adj(if (p$turn) p$y_title_align else p$x_title_align)$adj, font = hack_font(p, 3), cex = p$x_title_font_size, col = get_col_from_p(p, p$x_title_col), family = p$font)

  # x-title top
  if (is_set(p$y_r_title)) {
    # if (p$turn) { # put y_right_title at top
      graphics::text(get_adj("right")$x, 1 - (p$margin_north - p$y_title_v_shift) / p$height, labels = set_newline(p$y_r_title), font = hack_font(p, 3), cex = p$y_title_font_size, adj = get_adj("right")$adj, col = get_col_from_p(p, p$y_r_title_col), family = p$font)
    # }
  }
  
  # y-title "left"
  graphics::text(get_adj(if (p$turn) p$x_title_align else p$y_title_align)$x, 1 - (p$margin_north - p$y_title_v_shift) / p$height, labels = set_newline(p$y_title), font = hack_font(p, 3), cex = p$y_title_font_size, adj = get_adj(if (p$turn) p$x_title_align else p$y_title_align)$adj, col = get_col_from_p(p, p$y_title_col), family = p$font)

  p_return
}