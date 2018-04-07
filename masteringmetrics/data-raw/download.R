library("httr")
library("here")
library("glue")
library("tidyverse")

OUTDIR <- here::here("data-raw", "downloads")

# nolint start
URLS <- c(
  "Data.zip" = "http://masteringmetrics.com/wp-content/uploads/2015/01/Data.zip",
  "ReadMe_NHIS.txt" = "http://masteringmetrics.com/wp-content/uploads/2014/12/ReadMe_NHIS.txt",
  "NHIS2009_hicompare.do" = "http://masteringmetrics.com/wp-content/uploads/2015/01/NHIS2009_hicompare.do",
  "ReadMe_RAND.txt" = "http://masteringmetrics.com/wp-content/uploads/2015/01/ReadMe_RAND.txt",
  "Data1.zip" = "http://masteringmetrics.com/wp-content/uploads/2015/01/Data1.zip",
  "Code.zip" = "http://masteringmetrics.com/wp-content/uploads/2015/01/Code.zip",
  "ReadMe_MDVE.txt" = "http://masteringmetrics.com/wp-content/uploads/2015/02/ReadMe_MDVE.txt",
  "mdve.dta" = "http://masteringmetrics.com/wp-content/uploads/2015/02/mdve.dta",
  "MDVE_Table33.do" = "http://masteringmetrics.com/wp-content/uploads/2015/02/MDVE_Table33.do",
  "ReadMe_MLDA.txt" = "http://masteringmetrics.com/wp-content/uploads/2015/01/ReadMe_MLDA.txt",
  "AEJfigs.dta" = "http://masteringmetrics.com/wp-content/uploads/2015/01/AEJfigs.dta",
  "master_cd_rd.do" = "http://masteringmetrics.com/wp-content/uploads/2015/01/master_cd_rd.do",
  "ReadMe_BankFailures.txt" = "http://masteringmetrics.com/wp-content/uploads/2015/02/ReadMe_BankFailures.txt",
  "banks.csv" = "http://masteringmetrics.com/wp-content/uploads/2015/02/banks.csv",
  "master_banks.do" = "http://masteringmetrics.com/wp-content/uploads/2015/02/master_banks.do",
  "ReadMe_MLDA_DD.txt" = "http://masteringmetrics.com/wp-content/uploads/2015/01/ReadMe_MLDA_DD.txt",
  "deaths.dta" = "http://masteringmetrics.com/wp-content/uploads/2015/01/deaths.dta",
  "analysis.do" = "http://masteringmetrics.com/wp-content/uploads/2015/01/analysis.do",
  "ReadMe_Twinsburg.txt" = "http://masteringmetrics.com/wp-content/uploads/2015/02/ReadMe_Twinsburg.txt",
  "coefint.ado" = "https://dataspace.princeton.edu/jspui/bitstream/88435/dsp01rv042t084/2/coefint.ado",
  "pubtwins.do" = "https://dataspace.princeton.edu/jspui/bitstream/88435/dsp01rv042t084/3/pubtwins.do",
  "pubtwins.dta" = "https://dataspace.princeton.edu/jspui/bitstream/88435/dsp01rv042t084/4/pubtwins.dta",
  "pubtwins.log" = "https://dataspace.princeton.edu/jspui/bitstream/88435/dsp01rv042t084/5/pubtwins.log",
  "twinsreg.do" = "https://dataspace.princeton.edu/jspui/bitstream/88435/dsp01rv042t084/6/twinsreg.do",
  "twinsreg.log" = "https://dataspace.princeton.edu/jspui/bitstream/88435/dsp01rv042t084/7/twinsreg.log",
  "ReadMe_ChildLaborLaws.txt" = "http://masteringmetrics.com/wp-content/uploads/2015/02/ReadMe_ChildLaborLaws.txt",
  "AA_small.dta_.zip" = "http://masteringmetrics.com/wp-content/uploads/2015/02/AA_small.dta_.zip",
  "AA_regs.do" = "http://masteringmetrics.com/wp-content/uploads/2015/02/AA_regs.do",
  "ReadMe_QOB.txt" = "http://masteringmetrics.com/wp-content/uploads/2015/02/ReadMe_QOB.txt",
  "ak91.dta" = "http://masteringmetrics.com/wp-content/uploads/2015/02/ak91.dta",
  "ak91.do" = "http://masteringmetrics.com/wp-content/uploads/2015/02/ak91.do",
  "ReadMe_Sheepskin.txt" = "http://masteringmetrics.com/wp-content/uploads/2015/02/ReadMe_Sheepskin.txt",
  "clark_martorell_cellmeans.dta" = "http://masteringmetrics.com/wp-content/uploads/2015/02/clark_martorell_cellmeans.dta",
  "cm_graphs.do" = "http://masteringmetrics.com/wp-content/uploads/2015/02/cm_graphs.do"
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
