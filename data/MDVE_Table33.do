*** Mastering 'Metrics
*** Generates Table 3.3
*** Minneapolis Domestic Violence Experiment
*** Created by Jon Petkun (jbpetkun@mit.edu) on Feb 12, 2015

version 12
clear all

// set to directory where the data file is located
cd ""

use mdve.dta, clear

* Generate action assignments (i.e. what are police assigned to do)
gen z_arrest=(T_RANDOM == 1)
gen z_advise=(T_RANDOM == 2)
gen z_separate=(T_RANDOM == 3)

* Generate actual outcomes (i.e. what action do the police actually take)
gen d_arrest=(T_FINAL == 1)
gen d_advise=(T_FINAL == 2)
gen d_separate=(T_FINAL == 3)
gen d_other=(T_FINAL == 4)
gen z_coddled=(z_arrest == 0)
gen d_coddled=(d_arrest == 0)
gen assigned = "Arrest" if T_RANDOM == 1
replace assigned = "Advise" if T_RANDOM == 2
replace assigned = "Separate" if T_RANDOM == 3
gen outcome = "Arrest" if T_FINAL == 1
replace outcome = "Advise" if T_FINAL == 2
replace outcome = "Separate" if T_FINAL == 3
replace outcome = "Other" if T_FINAL == 4
gen total = 1

* Drop if actual outcome is "other"
keep if d_other == 0

* Tabulate assignments and outcomes
estpost tabstat d_arrest d_advise d_separate total, by(assigned) listwise ///
	statistics(sum  mean) columns(statistics)
	
* Insert tabulations into matrix	
matrix S = e(sum)
matrix T = J(4,8,.)
mat T[1,2] = S[1,5]
mat T[1,4] = S[1,6]
mat T[1,6] = S[1,7]
mat T[2,2] = S[1,1]
mat T[2,4] = S[1,2]
mat T[2,6] = S[1,3]
mat T[3,2] = S[1,9]
mat T[3,4] = S[1,10]
mat T[3,6] = S[1,11]
mat T[1,8] = T[1,2]+T[1,4]+T[1,6]
mat T[2,8] = T[2,2]+T[2,4]+T[2,6]
mat T[3,8] = T[3,2]+T[3,4]+T[3,6]
mat T[4,2] = T[1,2]+T[2,2]+T[3,2]
mat T[4,4] = T[1,4]+T[2,4]+T[3,4]
mat T[4,6] = T[1,6]+T[2,6]+T[3,6]
mat T[4,8] = T[1,8]+T[2,8]+T[3,8]
* Generate percentage values
forval i = 1/4 {
forval j = 1/3 {
local k = `j'*2
local r = `k' - 1
mat T[`i',`r'] = 100*T[`i',`k']/T[`i',8]
}
mat T[`i',7] = 100*T[`i',8]/T[4,8]
}
* Row and column labels
matrix rownames T = Arrest Advise Separate Total
matrix colnames T = Arrest Arrest Advise Advise Separate Separate Total Total

mat2txt, matrix(T) saving("../Output/Table33.xls") replace
