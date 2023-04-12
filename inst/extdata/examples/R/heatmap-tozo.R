source('M:/p_james/release/2023-03-30/R-header.R')
d <- dget('M:/p_james/release/2023-03-30/examples/R/heatmap-tozo.RData')
nplot(d, type = c('heatmap'), title = c('Fractie bedrijven die TOZO gebruikt'), x_title = c('eigen vermogen 2020 (deciel)'), y_title = c('eigen vermogen 2021 (deciel)'), style = c('default'), open = FALSE)
