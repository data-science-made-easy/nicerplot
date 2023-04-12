is_english <- function(p) is.element("english", p$style)

cut_data <- function(vec, lim) {
  if (!is_set(lim)) return(vec)
  index <- which(vec < lim[1] | lim[2] < vec)
  if (length(index)) vec <- vec[-index]
  vec
}

set_lims <- function(p) {
  print_debug_info(p)

  # x_lim
  p$x_lim_data <- range(p$x, na.rm = T)
  if (!p$x_lim_by_user & p$x_lim_follow_data) p$x_lim <- p$x_lim_data

  set_y_lr_lim <- function(p, j, data) {
    if (is_yl(p)[j]) {
      if (!p$y_l_lim_by_user) p$y_l_lim <- range(c(p$y_l_lim, data), na.rm = T)
    } else {
      stopifnot(is_yr(p)[j])
      if (!p$y_r_lim_by_user) p$y_r_lim <- range(c(p$y_r_lim, data), na.rm = T)
    }
    p
  }

  # y_lim l, r
  # if (!is_set(p$y_l_lim)) {

  for (j in seq_along(p$type)) {
    if (is_area(p$type)[j] | is_area_stack(p$type)[j]) {
      # Fix AREA below
    } else if (is_bar_stack(p$type)[j]) {
      # Fix BAR STACKS below
    } else if (is_whisker(p$type)[j]) {
      # Fix WHISKERS below
    } else {
      p <- set_y_lr_lim(p, j, p$y[, j])
    }
  }

  #
  ## AREA
  #
  # area
  if (any(is_area(p$type))) {
    for (i in seq_along(p$y_area_list)) {
      this_area <- p$y_area_list[[i]]
      j         <- this_area$nth_col
      p <- set_y_lr_lim(p, j, c(this_area$y_low, this_area$y_high))
    }
  }
  # area=
  this_area_stack_index <- 1
  for (j in seq_along(p$type)) {
    if (is_area_stack(p$type[j])) {
      this_area <- p$y_stack_list[[this_area_stack_index]]
      p <- set_y_lr_lim(p, j, c(this_area$y_low, this_area$y_high))
      this_area_stack_index <- 1 + this_area_stack_index
    }
  }
  
  #
  ## BAR STACKS
  #
  index_stack <- which(is_bar_stack(p$type))
  if (length(index_stack)) {
    on_left <- is_yl(p)[index_stack]
    if (!all(on_left) & !all(!on_left)) error_msg("Not all bar= have same y-axis. Make sure all bar= are on or the left y-axis or the right y-axis. Please change parameter 'y_axis' to fix this.")
    stack_pos <- stack_neg <- rep(0, length(p$x))
    for (j in index_stack) {
      for (i in 1:length(p$x)) {
        if (p$y[i, j] < 0) stack_neg[i] <- stack_neg[i] + p$y[i, j]
          else             stack_pos[i] <- stack_pos[i] + p$y[i, j]
      }
    }
    if (on_left[1]) {
      if (!p$y_l_lim_by_user) p$y_l_lim <- range(c(p$y_l_lim, stack_neg, stack_pos), na.rm = T)
    } else {
      if (!p$y_r_lim_by_user) p$y_r_lim <- range(c(p$y_r_lim, stack_neg, stack_pos), na.rm = T)
    }
  }
  
  #
  ## WHISKERS
  #
  if (is_set(p$whisker_list)) for (j in seq_along(p$whisker_list)) {
    elt <- p$whisker_list[[j]]
    if (LEFT  == elt$y_axis) p$y_l_lim <- range(c(p$y_l_lim, elt$low, elt$high), na.rm = T)
    if (RIGHT == elt$y_axis) p$y_r_lim <- range(c(p$y_r_lim, elt$low, elt$high), na.rm = T)
  }
  
  #
  ## HEATMAP
  #
  if (is_heatmap(p) & !p$y_l_lim_by_user) {
    p$y_l_lim <- p$y_lim #0.5 + c(0, length(p$x))
  }
  
  # hline_bold
  if (is_set(p$hline_bold) & !p$y_l_lim_by_user) p$y_l_lim <- range(c(p$y_l_lim, p$hline_bold), na.rm = T)
# }
  
  # If user wants zero in lim (implicit left y-axis)
  if (is_yes(p$y_force_include_zero)) {
    if (0 < p$y_l_lim[1] | p$y_l_lim[2] < 0) print_info(p, "'y_force_include_zero = yes' forces an extension of y_lim so it includes zero.")
    p$y_l_lim <- range(c(p$y_l_lim, 0), na.rm = T)
  }
  
  p
}

