#!/usr/bin/env Rscript

files <- c(dir(here::here(), pattern = "\\.(Rmd)"),
           here::here("README.md"))
words <- readLines(here::here("WORDLIST"))
spelling::spell_check_files(files, ignore = words)
