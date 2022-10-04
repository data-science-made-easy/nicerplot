if (file.exists('legend-math-expression.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('legend-math-expression.xlsx')
} else if (file.exists('legend-math-expression.RData')) { # or plot figures directly in R:
  d <- dget('legend-math-expression.RData')
  nicerplot::nplot(d, style = c('english'), title = c('Mathematical expression in legend'), x_title = c('a.u.'), y_title = c('a.u.'), footnote = c('NB legend may be incorrectly formatted'), legend_n_per_column = c(4), legend_math = c('y'), grid_lines_lwd = c(-1), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
