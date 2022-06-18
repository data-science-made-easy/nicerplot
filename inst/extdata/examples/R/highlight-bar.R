source('M:/p_james/release/2022-06-18/R-header.R')
d <- dget('M:/p_james/release/2022-06-18/examples/R/highlight-bar.RData')
nplot(d, type = c('bar--'), title = c('Europese steunpakketten'), y_title = c('% bbp'), turn = c('y'), highlight_series = c(1), highlight_x = c('7'), open = FALSE)
