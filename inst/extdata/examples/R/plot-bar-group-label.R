if (file.exists('bar-group-label.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('bar-group-label.xlsx')
} else if (file.exists('bar-group-label.RData')) { # or plot figures directly in R:
  d <- dget('bar-group-label.RData')
  nicerplot::nplot(d, type = c('bar--'), title = c('VWO'), y_title = c('zakkans (%)'), turn = c('y'), hline_bold = c(0), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
