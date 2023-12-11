set_file_name <- function(p) {
  print_debug_info(p)

  # init names:
  if (!is_set(p$file)) {
    if (is_set(p$id))
      p$file <- p$id            # try id
    else if (is_set(p$title) & (0 < nchar(p$title)))
      p$file <- p$title         # try title
    else if (is_set(p$tab))
      p$file <- p$tab           # try tab name
    else if (is_report(p)) {
      p$file <- "james-report"  # just a report name
    } else {
      p$file <- "james-figure"  # just a file name
    }
  }  

  if (p$time_stamp) p$file <- paste0(p$file, "-", time_stamp())

  if (p$file_correct_name) p$file <- gsub('[[:punct:] ]+|\n','-', p$file) # for linux, OSx, remove punctuation, white space, and newlines
  p$file <- stringi::stri_trans_general(p$file, "Latin-ASCII")
  ## PDF name
  if (!is_set(p$pdf_file)) p$pdf_file <- file.path(p$destination_path, p$pdf_dir, paste0(p$file, ".pdf"))
  ## PNG name
  if (!is_set(p$png_file)) p$png_file <- file.path(p$destination_path, p$png_dir, paste0(p$file, ".png"))
  ## JPG name
  if (!is_set(p$jpg_file)) p$jpg_file <- file.path(p$destination_path, p$jpg_dir, paste0(p$file, ".jpg"))
  ## SVG name
  if (!is_set(p$svg_file)) p$svg_file <- file.path(p$destination_path, p$svg_dir, paste0(p$file, ".svg"))
  # ## GIF name
  # if (!is_set(p$gif_file)) p$gif_file <- file.path(p$destination_path, p$gif_dir, paste0(p$file, ".gif"))

  # Report name
  if (!is_set(p$report_file)) p$report_file <- file.path(p$destination_path, p$report_dir, paste0(p$file, ".Rmd"))

  return(p)
}