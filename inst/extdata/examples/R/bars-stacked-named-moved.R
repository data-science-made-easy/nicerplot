source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/bars-stacked-named-moved.RData')
plot(d, type = c('bar=, bar--, bar--, bar=, bar--, bar--, bar='), title = c('Number of phones in the world'), bar_stack_name = c('The Americas'), bar_stack_index = c(1), open = FALSE)
