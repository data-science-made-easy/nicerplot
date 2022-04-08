if (file.exists('partly-dashed-line.xlsx') { # plot figures from Excel file:
  nicerplot::plot('partly-dashed-line.xlsx')
} else if (file.exists('partly-dashed-line.RData') { # or plot figures directly in R:
  d <- dget('partly-dashed-line.RData')
  nicerplot::plot(d, title = c('Partly dashed line'), x_title = c('maand'), y_title = c('index'), line_lty = c(1, 3, 1), hline_bold = c(100), legend_order = c(1, 3), palette = c('endeavour, endeavour, rose'), lock = c('no'), open = FALSE)
}
