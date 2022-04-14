if (file.exists('geo-three-cols.xlsx') { # plot figures from Excel file:
  nicerplot::nplot('geo-three-cols.xlsx')
} else if (file.exists('geo-three-cols.RData') { # or plot figures directly in R:
  d <- dget('geo-three-cols.RData')
  nicerplot::nplot(d, style = c('map'), title = c('Arbeidsmarktregio's in 2020 volgens CBS'), footnote = c('Nederland bestaat in 2020 uit 36 arbeidsmarktregio's'), name_col = c('special region = sun'), geo_cbs_map = c('arbeidsmarktregio_2020'), name = c('lowest value (1);; middle value (18.5);; highest value (36);; special region'), geo_col_threshold = c(1, 18.5, 36), palette = c('anakiwa, endeavour, rose'), lock = c('no'), open = FALSE)
}
