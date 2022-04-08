if (file.exists('bars-non-equidistant.xlsx') { # plot figures from Excel file:
  nicerplot::plot('bars-non-equidistant.xlsx')
} else if (file.exists('bars-non-equidistant.RData') { # or plot figures directly in R:
  d <- dget('bars-non-equidistant.RData')
  nicerplot::plot(d, type = c('bar--'), title = c('Number of phones in the world'), open = FALSE)
}
