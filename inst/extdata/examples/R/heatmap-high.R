source('M:/p_james/release/2024-10-22/R-header.R')
d <- dget('M:/p_james/release/2024-10-22/examples/R/heatmap-high.RData')
nplot(d, type = c('heatmap'), title = c('Heatmap stressing high values'), x_title = c('first variable (unit)'), y_title = c('second variable (unit)'), footnote = c('mexican hat pointing down (left) and up (right)'), palette = c('palette_heatmap_high'), style = c('default'), lock = c('no'), open = FALSE)
