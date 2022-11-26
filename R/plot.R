#' @title Plots Data from File or URL
#' @description Creates nice figures (PNG, PDF, SVG, JPEG).
#' @param x may be 'path/to/file.xlsx' (please note: at the current moment Excel files must have a meta-tab) or a URL referring to Statistics Netherlands.
#' @param ... you can add parameters to customize your figure (see manual). For example `title` to specify a title, `pdf = TRUE` if you want a PDF (`png = TRUE` by default), and `file` to specify file name (with `file`.{png,pdf,jpg,svg} as a result).
#' @return path/to/result/file.png
#' @details
#' \href{https://github.com/data-science-made-easy/nicerplot/raw/master/inst/extdata/examples/xlsx/hello-world.xlsx}{hello-world.xlsx} is an example of an xlsx-file, which you can plot with this function. Please find many other examples in same directory.
#' @examples
#' \dontrun{
#' # please find a link to hello-world.xlsx in details above
#' nplot("hello-world.xlsx")
#' # plot up-to-date data from CBS (Statistics Netherlands)
#' nplot("https://opendata.cbs.nl/statline/#/CBS/nl/dataset/83913NED/table?dl=323FD")
#' }
nplot.character <- function(x, ...) {
  # string may be file or cbs-url
  if (file.exists(x)) { # try file
    # For now we allow only xlsx files with a 'meta' tab
    if (!is.element(META, openxlsx::getSheetNames(x))) {
      show_msg("Skipping file '", x, "' because it has no meta tab. Please see manual for details.")
      return(invisible(NULL)) # nothing to do
    } else {
      # get figs as lst
      lst <- import(xlsx = x, ...)

      if (0 == length(lst)) {
        print_warning("Nothing to do...")
        return(invisible(NULL)) # nothing to do
      }
    
      # If lst contains report(s), only handle report(s). Else, plot lst.
      index_report <- which(sapply(lst, function(p) is_report(p) & !is_no(p$create)))
      if (1 < length(index_report)) error_msg("Currently, James can only produce one report per xlsx-file.")
      if (length(index_report)) { # We want a report
        return(nplot(lst[[index_report]], ...))
      } else { # We just want figures
        return(nplot(lst))
      }
    }    
  } else { # try cbs
    if ("https://" == stringr::str_sub(x, 1, 8)) {
      return(nplot(james(data = cbs(x), ...)))
    } else {
      error_msg("File '", x, "' not found.")
    }
  }
}

#' @title Nicer Plot of Matrix
#' @description Creates nice figures (PNG, PDF, SVG, JPEG).
#' @param x matrix
#' @param ... you can add parameters to customize your figure (see manual)
#' @return path/to/result/files.png
nplot.matrix <- function(x, ...) {
  nplot(james(data = x, ...))
}

#' @title Nicer Plot of Data Frame
#' @description Creates nice figures (PNG, PDF, SVG, JPEG).
#' @param x data.frame
#' @param ... you can add parameters to customize your figure (see manual)
#' @return path/to/result/files.png
nplot.data.frame <- function(x, ...) {
  nplot(james(data = x, ...))
}

#' @title Nicer Plot of Time Series Data
#' @description Creates nice figures (PNG, PDF, SVG, JPEG).
#' @param x ts object
#' @param ... you can add parameters to customize your figure (see manual)
#' @return path/to/result/files.png
nplot.ts <- function(x, ...) {
  z <- cbind(as.vector(stats::time(x)), unclass(x)) # can deal with ts and also deal with 'cpb/regts'
  nplot(james(data = z, ...))
}

#' @title Nicer Plot of Multivariate Time Series Data
#' @description Creates nice figures (PNG, PDF, SVG, JPEG).
#' @param x ts object
#' @param ... you can add parameters to customize your figure (see manual)
#' @return path/to/result/files.png
nplot.mts <- function(x, ...) { # multi variate time series
  nplot.ts(x, ...)
}

