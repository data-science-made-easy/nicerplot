world_map_title_www <- function(p) {
  print_debug_info(p)
  if (!is_world_map_www(p)) return(p)
  
  p_return <- p # Don't pass the modified p (e.g. with swap) on to next function (bit of hack)

  x_position_left <- p$labels_margin_left

  if (!is_set(p$world_map_value)) {
    title_width <- p$width
  } else {
    title_width <- graphics::strwidth(p$title, cex = p$world_map_title_font_size, units = "inches", family = p$font) * grDevices::cm(1) + 2 * x_position_left
  }

  # Correct for logo
  if (is_yes(p$logo)) vshift <- p$logo_height / p$height else vshift <- 0

  # COLOR TITLE BG
  h        <- .85
  dy       <- (1 - h) / (1 + vshift)
  delta_dy <- (1 - h) - dy
  r        <- title_width / p$width
  ybot     <- h - vshift + delta_dy
  ytop     <- h - vshift + (1 - h) - delta_dy
  graphics::rect(0, ybot, r, ytop, col = get_col_from_p(p, p$world_map_title_bg_col), border = NA)
  graphics::rect(r, ybot, 1, ytop, col = get_col_from_p(p, p$world_map_value_bg_col), border = NA)


  graphics::text(x_position_left / p$width, (1+h)/2 - vshift, labels = p$title, adj = c(0, 0.5), cex = p$world_map_title_font_size, col = get_col_from_p(p, p$world_map_title_col), family = p$font)

  if (is_set(p$world_map_value)) {
    sgn <- if (0 < p$world_map_value) "+" else ""
    value <- fix_numbers(p$world_map_value, n_decimals = p$world_map_value_n_decimals, p$decimal_mark, big_mark = p$big_mark)
    graphics::text((1+r)/2, (1+h)/2 - vshift, labels = paste0(sgn, value, p$world_map_value_symbol), adj = c(.5, 0.5), cex = p$world_map_value_font_size, col = get_col_from_p(p, p$world_map_value_col), family = p$font)
  }

  p_return
}