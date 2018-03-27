*** Metrics
*** Table 6.3
*** Metrics returns to schooling regressions for AA2000 data

cap log close
log using AA_reg, replace text
set more 1
clear

// set to directory where data (AA_small.dta) is located
cd ""

use AA_small

/* first stages and reduced forms */

regress indEduc i.year i.yob i.sob cl7 cl8 cl9 [pw=weight], cluster(sob)
outreg2 cl* using "../Output/first.xls", replace bdec(3) sdec(3) noaster word
testparm cl*

regress indEduc i.year i.yob i.sob i.sob#c.yob cl7 cl8 cl9 [pw=weight], cluster(sob)
outreg2 cl* using "../Output/first.xls", append bdec(3) sdec(3) noaster word
testparm cl*

regress lnwkwage i.year i.yob i.sob cl7 cl8 cl9 [pw=weight], cluster(sob)
outreg2 cl* using "../Output/first.xls", append bdec(3) sdec(3) noaster word
testparm cl*

regress lnwkwage i.year i.yob i.sob i.sob#c.yob cl7 cl8 cl9 [pw=weight], cluster(sob)
outreg2 cl* using "../Output/first.xls", append bdec(3) sdec(3) noaster word
testparm cl*


/* OLS and IV returns */

regress lnwkwage indEduc i.year i.yob i.sob [pw=weight], cluster(sob)
outreg2 indEduc using "../Output/second.xls", replace bdec(3) sdec(3) noaster word

regress lnwkwage indEduc i.year i.yob i.sob i.sob#c.yob [pw=weight], cluster(sob)
outreg2 indEduc using "../Output/second.xls", append bdec(3) sdec(3) noaster word

ivregress 2sls lnwkwage (indEduc = cl7 cl8 cl9) i.year i.yob i.sob [pw=weight], cluster(sob)
outreg2 indEduc using "../Output/second.xls", append bdec(3) sdec(3) noaster word

ivregress 2sls lnwkwage (indEduc = cl7 cl8 cl9) i.year i.yob i.sob i.sob#c.yob [pw=weight], cluster(sob)
outreg2 indEduc using "../Output/second.xls", append bdec(3) sdec(3) noaster word

set more 0
log close
