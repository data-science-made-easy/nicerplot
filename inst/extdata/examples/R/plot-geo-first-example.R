if (file.exists('geo-first-example.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('geo-first-example.xlsx')
} else if (file.exists('geo-first-example.RData')) { # or plot figures directly in R:
  d <- dget('geo-first-example.RData')
  nicerplot::nplot(d, style = c('map'), cbs_map = c('arbeidsmarktregio'), cbs_map_year = c(2020), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
