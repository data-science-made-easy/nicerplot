source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/date-text-label.RData')
plot(d, title = c('Rentespreads op overheidsschuld'), y_title = c('%'), x_lim = c(2020.09, 2020.38), vline_dash_date = c('43908'), text_x_date = c(43908), text_y = c(4.5), text_pos = c(4), text_label = c('18-mrt'), open = FALSE)
