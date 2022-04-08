source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/bar-bar-dot-whisker.RData')
plot(d, type = c('bar--, bar--, dot, whisker, whisker'), title = c('Verwacht verlies in verschillende scenario's'), y_title = c('Verlies (mld €)'), dot_size = c(0.7), legend_n_per_column = c(4), whisker_series = c(2), open = FALSE)
