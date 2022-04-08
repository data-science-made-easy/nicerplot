source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/discontinuity.RData')
plot(d, type = c('line'), title = c('A discontinuity'), y_lim = c(0, 3), open = FALSE)
