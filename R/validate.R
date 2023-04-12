validate <- function(p) {
  print_debug_info(p)

  # Loop over given params and warn if not known
  unkown_params <- setdiff(names(p), pkg.env$globals$param)
  if (length(unkown_params)) print_warning("Uknown parameters: ", paste(unkown_params, collapse = ", "))
  
  if (p$r_plot & any_file_to_save(p)) error_msg("Please set parameter 'r_plot = n' if you want to export your figure (gif, jpg, pdf, png, svg).")  
  
  index_unavailable_style <- which(!is.element(p$style, styles()))
  if (length(index_unavailable_style)) {
    error_msg("Style, ", p$style[index_unavailable_style], " is unavailable. Available styles are: ", paste0(styles(), collapse = ", "))
  }

  todo(p, "TODO make types()")
  todo(p, "TODO rename styles to style")
  existing_types_string <- get_param("type", style = "example")
  existing_types <- as_char_vec(existing_types_string, sep = SEP0) # this line can be removed? NO :)
  non_existing_type_index <- which(!(p$type %in% existing_types))
  if (length(non_existing_type_index)) error_msg("Type '", p$type[non_existing_type_index], "' not allowed! Please choose from the following types: ", paste0(existing_types_string, collapse = ", "), ".")
    
  # hist
  if (is_hist(p)) {
    if (1 < ncol(p$data)) error_msg("Currently 'style = histogram' only allows one data column.")
  }
  
  n_whiskers <- length(which(is_whisker(p$type)))
  if (0 != n_whiskers %% 2) error_msg("'whisker' occurs ", length(n_whiskers), " times in as 'type'. This should be an even number.")
    
  n_areas <- length(which(is_area(p$type)))
  if (1 != n_areas & 0 != n_areas %% 2) error_msg("'area' occurs ", length(n_areas), " times in as 'type'. This should be an even number.")
 
  # AXES
  for (prefix in c("", "x_", "y_")) {
    align <- paste0(prefix, "title_align")
    if (!is.element(get_parsed(p, align), ALIGNMENT)) error_msg("'", align, "' (", get_parsed(p, align), ") should be one of ", paste(ALIGNMENT, collapse = ", "))
  }

  # Right axis: check areas and bars are on same axis
  if (any(is_yr(p))) { # we have right y-axis
    for (i in 1:2) {
      index <- list(which(is_bar_stack(p$type)), which(is_area_stack(p$type)))[[i]]
      if (length(index)) { # we have bars stacked; allow a stack only on same axis
        if (length(index) != length(which(is_yr(p, index))) & length(index) != length(which(is_yl(p, index)))) {
          terms <- c("bars", "areas")
          error_msg("Stacked ", terms[i], " should be all on either the left y-axis or all on the right y-axis. Please update parameter 'type' or parameter 'y_axis'.")
        }
      }
    }
  }

  # In meta tab one MUST use a dot as decimal separator. Error in case parameter type 'numeric' has a comma (',') in it.
  for (this_param in names(p)) if (NUMERIC == get_param_value_type(this_param)) if (is_set(p[[this_param]])) if (!is.numeric(get_parsed(p, this_param))) {
    error_msg("Parameter '", this_param, "' has type 'numeric'. However, the assigned value '", p[[this_param]], "' is instead of type '", class(p[[this_param]]), "'. Please use a dot ('.') as decimal separator for numbers.", if (param_is_list_type(this_param)) " Please note that the parameter is of type 'list'. If your list has length > 1, please split its elements with separator '", get_param_list_sep(this_param), "'.")
  }
  
  # LIMS
  if (is_set(p$y_l_lim)) error_msg("It is not allowed to set parameter 'y_l_lim'. Please use parameter 'y_lim' instead.")
  
  # y_r_at
  # if (is_set(p$y_r_lab) & !is_set(p$y_r_at)) error_msg("You have set parameter y_r_lab. Please ")
  # if (is_set(p$y_r_at) & 2 < length(p$y_r_at)) if (any(1e-10 < abs(diff(diff(p$y_r_at))))) error_msg("Values of parameter y_r_at should be equidistant.")
  
  # ID may not have spaces
  if (is_set(p$id)) if (grepl("\\s+", p$id, perl = T)) error_msg("Parameter 'id' does not allow a whitespace. Please remove the whitespace or replace it with e.g. '-'. Problematic id: '", p$id, "'.")
 
  # FONT
  # if (!is.element(p$font, extrafont::fonts())) error_msg("Your font '", p$font, "' is unkown. Please choose from: ", paste(extrafont::fonts(), collapse = ", "))
  # if (!is.element(p$font, names(grDevices::quartzFonts()))) error_msg("Your font '", p$font, "' is unkown. Please choose from: ", paste(names(grDevices::quartzFonts()), collapse = ", "))
 
  # ORDER
  if (is_set(p$order) & is_set(p$order_name)) error_msg("You have specified both 'order' (", p$order, ") as 'order_name' (", p$order_name, "). James doesn't know which to take. Please leave at least one empty.")
 
  # # DATA
  # series_name <- colnames(p$data)[-1]
  # series_name_duplicated <- series_name[duplicated(series_name)]
  # if (length(series_name_duplicated)) error_msg("Some series occur twice in your data tab '", p$tab, "' ('", paste(series_name_duplicated, collapse = ", "), "'). Please remove or rename.")
  
  # LOCK
  if (is_yes(p$lock)) {
    index_locked_setting <- which(is.element(p$locked_settings, names(p)))
    index <- NULL
    for (i in seq_along(index_locked_setting)) if (is_set(p[[p$locked_settings[i]]])) index <- c(index, i)
      
    if (length(index)) error_msg("The following parameters are locked: ", paste(p$locked_settings[index], collapse = ", "), ". The reason for this is to make the figures more similar/uniform/comparable for publication purposes. You can unlock these settings by setting parameter 'lock = no'.")
  }

  # HEATMAP
  if (is.element(HEATMAP, p$type)) {
    if (1 < length(p$type)) error_msg("Currently James can't add extra plot types to a heatmap. Please use 'type = heatmap' and remove other types/data.")

    # input mistakes
    if (is_no(p$heatmap_x_axis_asis) & is_really_character(colnames(p$data))) error_msg("You set 'heatmap_x_axis_asis = no', while the x-axis (i.e. first row) in your data contains a non-numeric character.")
    if (is_no(p$heatmap_y_axis_asis) & is_really_character(p$data[, 1])) error_msg("You set 'heatmap_y_axis_asis = no', while the y-axis (i.e. first column) in your data contains a non-numeric character.")
  }
  
  return(p)
}
