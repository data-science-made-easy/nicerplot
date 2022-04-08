source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/world-map.RData')
plot(d, style = c('world-map, english'), title = c('World import, customs or balance of payments (prices), change in july, 2020.'), footnote = c('Source: cpb.nl/en/cpb-world-trade-monitor-july-2020'), open = FALSE)
