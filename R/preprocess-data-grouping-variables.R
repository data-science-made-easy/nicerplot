preprocess_data_grouping_variables <- function(p) {
  print_debug_info(p)
  stopifnot(is.james(p))

  p$data <- as.data.frame(p$data, stringsAsFactors = FALSE) # as data frame

  #
  ## Retrieve groups in first COL
  #
  if (!is_set(p$first_col_grouping)) p$first_col_grouping <- is_really_character(as.character(p$data[-1, 2]))
  if (is_yes(p$first_col_grouping)) {
    p$group <- p$data[, 1]
    p$data  <- p$data[, -1, drop = FALSE] # remove groups from data

    group_x <- NULL
    x_at    <- NULL
    this_x  <- 1
    i       <- 1
    while (i <= nrow(p$data)) {
      if (is_no(duplicated(p$group)[i])) { # place group header here
        group_x <- c(group_x, this_x)
        if (is_set(p$data[i, 1]) & p$turn) this_x <- 1 + this_x # Don't add newline if there is no series name (usually there is only one item in such cases)
      } 
      # just a box
      x_at   <- c(x_at, this_x)
      this_x <- 1 + this_x
      i      <- 1 + i
      if (is_no(duplicated(p$group)[i])) this_x <- this_x + p$group_spacing # only add space if grouping is vertical
    }
    
    p$group_x <- group_x # export group_x
    
    # set back x_at
    p$x_at <- x_at
  }

  # cast x-axis data
  if (!all(1:nrow(p$data) == rownames(p$data)) & !is_really_character(p$data[,1])) p$data <- cbind(x = rownames(p$data), p$data) # hack
  if (0 < ncol(p$data)) { # only if we have data
    if ("Date" == class(p$data[, 1]) & !is_yes(p$x_lab_as_text)) { # convert dates to decimals
      p$data[, 1] <- lubridate::decimal_date(p$data[, 1])
      if (!is_set(p$x_lab_date_show)) p$x_lab_date_show <- T # if user did not specifiy, he may want to see dates on x-axis
    } else { # retrieve original type of x-data     
      p$data[, 1] <- as_native_vec(p$data[, 1], sep = "this is improper use")
      if (is_really_character(p$data[, 1]) | is_yes(p$x_lab_as_text)) {
        # p$x_lab_as_text <- F
        if (!is_set(p$x_lab)) p$x_lab <- p$data[, 1]
        if (!is_set(p$x_at))  p$x_at <- 1:nrow(p$data)
        if (!is_set(p$x))     p$x <- p$x_at
      }
    }
  }
  
  #
  ## Retrieve groups in first ROW
  #
  # retrieve grouping for type = 'box'
  index_param <- which(is_param(p$type)) # for ignoring param's
  # If first row contains chars, then guess we have to deal with grouping
  if (!is_set(p$first_row_grouping)) p$first_row_grouping <- is_really_character(as.character(p$data[1, c(-1, -(1 + index_param))])) # The -1 removes the first element (it belongs to the x-axis)
  if (is_yes(p$first_col_grouping) & is_yes(p$first_row_grouping)) error_msg("You can't have both first_col_grouping and first_row_grouping. You may have a non-numeric value in both your second column and second row.")
  if (p$first_row_grouping & !is_set(p$group)) {
    p$group     <- colnames(p$data)
    if (!all(is_box(p$type))) p$group <- p$group[-1]
    colnames(p$data) <- as.vector(t(p$data)[,1]) # we mean p$data[1, ]
    p$data      <- p$data[-1, , drop = FALSE] # < niet getest
  }
  
  # check/cast variables to their type
  # TODO Maybe repair this?
  # for (i in seq_along(p)) { # cast numeric
  #   if (is_numeric(names(p)[i])) {
  #     p[i] <- tryCatch({as.numeric(p[i])}, error = function(cond) error_casting(param_name = names(p)[i], expected_type = NUMERIC, observed_type = class(p[i]), val = p[i])) # numeric
  #     # if (0 < length(warnings())) error_casting(param_name = names(p)[i], expected_type = NUMERIC, observed_type = class(p[i]), val = p[i])
  #   }
  #   if (is_bool(names(p)[i])) { # check (not cast) bools
  #     if (is_set(p[i])) { # if is.na(p[i]), leave it so
  #       if (!is.element(p[i], BOOL_SET)) {
  #         error_casting(param_name = names(p)[i], expected_type = BOOL, observed_type = class(p[i]), val = p[i])
  #       }
  #     }
  #   }
  # }

  p
}

