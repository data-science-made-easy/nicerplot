is_report <- function(p) all(REPORT == p$type)

install_root <- function(linux_server = F) if (linux_server) get_param("install_root_remote_prod_use_time_rs") else if (get_param("install_local")) get_param("install_root_local_prod") else if (on_linux_server()) get_param("install_root_remote_prod_use_time_rs") else get_param("install_root_remote_prod_use_time")

complete_output_format <- function(form) {
  if (is.element(form, REPORT_DOC_FORMATS)) {
    form <- paste0(form, "_document")
  } else if (is.element(form, REPORT_PRESENTATION_FORMATS)) {
    form <- paste0(form, "_presentation")
  } else error_msg("You try to create a report of form '", form, "'. However, this form is not (yet) supported. Please try one ore more of the following: ", REPORT_DOC_FORMATS, REPORT_PRESENTATION_FORMATS)

  form
}

data_frame_to_string <- function(df) {
  df_concat <- df[, 1]
  
  # First glue cols together
  if (1 < ncol(df)) for (i in 1:nrow(df)) for (j in 2:ncol(df)) {
     if (!is.na(df[i, j])) df_concat[i] <- stringr::str_c(df_concat[i], df[i, j])
  }
    
  return(df_concat)
  # # Now glue rows together (separated by \n)
  # string <- ""
  # for (i in seq_along(df_concat)) string <- stringr::str_c(string, df_concat[i], "\n")
  #
  # return(string)
}

set_yaml <- function(p, form) {
  print_debug_info(p)

  # if ("---" == stringr::str_sub(p$report_text, end = 3)) return(p) # If there is already a yaml
  if (is_set(p$report_text)) if ("---" == p$report_text[1]) return(p)
  
  yaml <- "---"
  yaml <- c(yaml, readLines(fix_path(p$report_yaml_default, use_local_path = on_mac())))
  if ("html" == form)       yaml <- c(yaml, readLines(fix_path(p$report_yaml_html, use_local_path = on_mac()))) else
  if ("pdf" == form)        yaml <- c(yaml, readLines(fix_path(p$report_yaml_pdf, use_local_path = on_mac())))  else
  if ("word" == form)       yaml <- c(yaml, readLines(fix_path(p$report_yaml_word, use_local_path = on_mac()))) else
  if ("ioslides" == form)   yaml <- c(yaml, readLines(fix_path(p$report_yaml_ioslides, use_local_path = on_mac()))) else
  if ("powerpoint" == form) yaml <- c(yaml, readLines(fix_path(p$report_yaml_powerpoint, use_local_path = on_mac()))) else
    error_msg("Add yaml for ", form)
  
  if (p$report_table_of_content)    yaml <- c(yaml, readLines(fix_path(p$report_yaml_toc, use_local_path = on_mac())))
  if (is_set(p$report_yaml_custom)) yaml <- c(yaml, p$report_yaml_custom)
  
  p$report_text <- c(yaml, "---", "", p$report_text)
  
  p
}

get_user_name <- function() {
  u <- Sys.info()[["user"]]
  unames <- dget(fix_path(get_param("user_names_file"), use_local_path = on_mac()))
  index <- which(u == unames[,"username"])
  if (length(index)) return(unames[index, "full name"]) else return(u)
}

