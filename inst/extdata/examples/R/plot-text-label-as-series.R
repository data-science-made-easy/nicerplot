if (file.exists('text-label-as-series.xlsx') { # plot figures from Excel file:
  nicerplot::nplot('text-label-as-series.xlsx')
} else if (file.exists('text-label-as-series.RData') { # or plot figures directly in R:
  d <- dget('text-label-as-series.RData')
  nicerplot::nplot(d, style = c('no-legend'), type = c('dot, param'), title = c('Overlapping labels (NL, PT)'), x_title = c('Overdrachtsbelasting (%)'), y_title = c('Aantal transacties per 1000 inwoners'), x_lim = c(0, 11), dot_size = c(0.8), label_font_size = c(0.9), rect_xleft = c(1.75), rect_ybottom = c(10.5), rect_xright = c(3), rect_ytop = c(14), rect_col = c('yellow'), open = FALSE)
}
