logo_pre <- function(p) {
  print_debug_info(p)
  if (!p$logo) return(p)

  # Extend margin for logo
  p$margin_north <- p$margin_north + p$logo_height
  
  # Further extend if world-map-www
  if (is_world_map_www(p)) p$margin_north <- p$margin_north + .1
  
  return(p)
}

logo <- function(p) {
  print_debug_info(p)
  if (!p$logo) return(p)

  logo_matrix <- png::readPNG("./img/rijkslogo.png", T) #

  # Keep aspect ratio, given logo_height
  w_aspect <- (p$logo_height * ncol(logo_matrix) / nrow(logo_matrix)) / p$width

  graphics::rasterImage(image = logo_matrix, xleft = .5 - (w_aspect / 2), xright = .5 + (w_aspect / 2), ybottom = 1 - p$logo_height / p$height, ytop = 1, interpolate = T) # Place logo top middle
  
  # txt <- if (is.element("english", p$style)) p$logo_text_en else p$logo_text_nl
#   txt <- stringr::str_replace_all(txt, "\\\\n", "\n")
#
#   text(.5 + (w_aspect / 2) * 1.3, 1 - p$logo_height / p$height * .5, labels = txt, adj = c(0, 1), cex = .85, family = p$font)
#
  txt <- if (is.element("english", p$style)) p$logo_text_en else p$logo_text_nl
  txt <- stringr::str_split(txt, "\\\\n")[[1]]
  graphics::text(.5 + (w_aspect / 2) * 1.3, 1 - p$logo_height / p$height * .5, labels = txt[1], adj = c(0, 1), cex = .85, family = p$font)
  if (1 < length(txt)) graphics::text(.5 + (w_aspect / 2) * 1.3, 1 - p$logo_height / p$height * .5 - 1.5 * graphics::strheight("M", family = p$font, cex = .85, unit = "inches") / grDevices::cm(1), labels = txt[2], adj = c(0, 1), cex = .85, family = p$font)
  
  p
}
