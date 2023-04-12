if (file.exists('heatmap-phones.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('heatmap-phones.xlsx')
} else if (file.exists('heatmap-phones.RData')) { # or plot figures directly in R:
  d <- dget('heatmap-phones.RData')
  nicerplot::nplot(d, type = c('heatmap'), title = c('Number of phones in the world'), x_title = c('year'), y_title = c('Part of world'), heatmap_x_axis_asis = c('T'), heatmap_z_lim = c(0, 90000), heatmap_legend_labels_n_decimals = c(0), style = c('default'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
