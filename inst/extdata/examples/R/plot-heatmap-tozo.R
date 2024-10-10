if (file.exists('heatmap-tozo.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('heatmap-tozo.xlsx')
} else if (file.exists('heatmap-tozo.RData')) { # or plot figures directly in R:
  d <- dget('heatmap-tozo.RData')
  nicerplot::nplot(d, type = c('heatmap'), title = c('Percentage bedrijven dat TOZO gebruikt'), x_title = c('eigen vermogen 2020 (deciel)'), y_title = c('eigen vermogen 2021 (deciel)'), style = c('default'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
