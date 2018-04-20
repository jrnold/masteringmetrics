# R Code for Mastering 'Metrics (Angrist and Pischke)

This repository R code and text for [R Code for Mastering 'Metrics](https://jrnold.github.io/masteringmetrics/), which contains the R code to reproduce the analyses in *Mastering 'Metrics* by Joshua D. Angrist and Jörn-Steffen Pischke.


The site is built using the [bookdown](https://bookdown.org/yihui/bookdown/) package.

## Build

To render the book, run the following in R,
``` r
render_book("index.Rmd")
```

To lint R code run
``` console
Rscript _lint.R
```

To check spelling run
``` console
Rcript _spelling.R
```

To lint markdown, install remark and various plugins for it.
``` console
$ npm install remark-preset-lint-recommended remark-preset-lint-consistent remark-preset-lint-markdown-style-guide remark-frontmatter
```
``` console
$ remark *.Rmd
```
