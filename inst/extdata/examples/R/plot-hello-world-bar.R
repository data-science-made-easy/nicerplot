if (file.exists('hello-world-bar.xlsx') { # plot figures from Excel file:
  nicerplot::plot('hello-world-bar.xlsx')
} else if (file.exists('hello-world-bar.RData') { # or plot figures directly in R:
  d <- dget('hello-world-bar.RData')
  nicerplot::plot(d, style = c('no-title'), type = c('bar='), x_title = c('x'), y_title = c('y'), turn = c('y'), open = FALSE)
}
