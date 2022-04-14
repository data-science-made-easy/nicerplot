if (file.exists('x-lim-example.xlsx') { # plot figures from Excel file:
  nicerplot::nplot('x-lim-example.xlsx')
} else if (file.exists('x-lim-example.RData') { # or plot figures directly in R:
  d <- dget('x-lim-example.RData')
  nicerplot::nplot(d, title = c('Groeibijdragen bestedingen'), y_title = c('%-punt bbp-groei'), footnote = c('x_lim = 2010, 2014'), x_lim = c(2010, 2014), open = FALSE)
}
