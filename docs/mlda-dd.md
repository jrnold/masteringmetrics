
---
output: html_document
editor_options: 
  chunk_output_type: console
---
# MLDA Difference-in-Difference

Derived from [analysis.do](http://masteringmetrics.com/wp-content/uploads/2015/01/analysis.do).
This program generates Tables 5.2 and 5.3 in Mastering 'Metrics.

Load necessary libraries.

```r
library("tidyverse")
library("haven")
library("rlang")
#> 
#> Attaching package: 'rlang'
#> The following objects are masked from 'package:purrr':
#> 
#>     %@%, %||%, as_function, flatten, flatten_chr, flatten_dbl,
#>     flatten_int, flatten_lgl, invoke, list_along, modify, prepend,
#>     rep_along, splice
library("broom")
```


```r
deaths_file <- here::here("data", "deaths.dta")
```

```r
deaths <- read_dta(deaths_file) %>%
  mutate_if(is.labelled, as_factor) %>%
  mutate(state = as.factor(state))
```


```r
glimpse(deaths)
#> Observations: 24,786
#> Variables: 15
#> $ year         <dbl> 1970, 1971, 1972, 1973, 1974, 1975, 1976, 1977, 1...
#> $ state        <fct> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1...
#> $ legal1820    <dbl> 0.000, 0.000, 0.000, 0.000, 0.000, 0.294, 0.665, ...
#> $ dtype        <fct> all, all, all, all, all, all, all, all, all, all,...
#> $ agegr        <fct> 15-17 yrs, 15-17 yrs, 15-17 yrs, 15-17 yrs, 15-17...
#> $ count        <dbl> 224, 241, 270, 258, 224, 207, 231, 219, 234, 176,...
#> $ pop          <dbl> 213574, 220026, 224877, 227256, 229025, 229739, 2...
#> $ age          <dbl> 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 1...
#> $ legal        <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
#> $ beertaxa     <dbl> 1.374, 1.316, 1.275, 1.200, 1.081, 0.991, 0.937, ...
#> $ beerpercap   <dbl> 0.60, 0.66, 0.74, 0.79, 0.83, 0.88, 0.89, 0.99, 0...
#> $ winepercap   <dbl> 0.09, 0.09, 0.09, 0.10, 0.16, 0.16, 0.15, 0.13, 0...
#> $ spiritpercap <dbl> 0.70, 0.76, 0.78, 0.79, 0.81, 0.85, 0.86, 0.84, 0...
#> $ totpercap    <dbl> 1.38, 1.52, 1.61, 1.69, 1.80, 1.88, 1.89, 1.96, 1...
#> $ mrate        <dbl> 104.9, 109.5, 120.1, 113.5, 97.8, 90.1, 100.1, 95...
```



## Table 5.2

Regression DD Estimates of MLDA-Induced Deaths among 18-20 Year Olds, from 1970-1983


```r
dtypes <- c("all", "MVA", "suicide", "homicide")
```



```r
run_reg <- function(i) {
  data <- filter(deaths, year <= 1983, agegr == "18-20 yrs", dtype == i)
  mods <- list(
    "No trends, no weights" = 
      lm(mrate ~ legal + state + year, data = mutate(data, year = factor(year))),
    "Time trends, no weights" = 
      lm(mrate ~ legal + state * year, data = data),
    "No trends, weights" =
      lm(mrate ~ legal + state + year, data = mutate(data, year = factor(year)),
         weights = data$pop),
    "Time trends, weights" = 
      lm(mrate ~ legal + state * year, data = data, weights = data$pop)
  )
  map_df(mods, tidy) %>%
    filter(term == "legal") %>%
    select(estimate, std.error) %>%
    mutate(response = i,
           model = names(mods))
}
                 
```

**TODO: need to add clustering by state**


```r
mlda_dd <- map_df(dtypes, run_reg)
```


## Table 5.3

Regression DD Estimates of MLDA-Induced Deaths among 18-20 Year Olds, from 1970-1983, controlling for Beer Taxes


```r
run_reg <- function(i) {
  data <- filter(deaths, year <= 1983, agegr == "18-20 yrs", dtype == i)

  mods <- list(
    "No time trends" = 
      lm(mrate ~ legal + beertax + state + year, data = mutate(data, year = factor(year))),
    "Time trends" = 
      lm(mrate ~ legal + beertax + state * year, data = data),
  )
  map_df(mods, tidy) %>%
    filter(term == "legal") %>%
    select(estimate, std.error) %>%
    mutate(response = i,
           model = names(mods))
}
                 
```


