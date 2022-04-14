if (file.exists('fan-example.xlsx') { # plot figures from Excel file:
  nicerplot::nplot('fan-example.xlsx')
} else if (file.exists('fan-example.RData') { # or plot figures directly in R:
  d <- dget('fan-example.RData')
  nicerplot::nplot(d, style = c('fan'), title = c('Inflatie'), y_title = c('mutatie in %'), open = FALSE)
}
