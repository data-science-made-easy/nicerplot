source('M:/p_james/release/2022-09-14/R-header.R')
d <- dget('M:/p_james/release/2022-09-14/examples/R/secondary-y-axis-y-r-lim.RData')
nplot(d, type = c('bar--, line'), title = c('The use of y_r_lim'), y_title = c('mutatie in %'), x_lab_date_show = c('y'), x_ticks_date = c('years, quarters'), y_axis = c('l, r'), y_r_title = c('€ miljard'), y_r_lim = c(674, 800), style = c('default'), open = FALSE)