#' @title Nicer Plot of Elements in List
#' @description Creates nice figures (PNG, PDF, SVG, JPEG).
#' @param x list must contain elements of a class that can be plotted by this package (e.g., matrix, data.frame, character, ts, mts)
#' @param ... you can add parameters to customize your figure (see manual)
#' @return path/to/result/files.png
nplot.list <- function(x, ...) {
  # Overwrite parameters in each imported item p with those in P
  P <- list(...)
  
  # (i) Add ... parameters to each p element lst x; (ii) find out which figures to process in parallel
  index_parallel <- NULL
  for (i_p in seq_along(x)) {
    p <- x[[i_p]]

    # Add super parameters to p
    if (!missing(...)) {
      for (i in seq_along(P)) {
        p[[names(P)[i]]] <- P[[i]]
      }
    }

    if (p$parallel) index_parallel <- c(index_parallel, i_p)
  }
  
  #
  index_all        <- seq_along(x)
  index_sequential <- setdiff(index_all, index_parallel)
  #
  # # Create figs and collect paths to those figs
  paths <- NULL
  #
  # # PARALLEL
  if (length(index_parallel)) {
    show_msg("Starting to create [", length(index_parallel), "] of [", length(x), "] figures in parallel on [", parallel::detectCores(), "] cores...")
    p_result_lst <- parallel::mclapply(x[index_parallel], plot_continue_on_error)
    
    error_text <- NULL
    for (i in seq_along(p_result_lst)) {
      p <- p_result_lst[[i]]

      if (is_set(p$error)) {
        error_text <- paste0(c(error_text, "ERROR IN FIGURE '", set_file_name(p)$file, ".*':\n"), collapse = "")
        error_text <- paste0(c(error_text, paste0(p$error), "\n\n"), collapse = "")
      }

      paths <- c(paths, p$figure_path)
    }
    
    # STOP IF ANY ERROR
    if (!is.null(error_text)) stop(paste0("\n\n", error_text)) else if (!p$quiet) show_msg("Done.")
  }

  # # SEQUENTIAL
  if (length(index_sequential)) {
    if (!p$quiet) show_msg("Starting to create [", length(index_sequential), "] of [", length(x), "] figures.\n")
    for (p in x[index_sequential]) paths <- c(paths, nplot(p))
  }
    
  # Check for duplicated file names
  index_duplicated <- which(duplicated(paths))
  if (length(index_duplicated)) error_msg("Some of your figures are overwritten on disk because they have equal file names (i.e., ", paths[index_duplicated], "). Please use parameter 'file' to assign different file names.")
  
  paths
}

plot_continue_on_error <- function(p) {
   path_or_error <- tryCatch(
    {
      nplot(p)
    }, error = function(cond) {
      p$error <<- cond
    }, finally = {
      # Nothing to do :-)
    }
  )
  
  if (!is.element("error", class(path_or_error))) p$figure_path <- path_or_error
  
  p
}

