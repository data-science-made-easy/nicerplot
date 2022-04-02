linez_lsfit <- function(p) {
  print_debug_info(p)
  if (!is_set(p$lsfit_series)) return(p)
  # lsfit(p$data[,1], p$data[,2])$coef[1] + lsfit(p$data[,1], p$data[,2])$coef[2] * p$data[, 1]
}