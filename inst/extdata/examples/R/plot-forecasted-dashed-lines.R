if (file.exists('forecasted-dashed-lines.xlsx') { # plot figures from Excel file:
  nicerplot::nplot('forecasted-dashed-lines.xlsx')
} else if (file.exists('forecasted-dashed-lines.RData') { # or plot figures directly in R:
  d <- dget('forecasted-dashed-lines.RData')
  nicerplot::nplot(d, title = c('Bbp tijdens crises'), x_title = c('maand'), y_title = c('index'), forecast_x = c(5), hline_bold = c(100), open = FALSE)
}
