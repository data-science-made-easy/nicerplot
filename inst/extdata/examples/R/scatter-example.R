source('M:/p_james/release/2022-11-26/R-header.R')
d <- dget('M:/p_james/release/2022-11-26/examples/R/scatter-example.RData')
nplot(d, type = c('dot'), title = c('Phones per continent'), y_title = c('number'), style = c('default'), open = FALSE)
