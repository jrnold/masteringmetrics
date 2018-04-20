suppressPackageStartupMessages({
  library("rex")
  library("lintr")
})

lint_dir <- function(path = ".", relative_path = TRUE,
                     pattern = "\\.([Rr]|Rmd|Rhtml)$", recursive = TRUE, ...) {
  lintr:::read_settings(path)
  on.exit(lintr:::clear_settings, add = TRUE)
  settings <- lintr:::settings
  names(settings$exclusions) <-
    normalizePath(file.path(path, names(settings$exclusions)))
  files <- dir(path = path, pattern = pattern, recursive = TRUE,
               full.names = TRUE)
  files <- normalizePath(files)
  lints <- lintr:::flatten_lints(lapply(files, function(file) {
    if (interactive()) {
      message(".", appendLF = FALSE)
    }
    try(lint(file, ..., parse_settings = FALSE))
  }))
  if (interactive()) {
    message()
  }
  lints <- lintr:::reorder_lints(lints)
  if (relative_path == TRUE) {
    lints[] <- lapply(lints, function(x) {
      x$filename <- re_substitutes(x$filename, rex(normalizePath(path),
                                                   one_of("/", "\\")), "")
      x
    })
    attr(lints, "path") <- path
  }
  class(lints) <- "lints"
  lints
}

lint_dir(here::here())
