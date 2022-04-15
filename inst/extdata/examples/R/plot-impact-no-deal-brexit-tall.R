if (file.exists('impact-no-deal-brexit-tall.xlsx')) { # plot figures from Excel file:
  nicerplot::nplot('impact-no-deal-brexit-tall.xlsx')
} else if (file.exists('impact-no-deal-brexit-tall.RData')) { # or plot figures directly in R:
  d <- dget('impact-no-deal-brexit-tall.RData')
  nicerplot::nplot(d, style = c('tall'), type = c('bar--, bar--, whisker, whisker, whisker, whisker'), title = c('Impact no-deal Brexit (tall)'), y_title = c('% verandering'), y_lab = c('-5;-4; -3; -2; -1; 0; 1'), turn = c('y'), x_ticks = c(1,5,6,7,8,9,10,11,12,13,14,15,16,17,18), y_r_title = c('% verandering VK'), y_r_title_col = c('rose'), vline_dash = c(3), text_x = c(2, 4), text_y = c(-2, -2), text_label = c('zie bovenste x-as;; zie onderste x-as'), text_col = c('rose, black'), x_lab_col = c('rose, black, black, black, black, black, black, black, black, black, black, black, black, black, black, black, black, black'), y_r_lab = c('-25;-20; -15; -10; -5; 0; 5'), y_r_lab_col = c('rose'), whisker_legend_show_n = c(0), open = FALSE)
} else print(paste('Please download', xlsx_data_file, 'or', rdata_file, 'to create the nice R plot.'))
