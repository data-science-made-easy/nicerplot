source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/bars-non-equidistant.RData')
plot(d, type = c('bar--'), title = c('Number of phones in the world'), open = FALSE)
