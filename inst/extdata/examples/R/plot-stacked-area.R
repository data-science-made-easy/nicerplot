if (file.exists('stacked-area.xlsx') { # plot figures from Excel file:
  nicerplot::plot('stacked-area.xlsx')
} else if (file.exists('stacked-area.RData') { # or plot figures directly in R:
  d <- dget('stacked-area.RData')
  nicerplot::plot(d, type = c('area='), title = c('NL'ers hebben buitenlandse obligaties'), y_title = c('mld euro'), scale = c(100), x_lim_follow_data = c('y'), legend_order = c(3, 2, 1, 4), area_stack_name = c('Totaal belangrijkste drie landen'), open = FALSE)
}