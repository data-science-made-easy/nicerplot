source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/hello-world.RData')
plot(d, type = c('line'), title = c('Hello World'), x_title = c('x'), y_title = c('y'), open = FALSE)
