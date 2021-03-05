sysuse auto.dta, clear
ds

/*----------------------------------------------------------------------------*/
/* asdoc                                                                      */
/* ssc install asdoc                                                          */
/*----------------------------------------------------------------------------*/
// Tables of Descriptves
// dec -> decimals
// tzok -> trailing zeros OK
// cnames -> column nuame
// fs(8) -> font size
// nocf --> no cumulative percentage

// summary table with # of observations and mean for each variable 
asdoc sum, stat(N mean) save(asdoc_example.doc) replace

// more descriptive statistics for select variables (and some additional formatting)
asdoc sum mpg price rep78 weight, label stat(N mean sd min max tstat) dec(2) tzok save(asdoc_example.doc) append

// adding some text to the Word document, and adding 1-way table with a title (no cumulative %)
// (append is the default option so we will keep adding to the some docx) 
asdoc, text(\par Here is another table \par) fs(14) save(asdoc_example.doc)
asdoc tabulate rep78, nocf save(asdoc_example.doc) title(Table 2: One-way tabulate)

// adding 2-way table with column percents
asdoc tabulate rep78 foreign, column save(asdoc_example.doc) title(Table 3: Two-way tabulate)

// adding 2-way table with row %, but no frequencies
asdoc tabulate rep78 foreign, row nofreq save(asdoc_example.doc) title(Table 4: Two-way tabulate)

// adding 2-way table with summary statistics for miles per gallon (mpg) for each value of rep78
asdoc table rep78, c(n mpg mean mpg sd mpg median mpg) save(asdoc_example.doc) title(Table 5: Table command)

// adding a table of percent distribution of rep78 for each value of foreign
asdoc proportion rep78, over(foreign)

// not working: asdoc tabstat price mpg, stat(mean) by(foreign)


// Regression Tables
// with the nest command, this will create a new document (i.e., will not add to the previous
// Word document created by the preceding commands).

// Table with 3 regression models, with a model name, dropping the constant, including summary statistics at the
// bottom of the table, and adding t-statistics for each coefficient.
// (adding a title for the table with the third command)
asdoc reg mpg weight, cnames(Model 1) drop(_cons) stat(N r2_a) rep(t) save(asdoc_reg.doc) replace nest
asdoc reg mpg price, cnames(Model 2) drop(_cons) stat(N r2_a) save(asdoc_reg.doc) nest
asdoc reg mpg weight price, title(Table 3: Regressions) cnames(Model 3) drop(_cons) stat(N r2_a) save(asdoc_reg.doc) nest

// Same as above but specify significance levels, font, and bolding column & row headers
// standard errors are included (by default) for each coefficient
// * doesn't seem like we can set the number of decimal places
asdoc reg mpg weight, dec(5) setstars(***@.03 **@.05 *@.1) font(Arial) save(asdoc_reg.doc) reset nest
asdoc reg mpg price,  dec(5) setstars(***@.03 **@.05 *@.1) font(Arial) save(asdoc_reg.doc) nest
asdoc reg mpg weight price, dec(5) setstars(***@.03 **@.05 *@.1) font(Arial) fhc(\b) fhr(\b \i) save(asdoc_reg.doc) nest

// additional text at the bottom of the table
asdoc reg mpg weight, replace nest
asdoc reg mpg price,        add(Race dummy, yes, Education dummy, yes) save(asdoc_reg.doc) nest
asdoc reg mpg weight price, add(Race dummy, yes, Education dummy, yes) save(asdoc_reg.doc) nest

// example with logit models
asdoc logit foreign mpg weight, save(logit_example.doc) replace nest
asdoc logit foreign mpg price, save(logit_example.doc) nest
asdoc logit foreign mpg weight price, save(logit_example.doc)  nest

