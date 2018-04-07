#!/usr/bin/env Rscript

files <- dir(here::here(), pattern = "\\.(Rmd|md)")
words <- readLines(here::here("WORDLIST"))
spelling::spell_check_files(files, ignore = words)
