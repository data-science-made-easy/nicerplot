source('M:/p_james/release/2023-03-30/R-header.R')
d <- dget('M:/p_james/release/2023-03-30/examples/R/bars-highlight-series.RData')
nplot(d, type = c('bar='), title = c('Number of phones (Europe yellow)'), highlight_series = c(2), highlight_col = c('yellow'), style = c('default'), open = FALSE)
