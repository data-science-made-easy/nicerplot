#' @title Object to Save Data and Meta Data on Your Figure
#' @description The main data object in the 'nicerplot' package has class `james`. `james` objects enable you to add data and meta data in an incremental fashion so you don't need to put everything in one and the same plot-statement.
#' @param ... add parameters to customize figure (see manual)
#' @return object of class james
#' @details
#' Knowing the right parameter names is crucial. One example is parameter 'data', which
#' you can use to store your data object. Please see manual for details. Please find the
#' manual here: \url{https://data-science-made-easy.github.io/nicerplot}.
#' @examples
#' \dontrun{
#' x <- 0:6
#' d <- data.frame(x, first = (6 - x)^2, second = x^2)
#' j <- nicerplot::james(data = d, title = 'Hello World', x_title = 'x', y_title = 'y') # init
#' j$footnote <- 'just an example' # add other parameters
#' nicerplot::nplot(j)
#' }
#' @export
james <- function(...) { # Arg may be list or individual values, i.e. james(list(a=1,b=2)) or james(a=1,b=2) or james()
  p <- list(...)
  if (1 == length(p)) {
    if (is.list(p[[1]]) && !is.data.frame(p[[1]])) {
      p <- p[[1]]
    } else {
      if ((is.list(p[[1]]) && is.data.frame(p[[1]])) || is.matrix(p[[1]])) { # assume it's data
        p <- list(data = p[[1]])
      } else {
        # The arguments are non-data arguments
      }
    }
  } else if (0 == length(p)) {
    # Do nothing
  } else {
    if ("" == names(p)[1]) names(p)[1] <- DATA
  }

  if (!is.element(STYLE, names(p)))     p[[STYLE]]     <- DEFAULT
  if (!is.element(DATA, names(p)))      p[[DATA]]      <- NULL
  if (!is.element(GLOBALS, names(p)))   p[[GLOBALS]]   <- pkg.env$globals
  if (!is.element(USER, names(p)))      p[[USER]]      <- Sys.info()[["user"]]
#  if (!is.element(TIMESTAMP, names(p))) p[[TIMESTAMP]] <- Sys.time() # as.POSIXct(born, origin = "1970-01-01")
#  if (!is.element(JID, names(p)))       p[[JID]]       <- paste(sample(c(letters,LETTERS,0:9), 3), collapse = "") # Random string size 3
    
  attr(p, "class") <- "james"

  if (on_mac() & !is_set(p$open)) {
    # if (!p$quiet) show_msg("Figure will 'auto open' after it is generated.")
    p$open <- T
  }

  p
}

#' @title Tests if its Argument has Class James
#' @description `james` objects enable you to add data and meta data in an incremental fashion so you don't need to put everything in one and the same plot-statement. With `is.james` you can test whether a given object is of type `james`.
#' @param p R object to be tested
#' @return boolean
#' @importFrom methods "is"
#' @export
is.james <- function(p) any("james" == class(p))

force_value <- function(lst, name, val) {
  if (is.na(val)) { # Force global too, if NA
    index   <- which(name == lst[[GLOBALS]]$param)
    lst[[GLOBALS]]$default[index] <- val
  }
  
  lst[[name]] <- val
  
  lst
}

