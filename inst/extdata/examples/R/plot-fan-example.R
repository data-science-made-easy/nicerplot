if (file.exists('fan-example.xlsx') { # plot figures from Excel file:
  nicerplot::plot('fan-example.xlsx')
} else if (file.exists('fan-example.RData') { # or plot figures directly in R:
  d <- dget('fan-example.RData')
  nicerplot::plot(d, style = c('fan'), title = c('Inflatie'), y_title = c('mutatie in %'), open = FALSE)
}
