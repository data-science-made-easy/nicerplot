if (file.exists('bars-and-line-color.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('bars-and-line-color.xlsx')
} else if (file.exists('bars-and-line-color.RData')) { # or plot figures directly in R:
  d <- dget('bars-and-line-color.RData')
  nicerplot::nplot(d, type = c('bar=, bar=, bar=, bar=, bar=, line'), title = c('Groeibijdragen bestedingen'), y_title = c('%-punt bbp-groei'), name_col = c('bbp-groei=black'), line_lty = c(3), palette = c('red, blue, white, appletv'), lock = c('no'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
