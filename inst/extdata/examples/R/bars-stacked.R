source('M:/p_james/release/2024-10-10/R-header.R')
d <- dget('M:/p_james/release/2024-10-10/examples/R/bars-stacked.RData')
nplot(d, type = c('bar=, bar--, bar--, bar=, bar--, bar--, bar='), title = c('Number of phones in the world'), x_lab_as_text = c('y'), style = c('default'), open = FALSE)
