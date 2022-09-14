if (file.exists('area-multiple.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('area-multiple.xlsx')
} else if (file.exists('area-multiple.RData')) { # or plot figures directly in R:
  d <- dget('area-multiple.RData')
  nicerplot::nplot(d, type = c('line, area, area, line, area, area'), title = c('Two bandwiths in one plot'), line_lty = c(3, 3), style = c('default'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
