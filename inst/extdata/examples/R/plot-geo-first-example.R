if (file.exists('geo-first-example.xlsx') { # plot figures from Excel file:
  nicerplot::nplot('geo-first-example.xlsx')
} else if (file.exists('geo-first-example.RData') { # or plot figures directly in R:
  d <- dget('geo-first-example.RData')
  nicerplot::nplot(d, style = c('map'), geo_cbs_map = c('arbeidsmarktregio_2020'), open = FALSE)
}
