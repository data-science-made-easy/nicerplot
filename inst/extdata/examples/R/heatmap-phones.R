source('M:/p_james/release/2024-10-22/R-header.R')
d <- dget('M:/p_james/release/2024-10-22/examples/R/heatmap-phones.RData')
nplot(d, type = c('heatmap'), title = c('Number of phones in the world'), x_title = c('year'), y_title = c('Part of world'), heatmap_x_axis_asis = c('T'), heatmap_z_lim = c(0, 90000), heatmap_legend_labels_n_decimals = c(0), style = c('default'), open = FALSE)
