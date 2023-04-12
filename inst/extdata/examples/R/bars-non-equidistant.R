source('M:/p_james/release/2023-03-30/R-header.R')
d <- dget('M:/p_james/release/2023-03-30/examples/R/bars-non-equidistant.RData')
nplot(d, type = c('bar--'), title = c('Number of phones in the world'), style = c('default'), open = FALSE)
