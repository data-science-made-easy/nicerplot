source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/geo-first-example.RData')
plot(d, style = c('map'), geo_cbs_map = c('arbeidsmarktregio_2020'), open = FALSE)
