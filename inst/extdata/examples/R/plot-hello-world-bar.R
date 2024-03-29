if (file.exists('hello-world-bar.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('hello-world-bar.xlsx')
} else if (file.exists('hello-world-bar.RData')) { # or plot figures directly in R:
  d <- dget('hello-world-bar.RData')
  nicerplot::nplot(d, style = c('no-title'), type = c('bar='), x_title = c('x'), y_title = c('y'), turn = c('y'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
