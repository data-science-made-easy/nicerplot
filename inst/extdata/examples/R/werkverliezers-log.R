source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/werkverliezers-log.RData')
plot(d, type = c('line'), title = c('Werkverliezers'), y_title = c('dzd personen op log-schaal, 15-74 jaar'), x_lim_follow_data = c('y'), transformation = c('log'), open = FALSE)
