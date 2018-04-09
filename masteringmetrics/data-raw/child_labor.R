#' ---
#' title: Create child_labor.rda
#' ---
#'
#' To reduce the size, only variables that are used are retained.
suppressPackageStartupMessages({
  library("tidyverse")
  library("haven")
})

child_labor <- unz(here::here("data-raw", "downloads", "AA_small.dta_.zip"),
                   "AA_small.dta") %>%
  read_dta() %>%
  mutate_if(haven::is.labelled, haven::as_factor) %>%
  map_dfc(~ rlang::set_attrs(.x, NULL)) %>%
  select(yob, year, sob, indEduc, lnwkwage, cl7, cl8, cl9) %>%
  mutate_at(vars(cl7, cl8, cl9), funs(as.logical)) %>%
  mutate_at(vars(yob, year, sob), funs(as.integer))

devtools::use_data(child_labor, overwrite = TRUE)
