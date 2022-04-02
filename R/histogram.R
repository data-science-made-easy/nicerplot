is_hist <- function(p) is.element(HIST, p$style)

hist_pre <- function(p) {
  print_debug_info(p)
  if (!is_hist(p)) return(p)
  
  br <- if (is_set(p$hist_breaks)) p$hist_breaks else "Sturges"
  stats <- graphics::hist(p$y[, 1], breaks = br, plot = F)
  p$x <- stats$mids
  p$y <- cbind(if (p$hist_freq) stats$counts else stats$density)

  p
}