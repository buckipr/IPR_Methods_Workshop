/*   
         
     StatTag for IPR Seminar 24.9.20

     Illustrating:  tables
                                                  */


global D "c:/Box Sync"

set more off


use "$D/a_Z/computing/software_stat/stattag/IPRdata.dta", clear


bysort cc:  gen N_surveys = _N
keep if N_surveys>=2

drop if cc=="ke" | cc=="zm"

gen pbu = unwant
label variable pbu "percent births unwanted"

gen Year = year - 1975

sort cc year

gen RegionX = Region
replace RegionX = 4  if Region==5 | Region==7
replace RegionX = 5  if Region==6
capture label drop RegionX
label define RegionX 1 "East & South Africa"  2 "West & Middle Africa"   ///
                     3 "Latin America"        4 "South & SE Asia"        ///     
                     5 "W Asia & N Africa"
label values RegionX RegionX


estpost tabstat pbu, stat(mean) by(RegionX) nototal
matrix P = e(mean)' 

estpost tabstat tfr, stat(mean) by(RegionX) nototal
matrix T = e(mean)'


mixed pbu ibn.RegionX#c.Year, nocons || cc:
margins, dydx(Year) at(RegionX=(1(1)5))
matrix B = r(b)'


matrix tab1 = P,T,B

matrix list P

matrix list T

matrix list B


matrix list tab1


mixed pbu ibn.RegionX, nocons  || cc: 
estimates store pbu1

mixed pbu ibn.RegionX Year, nocons  || cc:
estimates store pbu2

esttab pbu1 pbu2,                                                            ///
       cells(b(star fmt(1))) drop(_cons) varwidth(20) label                  ///
       stats(N bic, fmt(%4.0f %5.1f) labels("Number of surveys" "BIC"))      ///
       eqlabels(none) nonum   collabels(none)  mlabel("Model 1" "Model 2")   /// 
       ti("Table 2. Effects of Region and Year on Percent Births Unwanted")  ///
       legend style(tab) 

