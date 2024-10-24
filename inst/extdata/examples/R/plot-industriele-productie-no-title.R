if (file.exists('industriele-productie-no-title.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('industriele-productie-no-title.xlsx')
} else if (file.exists('industriele-productie-no-title.RData')) { # or plot figures directly in R:
  d <- dget('industriele-productie-no-title.RData')
  nicerplot::nplot(d, style = c('no-title'), type = c('line'), title = c('Industriële productie en detailhandel'), y_title = c('geïndexeerd (2015=100)'), x_lim_follow_data = c('y'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
