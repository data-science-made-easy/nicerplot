#
## Document figures
#
fix_path_if_manual_local_dev <- function(path) {
  if (get_param("install_local") & !get_param("install_status_production")) { # if generating local in dev mode, fix path; kind of hack
    path <- file.path(get_param("destination_path"), get_param("report_dir"), path)
  }
  path 
}
isolate_xlsx_and_r_script <- function(p) {
  #
  ## (0) determine parameters
  #
  parameter       <- setdiff(names(p)[!is.na(p)], p$report_dont_print_param_set)
  if (any(p$locked_settings %in% parameter)) {
    parameter <- c(parameter, LOCK)
    p$lock <- "no"
  }
  parameter_value <- p[parameter]

  # Get base name of files
  file_base_name <- tools::file_path_sans_ext(basename(p$figure_path))

  #
  ## (1) create xlsx
  #
  options("openxlsx.numFmt" = NULL)
  wb <- openxlsx::createWorkbook(creator = get_user_name())

  # prepare meta tab
  meta_table <- NULL
  for (i in seq_along(parameter)) {
    meta_table <- rbind(meta_table, c(parameter[i], paste(parameter_value[[i]], collapse = ", ")))
  }

  data_tab_name <- if (is_set(p$id)) p$id else p$tab

  if (is_set(p$tab)) {
    meta_table <- rbind(c("tab", data_tab_name), meta_table)
  }

  # write meta tab
  meta_tab <- "meta"
  openxlsx::addWorksheet(wb, meta_tab)
  openxlsx::writeData(wb, meta_tab, x = meta_table, xy = c("A", 1), colNames = F)
  openxlsx::addStyle(wb, meta_tab, rows = 1:(1 + nrow(meta_table)), cols = 1, style = openxlsx::createStyle(fontColour = "#ED7D31", textDecoration = "bold"))

  # data tab:
  if (is_set(p$tab)) {
    manual_data_tab <- openxlsx::read.xlsx(xlsxFile = get_param("manual_xlsx_input_file"), sheet = p$tab, sep.names = " ", detectDates = T)
    if ("X1" == colnames(manual_data_tab)[1]) colnames(manual_data_tab)[1] = ""
    openxlsx::addWorksheet(wb, data_tab_name)
    openxlsx::writeData(wb, data_tab_name, x = manual_data_tab, xy = c("A", 1))
  } # else {
#     if (use_inner_data) {
#       openxlsx::addWorksheet(wb, "data")
#       openxlsx::writeData(wb, "data", x = p$data, xy = c("A", 1), colNames = T, rowNames = T)
#     }
#   }
  
  result_dir_xlsx <- get_param("manual_xlsx_example_path")
  if (!file.exists(result_dir_xlsx)) dir.create(result_dir_xlsx, showWarnings = F, recursive = T)
  result_file_xlsx <- file.path(result_dir_xlsx, paste0(file_base_name, ".xlsx"))
  openxlsx::saveWorkbook(wb, result_file_xlsx, overwrite = TRUE)

  #
  ## (2) save RData
  #
  # Set path and resulting file name
  result_dir_r <- get_param("manual_R_example_path")
  if (!file.exists(result_dir_r)) dir.create(result_dir_r, showWarnings = F, recursive = T)
  result_file_r_data <- file.path(result_dir_r, paste0(file_base_name, ".RData"))
  result_file_r      <- file.path(result_dir_r, paste0(file_base_name, ".R"))

  # save data
  dput(p$data, result_file_r_data)  
  
  #
  ## (3) create R-script
  #
  write(paste0("source('", knitr::knit(text = fix_path(get_param("manual_source_R_header"))), "')"), file = result_file_r)
  write(paste0("d <- dget('", knitr::knit(text = fix_path(result_file_r_data)), "')"), result_file_r, append = T)

  param_vec <- NULL
  for (i in seq_along(parameter)) {
    param_vec[i] <- paste0(parameter[i], " = c(", paste(if (is.element(get_param_value_type(parameter[i]), c("string", "bool"))) sapply(parameter_value[[i]], function(x) paste0("'", x, "'")) else parameter_value[[i]], collapse = ", "), ")")
  }
  
  param_vec <- c(param_vec, "open = FALSE")
  write(paste0("plot(d, ", paste0(param_vec, collapse = ", "), ")"), result_file_r, append = T)
  
  # (4) return paths
  if (!exists("generate_manual_for_james_start")) generate_manual_for_james_start <- FALSE # Man.. what a hack :-O
  if (generate_manual_for_james_start) {
    return(list(xlsx = result_file_xlsx, rdata = result_file_r_data, r = result_file_r))
  } else {
    return(list(xlsx = fix_path(fix_path_if_manual_local_dev(result_file_xlsx)), rdata = fix_path(fix_path_if_manual_local_dev(result_file_r_data)), r = fix_path(fix_path_if_manual_local_dev(result_file_r))))
  }
}

