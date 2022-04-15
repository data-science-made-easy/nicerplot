if (file.exists('dot-whisker-double.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('dot-whisker-double.xlsx')
} else if (file.exists('dot-whisker-double.RData')) { # or plot figures directly in R:
  d <- dget('dot-whisker-double.RData')
  nicerplot::nplot(d, style = c('wide, english'), type = c('dot, dot, whisker, whisker, whisker, whisker'), title = c('Two series of whiskers in one plot'), x_title = c('year'), y_title = c('effect (a.u.)'), footnote = c('The whiskers of the two series don't overlap because their x-values are adapted by hand.'), x_lim = c(0.5, 15.5), dot_size = c(0.5), x_at = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15), hline_dash = c(0), legend_order = c(1, 3, 2), whisker_col = c('endeavour, rose'), whisker_legend_col = c('black'), whisker_legend_show_n = c(1), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
