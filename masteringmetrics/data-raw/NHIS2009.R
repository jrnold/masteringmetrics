#' ---
#' title: Convert NHIS2009_clean.dta to RData
#' ---
library("haven")
library("tidyverse")

NHIS2009 <-
  read_dta(unz(here::here("data-raw", "downloads", "Data.zip"),
             "Data/NHIS2009_clean.dta")) %>%
  mutate(age = as.numeric(age),
         serial = as.integer(serial),
         fml = as.logical(fml),
         marradult = as.logical(marradult))

devtools::use_data(NHIS2009, overwrite = TRUE)