figure_with_params <- function(report, id = "", ...) {
  if (!missing(id)) {
    stopifnot(1 == length(id))
    cat(paste0("For report, creating id = '", id, "' from xlsx = '", report$xlsx, "' "))
    p <- import(report$xlsx, id = id)[[1]] # , report_output_format = report$report_output_format
  } else {
    cat("Direct figure. ")
    p <- james() #james(format = report$report_output_format)
  }
  
  # Overwrite parameters
  P <- list(...) # TODO kunnen die puntjes niet gewoon in call james( ,...)?
  if (!missing(...)) for (i in seq_along(P)) p[[names(P)[i]]] <- P[[i]]

  # Set file name
  if (!is_set(p$file) & is_set(p$id)) p$file <- p$id

  #
  ## Create param table to display
  #
  param_name  <- setdiff(names(p)[!is.na(p)], p$report_dont_print_param_set)
  style_only_default <- if (is_set(p[[STYLE]])) all(DEFAULT == p[[STYLE]]) else FALSE # we don't want to see style = default
  if (style_only_default) param_name <- setdiff(param_name, STYLE)  # we don't want to see style = default
  param_value <- p[param_name]

  for (i in seq_along(param_value)) {
    if (STYLE == param_name[i]) {
      style_values   <- setdiff(get_parsed(p, param_name[i]), DEFAULT) # we don't want to see default as style
      param_value[i] <- paste(style_values, collapse = ", ")
    } else if (TYPE == param_name[i] && stringr::str_detect(param_value[[i]], "bar--")) {
      param_value[[i]] <- stringr::str_replace_all(string = param_value[[i]], pattern = "bar--", replacement = "bar`--`")
    } else {
      param_value[i] <- paste(get_parsed(p, param_name[i]), collapse = paste0(get_param(param_name[i], "type"), " ")) # fix separators
      if ("TRUE"  == param_value[i]) param_value[i] <- YES[1]
      if ("FALSE" == param_value[i]) param_value[i] <- NO[1]
    }
    
    names(param_value)[i] <- paste0("<a href='#parameter_", param_name[i], "'>", param_name[i], "</a>") # so it's easy to find parameters definition
  }

  # Handle newlines
  for (i in seq_along(param_name)) {
    if (1 == length(param_value[[i]])) if (stringr::str_detect(param_value[[i]], "\\\\n")) {
      param_value[[i]] <- stringr::str_replace(string = param_value[[i]], pattern = "\\\\n", replacement = "<backslash-n>") # amazing, this number of \, isn't it? :-O
      iii <- i
    }
  }

  # Create html table
  param_table <- kableExtra::kable_styling(knitr::kable(unlist(param_value), col.names = NULL, table.attr = "class=\'param\'"))

  # Figure path
  if ("geo-first-example" == id) { # TODO WORKAROUND FOR BUG ON MAC: suddenly can't read *.gpkg file anymore
    p$figure_path <- "ext/img/geo-first-example.png"
  } else if ("geo-three-cols" == id) {
    p$figure_path <- "ext/img/geo-three-cols.png"
  } else if ("geo-participatie-gemeenten" == id) {
    p$figure_path <- "ext/img/geo-participatie-gemeenten.png"
  } else {
    p$figure_path <- plot(p, lock = F)
  }
  rmd_link_to_figure <- if ("pdf" == report$report_format) paste0("\\includegraphics{", p$figure_path, "}") else paste0("![](", p$figure_path, ")")

  # xlsx, RData, R path
  path <- isolate_xlsx_and_r_script(p)
  # TODO unduplicate code below
  html <- paste0(create_anchor(p$id), " <table class=\"fig\">")
  if (10 < p$width) {
    html <- paste0(c(html, "<tr><td>",
            rmd_link_to_figure,
            if (is_set(p$caption)) paste("<BR/>", p$caption) else "",
            "</td></tr>",
            "<tr><td style = \"vertical-align: top;\">\n",
            "<span style='color:#CD0469'>**Relevant parameters:**</span>\n\n",
            kableExtra::column_spec(param_table, 1, bold = T, width_max = '1em', link = "https://dont-remove-this"),
            "</td></tr>\n"),
            "<tr><td>", collapse = "\n")
  } else {
    html <- paste0(c(html, "<tr><td>",
            rmd_link_to_figure, "<BR/>",
            if (is_set(p$caption)) p$caption else "",
            "</td><td style = \"vertical-align: top;\">\n",
            "<span style='color:#CD0469'>**Relevant parameters:**</span>\n\n",
            kableExtra::column_spec(kableExtra::column_spec(param_table, 1, bold = T, link = "https://dont-remove-this"), 2, width = '100%'),
            "</td></tr>\n",
            "<tr><td colspan='2'>"), collapse = "\n")
  }
  
  # Okay, so. We generate the manual twice. Once to be located anywhere (so with links pointing to M-disk). The other one is located in the www/ folder of James Start!. The second one does not have any access outside of the www/ folder. So, in the latter case we need relative paths.
  if (!exists("generate_manual_for_james_start")) generate_manual_for_james_start <- FALSE # Man.. what a hack :-O
  if (generate_manual_for_james_start) {
    james_win_lin_path <- get_param("james_server_2_path")
    james_win_win_path <- get_param("james_windows_path")
    james_sh_path      <- get_param("james_sh_path")
  } else {
    james_win_lin_path <- file.path(get_param("install_root_remote_prod_use_time"), get_param("james_version"), get_param("james_server_2_path"))
    james_win_win_path <- file.path(get_param("install_root_remote_prod_use_time"), get_param("james_version"), get_param("james_windows_path"))
    james_sh_path      <- file.path(get_param("install_root_remote_prod_use_time"), get_param("james_version"), get_param("james_sh_path"))
  }
  
  html <- paste0(c(html,
    "<span style='color:#43B546'><B>How to reproduce this figure:</B></span> copy [this xlsx-file](", path$xlsx, ") and [", get_param("james_server_2_path"), "](", james_win_lin_path, ") (starts on Windows, runs on Linux), [", get_param("james_windows_path"), "](", james_win_win_path, ") (starts on Windows, runs on Windows), or [", get_param("james_sh_path"), "](", james_sh_path, ") (starts on Linux, runs on Linux) to a personal directory and start the batch file. Alternatively, you can also run [this R-script](", path$r, ") in R (starts in R, runs in R).",
    "</td></tr>",
  "</table>"), collapse = "\n")
  
  html  
}

