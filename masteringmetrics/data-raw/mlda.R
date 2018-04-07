#' ---
#' title: Create MLDA Regression Discontinuity Data
#' ---
suppressPackageStartupMessages({
  library("tidyverse")
})

mlda <- here::here("data-raw", "downloads", "AEJfigs.dta") %>%
  haven::read_dta() %>%
  mutate_if(haven::is.labelled, haven::as_factor) %>%
  map_dfc(~ rlang::set_attrs(.x, NULL)) %>%
  select(-matches("fitted^"))

devtools::use_data(mlda, overwrite = TRUE)