find_y_r_scaling <- function(p) {
  print_debug_info(p)

  whisker_right <- if (is_set(p$whisker_list)) any(is.element(RIGHT, unlist(lapply(p$whisker_list, function(elt) elt$y_axis)))) else FALSE
  if (!any(is_yr(p)) & !whisker_right) return(p)

  n_labels <- length(p$y_at)
  if (is_set(p$y_r_at)) {
    if (n_labels != length(p$y_r_at)) error_msg("At your left y-axis you have ", n_labels, " values, while at your right y-axis you have ", length(p$y_r_at), " values. Please update the values of y_r_at. (Now: ", p$y_r_at, ".)")
      y_r_at <- p$y_r_at
  } else { # find new labs right
    low  <- p$y_r_lim[1]
    high <- p$y_r_lim[2]

    if (!p$y_r_scale_auto | p$y_r_lim_by_user) {
      y_r_at <- seq(low, high, length = n_labels)
    } else {
      y_r_at <- pretty(c(low, high), n = n_labels)
      n       <- n_labels - length(y_r_at)
      delta   <- diff(head(y_r_at, 2))
      while (0 != n) {
        if (0 < n) {
          for (i in n:1) { # we don't have enough labels right, yet
            # for reasons of simplicity, just add equidistant labels at top/bottom
            if (low - y_r_at[1] < tail(y_r_at, 1) - high) {
              y_r_at <- c(y_r_at[1] - delta, y_r_at) # add below
            } else {
              y_r_at <- c(y_r_at, tail(y_r_at, 1) + delta) # add above
            }
          }
        } else { # we have too many labels right
          # chop in half
          y_r_at <- odd_elements(y_r_at) # potentially slightly suboptimal :-#
          delta  <- diff(head(y_r_at, 2))
        }      
        n <- n_labels - length(y_r_at)
      }
    }
  }
  
  # New labels implies y_r_lim
  if (!p$y_r_lim_by_user) p$y_r_lim <- c(y_r_at[1], tail(y_r_at, 1))
  
  # Get transformation
  slope <- (p$y_at[1] - tail(p$y_at, 1)) / (y_r_at[1] - tail(y_r_at, 1))
  inter <- p$y_at[1] - slope * y_r_at[1]
  
  # Export labels
  if (!is_set(p$y_r_lab)) {
    p$y_r_lab <- fix_numbers(y_r_at, p$y_r_n_decimals, p$decimal_mark, big_mark = if (p$y_lab_big_mark_show) p$big_mark else "") # converts numbers to string with right number of decimals and right decimal separator
  }
  
  # Export scaling
  p$y_r_scaling <- c(inter, slope)
  
  # Apply scaling to all but area_stack
  p$y[, which(is_yr(p))] <- inter + slope * p$y[, which(is_yr(p))]
  
  # Scale area stack
  area_stack_on_right_axis <- is_yr(p, which(is_area_stack(p$type))[1])
  if (any(is_area_stack(p$type)) & area_stack_on_right_axis) { # only scale if area= is on right axis
    for (i in seq_along(p$y_stack_list)) for (j in 1:2) p$y_stack_list[[i]][[j]] <- inter + slope * p$y_stack_list[[i]][[j]]
  }
  
  # Scale whiskers
  if (is_set(p$whisker_list)) for (j in seq_along(p$whisker_list)) {
    elt <- p$whisker_list[[j]]
    if (RIGHT == elt$y_axis) {
      p$whisker_list[[j]]$low  <- inter + slope * elt$low
      p$whisker_list[[j]]$high <- inter + slope * elt$high
    }
  }
  
  p
}


