if (file.exists('scatter-example.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('scatter-example.xlsx')
} else if (file.exists('scatter-example.RData')) { # or plot figures directly in R:
  d <- dget('scatter-example.RData')
  nicerplot::nplot(d, type = c('dot'), title = c('Phones per continent'), y_title = c('number'), style = c('default'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
