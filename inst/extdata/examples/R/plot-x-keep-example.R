if (file.exists('x-keep-example.xlsx') { # plot figures from Excel file:
  nicerplot::plot('x-keep-example.xlsx')
} else if (file.exists('x-keep-example.RData') { # or plot figures directly in R:
  d <- dget('x-keep-example.RData')
  nicerplot::plot(d, title = c('Groeibijdragen bestedingen'), y_title = c('%-punt bbp-groei'), footnote = c('x_keep = 2010, 2014'), open = FALSE)
}
