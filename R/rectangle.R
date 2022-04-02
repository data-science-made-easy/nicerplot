rectangle <- function(p) {
  print_debug_info(p)
  if (!is_set(p$rect_xleft)) return(p)
  
  for (i in seq_along(p$rect_xleft)) {
    graphics::rect(p$rect_xleft, p$rect_ybottom, p$rect_xright, p$rect_ytop, col = get_col_from_p(p, p$rect_col), border = get_col_from_p(p, p$rect_border))
  }
  
  p
}
