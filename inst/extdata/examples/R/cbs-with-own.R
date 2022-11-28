source('M:/p_james/release/2022-11-28/R-header.R')
d <- dget('M:/p_james/release/2022-11-28/examples/R/cbs-with-own.RData')
nplot(d, cbs_url = c('https://opendata.cbs.nl/statline/#/CBS/nl/dataset/83913NED/table?dl=323FD'), type = c('line'), title = c('Bestaande koopwoningen'), y_title = c('verkoopprijzen (prijsindex 2015=100)'), footnote = c('https://opendata.cbs.nl/statline/#/CBS/nl/dataset/83913NED/table?dl=323FD'), order = c(2, 3, 1), style = c('default'), open = FALSE)
