#' @title Create a 'nice R plot'/'nicer plot` in Png, Pdf, Jpg and/or Svg format
#' @description
#' Plots data stored in a data.frame, james object, matrix, mts, ts, cbs.nl-type 'share data' URL,
#' an xlsx-file or in a list that combines these data structures. The result is saved as
#' PNG, PDF, SVG, and/or JPEG.
#'
#' @param x data.frame, james object, matrix, mts, ts, 'path/to/file.xlsx', URL
#' @param ... you can add parameters to customize your figure (see manual). For example `title` to specify a title, `pdf = TRUE` if you want a PDF (`png = TRUE` by default), and `file` to specify file name (with path/to/your-file.\{png, pdf, jpg, svg\} as a result).
#' @return path/to/result/file.png
#' @details
#' Class 'james' can help you to recycle parameters and data accross multiple figures. A 'james'
#' object also enables you also to add parameters in an incremental fashion, rather than
#' putting them all in one big nplot-statement.
#' @seealso \code{\link{james}} to create a james object
#' @examples
#' \dontrun{
#' x <- 0:6
#' d <- data.frame(x, first = (6 - x)^2, second = x^2)
#' nplot(d, title = 'Hello World', x_title = 'x', y_title = 'y', footnote = "just an example")
#' }
#' @export
nplot <- function(x, ...) {
  if (is.character(x))       nplot.character(x, ...)
  else if (is.data.frame(x)) nplot.data.frame(x, ...)
  else if (is.james(x))      nplot.james(x, ...)
  else if (is.list(x))       nplot.list(x, ...)
  else if (is.matrix(x))     nplot.matrix(x, ...)
  else if (stats::is.mts(x)) nplot.mts(x, ...)
  else if (stats::is.ts(x))  nplot.ts(x, ...)
}
