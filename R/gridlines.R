gridlines <- function(p) {
  print_debug_info(p)
    
  graphics::abline(h = if (p$turn) NULL else p$y_at, v = if (p$turn) p$x_at else NULL, lwd = p$grid_lines_lwd, col = p$grid_lines_col)

  if (is_yes(p$x_axis_bold_if_zero)) {
    if (p$turn) {
      if (is.element(0, p$x_at)) graphics::abline(v = 0, lwd = p$x_axis_bold_lwd, col = get_col_from_p(p, p$x_axis_bold_col))
    } else {
      if (is.element(0, p$y_at)) graphics::abline(h = 0, lwd = p$x_axis_bold_lwd, col = get_col_from_p(p, p$x_axis_bold_col))
    }    
  }

  p
}
