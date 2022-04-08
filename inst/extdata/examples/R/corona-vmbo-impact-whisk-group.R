source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/corona-vmbo-impact-whisk-group.RData')
plot(d, type = c('bar--, bar--, whisker, whisker, whisker, whisker'), title = c('VMBO'), y_title = c('kans om te zakken (%)'), footnote = c('Please note: whiskers are different.'), footnote_col = c('rose'), turn = c('y'), legend_n_per_column = c(2), whisker_legend_show_n = c(2), lock = c('no'), open = FALSE)
