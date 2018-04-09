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
  map_dfc(~ rlang::set_attrs(.x, NULL)) %>%
  # add age variable
  mutate(age = ( (79 - yob) * 4 + 5 - qob) / 4,
         # not integer since not necessarily whole number
         sob = as.integer(sob),
         yob = as.integer(1900 + yob),
         s = as.integer(s))

devtools::use_data(ak91, overwrite = TRUE)
