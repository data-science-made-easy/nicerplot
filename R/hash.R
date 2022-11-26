set_hash_p <- function(p) {
  print_debug_info(p)
  
  p_copy          <- p
  p_copy$debug    <- F
  p_copy$open     <- F
  p_copy$parallel <- F
  for (file_format in FILE_FORMATS) p_copy[[file_format]] <- FALSE # Let's pretend all flags are down  
  
  # Set hash of (meta) data
  p$hash_p <- digest::digest(p_copy)
  
  p  
}

set_export_flags <- function(p) {
  print_debug_info(p)
  # If we have created a figures before, then skip that work.
  if (!p$cache) return(p)

  for (file_format in FILE_FORMATS) {
    if (is_yes(get_parsed(p, file_format))) {
      file_name_param <- paste0(file_format, "_file", collapse = "") # e.g. 'png_file'
      if (file.exists(p[[file_name_param]])) {
        # file exists so check hash
        hash_of_file <- digest::digest(p[[file_name_param]]) # this is the hash of 'png_file' in our example
        hash_of_file_path <- file.path(p$hash_dir, hash_of_file) # e.g. ./generated/'hash of figure.png'
        if (file.exists(hash_of_file_path)) { # hash exists so check content
          # i.e. check whether file was made with same (meta) data
          if (p$hash_p == readLines(hash_of_file_path)[[1]]) {
            p[[file_format]] <- FALSE
            print_progress(p, "Skipping ", if (is_yes(p$open)) "creation and opening of '" else "'", p[[file_name_param]], "' (cached).")
          }
        }
      }
    }
  }

  p
}

save_hash <- function(p, file_format) {
  print_debug_info(p)
   if (!p$cache) return(p)
  
  if (!dir.exists(p$hash_dir)) {
    print_info(p, "Creating directory '", p$hash_dir, "' to speed James up when recreating the exact same figures.")
    dir.create(p$hash_dir, recursive = T)
  }
  
  print_info(p, "Caching figure...")
  file_name_param <- paste0(file_format, "_file", collapse = "") # e.g. 'png_file'

  hash_of_file <- digest::digest(p[[file_name_param]]) # this is the hash of 'png_file' in our example
  hash_of_file_path <- file.path(p$hash_dir, hash_of_file) # e.g. ./generated/'hash of figure.png'
  
  # Create file p$hash_of_file_path (this is the hash of the image) and store p$hash in it
  file_connection <- file(hash_of_file_path)
  writeLines(p$hash_p, file_connection)
  close(file_connection)
  if (p$debug) print_info(p, "Cached ", p[[file_name_param]])
  
  p
}

