*** Mastering 'Metrics
*** Figures 6.3 and 6.4
*** Last Chance

clear

// set to directory where the data file is located
cd ""

use clark_martorell_cellmeans, clear

gen test_lcs_pass=(minscore>=0)
gen test_lcs_min=minscore
forvalues i=1/4 {
 gen test_lcs_left_min`i'=(minscore^(`i'))*(test_lcs_pass==0)
 gen test_lcs_right_min`i'=(minscore^(`i'))*(test_lcs_pass==1)
}


/***************** CODE FOR FIGURE 1 ************************/

reg receivehsd test_lcs_pass test_lcs_left_min1 test_lcs_left_min2 test_lcs_left_min3 test_lcs_left_min4 if minscore<0 [w=n]
predict fit_hsd2_l if minscore<=0
reg receivehsd test_lcs_pass test_lcs_right_min1 test_lcs_right_min2 test_lcs_right_min3 test_lcs_right_min4 if minscore>=0 [w=n]
predict fit_hsd2_r if minscore>=0
sort test_lcs_min

  **Notes: (1) use fitted from left-hand and right-hand polynomial at x=0
twoway /*
*/ (scatter receivehsd test_lcs_min, mcolor(black) msize(med)) /*
*/ (line fit_hsd2_l test_lcs_min if test_lcs_min<=0, clwidth(medthick medthick) clcolor(black black) clpattern(solid dash dot)) /*	
*/ (line fit_hsd2_r test_lcs_min if test_lcs_min>=0, clwidth(medthick medthick medthick) clcolor(black black black) clpattern(solid dash dot)), /*	
*/ xline(0, lcolor(black)) xsc(r(-30,15)) ysc(r(0,1)) xtitle("Test score relative to cutoff", size(medium)) ytitle("Fraction receiving diploma", size(medium)) legen(off) /*
*/ xlabel(-30(5)15, labsize(medium)) ylab(0(0.2)1, labsize(medium)) /*
*/ subtitle("`7'", size(2) justification(center)) /*
*/  xsize(6.5) ysize(3)  graphregion(fcolor(white)  ifcolor(white) color(white) icolor(white)) graphregion(margin(l+2 r+2 t+2))  plotregion(fcolor(white))

graph export "../Output/fig1.png", replace


/***************** CODE FOR FIGURE 2 ************************/

capture program drop earn
program define earn
*1: variables
*3-4: y-range
*5-7: y-labels
*8: graph name
*9: graph title

	reg avgearnings test_lcs_pass test_lcs_left_min1 test_lcs_left_min2   test_lcs_left_min3 test_lcs_left_min4 if  minscore<0  & minscore>=-30 [w=person_years]
	predict fit_l if minscore<=0
	reg avgearnings test_lcs_pass test_lcs_right_min1 test_lcs_right_min2   test_lcs_right_min3 test_lcs_right_min4   if   minscore>=0 [w=person_years]
	predict fit_r if minscore>=0

	sort test_lcs_min
	twoway /*
	*/ (scatter avgearnings test_lcs_min, mcolor(black black black) msize(med med med)) /*
	*/ (line fit_l test_lcs_min if test_lcs_min<=0, clwidth(medthick medthick medthick) clcolor(black black black) clpattern(solid dash dot)) /*	
	*/ (line fit_r test_lcs_min if test_lcs_min>=0, clwidth(medthick medthick medthick) clcolor(black black black) clpattern(solid dash dot)), /*	
	*/ xline(0, lcolor(black)) xsc(r(-30,15)) ysc(r(`3',`4')) xtitle("Test score relative to cutoff", size(medium)) ytitle("Annual earnings", size(medium)) legen(off) /*
	*/ xlabel(-30(5)15, labsize(medium)) ylab(`5'(`6')`7', labsize(medium)) /*
	*/ subtitle("", size(2) justification(center)) /*
	*/ xsize(6.5) ysize(3) graphregion(fcolor(white)  ifcolor(white) color(white) icolor(white)) graphregion(margin(l+2 r+2 t+2)) plotregion(fcolor(white))
	
	graph export "../Output/fig2.png", replace
	
end


earn 7_11 "" 8000 18000 8000 10000 18000 total_y7_11 "Average Years 7-11"


