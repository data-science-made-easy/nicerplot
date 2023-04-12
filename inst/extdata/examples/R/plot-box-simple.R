if (file.exists('box-simple.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('box-simple.xlsx')
} else if (file.exists('box-simple.RData')) { # or plot figures directly in R:
  d <- dget('box-simple.RData')
  nicerplot::nplot(d, style = c('no-legend, wide'), type = c('box'), title = c('Kans om in risicogroep te zitten'), x_title = c('kenmerk'), y_title = c('toename in de kans om geraakt te worden t.o.v. het gemiddelde (%)'), turn = c('y'), box_col_all_equal = c('y'), box_quantiles = c(0.025, .5, .5, .5, .975), box_median_shape = c(19), box_median_col = c('rose'), box_median_lab_suffix = c('\s%'), hline_dash = c(0), box_median_lab_show = c('y'), box_median_lab_n_decimals = c(2), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
