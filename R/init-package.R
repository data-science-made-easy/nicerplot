#' @importFrom stats is.mts is.ts
#' @importFrom utils head tail type.convert

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


# overwrite font # << don't do that; just check for RijksoverheidSansText and if not available use 'sans'
# index <- which("font" == pkg.env$globals$param)
# pkg.env$globals$default[index] <- "sans"

cat("Done.\n")
