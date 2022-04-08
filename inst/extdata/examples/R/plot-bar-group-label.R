if (file.exists('bar-group-label.xlsx') { # plot figures from Excel file:
  nicerplot::plot('bar-group-label.xlsx')
} else if (file.exists('bar-group-label.RData') { # or plot figures directly in R:
  d <- dget('bar-group-label.RData')
  nicerplot::plot(d, type = c('bar--'), title = c('VWO'), y_title = c('zakkans (%)'), turn = c('y'), hline_bold = c(0), open = FALSE)
}
