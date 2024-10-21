source('M:/p_james/release/2024-10-22/R-header.R')
d <- dget('M:/p_james/release/2024-10-22/examples/R/stacked-area.RData')
nplot(d, type = c('area='), title = c('NL'ers hebben buitenlandse obligaties'), y_title = c('mld euro'), scale = c(100), x_lim_follow_data = c('y'), legend_order = c(3, 2, 1, 4), area_stack_name = c('Totaal belangrijkste drie landen'), style = c('default'), open = FALSE)