#' @title Nicer Plot of James Object
#' @description Creates nice figures (PNG, PDF, SVG, JPEG).
#' @param p object of class james
#' @param ... you can add parameters to customize your figure (see manual)
#' @return path/to/result/files.png
nplot.james <- function(p, ...) {
  print_debug_info(p)

  # TODO
  # Read ~/.james with 'base settings' like 'open = TRUE', e.g.:
  # private_settings <- james("~/.james")
  # p <- combine_lists(high_prio = p, low_prio = private_settings)

  # Overwrite parameters p
  P <- list(...)
  if (!missing(...)) for (i in seq_along(P)) p[[names(P)[i]]] <- P[[i]]
  
  # Skip if !create
  if (is_no(p$create)) {
    print_progress(p, "Skipping '", p$id, "' (create = no).")
    return()
  }
  
  # Check for report
  if (is_report(p)) { # "Plot" the report
    print_progress(p, "Creating report...")
    path <- create_report(p)
    return(path)
  }

  # If creating report, (only) produce PDF
  if (creating_report_now()) p <- set_report_export(p) # TODO is dit nodig?

  # Set file name
  p <- set_file_name(p)
  
  # Set hash
  p <- set_hash_p(p)

  # Return 'paths' of created figures (even if they are cached)
  paths <- NULL
  if (p$png) paths <- c(paths, p$png_file)
  if (p$pdf) paths <- c(paths, p$pdf_file)
  if (p$jpg) paths <- c(paths, p$jpg_file)
  if (p$svg) paths <- c(paths, p$svg_file)
  if (p$gif) paths <- c(paths, p$gif_file)
  if (is.null(paths)) paths <- p$png_file # Why is this? <--

  # Flags down (for pdf, png, ...) if figure already exists (cache)
  p <- set_export_flags(p)

  # Stop if nothting to do!
  if (!any_plot_export(p) & !p$r_plot) return(invisible(paths))
  
  # If a parameter with suffix _r exists, e.g. x_r, then evaluate its value and assign it to the 'base parameter' (here: x)
  p <- eval_parameter_values(p)
  
  # Set resolution for PNG, JPG
  showtext::showtext_opts(dpi = p$resolution)
  
  # First start pre-processing pipeline according to function order in james-base-settings file
  if (!p$gif & any_file_to_save(p)) p <- start_preprocess_pipeline(p)

  if (p$pdf) {
    # p$pdf_active_hack_font <- TRUE
    print_progress(p, "Creating ", file.path(p$destination_path, basename(p$pdf_file)), "...")
    showtext::showtext_auto(enable = FALSE)
    plot_james_pdf(p)
    # p$pdf_active_hack_font <- FALSE
    print_info(p, "Embedding fonts in pdf...")
    
    # if (on mac) {
    #   extrafont::embed_fonts(p$pdf_file)
    # } else {
    #   if (on linux) {
    #     font_path <- paste0("/cifs/p_james/fonts")
    #   } else {# on windows
    #     font_path <- get_param(...)
    #   }
    #   if (!dir.exists(font_path)) error_msg("Directory with fonts does not exist: ", font_path)
    #   grDevices::embedFonts(p$pdf_file, options = paste0("-sFONTPATH=", font_path))
    # }
    #
    
    if (on_mac()) {
      extrafont::embed_fonts(p$pdf_file)
    } else {
      font_path <- get_first_existing(get_param("font_path"))
      if (!dir.exists(font_path)) error_msg("Directory with fonts does not exist: ", font_path) 
      grDevices::embedFonts(p$pdf_file, options = paste0("-sFONTPATH=", font_path))      
    }

    save_hash(p, "pdf")
    if (!p$quiet) show_msg("Done.")
    if (!creating_report_now() & is_yes(p$open)) {
      print_progress(p, "Opening ", p$pdf_file)
      system(paste("open", p$pdf_file), wait = FALSE)
    }
  }

  if (p$png) {
    print_progress(p, "Creating ", file.path(p$destination_path, basename(p$png_file)), "...")
    p <- init_font(p)
    showtext::showtext_auto(enable = TRUE)
    plot_james_png(p)
    showtext::showtext_auto(enable = FALSE) # double check
    save_hash(p, "png")
    if (!p$quiet) show_msg("Done.")
    if (!creating_report_now() & is_yes(p$open)) {
      print_progress(p, "Opening ", p$png_file)
      system(paste("open", p$png_file))
    }
  }
  if (p$jpg) {
    print_progress(p, "Creating ", file.path(p$destination_path, basename(p$jpg_file)), "...")
    p <- init_font(p)
    showtext::showtext_auto(enable = TRUE)
    plot_james_jpg(p)
    showtext::showtext_auto(enable = FALSE) # double check
    save_hash(p, "jpg")
    if (!p$quiet) show_msg("Done.")
    if (!creating_report_now() & is_yes(p$open)) {
      print_progress(p, "Opening ", p$jpg_file)
      system(paste("open", p$jpg_file))
    }
  }
  if (p$svg) {
    print_progress(p, "Creating ", file.path(p$destination_path, basename(p$svg_file)), "...")
    p <- init_font(p)
    plot_james_svg(p)
    save_hash(p, "svg")
    if (!p$quiet) show_msg("Done.")
  }
  if (p$gif) {
    print_progress(p, "Creating ", basename(p$gif_file), "...")
    if (is_set(p$format)) if (!is.element(p$format, c("html", "ioslides"))) error_msg("You try to create a gif-file for a report that is not 'html' or 'ioslides'. Please choose another format. E.g. set gif = F and png = T.")
    p <- init_font(p)
    showtext::showtext_auto(enable = TRUE)
    gif_file <- plot_james_gif(p)$gif_file
    p$gif_file <- gif_file
    showtext::showtext_auto(enable = FALSE) # double check
    # to do: cash
    if (!p$quiet) show_msg("Done.")
    if (!creating_report_now() & is_yes(p$open)) {
      print_progress(p, "Opening ", p$gif_file)
      system(paste("open", p$gif_file))
    }
  }

  if (!any_plot_export(p) & p$r_plot) p <- plot_james_internal(p)

  return(invisible(paths))
}

plot_james_pdf <- function(p) {
  print_debug_info(p)
  create_dir_for_file(p$pdf_file, p$quiet)
  # extrafont::font_import() # ONLY ONCE
  extrafont::loadfonts(quiet = TRUE)
  on.exit(grDevices::dev.off())
  # p <- set_point_size(p)

  grDevices::pdf(p$pdf_file, width = p$width / grDevices::cm(1), height = p$height / grDevices::cm(1), pointsize = p$font_size, useDingbats = FALSE, family = p$font)

  p <- plot_james_internal(p)
  
  todo(p, "Fix return value of plot")
  # return(p)
}

