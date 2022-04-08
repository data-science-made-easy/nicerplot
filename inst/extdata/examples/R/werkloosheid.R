source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/werkloosheid.RData')
plot(d, type = c('line'), title = c('Werkloosheid'), y_title = c('% beroepsbevolking'), open = FALSE)
