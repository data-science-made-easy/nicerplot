source('M:/p_james/dev/dev-2022-04-15/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-15/examples/R/regular-text-labels.RData')
nplot(d, title = c('Industriële productie en detailhandel'), y_title = c('geïndexeerd (2015=100)'), text_x = c(2016, 2021), text_y = c(108, 97), text_label = c('steady increase;; sharp fall'), text_rotation = c(25, -85), text_col = c('green, red'), text_font_size = c(2), open = FALSE)
