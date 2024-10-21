source('M:/p_james/release/2024-10-22/R-header.R')
d <- dget('M:/p_james/release/2024-10-22/examples/R/bar-group-label-horiz-num.RData')
nplot(d, type = c('bar='), title = c('Tozo'), x_title = c('deciel'), y_title = c('%'), first_col_grouping = c('y'), x_lab_as_text = c('y'), group_spacing = c(1), style = c('default'), open = FALSE)
