capture log close
log using "markstat_example_PDF", smcl replace
//_1
sysuse auto, clear
//_2
gen gphm = 100/mpg
//_3
twoway scatter gphm weight || lfit gphm weight ///
    , ytitle(Gallons per Mile) legend(off)
graph export auto.png, width(500) replace
//_^
log close
