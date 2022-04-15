if (file.exists('investment-nl.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('investment-nl.xlsx')
} else if (file.exists('investment-nl.RData')) { # or plot figures directly in R:
  d <- dget('investment-nl.RData')
  nicerplot::nplot(d, type = c('bar='), title = c('Investeringen in Nederland¹ door de zwaarst-\ngetroffen eurolanden in 2018 en vice versa'), x_title = c('¹Portfolio-obligaties en aandelen (< 5% totaal), en FDI in\neigen vermogen, incl. belastingconstructies als brievenbusfirma's.'), y_title = c('mld euro's'), footnote = c('Data: IMF, CDIS en CPIS | ESB'), legend_n_per_column = c(1), legend_y = c(1.3), group_spacing = c(0.5), x_title_v_shift = c(1.6), x_lab_font_size = c(0.85), x_title_align = c('left'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
