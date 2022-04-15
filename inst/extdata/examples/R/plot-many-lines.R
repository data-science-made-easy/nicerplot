if (file.exists('many-lines.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('many-lines.xlsx')
} else if (file.exists('many-lines.RData')) { # or plot figures directly in R:
  d <- dget('many-lines.RData')
  nicerplot::nplot(d, style = c('wide'), title = c('Coloring many series in a clear and unique fashion is challenging'), palette = c('kansrijk, extra'), lock = c('no'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
