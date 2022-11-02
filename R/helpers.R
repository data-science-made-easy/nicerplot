on_windows       <- function() "windows" == .Platform$OS.type
on_mac           <- function() "mac" == stringr::str_sub(.Platform$pkgType, end = 3)
on_linux_server  <- function() "linux-gnu" == version$os
creating_png_now <- function() is.element("plot_james_png", unlist(lapply(lapply(sys.calls(), as.character), function(vec) vec[1])))
creating_pdf_now <- function() is.element("plot_james_pdf", unlist(lapply(lapply(sys.calls(), as.character), function(vec) vec[1])))
creating_jpg_now <- function() is.element("plot_james_jpg", unlist(lapply(lapply(sys.calls(), as.character), function(vec) vec[1])))
creating_svg_now <- function() is.element("plot_james_svt", unlist(lapply(lapply(sys.calls(), as.character), function(vec) vec[1])))

creating_report_now <- function() isTRUE(getOption('knitr.in.progress'))

any_file_to_save <- function(p) any(p$gif | p$jpg | p$pdf | p$png | p$svg)

time_stamp <- function() format(Sys.time(), "%Y-%m-%d-%H.%M.%S")

hack_font <- function(p, x) {
  # if (!creating_pdf_now() | "RijksoverheidSansText" != p$font) return(x)
  # if (2 == x) return(3)
  # if (3 == x) return(2)
  return(x)
}

fix_lty_vector_graphics <- function(lty) if (3 == lty & (creating_pdf_now() | creating_svg_now())) return(2) else return(lty)

# append multiple values
mappend <- function(x, values, after = length(x)) {
  vec <- rep(x, (1:2)[(1:length(x) %in% after) + 1])
  vec[after + 1:length(after)] <- values
  vec
}

get_param <- function(name, style = DEFAULT) {
  index <- which(name == pkg.env$globals$param)
  if (!length(index)) {
    return(NA)
  } else {
    val <- pkg.env$globals[index, style] 

    # Cast value
    type <- pkg.env$globals[index, TYPE]
    type_original <- type
    if (is.element(type, LIST_SEPS)) {
      type <- pkg.env$globals[index, LIST_TYPE]
    }
    
    if (type == R)       val <- eval(parse(text = val))
    if (type == NUMERIC) val <- as_native_vec(val, type_original) #as.numeric(val)     # TODO tryCatch
    if (type == STRING)  val <- as_char_vec(val, sep = type_original, trim = REPORT_TEXT != name) # Leave report intact.
    if (type == PATH)    val <- as_char_vec(val, sep = type_original)
    if (type == BOOL)    { # Let NA intact, transform rest to T, F
      index_NA  <- which(is.na(val))
      val       <- is_yes(val)
      if (length(index_NA)) val[index_NA] <- NA # Set NA's back
    }  
    if (type == DATE) {
      if ("Date" != class(val)) {
        if (grepl("^[-]{0,1}[0-9]{0,}.{0,1}[0-9]{1,}$", val)) { # val MUST be number
          val <- as.Date(as.numeric(val), origin = "1899-12-30")
        } else print_warning(paste0("Parameter '", name, "' for style '", style, "' has value '", val, "' which is not Date and not numeric. Unsure if date value is interpreted right here."))
      }
    }
    
    return(val)
  } 
}

param_is_list_type <- function(name) {
  index <- which(name == pkg.env$globals$param)
  if (!length(index)) 
    error_msg("Parameter does not exist: ", name)
  
  is.element(pkg.env$globals[index, TYPE], LIST_SEPS)
}

get_param_value_type <- function(name) {
  index <- which(name == pkg.env$globals$param)
  if (!length(index)) {
    return("unknown")
  }
  type <- pkg.env$globals[index, TYPE]
  if (is.element(type, LIST_SEPS)) type <- pkg.env$globals[index, LIST_TYPE]

  return(type)
}

get_param_list_sep <- function(name) {
  index <- which(name == pkg.env$globals$param)
  if (!length(index)) 
    error_msg("You want to know the list separator for a non-existing parameter: ", name)
  
  list_sep <- pkg.env$globals[index, TYPE]
  if (!is.element(list_sep, LIST_SEPS))
    error_msg("You ask for the list separator of parameter '", name, "'. However, this parameter is not of type list.")
  else
    return(list_sep)
}

get_param_replicate <- function() pkg.env$globals$param[which(is_yes(pkg.env$globals[[REPLICATE]]))]

is_really_character <- function(vec) {
  if ("character" == class(vec)) {
    return("character" == class(type.convert(vec, as.is = TRUE)))
  } else return(FALSE)
}

set_newline <- function(string) stringr::str_replace_all(string, "\\\\n", "\n")

