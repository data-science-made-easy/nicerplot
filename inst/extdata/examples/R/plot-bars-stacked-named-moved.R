if (file.exists('bars-stacked-named-moved.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('bars-stacked-named-moved.xlsx')
} else if (file.exists('bars-stacked-named-moved.RData')) { # or plot figures directly in R:
  d <- dget('bars-stacked-named-moved.RData')
  nicerplot::nplot(d, type = c('bar=, bar--, bar--, bar=, bar--, bar--, bar='), title = c('Number of phones in the world'), bar_stack_name = c('The Americas'), bar_stack_index = c(1), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
