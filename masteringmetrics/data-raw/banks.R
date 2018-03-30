#' ---
#' title: Create banks dataset
#' ---
suppressPackageStartupMessages({
  library("tidyverse")
})


col_types <- cols(
  date = col_integer(),
  weekday = col_character(),
  day = col_integer(),
  month = col_integer(),
  year = col_integer(),
  bib6 = col_integer(),
  bio6 = col_integer(),
  bib8 = col_integer(),
  bio8 = col_integer()
)

banks <- read_csv(here::here("data-raw", "downloads", "banks.csv"),
                  na = "", col_types = col_types) %>%
  mutate(date = lubridate::make_date(year, month, day)) %>%
  select(-day, -month, -year, -weekday)

devtools::use_data(banks, overwrite = TRUE)
