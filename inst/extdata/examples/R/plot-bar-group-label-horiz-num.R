if (file.exists('bar-group-label-horiz-num.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('bar-group-label-horiz-num.xlsx')
} else if (file.exists('bar-group-label-horiz-num.RData')) { # or plot figures directly in R:
  d <- dget('bar-group-label-horiz-num.RData')
  nicerplot::nplot(d, type = c('bar='), title = c('Tozo'), x_title = c('deciel'), y_title = c('%'), first_col_grouping = c('y'), x_lab_as_text = c('y'), group_spacing = c(1), style = c('default'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
