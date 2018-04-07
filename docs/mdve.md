
# Minneapolis Domestic Violence Experiment

This replicates Table 3.3 of *Mastering 'Metrics*, which replicates the Minneapolis Domestic Violence Experiment [@ShermanBerk1984,@Angrist2006].

Load necessary packages.

```r
library("tidyverse")
```

Load the MDVE data.

```r
data("mdve", package = "masteringmetrics")
```

Randomized assignments (i.e. what are police assigned to do) are in the `assigned` column.
Actual outcomes (i.e. what action do the police actually take) is in the `outcome` column.
gen outcome = "Arrest" if T_FINAL == 1
replace outcome = "Advise" if T_FINAL == 2
replace outcome = "Separate" if T_FINAL == 3
replace outcome = "Other" if T_FINAL == 4
gen total = 1

```r
mdve <- mutate(mdve,
               assigned = case_when(
      T_RANDOM == 1 ~ "Arrest",
      T_RANDOM == 2 ~ "Advise",
      T_RANDOM == 3 ~ "Separate"
    ),
      outcome = case_when(
        T_FINAL == 1 ~ "Arrest",
        T_FINAL == 2 ~ "Advise",
        T_FINAL == 3 ~ "Separate",
        T_FINAL == 4 ~ "Other"
      ),
      coddled_a = assigned != "Arrest",
      coddled_o = outcome != "Arrest"
    ) %>%
  filter(outcome != "Other")
```

Assigned and delivered treatments in the MDVE:

```r
mdve_summary <-
  mdve %>%
  count(assigned, outcome) %>%
  group_by(assigned) %>%
  mutate(p = n / sum(n))
print(mdve_summary, n = nrow(mdve_summary))
#> # A tibble: 8 x 4
#> # Groups:   assigned [3]
#>   assigned outcome      n      p
#>   <chr>    <chr>    <int>  <dbl>
#> 1 Advise   Advise      84 0.778 
#> 2 Advise   Arrest      19 0.176 
#> 3 Advise   Separate     5 0.0463
#> 4 Arrest   Arrest      91 0.989 
#> 5 Arrest   Separate     1 0.0109
#> 6 Separate Advise       5 0.0439
#> 7 Separate Arrest      26 0.228 
#> 8 Separate Separate    83 0.728
```

Assigned proportions in the MDVE:

```r
mdve_assigned <- mdve %>%
  count(assigned) %>%
  mutate(p = n / sum(n))
mdve_assigned
#> # A tibble: 3 x 3
#>   assigned     n     p
#>   <chr>    <int> <dbl>
#> 1 Advise     108 0.344
#> 2 Arrest      92 0.293
#> 3 Separate   114 0.363
```

Delivered treatments in the MDVE:

```r
mdve_outcome <- mdve %>%
  count(outcome) %>%
  mutate(p = n / sum(n))
mdve_outcome
#> # A tibble: 3 x 3
#>   outcome      n     p
#>   <chr>    <int> <dbl>
#> 1 Advise      89 0.283
#> 2 Arrest     136 0.433
#> 3 Separate    89 0.283
```

Probability of being coddled, given being assigned the coddled treatment:

```r
mdve_coddled <- mdve %>%
  count(coddled_a, coddled_o) %>%
  group_by(coddled_a) %>%
  mutate(p = n / sum(n))
mdve_coddled
#> # A tibble: 4 x 4
#> # Groups:   coddled_a [2]
#>   coddled_a coddled_o     n      p
#>   <lgl>     <lgl>     <int>  <dbl>
#> 1 F         F            91 0.989 
#> 2 F         T             1 0.0109
#> 3 T         F            45 0.203 
#> 4 T         T           177 0.797
```

IV first stage,
$$
E[D_i | Z_i = 1] - E[D_i | Z_i = 0] .
$$

```r
filter(mdve_coddled, coddled_o, coddled_a)$p -
  filter(mdve_coddled, coddled_o, !coddled_a)$p
#> [1] 0.786
```

The response variable is not provided, so the full 2SLS is not estimated here.

## References

-   <http://masteringmetrics.com/wp-content/uploads/2015/02/MDVE_Table33.do>
-   <http://masteringmetrics.com/wp-content/uploads/2015/02/ReadMe_MDVE.txt>

