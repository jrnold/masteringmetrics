#' ---
#' title: Create sheepskin effects
#' ---
suppressPackageStartupMessages({
  library("tidyverse")
  library("haven")
})

sheepskin <- here::here("data-raw", "downloads",
                        "clark_martorell_cellmeans.dta") %>%
  read_dta() %>%
  mutate_if(haven::is.labelled, haven::as_factor) %>%
  map_dfc(~ rlang::set_attrs(.x, NULL))

devtools::use_data(sheepskin, overwrite = TRUE)
