is_dot <- function(type) if (is_set(type)) type == DOT else FALSE

dot_pre <- function(p) {
  print_debug_info(p)  
  if (!any(is_dot(p$type))) return(p)
  
  for (j in 1:ncol(p$y)) if (is_dot(p$type[j])) {
    if (!p$y_lim_by_user & is_yl(p, j)) p <- update_y_lims(p, j, p$y[, j])
    if (is_yr(p, j))                    p <- update_y_lims(p, j, p$y[, j]) # TODO NOT if user sets yr
  }
    
  p
}

is_nth_dot <- function(j, p) {
  index <- which(is_dot(p$type))
  return(which(j == index))
}

dot <- function(p) {
  print_debug_info(p)
  if (!any(is_dot(p$type))) return(p)

  for (index_obs_fc in seq_along(p$index_lst)) {
    index <- p$index_lst[[index_obs_fc]]
    for (j in 1:ncol(p$y)) if (is_dot(p$type[j])) {
      x <- if (p$turn) p$y[index, j] else p$x[index]
      y <- if (p$turn) p$x[index]    else p$y[index, j]
    
      this_col <- p$color[j]
      if (2 == index_obs_fc) {
        this_factor     <- 1 - p$forecast_col_transparency
        this_transp_hex <- if (9 == nchar(this_col)) stringr::str_sub(this_col, start= -2) else "FF"
        this_transp_dec <- base::strtoi(paste0("0x", this_transp_hex)) / 255
        this_transp_dec <- this_transp_dec * (1 - p$forecast_col_transparency)
        this_col <- make_transparent(p$color[j], this_transp_dec)
      } # 
      this_shape <- if (1 == length(p$dot_shape)) p$dot_shape else p$dot_shape[is_nth_dot(j, p)]
      this_lwd   <- if (1 == length(p$dot_lwd))   p$dot_lwd   else p$dot_lwd[is_nth_dot(j, p)]
      
      # Because dots may be partly on border of plot, temporarily remove the plot border
      xpd_current <- graphics::par()$xpd
      graphics::par(xpd = TRUE)
    
      graphics::points(x, y, col = this_col, cex = p$dot_size, pch = this_shape, lwd = this_lwd)
      graphics::par(xpd = xpd_current)
    }    
  }
  
  p
}