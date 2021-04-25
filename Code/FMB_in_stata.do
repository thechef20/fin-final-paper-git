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

xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma esg_minus_rf, fmb newey(1) first save(first_function_for_size)

**********need to add this to my LATEX doc
outreg2 using FF_pass_2.tex, replace ctitle(Size Portoflios)



use first_function_for_size,clear
drop  _obs
gen portoflio_numer = _TimeVar
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
eststo clear
ds
estpost tabstat `r(varlist)', by(portoflio_numer)
esttab  using beta_output_inital.tex, cells("`beta_list'") replace noobs nodepvar nomtitle
*esttab using desc1.tex, cells("mean sd min max") replace  nodepvar




* beta based porfolios
import delimited beta_porflios_and_returns.csv, clear
xtset indexy_time_var beta_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma esg_minus_rf, fmb newey(1) first save(first_function_for_beta)
outreg2 using FF_pass_2.tex, append ctitle(Beta Portoflios) 

use first_function_for_size,clear
drop  _obs
gen portoflio_numer = _TimeVar
drop _TimeVar