/*----------------------------------------------------------------------------*/
/* estout (write a CSV file)                                                  */
/* ssc install estout                                                         */
/*----------------------------------------------------------------------------*/
// run 3 regressions and save the results with names m1, m2, m3
eststo m1: reg mpg weight
eststo m2: reg mpg price
eststo m3: reg mpg weight price

// write out models m1, m2, & m3, and give them better titles
esttab m1 m2 m3 using estout_example.csv, mtitles("Model 1" "Model 2" "Model 3") replace

// specify the order in with the independent variables appear
esttab m1 m2 m3 using estout_example.csv, mtitles("Model 1" "Model 2" "Model 3") order(_cons price weight) replace 

// set the labels for the independent variables 
esttab m1 m2 m3 using estout_example.csv, mtitles("Model 1" "Model 2" "Model 3") order(_cons price weight) coeflabels(_cons "Intercept") replace 

// include R^2 and truncate coefficients to 3 decimal places
esttab m1 m2 m3 using estout_example.csv, mtitles("Model 1" "Model 2" "Model 3") order(_cons price weight) coeflabels(_cons "Intercept") b(4) t(4) r2 replace 

// footnotes and remove numbers above model names
esttab m1 m2 m3 using estout_example.csv, nonumbers addnotes("These data are from Stata."  "These modles are cool") replace 

// use standard errors
esttab m1 m2 m3 using estout_example.csv, label se nostar brackets replace 

// set the significance levels and include 99% confidence intervals for coefficents with 2 decimal places
// I found that MS Excel would see the comma separating the lower and upper bounds of the confidence
// interval and split them into 2 cells (even though this shouldn't happen because this comma is surrounded
// by quotation marks).  To get around this, you can save the file in scsv (semi-colon separated value) format.
// When openning the file in MS Excel, you need to specify that the delimiter is the semi-colon.
esttab m1 m2 m3 using estout_example.txt, scsv ci(2) level(99) ar2 noobs star(+ 0.10 * 0.05) replace 

// add another statistic (log likelihood)
estout m3
ereturn list
display e(ll)
esttab m1 m2 m3 using estout_example.csv, p bic noconst scalar(ll) sfmt(%8.2f) replace

// example with an interaction term (and giving a more informative label)
eststo m4: reg mpg c.weight##c.price
esttab m1 m2 m3 m4 using estout_example.csv, coeflabels(c.weight#c.price "Weight by Price") replace

/*----------------------------------------------------------------------------*/
/* tabout (very basic intro; write a CSV file)                                */
/* ssc install tabout                                                         */
/*                                                                            */
/* https://www.ianwatson.com.au/stata/tabout_tutorial.pdf                     */
/*----------------------------------------------------------------------------*/

// 2-way table with column percents
tabout foreign rep78 using tabout_example.csv, cells(col) style(csv) replace

// 2-way table with column percents and frequencies
tabout foreign rep78 using tabout_example.csv, cells(col freq) layout(rb) style(csv) replace

// 2-way table with 2 panels (top panel -- foreign [row] x repair record [col])
//                           (bottom panel -- mpg categories [row] x repair record [col])
egen mpg_cat = cut(mpg), group(4)
tabout foreign mpg_cat rep78 using tabout_example.csv, cells(freq) style(csv) layout(rb) replace

// 2-way table with summary statistic for a third variable (mpg)
tabout foreign rep78 using tabout_example.csv, cells(mean mpg) sum style(csv) replace

/*----------------------------------------------------------------------------*/
/* putdocx (very basic intro)                                                 */
/* (requires Stata version 15 or later)                                       */
/*----------------------------------------------------------------------------*/
// create a summary table of mpg for each category in foreign
sysuse auto, clear
putdocx begin
putdocx paragraph
putdocx text ("Example of Stata's putdocx"), bold
statsby Total=r(N) Average=r(mean) Max=r(max) Min=r(min), by(foreign): summarize mpg
putdocx table tbl1 = data("foreign Total Average Max Min"), varnames
putdocx save putdocx_example.docx, replace
putdocx clear