# set_point_size <- function(p) { # this may be a bit confusing: we are setting point size here (as the function name suggests), but for practical reasons of understandibiliy the respective parameter is called font_size
#   print_debug_info(p)
#
#   if (!is_set(p$font_size)) {
#     p$font_size <- 7
#   }
#
#   # To use graphics::strwidth for png/jpg, we need to create a tmp-pdf file. For the tmp-pdf file we need the original font_size
#   p$font_size_original <- p$font_size
#
#   if (creating_pdf_now() | creating_svg_now()) {
#     # do nothing
#   } else if (creating_png_now()) {
#       #p$font_size <- p$resolution / 150 * p$font_size * 1.7
#   } else if (creating_jpg_now()) {
#     if (!is_set(p$font_size_grDevices::jpeg)) {
#       #p$font_size_grDevices::jpeg <- p$resolution / 150 * p$font_size * 1.7
#     }
#   }
#
#   return(p)
# }

plot_james_png <- function(p) {
  print_debug_info(p)
  create_dir_for_file(p$png_file, p$quiet)
  on.exit({grDevices::dev.off(); showtext::showtext_auto(enable = FALSE)})
  # p <- set_point_size(p)

  grDevices::png(p$png_file, width = p$width / grDevices::cm(1), height = p$height / grDevices::cm(1), pointsize = p$font_size, unit = "in", res = p$resolution, type = "cairo")
  
  p <- plot_james_internal(p)
  todo(p, "Fix return value of plot")
  # return(p)
}

plot_james_jpg <- function(p) {
  print_debug_info(p)
  create_dir_for_file(p$jpg_file, p$quiet)
  on.exit({grDevices::dev.off(); showtext::showtext_auto(enable = FALSE)})
  # p <- set_point_size(p)
  grDevices::jpeg(p$jpg_file, width = p$width / grDevices::cm(1), height = p$height / grDevices::cm(1), pointsize = p$font_size, unit = "in", res = p$resolution, quality = p$quality, type = "cairo") # , family = p$font seems not to work here; instead inject everywhere apart
  p <- plot_james_internal(p)
  # return(p)
}

plot_james_svg <- function(p) {
  print_debug_info(p)
  create_dir_for_file(p$svg_file, p$quiet)
  # extrafont::font_import() # ONLY ONCE
  extrafont::loadfonts(quiet = TRUE)
  # if ("windows" == .Platform$OS.type) loadfonts(device = "win")
  # if (!is.element("rijk", names(grDevices::pdfFonts()))) {
  #   rijk <- grDevices::pdfFonts()$RijksoverheidSansText
  #   rijk$metrics <- rijk$metrics[c(1,3,2,4,5)]
  #   grDevices::pdfFonts(rijk = rijk)
  # }
  on.exit(grDevices::dev.off())
  # p <- set_point_size(p)
  grDevices::svg(p$svg_file, width = p$width / grDevices::cm(1), height = p$height / grDevices::cm(1), pointsize = p$font_size, family = p$font)
  p <- plot_james_internal(p)
  
  todo(p, "Fix return value of plot")
  # return(p)
}

plot_james_gif <- function(p) {
  print_debug_info(p)
  create_dir_for_file(p$gif_file, p$quiet)
  on.exit({if (length(grDevices::dev.list())) grDevices::dev.off();showtext::showtext_auto(enable = FALSE)})
  # jstop(p)
  # Make end figure to derive y_lim
  p$gif = F
  p$png = F
  data_orig <- p$data
  p_orig <- p
  p_gif_pngs <- p$gif_pngs
  p <- start_preprocess_pipeline(p)
  y_lim <- p$y_lim
  
  p <- p_orig
  p$y_lim <- y_lim
  p$gif_pngs <- p_gif_pngs
  dir.create(file.path(p$destination_path, p$gif_dir, "pngs-for-gif"), showWarnings = F, recursive = T)
  if (!is_set(p$gif_pngs)) p$gif_pngs <- file.path(p$destination_path, p$gif_dir, "pngs-for-gif", paste0(p$file, "-", 1:p$gif_n_frames, ".png"))
  for (i in 1:p$gif_n_frames) {
    p$png_file <- p$gif_pngs[i]
    p$data <- (i - 1) / (p$gif_n_frames - 1) * data_orig
    nplot(p, png = T, gif = F, open = F)
  }

  ## GIF name
  if (is.na(p$gif_file)) p$gif_file <- file.path(p$destination_path, p$gif_dir, paste0(p$file, ".gif"))
  
  gifski::gifski(p$gif_pngs, p$gif_file, delay = p$gif_delay, loop = p$gif_loop)
  
  todo(p, "gifff")
  
  p
}
