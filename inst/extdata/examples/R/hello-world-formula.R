source('M:/p_james/dev/dev-2022-04-15/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-15/examples/R/hello-world-formula.RData')
nplot(d, type = c('line'), title = c('Hello World'), x_title = c('x'), y_title = c('y'), hline_bold = c(0), formula = c('10 * sin(p$data[, 1])'), formula_name = c('sinus'), open = FALSE)
