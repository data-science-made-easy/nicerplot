text_label <- function(p) {
  print_debug_info(p)
  if (!is_set(p$text_label)) return(p)

  # Check
  if (is_set(p$text_x) & is_set(p$text_x_date)) error_msg("Please use only one of text_x and text_x_date.")
  
  if (is_set(p$text_x_date)) {
    this_x <- lubridate::decimal_date(p$text_x_date)
  } else {
    this_x <- p$text_x
  }
  
  if (p$turn) {
    this_y <- this_x
    this_x <- p$text_y
  } else {
    this_y <- p$text_y
  }
  
  pos <- if (!is_set(p$text_pos)) NULL else p$text_pos
  
  if (!is_set(p$text_rotation)) {
    graphics::text(this_x, this_y, set_newline(p$text_label), family = p$font, pos = pos, col = get_col_from_p(p, p$text_col), srt = p$text_rotation, font = p$text_font_style, cex = p$text_font_size, offset = p$text_offset)
  } else {
    for (i in 1:length(p$text_label)) {
      this_pos <- if (1 < length(p$text_pos)) p$text_pos[i] else pos
      this_col <- if (1 < length(p$text_col)) get_col_from_p(p, p$text_col)[i] else get_col_from_p(p, p$text_col)
      this_srt <- if (1 < length(p$text_rotation)) p$text_rotation[i] else p$text_rotation
      this_stl <- if (1 < length(p$text_font_style)) p$text_font_style[i] else p$text_font_style
      this_cex <- if (1 < length(p$text_font_size)) p$text_font_size[i] else p$text_font_size
      this_off <- if (1 < length(p$text_offset)) p$text_offset[i] else p$text_offset
      
      graphics::text(this_x[i], this_y[i], set_newline(p$text_label[i]), family = p$font, pos = this_pos, col = this_col, srt = this_srt, font = this_stl, cex = this_cex, offset = this_off)
    }
  }
    
  p
}