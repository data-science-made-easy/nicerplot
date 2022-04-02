margins_0000 <- function(p) {
  print_debug_info(p)
  
  # Set margins
  # opar <- graphics::par()
  # on.exit(suppressWarnings(graphics::par(opar)))
  graphics::par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE, xaxs = 'i', yaxs = 'i')
  plot(0:1, 0:1, type = "n", bty = "n", xaxt = "n", yaxt = "n")
  
  return(p)
}