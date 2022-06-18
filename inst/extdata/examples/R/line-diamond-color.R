source('M:/p_james/release/2022-06-18/R-header.R')
d <- dget('M:/p_james/release/2022-06-18/examples/R/line-diamond-color.RData')
nplot(d, type = c('line'), title = c('Number of phones US vs. Europe'), line_symbol = c(0, 18), line_symbol_col = c('NA, brown'), order = c(1, 2), open = FALSE)
