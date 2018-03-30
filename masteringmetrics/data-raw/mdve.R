#' ---
#' title: Create mdve.rda
#' ---
suppressPackageStartupMessages({
  library("tidyverse")
})

mdve <- here::here("data-raw", "downloads", "mdve.dta") %>%
  haven::read_dta() %>%
  mutate_if(haven::is.labelled, haven::as_factor) %>%
  map_dfc(~ rlang::set_attrs(.x, NULL))

devtools::use_data(mdve, overwrite = TRUE)
