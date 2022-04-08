if (file.exists('secondary-y-axis-not-auto.xlsx') { # plot figures from Excel file:
  nicerplot::plot('secondary-y-axis-not-auto.xlsx')
} else if (file.exists('secondary-y-axis-not-auto.RData') { # or plot figures directly in R:
  d <- dget('secondary-y-axis-not-auto.RData')
  nicerplot::plot(d, type = c('bar--, line'), title = c('No auto-scaling'), y_title = c('mutatie in %'), x_lab_date_show = c('y'), x_ticks_date = c('years, quarters'), y_axis = c('l, r'), y_r_title = c('€ miljard'), y_r_scale_auto = c('n'), open = FALSE)
}
