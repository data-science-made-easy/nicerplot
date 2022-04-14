if (file.exists('werkverliezers-log.xlsx') { # plot figures from Excel file:
  nicerplot::nplot('werkverliezers-log.xlsx')
} else if (file.exists('werkverliezers-log.RData') { # or plot figures directly in R:
  d <- dget('werkverliezers-log.RData')
  nicerplot::nplot(d, type = c('line'), title = c('Werkverliezers'), y_title = c('dzd personen op log-schaal, 15-74 jaar'), x_lim_follow_data = c('y'), transformation = c('log'), open = FALSE)
}
