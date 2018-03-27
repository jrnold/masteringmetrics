*** Metrics
*** Table 1.1
*** goal: make table of health outcomes and characteristics by insurance status ***

* by Georg Graetz, August 6, 2013
* modified lightly by Gabriel Kreindler, June 13, 2014
* modified lightly by Jon Petkun, January 2, 2015

pause on
clear all
set more off
cap log close

// set to directory where NHIS2009_clean.dta is stored
cd "/NHIS/Data/"

log using NHIS2009_hicompare.log, text replace

u NHIS2009_clean, clear

* select non-missings
	keep if marradult==1 & perweight!=0 
		by serial: egen hi_hsb = mean(hi_hsb1)
			keep if hi_hsb!=. & hi!=.
		by serial: egen female = total(fml)
			keep if female==1
			drop female
	
* Josh's sample selection criteria	
	gen angrist = ( age>=26 & age<=59 & marradult==1 & adltempl>=1 )
		keep if angrist==1
	// drop single-person HHs
	by serial: gen n = _N
		keep if n>1

* count of husbands by HI status
	tab hi if  fml==0 [ aw=perweight ]

* mean comparisons for husbands
	foreach var in hlth nwhite age yedu famsize empl inc {
		qui reg `var' hi if fml==0 [ w=perweight ], robust
						
		* means and standard devs
		qui sum `var' if hi==0 & fml==0 [ aw=perweight ]
		local m0   =r(mean)
		local sd0  =r(sd)
		qui sum `var' if hi==1 & fml==0 [ aw=perweight ]
		local m1   =r(mean)
		local sd1  =r(sd)
			
			if "`var'"=="hlth" {
				outreg2 hi using hicompare_hsb, replace excel noaster adec(2) dec(2) bdec(2) sdec(2) ///
				addstat("Mean no HI",`m0',"SD no HI",`sd0',"Mean HI",`m1',"SD HI",`sd1')
			}
			if "`var'"!="hlth" {
				outreg2 hi using hicompare_hsb, append excel noaster adec(2) dec(2) bdec(2) sdec(2) ///
				addstat("Mean no HI",`m0',"SD no HI",`sd0',"Mean HI",`m1',"SD HI",`sd1') 
			}
		}
	
* count of wives by HI status
	tab hi if  fml==1 [ aw=perweight ]

* mean comparisons for wives
	foreach var in hlth nwhite age yedu famsize empl inc {
		qui reg `var' hi if fml==1 [ w=perweight ], robust
		
				* means and standard devs
		qui sum `var' if hi==0 & fml==1 [ aw=perweight ]
		local m0   =r(mean)
		local sd0  =r(sd)
		qui sum `var' if hi==1 & fml==1 [ aw=perweight ]
		local m1   =r(mean)
		local sd1  =r(sd)
		
		
			if "`var'"=="hlth" {
				outreg2 hi using hicompare_wf, replace excel noaster adec(2) dec(2) bdec(2) sdec(2) ///
				addstat("Mean no HI",`m0',"SD no HI",`sd0',"Mean HI",`m1',"SD HI",`sd1')
			}
			if "`var'"!="hlth" {
				outreg2 hi using hicompare_wf, append excel noaster adec(2) dec(2) bdec(2) sdec(2) ///
				addstat("Mean no HI",`m0',"SD no HI",`sd0',"Mean HI",`m1',"SD HI",`sd1')
			}
		}

	
cap log close