create_report <- function(report) { # TODO rewrite code
  print_debug_info(report)
  print_progress(report, "Creating report with title '", if (is.na(report$title)) "not supplied" else report$title, "' based on xlsx '", report$xlsx, "'...")
  report$create_report_start_time <- Sys.time()
  
  print(paste0("CURRENT SYS TIME: ", report$create_report_start_time))
  
  # Pandoc
  # if (on_windows()) {
  #   print_progress(report, "Setting pandoc location: ", report$pandoc_location_windows)
  #   Sys.setenv(RSTUDIO_PANDOC = report$pandoc_location_windows)
  # }
  
  # Get right file name and create dir for report
  report <- set_file_name(report)
  report_dir <- create_dir_for_file(report$report_file)

  # Create report in each format (html, pdf, ...)
  for (format in report$report_format) {
    print_progress(report, "Creating report in '", format, "'...")
    report$format <- format # so we can adjust the output (e.g. for figures)  
  
    # Copy xlsx style, logo shabba
    file.copy(from = report$xlsx, to = report_dir)
    dir.create(file.path(report_dir, "ext/report"), showWarnings = F, recursive = T)
    file.copy(fix_path(file.path("ext/style", ""), use_local_path = on_mac()), file.path(report_dir, "ext", ""), recursive = T)
    file.copy(fix_path(file.path("ext/img", ""), use_local_path = on_mac()), file.path(report_dir, "ext", ""), recursive = T)
    file.copy(fix_path(file.path("ext/misc", ""), use_local_path = on_mac()), file.path(report_dir, "ext", ""), recursive = T)
    file.copy(fix_path(file.path("ext/report/kmev2021"), use_local_path = on_mac()), file.path(report_dir, "ext/report"), recursive = T)
    if (is_set(report$report_place_files_in_input_dir)) {
      print_progress(report, "Creating directory 'input'...")
      dir.create(file.path(report_dir, "input"), showWarnings = F, recursive = T)
      for (file_to_copy in report$report_place_files_in_input_dir) {
        print_progress(report, "Copy '", file_to_copy, "' to 'input/'")
        file.copy(from = file_to_copy, to = file.path(report_dir, "input", ""), recursive = T)
      }
    }
    
    # Do we have custom text? Or just use default
    add_default_text <- !is_set(report$report_text)

    # Add report text from file
    if (is_set(report$report_text) & is_set(report$report_text_file)) error_msg("You have > 1 report texts: variable 'report_text' is set (may be via 'tab') and on top of that 'report_text_file' is set too. Please make clear which report text you want by removing the other variables.")
      
    HACK_report_text <- report$report_text # For not yet clarified reasons, James-class removes the word 'string' :-O So, I decided to put the report text just in a local variable to avoid all of this. Later james-class should be fixed.
    if (is_set(report$report_text_file)) {
      add_default_text <- F
      HACK_report_text <- readLines(report$report_text_file)
    }
    
    # Create YML
    report <- set_yaml(report, format) # Only add yaml if not in report_text
    HACK_report_text[is.na(HACK_report_text)] <- "" # Replace NA's by empty lines
    # Save report text to report file
    print_progress(report, "Writing report text to file...")
    write(HACK_report_text, report$report_file) # write yaml (and user text)
    
    if (add_default_text) { # write default text if no custom text
      print_progress(report, "Using default report: ", report$report_default_file)
      write(c("", readLines(fix_path(report$report_default_file, use_local_path = on_mac()))), report$report_file, append = T)      
    }

    # Do we want the appendix with all info from James?
    if (report$report_include_james_appendix) write(c("", readLines(fix_path(report$report_james_appendix_path, use_local_path = on_mac()))), report$report_file, append = T)

      # Export one variable, specifically for the manual
    described_param_set <- "hoi"

    # The real work:
    print_progress(report, "Creating the ", format)
    this_report <- rmarkdown::render(input = report$report_file, output_format = complete_output_format(format))
    if (report$debug | is_yes(report$open)) {
      if (report$open) {
        print_progress(report, "Opening report...")
        system(paste("open", this_report))
      }
    }
  }
  
  return(this_report) # path to report
}

set_report_export <- function(p) {
  index <- which(c(p$pdf, p$png, p$jpg, p$svg, p$gif))
  if (1 < length(index)) error_msg("You are creating a figure (", p$file, ".*) for your report. However, you have selected multiple output formats (*) for your figure. Please choose only one of jpg, pdf, png, svg.")
  if (0 == length(index)) p$png <- T

  p
}

# knitr_link_in_current_report_output_format <- function(p) {
#   this_file <- if (p$png) p$png_file else if (p$pdf) p$pdf_file else if (p$jpg) p$jpg_file else if (p$svg) p$svg_file else if (p$gif) p$gif_file else p$png_file # or error
#   if ("pdf" == p$report_output_format) return(paste0("\\includegraphics{", this_file, "}"))
#   else return(paste0("![](", this_file, ")"))
# }

# caption_html <- function(p) {
#   if (!is_set(p)) {
#     return("")
#   } else {
#     this_cap <- if (is_set(p$caption)) p$caption else ""
#
#     if ("pdf" == p$format) return(kableExtra::cell_spec(paste0(this_cap, "\n", "[id: ", p$id, "]"), italic = T, format = if ("pdf" == p$format) "latex" else if ("ioslides" == p$format) "html" else p$format))
#     else return(paste0("*", this_cap,"*. <BR/>[id: ", p$id, "]"))
#   }
# }
create_anchor <- function(id) paste0("<a name=\"", id, "\"></a>")
link          <- function(id) paste0("[", id, "](#", gsub('[[:punct:] ]+|\n','-', stringr::str_to_lower(id)), ")")
link_param    <- function(id) paste0("[`", id, "`](#parameter_", id, ")")
link_fig      <- function(id, title = "this figure") paste0("[", title, "](#", id, ")")

vec_as_md_list <- function(vec) {
  lst <- "\n"
  for (i in seq_along(vec)) lst <- paste0(lst, i, ". ", vec[i], "\n")    
  lst
}

vec_as_md_seq <- function(vec) {
  paste0("(", 1:length(vec), ") ", sapply(vec, function(s) paste0("`", s, "`")), collapse = ", ")
}

plot_all_figs_in_xlsx <- function(report) {
  lst <- import(basename(report$xlsx)) # basename takes local copy of the xlsx-file

  if (0 == length(lst)) return(NULL) # nothing to do
  
  index_report <- which(sapply(lst, function(p) is_report(p) & !is_no(p$create)))
  if (length(index_report)) lst <- lst[-index_report]

  res <- NULL
  for (elt in lst) {
    res <- c(res, paste0("## ", elt$title, "\n\n"))
    
    path <- plot(elt)
    path <- if ("pdf" == report$report_format) paste0("\\includegraphics{", path, "}") else paste0("![](", path, ")")
    
    caption <- if (is_set(elt$caption)) c(elt$caption, "<BR/>\n\n") else ""
    res <- paste0(c(res, path, "<BR/>\n\n", caption), collapse = "")
  }

  res
}



























