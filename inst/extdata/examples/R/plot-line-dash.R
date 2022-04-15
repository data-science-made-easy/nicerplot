if (file.exists('line-dash.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('line-dash.xlsx')
} else if (file.exists('line-dash.RData')) { # or plot figures directly in R:
  d <- dget('line-dash.RData')
  nicerplot::nplot(d, style = c('y-right'), type = c('line'), title = c('Six different line types'), y_lab = c('1; 2; 3; 4; 5; 6;'), footnote = c('Please use line_lty = 3 for CPB-figures'), footnote_col = c('rose'), x_lim_follow_data = c('y'), line_lty = c(1, 2, 3, 4, 5, 6), y_r_lab = c('; 1; 2; 3; 4; 5; 6'), x_axis_show = c('n'), lock = c('no'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
