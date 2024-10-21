source('M:/p_james/release/2024-10-22/R-header.R')
d <- dget('M:/p_james/release/2024-10-22/examples/R/hello-world-bar.RData')
nplot(d, style = c('no-title'), type = c('bar='), x_title = c('x'), y_title = c('y'), turn = c('y'), open = FALSE)
