if (file.exists('arrows-per-pct.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('arrows-per-pct.xlsx')
} else if (file.exists('arrows-per-pct.RData')) { # or plot figures directly in R:
  d <- dget('arrows-per-pct.RData')
  nicerplot::nplot(d, title = c('Spanning op arbeidsmarkt blijft toenemen'), x_title = c('werkloosheidspercentage'), y_title = c('vacaturegraad (vacatures per 1000 werknemersbanen)'), arrow_col = c('black, rose, rose, black'), arrow_position_pct = c(10, 30, 50, 90), style = c('default'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
