if (file.exists('cbs-weeksterfte.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('cbs-weeksterfte.xlsx')
} else if (file.exists('cbs-weeksterfte.RData')) { # or plot figures directly in R:
  d <- dget('cbs-weeksterfte.RData')
  nicerplot::nplot(d, cbs_url = c('https://opendata.cbs.nl/statline/#/CBS/nl/dataset/70895ned/table?dl=45E64'), style = c('wide'), type = c('line'), title = c('Eerste indruk: corona treft ouderen buitenproportioneel'), y_title = c('Aantal overledenen per week'), footnote = c('De stippellijnen markeren de eerste piek (14 maart t/m 14 mei). Bron: opendata.cbs.nl.'), vline_dash_date = c('2020-03-14, 2020-05-14'), order = c(2, 3, 4), custom = c('points(rep(lubridate::decimal_date(as.Date("2020-01-11", origin = "1899-12-30")), 3), c(432, 967, 1966), col = "gray50", cex = 1)'), col_order = c(3, 1, 2), shading_suppress_x_date = c('2020-01-01, 2020-03-14, 2020-05-14, 2021-01-01'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
