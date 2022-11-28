source('M:/p_james/release/2022-11-28/R-header.R')
d <- dget('M:/p_james/release/2022-11-28/examples/R/area-multiple.RData')
nplot(d, type = c('line, area, area, line, area, area'), title = c('Two bandwiths in one plot'), line_lty = c(3, 3), style = c('default'), open = FALSE)
