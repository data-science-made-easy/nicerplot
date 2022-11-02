source('M:/p_james/release/2022-10-25/R-header.R')
d <- dget('M:/p_james/release/2022-10-25/examples/R/discontinuity.RData')
nplot(d, type = c('line'), title = c('A discontinuity'), y_lim = c(0, 3), style = c('default'), open = FALSE)
