if (file.exists('bars-non-equidistant.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('bars-non-equidistant.xlsx')
} else if (file.exists('bars-non-equidistant.RData')) { # or plot figures directly in R:
  d <- dget('bars-non-equidistant.RData')
  nicerplot::nplot(d, type = c('bar--'), title = c('Number of phones in the world'), style = c('default'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
