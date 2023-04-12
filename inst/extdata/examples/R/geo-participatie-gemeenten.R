source('M:/p_james/release/2023-03-30/R-header.R')
d <- dget('M:/p_james/release/2023-03-30/examples/R/geo-participatie-gemeenten.RData')
nplot(d, style = c('map'), title = c('Participatie gemeenten'), footnote = c('Jaar 2018'), geo_cbs_map = c('gemeente_2018'), name = c('niet;;wel'), legend_order = c(2, 1), open = FALSE)
