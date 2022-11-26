if (file.exists('secondary-y-axis-not-auto.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('secondary-y-axis-not-auto.xlsx')
} else if (file.exists('secondary-y-axis-not-auto.RData')) { # or plot figures directly in R:
  d <- dget('secondary-y-axis-not-auto.RData')
  nicerplot::nplot(d, type = c('bar--, line'), title = c('No auto-scaling'), y_title = c('mutatie in %'), x_lab_date_show = c('y'), x_ticks_date = c('years, quarters'), y_axis = c('l, r'), y_r_title = c('€ miljard'), y_r_scale_auto = c('n'), x_date_format = c('yyyy'), y_r_n_decimals = c(1), style = c('default'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
