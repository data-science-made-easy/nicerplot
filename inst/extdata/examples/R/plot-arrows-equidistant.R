if (file.exists('arrows-equidistant.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('arrows-equidistant.xlsx')
} else if (file.exists('arrows-equidistant.RData')) { # or plot figures directly in R:
  d <- dget('arrows-equidistant.RData')
  nicerplot::nplot(d, title = c('Spanning op arbeidsmarkt blijft toenemen'), x_title = c('werkloosheidspercentage'), y_title = c('vacaturegraad (vacatures per 1000 werknemersbanen)'), arrow_n = c(5), style = c('default'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
