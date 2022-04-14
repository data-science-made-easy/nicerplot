if (file.exists('bar-bar-dot-whisker.xlsx') { # plot figures from Excel file:
  nicerplot::nplot('bar-bar-dot-whisker.xlsx')
} else if (file.exists('bar-bar-dot-whisker.RData') { # or plot figures directly in R:
  d <- dget('bar-bar-dot-whisker.RData')
  nicerplot::nplot(d, type = c('bar--, bar--, dot, whisker, whisker'), title = c('Verwacht verlies in verschillende scenario's'), y_title = c('Verlies (mld €)'), dot_size = c(0.7), legend_n_per_column = c(4), whisker_series = c(2), open = FALSE)
}
