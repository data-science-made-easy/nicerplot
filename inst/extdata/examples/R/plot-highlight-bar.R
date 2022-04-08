if (file.exists('highlight-bar.xlsx') { # plot figures from Excel file:
  nicerplot::plot('highlight-bar.xlsx')
} else if (file.exists('highlight-bar.RData') { # or plot figures directly in R:
  d <- dget('highlight-bar.RData')
  nicerplot::plot(d, type = c('bar--'), title = c('Europese steunpakketten'), y_title = c('% bbp'), turn = c('y'), highlight_series = c(1), highlight_x = c('7'), open = FALSE)
}
