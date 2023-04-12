source('M:/p_james/release/2023-03-30/R-header.R')
d <- dget('M:/p_james/release/2023-03-30/examples/R/bar-group-label.RData')
nplot(d, type = c('bar--'), title = c('VWO'), y_title = c('zakkans (%)'), turn = c('y'), hline_bold = c(0), style = c('default'), open = FALSE)