has_value <- function(x) { # Considers NA to be a value
  if (0 == length(x)) # NB 0 == length(NULL)
    return(FALSE)
  x <- paste(x, collapse="")
  if (is.na(x))
    return(TRUE)
  return("" != stringr::str_trim(x))
}

is_set <- function(x) { # Returns TRUE for c(1, NA)
  if (0 == length(x)) return(FALSE) else if (1 == length(x)) return(!is.na(x)) else return(TRUE)
}
is_set_vec <- function(vec) sapply(vec, is_set)

get_x <- function(p, x, name = "unknown") {
  if (any(!is_set_vec(suppressWarnings(as.numeric(rownames(p$data)))))) { # only proceed if any of the x's is not numeric
      corresponding_int <- which(as.character(x) == as.character(rownames(p$data)))
    if (1 != length(corresponding_int)) {
      error_casting_x_lab(param_name = name, problematic_value = x, possible_values = rownames(p$data))
    } else {
      x <- corresponding_int
    }
  } else {
    # ? IS THIS CHECK NOT TOO MUCH?!
    if (!is.element(x, rownames(p$data)))
      error_casting_x_lab(param_name = name, problematic_value = x, possible_values = rownames(p$data))
  }    
  x
}

fix_numbers <- function (vec, n_decimals, decimal_mark, big_mark) {
    vec <- as.numeric(vec)
    if (!is_set(n_decimals)) n_decimals <- max(n_digits(vec))
    if (is_no(big_mark)) big_mark <- ""
    vec <- format(round(vec, n_decimals), nsmall = n_decimals, big.mark = big_mark, decimal.mark = decimal_mark, scientific = F)
    vec <- trimws(vec)
    # if ("." != decimal_mark) vec <- stringr::str_replace(c(vec), "\\.", decimal_mark)

    return(vec)
}

n_digits <- function (vec) {
  if (1 < length(vec)) {
   return(sapply(vec, n_digits))
  } else {
    if (vec == round(vec)) return(0) else return(nchar(as.character(gsub("(.*)(\\.)|([0]*$)", "", vec))))
  }
}

get_str_dim <- function(p, x, horizontal = TRUE, ...) {
  h <- graphics::strwidth(x, ...)
  v <- graphics::strheight(x, ...)

  if (!horizontal) {
    x_lim_full <- diff(graphics::par()$usr[1:2])
    y_lim_full <- diff(graphics::par()$usr[3:4])
    x_inch     <- graphics::par("pin")[1]
    y_inch     <- graphics::par("pin")[2]
    
    h_  <- h
    h   <- v  * x_lim_full / y_lim_full * y_inch / x_inch
    v   <- h_ * y_lim_full / x_lim_full * x_inch / y_inch
  }    
  
  return(list(h = h, v = v))
}

#' @keywords internal
as_char_vec <- function(str, sep = SEP1, trim = TRUE) {
  # if (!is.na(str) && !is.null(str) && str == sep) return(str) else {
  if (identical(sep, str)) return(str) else {
    vec <- unlist(stringr::str_split(str, sep))
    if (trim) return(stringr::str_trim(vec)) else return(vec)
  }
}
as_numeric_vec <- function(str) as.numeric(as_char_vec(str))
as_native_vec <- function(str, sep = SEP0) {
  vec <- as_char_vec(str, sep = sep)
  if (is_really_character(vec))
    return(vec)
  else
    return(as.numeric(vec))
}

strings_to_vectors <- function(meta, skip_fields = NULL) {
  input_char <- is.character(meta)
  if (input_char) meta <- list(whatever = meta)
    
  for (i in seq_along(meta)) {
    val <- meta[[i]]
    if (!is.element(names(meta)[i], skip_fields) && "character" == class(val)) {
      meta[[i]] <- as_native_vec(val)
    }
  }
  
  if (input_char) meta <- unlist(meta)
  
  return(meta)
}

combine_lists <- function(high_prio, low_prio) {
  if (0 == length(low_prio)) return(high_prio)
  
  lst <- low_prio
  
  for (i in seq_along(high_prio)) {
    var <- names(high_prio)[i]
    value <- high_prio[[i]]
    
    # Only use NA to overwrite if var was non-existent
    # if (is.null(value) || !is.na(value) || is.null(lst[[var]])) lst[[var]] <- value
    if (is_set(value)) lst[[var]] <- value
  }
  
  return(lst)
}

get_params_from_col_as_list <- function(df, col_name) {
  index <- which(!is.na(df[, col_name]))
  meta  <- list()
  for (i in index)
    meta[[df$param[i]]] <- df[i, col_name]
  meta
}

#' @keywords internal
is_no <- function(val) {
  if (is.null(val))
    return(FALSE)
  else
    return(is.element(val, NO))
}

#' @keywords internal
is_yes <- function(val) {
  if (1 < length(val)) return(as.vector(sapply(val, is_yes)))
    
  if (is.null(val) || is.na(val))
    return(FALSE)
  else
    return(is.element(val, YES) || (is.logical(val) && val))
}

