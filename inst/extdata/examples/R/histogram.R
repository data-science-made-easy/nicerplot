source('M:/p_james/release/2022-10-25/R-header.R')
d <- dget('M:/p_james/release/2022-10-25/examples/R/histogram.RData')
nplot(d, style = c('histogram, no-legend'), title = c('Standard normal distribution'), y_title = c('Number of observations (a.u.)'), footnote = c('mu = 0, sigma = 1'), open = FALSE)
