source('M:/p_james/release/2023-03-30/R-header.R')
d <- dget('M:/p_james/release/2023-03-30/examples/R/box.RData')
nplot(d, style = c('box-plot, tall'), type = c('box'), title = c('Inkomenseffecten plannen\nsocialezekerheids- en belastingstelsel'), y_title = c('verandering in 2025 (%)'), turn = c('y'), open = FALSE)
