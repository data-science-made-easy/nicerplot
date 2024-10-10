source('M:/p_james/release/2024-10-10/R-header.R')
d <- dget('M:/p_james/release/2024-10-10/examples/R/hello-world.RData')
nplot(d, type = c('line'), title = c('Hello World'), x_title = c('x'), y_title = c('y'), style = c('default'), open = FALSE)
