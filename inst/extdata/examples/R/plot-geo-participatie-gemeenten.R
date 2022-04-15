if (file.exists('geo-participatie-gemeenten.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('geo-participatie-gemeenten.xlsx')
} else if (file.exists('geo-participatie-gemeenten.RData')) { # or plot figures directly in R:
  d <- dget('geo-participatie-gemeenten.RData')
  nicerplot::nplot(d, style = c('map'), title = c('Participatie gemeenten'), footnote = c('Jaar 2018'), geo_cbs_map = c('gemeente_2018'), name = c('niet;;wel'), legend_order = c(2, 1), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
