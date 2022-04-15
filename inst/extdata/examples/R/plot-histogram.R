if (file.exists('histogram.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('histogram.xlsx')
} else if (file.exists('histogram.RData')) { # or plot figures directly in R:
  d <- dget('histogram.RData')
  nicerplot::nplot(d, style = c('histogram, no-legend'), title = c('Standard normal distribution'), y_title = c('Number of observations (a.u.)'), footnote = c('mu = 0, sigma = 1'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
