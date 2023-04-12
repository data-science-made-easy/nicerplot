source('M:/p_james/release/2023-03-30/R-header.R')
d <- dget('M:/p_james/release/2023-03-30/examples/R/heatmap-middle.RData')
nplot(d, type = c('heatmap'), title = c('Heatmap stressing middle values'), x_title = c('first variable (unit)'), y_title = c('second variable (unit)'), footnote = c('mexican hat pointing down (left) and up (right)'), palette = c('palette_heatmap_middle'), style = c('default'), lock = c('no'), open = FALSE)
