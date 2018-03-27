*** Metrics
*** Tables 1.3-1.4
*** goal: master RAND replication do file

clear all
set more off

// set to directory where this do file is located
cd "/NHIS/Data/"

use person_years.dta, clear

*Merge Data on Hospital Visits
merge 1:1 person year using annual_spend.dta
keep if _m==3
drop _m

* Group plans into four types: 
* 1-Free, 2-Individual Deductible, 3-Cost Sharing (25%/50%), 4-Catostrophic (Fam Deductible) (95%/100%)*
gen plantype =.

replace plantype = 1 if plan==24
replace plantype = 2 if plan==1
replace plantype = 2 if plan==5
replace plantype = 4 if plan>=2 & plan<=4
replace plantype = 4 if plan>=6 & plan<=8
replace plantype = 3 if plan>=9 & plan<=23

*Generate Plan Dummies
gen plantype_1= (plantype==1)
gen plantype_2= (plantype==2)
gen plantype_3= (plantype==3)
gen plantype_4= (plantype==4)

*Generate Site Dummies
gen site1=(site==1)
gen site2=(site==2)
gen site3=(site==3)
gen site4=(site==4)
gen site5=(site==5)
gen site6=(site==6)

*Attempt to correlate year variable from annyal expenditures data to correct calendar year in order to adjust for inflation

gen expyear=indv_start_year+year-1

*Adjust for inflation.  This will only be an estimate since the annual expenditures data does not tell us what month they received specific services. 
*The CPI adjustment values below are based on the June CPI from 1991 (see table found at http://www.seattle.gov/financedepartment/cpi/historical.htm ).

gen out_inf=.
replace out_inf=outsum*3.07 if expyear==1973
replace out_inf=outsum*2.76 if expyear==1974
replace out_inf=outsum*2.53 if expyear==1975
replace	out_inf	=	outsum*	2.39	if	expyear	==1976
replace	out_inf	=	outsum*	2.24	if	expyear	==1977
replace	out_inf	=	outsum*	2.09	if	expyear	==1978
replace	out_inf	=	outsum*	1.88	if	expyear	==1979
replace	out_inf	=	outsum*	1.65	if	expyear	==1980
replace	out_inf	=	outsum*	1.5	if	expyear	==1981
replace	out_inf	=	outsum*	1.41	if	expyear	==1982
replace	out_inf	=	outsum*	1.37	if	expyear	==1983
replace	out_inf	=	outsum*	1.31	if	expyear	==1984
replace	out_inf	=	outsum*	1.27	if	expyear	==1985

gen inpdol_inf=.
replace inpdol_inf=inpdol*3.07 if expyear==1973
replace inpdol_inf=inpdol*2.76 if expyear==1974
replace inpdol_inf=inpdol*2.53 if expyear==1975
replace	inpdol_inf	=	inpdol*	2.39	if	expyear	==1976
replace	inpdol_inf	=	inpdol*	2.24	if	expyear	==1977
replace	inpdol_inf	=	inpdol*	2.09	if	expyear	==1978
replace	inpdol_inf	=	inpdol*	1.88	if	expyear	==1979
replace	inpdol_inf	=	inpdol*	1.65	if	expyear	==1980
replace	inpdol_inf	=	inpdol*	1.5	if	expyear	==1981
replace	inpdol_inf	=	inpdol*	1.41	if	expyear	==1982
replace	inpdol_inf	=	inpdol*	1.37	if	expyear	==1983
replace	inpdol_inf	=	inpdol*	1.31	if	expyear	==1984
replace	inpdol_inf	=	inpdol*	1.27	if	expyear	==1985

*Generate Total Spending Variable
gen tot_inf=inpdol_inf+out_inf



* Family id
gen famid=substr(fam_identifier,3,.)
destring famid, ignore("A") replace
gen any_ins=(plantype==1|plantype==2|plantype==3)

*replace old table file
reg female plantype_1, noconst
outreg2 using table2, excel se replace nor nobs

foreach var of varlist ftf out_inf totadm inpdol_inf tot_inf{
		
	qui reg `var' plantype_1 plantype_2 plantype_3, cl(famid)
	qui sum `var' if plantype==4
	local sdev = r(sd)
	outreg2 using table2, excel se append noaster dec(3) addstat("Constant SD:",`sdev')

	qui reg `var' any_ins, cl(famid)
	outreg2 using table2, excel se append noaster dec(3)
}

