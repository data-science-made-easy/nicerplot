source('M:/p_james/release/2023-03-30/R-header.R')
d <- dget('M:/p_james/release/2023-03-30/examples/R/x-lim-follow-data-example.RData')
nplot(d, title = c('Groeibijdragen bestedingen'), y_title = c('%-punt bbp-groei'), footnote = c('x_lim_follow_data = y'), x_lim_follow_data = c('y'), style = c('default'), open = FALSE)
