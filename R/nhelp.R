#' @importFrom utils browseURL
nhelp <- function(param = NULL) {
  url <- get_param("james_url")
  if (!is.null(param)) url <- paste0(url, "#parameter_", param)
  print(url)
  utils::browseURL(url)
}