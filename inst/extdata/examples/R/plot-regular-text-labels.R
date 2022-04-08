if (file.exists('regular-text-labels.xlsx') { # plot figures from Excel file:
  nicerplot::plot('regular-text-labels.xlsx')
} else if (file.exists('regular-text-labels.RData') { # or plot figures directly in R:
  d <- dget('regular-text-labels.RData')
  nicerplot::plot(d, title = c('Industriële productie en detailhandel'), y_title = c('geïndexeerd (2015=100)'), text_x = c(2016, 2021), text_y = c(108, 97), text_label = c('steady increase;; sharp fall'), text_rotation = c(25, -85), text_col = c('green, red'), text_font_size = c(2), open = FALSE)
}
