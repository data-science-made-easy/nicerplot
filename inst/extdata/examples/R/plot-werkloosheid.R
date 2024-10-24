if (file.exists('werkloosheid.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('werkloosheid.xlsx')
} else if (file.exists('werkloosheid.RData')) { # or plot figures directly in R:
  d <- dget('werkloosheid.RData')
  nicerplot::nplot(d, type = c('line'), title = c('Werkloosheid'), y_title = c('% beroepsbevolking'), style = c('default'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
