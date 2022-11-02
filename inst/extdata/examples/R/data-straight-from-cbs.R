source('M:/p_james/release/2022-10-25/R-header.R')
d <- dget('M:/p_james/release/2022-10-25/examples/R/data-straight-from-cbs.RData')
nplot(d, cbs_url = c('https://opendata.cbs.nl/statline/#/CBS/nl/dataset/83913NED/table?dl=323FD'), type = c('line'), title = c('Bestaande koopwoningen'), y_title = c('verkoopprijzen (prijsindex 2015=100)'), footnote = c('https://opendata.cbs.nl/statline/#/CBS/nl/dataset/83913NED/table?dl=323FD'), style = c('default'), open = FALSE)
