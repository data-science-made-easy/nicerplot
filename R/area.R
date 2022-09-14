is_area       <- function(type) type == AREA
is_area_stack <- function(type) type == AREA_STACK

# new_y_lim <- function(p, vec) {
#   if (!p$y_lim_by_user) {
#     p$y_lim <- range(p$y_lim, as.numeric(unlist(vec)), na.rm = T)
#   }
#
#   return(p)
# }

area_stack_pre <- function(p) {
  print_debug_info(p)
  if (!any(is_area_stack(p$type))) return(p)
  
  p$y_force_include_zero <- TRUE # must do so for stacked areas.
  
  y_stack_list_index <- NULL   # First as a local variable to make the programming ...
  y_stack_list       <- list() # ... easier as non-initialized p$variables give NA

  y_low_bot <- y_low_top <- rep(0, length(p$x))
  for (j in 1:ncol(p$y)) if (is_area_stack(p$type[j])) {
    top <- all(0 <= p$y[, j])
    bot <- all(p$y[, j] <= 0)
    
    if (!top & !bot) error_msg("Time series '", p$name[j], "' is of type 'area=' and has both positive and negative y-values at the same time. Currently this is not allowed for stacked areas.")
  
    this_low                                 <- if (top) y_low_top else y_low_bot
    y_high                                   <- this_low + p$y[, j]
    y_stack_list[[1 + length(y_stack_list)]] <- list(y_low = this_low, y_high = y_high)
    y_stack_list_index[j]                    <- length(y_stack_list)
    if (top) y_low_top <- y_high else y_low_bot <- y_high
  } else {
    y_stack_list_index[j] <- NA
  }  

  # Make them available for reuse
  p$y_stack_list       <- y_stack_list
  p$y_stack_list_index <- y_stack_list_index
  
  p
}

area_pre <- function(p) {
  print_debug_info(p)
  if (!any(p$type %in% AREA)) return(p)

  p$y_area_list <- list()
  
  # get pairs of subsequent indices
  j_y_lim    <- NULL
  index      <- which(is_area(p$type))
  index_low  <- odd_elements(index)
  index_high <- even_elements(index)
  for (i in seq_along(index_low)) {
    j_low   <- index_low[i]
    j_high  <- index_high[i]
    j_y_lim <- range(c(j_y_lim, p$y[, j_low], p$y[, j_high]), na.rm = T)
    p$y_area_list[[i]] <- list(y_low = p$y[, j_low], y_high = p$y[, j_high], nth_col = j_low - i + 1) # so later we can use p$color[nth_col]
    
    # Adapt y_lim
    range_to_add <- c(as.numeric(p$y[, j_low]), as.numeric(p$y[, j_high]))
    # if (!p$y_lim_by_user & is_yl(p, j_low)) p <- update_y_lims(p, i, range_to_add)
    # if (is_yr(p, j_low))                    p <- update_y_lims(p, i, range_to_add) # TODO NOT if user sets yr
  }
  
  # Remove second column of area from our data
  p$y        <- p$y[, -index_high, drop = F]
  p$type     <- p$type[-index_high]
  p$name     <- p$name[-index_high]
  p$line_lty <- p$line_lty[-index_high]
  p$y_axis   <- p$y_axis[-index_high]
    
  p
}

area <- function(p) {
  print_debug_info(p)
  if (!any(p$type %in% AREA)) return(p)

  for (index_obs_fc in seq_along(p$index_lst)) {
    index <- p$index_lst[[index_obs_fc]]
    for (j in 1:length(p$y_area_list)) {
      x_normal <- c(p$x[index], rev(p$x[index]))
      y_normal <- c(p$y_area_list[[j]]$y_low[index], rev(p$y_area_list[[j]]$y_high[index]))
    
      if (p$turn) {
        x <- y_normal
        y <- x_normal
      } else {
        x <- x_normal
        y <- y_normal
      }
    
    
      if (9 == nchar(p$color[p$y_area_list[[j]]$nth_col])) { # is already transp
        this_col <- p$color[p$y_area_list[[j]]$nth_col]
      } else {
        this_col <- make_transparent(p$color[p$y_area_list[[j]]$nth_col], if (1 == index_obs_fc) 1 else 1 - p$forecast_col_transparency) # p$y_area_list[[j]]$col
      }

      graphics::polygon(x = x, y = y, col = this_col, border = NA)
          
      if (p$forecast_shading_show & "forecast" == names(p$index_lst)[index_obs_fc]) {
        graphics::polygon(x = x, y = y, col = get_col_from_p(p, p$forecast_shading_col), border = NA, density = grDevices::cm(1) * p$forecast_shading_density, angle = p$forecast_shading_angle)
      }
    }
  }
  
  p
}

area_stack <- function(p) {
  print_debug_info(p)
  if (!any(p$type %in% AREA_SET)) return(p)

  for (index_obs_fc in seq_along(p$index_lst)) {
    index <- p$index_lst[[index_obs_fc]]
    #for (j in 1:ncol(p$y)) if (is_set(p$y_stack_list_index[j])) {
    for (j in seq_along(p$y_stack_list_index)) if (is_set(p$y_stack_list_index[j])) {
      obj <- p$y_stack_list[[p$y_stack_list_index[j]]]
    
      x_normal <- c(p$x[index], rev(p$x[index]))
      y_normal <- c(obj$y_low[index], rev(obj$y_high[index]))
    
      # if (any(y_normal < 0)) error_msg("Type '", AREA_STACK, "' not yet implemented for negative numbers.")
    
      if (p$turn) {
        x <- y_normal
        y <- x_normal
      } else {
        x <- x_normal
        y <- y_normal
      }

      this_col <- p$color[which(AREA_STACK == p$type)[p$y_stack_list_index[j]]]
      this_col <- make_transparent(this_col, if (1 == index_obs_fc) 1 else 1 - p$forecast_col_transparency) # p$color[j]
    
      graphics::polygon(x = x, y = y, col = this_col, border = NA)
      if (p$forecast_shading_show & "forecast" == names(p$index_lst)[index_obs_fc]) {
        graphics::polygon(x = x, y = y, col = get_col_from_p(p, p$forecast_shading_col), border = NA, density = grDevices::cm(1) * p$forecast_shading_density, angle = p$forecast_shading_angle)
      }
    }
  }
  
  p
}