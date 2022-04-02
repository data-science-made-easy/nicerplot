get_col_from_p <- function(p, parameter_name) {
  if (!is_set(parameter_name)) return(parameter_name)

  pal_names <- unlist(strsplit(names(get_pal()), ".pal", T))

  if (1 == length(parameter_name)) {
    if (is.element(parameter_name, pal_names))
      return(get_pal(parameter_name))
    p_val <- get_parsed(p, parameter_name, allow_non_existing = TRUE)
    if (!is_set(p_val)) {
      return(parameter_name)
    } else {
      if (1 < length(p_val)) {
        vec <- NULL
        for (p_val_elt in p_val) vec <- c(vec, get_col_from_p(p, p_val_elt))
        return(vec)
      } else return(get_col_from_p(p, p_val))
    }
  } else {
    vec <- NULL
    for (p_elt in parameter_name) vec <- c(vec, get_col_from_p(p, p_elt))
    return(vec)
  }
}

color_pre <- function(p) {
  print_debug_info(p)

  if (!is_set(p$color)) {
    # Choose right palette based on number of series
    if (AUTO == p$palette[1]) {
      p$palette <- if (p$n_series_without_whiskers < 4) "cpb_3" else "cpb"
    }
    
    # First retrieve real colors to fill our palette
    p$palette <- get_col_from_p(p, p$palette)
    
    # Remove color if it is used to highlight a series (element)
    if (is_set(p$highlight_series)) {
      index <- which(get_col_from_p(p, p$highlight_col) == p$palette)
      if (length(index)) p$palette <- p$palette[-index]
    }
    
    # Now remove colors that we want for specific series
    if (is_set(p$name_col)) {
      # Unravel name_col
      lst <- stringr::str_split(p$name_col, "=")
      if (!all(2 == unlist(lapply(lst, length)))) error_msg("Your parameter 'name_col' should have elements in the form of 'time-series=color-name. Problematic name_col: ", p$name_col)

      p$name_col_processed <- stringr::str_trim(unlist(lapply(lst, function(elts) elts[2])))
      names(p$name_col_processed) <- stringr::str_trim(unlist(lapply(lst, function(elts) elts[1])))

      yet_assigned_colors <- get_col_from_p(p, p$name_col_processed)
      p$palette <- setdiff(p$palette, yet_assigned_colors)
    }
    
    p$color <- get_col_from_p(p, set_color_per_index(p)) # taking into account specific colors

    # user can force col order
    if (is_set(p$col_order)) {
      p$color <- p$color[p$col_order]
    }
  }

  # Spike in color if highlight_series is given but highlight_x is not given
  if (is_set(p$highlight_series) & !is_set(p$highlight_x)) {
    p$color <- append(p$color, get_col_from_p(p, p$highlight_col), p$highlight_series - 1)
  }

  # Check all series get indeed a color
  if (any(is.na(p$color))) error_msg("The palette of figure '", if (is_set(p$file)) p$file else p$id, "' has not enough colors. The figure has ", p$n_series, " time series while the color palette has only ", length(which(!is.na(p$color))), " color(s). Please add colors to the palette. The manual, section 'Colors', explains in detail how you may do so (e.g. palette = cpb, info).")

  p
}

is_forced_color  <- function(p, j) is.element(p$name[j], names(p$name_col_processed))
get_forced_color <- function(p, j) p$name_col_processed[[p$name[j]]]

set_color_per_index <- function(p) {
  color_per_box_group <- list()
  color_per_index     <- NULL
  index               <- 1
  j                   <- 1
  while (j <= length(p$type)) {
    forced <- is_forced_color(p, j)
    if (is_whisker(p$type[j])) {
      color_per_index[j] <- NA
      j <- 1 + j
    } else { # no whisker
      # if (is_area(p$type[j])) { # we see an area (has two columns)
      #   color_per_index[j]     <- if (forced) get_forced_color(p, j) else p$palette[index]
      #   color_per_index[1 + j] <- NA
      #   j <- 2 + j
      #   if (!forced) index <- 1 + index
      # } else { # no whisker, no area
        if (is_box(p$type[j])) { # we see a box (has one column)
          if (p$box_col_per_group) { # each group its own color
            if (!is_set(p$group)) { # all boxes fall in same group
              if (p$box_col_all_equal) { # no groups, but still all boxes one and same color
                if (0 == length(color_per_box_group)) { # first time we see box
                  color_per_index[j] <- if (forced) get_forced_color(p, j) else p$palette[index]
                  color_per_box_group$box_col <- color_per_index[j]
                  j <- 1 + j
                  if (!forced) index <- 1 + index
                } else { # we did see this box before
                  color_per_index[j] <- color_per_box_group$box_col
                  j <- 1 + j # only shift j, not index because we recycle a color now
                }
              } else { # no groups, each box its own color
                
                color_per_index[j] <- if (forced) get_forced_color(p, j) else p$palette[index]
                j <- 1 + j
                if (!forced) index <- 1 + index
              }
            } else { # we (may) have different groups
              if (p$box_col_all_equal) {
                if (0 == length(color_per_box_group)) { # first time we see box
                  
                  color_per_index[j] <- if (forced) get_forced_color(p, j) else p$palette[index]
                  color_per_box_group$box_col <- color_per_index[j]
                  j <- 1 + j
                  if (!forced) index <- 1 + index
                } else { # we did see box before
                  
                  color_per_index[j] <- if (forced) get_forced_color(p, j) else color_per_box_group$box_col           
                  j <- 1 + j # only shift j, not index because we recycle a color now
                }
              } else if (!is.element(p$group[j], names(color_per_box_group))) { # group not seen before
                
                color_per_index[j] <- if (forced) get_forced_color(p, j) else p$palette[index]
                color_per_box_group[[p$group[j]]] <- color_per_index[j]
                j <- 1 + j
                if (!forced) index <- 1 + index
              } else { # group seen before
                
                if (forced) {
                  color_per_index[j] <- get_forced_color(p, j)
                } else {
                  color_per_index[j] <- if (p$box_col_all_equal) color_per_box_group$box_col else color_per_box_group[[p$group[j]]] # just take known color of the group
                }
                j <- 1 + j
              }
            }
          } else { # each box its own color
            
            color_per_index[j] <- if (forced) get_forced_color(p, j) else p$palette[index]
            j <- 1 + j
            if (!forced) index <- 1 + index
          }
        } else { # no whisker, no area, no box
          
          color_per_index[j] <- if (forced) get_forced_color(p, j) else p$palette[index]
          j <- 1 + j
          if (!forced) index <- 1 + index
        }
      }
    }
  

  color_per_index
}



















