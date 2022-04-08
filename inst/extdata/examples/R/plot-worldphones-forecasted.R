if (file.exists('worldphones-forecasted.xlsx') { # plot figures from Excel file:
  nicerplot::plot('worldphones-forecasted.xlsx')
} else if (file.exists('worldphones-forecasted.RData') { # or plot figures directly in R:
  d <- dget('worldphones-forecasted.RData')
  nicerplot::plot(d, style = c('english'), type = c('line, bar=, bar=, bar=, bar=, bar=, bar='), title = c('Forecasted from 1958'), footnote = c('For aesthetical reasons and not cutting bars, we use forecast_x = 1957.5'), logo = c('y'), forecast_x = c(1957.5), open = FALSE)
}
