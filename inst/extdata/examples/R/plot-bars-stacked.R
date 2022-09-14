if (file.exists('bars-stacked.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('bars-stacked.xlsx')
} else if (file.exists('bars-stacked.RData')) { # or plot figures directly in R:
  d <- dget('bars-stacked.RData')
  nicerplot::nplot(d, type = c('bar=, bar--, bar--, bar=, bar--, bar--, bar='), title = c('Number of phones in the world'), x_lab_as_text = c('y'), style = c('default'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
