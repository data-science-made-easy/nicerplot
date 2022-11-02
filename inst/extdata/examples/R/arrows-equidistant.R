source('M:/p_james/release/2022-10-25/R-header.R')
d <- dget('M:/p_james/release/2022-10-25/examples/R/arrows-equidistant.RData')
nplot(d, title = c('Spanning op arbeidsmarkt blijft toenemen'), x_title = c('werkloosheidspercentage'), y_title = c('vacaturegraad (vacatures per 1000 werknemersbanen)'), arrow_n = c(5), style = c('default'), open = FALSE)
