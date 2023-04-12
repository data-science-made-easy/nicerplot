if (file.exists('corona-vmbo-impact-whisk-group.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('corona-vmbo-impact-whisk-group.xlsx')
} else if (file.exists('corona-vmbo-impact-whisk-group.RData')) { # or plot figures directly in R:
  d <- dget('corona-vmbo-impact-whisk-group.RData')
  nicerplot::nplot(d, type = c('bar--, bar--, whisker, whisker, whisker, whisker'), title = c('VMBO'), y_title = c('kans om te zakken (%)'), footnote = c('Please note: the two whiskers have a different meaning.'), footnote_col = c('rose'), turn = c('y'), legend_n_per_column = c(2), whisker_legend_show_n = c(2), style = c('default'), lock = c('no'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
