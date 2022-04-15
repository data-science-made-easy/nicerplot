if (file.exists('ppower.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('ppower.xlsx')
} else if (file.exists('ppower.RData')) { # or plot figures directly in R:
  d <- dget('ppower.RData')
  nicerplot::nplot(d, style = c('ppower'), y_at = c(-50, -40, -30, -20, -10, 0, 10, 20, 30, 40, 50), x_keep = c(0, 140), y_keep = c(-50, 50), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
