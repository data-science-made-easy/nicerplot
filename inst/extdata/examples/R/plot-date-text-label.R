if (file.exists('date-text-label.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('date-text-label.xlsx')
} else if (file.exists('date-text-label.RData')) { # or plot figures directly in R:
  d <- dget('date-text-label.RData')
  nicerplot::nplot(d, title = c('Rentespreads op overheidsschuld'), y_title = c('%'), x_lim = c(2020.09, 2020.38), vline_dash_date = c('43908'), text_x_date = c(43908), text_y = c(4.5), text_pos = c(4), text_label = c('18-mrt'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
