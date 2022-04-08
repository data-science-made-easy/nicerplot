if (file.exists('line-diamond-color.xlsx') { # plot figures from Excel file:
  nicerplot::plot('line-diamond-color.xlsx')
} else if (file.exists('line-diamond-color.RData') { # or plot figures directly in R:
  d <- dget('line-diamond-color.RData')
  nicerplot::plot(d, type = c('line'), title = c('Number of phones US vs. Europe'), line_symbol = c(0, 18), line_symbol_col = c('NA, brown'), order = c(1, 2), open = FALSE)
}
