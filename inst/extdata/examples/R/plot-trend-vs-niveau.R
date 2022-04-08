if (file.exists('trend-vs-niveau.xlsx') { # plot figures from Excel file:
  nicerplot::plot('trend-vs-niveau.xlsx')
} else if (file.exists('trend-vs-niveau.RData') { # or plot figures directly in R:
  d <- dget('trend-vs-niveau.RData')
  nicerplot::plot(d, style = c('no-title'), type = c('line'), x_title = c('tijd'), y_title = c('niveau'), line_lty = c(2, 1, 1), hline_bold = c(100), x_axis_show = c('n'), y_axis_show = c('n'), open = FALSE)
}
