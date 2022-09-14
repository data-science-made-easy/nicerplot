is_yl  <- function(p, j) {
  if (missing(j)) j <- seq_along(p$y_axis)
  "l"  == p$y_axis[j]
}
is_yr  <- function(p, j) {
  if (missing(j)) j <- seq_along(p$y_axis)
  "r"  == p$y_axis[j]
}

