#' ---
#' title: Create the pubtwins data
#' ---

suppressPackageStartupMessages({
  library("tidyverse")
  library("haven")
})

pubtwins <- here::here("data-raw", "downloads", "pubtwins.dta") %>%
  read_dta() %>%
  mutate_if(haven::is.labelled, haven::as_factor) %>%
  map_dfc(~ rlang::set_attrs(.x, NULL))

devtools::use_data(pubtwins, overwrite = TRUE)
