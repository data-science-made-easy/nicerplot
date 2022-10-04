source('M:/p_james/release/2022-10-04/R-header.R')
d <- dget('M:/p_james/release/2022-10-04/examples/R/secondary-y-axis.RData')
nplot(d, type = c('bar--, line'), title = c('Economische groei in Nederland'), y_title = c('mutatie in %'), x_lab_date_show = c('y'), x_ticks_date = c('years, quarters'), y_axis = c('l, r'), y_r_title = c('€ miljard'), style = c('default'), open = FALSE)
