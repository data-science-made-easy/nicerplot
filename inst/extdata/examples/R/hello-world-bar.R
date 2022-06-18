source('M:/p_james/release/2022-06-18/R-header.R')
d <- dget('M:/p_james/release/2022-06-18/examples/R/hello-world-bar.RData')
nplot(d, style = c('no-title'), type = c('bar='), x_title = c('x'), y_title = c('y'), turn = c('y'), open = FALSE)
