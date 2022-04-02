custom <- function(p) {
  print_debug_info(p)
  
  if (is_set(p$custom)) eval(parse(text = p$custom))
    
  return(p)
}