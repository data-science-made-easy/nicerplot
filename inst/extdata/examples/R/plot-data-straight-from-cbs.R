if (file.exists('data-straight-from-cbs.xlsx') { # plot figures from Excel file:
  nicerplot::nplot('data-straight-from-cbs.xlsx')
} else if (file.exists('data-straight-from-cbs.RData') { # or plot figures directly in R:
  d <- dget('data-straight-from-cbs.RData')
  nicerplot::nplot(d, cbs_url = c('https://opendata.cbs.nl/statline/#/CBS/nl/dataset/83913NED/table?dl=323FD'), type = c('line'), title = c('Bestaande koopwoningen'), y_title = c('verkoopprijzen (prijsindex 2015=100)'), footnote = c('https://opendata.cbs.nl/statline/#/CBS/nl/dataset/83913NED/table?dl=323FD'), open = FALSE)
}
