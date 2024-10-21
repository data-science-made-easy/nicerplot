source('M:/p_james/release/2024-10-22/R-header.R')
d <- dget('M:/p_james/release/2024-10-22/examples/R/geo-participatie-gemeenten.RData')
nplot(d, style = c('map'), title = c('Participatie gemeenten'), footnote = c('Jaar 2018'), cbs_map = c('gemeente'), cbs_map_year = c(2018), name = c('niet;;wel'), legend_order = c(2, 1), open = FALSE)
