is_yl  <- function(p, j) {
  if (missing(j)) j <- seq_along(p$y_axis)
  "l"  == p$y_axis[j]
}
is_yr  <- function(p, j) {
  if (missing(j)) j <- seq_along(p$y_axis)
  "r"  == p$y_axis[j]
}

update_y_lims <- function(p, j, vec) {
  return(p)
  
  stop("IS THIS REALLY NEEDED?")
  
  if (all(is_yl(p, j))) {
    p$y_lim  <- range(as.numeric(c(p$y_lim, vec)),  na.rm = T)
  } else if (all(is_yr(p, j))) {
    p$y_r_lim <- range(as.numeric(c(p$y_r_lim, vec)), na.rm = T)
  } else error_msg("Problem updating y_lim for either no axes or for both y-axes simultaneously :-O")

  p
}

# secondary_y_axis <- function(p) {
#   print_debug_info(p)
#   if (all("l" == p$y_axis) | is_set(p$y_r_lab)) return(p)
#
#   if (!p$y_axes_align_zeros) error_msg("p$y_axes_align_zeros FALSE not yet implemented.")
#
#   y_left_n_labels <- length(p$y_at)
#
#   seq_left        <- seq(0, 1, length = y_left_n_labels)
#   i               <- y_left_n_labels
#   m_possible      <- NULL # vector with possible number of labeled gridlines on secondary y-axis (min. 3)
#   while (p$y_right_min_n_labels - 1 < i) {
#     seq_right <- seq(0, 1, length = i)
#     if (all(seq_right %in% seq_left)) m_possible <- c(m_possible, i)
#     i <- i - 1
#   }
#
#   # PREVENT ERRORS
#   scaling_data <- max(p$y_lim / p$y_r_lim, na.rm = T)
#   if (!is.finite(scaling_data)) error_msg("Cannot determine scaling for secondary y-axis in this data set.")
#   if (scaling_data <= 0) error_msg("No scaling of secondary y-axis possible because the axes are on opposite sides of zero.")
#
#   axis_possible <- function(data_lim, labs) min(labs) <= min(data_lim) & max(data_lim) <= max(labs)
#   done <- FALSE
#   scaling <- 1
#   tries_left <- 2000
#   while (!done & 0 < tries_left) {
#     i <- 1
#     while (!done & i <= length(m_possible)) { # try different number of labs on right axis
#       labs <- pretty(scaling * c(0, p$y_r_lim[2]), n = m_possible[i])
#       done <- m_possible[i] == length(labs) #& axis_possible(scaling * p$y_right_lim, labs)
#       i    <- 1 + i
#     }
#     scaling    <- scaling * 1.01
#     tries_left <- tries_left - 1
#   }
#   if (!done) error_msg("Sorry :-O James found no suitable scaling for the secondary y-axis. Please try so manually with parameters y_right_scaling, y_right_at and y_r_lab.")
#
#   # Do da scaling
#   p$y[, which(is_yr(p))] <- p$y_lim[2] / tail(labs, 1) * p$y[, which(is_yr(p))]
#
#   # Set da labs
#   p$y_r_lab <- rep(NA, y_left_n_labels)
#   p$y_r_lab[which(seq_left %in% seq(0, 1, length = length(labs)))] <- labs
#
#   # fix y_lab right elsewhere
#   if (is_set(p$y_r_lab)) {
#     p$y_r_lab <- fix_numbers(p$y_r_lab, p$y_n_decimals, p$decimal_mark, big_mark = if (p$y_lab_big_mark_show) p$big_mark else "")
#   } else {
#     p$y_r_lab <- set_newline(p$y_r_lab)
#   }
#
#   p
# }