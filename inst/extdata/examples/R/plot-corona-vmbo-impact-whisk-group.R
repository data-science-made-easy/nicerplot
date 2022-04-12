if (file.exists('corona-vmbo-impact-whisk-group.xlsx') { # plot figures from Excel file:
  nicerplot::plot('corona-vmbo-impact-whisk-group.xlsx')
} else if (file.exists('corona-vmbo-impact-whisk-group.RData') { # or plot figures directly in R:
  d <- dget('corona-vmbo-impact-whisk-group.RData')
  nicerplot::plot(d, type = c('bar--, bar--, whisker, whisker, whisker, whisker'), title = c('VMBO'), y_title = c('kans om te zakken (%)'), footnote = c('Please note: whiskers are different.'), footnote_col = c('rose'), turn = c('y'), legend_n_per_column = c(2), whisker_legend_show_n = c(2), lock = c('no'), open = FALSE)
}