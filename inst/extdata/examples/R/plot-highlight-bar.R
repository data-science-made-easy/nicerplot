if (file.exists('highlight-bar.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('highlight-bar.xlsx')
} else if (file.exists('highlight-bar.RData')) { # or plot figures directly in R:
  d <- dget('highlight-bar.RData')
  nicerplot::nplot(d, type = c('bar--'), title = c('Europese steunpakketten'), y_title = c('% bbp'), turn = c('y'), highlight_series = c(1), highlight_x = c('7'), style = c('default'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
