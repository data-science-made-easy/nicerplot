if (file.exists('typography.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('typography.xlsx')
} else if (file.exists('typography.RData')) { # or plot figures directly in R:
  d <- dget('typography.RData')
  nicerplot::nplot(d, style = c('no-legend'), type = c('bar--'), title = c('{x,y}_lab_{bold,italic}'), y_at = c(1, 2, 3, 4), x_lab_bold = c(2, 4), x_lab_italic = c(3, 4), y_lab_bold = c(2, 4), y_lab_italic = c(3, 4), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
