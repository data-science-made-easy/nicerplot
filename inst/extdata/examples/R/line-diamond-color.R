source('M:/p_james/release/2023-03-30/R-header.R')
d <- dget('M:/p_james/release/2023-03-30/examples/R/line-diamond-color.RData')
nplot(d, type = c('line'), title = c('Number of phones US vs. Europe'), line_symbol = c(0, 18), line_symbol_col = c('NA, brown'), order = c(1, 2), style = c('default'), open = FALSE)
