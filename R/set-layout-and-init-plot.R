set_layout_and_init_plot <- function(p) {
  print_debug_info(p)

  mai <- c(p$margin_south, p$margin_west, p$margin_north + p$margin_north_extra, if (is.element("y-right", p$style)) p$margin_west else p$margin_east) / grDevices::cm(1) # scale to inches

  # correct if plot in R
  if (!any_plot_export(p)) {
    mai <- mai / c(0.6, 0.5, 0.5, 0.25) * c(1.02, 0.82, 0.82, 0.42)
  }
  # Init plot
  graphics::par(bg = p$bg_col, mai = mai, xaxs = 'i', yaxs = 'i')

  p_tmp <- swap_xy(p)
  plot(NA, axes = FALSE, ann = FALSE, xlim = p_tmp$x_lim, ylim = p_tmp$y_l_lim)

  return(p)
}
