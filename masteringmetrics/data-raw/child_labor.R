#' ---
#' title: Create child_labor.rda
#' ---
#'
suppressPackageStartupMessages({
  library("tidyverse")
  library("haven")
})

child_labor <- unz(here::here("data-raw", "downloads", "AA_small.dta_.zip"),
                   "AA_small.dta") %>%
  read_dta() %>%
  mutate_if(haven::is.labelled, haven::as_factor) %>%
  map_dfc(~ rlang::set_attrs(.x, NULL))

devtools::use_data(child_labor, overwrite = TRUE)
