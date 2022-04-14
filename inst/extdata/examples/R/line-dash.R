source('M:/p_james/dev/dev-2022-04-15/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-15/examples/R/line-dash.RData')
nplot(d, style = c('y-right'), type = c('line'), title = c('Six different line types'), y_lab = c('1; 2; 3; 4; 5; 6;'), footnote = c('Please use line_lty = 3 for CPB-figures'), footnote_col = c('rose'), x_lim_follow_data = c('y'), line_lty = c(1, 2, 3, 4, 5, 6), y_r_lab = c('; 1; 2; 3; 4; 5; 6'), x_axis_show = c('n'), lock = c('no'), open = FALSE)
