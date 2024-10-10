source('M:/p_james/release/2024-10-10/R-header.R')
d <- dget('M:/p_james/release/2024-10-10/examples/R/heatmap-tozo.RData')
nplot(d, type = c('heatmap'), title = c('Percentage bedrijven dat TOZO gebruikt'), x_title = c('eigen vermogen 2020 (deciel)'), y_title = c('eigen vermogen 2021 (deciel)'), style = c('default'), open = FALSE)
