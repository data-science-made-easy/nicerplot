source('M:/p_james/dev/dev-2022-04-07/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-07/examples/R/histogram.RData')
plot(d, style = c('histogram, no-legend'), title = c('Standard normal distribution'), y_title = c('Number of observations (a.u.)'), footnote = c('µ = 0, σ = 1'), open = FALSE)
