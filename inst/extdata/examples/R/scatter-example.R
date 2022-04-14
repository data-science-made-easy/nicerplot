source('M:/p_james/dev/dev-2022-04-15/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-15/examples/R/scatter-example.RData')
nplot(d, type = c('dot'), title = c('Phones per continent'), y_title = c('number'), open = FALSE)
