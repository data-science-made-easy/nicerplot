source('M:/p_james/release/2022-11-26/R-header.R')
d <- dget('M:/p_james/release/2022-11-26/examples/R/kansrijk.RData')
nplot(d, style = c('kansrijk'), type = c('bar--'), y_title = c('%'), scale = c(100), turn = c('y'), bar_lab_show = c('y'), open = FALSE)
