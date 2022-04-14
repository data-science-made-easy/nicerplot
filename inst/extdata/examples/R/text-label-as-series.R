source('M:/p_james/dev/dev-2022-04-15/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-15/examples/R/text-label-as-series.RData')
nplot(d, style = c('no-legend'), type = c('dot, param'), title = c('Overlapping labels (NL, PT)'), x_title = c('Overdrachtsbelasting (%)'), y_title = c('Aantal transacties per 1000 inwoners'), x_lim = c(0, 11), dot_size = c(0.8), label_font_size = c(0.9), rect_xleft = c(1.75), rect_ybottom = c(10.5), rect_xright = c(3), rect_ytop = c(14), rect_col = c('yellow'), open = FALSE)
