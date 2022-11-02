source('M:/p_james/release/2022-10-25/R-header.R')
d <- dget('M:/p_james/release/2022-10-25/examples/R/bar-bar-dot-whisker.RData')
nplot(d, type = c('bar--, bar--, dot, whisker, whisker'), title = c('Verwacht verlies in verschillende scenario's'), y_title = c('Verlies (mld €)'), dot_size = c(0.7), legend_n_per_column = c(4), whisker_series = c(2), style = c('default'), open = FALSE)
