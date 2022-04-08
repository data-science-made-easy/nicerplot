if (file.exists('oversterfte.xlsx') { # plot figures from Excel file:
  nicerplot::plot('oversterfte.xlsx')
} else if (file.exists('oversterfte.RData') { # or plot figures directly in R:
  d <- dget('oversterfte.RData')
  nicerplot::plot(d, type = c('line, line, area, area'), title = c('Oversterfte in 2020'), x_title = c('week'), y_title = c('sterfgevallen per week'), footnote = c('Bron: cbs.nl/nl-nl/faq/corona/medisch/hoeveel-sterfgevallen-zijn-er-per-week'), x_lim = c(0, 53), line_lty = c(1, 3), hline_bold = c(0), vline_dash = c(41), vline_dash_col = c('rose'), text_x = c(42), text_y = c(4200), text_pos = c(2), text_label = c('12 oktober'), text_col = c('rose'), palette = c('rose, endeavour, anakiwa'), lock = c('no'), open = FALSE)
}
