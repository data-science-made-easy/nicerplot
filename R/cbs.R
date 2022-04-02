cbs <- function(url = "https://opendata.cbs.nl/statline/#/CBS/nl/dataset/83913NED/table?dl=323FD") {
  mat <- cbsodataR::cbs_get_data_from_link(url, message = FALSE)  
  mat <- cbsodataR::cbs_add_label_columns(mat)
  mat <- cbsodataR::cbs_add_date_column(mat)
  mat <- as.data.frame(mat)
  mat <- cbind(date = mat[,"Perioden_Date"], mat)#cbind(date = lubridate::decimal_date(mat[,"Perioden_Date"]), mat)
  
  index_col_label <- which(stringr::str_detect(colnames(mat), "_label"))
  # Filter cols which have > 1 different values
  index_col_label_sel <- NULL
  for (i in seq_along(index_col_label)) {
    if (1 < length(unique(mat[, index_col_label[i]]))) index_col_label_sel <- c(index_col_label_sel, index_col_label[i])
  }
  col_index_values <- NULL
  for (i in 1:20) col_index_values <- c(col_index_values, which(stringr::str_detect(colnames(mat), paste0("_", i))))
  value_col_name <- colnames(mat)[col_index_values]
  # Now, keep only those and the date and value column
  mat <- dplyr::select(mat, date = date, value_col_name, colnames(mat)[index_col_label_sel])
  colnames(mat) <- c("date", stringr::str_sub(value_col_name, end = -3), stringr::str_sub(colnames(mat)[-c(1,2)], end = -nchar("_label") - 1))
  # Remove Perioden-column
  index_periods <- which("Perioden" == colnames(mat))
  if (length(index_periods)) mat <- mat[, -index_periods]
  index_colnames_NA <- which(is.na(colnames(mat)))
  if (length(index_colnames_NA)) colnames(mat)[index_colnames_NA] <- paste0("Unknown", 1:length(index_colnames_NA))
  if (2 < ncol(mat)) mat <- tidyr::pivot_wider(mat, names_from = colnames(mat)[3], values_from = colnames(mat)[2])
  mat <- as.data.frame(mat)
  
  if (all(is.na(mat$date))) mat <- mat[, -which("date" == colnames(mat))]
  
  mat
}