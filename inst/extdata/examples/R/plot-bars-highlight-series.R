if (file.exists('bars-highlight-series.xlsx') { # plot figures from Excel file:
  nicerplot::nplot('bars-highlight-series.xlsx')
} else if (file.exists('bars-highlight-series.RData') { # or plot figures directly in R:
  d <- dget('bars-highlight-series.RData')
  nicerplot::nplot(d, type = c('bar='), title = c('Number of phones (Europe yellow)'), highlight_series = c(2), highlight_col = c('yellow'), open = FALSE)
}
