source('M:/p_james/release/2022-10-04/R-header.R')
d <- dget('M:/p_james/release/2022-10-04/examples/R/worldphones-forecasted.RData')
nplot(d, style = c('english'), type = c('line, bar=, bar=, bar=, bar=, bar=, bar='), title = c('Forecasted from 1958'), footnote = c('For aesthetical reasons and not cutting bars, we use forecast_x = 1957.5'), logo = c('y'), forecast_x = c(1957.5), open = FALSE)
