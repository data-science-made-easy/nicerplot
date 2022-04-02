shade <- function(p, x_pos, this_col) {
  this_col <- get_col_from_p(p, this_col)
  
  # user may supply less colors than shading areas
  # replicate cols in that case
  if (1 == length(this_col) & 2 < length(x_pos)) this_col <- rep(this_col, length(x_pos) / 2)
  
  counter <- 1
  for (i in seq(from = 1, to = length(x_pos) - 1, by = 2)) {
    graphics::rect(x_pos[i], ybottom = p$y_l_lim[1], xright = x_pos[1 + i], p$y_l_lim[2], col = this_col[counter], border = NA)
    counter <- 1 + counter
  }
}

shading <- function(p) {
  print_debug_info(p)
  numbers <- is_set(p$x_shading)
  dates   <- is_set(p$x_shading_date)
  if (!numbers & !dates) return(p)
  
  if (numbers & dates) error_msg("Both x_shading and x_shading_date are set. Please choose only one, based on the values on your x-axis.")
      
  x_pos <- if (numbers) p$x_shading else lubridate::decimal_date(as.Date(p$x_shading_date))
  
  shade(p, x_pos, p$x_shading_col)
  
  p
}

shading_suppress <- function(p) {
  print_debug_info(p)
  numbers <- is_set(p$shading_suppress_x)
  dates   <- is_set(p$shading_suppress_x_date)
  if (!numbers & !dates) return(p)
  
  if (numbers & dates) error_msg("Both shading_suppress_x and shading_suppress_x_date are set. Please choose only one, based on the values on your x-axis.")
  
  x_pos <- if (numbers) p$shading_suppress_x else lubridate::decimal_date(as.Date(p$shading_suppress_x_date))
  
  shade(p, x_pos, p$shading_suppress_col)
  
  p
}