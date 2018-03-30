#' ---
#' title: Create RAND Person Years
#' ---
suppressPackageStartupMessages({
  library("here")
  library("tidyverse")
  library("haven")
})

person_years <-
  unz(here::here("data-raw", "downloads", "Data1.zip"),
      "Data/person_years.dta") %>%
  read_dta() %>%
  map_dfc(~ rlang::set_attrs(.x, NULL))

annual_spend <-
  unz(here::here("data-raw", "downloads", "Data1.zip"),
                 "Data/annual_spend.dta") %>%
  read_dta() %>%
  map_dfc(~ rlang::set_attrs(.x, NULL))

person_spend <- inner_join(person_years, annual_spend,
                           by = c("person", "year"))

#' There are four types of plans in RAND experiment.
#'
#' 1.  Free,
# 2.  Individual Deductible
# 3.  Cost Sharing (25%/50%)
# 4.  Catostrophic (Fam Deductible) (95%/100%)
#
# Create a categorical variable with these categories.

rand_person_spend <-
  mutate(person_spend,
         plantype = case_when(
           plan == 24 ~ "Free",
           plan %in% c(1, 5) ~ "Deductible",
           plan >= 2 & plan <= 4 ~ "Catastrophic",
           plan >= 6 & plan <= 8 ~ "Catastrophic",
           plan >= 9 & plan <= 23 ~ "Cost Sharing"
         )) %>%
  # reorder levels so Catastrophic is first
  mutate(plantype = fct_relevel(plantype,
                                "Catastrophic",
                                "Deductible",
                                "Cost Sharing",
                                "Free"))

devtools::use_data(rand_person_spend, overwrite = TRUE)