/*   
         
     StatTag for IPR Seminar 24.9.20

     Illustrating:  figure
                                                  */


global D "c:/Box Sync"

set more off

use "$D/a_Z/computing/software_stat/stattag/IPRdata.dta", clear


bysort cc:  gen N_surveys = _N
keep if N_surveys>=2


gen PBU = unwant
label variable PBU "percent births unwanted"

sort cc year

gen RegionX = Region
replace RegionX = 4  if Region==5 | Region==7
replace RegionX = 5  if Region==6
capture label drop RegionX
label define RegionX 1 "East & South Africa"  2 "West & Middle Africa"   ///
                     3 "Latin America"        4 "South & SE Asia"        ///     
                     5 "W Asia & N Africa"
label values RegionX RegionX



mixed PBU ibn.RegionX i.RegionX#(c.tfr##c.tfr), nocons || cc: 
estimates store pbu1


forvalues r = 1/5  {
  sum tfr  if RegionX==`r', meanonly
  local R`r'min = `r(min)' + 0.50
  local R`r'max = `r(max)' - 0.50
  if RegionX==1  {
     local R`r'max = `r(max)' - 0.75
  }
}


qui margins, at(RegionX=1 tfr=(`R1min'(0.25)`R1max'))      ///
             at(RegionX=2 tfr=(`R2min'(0.25)`R2max'))      ///
             at(RegionX=3 tfr=(`R3min'(0.25)`R3max'))      ///
             at(RegionX=4 tfr=(`R4min'(0.25)`R4max'))      ///
             at(RegionX=5 tfr=(`R5min'(0.25)`R5max'))      ///
             noatlegend post

marginsplot, plot(at(RegionX))                                                       ///
             plot1opts(msymbol(i) lwidth(*1.50) lpattern(solid) lcolor(black))       ///
             plot2opts(msymbol(i) lwidth(*1.50) lpattern(solid) lcolor(orange_red))  ///
             plot3opts(msymbol(i) lwidth(*1.50) lpattern(dash)  lcolor(blue))        ///
             plot4opts(msymbol(i) lwidth(*1.50) lpattern(dash)  lcolor(cranberry))   ///
             plot5opts(msymbol(i) lwidth(*1.50) lpattern(dash)  lcolor(green))       ///
             recastci(rarea)                                                         ///
             ciopts(lwidth(none) fintensity(inten10) fcolor(black%50))               ///
             title("Figure 1.  Trends in Percent Births Unwanted [PBU]",    ///
                    size(*0.95) color(black) margin(t-1 b+2))                        ///
             ytitle("Percent Births Unwanted", size(*0.90) margin(l-2 r+1))          ///
             yscale(r(0 41))                                                         ///
             ylabel(0(10)40, labsize(*.70) format(%2.0f) angle(0)                    ///
                    labgap(*.60) tlength(*.60)                                       ///
                    grid glwidth(*.30) glcolor(gs10))                                ///
             xtitle("Total Fertility Rate", margin(t+2 b+1))                         ///
             xlabel(2(1)8, labsize(*.80) labgap(*.40) format(%1.0f) tlength(*.65))   ///
             xscale(r(2 8.2) reverse)                                                ///
             graphregion(color(white))                                               ///
             legend(cols(1) ring(0) pos(5) size(*0.75)                               ///
                    rowgap(*.05)  keygap(*1.30) symx(*.60)                           ///
                    margin(r+2)  bmargin(b+1 r+6)                                    ///
                    region(lwidth(*.25) lcolor(gs6) margin(t-1 b-1 l+1 r-3)))        ///
             graphregion(color(white))

graph export "$D/a_Z/computing/software_stat/stattag/pbu1_region.png",               ///
      width(3000) replace
