if (file.exists('line-symbol.xlsx') { # plot figures from Excel file:
  nicerplot::nplot('line-symbol.xlsx')
} else if (file.exists('line-symbol.RData') { # or plot figures directly in R:
  d <- dget('line-symbol.RData')
  nicerplot::nplot(d, type = c('line'), title = c('Ontwikkeling EMU-schuld in schokscenario's'), y_title = c('%-bbp'), x_lim = c(2017.5, 2025.5), line_symbol = c(0, 20, 20, 20), open = FALSE)
}
