source('M:/p_james/release/2022-06-18/R-header.R')
d <- dget('M:/p_james/release/2022-06-18/examples/R/werkverliezers-log.RData')
nplot(d, type = c('line'), title = c('Werkverliezers'), y_title = c('dzd personen op log-schaal, 15-74 jaar'), x_lim_follow_data = c('y'), transformation = c('log'), open = FALSE)
