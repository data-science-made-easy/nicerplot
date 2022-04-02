is_param <- function(type) is.element(type, PARAM)

data_operations <- function(p) {
  print_debug_info(p)

  # Set p$x and p$y
  if (all(is_box(p$type))) {
    if (!is_set(p$x)) p$x <- 1:ncol(p$data)
    if (!is_set(p$y)) p$y <- p$data
  } else {
    if (is_hist(p)) {
      p$y <- p$data
    } else { # okay, we really have x-values
      # First x
      if (!is_set(p$x)) p$x <- p$data[,  1]
      # Now y
      if (!is_set(p$y)) p$y <- p$data[, -1, drop = F]
    }
  }
  for (j in 1:ncol(p$y)) if (!is_param(p$type[j])) p$y[, j] <- as.numeric(as.character(p$y[, j])) # cast to numeric

  # Check all data numeric
  if (!is.numeric(p$x)) error_msg("Some x-value(s) seem not numeric.")
  for (j in 1:ncol(p$y)) if (!is_param(p$type[j])) if (!all(is.numeric(p$y[, j]))) error_msg("Some datapoint(s) seem not numeric.")

  # Select series and change order
  if (is_set(p$order))      p$y <- p$y[, p$order, drop = FALSE]
  if (is_set(p$order_name)) p$y <- p$y[, p$order_name, drop = FALSE]
  
  # Security
  # if (is_set(p$order) & 1 < length(p$type) & length(p$type) != length(p$order)) error_msg("You make a subselection of your data using 'order = ", paste0(p$order, collapse = ", "), "', while you define 'type = ", paste0(p$type, collapse = ", "), "'. The number of elements doesn't match.")
    
  # Now remove any 'parameter'
  index_param <- which(is_param(p$type))
  if (length(index_param)) {
    for (j in index_param) {
      j_param_name <- colnames(p$y)[j]
      j_original_value <- p[[j_param_name]]
      if (!is_set(j_original_value)) j_original_value <- get_param(j_param_name)
      p[[j_param_name]] <- p$y[, j] # set as parameter
      if (any(is.na(p[[j_param_name]]))) p[[j_param_name]][which(is.na(p[[j_param_name]]))] <- j_original_value
    }
    p$y    <- p$y[, -index_param, drop = FALSE] # remove param from data
    p$type <- p$type[-index_param] # remove param from type  
  }

  # Scale x
  if (1 != p$x_scale) {
    p$x <- p$x_scale * p$x
  }

  # Scale y
  if (any(1 != p$scale)) {
    if (1 == length(p$scale)) {
      p$scale <- rep(p$scale, ncol(p$y))
    } else {
      if (length(p$scale) != ncol(p$y))
        error_msg("You have ", ncol(p$y), " time series. However, parameter scale has ", length(p$scale), " elements. Parameter scale should have either 1 or ", ncol(p$y), " elements.")
    }
    for (j in 1:ncol(p$y)) p$y[, j] <- p$scale[j] * p$y[, j]
  }

  # Remove data x based on x_keep
  index_x_del <- NULL
  if (is_set(p$x_keep)) index_x_del <- which(p$x < p$x_keep[1] | p$x_keep[2] < p$x)
  if (length(index_x_del)) {
    p$x <- p$x[-index_x_del]   # Remove x
    p$y <- p$y[-index_x_del, , drop = FALSE] # Remove data
  }

  # Remove data y based on y_keep
  for (j in 1:ncol(p$y)) {
    vec <- p$y[, j]
    index_y_NA  <- which(vec < p$y_keep[1] | p$y_keep[2] < vec)
    if (length(index_y_NA)) {
      vec[index_y_NA] <- NA
      p$y[, j]        <- vec
    }
  }

  # Apply any other user give transformation (e.g. log)
  if (is_set(p$transformation)) {
    p$y <- eval(parse(text = p$transformation))(p$y)
  }
  
  p
}