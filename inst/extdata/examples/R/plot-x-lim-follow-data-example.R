if (file.exists('x-lim-follow-data-example.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('x-lim-follow-data-example.xlsx')
} else if (file.exists('x-lim-follow-data-example.RData')) { # or plot figures directly in R:
  d <- dget('x-lim-follow-data-example.RData')
  nicerplot::nplot(d, title = c('Groeibijdragen bestedingen'), y_title = c('%-punt bbp-groei'), footnote = c('x_lim_follow_data = y'), x_lim_follow_data = c('y'), style = c('default'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
