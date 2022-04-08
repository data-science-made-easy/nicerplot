if (file.exists('world-map.xlsx') { # plot figures from Excel file:
  nicerplot::plot('world-map.xlsx')
} else if (file.exists('world-map.RData') { # or plot figures directly in R:
  d <- dget('world-map.RData')
  nicerplot::plot(d, style = c('world-map, english'), title = c('World import, customs or balance of payments (prices), change in july, 2020.'), footnote = c('Source: cpb.nl/en/cpb-world-trade-monitor-july-2020'), open = FALSE)
}
