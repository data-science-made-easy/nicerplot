if (file.exists('dot-whisker.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('dot-whisker.xlsx')
} else if (file.exists('dot-whisker.RData')) { # or plot figures directly in R:
  d <- dget('dot-whisker.RData')
  nicerplot::nplot(d, style = c('no-legend'), type = c('dot, whisker, whisker'), title = c('Verwacht verlies in verschillende scenario's'), y_title = c('Verlies (mld €)'), turn = c('y'), dot_size = c(0.7), whisker_col = c('endeavour'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
