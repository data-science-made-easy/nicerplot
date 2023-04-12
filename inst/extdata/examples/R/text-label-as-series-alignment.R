source('M:/p_james/release/2023-03-30/R-header.R')
d <- dget('M:/p_james/release/2023-03-30/examples/R/text-label-as-series-alignment.RData')
nplot(d, style = c('no-legend'), type = c('dot, param, param'), title = c('Different alignment for PT'), x_title = c('Overdrachtsbelasting (%)'), y_title = c('Aantal transacties per 1000 inwoners'), x_lim = c(0, 11), dot_size = c(0.8), label_font_size = c(0.9), text_offset = c(0.25), rect_xleft = c(1.75), rect_ybottom = c(10.5), rect_xright = c(3), rect_ytop = c(14), rect_col = c('yellow'), rect_border = c('rose'), open = FALSE)
