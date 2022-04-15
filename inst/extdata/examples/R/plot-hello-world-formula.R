if (file.exists('hello-world-formula.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('hello-world-formula.xlsx')
} else if (file.exists('hello-world-formula.RData')) { # or plot figures directly in R:
  d <- dget('hello-world-formula.RData')
  nicerplot::nplot(d, type = c('line'), title = c('Hello World'), x_title = c('x'), y_title = c('y'), hline_bold = c(0), formula = c('10 * sin(p$data[, 1])'), formula_name = c('sinus'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
