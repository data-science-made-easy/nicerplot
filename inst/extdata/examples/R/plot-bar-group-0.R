if (file.exists('bar-group-0.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('bar-group-0.xlsx')
} else if (file.exists('bar-group-0.RData')) { # or plot figures directly in R:
  d <- dget('bar-group-0.RData')
  nicerplot::nplot(d, type = c('bar--'), title = c('VWO'), y_title = c('zakkans (%)'), turn = c('y'), x_ticks = c(1, 2, 4, 5, 6, 8, 9, 10, 12, 13), style = c('default'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
