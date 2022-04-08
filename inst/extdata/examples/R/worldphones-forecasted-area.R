source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/worldphones-forecasted-area.RData')
plot(d, type = c('line, area=, area=, area=, area=, area=, area='), title = c('Geraamd vanaf 1958'), x_lim_follow_data = c('y'), logo = c('y'), forecast_x = c(1958), open = FALSE)
