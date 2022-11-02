source('M:/p_james/release/2022-10-25/R-header.R')
d <- dget('M:/p_james/release/2022-10-25/examples/R/world-map-www.RData')
nplot(d, style = c('world-map-www, english'), title = c('World trade volume change last month'), footnote = c('Source: cpb.nl/en/worldtrademonitor'), open = FALSE)
