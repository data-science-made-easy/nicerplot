set_line_distance <- function(p) {
  print_debug_info(p)
  
  graphics::par(lheight = p$line_distance)
  
  p
}