# plot_param_table <- function(report, xlsx_id, ...) {
#   if (!is.element(xlsx_id, report$ids)) error_msg("plot_param_table: '", xlsx_id, "' non-existing!")
#   p <- report$figs[[xlsx_id]]
#
#   # Overwrite parameters
#   P <- list(...)
#   if (!missing(...)) for (i in seq_along(P)) p[[names(P)[i]]] <- P[[i]]
#
#   # if (p$id == "hello-world-styles") jstop(p)
#
#   #
#   ## Create param table to display
#   #
#   param_name  <- setdiff(names(p)[!is.na(p)], p$report_dont_print_param_set)
#   param_value <- p[param_name]
#   # Fix params that have multiple values
#   for (i in seq_along(param_name)) param_value[i] <- paste(param_value[[param_name[i]]], collapse = ", ")
#   # Create html table
#   param_table <- kableExtra::kable_styling(knitr::kable(unlist(param_value), col.names = NULL, table.attr = "class=\'param\'"))
#
#   path_to_example_xlsx <- manual_isolate_xlsx(report, xlsx_id, ...)
#   path_to_example_R    <- manual_isolate_r(report, xlsx_id, ...)
#
#   html <- paste0(c("<table class=\"fig\"><tr><td>",
#     plot(p), "<BR/>",
#     if (is_set(p$caption)) p$caption else "",
#     "</td><td style = \"vertical-align: top;\">\n",
#     "<span style='color:#CD0469'>**Relevant parameters:**</span>\n\n",
#     kableExtra::column_spec(param_table, 1, bold = T, width_max = '1em'),
#     "</td></tr>\n",
#     "<tr><td colspan='2'>",
#     "<span style='color:#43B546'><B>How to reproduce this figure:</B></span> copy [this xlsx-file](", path_to_example_xlsx, ") and [this batch script](", file.path(get_param("install_root_remote_prod_use_time"), get_param("james_version"), paste0("james-", get_param("james_version"), ".bat")), ") (or [this data file](", path_to_example_R$data, ") and [this R-script](", path_to_example_R$script, ")) to your personal directory and start the batch (or R) script.",
#     "</td></tr>",
#   "</table>"), collapse = "\n")
#
#   html
# }

