if (file.exists('box.xlsx') { # plot figures from Excel file:
  nicerplot::nplot('box.xlsx')
} else if (file.exists('box.RData') { # or plot figures directly in R:
  d <- dget('box.RData')
  nicerplot::nplot(d, style = c('box-plot, tall'), type = c('box'), title = c('Inkomenseffecten plannen\nsocialezekerheids- en belastingstelsel'), y_title = c('verandering in 2025 (%)'), turn = c('y'), open = FALSE)
}
