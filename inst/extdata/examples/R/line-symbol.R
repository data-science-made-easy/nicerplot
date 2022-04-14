source('M:/p_james/dev/dev-2022-04-15/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-15/examples/R/line-symbol.RData')
nplot(d, type = c('line'), title = c('Ontwikkeling EMU-schuld in schokscenario's'), y_title = c('%-bbp'), x_lim = c(2017.5, 2025.5), line_symbol = c(0, 20, 20, 20), open = FALSE)
