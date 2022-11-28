source('M:/p_james/release/2022-11-28/R-header.R')
d <- dget('M:/p_james/release/2022-11-28/examples/R/industriele-productie-no-title.RData')
nplot(d, style = c('no-title'), type = c('line'), title = c('Industriële productie en detailhandel'), y_title = c('geïndexeerd (2015=100)'), x_lim_follow_data = c('y'), open = FALSE)
