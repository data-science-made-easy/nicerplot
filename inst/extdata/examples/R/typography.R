source('M:/p_james/dev/dev-2022-04-15/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-15/examples/R/typography.RData')
nplot(d, style = c('no-legend'), type = c('bar--'), title = c('{x,y}_lab_{bold,italic}'), y_at = c(1, 2, 3, 4), x_lab_bold = c(2, 4), x_lab_italic = c(3, 4), y_lab_bold = c(2, 4), y_lab_italic = c(3, 4), open = FALSE)