#
## Document parameters
#
see_also <- function(see_also) {
  if (is_set(see_also)) {
    see_also <- stringr::str_trim(stringr::str_split(see_also, ",")[[1]])
    txt <- " See also parameter(s): "
    param_refs <- paste(paste0("[", see_also, "](", paste0("#parameter_", see_also), ")"), collapse = ", ")
    txt <- paste0(txt, param_refs, ".")
  } else {
    txt <- ""
  }
  
  txt
}

describe_params_with_help_appendix_list <- function(report) {
  all_params <- sort(unique(pkg.env$globals$param[which(!is_no(pkg.env$globals$in_manual) & is_set(pkg.env$globals$help))]))
  index_header <- which("#" == stringr::str_sub(all_params,1,1))
  all_params <- all_params[-index_header]  
  txt <- "\n\n"
  for (i in seq_along(all_params)) txt <- paste0(txt, i, ". ", describe_param(report, all_params[i]), "\n")

  txt
}

describe_param <- function(report, param, add_bold_name = TRUE) {
  # Describe the param
  index <- which(param == pkg.env$globals$param)
  p     <- pkg.env$globals[index, ]
  
  if (!is_set(p$help)) p$help <- "Not documented yet."
  
  # Param name, its help and default value.
  if (add_bold_name) {
    txt   <- paste0("<div style='text-align: left'>**`", param, "`**: ", create_anchor(paste0("parameter_", param)), paste(tolower(substr(p$help, 1, 1)), substr(p$help, 2, nchar(p$help)), sep=""))
  } else {
    txt   <- p$help
  }
  
  # Param type
  if (is_set(p[["list-type"]])) {
    this_type <- p[["list-type"]]
    txt <- paste0(txt, " The value is a [list](#param-def) with elements of the [type](#param-def) '", this_type, "' separated by '", p$type, "'.")
  } else {
    this_type <- p$type
    txt <- paste0(txt, " The value is of [type](#param-def) '", this_type, "'.")
  }
  
  # Add unit
  if (!is.na(p$unit))
    txt <- paste0(txt, " Unit: '", p$unit, "'.")

  # Add examples
  if (add_bold_name && !is.na(p$example))
    txt <- paste0(txt, " Example(s): `", p$example, "`.")

  available_styles <- colnames(pkg.env$globals)
  index_col_start  <- which(DEFAULT == available_styles)
  index_col_stop   <- which(INTERACTIVE == available_styles)
  available_styles <- available_styles[index_col_start:index_col_stop]


  # Add other sets
  for (style in available_styles) {
    if (is_set(p[[style]])) {
      this_value <- p[[style]]
      if (is.na(this_value) || DO_NOT_CHANGE == this_value) {
        this_value <- "[not set]"
      } else if (NUMERIC == this_type) {
        if (grepl("^[-]{0,1}[0-9]{0,}.{0,1}[0-9]{1,}$", this_value)) { # only round if this_value is really convertible to numeric!
          this_value <- as.numeric(this_value)
          this_value <- round(this_value, 5) # to prevent ugly values as 0.63500000000000001 and 1.4999999999999999E-2
        }
      }
      txt <- paste0(txt, " For the _", style, "_ style the value is `", this_value, "`.")
    }
  }
  
  txt <- paste0(txt, see_also(p$see_also))
  
  # Add list of figures where this parameter occurs.
  example_figs <- report$param_example_lst[[param]] #get_fig_lst_using_param(param = param, subject = param, ignore_id = NULL)
  if (is_set(example_figs)) txt <- paste(txt, example_figs)
  
  if (add_bold_name) txt <- paste0(txt, "</div>")
  
  txt
}
# describe_param(james(param_example_lst = list(jid=3), type= "report"), "jid")

describe_param_set <- function(report, param_set) {
  index_this_set_start <- which(param_set == pkg.env$globals$param)
  if (!length(index_this_set_start)) error_msg("Paramter set '", param_set, "' does not exist. Please check spelling.")
  index_all_sets_start <- which("# " == stringr::str_sub(pkg.env$globals$param, 1, 2))
  index <- (1 + index_this_set_start):(index_all_sets_start[which(index_this_set_start < index_all_sets_start)[1]] - 1)
  
  this_help <- pkg.env$globals$help[index[1] - 1]
  this_help <- paste0(this_help, see_also(pkg.env$globals$see_also[index[1] - 1]))
  txt <- if (!is_set(this_help) | "NA" == this_help) "" else paste(this_help, " \n\n")
  
  # Sort parameters on alphabet
  index <- index[sort(pkg.env$globals$param[index], index.return = T)$ix]
  
  for (i in index) {
    if (!is_no(pkg.env$globals$in_manual[i])) txt <- paste(txt, "*", describe_param(report, pkg.env$globals$param[i]), "\n")
  }
    
  txt
}

