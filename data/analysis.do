* Filename: analysis.do
* Description: This program generates Tables 5.2 and 5.3 in Mastering 'Metrics.
* Modified lightly by Jon Petkun, January 20, 2015

set more off

clear all
* Set directory to location of data
cd ""
use "deaths.dta"

* construct table 5.2 in 'Metrics
* Regression DD Estimates of MLDA-Induced Deaths among 18-20 Year Olds, from 1970-1983

qui xi: reg mrate legal
outreg2 beertax using "../Output/table52.xls", replace bdec(2) sdec(2) excel noaster

* death cause: 1=all, 2=MVA, 3=suicide, 6=internal
foreach i in 1 2 3 6{

* no trends, no weights
qui xi: reg mrate legal i.state i.year if year <= 1983 & agegr == 2 & dtype == `i', cluster(state)
outreg2 legal using "../Output/table52.xls", append bdec(2) sdec(2) excel noaster cttop("`i'") cttop(" no tr, no w")

* time trends, no weights
qui xi: reg mrate legal i.state*year i.year if year <= 1983 & agegr == 2 & dtype == `i', cluster(state)
outreg2 legal using "../Output/table52.xls", append bdec(2) sdec(2) excel noaster cttop("`i'") cttop(" tr, no w")

* no trends, weights
qui xi: reg mrate legal i.state i.year if year <= 1983 & agegr == 2 & dtype == `i' [aw=pop], cluster(state)
outreg2 legal using "../Output/table52.xls", append bdec(2) sdec(2) excel noaster cttop("`i'") cttop(" no tr, w")

* time trends, weights
qui xi: reg mrate legal i.state*year i.year if year <= 1983 & agegr == 2 & dtype == `i' [aw=pop], cluster(state)
outreg2 legal using "../Output/table52.xls", append bdec(2) sdec(2) excel noaster cttop("`i'") cttop(" tr, w")
}
// */


* Table 5.3.
* Regression DD Estimates of MLDA-Induced Deaths among 18-20 Year Olds, from 1970-1983, controlling for Beer Taxes

xi: reg mrate legal 
outreg2  beertax using "../Output/table53.xls", replace bdec(2) sdec(2) excel noaster cttop("`i'")

* no time trends
foreach i in 1 2 3 6 {
	qui xi: reg mrate legal beertax i.state i.year if year <= 1983 & agegr == 2 & dtype == `i', cluster(state)
	outreg2 legal beertax using "../Output/table53.xls", append bdec(2) sdec(2) excel noaster cttop("`i'") cttop("no t")
}

* with time trends
foreach i in 1 2 3 6 {
	qui xi: reg mrate legal beertax i.state*year i.year if year <= 1983 & agegr == 2 & dtype == `i', cluster(state)
	outreg2 legal beertax using "../Output/table53.xls", append bdec(2) sdec(2) excel noaster cttop("`i'") cttop("t")
}

