is_map <- function(p) is.element(MAP, p$style)

geo_init <- function(p) {
  print_debug_info(p)
  
  # Determine layer
  # if (!is_set(p$geo_cbs_map)) error_msg("Please set 'geo_cbs_map' (see manual for options).")
  if (!is_set(p$cbs_map))      error_msg("Please set 'cbs_map' (see manual for options).")
  if (!is_set(p$cbs_map_year)) error_msg("Please set 'cbs_map_year' (see manual for options).")

  # p$geo_url_polygon  <- paste0(p$geo_cbs_url_base, p$geo_cbs_map, p$geo_cbs_url_polygon)
  # p$geo_url_centroid <- paste0(p$geo_cbs_url_base, p$geo_cbs_map, p$geo_cbs_url_centroid)

  # Read data
  # 
  # p$geo_region_data   <- sf::st_read(p$geo_url_polygon,   stringsAsFactors = F, quiet = T)
  # p$geo_centroid_data <- sf::st_read(p$geo_url_centroid,  stringsAsFactors = F, quiet = T)

  p$geo_region_data   <- cbsodataR::cbs_get_sf(p$cbs_map, p$cbs_map_year, verbose = FALSE)
  p$geo_centroid_data <- suppressWarnings(sf::st_centroid(p$geo_region_data))

  #
  ## Filter data
  #
  # Sometimes we see duplicates :-s
  index_dup <- which(duplicated(p$geo_region_data$statcode))
  if (length(index_dup)) {
    print_warning("Some of your regions exist in duplicate in the downloaded data set. These dups are removed.")
    p$geo_region_data   <- p$geo_region_data[-index_dup, ]
  }
  index_dup <- which(duplicated(p$geo_centroid_data$statcode))
  if (length(index_dup)) {
    print_warning("Some of your centroids exist in duplicate in the downloaded data set. These dups are removed.")
    p$geo_centroid_data <- p$geo_centroid_data[-index_dup, ]
  }

  
  if (!is_set(p$data)) { # Init stuff in xlsx to make user's life easier    
    n_colors <- if (is_set(p$name)) length(p$name) else min(3, length(p$geo_region_data$statnaam))
    p$geo_n_regions <- length(p$geo_region_data$statnaam)
    p$data <- cbind(region = p$geo_region_data$statnaam, code = p$geo_region_data$statcode, value = 1:p$geo_n_regions, label = 1:p$geo_n_regions)
    
    print_progress(p, "Adding data tab '", p$tab, "' with geo regions to your file '", p$xlsx, "'...\n\n")    
    wb <- openxlsx::loadWorkbook(p$xlsx)
    openxlsx::addWorksheet(wb, sheetName = p$tab)
    openxlsx::writeData(wb, sheet = p$tab, p$data, colNames = T)
    openxlsx::addStyle(wb,  sheet = p$tab, style = openxlsx::createStyle(textDecoration = "bold"), rows = 1, cols = 1:3)
    openxlsx::setColWidths(wb, sheet = p$tab, cols = 1:3, widths = "auto")
    openxlsx::saveWorkbook(wb, p$xlsx, overwrite = T)

    print_progress(p, "Done. Please re-open '", p$xlsx, "' and edit the color column of tab '", p$tab, "'.\n")
  }
  
  if (is_set(p$geo_n_regions)) stopifnot(p$geo_n_regions == nrow(p$data)) else {
    p$geo_n_regions <- nrow(p$data)
  }

  p
}

geo_validate <- function(p) {
  print_debug_info(p)
  
  # Check column names
  if (!all(is.element(colnames(p$data), p$geo_data_column_names))) error_msg("The column names of geo-tab '", p$tab, "' must be equal to or a subset of: ", paste(p$geo_data_column_names, collapse = ", "), ".")

  # Check presence identifier
  if (!any(is.element(c("region", "code"), colnames(p$data)))) {
    error_msg("You currently don't have a column 'region' or a column 'code' in your geo-tab '", p$tab, "'. This tab should contain one of both or both.")
  }

  # Check region name
  if (is.element("region", colnames(p$data))) {
    index_mistake <- which(!is.na(p$data[, "region"]) & !is.element(p$data[, "region"], p$geo_region_data$statnaam))

    if (length(index_mistake)) error_msg("The following region names in your data tab '", p$tab, "' are non-existing: ", paste(p$data[index_mistake, "region"], collapse = ", "), ". Please choose from: ", paste(p$geo_region_data$statnaam, collapse = ", "), ".")
  }

  # Check region code
  if (is.element("code", colnames(p$data))) {
    if (any(is.na(p$data[, "code"]))) error_msg("In you data tab '", p$tab, "' are missing values in the column 'code'. Please fill in the missing values or remove the code column. In case you remove the column, James will use the 'region' column that contains the region names instead.")
    index_mistake <- which(!is.element(p$data[, "code"], p$geo_region_data$statcode))
    
    if (length(index_mistake)) {
      error_msg("The following region codes in your data tab '", p$tab, "' are non-existing: ", paste(p$data[index_mistake, "code"], collapse = ", "), ". Please choose from: ", paste(p$geo_region_data$statcode, collapse = ", "), ".")
    }
  }

  # Check consistency if both present
  if (all(is.element(c("region", "code"), colnames(p$data)))) for (i in 1:p$geo_n_regions) {
    if (!is.na(p$data[i, "region"]) & !is.na(p$data[i, "code"])) {
      index <- which(p$geo_region_data$statcode == p$data[i, "code"])
      if (p$geo_region_data$statnaam[index] != p$data[i, "region"]) error_msg("Your entry 'code = ", p$data[i, "code"], "' has 'region = ", p$data[i, "region"], "', while in the original data set '", p$geo_cbs_map, "', the region name is '", p$geo_region_data$statnaam[index], "'. Please make the two equal or remove the region name from your data set.")
    }
  }
    
  # If data has column value, then geo_col_threshold must be set too
  if ("value" %in% colnames(p$data)) if (!is_set(p$geo_col_threshold)) print_warning("Your geo-tab '", p$tab, "' has a column 'value', while parameter 'geo_col_threshold' is not set by you (now auto-set to min/max).")
  
  # Validate geo_col_threshold  
  if (is_set(p$geo_col_threshold)) if (is.unsorted(p$geo_col_threshold, strictly = T)) error_msg("The values in your parameter 'geo_col_threshold' should be strictly increasing. Now they are not: ", paste0(p$geo_col_threshold, collapse = ", "), ".")
  
  p
}

