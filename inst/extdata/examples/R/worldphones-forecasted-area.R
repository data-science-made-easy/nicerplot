source('M:/p_james/release/2024-10-22/R-header.R')
d <- dget('M:/p_james/release/2024-10-22/examples/R/worldphones-forecasted-area.RData')
nplot(d, type = c('line, area=, area=, area=, area=, area=, area='), title = c('Geraamd vanaf 1958'), x_lim_follow_data = c('y'), logo = c('y'), forecast_x = c(1958), style = c('default'), open = FALSE)
