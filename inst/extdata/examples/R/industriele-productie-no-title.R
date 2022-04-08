source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/industriele-productie-no-title.RData')
plot(d, style = c('no-title'), type = c('line'), title = c('Industriële productie en detailhandel'), y_title = c('geïndexeerd (2015=100)'), x_lim_follow_data = c('y'), open = FALSE)
