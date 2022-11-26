source('M:/p_james/release/2022-11-26/R-header.R')
d <- dget('M:/p_james/release/2022-11-26/examples/R/fan-example.RData')
nplot(d, style = c('fan'), title = c('Inflatie'), y_title = c('mutatie in %'), open = FALSE)
