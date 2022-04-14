if (file.exists('scatter-example.xlsx') { # plot figures from Excel file:
  nicerplot::nplot('scatter-example.xlsx')
} else if (file.exists('scatter-example.RData') { # or plot figures directly in R:
  d <- dget('scatter-example.RData')
  nicerplot::nplot(d, type = c('dot'), title = c('Phones per continent'), y_title = c('number'), open = FALSE)
}
