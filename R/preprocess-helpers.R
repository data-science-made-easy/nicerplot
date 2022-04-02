is_numeric <- function(p) {
  type <- get_param(p, style = "type")
  if (is.na(type)) return(FALSE) else return(NUMERIC == type)
}

is_bool <- function(p) {
  type <- get_param(p, style = "type")
  if (is.na(type)) return(FALSE) else return(BOOL == type) 
}