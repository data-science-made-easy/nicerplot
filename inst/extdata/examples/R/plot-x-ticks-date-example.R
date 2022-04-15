if (file.exists('x-ticks-date-example.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('x-ticks-date-example.xlsx')
} else if (file.exists('x-ticks-date-example.RData')) { # or plot figures directly in R:
  d <- dget('x-ticks-date-example.RData')
  nicerplot::nplot(d, title = c('Groeibijdragen bestedingen'), y_title = c('%-punt bbp-groei'), footnote = c('x_ticks_date = years, quarters'), x_ticks_date = c('years, quarters'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
