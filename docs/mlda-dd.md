
---
output: html_document
editor_options: 
  chunk_output_type: console
---

# MLDA Difference-in-Difference

Difference-in-difference estimates of the effect of the minimum legal drinking age (MLDA) on mortality [@DuMouchelWilliamsZador1987;@NorbergBierutGrucza2009].
This replicates the analyses in Tables 5.2 and 5.3 in *Mastering 'Metrics*.

Load necessary libraries.

```r
library("tidyverse")
library("haven")
library("rlang")
library("broom")
#> Warning: package 'broom' was built under R version 3.4.4
library("clubSandwich")
#> Warning: package 'clubSandwich' was built under R version 3.4.4
```


```r
data("deaths", package = "masteringmetrics")
```
In these regressions, we will use both indicator variables for year as well as a trend, so make a factor version of the `year` variable.

```r
deaths <- mutate(deaths, year_fct = factor(year))
```


## Table 5.2

Regression DD Estimates of MLDA-Induced Deaths among 18-20 year-olds, from 1970-1983


```r
dtypes <- c("all" = "All deaths", 
            "MVA" = "Motor vehicle accidents",
            "suicide" = "Suicide", 
            "internal" = "All internal causes")
```

Estimate the DD for MLDA for all causes of death in 18-20 year olds. 
Run the regression with `lm` and calculatate the cluster-robust standard errors
using `sandwich::vcovCL`.
Subset the data.

```r
data <- filter(deaths, year <= 1983, agegr == "18-20 yrs", dtype == "all")
```
Run the OLS model.

```r
mod <- lm(mrate ~ 0 + legal + state + year_fct, 
          data = data)
```
Calculate cluster robuset coefficients.
These are calculcated using a different method than Stata's default, and thus will be slightly different than those reported in the book.

```r
vcov <- vcovCR(mod, cluster = data[["state"]],
               type = "CR2")
coef_test(mod, vcov = vcov) %>%
  rownames_to_column(var = "term") %>%
  as_tibble() %>%
  select(term, estimate = beta, std.error = SE) %>%
  filter(term == "legal") %>%
  knitr::kable(digits = 2)
```



term     estimate   std.error
------  ---------  ----------
legal        10.8        4.48

Function to calculate sclustered standard errors and return a tidy data frame of the coefficients and standard errors.

```r
cluster_se <- function(mod, cluster, type = "CR2") {
  vcov <- vcovCR(mod, cluster = cluster, type = "CR2")
  coef_test(mod, vcov = vcov) %>%
    rownames_to_column(var = "term") %>%
    as_tibble() %>%
    select(term, estimate = beta, std.error = SE)
}
```



```r
run_mlda_dd <- function(i) {
  data <- filter(deaths, year <= 1983, agegr == "18-20 yrs", dtype == i) # nolint
  mods <- tribble(
    ~ name, ~ model,
    "No trends, no weights", lm(mrate ~ 0 + legal + state + year_fct, data = data),
    "Time trends, no weights",
      lm(mrate ~ 0 + legal + year_fct + state + state:year, data = data),
    "No trends, weights",
      lm(mrate ~ 0 + legal + year_fct + state, data = data, weights = pop),
    # "Time trends, weights",
    #   lm(mrate ~ 0 + legal + year_fct + state + state:year, data = data, weights = pop)
  ) %>%
    mutate(coefs = map(model, ~ cluster_se(.x, cluster = data[["state"]], type = "CR2"))) %>%
    unnest(coefs) %>%
    filter(term == "legal") %>%
    mutate(response = i) %>%
    select(name, response, estimate, std.error)
}
```


```r
mlda_dd <- map_df(names(dtypes), run_mlda_dd)
```


```r
mlda_dd %>%
  knitr::kable(digits = 2)
```



name                      response    estimate   std.error
------------------------  ---------  ---------  ----------
No trends, no weights     all            10.80        4.48
Time trends, no weights   all             8.47        4.74
No trends, weights        all            12.41        4.78
No trends, no weights     MVA             7.59        2.43
Time trends, no weights   MVA             6.64        2.47
No trends, weights        MVA             7.50        2.30
No trends, no weights     suicide         0.59        0.57
Time trends, no weights   suicide         0.47        0.74
No trends, weights        suicide         1.49        0.92
No trends, no weights     internal        1.33        1.53
Time trends, no weights   internal        0.08        1.80
No trends, weights        internal        1.89        1.83


## Table 5.3

Regression DD Estimates of MLDA-Induced Deaths among 18-20 year-olds, from 1970-1983, controlling for Beer Taxes.
This is the analysis presented in @AngristPischke2014 Table 5.3.


```r
run_beertax <- function(i) {
  data <- filter(deaths, year <= 1983, agegr == "18-20 yrs", 
                 dtype == i, !is.na(beertaxa))
  out <- tribble(
    ~ name, ~ model,
    "No time trends",
      lm(mrate ~ 0 + legal + beertaxa + year_fct + state, data = data),
    "Time trends",
      lm(mrate ~ 0 + legal + beertaxa + year_fct + state + state:year, data = data)
  ) %>%
    # calc culstered standard errors
    mutate(coefs = map(model, ~ cluster_se(.x, data[["state"]]))) %>%
    unnest(coefs) %>%
    filter(term %in% c("legal", "beertaxa")) %>%
    mutate(response = i) %>%    
    select(response, name, term, estimate, std.error)
}
```


```r
beertax <- map_df(names(dtypes), run_beertax)
```


```r
beertax %>%
  knitr::kable(digits = 2)
```



response   name             term        estimate   std.error
---------  ---------------  ---------  ---------  ----------
all        No time trends   legal          10.98        4.60
all        No time trends   beertaxa        1.51        9.02
all        Time trends      legal          10.03        4.57
all        Time trends      beertaxa       -5.52       30.40
MVA        No time trends   legal           7.59        2.51
MVA        No time trends   beertaxa        3.82        5.27
MVA        Time trends      legal           6.89        2.47
MVA        Time trends      beertaxa       26.88       18.76
suicide    No time trends   legal           0.45        0.58
suicide    No time trends   beertaxa       -3.05        1.61
suicide    Time trends      legal           0.38        0.72
suicide    Time trends      beertaxa      -12.13        8.28
internal   No time trends   legal           1.46        1.56
internal   No time trends   beertaxa       -1.36        3.02
internal   Time trends      legal           0.88        1.68
internal   Time trends      beertaxa      -10.31       10.90

*Note:* I had trouble getting `sandwich::vcovCL` to estimate clustered standard errors for this regression.

## References

- <http://masteringmetrics.com/wp-content/uploads/2015/01/analysis.do>
- <http://masteringmetrics.com/wp-content/uploads/2015/01/ReadMe_MLDA_DD.txt>

