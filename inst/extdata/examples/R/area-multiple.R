source('M:/p_james/dev/dev-2022-04-15/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-15/examples/R/area-multiple.RData')
nplot(d, type = c('line, area, area, line, area, area'), title = c('Two bandwiths in one plot'), line_lty = c(3, 3), open = FALSE)
