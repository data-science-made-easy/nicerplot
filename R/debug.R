print_var <- function(x) print(paste0(as.list(match.call())[[2]], ": ", x))
print_debug_info <- function(p)   if (p$debug & !creating_report_now()) {
  cat(paste0("DEBUG INFO>> ", deparse(sys.calls()[[sys.nframe()-1]]), "\n"))
  p. <<- p
  # if (is_set(p$x_at)) stop('found it')
}

show_msg         <- function(...) cat(paste0("> INFO > ", paste0(...), "\n"))
print_info       <- function(p, ...) if (p$debug & !creating_report_now()) cat(paste0("> INFO > ", paste0(...), "\n"))
print_warning    <- function(...) cat(paste0("## WARNING ## ", paste0(...), "\n"))
todo             <- function(p, ...) if (p$debug & !creating_report_now()) cat(paste0("## TO DO ## ", paste0(...), "\n"))
error_msg        <- function(...) stop(paste0("## PLEASE FIX THIS ## ", paste0(...), "\n"), call. = F)
error_casting    <- function(param_name, expected_type, observed_type, val) {
  stop(
    message(paste0("Parameter: ", param_name)),
    message(paste0("- expected type: ", expected_type)),
    message(paste0("- observed type: ", observed_type)),
    message(paste0("- its value:     ", val)),
    "observed type should match expected type",
    call. = F
  )
}
error_casting_x_lab <- function(param_name, problematic_value, possible_values) {
  stop(
    message(paste0("Parameter: ", param_name)),
    message(paste0("- problematic value: ", problematic_value)),
    message(paste0("- possible values: ", paste0(possible_values, collapse = ", "))),
    "Parameter value should be one of the possible values.",
    call. = F
  )
}

print_progress <- function(p, ...) if (!p$quiet) cat(paste0(paste0(...), "\n"))
