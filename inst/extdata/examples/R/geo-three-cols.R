source('M:/p_james/release/2024-10-22/R-header.R')
d <- dget('M:/p_james/release/2024-10-22/examples/R/geo-three-cols.RData')
nplot(d, style = c('map'), title = c('Arbeidsmarktregio's in 2020 volgens CBS'), footnote = c('Nederland bestaat in 2020 uit 36 arbeidsmarktregio's'), name_col = c('special region = sun'), cbs_map = c('arbeidsmarktregio'), cbs_map_year = c(2020), name = c('lowest value (1);; middle value (18.5);; highest value (36);; special region'), cbs_map_col_threshold = c(1, 18.5, 36), palette = c('anakiwa, endeavour, rose'), lock = c('no'), open = FALSE)
