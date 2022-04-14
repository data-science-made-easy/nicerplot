if (file.exists('cbs-with-own.xlsx') { # plot figures from Excel file:
  nicerplot::nplot('cbs-with-own.xlsx')
} else if (file.exists('cbs-with-own.RData') { # or plot figures directly in R:
  d <- dget('cbs-with-own.RData')
  nicerplot::nplot(d, cbs_url = c('https://opendata.cbs.nl/statline/#/CBS/nl/dataset/83913NED/table?dl=323FD'), type = c('line'), title = c('Bestaande koopwoningen'), y_title = c('verkoopprijzen (prijsindex 2015=100)'), footnote = c('https://opendata.cbs.nl/statline/#/CBS/nl/dataset/83913NED/table?dl=323FD'), order = c(2, 3, 1), open = FALSE)
}
