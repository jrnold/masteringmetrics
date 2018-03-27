log using pubtwins,replace
*
* PROGRAM PUBTWINS.DO
*
*  This program creates the public use analysis sample
*  for Ashenfelter and Rouse (QJE, 1998)
*
*  December 23, 1997
*
set more 1
# delimit ;

use ~/twins/bc/samp94;

/* Only keep identical twins */
keep if ident2==1;

gen aeduc=(educ+educt_t)/2;
label var aeduc "Own-Reported Avg. Education";

gen aeduct=(educt+educ_t)/2;
label var aeduct "Twin-Reported Avg. Educ";

gen dlwage=lwage-lwage_t;
label var dlwage "1st Diff. Log Wage";

gen deduc=educ-educ_t;
label var deduc "Own-Report 1st Diff in Educ";

gen deduct=educt_t-educt;
label var deduct "Twin-Report 1st Diff in Educ";

gen dceduc=educ-educt;
label var dceduc "Twin1-Report 1st Diff in Educ";

gen dceduct=educt_t-educ_t;
label var dceduct "Twin2-Report 1st Diff in Educ";

gen cseduc=(educ+educt)/2;
label var cseduc "Twin1 Report of Average";

gen cseduct=(educt_t+educ_t)/2;
label var cseduct "Twin2 Report of Average";
 
gen dcsumint=cseduc*dceduc;
label var dcsumint "Twin1 Report of Avg. x Twin1 Report of Ed Diff";

gen dcsuminz=cseduct*dceduct;
label var dcsuminz "Twin2 Report of Avg. x Twin2 Report of Ed Diff";
 
gen duncov=uncov-uncov_t;
label var duncov "1st diff in Union";

gen dmaried=married-maried_t;
label var dmaried "1st Diff in Ever-married";

gen dtenure=tenure-tenure_t;
label var dtenure "1st Diff in Job Tenure";

label var educ "Twin1 Educ";
label var educt "Twin1 Report of Twin2 Educ";

label var educ_t "Twin2 Educ";
label var educt_t "Twin2 Report of Twin1 Educ";

label var age2 "Age, squared";

/* Construct Parents' Education Levels */

gen ped=(daded+momed)/2;
gen pedt=(daded_t+momed_t)/2;
 
/*  Replace parents' ed with the non-missing value if one missing */
 
replace ped=daded if daded~=.&momed==.;
replace ped=momed if daded==.&momed~=.;
replace pedt=daded_t if daded_t~=.&momed_t==.;
replace pedt=momed_t if daded_t==.&momed_t~=.;
 
/*  Only keep pairs with both reports of parents' ed */
 
replace ped=. if pedt==.;
replace pedt=. if ped==.;
 
gen mped=(ped+pedt)/2;
label var mped "Avg. of Parents' Education";
 
/*  Divide the avg. of parents' educ into groups */
 
gen pedhs=(mped>11&mped<13);
replace pedhs=. if mped==.;
label var pedhs "Parents Ed = HS";

gen pedcl=(mped>12.99);
replace pedcl=. if mped==.;
label var pedcl "Parents Ed = HS+";
 
gen dcpedhs=pedhs*dceduc;
label var dcpedhs "Parents Ed = HS x Twin1 Diff in Educ";

gen dcpedhst=pedhs*dceduct;
label var dcpedhst "Parents Ed = HS x Twin2 Diff in Educ";

gen dcpedcl=pedcl*dceduc;
label var dcpedcl "Parents Ed = HS+ x Twin1 Diff in Educ";

gen dcpedclt=pedcl*dceduct;
label var dcpedclt "Parents Ed = HS+ x Twin2 Diff in Educ";
 
keep first age age2 female white uncov married tenure
     duncov dmaried dtenure aeduct dlwage deduc deduct
     dceduc dceduct educ educ_t educt_t educt selfemp
     lwage lwage_t dlwage hrwage daded momed nsibs twoplus
     cseduc cseduct dcsumint dcsuminz
     dcpedhs dcpedcl dcpedhst dcpedclt pedhs pedcl;

sum educ educt_t lwage hrwage age white female daded momed
    nsibs selfemp uncov tenure married twoplus; 
 
corr lwage lwage_t educ educt_t educ_t educt if first==1;
 
compress;

save pubtwins,replace;

