source('M:/p_james/release/2024-10-22/R-header.R')
d <- dget('M:/p_james/release/2024-10-22/examples/R/usarrests.RData')
nplot(d, style = c('tall'), type = c('bar='), title = c('Violent crime rates in the USA'), x_title = c('state'), y_title = c('Number per 100,000'), turn = c('y'), logo = c('y'), order = c(1, 2, 4), open = FALSE)
