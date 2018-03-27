*** Metrics
*** Tables 1.3-1.4
*** goal: master RAND replication do file

clear all
set more off

// set to directory where this do file is located
cd "/NHIS/Data/"

use rand_initial_sample_2.dta, clear

*Ensure dummy variable for free plan does not give "0's" to anyone without a plan
replace plantype_1=. if plantype==.

*Conduct difference in means test for cholesterol levels between free and cost sharing plans
gen famid=substr(fam_identifier,3,.)
destring famid, ignore("A") replace
gen any_ins=(plantype==1|plantype==2|plantype==3)

*replace old table file
reg female plantype_1, noconst
outreg2 blackhisp using table1, excel se replace nor nobs

foreach var of varlist female blackhisp age educper income1cpi hosp ghindx cholest diastol systol mhi ghindxx cholestx diastolx systolx mhix {
		
	qui reg `var' plantype_1 plantype_2 plantype_3, cl(famid)
	qui sum `var' if plantype==4
	local sdev = r(sd)
	outreg2 using table1, excel se append noaster dec(3) addstat("Constant SD:",`sdev')

	qui reg `var' any_ins, cl(famid)
	outreg2 using table1, excel se append noaster dec(3)
}
