if (file.exists('hello-world.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('hello-world.xlsx')
} else if (file.exists('hello-world.RData')) { # or plot figures directly in R:
  d <- dget('hello-world.RData')
  nicerplot::nplot(d, type = c('line'), title = c('Hello World'), x_title = c('x'), y_title = c('y'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
