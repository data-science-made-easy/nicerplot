if (file.exists('secondary-y-axis.xlsx') { # plot figures from Excel file:
  nicerplot::plot('secondary-y-axis.xlsx')
} else if (file.exists('secondary-y-axis.RData') { # or plot figures directly in R:
  d <- dget('secondary-y-axis.RData')
  nicerplot::plot(d, type = c('bar--, line'), title = c('Economische groei in Nederland'), y_title = c('mutatie in %'), x_lab_date_show = c('y'), x_ticks_date = c('years, quarters'), y_axis = c('l, r'), y_r_title = c('€ miljard'), open = FALSE)
}
