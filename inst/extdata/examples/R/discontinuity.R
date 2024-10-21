source('M:/p_james/release/2024-10-22/R-header.R')
d <- dget('M:/p_james/release/2024-10-22/examples/R/discontinuity.RData')
nplot(d, type = c('line'), title = c('A discontinuity'), y_lim = c(0, 3), style = c('default'), open = FALSE)
