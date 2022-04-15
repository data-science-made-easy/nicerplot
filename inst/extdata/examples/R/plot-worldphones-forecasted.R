if (file.exists('worldphones-forecasted.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('worldphones-forecasted.xlsx')
} else if (file.exists('worldphones-forecasted.RData')) { # or plot figures directly in R:
  d <- dget('worldphones-forecasted.RData')
  nicerplot::nplot(d, style = c('english'), type = c('line, bar=, bar=, bar=, bar=, bar=, bar='), title = c('Forecasted from 1958'), footnote = c('For aesthetical reasons and not cutting bars, we use forecast_x = 1957.5'), logo = c('y'), forecast_x = c(1957.5), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
