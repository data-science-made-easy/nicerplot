if (file.exists('custom-example.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('custom-example.xlsx')
} else if (file.exists('custom-example.RData')) { # or plot figures directly in R:
  d <- dget('custom-example.RData')
  nicerplot::nplot(d, style = c('wide, no-legend, english'), type = c('dot, param'), title = c('Older workers more productive?'), x_title = c('age (years)'), y_title = c('productivity (a.u.)'), dot_size = c(0), text_x = c(25, 55, 10, 10, 10, 10, 10), text_y = c(1.5, 2.3, 3.33, 3.13, 2.93, 2.73, 2.53), text_pos = c(1, 1, 4, 4, 4, 4, 4), text_label = c('Detailhandel;; Overheid,\nonderwijs,\nwetenschap;; Number of observations;; 4;; 8;; 12;; 16'), text_font_style = c(3, 3, 2, 1, 1, 1, 1), custom = c('points(p$data[, 1], p$data[, 2], pch = 19, cex = p$data[, 3] / 16, col = get_col_from_p(p, "endeavour")); points(rep(14, 4), c(3.13, 2.93, 2.73, 2.53), pch = 19, cex = 1:4 / 4, col = get_col_from_p(p, "rose"))'), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
