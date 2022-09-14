is_line <- function(type) is.element(type, LINE_SET)

arrows_exist <- function(p) is_set(p$arrow_n) | is_set(p$arrow_position_pct)

dx_to_inch <- function(dx) {
  x_usr  <- abs(diff(graphics::par()$usr[1:2]))
  x_inch <- graphics::par("pin")[1]
  dx / x_usr * x_inch
}
dx_from_inch <- function(dx_in) {
  x_usr  <- abs(diff(graphics::par()$usr[1:2]))
  x_inch <- graphics::par("pin")[1]
  dx_in / x_inch * x_usr
}
dy_to_inch <- function(dy) {
  y_usr  <- abs(diff(graphics::par()$usr[3:4]))
  y_inch <- graphics::par("pin")[2]
  dy / y_usr * y_inch
}
dy_from_inch <- function(dy_in) {
  y_usr  <- abs(diff(graphics::par()$usr[3:4]))
  y_inch <- graphics::par("pin")[2]
  dy_in / y_inch * y_usr
}

get_arrow_xy <- function(p) {
  print_debug_info(p)
  # (1) Determine length of each of the 'line time series' (from now on called 'curves')
  # Measure curves on 'inch scale' to accommodate for
  # - differences between the scales of the x- and y-axis
  # - differences between the top-down distance in inches and the left-right distance in inches

  arrow_series_length_inch <- NULL
  for (j in 1:ncol(p$y)) if (is_line(p$type[j])) {
    curve_length_inch <- 0
    for (i in 1:(length(p$x) - 1)) {
      dx    <- p$x[1 + i]    - p$x[i]
      dy    <- p$y[1 + i, j] - p$y[i, j]
      delta <- sqrt(dx_to_inch(dx)^2 + dy_to_inch(dy)^2)
      if (is.na(delta)) {
        # some data is NA
      } else curve_length_inch <- curve_length_inch + delta
    }
    arrow_series_length_inch <- c(arrow_series_length_inch, curve_length_inch)
  }
  
  # VALIDATION
  if (is_set(p$arrow_position_pct) & is_set(p$arrow_n)) error_msg("You can't specify both paramter 'arrow_position_pct' and paramter 'arrow_n'. Please specify at most one of them.")

  # (2) Determine positions of arrows on 'total curve' (i.e., curves glued together).
  # Position is expressed as distance traveled over 'total curve'.
  # Distances are measured 'on paper', i.e. in inches
  if (is_set(p$arrow_position_pct)) {
    if (any(p$arrow_position_pct <= 0 | 100 < p$arrow_position_pct)) error_msg("Arrows must be 'on the curve'. Parameter 'arrow_position_pct' should have values larger than zero and smaller than or equal to 100 (%).")
    curve_arrow_positions_inch <- sum(arrow_series_length_inch) * p$arrow_position_pct / 100
  } else {
    if (1 == length(p$arrow_n)) {
      # user wants to spread arrows accross the 'total curve'
      dist_between_arrows_inch   <- sum(arrow_series_length_inch) / p$arrow_n
      curve_arrow_positions_inch <- dist_between_arrows_inch / 2
      curve_arrow_positions_inch <- curve_arrow_positions_inch + 0:(p$arrow_n - 1) * dist_between_arrows_inch
    } else {
      # user set number of arrows per curve
      if (length(p$arrow_n) != length(arrow_series_length_inch)) {
        error_msg("The number of values you specify in parameter 'arrow_n' (", length(p$arrow_n), ") should equal the number of time series of type 'line' in your data (", length(arrow_series_length_inch), ").")
      } else {    
        curve_arrow_positions_inch <- NULL
        for (j in seq_along(arrow_series_length_inch)) {
          inches_walked              <- if (1 == j) 0 else sum(arrow_series_length_inch[2:j - 1])
          dist_between_arrows_inch   <- arrow_series_length_inch[j] / p$arrow_n[j]
          inches_walked              <- inches_walked + dist_between_arrows_inch / 2
          curve_arrow_positions_inch <- c(curve_arrow_positions_inch, inches_walked)
          if (1 < p$arrow_n[j]) curve_arrow_positions_inch <- c(curve_arrow_positions_inch, inches_walked + 1:(p$arrow_n[j] - 1) * dist_between_arrows_inch)
        }
      }
    }
  }

  
  # (3) Report positions in 'coordinates' on x- and y-axis
  arrow_angle       <- p$arrow_angle / 360 * 2 * pi # convert arc degrees to radials
  arrow_length_inch <- p$arrow_length_cm / grDevices::cm(1)
  inches_walked     <- 0
  arrow_list        <- list()
  for (j in 1:ncol(p$y)) if (is_line(p$type[j])) {
    for (i in 1:(length(p$x) - 1)) {
      # handy shorthands
      x0         <- p$x[i]
      y0         <- p$y[i, j]
      x1         <- p$x[1 + i]
      y1         <- p$y[1 + i, j]
      dx         <- x1 - x0
      dy         <- y1 - y0
      dx_in      <- dx_to_inch(dx)
      dy_in      <- dy_to_inch(dy)
      delta_inch <- sqrt(dx_in^2 + dy_in^2)
      if (!is.na(delta_inch)) { # only measure distance and create arrow if data exists
        index <- which(inches_walked < curve_arrow_positions_inch & curve_arrow_positions_inch <= inches_walked + delta_inch)
        if (length(index)) {
          for (i_index in index) {
            fraction   <- (curve_arrow_positions_inch[i_index] - inches_walked) / delta_inch
            x_end      <- x0 + fraction * dx # horizontal end point of arrow *in (x,y)-coordinates (ie no inches)
            y_end      <- y0 + fraction * dy # vertical   end point of arrow
            alpha      <- atan(dy_in / dx_in) # angle between curve and x-axis
          
            if (x0 < x1) { # arrow head part left of curve if x increases
              gamma_dif <- alpha - arrow_angle
              gamma_sum <- alpha + arrow_angle
              dx_xu_in  <- arrow_length_inch * cos(gamma_dif)
              dy_yu_in  <- arrow_length_inch * sin(gamma_dif)
              xl        <- x_end - dx_from_inch(dx_xu_in) # x-head part LEFT of curve
              yl        <- y_end - dy_from_inch(dy_yu_in) # y-head part LEFT of curve
              xr        <- x_end - dx_from_inch(arrow_length_inch * cos(gamma_sum)) # x-head part RIGHT of curve
              yr        <- y_end - dy_from_inch(arrow_length_inch * sin(gamma_sum)) # y-head part RIGHT of curve
            } else {
              gamma_sum <- abs(alpha) + arrow_angle
              gamma_dif <- abs(alpha) - arrow_angle
              if (y0 < y1) { # if x decreases, y increases
                dx_xu_in  <- arrow_length_inch * cos(gamma_sum)
                dy_yu_in  <- arrow_length_inch * sin(gamma_sum)
                xl        <- x_end + dx_from_inch(dx_xu_in) # x-head part LEFT of curve
                yl        <- y_end - dy_from_inch(dy_yu_in) # y-head part LEFT of curve
                xr        <- x_end + dx_from_inch(arrow_length_inch * cos(gamma_dif)) # x-head part RIGHT of curve
                yr        <- y_end - dy_from_inch(arrow_length_inch * sin(gamma_dif)) # y-head part RIGHT of curve
              } else { # x decreases, y decreases
                dx_xu_in  <- arrow_length_inch * cos(gamma_dif)
                dy_yu_in  <- arrow_length_inch * sin(gamma_dif)
                xl        <- x_end + dx_from_inch(dx_xu_in) # x-head part LEFT of curve
                yl        <- y_end + dy_from_inch(dy_yu_in) # y-head part LEFT of curve
                xr        <- x_end + dx_from_inch(arrow_length_inch * cos(gamma_sum)) # x-head part RIGHT of curve
                yr        <- y_end + dy_from_inch(arrow_length_inch * sin(gamma_sum)) # y-head part RIGHT of curve
              }
            }
          
            arrow_new <- list(j = j, x_end = x_end, y_end = y_end, xl = xl, yl = yl, xr = xr, yr = yr)
            arrow_list[[1 + length(arrow_list)]] <- arrow_new
          
          }
        }
        inches_walked <- inches_walked + delta_inch
      }
    }
  }
  p$arrow_list <- arrow_list
  
  p
}
