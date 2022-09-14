if (file.exists('worldphones-forecasted-area.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('worldphones-forecasted-area.xlsx')
} else if (file.exists('worldphones-forecasted-area.RData')) { # or plot figures directly in R:
  d <- dget('worldphones-forecasted-area.RData')
  nicerplot::nplot(d, type = c('line, area=, area=, area=, area=, area=, area='), title = c('Geraamd vanaf 1958'), x_lim_follow_data = c('y'), logo = c('y'), forecast_x = c(1958), style = c('default'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
