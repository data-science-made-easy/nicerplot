source('M:/p_james/dev/dev-2022-04-15/R-header.R')
d <- dget('M:/p_james/dev/dev-2022-04-15/examples/R/footnote-example.RData')
nplot(d, title = c('Toeslagen'), x_title = c('bruto huishoudinkomen (euro)'), y_title = c('jaarbedrag (euro)'), footnote = c('Bron: Koot en Gielen (2019), op basis van MIMOSI'), footnote_col = c('rose'), footnote_side = c('top'), footnote_align = c('center'), footnote_font_style = c(1), x_lab_big_mark_show = c('y'), lock = c('no'), open = FALSE)
