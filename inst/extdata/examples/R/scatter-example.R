source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/scatter-example.RData')
plot(d, type = c('dot'), title = c('Phones per continent'), y_title = c('number'), open = FALSE)
