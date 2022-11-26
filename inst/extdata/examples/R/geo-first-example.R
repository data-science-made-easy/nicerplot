source('M:/p_james/release/2022-11-26/R-header.R')
d <- dget('M:/p_james/release/2022-11-26/examples/R/geo-first-example.RData')
nplot(d, style = c('map'), geo_cbs_map = c('arbeidsmarktregio_2020'), open = FALSE)
