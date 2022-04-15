if (file.exists('area-order.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('area-order.xlsx')
} else if (file.exists('area-order.RData')) { # or plot figures directly in R:
  d <- dget('area-order.RData')
  nicerplot::nplot(d, type = c('area, area, area, area, area='), title = c('Cohorten omvatten veel asielmigranten'), y_title = c('aantal (x 1.000)'), legend_order = c(3, 1, 2), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
