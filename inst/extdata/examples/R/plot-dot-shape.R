if (file.exists('dot-shape.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('dot-shape.xlsx')
} else if (file.exists('dot-shape.RData')) { # or plot figures directly in R:
  d <- dget('dot-shape.RData')
  nicerplot::nplot(d, style = c('x-top'), type = c('bar=, bar=, bar=, bar=, bar=, dot'), title = c('Verlies van banken na afschrijving 20% van de\noverheidsschuld van GIIPS-landen'), x_title = c('land'), y_title = c('% van EV'), footnote = c('Bron: EBA Transparency Exercise'), scale = c(1, 1, 1, 1, 1, 100), turn = c('y'), y_axis = c('r, r, r, r, r, l'), y_r_title = c('mld euro'), highlight_series = c(6), dot_shape = c(18), y_at = c(0, 10, 20, 30, 40, 50, 60), x_title_align = c('left'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
