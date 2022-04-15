if (file.exists('bars-and-line-turn.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('bars-and-line-turn.xlsx')
} else if (file.exists('bars-and-line-turn.RData')) { # or plot figures directly in R:
  d <- dget('bars-and-line-turn.RData')
  nicerplot::nplot(d, type = c('bar=, bar=, bar=, bar=, bar=, line'), title = c('Groeibijdragen bestedingen'), y_title = c('%-punt bbp-groei'), turn = c('y'), name_col = c('bbp-groei=black'), line_lty = c(3), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
