if (file.exists('world-map-www-value.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('world-map-www-value.xlsx')
} else if (file.exists('world-map-www-value.RData')) { # or plot figures directly in R:
  d <- dget('world-map-www-value.RData')
  nicerplot::nplot(d, style = c('world-map-www, english'), title = c('World trade volume change last month:'), footnote = c('Source: cpb.nl/en/worldtrademonitor'), world_map_value = c(3.3), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
