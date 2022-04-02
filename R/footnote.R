footnote <- function(p) {
  print_debug_info(p)
  if (!is_set(p$footnote)) return(p)
  
  
  if ("left"   == p$footnote_align) {
    x   <- p$footnote_x / p$width
    adj <- 0
  }
  if ("center" == p$footnote_align) {
    x   <- 1/2
    adj <- 1/2
  }
  if ("right"  == p$footnote_align) {
    x   <- 1 - p$footnote_x / p$width
    adj <- 1
  }
  if ("bottom" == p$footnote_side)  y <- p$footnote_y / p$height
  if ("top"    == p$footnote_side)  {
    y   <- 1 - p$footnote_y / p$height
    adj <- c(1/2, adj)
  }
  
  graphics::text(x, y, labels = p$footnote, adj = adj, font = p$footnote_font_style, cex = p$footnote_font_size, col = get_col_from_p(p, p$footnote_col), family = p$font)
  
  p
}