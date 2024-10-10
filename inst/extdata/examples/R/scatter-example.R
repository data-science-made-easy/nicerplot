source('M:/p_james/release/2024-10-10/R-header.R')
d <- dget('M:/p_james/release/2024-10-10/examples/R/scatter-example.RData')
nplot(d, type = c('dot'), title = c('Phones per continent'), y_title = c('number'), style = c('default'), open = FALSE)
