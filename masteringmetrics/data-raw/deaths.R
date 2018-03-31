#' ---
#' title: Create MLDA deaths
#' ---
suppressPackageStartupMessages({
  library("tidyverse")
  library("haven")
})

deaths <-
  here::here("data-raw", "downloads", "deaths.dta") %>%
  read_dta() %>%
  mutate_if(is.labelled, as_factor) %>%
  mutate(state = as.factor(state))

devtools::use_data(deaths, overwrite = TRUE)
