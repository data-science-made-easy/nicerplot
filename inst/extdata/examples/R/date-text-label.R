source('M:/p_james/release/2024-10-22/R-header.R')
d <- dget('M:/p_james/release/2024-10-22/examples/R/date-text-label.RData')
nplot(d, title = c('Rentespreads op overheidsschuld'), y_title = c('%'), x_lim = c(2020.09, 2020.38), vline_dash_date = c('43908'), text_x_date = c(43908), text_y = c(4.5), text_pos = c(4), text_label = c('18-mrt'), style = c('default'), open = FALSE)
