if (file.exists('dot-whisker.xlsx') { # plot figures from Excel file:
  nicerplot::plot('dot-whisker.xlsx')
} else if (file.exists('dot-whisker.RData') { # or plot figures directly in R:
  d <- dget('dot-whisker.RData')
  nicerplot::plot(d, style = c('no-legend'), type = c('dot, whisker, whisker'), title = c('Verwacht verlies in verschillende scenario's'), y_title = c('Verlies (mld €)'), turn = c('y'), dot_size = c(0.7), whisker_col = c('endeavour'), open = FALSE)
}
