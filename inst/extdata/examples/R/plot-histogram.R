if (file.exists('histogram.xlsx') { # plot figures from Excel file:
  nicerplot::plot('histogram.xlsx')
} else if (file.exists('histogram.RData') { # or plot figures directly in R:
  d <- dget('histogram.RData')
  nicerplot::plot(d, style = c('histogram, no-legend'), title = c('Standard normal distribution'), y_title = c('Number of observations (a.u.)'), footnote = c('µ = 0, σ = 1'), open = FALSE)
}
