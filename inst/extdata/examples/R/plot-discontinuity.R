if (file.exists('discontinuity.xlsx') { # plot figures from Excel file:
  nicerplot::plot('discontinuity.xlsx')
} else if (file.exists('discontinuity.RData') { # or plot figures directly in R:
  d <- dget('discontinuity.RData')
  nicerplot::plot(d, type = c('line'), title = c('A discontinuity'), y_lim = c(0, 3), open = FALSE)
}
