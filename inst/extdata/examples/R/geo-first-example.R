source('M:/p_james/dev/dev-2022-04-15/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-15/examples/R/geo-first-example.RData')
nplot(d, style = c('map'), geo_cbs_map = c('arbeidsmarktregio_2020'), open = FALSE)
