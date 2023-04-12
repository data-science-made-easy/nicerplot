source('M:/p_james/release/2023-03-30/R-header.R')
d <- dget('M:/p_james/release/2023-03-30/examples/R/werkverliezers-log.RData')
nplot(d, type = c('line'), title = c('Werkverliezers'), y_title = c('dzd personen op log-schaal, 15-74 jaar'), x_lim_follow_data = c('y'), transformation = c('log'), style = c('default'), open = FALSE)
