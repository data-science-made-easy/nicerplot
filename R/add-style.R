add_style <- function(p) {
  print_debug_info(p)

  # Update style if for second y-axis
  if (any(RIGHT == p$y_axis) | is_set(p$y_r_lab)) p$style <- c(if (p$turn) "x-top" else "y-right", p$style)

  # Update style if we don't export the plot
  if (!any_plot_export(p)) p$style <- c(INTERACTIVE, p$style) # Add interactive if applicable

  # Remove duplicates
  p$style <- unique(p$style)
  
  p
}
