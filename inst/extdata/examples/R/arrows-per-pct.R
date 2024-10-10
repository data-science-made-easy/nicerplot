source('M:/p_james/release/2024-10-10/R-header.R')
d <- dget('M:/p_james/release/2024-10-10/examples/R/arrows-per-pct.RData')
nplot(d, title = c('Spanning op arbeidsmarkt blijft toenemen'), x_title = c('werkloosheidspercentage'), y_title = c('vacaturegraad (vacatures per 1000 werknemersbanen)'), arrow_col = c('black, rose, rose, black'), arrow_position_pct = c(10, 30, 50, 90), style = c('default'), open = FALSE)
