if (file.exists('cbs-weeksterfte-normalized.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('cbs-weeksterfte-normalized.xlsx')
} else if (file.exists('cbs-weeksterfte-normalized.RData')) { # or plot figures directly in R:
  d <- dget('cbs-weeksterfte-normalized.RData')
  nicerplot::nplot(d, cbs_url = c('https://opendata.cbs.nl/statline/#/CBS/nl/dataset/70895ned/table?dl=45E64'), style = c('wide'), type = c('line'), title = c('Tweede indruk coronadoden: relatief geen verschil 65-80 en 80+'), y_title = c('Gestandaardiseerd aantal overledenen per week'), footnote = c('Aantallen zijn hier gedeeld door respectieve aantallen in de week van 2020-01-11 (cirkel).'), footnote_col = c('rose'), scale = c(0.002314815, 0.001034126, 0.000508647), order = c(2, 3, 4), hline_dash = c(1), custom = c('points(lubridate::decimal_date(as.Date("2020-01-11", origin = "1899-12-30")), 1)'), col_order = c(3, 1, 2), x_shading_date = c('2020-03-14, 2020-05-14'), x_shading_col = c('anakiwa'), lock = c('no'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
