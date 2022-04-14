#' @title Generic function to make a 'nice R plot'/'nicer plot` and save it as png, pdf, jpg and/or svg.
#' @description Can plot time series data from xlsx-files, certain URLs, and directly from R (`data.frame`, `james`, `list`, `matrix`, `mts`, `ts`). Saves it as png, pdf, svg, and/or jpeg.
#' @param x 'path/to/file.xlsx', 'URL', or above data types.
#' @param ... you can add parameters to customize your figure (see manual). For example `title` to specify a title, `pdf = TRUE` if you want a PDF (`png = TRUE` by default), and `file` to specify file name (with `file`.{png,pdf,jpg,svg} as a result).
#' @return path/to/result/file.png
#' @examples
#' \dontrun{
#' x <- 0:6
#' my_data <- data.frame(x, first = (6 - x)^2, second = x^2)
#' nplot(my_data, title = 'Hello World', x_title = 'x', y_title = 'y', footnote = "just an example")
#' }
#' @export
nplot <- function(x, ...) {
  if (is.character(x))       nplot.character(x, ...)
  else if (is.data.frame(x)) nplot.data.frame(x, ...)
  else if (is.james(x))      nplot.james(x, ...)
  else if (is.list(x))       nplot.list(x, ...)
  else if (is.matrix(x))     nplot.matrix(x, ...)
  else if (stats::is.mts(x))        nplot.mts(x, ...)
  else if (stats::is.ts(x))         nplot.ts(x, ...)
}
