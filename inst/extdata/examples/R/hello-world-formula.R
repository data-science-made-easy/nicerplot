source('M:/p_james/release/2022-10-04/R-header.R')
d <- dget('M:/p_james/release/2022-10-04/examples/R/hello-world-formula.RData')
nplot(d, type = c('line'), title = c('Hello World'), x_title = c('x'), y_title = c('y'), hline_bold = c(0), formula = c('10 * sin(p$data[, 1])'), formula_name = c('sinus'), style = c('default'), open = FALSE)
