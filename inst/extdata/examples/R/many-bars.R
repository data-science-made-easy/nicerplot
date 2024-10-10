source('M:/p_james/release/2024-10-10/R-header.R')
d <- dget('M:/p_james/release/2024-10-10/examples/R/many-bars.RData')
nplot(d, style = c('wide'), type = c('line, bar=, bar=, bar=, bar=, bar=, bar=, bar='), title = c('Decompositie gemiddelde marginale belastingdruk werknemers 2021 '), x_title = c('individueel bruto jaarinkomen (euro)'), y_title = c('%'), highlight_series = c(1), bar_gap_fraction = c(0.5), x_scale = c(1000), x_lab_big_mark_show = c('y'), open = FALSE)
