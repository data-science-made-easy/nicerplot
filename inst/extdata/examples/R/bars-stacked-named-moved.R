source('M:/p_james/release/2024-10-22/R-header.R')
d <- dget('M:/p_james/release/2024-10-22/examples/R/bars-stacked-named-moved.RData')
nplot(d, type = c('bar=, bar--, bar--, bar=, bar--, bar--, bar='), title = c('Number of phones in the world'), bar_stack_name = c('The Americas'), bar_stack_index = c(1), style = c('default'), open = FALSE)
