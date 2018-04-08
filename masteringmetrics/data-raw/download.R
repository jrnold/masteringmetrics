library("httr")
library("here")
library("glue")
library("tidyverse")

OUTDIR <- here::here("data-raw", "downloads")

# nolint start
URLS <- c(
  "Data.zip" = "http://masteringmetrics.com/wp-content/uploads/2015/01/Data.zip",
  "NHIS2009_hicompare.do" = "http://masteringmetrics.com/wp-content/uploads/2015/01/NHIS2009_hicompare.do",
  "Data1.zip" = "http://masteringmetrics.com/wp-content/uploads/2015/01/Data1.zip",
  "Code.zip" = "http://masteringmetrics.com/wp-content/uploads/2015/01/Code.zip",
  "mdve.dta" = "http://masteringmetrics.com/wp-content/uploads/2015/02/mdve.dta",
  "AEJfigs.dta" = "http://masteringmetrics.com/wp-content/uploads/2015/01/AEJfigs.dta",
  "banks.csv" = "http://masteringmetrics.com/wp-content/uploads/2015/02/banks.csv",
  "deaths.dta" = "http://masteringmetrics.com/wp-content/uploads/2015/01/deaths.dta",
  "pubtwins.dta" = "https://dataspace.princeton.edu/jspui/bitstream/88435/dsp01rv042t084/4/pubtwins.dta",
  "AA_small.dta_.zip" = "http://masteringmetrics.com/wp-content/uploads/2015/02/AA_small.dta_.zip",
  "ak91.dta" = "http://masteringmetrics.com/wp-content/uploads/2015/02/ak91.dta",
  "clark_martorell_cellmeans.dta" = "http://masteringmetrics.com/wp-content/uploads/2015/02/clark_martorell_cellmeans.dta"
)
# nolint end

dir.create(OUTDIR, showWarnings = FALSE)

download_file <- function(url, i) {
  print(url)
  print(i)
  if (i != "") {
    path <- file.path(OUTDIR, i)  # nolint
  } else {
    path <- file.path(OUTDIR, basename(url))  # nolint
  }
  if (!file.exists(path)) {
    cat(glue("Saving {url} to {path}."), "\n")  # nolint
    dir.create(dirname(path), showWarnings = FALSE, recursive = TRUE)
    GET(url, write_disk(path))  # nolint
  } else {
    cat(glue("{path} exists already."), "\n")  # nolint
  }
}

walk2(URLS, names(URLS), download_file)
