#' ---
#' title: Create ak91.rda
#' ---
#'
suppressPackageStartupMessages({
  library("tidyverse")
  library("haven")
})

ak91 <- here::here("data-raw", "downloads", "ak91.dta") %>%
  read_dta() %>%
  mutate_if(haven::is.labelled, haven::as_factor) %>%
  map_dfc(~ rlang::set_attrs(.x, NULL))

devtools::use_data(ak91, overwrite = TRUE)
