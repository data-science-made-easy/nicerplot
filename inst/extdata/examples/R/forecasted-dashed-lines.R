source('M:/p_james/release/2022-10-25/R-header.R')
d <- dget('M:/p_james/release/2022-10-25/examples/R/forecasted-dashed-lines.RData')
nplot(d, title = c('Bbp tijdens crises'), x_title = c('maand'), y_title = c('index'), forecast_x = c(5), hline_bold = c(100), style = c('default'), open = FALSE)
