any_plot_export <- function(p) any(p$pdf, p$png, p$jpg, p$svg, p$gif)

create_dir_for_file <- function(file_name, quiet = F) {
  this_dir <- dirname(file_name)
  if (!dir.exists(this_dir)) {
    if (!quiet) show_msg("Creating directory '", this_dir, "' to store figures.")
    dir.create(this_dir, showWarnings = FALSE, recursive = TRUE)
  }

  return(this_dir)
}