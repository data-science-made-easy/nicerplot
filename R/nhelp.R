#' @title Shows help
#' @description
#' Opens manual. If param is given, it opens manual at description of given parameter.
#'
#' @param param the parameter for which you need help
#' @return NULL
#' @examples
#' \dontrun{
#' nhelp("x_date_format")
#' }
#' @importFrom utils browseURL
#' @export
nhelp <- function(param = NULL) {
  url <- get_param("james_url")
  if (!is.null(param)) url <- paste0(url, "#parameter_", param)
  print(url)
  utils::browseURL(url)
}