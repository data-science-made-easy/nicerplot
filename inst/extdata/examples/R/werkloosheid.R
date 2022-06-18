source('M:/p_james/release/2022-06-18/R-header.R')
d <- dget('M:/p_james/release/2022-06-18/examples/R/werkloosheid.RData')
nplot(d, type = c('line'), title = c('Werkloosheid'), y_title = c('% beroepsbevolking'), open = FALSE)
