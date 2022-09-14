source('M:/p_james/release/2022-09-14/R-header.R')
d <- dget('M:/p_james/release/2022-09-14/examples/R/area-order.RData')
nplot(d, type = c('area, area, area, area, area='), title = c('Cohorten omvatten veel asielmigranten'), y_title = c('aantal (x 1.000)'), legend_order = c(3, 1, 2), style = c('default'), open = FALSE)
