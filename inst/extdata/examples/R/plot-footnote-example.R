if (file.exists('footnote-example.xlsx') { # plot figures from Excel file:
  nicerplot::plot('footnote-example.xlsx')
} else if (file.exists('footnote-example.RData') { # or plot figures directly in R:
  d <- dget('footnote-example.RData')
  nicerplot::plot(d, title = c('Toeslagen'), x_title = c('bruto huishoudinkomen (euro)'), y_title = c('jaarbedrag (euro)'), footnote = c('Bron: Koot en Gielen (2019), op basis van MIMOSI'), footnote_col = c('rose'), footnote_side = c('top'), footnote_align = c('center'), footnote_font_style = c(1), x_lab_big_mark_show = c('y'), lock = c('no'), open = FALSE)
}
