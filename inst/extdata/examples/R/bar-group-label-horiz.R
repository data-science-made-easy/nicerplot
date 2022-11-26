source('M:/p_james/release/2022-11-26/R-header.R')
d <- dget('M:/p_james/release/2022-11-26/examples/R/bar-group-label-horiz.RData')
nplot(d, type = c('bar--'), title = c('VWO'), y_title = c('zakkans (%)'), hline_bold = c(0), legend_y = c(0.8), group_spacing = c(0.2), style = c('default'), open = FALSE)