geo_pre <- function(p) {
  print_debug_info(p)

  # Get input data
  if (!is_set(p$region_name) & is.element("region", colnames(p$data)))
    p$region_name <- p$data[, "region"]
  if (!is_set(p$region_code) & is.element("code", colnames(p$data)))
    p$region_code <- p$data[, "code"]
     
  if (is.element("color", colnames(p$data)) & !is_set(p$region_color)) p$region_color <- get_col_from_p(p, p$data[, "color"]) # to color the regions respectively
  if (is.element("label", colnames(p$data)) & !is_set(p$region_label)) p$region_label <- p$data[, "label"]

  # Color for legend
  p$palette <- get_col_from_p(p, p$palette)

  # Color based on value in data
  if (is.element("value", colnames(p$data))) {
    # cast value column
    p$data <- transform(p$data, value = as.numeric(p$data[, "value"]))
    
    # If user did not set 'geo_col_threshold', then use min and max
    if (!is_set(p$geo_col_threshold)) {
      p$geo_col_threshold <- seq(from = min(p$data[, "value"], na.rm = T), to = max(p$data[, "value"], na.rm = T), length = length(p$palette))
    }

    for (i in 1:p$geo_n_regions) if (!is_set(p$region_color[i])) {
      this_value <- as.numeric(p$data[i, "value"])
      # detect this value in palette
      for (j in 2:length(p$geo_col_threshold)) {
        if (!is.na(this_value)) if (p$geo_col_threshold[j - 1] <= this_value & this_value <= p$geo_col_threshold[j]) {
          this_value <- this_value - p$geo_col_threshold[j - 1]
          this_value <- this_value / (p$geo_col_threshold[j] - p$geo_col_threshold[j - 1])
          rgb_col    <- grDevices::colorRamp(p$palette[c(j - 1, j)], interpolate = "linear", space = "rgb")(this_value)
          hex_col    <- grDevices::rgb(rgb_col[1,1], rgb_col[1,2], rgb_col[1,3], maxColorValue = 255)
          p$region_color[i] <- hex_col
        }
      }
    }
  }

  p$color <-  get_col_from_p(p, p$palette)

  # Now remove colors that we want for specific series
  if (is_set(p$name_col)) {
    # Unravel name_col
    lst <- stringr::str_split(p$name_col, "=")
    if (!all(2 == unlist(lapply(lst, length)))) error_msg("Your parameter 'name_col' should have elements in the form of 'time-series=color-name. Problematic name_col: ", p$name_col)

    p$name_col_processed <- stringr::str_trim(unlist(lapply(lst, function(elts) elts[2])))
    names(p$name_col_processed) <- stringr::str_trim(unlist(lapply(lst, function(elts) elts[1])))

    yet_assigned_colors <- get_col_from_p(p, p$name_col_processed)
    p$palette <- setdiff(p$palette, yet_assigned_colors)
    
    index_cols_should_get <- match(names(p$name_col_processed), p$name)

    p$color[index_cols_should_get] <- get_col_from_p(p, p$name_col_processed)
  }
  
  # Legend
  if (!is_set(p$name)) p$name <- p$geo_col_threshold
  p$n_series     <- if (is_set(p$name)) length(p$name) else 0
  p$legend_type  <- rep(MAP, p$n_series)
  p$legend_color <- p$color
  
  p
}

geo_init_plot <- function(p) {
  print_debug_info(p)
  
  # Margins
  mai <- c(p$margin_south, p$margin_west, p$margin_north, p$margin_east) / grDevices::cm(1) # scale to inches

  # adjust if plot in R
  if (!any_plot_export(p)) {
    mai <- mai / c(0.6, 0.5, 0.5, 0.25) * c(1.02, 0.82, 0.82, 0.42)
  }
  # Init plot
  graphics::par(bg = p$bg_col, mai = mai, xaxs = 'i', yaxs = 'i')
  
  p
}

geo_plot <- function(p) {
  print_debug_info(p)
  
  if (is_set(p$region_code)) {
    index_match <- match(p$region_code, p$geo_region_data$statcode)
  } else {
    index_match <- match(p$region_name, p$geo_region_data$statnaam)
  }
  
  # Plot map
  plot(sf::st_geometry(p$geo_region_data)[index_match], col = p$region_color, border = p$geo_border_col, lwd = p$geo_border_lwd)
  
  # Add text labels
  if (is_set(p$region_label)) {
    for (i in 1:length(index_match)) {
      this_point <- sf::st_geometry(p$geo_centroid_data)[[index_match[i]]]
      
      graphics::text(this_point[[1]], this_point[[2]], labels = set_newline(p$region_label[i]), family = p$font, col = get_col_from_p(p, p$region_label_col), font = p$region_label_font_style, cex = p$region_label_font_size)
    }
  }
  
  p
}



























