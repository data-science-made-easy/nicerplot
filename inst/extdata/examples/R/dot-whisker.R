source('M:/p_james/release/2022-11-28/R-header.R')
d <- dget('M:/p_james/release/2022-11-28/examples/R/dot-whisker.RData')
nplot(d, style = c('no-legend'), type = c('dot, whisker, whisker'), title = c('Verwacht verlies in verschillende scenario's'), y_title = c('Verlies (mld €)'), turn = c('y'), dot_size = c(0.7), whisker_col = c('endeavour'), open = FALSE)
