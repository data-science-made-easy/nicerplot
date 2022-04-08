source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/ppower.RData')
plot(d, style = c('ppower'), y_at = c(-50, -40, -30, -20, -10, 0, 10, 20, 30, 40, 50), x_keep = c(0, 140), y_keep = c(-50, 50), open = FALSE)
