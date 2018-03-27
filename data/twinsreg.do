log using twinsreg,replace
*
* PROGRAM TWINSREG.DO
*
*  This program runs the basic regressions in
*  Ashenfelter and Rouse (QJE, 1998)
*
*  NOTE:  The GLS and 3SLS estimates were done in SAS.
*
*  December 23, 23
*
set more 1
# delimit ;

use pubtwins;

global pindiv "age age2 female white";
global aindiv "age age2 female white uncov married tenure";
global adindiv "duncov dmaried dtenure";

/* RESULTS IN TABLE II */

reg lwage educ $pindiv;


/* RESULTS IN TABLE III */
/* ALL ASSUME CORRELATED MEASUREMENT ERRORS */

/*  Cols. 4 and 5 */

reg dlwage dceduc if first==1,noconstant;
reg dlwage dceduc (dceduct) if first==1,noconstant;

/*  Controlling for Other Covariates  -- Cols. 9 and 10 */

reg dlwage dceduc $adindiv if first==1&dtenure~=.&duncov~=.&dmaried~=.,noconstant;
reg dlwage dceduc $adindiv (dceduct $adindiv) 
        if first==1&dtenure~=.&duncov~=.&dmaried~=.,noconstant;

/* RESULTS IN TABLE IVa and IVb  */

/* Cols. 3 and 4 */
 
reg dlwage dceduc dcsumint if first==1,noconstant;
coefint dceduc dcsumint _b[dceduc] _b[dcsumint];
 
reg dlwage dceduc dcsumint (dceduct dcsuminz)
    if first==1,noconstant;
coefint dceduc dcsumint _b[dceduc] _b[dcsumint];
 
/* RESULTS IN TABLE V */

/*  Do FE -- Assuming correlated errors */
 
keep if dtenure~=.&duncov~=.&dmaried~=.;
reg dlwage dceduc dcpedhs dcpedcl if first==1,nocons;
 
/*  Do IV with FE -- Assuming correlated errors */
 
reg dlwage dceduc dcpedhs dcpedcl 
    (dceduct dcpedhst dcpedclt) if first==1,nocon;
 
 

 

