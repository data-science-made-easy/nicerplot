source('M:/p_james/release/2022-10-04/R-header.R')
d <- dget('M:/p_james/release/2022-10-04/examples/R/x-ticks-date-example.RData')
nplot(d, title = c('Groeibijdragen bestedingen'), y_title = c('%-punt bbp-groei'), footnote = c('x_ticks_date = years, quarters'), x_ticks_date = c('years, quarters'), style = c('default'), open = FALSE)
