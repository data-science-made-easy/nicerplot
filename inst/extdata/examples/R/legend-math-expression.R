source('M:/p_james/release/2022-11-26/R-header.R')
d <- dget('M:/p_james/release/2022-11-26/examples/R/legend-math-expression.RData')
nplot(d, style = c('english'), title = c('Mathematical expression in legend'), x_title = c('a.u.'), y_title = c('a.u.'), footnote = c('NB legend may be incorrectly formatted'), legend_n_per_column = c(4), legend_math = c('y'), grid_lines_lwd = c(-1), open = FALSE)
