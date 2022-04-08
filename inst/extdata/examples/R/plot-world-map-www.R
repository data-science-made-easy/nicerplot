if (file.exists('world-map-www.xlsx') { # plot figures from Excel file:
  nicerplot::plot('world-map-www.xlsx')
} else if (file.exists('world-map-www.RData') { # or plot figures directly in R:
  d <- dget('world-map-www.RData')
  nicerplot::plot(d, style = c('world-map-www, english'), title = c('World trade volume change last month'), footnote = c('Source: cpb.nl/en/worldtrademonitor'), open = FALSE)
}
