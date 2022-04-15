if (file.exists('usarrests.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('usarrests.xlsx')
} else if (file.exists('usarrests.RData')) { # or plot figures directly in R:
  d <- dget('usarrests.RData')
  nicerplot::nplot(d, style = c('tall'), type = c('bar='), title = c('Violent crime rates in the USA'), x_title = c('state'), y_title = c('Number per 100,000'), turn = c('y'), logo = c('y'), order = c(1, 2, 4), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
