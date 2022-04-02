is_label <- function(type) is.element(type, LABEL)

label_pre <- function(p) {
  print_debug_info(p)
  if (!is_set(p$label)) return(p)  
  
  # If only one value for e.g. aligment, then use this value everywhere
  if (1 == length(p$label_align))      p$label_align      <- rep(p$label_align,      length(p$label))
  if (1 == length(p$label_offset))     p$label_offset     <- rep(p$label_offset,     length(p$label))
  if (1 == length(p$label_col))        p$label_col        <- rep(p$label_col,        length(p$label))
  if (1 == length(p$label_rotation))   p$label_rotation   <- rep(p$label_rotation,   length(p$label))
  if (1 == length(p$label_font_style)) p$label_font_style <- rep(p$label_font_style, length(p$label))
  if (1 == length(p$label_font_size))  p$label_font_size  <- rep(p$label_font_size,  length(p$label))

  p
}

label <- function(p) {
  print_debug_info(p)
  if (!is_set(p$label)) return(p)
    
    
  for (i in seq_along(p$label)) {
    y <- p$y[, p$label_series_n]
    
    # handle turn
    x <- if (p$turn) y   else p$x
    y <- if (p$turn) p$x else y
    
    this_align <- if (0 == p$label_align[i]) NULL else p$label_align[i]
    
    graphics::text(x[i], y[i], p$label[i], family = p$font, pos = this_align, col = get_col_from_p(p, p$label_col[i]), srt = p$label_rotation[i], font = p$label_font_style[i], cex = p$label_font_size[i], offset = p$label_offset)
  }
  
  p
}