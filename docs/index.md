
---
knit: "bookdown::render_book"
title: "R Code for Mastering 'Metrics"
author: ["Jeffrey B. Arnold"]
description: >
  R code to reproduce analyses in Mastering Metrics 
  by Angrist and Pischke.
site: bookdown::bookdown_site
bibliography: ["masteringmetrics.bib"]
github-repo: "jrnold/r4ds-exercise-solutions"
url: 'http\://jrnold.github.io/r4ds-exercise-solutions'
twitter-handle: jrnld
documentclass: book
editor_options: 
  chunk_output_type: console
---

# Welcome {-}

This work contains R code to reproduce many of the analyses in *Mastering 'Metrics* by Joshua D. Angrist and Jörn-Steffen Pischke [@AngristPischke2014].
This work provides R translations of the replication code available at [masteringmetrics.com](http://masteringmetrics.com/resources/).

## Install {-}

To install all packages used in the examples in this work
and the datasets from *Mastering 'Metrics* run

```r
devtools::install_github("jrnold/masteringmetrics", subdir = "masteringmetrics")
```

## License {-}

The text of this work is licensed under the [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/).
The R Code in this work is licensed under the [MIT License](https://opensource.org/licenses/MIT).

## Colonophon {-}

The book is powered by <https://bookdown.org> which makes it easy to turn R markdown files into HTML, PDF, and EPUB.

This book was built with:


```r
devtools::session_info(c("tidyverse"))
#> Session info -------------------------------------------------------------
#>  setting  value                       
#>  version  R version 3.4.4 (2018-03-15)
#>  system   x86_64, darwin15.6.0        
#>  ui       X11                         
#>  language (EN)                        
#>  collate  en_US.UTF-8                 
#>  tz       America/Los_Angeles         
#>  date     2018-03-31
#> Packages -----------------------------------------------------------------
#>  package      * version    date       source                          
#>  assertthat     0.2.0      2017-04-11 CRAN (R 3.4.0)                  
#>  backports      1.1.2      2017-12-13 CRAN (R 3.4.3)                  
#>  base64enc      0.1-3      2015-07-28 CRAN (R 3.4.0)                  
#>  BH             1.66.0-1   2018-02-13 CRAN (R 3.4.3)                  
#>  bindr          0.1.1      2018-03-13 CRAN (R 3.4.4)                  
#>  bindrcpp       0.2        2017-06-17 CRAN (R 3.4.0)                  
#>  broom          0.4.4      2018-03-29 cran (@0.4.4)                   
#>  callr          2.0.2      2018-02-11 CRAN (R 3.4.3)                  
#>  cellranger     1.1.0      2016-07-27 CRAN (R 3.4.0)                  
#>  cli            1.0.0      2017-11-05 cran (@1.0.0)                   
#>  colorspace     1.3-2      2016-12-14 CRAN (R 3.4.0)                  
#>  compiler       3.4.4      2018-03-15 local                           
#>  crayon         1.3.4      2017-09-16 CRAN (R 3.4.1)                  
#>  curl           3.1        2017-12-12 CRAN (R 3.4.3)                  
#>  DBI            0.8        2018-03-02 CRAN (R 3.4.3)                  
#>  dbplyr         1.2.1      2018-02-19 CRAN (R 3.4.3)                  
#>  debugme        1.1.0      2017-10-22 CRAN (R 3.4.2)                  
#>  dichromat      2.0-0      2013-01-24 CRAN (R 3.4.0)                  
#>  digest         0.6.15     2018-01-28 CRAN (R 3.4.3)                  
#>  dplyr          0.7.4      2017-09-28 CRAN (R 3.4.2)                  
#>  evaluate       0.10.1     2017-06-24 CRAN (R 3.4.1)                  
#>  forcats        0.3.0      2018-02-19 CRAN (R 3.4.3)                  
#>  foreign        0.8-69     2017-06-22 CRAN (R 3.4.4)                  
#>  ggplot2        2.2.1      2016-12-30 CRAN (R 3.4.0)                  
#>  glue           1.2.0      2017-10-29 CRAN (R 3.4.2)                  
#>  graphics     * 3.4.4      2018-03-15 local                           
#>  grDevices    * 3.4.4      2018-03-15 local                           
#>  grid           3.4.4      2018-03-15 local                           
#>  gtable         0.2.0      2016-02-26 CRAN (R 3.4.0)                  
#>  haven          1.1.1.9000 2018-03-31 Github (tidyverse/haven@746eb3e)
#>  highr          0.6        2016-05-09 CRAN (R 3.4.0)                  
#>  hms            0.4.2      2018-03-10 CRAN (R 3.4.4)                  
#>  htmltools      0.3.6      2017-04-28 CRAN (R 3.4.0)                  
#>  httr           1.3.1      2017-08-20 CRAN (R 3.4.1)                  
#>  jsonlite       1.5        2017-06-01 CRAN (R 3.4.0)                  
#>  knitr          1.20       2018-02-20 CRAN (R 3.4.3)                  
#>  labeling       0.3        2014-08-23 CRAN (R 3.4.0)                  
#>  lattice        0.20-35    2017-03-25 CRAN (R 3.4.4)                  
#>  lazyeval       0.2.1      2017-10-29 CRAN (R 3.4.2)                  
#>  lubridate      1.7.3      2018-02-27 CRAN (R 3.4.3)                  
#>  magrittr       1.5        2014-11-22 CRAN (R 3.4.0)                  
#>  markdown       0.8        2017-04-20 CRAN (R 3.4.0)                  
#>  MASS           7.3-49     2018-02-23 CRAN (R 3.4.3)                  
#>  methods        3.4.4      2018-03-15 local                           
#>  mime           0.5        2016-07-07 CRAN (R 3.4.0)                  
#>  mnormt         1.5-5      2016-10-15 CRAN (R 3.4.0)                  
#>  modelr         0.1.1      2017-07-24 CRAN (R 3.4.1)                  
#>  munsell        0.4.3      2016-02-13 CRAN (R 3.4.0)                  
#>  nlme           3.1-131.1  2018-02-16 CRAN (R 3.4.4)                  
#>  openssl        1.0.1      2018-03-03 CRAN (R 3.4.3)                  
#>  parallel       3.4.4      2018-03-15 local                           
#>  pillar         1.2.1      2018-02-27 CRAN (R 3.4.3)                  
#>  pkgconfig      2.0.1      2017-03-21 CRAN (R 3.4.0)                  
#>  plogr          0.2.0      2018-03-25 CRAN (R 3.4.4)                  
#>  plyr           1.8.4      2016-06-08 CRAN (R 3.4.0)                  
#>  praise         1.0.0      2015-08-11 CRAN (R 3.4.0)                  
#>  psych          1.7.8      2017-09-09 CRAN (R 3.4.1)                  
#>  purrr          0.2.4      2017-10-18 cran (@0.2.4)                   
#>  R6             2.2.2      2017-06-17 CRAN (R 3.4.0)                  
#>  RColorBrewer   1.1-2      2014-12-07 CRAN (R 3.4.0)                  
#>  Rcpp           0.12.16    2018-03-13 cran (@0.12.16)                 
#>  readr          1.1.1      2017-05-16 CRAN (R 3.4.0)                  
#>  readxl         1.0.0      2017-04-18 CRAN (R 3.4.0)                  
#>  rematch        1.0.1      2016-04-21 CRAN (R 3.4.0)                  
#>  reprex         0.1.2      2018-01-26 CRAN (R 3.4.3)                  
#>  reshape2       1.4.3      2017-12-11 CRAN (R 3.4.3)                  
#>  rlang          0.2.0      2018-02-20 CRAN (R 3.4.3)                  
#>  rmarkdown      1.9        2018-03-01 CRAN (R 3.4.3)                  
#>  rprojroot      1.3-2      2018-01-03 CRAN (R 3.4.3)                  
#>  rstudioapi     0.7        2017-09-07 CRAN (R 3.4.1)                  
#>  rvest          0.3.2      2016-06-17 CRAN (R 3.4.0)                  
#>  scales         0.5.0      2017-08-24 CRAN (R 3.4.1)                  
#>  selectr        0.3-2      2018-03-05 CRAN (R 3.4.4)                  
#>  stats        * 3.4.4      2018-03-15 local                           
#>  stringi        1.1.7      2018-03-12 CRAN (R 3.4.4)                  
#>  stringr        1.3.0      2018-02-19 CRAN (R 3.4.3)                  
#>  testthat       2.0.0      2017-12-13 CRAN (R 3.4.3)                  
#>  tibble         1.4.2      2018-01-22 CRAN (R 3.4.3)                  
#>  tidyr          0.8.0      2018-01-29 CRAN (R 3.4.3)                  
#>  tidyselect     0.2.4      2018-02-26 CRAN (R 3.4.3)                  
#>  tidyverse      1.2.1      2017-11-14 CRAN (R 3.4.2)                  
#>  tools          3.4.4      2018-03-15 local                           
#>  utf8           1.1.3      2018-01-03 CRAN (R 3.4.3)                  
#>  utils        * 3.4.4      2018-03-15 local                           
#>  viridisLite    0.3.0      2018-02-01 CRAN (R 3.4.3)                  
#>  whisker        0.3-2      2013-04-28 CRAN (R 3.4.0)                  
#>  withr          2.1.2      2018-03-15 CRAN (R 3.4.4)                  
#>  xml2           1.2.0      2018-01-24 CRAN (R 3.4.3)                  
#>  yaml           2.1.18     2018-03-08 cran (@2.1.18)
```


