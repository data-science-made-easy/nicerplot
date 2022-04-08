if (file.exists('industriele-productie-no-title.xlsx') { # plot figures from Excel file:
  nicerplot::plot('industriele-productie-no-title.xlsx')
} else if (file.exists('industriele-productie-no-title.RData') { # or plot figures directly in R:
  d <- dget('industriele-productie-no-title.RData')
  nicerplot::plot(d, style = c('no-title'), type = c('line'), title = c('Industriële productie en detailhandel'), y_title = c('geïndexeerd (2015=100)'), x_lim_follow_data = c('y'), open = FALSE)
}
