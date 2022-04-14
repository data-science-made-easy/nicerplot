source('M:/p_james/dev/dev-2022-04-15/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-15/examples/R/forecasted-dashed-lines.RData')
nplot(d, title = c('Bbp tijdens crises'), x_title = c('maand'), y_title = c('index'), forecast_x = c(5), hline_bold = c(100), open = FALSE)
