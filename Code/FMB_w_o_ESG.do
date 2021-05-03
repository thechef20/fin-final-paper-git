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
label variable hml "HML"
label variable smb "SMB"
label variable cma "CMA"
label variable market_minus_rf "Market"
label variable rmw "RMW"
xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma, fmb newey(1) first save(first_function_for_size)

**********need to add this to my LATEX doc
outreg2 using FF_pass_2_no_ESG.tex, replace ctitle(Size Portfolio) tex(fragment) label



* beta based porfolios
import delimited beta_porflios_and_returns.csv, clear
label variable hml "HML"
label variable smb "SMB"
label variable cma "CMA"
label variable market_minus_rf "Market"
label variable rmw "RMW"
xtset indexy_time_var beta_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma, fmb newey(1) first save(first_function_for_beta)
outreg2 using  FF_pass_2_no_ESG.tex, append ctitle(Beta Portfolio) tex(fragment) label 


