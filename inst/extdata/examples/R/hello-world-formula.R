source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/hello-world-formula.RData')
plot(d, type = c('line'), title = c('Hello World'), x_title = c('x'), y_title = c('y'), hline_bold = c(0), formula = c('10 * sin(p$data[, 1])'), formula_name = c('sinus'), open = FALSE)