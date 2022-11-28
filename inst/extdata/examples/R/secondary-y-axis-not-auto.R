source('M:/p_james/release/2022-11-28/R-header.R')
d <- dget('M:/p_james/release/2022-11-28/examples/R/secondary-y-axis-not-auto.RData')
nplot(d, type = c('bar--, line'), title = c('No auto-scaling'), y_title = c('mutatie in %'), x_lab_date_show = c('y'), x_ticks_date = c('years, quarters'), y_axis = c('l, r'), y_r_title = c('€ miljard'), y_r_scale_auto = c('n'), x_date_format = c('yyyy'), y_r_n_decimals = c(1), style = c('default'), open = FALSE)
