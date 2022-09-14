if (file.exists('arrows-per-series.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('arrows-per-series.xlsx')
} else if (file.exists('arrows-per-series.RData')) { # or plot figures directly in R:
  d <- dget('arrows-per-series.RData')
  nicerplot::nplot(d, title = c('Spanning op arbeidsmarkt blijft toenemen'), x_title = c('werkloosheidspercentage'), y_title = c('vacaturegraad (vacatures per 1000 werknemersbanen)'), arrow_n = c(1, 0, 1, 2, 3), arrow_col = c('black'), style = c('default'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
