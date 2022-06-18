source('M:/p_james/release/2022-06-18/R-header.R')
d <- dget('M:/p_james/release/2022-06-18/examples/R/bars-and-line-color.RData')
nplot(d, type = c('bar=, bar=, bar=, bar=, bar=, line'), title = c('Groeibijdragen bestedingen'), y_title = c('%-punt bbp-groei'), name_col = c('bbp-groei=black'), line_lty = c(3), palette = c('red, blue, white, appletv'), lock = c('no'), open = FALSE)
