if (file.exists('world-map-www.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('world-map-www.xlsx')
} else if (file.exists('world-map-www.RData')) { # or plot figures directly in R:
  d <- dget('world-map-www.RData')
  nicerplot::nplot(d, style = c('world-map-www, english'), title = c('World trade volume change last month'), footnote = c('Source: cpb.nl/en/worldtrademonitor'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