get_param_settings_not_in_any_R_file <- function() {
  p_not_found <- NULL
  params <- pkg.env$globals$param[which("#" != stringr::str_sub(string = pkg.env$globals$param, end = 1))]
  all_files <- NULL
  for (subdir in c("R", "ext/snippet", "ext/script", "ext/template")) {
    all_files <- c(all_files, list.files(file.path(get_param("install_root_local_dev"), subdir), full.names = T))
  }
  for (p in params) {
    found <- F
    for (f in all_files) {
      found_after_dollar   <- length(grep(paste0("\\$", p), x = readLines(f, warn = F)))
      found_after_bracket  <- length(grep(paste0("\\[\\[\"", p), x = readLines(f, warn = F)))
      found_with_get_param <- length(grep(paste0("get_param\\(\"", p), x = readLines(f, warn = F)))
      if (found_after_dollar | found_after_bracket | found_with_get_param) {
        found <- T
        break
      }
    }
    
    if (!found) p_not_found <- c(p_not_found, p)
  }
  
  p_not_found
}

# get_fig_lst_using_param <- function(param, subject, ignore_id = NULL) {
#   meta        <- openxlsx::read.xlsx("james-manual.xlsx", sheet = "meta", colNames = F)
#   index_param <- which(param == meta[, 1])
#   index_fig   <- which(!is.na(meta[index_param, ]))[-1]
#   ids         <- meta[1, index_fig] # just assume id is listed first # which("id" == meta[,1])
#   ids         <- setdiff(ids, ignore_id)
#   index_fig   <- which(meta[1, ] %in% ids)
#   i_row_title <- which("title" == meta[, 1])
#   titles      <- meta[i_row_title, index_fig]
#   if (length(titles)) titles[which(is.na(titles))] <- meta[which("id" == meta[, 1]), index_fig] # use id if no title
#   if (length(ids)) {
#     refs        <- paste0("<a href='#", ids, "'>", titles, "</a>")
#     refs        <- paste(refs, collapse = ", ")
#   }
#
#   if (length(ids)) return(paste0("Example figures using '", subject, "': ", refs, ".")) else return(NULL)
# }

create_parameter_usage_lst <- function() {
  meta <- openxlsx::read.xlsx("james-manual.xlsx", sheet = "meta", colNames = F)
  stopifnot("id" == meta[1,1])
  index_title <- which("title" == meta[, 1])
  lst  <- list()
  for (i in 2:nrow(meta)) { # skip id at i = 1
    index <- which(!is.na(meta[i, ]))[-1] # param self
    if (length(index)) {
      names             <- meta[index_title, index]
      names[which(is.na(names))] <- meta[1, index[which(is.na(names))]]
      names             <- stringr::str_replace_all(string = names, pattern = "\\\\n", replacement = " ")
      links             <- paste0("<a href='#", meta[1, index], "'>", names, "</a>", collapse = ", ")
      lst[[meta[i, 1]]] <- paste0("Figure(s) using '", meta[i, 1], "': ", links, ".")
    }
  }  
  lst
}

get_style_parameters <- function(style) {
  stopifnot("style_" == stringr::str_sub(style, 0, 6))
  name  <- stringr::str_sub(style, 7)
  name  <- stringr::str_replace_all(name, "_", "-")
  index <- which(!is.na(pkg.env$globals[, name]))
  val   <- pkg.env$globals[index, name]
  
  var  <- pkg.env$globals[index, 1]
  unit <- pkg.env$globals[index, UNIT]
  unit <- stringr::str_replace_na(unit, "")
  unit["" != unit] <- paste0(" ", unit["" != unit])
  
  paste0("`", var, "`: ", val, unit, collapse = ", ")
}

figure_list_with_type <- function(this_type) {
  meta <- openxlsx::read.xlsx("james-manual.xlsx", sheet = "meta", colNames = T, rowNames = T)
  types <- meta[TYPE, ]
  types <- stringr::str_split(types, ",")
  types <- lapply(types, stringr::str_trim)
  has_this_type <- unlist(lapply(types, function(vec) is.element(this_type, vec)))
  index <- which(has_this_type)
  names <- meta[TITLE, index]
  names <- stringr::str_replace_all(string = names, pattern = "\\\\n", replacement = " ")
  ids   <- colnames(meta)[index]
  links <- paste0("<a href='#", ids, "'>", names, "</a>", collapse = ", ")
  return(links)
}























