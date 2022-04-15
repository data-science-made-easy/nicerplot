if (file.exists('many-bars.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('many-bars.xlsx')
} else if (file.exists('many-bars.RData')) { # or plot figures directly in R:
  d <- dget('many-bars.RData')
  nicerplot::nplot(d, style = c('wide'), type = c('line, bar=, bar=, bar=, bar=, bar=, bar=, bar='), title = c('Decompositie gemiddelde marginale belastingdruk werknemers 2021 '), x_title = c('individueel bruto jaarinkomen (euro)'), y_title = c('%'), highlight_series = c(1), bar_gap_fraction = c(0.5), x_scale = c(1000), x_lab_big_mark_show = c('y'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
