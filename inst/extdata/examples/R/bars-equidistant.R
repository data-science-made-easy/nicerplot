source('M:/p_james/release/2022-10-04/R-header.R')
d <- dget('M:/p_james/release/2022-10-04/examples/R/bars-equidistant.RData')
nplot(d, type = c('bar--'), title = c('Number of phones in the world'), x_lab_as_text = c('y'), style = c('default'), open = FALSE)
