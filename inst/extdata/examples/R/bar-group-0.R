source('M:/p_james/release/2024-10-22/R-header.R')
d <- dget('M:/p_james/release/2024-10-22/examples/R/bar-group-0.RData')
nplot(d, type = c('bar--'), title = c('VWO'), y_title = c('zakkans (%)'), turn = c('y'), x_ticks = c(1, 2, 4, 5, 6, 8, 9, 10, 12, 13), style = c('default'), open = FALSE)
