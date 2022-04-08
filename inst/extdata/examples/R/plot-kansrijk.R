if (file.exists('kansrijk.xlsx') { # plot figures from Excel file:
  nicerplot::plot('kansrijk.xlsx')
} else if (file.exists('kansrijk.RData') { # or plot figures directly in R:
  d <- dget('kansrijk.RData')
  nicerplot::plot(d, style = c('kansrijk'), type = c('bar--'), y_title = c('%'), scale = c(100), turn = c('y'), bar_lab_show = c('y'), open = FALSE)
}