get_parsed <- function(lst, name, allow_non_existing = FALSE) {
  if (!is.null(lst[[name]])) {
    val <- lst[[name]] # Will be casted if type is known
  } else {
    val <- NULL
  }

  # Hack?!
  if ("data" == name) return(val)

  # get pkg.env$globals from this object
  pkg.env$globals <- lst[[GLOBALS]]

  #
  ## Set style as user wants, with default as last (lowest priority)
  #
  style_vec <- pkg.env$globals[which(STYLE == pkg.env$globals$param), ]
  get_styles_recursive <- function(s) {
    if (!is_set(s)) return(NULL) else {
      s <- as_char_vec(s, SEP0)
      return(c(s[1], get_styles_recursive(style_vec[[s[1]]]), get_styles_recursive(s[-1])))
    }
  }
  # (1) get initial styles
  current_style <- lst[[STYLE]]
  if (is_set(lst[["style_add"]])) current_style <- c(current_style, lst[["style_add"]]) # TODO nieuwe stijl achteraan gezet: klopt dat wel?
  style <- get_styles_recursive(current_style)
  # (2) append default style
  style <- c(style, DEFAULT) # make sure we always have default as fallback
  style <- unique(style)
  if (STYLE == name) return(style)
    
  type  <- NA
  index <- which(name == pkg.env$globals$param)
  if (!length(index)) {
    if (is.null(val) & !allow_non_existing) error_msg("You try to use a non-existing parameter '", name, "'. Please check spelling! You should add and describe the non-existing parameter to ", fix_path(get_param("base-settings-path")), ".")
    return(val) # Not found in pkg.env$globals, so casting not possible
  } else {
    type <- pkg.env$globals[index, TYPE]
    # replaced all by any:
    for (this_style in style) if (!any(is_set(val))) val <- pkg.env$globals[index, this_style] # Set value if not set yet
  }

  # Cast value
  type_original <- type
  if (is.element(type, LIST_SEPS)) {
    type <- pkg.env$globals[index, LIST_TYPE]
  }

  # TODO dit zit ook in get_param <= remove duplicate code
  if (type == NUMERIC) val <- as_native_vec(val, type_original) 
  if (type == STRING)  val <- as_char_vec(val, sep = type_original, trim = REPORT_TEXT != name) # Leave report intact.
  if (type == PATH)    val <- as_char_vec(val, sep = type_original)
  if (type == BOOL)    { # Let NA intact, transform rest to T, F
    index_NA  <- which(is.na(val))
    val       <- is_yes(val)
    if (length(index_NA)) val[index_NA] <- NA # Set NA's back
  }  
  if (type == DATE) {
    if ("Date" != class(val)) {
      val <- as.Date(as.numeric(val), origin = "1899-12-30")
    }
  }
  
  return(val)
}

#' @method $ james
#' @export
"$.james" <- function(lst, name) get_parsed(lst, name)

j_names <- function(p) {
  global_names <- p[[GLOBALS]][,1]
  global_names <- global_names[which(!stringr::str_starts(global_names, "#"))]
  sort(union(names(p), global_names))
}

#' @title Print James Data Object in Nice Fashion
#' @details Relevant parameters are shown with values that are properly aligned. Data are truncated.
#' @param x object of class `james`
#' @param ... further arguments are ignored. The ... argument was added to be consistent with the generic print function
#' @examples
#' x <- 0:6
#' my_data <- data.frame(x, first = (6 - x)^2, second = x^2)
#' p <- james(data = my_data, title = "Hello World")
#' p
#' # `print(p)` and `print.james(p)` give same results
#' @export
print.james <- function(x, ...) {
  p <- x # for reasons of consistency with the generic print function 'print(x, ...)', this function has the same parameters (i.e., x and ...); however, please note, only the first argument 'x' is used and '...' is ignored.
  cat("# A james object\n")
  cat(paste0("# Parameters (", length(p) - 1, "):\n"))
  
  nchar_max <- max(nchar(names(p)))
  for (i in sort(names(p), index.return = T)$ix) {
    if (!is.element(names(p)[i], p$james_class_print_hide)) {
      if (FIGS == names(p)[i]) {
        this_val <- paste(length(p[[i]]), "items in your xlsx-file")
      } else if (REPORT_TEXT == names(p)[i]) {
        this_val <- paste0(stringr::str_sub(p[[i]][1], end = 20), "... (nchar: ", nchar(paste0(p[[i]])), ")")
      } else if (ERROR == names(p)[i]) {
        this_val <- p[[ERROR]]$message
      } else this_val <- utils::head(get_parsed(p, names(p)[i]), n = if (8 < length(p[[i]])) 5 else 8)
      
      cat(paste0(names(p)[i], ": ", paste(rep(" ", nchar_max - nchar(names(p[i]))), collapse = ""), paste0(this_val, collapse = ", ")), if (length(this_val) < length(p[[i]]) & FIGS != names(p)[i]) paste0("... with ", length(p[[i]]), " values total") else "", "\n")
    }
  }
  cat("data:\n")
  d <- p[[DATA]]
  if (!is.null(dim(d))) {
    print(utils::head(d))
    cat(paste("# ... with", nrow(d), "rows total"))
  }
  if (is_set(p$warning)) {
    cat(paste("\n\n### Generated warnings\n###", paste0(p$warning, collapse = ", ")))
  }
}




















