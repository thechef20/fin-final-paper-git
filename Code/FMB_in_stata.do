clear 
cls
*Matthew Chistolini
*Last Edited: 4/25/21
*ssc install asreg
*ssc install outreg2
*ssc outfile
* Setting up workspace
cd /Users/matt/Final_Paper_Git/Code/data

* size based porfolios
import delimited size_porflios_and_returns.csv, clear


gen emp = esg_minus_rf

label variable hml "HML"
label variable emp "EMP"
label variable smb "SMB"
label variable cma "CMA"
label variable market_minus_rf "Market"
label variable rmw "RMW"

drop esg_minus_rf
xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(first_function_for_size)

**********need to add this to my LATEX doc
outreg2 using FF_pass_2.tex, replace ctitle(Size Portfolio) tex(fragment) label


*** Size Pass 1
use first_function_for_size,clear
drop  _obs
gen portfolio_number = _TimeVar
drop _TimeVar
drop _Cons
drop _adjR2
ds
local size_list = r(varlist)
disp "`size_list'"

foreach v in `size_list'{
	gen LLL_`v' = round(`v',.001)
	drop `v'
	gen `v' = LLL_`v'
	drop LLL_`v'
}

label variable _b_hml "HML"
label variable _b_market_minus_rf "Market"
label variable _b_smb "SMB"
label variable _b_rmw "RMW"
label variable _b_cma "CMA"
label variable _b_emp "EMP"
label variable _R2 "R^2"
label variable portfolio_number "portfolio num"
eststo clear
local labelsl = "HML Market SMB RMW CMA EMP portfolio"
ds
estpost tabstat `r(varlist)', by(portfolio_number) nototal
esttab  using size_output_inital.tex, collabels("Market ""HML" "SMB" "RMW" "CMA" "EMP" "R2" "Portfolio Number")   nonumbers  noobs  cells("`size_list'") replace
*esttab using desc1.tex, cells("mean sd min max") replace  nodepvar width(10pt)




* beta based porfolios
import delimited beta_porflios_and_returns.csv, clear

gen emp = esg_minus_rf
label variable hml "HML"
label variable emp "EMP"
label variable smb "SMB"
label variable cma "CMA"
label variable market_minus_rf "Market"
label variable rmw "RMW"
drop esg_minus_rf
xtset indexy_time_var beta_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(first_function_for_beta)
outreg2 using FF_pass_2.tex, append ctitle(Beta Portfolio) tex(fragment) label





*** Beta Pass 1


use first_function_for_beta,clear
drop  _obs
gen portfolio_number = _TimeVar
drop _TimeVar
drop _Cons
drop _adjR2
ds
local beta_list = r(varlist)
disp "`beta_list'"

foreach v in `beta_list'{
	gen LLL_`v' = round(`v',.001)
	drop `v'
	gen `v' = LLL_`v'
	drop LLL_`v'
}
label variable _b_hml "HML"
label variable _b_market_minus_rf "Market"
label variable _b_smb "SMB"
label variable _b_rmw "RMW"
label variable _b_cma "CMA"
label variable _b_emp "EMP"
label variable _R2 "R^2"
label variable portfolio_number "portfolio num"

eststo clear
ds
local labelsl = "HML Market SMB RMW CMA EMP portfolio"
estpost tabstat `r(varlist)', by(portfolio_number) nototal 
esttab  using beta_output_inital.tex,  collabels("Market ""HML" "SMB" "RMW" "CMA" "EMP" "R2" "Portfolio Number")   nonumbers  noobs nomti  cells("`beta_list'")  replace
*unstack
*esttab  using beta_output_inital.tex,  cells("`beta_list'") replace   mtitle("Market ""HML" "SMB" "RMW" "CMA" "EMP" "R2" "portfolio num")  unstack nonumbers  collabels(none) eqlabels(none)    noobs 
*nomtitle nodepvar
*mtitle("HML" "Market" "SMB" "RMW" "CMA" "EMP" "portfolio num")
*mtitle("Market" "HML" "SMB" "RMW" "CMA" "EMP" "R2" "portfolio num")
