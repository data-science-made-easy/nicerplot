is_world_map     <- function(p) is.element(WORLD_MAP, p$style)
is_world_map_www <- function(p) is.element(WORLD_MAP_WWW, p$style)

col_value <- function(v, breaks, values) {
  stopifnot(all(0 < diff(breaks)))
  
  breaks <- c(-Inf, breaks, Inf)
  
  for (i in seq_along(breaks))
    if (breaks[i] <= v & v < breaks[1 + i])
      return(values[i])
}

world_map_pre <- function(p) {
  print_debug_info(p)

  # Validate TODO put in own function
  index_dup <- duplicated(p$data[, 1])
  if (any(index_dup)) error_msg(paste0("Each country should only occur once. Countries that occur in duplicate are: ", p$data[index_dup, 1]))

  # Load maps
  p$world <- rnaturalearth::ne_countries(scale = "small", returnclass = "sf")

  ocean_found <- FALSE
  for (ocean_path in get_param("ocean_file_paths")) {
    if (file.exists(ocean_path)) {
      ocean_found <- TRUE
      p$ocean <- sf::st_read(file.path(ocean_path, "ne_110m_ocean"))
    }
  }
  if (!ocean_found) error_msg("Ocean not found! Paths '", paste(get_param("ocean_file_paths"), collapse = ", "), "' do not exist :-O")
  
  # Check country codes
  if (!all(2 == nchar(p$data[, 1])) & !all(3 == nchar(p$data[, 1])))
    error_msg("The first column of your data set should contain either country codes conform ISO 3166-1 alpha 2 with only two characters each, or alpha 3 with three characters each.")
    
  # Fix country codes
  if (3 == nchar(p$data[1,1])) {
    p$world_map_country <- toupper(p$data[, 1])
  } else {
    # To 3-letter-iso
    iso <- ISOcodes::ISO_3166_1
    for (i in 1:nrow(p$data)) {
      index <- which(iso$Alpha_2 == toupper(p$data[i, 1]))
      if (0 == length(index)) {
        print_warning(paste0("Country code '", p$data[i, 1], "' is not found in ISO 3166-1 alpha 2.", sep = ""))
      } else {
        p$world_map_country[i] <- iso$Alpha_3[index]
      }
    }
  }
  
  # Check
  index <- which(!is.element(p$world_map_country, p$world[["adm0_a3"]]))
  if (length(index))
    print_warning(paste0("The following countries are not available in the world map: ", paste0(p$data[index, 1], collapse = ", ")))
  
  # Set color of title value
  p$color <-  get_col_from_p(p, p$palette)
  if (!is_set(p$world_map_value_bg_col) & is_set(p$world_map_value)) {
    p$world_map_value_bg_col <- col_value(v = p$world_map_value, breaks = p$world_map_threshold, values = p$color)
  }
  
  # Set colors of country
  p$country_col <- rep(get_col_from_p(p, p$world_map_country_no_data_col), nrow(p$world))
  for (i in 1:nrow(p$world)) {
    index <- which(p$world[["adm0_a3"]][i] == p$world_map_country) # index in our data
    stopifnot(length(index) < 2)
    if (length(index)) {
      p$country_col[i] <- col_value(v = p$data[index, 2], breaks = p$world_map_threshold, values = p$color)
    }
  }
  
  p
}

world_map_projection <- function(p) {
  print_debug_info(p)
  
  p$world <- sf::st_transform(p$world, crs = p$world_map_projection)
  p$ocean <- sf::st_transform(p$ocean, crs = p$world_map_projection)
  
  p
}

world_map_init_plot <- function(p) {
  print_debug_info(p)
  
  # Margins
  mai <- c(p$margin_south, p$margin_west, p$margin_north, p$margin_east) / grDevices::cm(1) # scale to inches

  # adjust if plot in R
  if (!any_plot_export(p)) {
    mai <- mai / c(0.6, 0.5, 0.5, 0.25) * c(1.02, 0.82, 0.82, 0.42)
  }
  
  # Init plot
  graphics::par(bg = p$bg_col, mai = mai)#, xaxs = 'i', yaxs = 'i')
  
  p
}

world_map_plot <- function(p) {
  print_debug_info(p)

  # Plot world
  plot(sf::st_geometry(p$world), col = p$country_col, border = get_col_from_p(p, p$world_map_country_border_col), lwd = p$world_map_country_border_lwd)
  
  # Plot ocean
  plot(sf::st_geometry(p$ocean), add = T, col = get_col_from_p(p, p$world_map_ocean_col), border = get_col_from_p(p, p$world_map_ocean_border_col))
  
  # Legend
  bbw     <- sf::st_bbox(p$world)
  bbo     <- sf::st_bbox(p$ocean)
  x_range <- c(min(bbw$xmin, bbo$xmin), max(bbw$xmax, bbo$xmax))
  y_range <- c(min(bbw$ymin, bbo$ymin), max(bbw$ymax, bbo$ymax))
  x_left  <- x_range[1] + .4 * diff(x_range)
  x_right <- x_left + diff(x_range) / 2.5
  y_bot   <- y_range[1] + .07 * diff(y_range)
  y_top   <- y_bot + .06 * diff(y_range)


  # legend txt; decimal seperator, number of decimals
  world_map_threshold_legend_txt <- fix_numbers(p$world_map_threshold, n_decimals = p$world_map_threshold_legend_n_decimals, p$decimal_mark, big_mark = p$big_mark)
  sgn <- rep("", length(p$world_map_threshold))
  sgn[which(0 < p$world_map_threshold)] <- "+"
  world_map_threshold_legend_txt <- paste0(sgn, world_map_threshold_legend_txt)

  dx  <- x_right - x_left
  dy  <- y_top   - y_bot
  txt <- c(NA, world_map_threshold_legend_txt)
  for (i in 1:6) {
    xl <- x_left + (i - 1) * dx / 6
    xr <- xl + dx / 6
    graphics::rect(xl, y_bot, xr, y_top, col = p$color[i], border = NA)#, lwd = 1)
    
    # sep dots
    if (1 < i) graphics::points(xl, y_top, col = get_col_from_p(p, p$world_map_legend_dot_col), cex = p$world_map_legend_dot_size, pch = 19)
  
    graphics::text(x = xl, y = y_top + dy / 2, labels = txt[i], family = p$font, cex = p$world_map_legend_font_size, col = get_col_from_p(p, p$world_map_legend_font_col))
  }
  
  p
}




















