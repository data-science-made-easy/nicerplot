if (file.exists('bar-group-label-horiz.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('bar-group-label-horiz.xlsx')
} else if (file.exists('bar-group-label-horiz.RData')) { # or plot figures directly in R:
  d <- dget('bar-group-label-horiz.RData')
  nicerplot::nplot(d, type = c('bar--'), title = c('VWO'), y_title = c('zakkans (%)'), hline_bold = c(0), legend_y = c(0.8), group_spacing = c(0.2), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
