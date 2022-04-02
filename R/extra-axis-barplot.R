extra_axis_barplot <- function(p) {
  print_debug_info(p)

  if (any(is_bar(p$type) | is_area_stack(p$type)) & p$y_l_lim[1] <= 0 & 0 <= p$y_l_lim[2]) {
    graphics::abline(h = if (p$turn) NULL else 0, v = if (p$turn) 0 else NULL, lwd = p$axis_barplot_lwd, col = get_col_from_p(p, p$axis_barplot_col))
  }

  p
}