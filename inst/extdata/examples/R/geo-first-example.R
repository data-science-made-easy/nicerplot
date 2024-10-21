source('M:/p_james/release/2024-10-22/R-header.R')
d <- dget('M:/p_james/release/2024-10-22/examples/R/geo-first-example.RData')
nplot(d, style = c('map'), cbs_map = c('arbeidsmarktregio'), cbs_map_year = c(2020), open = FALSE)
