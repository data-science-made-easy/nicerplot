source('M:/p_james/release/2024-10-22/R-header.R')
d <- dget('M:/p_james/release/2024-10-22/examples/R/bars-and-line-turn.RData')
nplot(d, type = c('bar=, bar=, bar=, bar=, bar=, line'), title = c('Groeibijdragen bestedingen'), y_title = c('%-punt bbp-groei'), turn = c('y'), name_col = c('bbp-groei=black'), line_lty = c(3), style = c('default'), open = FALSE)
