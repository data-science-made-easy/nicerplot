if (file.exists('bars-equidistant.xlsx') { # plot figures from Excel file:
  nicerplot::nplot('bars-equidistant.xlsx')
} else if (file.exists('bars-equidistant.RData') { # or plot figures directly in R:
  d <- dget('bars-equidistant.RData')
  nicerplot::nplot(d, type = c('bar--'), title = c('Number of phones in the world'), x_lab_as_text = c('y'), open = FALSE)
}