swap_xy <- function(p) {
  if (p$turn) {
    q <- p
    q$x_title <- p$y_title
    q$y_title <- p$x_title
    q$x_lim <- p$y_l_lim
    q$y_l_lim <- rev(p$x_lim) # Reverse because we want smallest above
    p <- q
  }
  
  p
}

# get_example_names <- function() names(meta_pp)

# j_get_example_meta <- function(example) {
#   meta <- meta_pp[[example]]
#
#   meta_sheet <- read.xlsx(paste("../../", get_param("james_example_xlsx"), sep = ""), sheet = "meta", rowNames = TRUE, colNames = FALSE)
#
#   # select col
#   col_index <- which(example == meta_sheet["name", ])
#   if (!length(col_index))
#     col_index <- which(example == meta_sheet["tab", ] & is.na(meta_sheet["name", ]))
#
#   index_meta <- which(!is.na(meta_sheet[, col_index]))
#   meta_names <- rownames(meta_sheet)[index_meta]
#
#   return(meta[c(meta_names, "data")])
# }

make_transparent <- function(hex_col, alpha = .5) grDevices::rgb(t(grDevices::col2rgb(hex_col) / 255), alpha = alpha)

seqft <- function(ft) seq(from = ft[1], to = ft[2])
styles <- function() colnames(pkg.env$globals)[seqft(which(is.element(colnames(pkg.env$globals), c(DEFAULT, INTERACTIVE))))]
types <- function() get_param("type", style = EXAMPLE)

odd_elements  <- function(vec) {
  if (length(vec) < 1) NULL else vec[seq(from = 1, to = length(vec), by = 2)]
}

even_elements <- function(vec) {
  if (length(vec) < 2) NULL else vec[seq(from = 2, to = length(vec), by = 2)]
}

fix_path <- function(path = '', use_local_path = F, linux_server = F, return_relative_path_only = F) { # Don't replace use_local_path = F with use_local_path = on_mac()
  if (return_relative_path_only) return(path)

  path_prefix <- ""
  if (get_param("install_status_production")) { # PROD
    if (get_param("install_local")) { # Local Prod = /tmp/dev, Local Dev = ~/Dropbox/cpb/git/james
      # PROD & LOCAL
      path_prefix <- get_param("install_root_local_prod")
    } else { # PROD & REMOTE
      if (use_local_path) { # PROD & REMOTE & INSTALL-TIME
        path_prefix <- get_param("install_root_remote_prod_install_time")
      } else { # PROD & REMOTE & USE-TIME
        if (linux_server | on_linux_server()) { # On 'rekenserver' / linux server
          path_prefix <- get_param("install_root_remote_prod_use_time_rs")
        # } else if (on_mac()) { # On Mac ## "darwin17.0" == version$os also works
        #   path_prefix <- get_param("install_root_local_dev")
        } else { # assume windows
          path_prefix <- get_param("install_root_remote_prod_use_time")
        }
      }
    }
    
    # Append james_version
    path_prefix <- file.path(path_prefix, get_param("james_version"))
  } else { # DEV
    if (get_param("install_local")) { # DEV & LOCAL
      path_prefix <- get_param("install_root_local_dev")
    } else { # DEV & REMOTE
      error_msg("Installing a dev-version remote is not possible yet. Please set 'install_status_production = T' or 'install_local = T'.")
    }
  }
  
  fixed_path <- file.path(path_prefix, path)
  
  return(fixed_path)
}

fix_path_rel <- function(path = '', path_base = paste0('p_james/release/', get_param("james_version")), platform = c(AUTO_DETECT, WINDOWS, LINUX, OSX, OSX_LOCAL)) {
  # fix_path_rel gives the path to our shared file system
  # from your current source (i.e. windows, linux, osx)
  # Exception: osx_local refers to development code directly
  
  platform <- match.arg(platform)
  
  if (AUTO_DETECT == platform) {
    if (on_linux_server()) platform <- LINUX
    else if (on_windows()) platform <- WINDOWS
    else if (on_mac())     platform <- OSX_LOCAL
    else error_msg("Platform not recognized. It's not clear whether you are on linux, osx or windows. See function 'fix_path_rel'.")
  }
  
  if (OSX_LOCAL == platform) {
    return(file.path("~/Dropbox/cpb/git/james", path))
  } else if (WINDOWS == platform) {
    prefix <- "m:"
  } else if (OSX == platform) {
    prefix <- "/Volumes"
  } else if (LINUX == platform) {
    prefix <- "/cifs"
  }
  
  file.path(prefix, path_base, path)
}

get_first_existing <- function(paths) {
  for (i in seq_along(paths)) if (file.exists(paths[i])) return(paths[i])

  return(NULL)
}