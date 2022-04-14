source('M:/p_james/dev/dev-2022-04-15/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-15/examples/R/line-diamond-color.RData')
nplot(d, type = c('line'), title = c('Number of phones US vs. Europe'), line_symbol = c(0, 18), line_symbol_col = c('NA, brown'), order = c(1, 2), open = FALSE)
