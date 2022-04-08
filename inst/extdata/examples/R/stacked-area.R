source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/stacked-area.RData')
plot(d, type = c('area='), title = c('NL'ers hebben buitenlandse obligaties'), y_title = c('mld euro'), scale = c(100), x_lim_follow_data = c('y'), legend_order = c(3, 2, 1, 4), area_stack_name = c('Totaal belangrijkste drie landen'), open = FALSE)
