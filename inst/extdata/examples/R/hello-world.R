source('M:/p_james/release/2022-10-04/R-header.R')
d <- dget('M:/p_james/release/2022-10-04/examples/R/hello-world.RData')
nplot(d, type = c('line'), title = c('Hello World'), x_title = c('x'), y_title = c('y'), style = c('default'), open = FALSE)
