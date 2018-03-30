#' ---
#' title: RAND Sample
#' ---

rand_sample <-
  unz(here::here("data-raw", "downloads", "Data1.zip"),
      "Data/rand_initial_sample_2.dta") %>%
  read_dta() %>%
  # delete Stata attributes
  map_dfc(~ rlang::set_attrs(.x, NULL))

# The `plantype` variable takes four values,
#
# ------- ------------------
# 1       Free
# 2       Deductible
# 3       Coinsurance
# 4       Catastrophic
# ------- -------------------

#   Create a more interpretable version of plantype, and
# ensure that the free plan does not give 0's to anyone without a plan.

rand_sample <- rand_sample %>%
  filter(!is.na(plantype)) %>%
  # plantype to a factor variable
  mutate(plantype = factor(plantype,
  labels = c("Free", "Deductible",
             "Coinsurance", "Catastrophic"))) %>%
  # reorder so that "Catastrophic is first
  mutate(plantype = fct_relevel(plantype,
          "Catastrophic", "Deductible",
          "Coinsurance", "Free")) %>%
  # indicator variable for any insurance
  mutate(any_ins = plantype != "Catastrophic")

use_data(rand_sample, overwrite = TRUE)