get_pretty_date_lab <- function(p, dates) {
  print_debug_info(p)

  y <- lubridate::year(dates)
  q <- lubridate::quarter(dates)
  m <- lubridate::month(dates)
  d <- lubridate::day(dates)

  # month as a word
  month      <- if (is_english(p)) p$month_en[m] else p$month_nl[m]
  month_full <- if (is_english(p)) p$month_en_full[m] else p$month_nl_full[m]

  lab <- rep(p$x_date_format, length(dates))
  
  for (i in seq_along(lab)) {
    # year
    lab[i] <- stringr::str_replace_all(string = lab[i], pattern = "yyyy", replacement = as.character(y[i]))
    lab[i] <- stringr::str_replace_all(string = lab[i], pattern = "yy", replacement = as.character(stringr::str_sub(y[i], 3, 4)))
    # quarter
    lab[i] <- stringr::str_replace_all(string = lab[i], pattern = "q", replacement = as.character(q[i]))
    # day
    lab[i] <- stringr::str_replace_all(string = lab[i], pattern = "dd", replacement = as.character(stringr::str_pad(d[i], 2, pad = "0")))
    lab[i] <- stringr::str_replace_all(string = lab[i], pattern = "d", replacement = as.character(d[i]))
    # month
    # extra checks needed to prevent cases like 'month' -> 'may' ([m]ay) -> '5ay'
    if (stringr::str_detect(string = lab[i], pattern = "mm")) {
      lab[i] <- stringr::str_replace_all(string = lab[i], pattern = "mm", replacement = as.character(stringr::str_pad(m[i], 2, pad = "0")))
    } else if (stringr::str_detect(string = lab[i], pattern = "month_full")) {
      lab[i] <- stringr::str_replace_all(string = lab[i], pattern = "month_full", replacement = month_full[i])
    } else if (stringr::str_detect(string = lab[i], pattern = "month")) {
      lab[i] <- stringr::str_replace_all(string = lab[i], pattern = "month", replacement = month[i])
    } else if (stringr::str_detect(string = lab[i], pattern = "m")) {
      lab[i] <- stringr::str_replace_all(string = lab[i], pattern = "m", replacement = as.character(m[i]))
    }    
  }

  return(lab)
}


set_labs <- function(p) {
  print_debug_info(p)
  # set x_at, based on x_at_date (i.e. convert dates to numbers)
  if (is_set(p$x_at_date)) {
    # validate
    n_dashes <- stringr::str_count(string = p$x_at_date, pattern = "-")
    if (1 < length(unique(n_dashes))) {
      error_msg("The dates specified for parameter x_at_dates have different formats. Please specify all values in one and the same format. Possible formats for 'x_at_date' are: 'yyyy-mm-dd', 'yy-m' (or a combination of those elements), where dd = 1..31, mm = 1..12, and year can be specified by two or four digits (e.g., 2022-3 and 22-03 are equivalent).")
    } else {
      if (1 == n_dashes[1]) {
        x_date <- lubridate::ym(p$x_at_date)
      } else if (2 == n_dashes[1]) {
        x_date <- lubridate::ymd(p$x_at_date)
      } else error_msg("Possible formats are: 'yyyy-mm-dd', 'yy-m' (or a combination).")
    }   
    
    # set x_at
    p$x_at <- lubridate::decimal_date(x_date)
  }

  if (!is_set(p$x_at) & !is_set(p$x_at_date)) {
    p$x_at <- pretty(if (is_set(p$x_lim)) p$x_lim else p$x_lim_data)
    p$x_at <- cut_data(p$x_at, p$x_lim)
  } 

  # derive x_at, x_lab from x_at_date
  if (is_yes(p$x_lab_date_show)) {
    # For dates make sure that x_at is exactly at start of day
    # if (!is_set(p$x_at)) {
      x_at_as_date <- lubridate::round_date(lubridate::date_decimal(p$x_at), unit = "day")
      p$x_at       <- lubridate::decimal_date(x_at_as_date)
      index_keep <- which(p$x_at %in% cut_data(p$x_at, p$x_lim))
      p$x_at     <- p$x_at[index_keep]
    # }
    
    # set x_lab
    if (!is_set(p$x_lab)) {
      if (exists('x_date')) {
        p$x_lab <- get_pretty_date_lab(p, x_date)
      } else {
        p$x_lab <- get_pretty_date_lab(p, x_at_as_date[index_keep])
      }
    }
    
  } 

  # Adapt x_lim to axes 
  if (!p$x_lim_by_user) p$x_lim <- range(c(p$x_at, p$x_lim, p$x_ticks), na.rm = T)
  
  #
  ## fix y_lab
  #
  if (!is_set(p$y_at)) {
    p$y_at <- pretty(p$y_l_lim)
    # p$y_l_lim <- range(c(p$y_l_lim, p$y_at))
  }
  
  # also update y_l_lim
  if (!p$y_l_lim_by_user) p$y_l_lim <- range(c(p$y_l_lim, p$y_at))

  # Don't allow only one value for p$y_at
  if (!p$y_at_by_user & 0 != diff(p$y_l_lim)) p$y_at <- cut_data(p$y_at, p$y_l_lim)
  
  # To prevent machine errors in rounding:
  p$y_at <- round(p$y_at, 8)
  
  return(p)
}
























