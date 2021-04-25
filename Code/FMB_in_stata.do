clear 
cls
*Matthew Chistolini
*Last Edited: 4/25/21
*ssc install asreg
* Setting up workspace
cd /Users/matt/Final_Paper_Git/Code/data

* size based porfolios
import delimited size_porflios_and_returns.csv, clear
xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma esg_minus_rf, fmb newey(1) first save(first_function_for_size)


use first_function_for_size,clear
drop  _obs
gen portoflio_numer = _TimeVar
drop _TimeVar



* beta based porfolios
import delimited beta_porflios_and_returns.csv, clear
xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma esg_minus_rf, fmb newey(1) first save(first_function_for_beta)


use first_function_for_size,clear
drop  _obs
gen portoflio_numer = _TimeVar
drop _TimeVar
