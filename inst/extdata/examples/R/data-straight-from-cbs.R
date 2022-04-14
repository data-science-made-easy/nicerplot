source('M:/p_james/dev/dev-2022-04-15/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-15/examples/R/data-straight-from-cbs.RData')
nplot(d, cbs_url = c('https://opendata.cbs.nl/statline/#/CBS/nl/dataset/83913NED/table?dl=323FD'), type = c('line'), title = c('Bestaande koopwoningen'), y_title = c('verkoopprijzen (prijsindex 2015=100)'), footnote = c('https://opendata.cbs.nl/statline/#/CBS/nl/dataset/83913NED/table?dl=323FD'), open = FALSE)
