/*   

     StatTag for IPR Methods Workshop 24.9.20

     Illustrating:  values                 
                                                  */


global D "c:/Box Sync/a_Z/computing/software_stat/stattag"

set more off


use "$D/IPRdata.dta", clear


bysort cc:  gen N_surveys = _N
keep if N_surveys>=2

drop if cc=="ke" | cc=="zm"


gen PBU = unwant
label variable PBU "percent births unwanted"


gen RegionX = Region
replace RegionX = 4  if Region==5 | Region==7
replace RegionX = 5  if Region==6
capture label drop RegionX
label define RegionX 1 "East & South Africa"  2 "West & Middle Africa"   ///
                     3 "Latin America"        4 "South & SE Asia"        ///     
                     5 "W Asia & N Africa"
label values RegionX RegionX


egen selectC = tag(cc)  


count
di `r(N)'


count  if selectC==1
di `r(N)'


sum PBU
di `r(mean)'

