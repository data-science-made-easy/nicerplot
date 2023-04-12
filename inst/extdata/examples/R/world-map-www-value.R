source('M:/p_james/release/2023-03-30/R-header.R')
d <- dget('M:/p_james/release/2023-03-30/examples/R/world-map-www-value.RData')
nplot(d, style = c('world-map-www, english'), title = c('World trade volume change last month:'), footnote = c('Source: cpb.nl/en/worldtrademonitor'), world_map_value = c(3.3), open = FALSE)
