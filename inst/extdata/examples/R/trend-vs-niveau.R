source('M:/p_james/release/2023-03-30/R-header.R')
d <- dget('M:/p_james/release/2023-03-30/examples/R/trend-vs-niveau.RData')
nplot(d, style = c('no-title'), type = c('line'), x_title = c('tijd'), y_title = c('niveau'), line_lty = c(2, 1, 1), hline_bold = c(100), x_axis_show = c('n'), y_axis_show = c('n'), open = FALSE)
