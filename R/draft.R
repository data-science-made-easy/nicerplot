draft <- function(p) {
  print_debug_info(p)
  if (!is_yes(p$draft)) return(p)

  print_info(p, "[draft = y] Resolution set to 150 ppi")
  p$resolution = 150

  return(p)
}