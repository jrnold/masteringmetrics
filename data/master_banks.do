*** Metrics
*** Figure 5.1, 5.2, 5.3
*** Richardson and Troost bank failure data and results

version 10
clear

// set to directory where this do file is located
cd ""

insheet using banks.csv

drop date
gen date = mdy(month,day,year)
format %td date

gen lbib6 = ln(bib6)
gen lbib8 = ln(bib8)
gen lbio6 = ln(bio6)
gen lbio8 = ln(bio8)

label var year "Year"

line lbio6 lbio8 date, xline(-10647 -10472)
line lbib6 lbib8 date, xline(-10647 -10472)


/* create counterfactual */

keep if month == 7 & day == 1

 gen diff = bib8 - bib6
 gen bibc = bib6*(year==1929) + (bib8 - diff[2])*(year>=1930) 

 gen ldiff = lbib8 - lbib6
 gen lbibc = lbib6*(year==1929) + (lbib8 - ldiff[2])*(year>=1930) 
 
/* plot levels -- add counterfactual to fig 2 */

scatter bib8 bib6 bibc year if year > 1929 & year < 1932, msymbol(circle circle circle) msize(vlarge vlarge vlarge) ///
mcolor(black black black) connect(l l l)  lpat(l l -) lwidth(medium medthick medium) lcolor(black black black) ///
xscale(range(1929 1932)) yscale(range(95 170)) xlabels(#4) legend(off) ytitle("Number of Banks in Business") saving("../Output/banks_fig51", replace)
graph export "../Output/banks_fig51.png", replace

scatter bib8 bib6 year if year > 1928 & year < 1935, msymbol(circle circle circle) msize(vlarge vlarge vlarge) ///
mcolor(black black black) connect(l l l)  lpat(l l -) lwidth(medium medthick medium) lcolor(black black black) ///
yscale(range(70 180)) legend(off) ytitle("Number of Banks in Business") saving("../Output/banks_fig52", replace)
graph export "../Output/banks_fig52.png", replace

scatter bib8 bib6 bibc year if year > 1928 & year < 1935, msymbol(circle circle circle) msize(vlarge vlarge vlarge) ///
mcolor(black black black) connect(l l l)  lpat(l l -) lwidth(medium medthick medium) lcolor(black black black) ///
yscale(range(70 180)) legend(off) ytitle("Number of Banks in Business") saving("../Output/banks_fig53", replace)
graph export "../Output/banks_fig53.png", replace




