if (file.exists('secondary-y-axis-y-r-lim.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('secondary-y-axis-y-r-lim.xlsx')
} else if (file.exists('secondary-y-axis-y-r-lim.RData')) { # or plot figures directly in R:
  d <- dget('secondary-y-axis-y-r-lim.RData')
  nicerplot::nplot(d, type = c('bar--, line'), title = c('The use of y_r_lim'), y_title = c('mutatie in %'), x_lab_date_show = c('y'), x_ticks_date = c('years, quarters'), y_axis = c('l, r'), y_r_title = c('€ miljard'), y_r_lim = c(674, 800), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
