source('M:/p_james/release/2024-10-10/R-header.R')
d <- dget('M:/p_james/release/2024-10-10/examples/R/bars-highlight-series.RData')
nplot(d, type = c('bar='), title = c('Number of phones (Europe yellow)'), highlight_series = c(2), highlight_col = c('yellow'), style = c('default'), open = FALSE)
