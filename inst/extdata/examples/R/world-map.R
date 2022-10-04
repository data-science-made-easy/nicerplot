source('M:/p_james/release/2022-10-04/R-header.R')
d <- dget('M:/p_james/release/2022-10-04/examples/R/world-map.RData')
nplot(d, style = c('world-map, english'), title = c('World import, customs or balance of payments (prices), change in july, 2020.'), footnote = c('Source: cpb.nl/en/cpb-world-trade-monitor-july-2020'), open = FALSE)
