if (file.exists('bars-and-line.xlsx') { # plot figures from Excel file:
  nicerplot::plot('bars-and-line.xlsx')
} else if (file.exists('bars-and-line.RData') { # or plot figures directly in R:
  d <- dget('bars-and-line.RData')
  nicerplot::plot(d, type = c('bar=, bar=, bar=, bar=, bar=, line'), title = c('Groeibijdragen bestedingen'), y_title = c('%-punt bbp-groei'), name_col = c('bbp-groei=black'), line_lty = c(3), open = FALSE)
}
