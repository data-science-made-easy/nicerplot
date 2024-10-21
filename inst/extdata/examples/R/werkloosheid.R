source('M:/p_james/release/2024-10-22/R-header.R')
d <- dget('M:/p_james/release/2024-10-22/examples/R/werkloosheid.RData')
nplot(d, type = c('line'), title = c('Werkloosheid'), y_title = c('% beroepsbevolking'), style = c('default'), open = FALSE)
