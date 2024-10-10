source('M:/p_james/release/2024-10-10/R-header.R')
d <- dget('M:/p_james/release/2024-10-10/examples/R/x-lim-example.RData')
nplot(d, title = c('Groeibijdragen bestedingen'), y_title = c('%-punt bbp-groei'), footnote = c('x_lim = 2010, 2014'), x_lim = c(2010, 2014), style = c('default'), open = FALSE)
