R ?= RScript

DATASETS = NHIS2009 rand_person_spend rand_sample mdve \
	mlda banks deaths pubtwins sheepskin child_labor ak91

foo = $(DATASETS:%=data/%.rda)

all: download data document

data: $(DATASETS:%=data/%.rda)

.PHONY: check
check:
	$(R) -e 'devtools::check()'

.PHONY: document
document:
	$(R) -e 'devtools::document()'

.PHONY: download
download:
	$(R) data-raw/download.R

data/%.rda: data-raw/%.R
	$(R) $<
