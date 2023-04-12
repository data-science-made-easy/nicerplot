is_heatmap <- function(p) is.element(HEATMAP, p$style)

heatmap_value_to_col <- function(p, value) {
  hex_col <- NULL
  
  for (i in seq_along(value)) {
    if (is.na(value[i])) {
      hex_col <- c(hex_col, NA)
    } else {
      frac         <- (value[i] - p$heatmap_z_lim[1]) / diff(p$heatmap_z_lim)
      rgb_col      <- grDevices::colorRamp(p$palette, interpolate = "linear", space = "rgb")(frac)
      this_hex_col <- grDevices::rgb(rgb_col[1,1], rgb_col[1,2], rgb_col[1,3], maxColorValue = 255)
      hex_col      <- c(hex_col, this_hex_col)      
    }
  }

  hex_col
}

heatmap_pre <- function(p) {
  print_debug_info(p)
  if (!is_heatmap(p)) return(p)

  # reorder data so it matches figure
  p$y <- p$y[nrow(p$y):1, ]

  # x, y
  n_x <- ncol(p$y)
  n_y <- nrow(p$y)

  # set param
  # NB some x-axis stuff is fixed in function 'preprocess_data_grouping_variables'
  if (!is_set(p$heatmap_x_axis_asis)) p$heatmap_x_axis_asis <- is_really_character(colnames(p$data)) | is_yes(p$x_lab_as_text) | n_x <= 10
  if (!is_set(p$heatmap_y_axis_asis)) p$heatmap_y_axis_asis <- is_really_character(p$data[, 1]) | n_y <= 10

  # x-axis
  # Fixed partly in function 'preprocess_data_grouping_variables'
  if (p$heatmap_x_axis_asis) {
    p$heatmap_x                   <- 1:n_x
    if (!is_set(p$x_at))  p$x_at  <- 1:n_x
    if (!is_set(p$x_lab)) p$x_lab <- colnames(p$data)[-1]
    if (!is_set(p$x_lim)) p$x_lim <- 0.5 + c(0, n_x)
  } else {
    # check equidistant
    p$heatmap_x <- as.numeric(colnames(p$data)[-1])
    max_diff_x  <- max(abs(diff(diff(p$heatmap_x))))

    if (10^-10 < max_diff_x) error_msg("The values on your x-axis (i.e. first row in your data) seem not equidistant (abs(diffs) > 10^-10). Please fix that or set 'heatmap_x_axis_asis = yes'.")
  }
  
  # y-axis
  if (p$heatmap_y_axis_asis) {
    if (!is_set(p$y_at))  p$y_at  <- p$heatmap_y <- 1:n_y
    if (!is_set(p$y_lab)) p$y_lab <- rev(p$data[, 1])
    if (!is_set(p$y_lim)) p$y_lim <- 0.5 + c(0, n_y)
  } else {
    p$heatmap_y <- as.numeric(p$data[, 1])

    if (!is_set(p$y_at)) p$y_at  <- pretty(p$heatmap_y)

    # validate whether y-axis has equidistant labels
    max_diff_y <- max(abs(diff(diff(p$heatmap_y))))
    if (10^-10 < max_diff_y) error_msg("The values on your y-axis (i.e. first column in your data) seem not equidistant. Please fix that or set 'heatmap_y_axis_asis = yes'. ")
  }

  # delta, x,y-lim
  p$heatmap_x_delta <- p$heatmap_x[2] - p$heatmap_x[1]
  p$heatmap_y_delta <- p$heatmap_y[2] - p$heatmap_y[1]
  if (!is_set(p$x_lim)) {
    p$x_lim <- c(min(p$heatmap_x) - p$heatmap_x_delta / 2, max(p$heatmap_x) + p$heatmap_x_delta / 2)
    p$x_at  <- cut_data(p$x_at, p$x_lim)
  }
  if (!is_set(p$y_lim)) {
    p$y_lim <- c(min(p$heatmap_y) - p$heatmap_y_delta / 2, max(p$heatmap_y) + p$heatmap_y_delta / 2)
    p$y_at  <- cut_data(p$y_at, p$y_lim)
  }

  # palette
  p$palette <- get_col_from_p(p, p$palette)

  # set z_lim, values that have no value
  if (!is_set(p$heatmap_z_lim)) p$heatmap_z_lim <- range(p$y, na.rm = T)
  if (!is_set(p$heatmap_legend_values)) {
    n_items <- if (is_set(p$heatmap_legend_n_items)) p$heatmap_legend_n_items else max(c(p$heatmap_legend_n_items_min_default, length(p$palette)))
    p$heatmap_legend_values <- seq(from = p$heatmap_z_lim[1], to = p$heatmap_z_lim[2], length = n_items)
  }
  
  # set labels
  if (!is_set(p$heatmap_legend_labels)) {
    p$heatmap_legend_labels <- fix_numbers(p$heatmap_legend_values, p$heatmap_legend_labels_n_decimals, p$decimal_mark, big_mark = if (p$heatmap_legend_labels_big_mark_show) p$big_mark else "")
  }
  # legend
  p$name        <- p$heatmap_legend_labels
  p$legend_type <- rep(BAR_NEXT, length(p$name))

  # validation
  if (length(p$heatmap_legend_values) != length(p$heatmap_legend_labels)) error_msg("Parameters 'heatmap_legend_values' (indicating the values of which you want to show a colour in the legend) and 'heatmap_legend_labels' (labels next to those colours in legend) should the same number of values (now respectively ", length(p$heatmap_legend_values), " vs. ", length(p$heatmap_legend_labels), ").")
    
  # legend colours
  p$legend_color <- heatmap_value_to_col(p, p$heatmap_legend_values)
  
  return(p)
}

j_heatmap <- function(p) {
  print_debug_info(p)  
  if (!is_heatmap(p)) return(p)

  dx <- p$heatmap_x_delta
  dy <- p$heatmap_y[2] - p$heatmap_y[1]
  for (i in 1:ncol(p$y)) for (j in 1:nrow(p$y)) {
    x  <- p$heatmap_x[i]
    y  <- p$heatmap_y[j]
    rect(x - dx/2, y - dy/2, x + dx/2, y + dy/2, col = heatmap_value_to_col(p, p$y[j, i]), border = p$heatmap_line_col, lwd = p$heatmap_line_width)
  }
    
  p
}
