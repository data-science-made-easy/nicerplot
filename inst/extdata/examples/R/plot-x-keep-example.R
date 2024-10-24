if (file.exists('x-keep-example.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('x-keep-example.xlsx')
} else if (file.exists('x-keep-example.RData')) { # or plot figures directly in R:
  d <- dget('x-keep-example.RData')
  nicerplot::nplot(d, title = c('Groeibijdragen bestedingen'), y_title = c('%-punt bbp-groei'), footnote = c('x_keep = 2010, 2014'), style = c('default'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
