source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/bars-highlight-series.RData')
plot(d, type = c('bar='), title = c('Number of phones (Europe yellow)'), highlight_series = c(2), highlight_col = c('yellow'), open = FALSE)
