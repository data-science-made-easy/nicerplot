if (file.exists('heatmap-middle.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('heatmap-middle.xlsx')
} else if (file.exists('heatmap-middle.RData')) { # or plot figures directly in R:
  d <- dget('heatmap-middle.RData')
  nicerplot::nplot(d, type = c('heatmap'), title = c('Heatmap stressing middle values'), x_title = c('first variable (unit)'), y_title = c('second variable (unit)'), footnote = c('mexican hat pointing down (left) and up (right)'), palette = c('palette_heatmap_middle'), style = c('default'), lock = c('no'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
