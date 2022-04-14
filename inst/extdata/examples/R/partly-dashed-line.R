source('M:/p_james/dev/dev-2022-04-15/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-15/examples/R/partly-dashed-line.RData')
nplot(d, title = c('Partly dashed line'), x_title = c('maand'), y_title = c('index'), line_lty = c(1, 3, 1), hline_bold = c(100), legend_order = c(1, 3), palette = c('endeavour, endeavour, rose'), lock = c('no'), open = FALSE)
