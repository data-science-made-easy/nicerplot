if (file.exists('discontinuity.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('discontinuity.xlsx')
} else if (file.exists('discontinuity.RData')) { # or plot figures directly in R:
  d <- dget('discontinuity.RData')
  nicerplot::nplot(d, type = c('line'), title = c('A discontinuity'), y_lim = c(0, 3), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
