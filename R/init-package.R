#' @importFrom openxlsx "read.xlsx"

cat("Initializing...\n")
pkg.env <- new.env(parent = emptyenv())
cat("Loading pkg.env$globals...\n")
pkg.env$globals <- NULL

# if (interactive()) {
#   cat("interactive")
#   pkg.env$pkg.env$globals_file <- '../ext/james-base-settings.xlsx'
# } else {
#   cat("in package")
  settings_file <- system.file('extdata', 'james-base-settings.xlsx', package = 'nicerplot')
# }

for (sheet in openxlsx::getSheetNames(settings_file)) {
  pkg.env$globals <- rbind(pkg.env$globals, openxlsx::read.xlsx(settings_file, sheet = sheet))  
}
cat("Done.\n")
