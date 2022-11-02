source('M:/p_james/release/2022-10-25/R-header.R')
d <- dget('M:/p_james/release/2022-10-25/examples/R/x-keep-example.RData')
nplot(d, title = c('Groeibijdragen bestedingen'), y_title = c('%-punt bbp-groei'), footnote = c('x_keep = 2010, 2014'), style = c('default'), open = FALSE)
