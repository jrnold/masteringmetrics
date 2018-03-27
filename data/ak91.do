*** Mastering 'Metrics
*** Tables 6.4 and 6.5; Figures 6.1 and 6.2
*** AK 91 regressions 
*** Modified by Jon Petkun (jbpetkun@mit.edu) on Feb 10, 2015

version 12
clear all

// set to directory where the data file is located
cd ""

use ak91
tab qob, gen(q)

gen age = ((79 - yob)*4 + 5 - qob)/4
gen age2 = age^2

/* Table 6.4. IV recipe for returns to schooling using a single QOB instrument */
matrix T = J(6,3,.)
reg lnw q4, robust
mat T[1,1] = _b[_cons]
mat T[1,2] = (_b[_cons] + _b[q4])
mat T[1,3] = _b[q4]
mat T[2,3] = _se[q4]
reg s q4, robust
mat T[3,1] = _b[_cons]
mat T[3,2] = (_b[_cons] + _b[q4])
mat T[3,3] = _b[q4]
mat T[4,3] = _se[q4]
ivregress 2sls lnw (s = q4), robust
mat T[5,3] = _b[s]
mat T[6,3] = _se[s]
matrix list T
mat2txt, matrix(T) saving("../Output/Table64.xls") title(Table 6.4) replace

/* Table 6.5. Regression Estimates of Returns to Schooling using Quarter of Birth Instruments */

/* Wald estimate */

sort q4
by q4: sum lnw s

reg lnw q4, robust
reg s q4, robust

* AK91 column 1
reg lnw s, robust
outreg2 s using "../Output/Table65.xls", replace bdec(3) sdec(3) noaster word

* first stage
reg s q4
testparm q4
local F = r(F)
* AK91 column 2
ivregress 2sls lnw (s = q4),  robust
outreg2 s using "../Output/Table65.xls", append bdec(3) sdec(3) noaster word addstat(F-stat, `F')

* AK91 column 3
reg lnw s i.yob, robust
outreg2 s using "../Output/Table65.xls", append bdec(3) sdec(3) noaster word

* first stage
reg s q4 i.yob
testparm q4
local F = r(F)
* AK91 column 4
ivregress 2sls lnw (s = q4) i.yob, robust
outreg2 s using "../Output/Table65.xls", append bdec(3) sdec(3) noaster word addstat(F-stat, `F')

* first stage
reg s q2 q3 q4 i.yob
testparm q2 q3 q4
local F = r(F)
* AK91 column 5
ivregress 2sls lnw (s = i.qob) i.yob, robust
outreg2 s using "../Output/Table65.xls", append bdec(3) sdec(3) noaster word addstat(F-stat, `F')


* Figures 6.1 and 6.2
collapse s lnw q*, by(age)

gen yob = 80-age

label var s "Years of education"
label var lnw "Log Weekly Earnings"
label var age "Age"
label var yob "Year of Birth"

twoway (line s yob) (scatter s yob if q4 == 1) (scatter s yob if q1 == 1, msym(Oh)), legend(order (3 "Quarter 1" 2 "Quarter 4"))
graph export "../Output/fig61_first.png", replace
twoway (line lnw yob) (scatter lnw yob if q4 == 1) (scatter lnw yob if q1 == 1, msym(Oh)), legend(order (3 "Quarter 1" 2 "Quarter 4"))
graph export "../Output/fig62_reduced.png", replace

