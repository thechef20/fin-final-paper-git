clear 
cls
*Matthew Chistolini
*Last Edited: 4/25/21
*ssc install asreg
*ssc install outreg2
*ssc outfile
* Setting up workspace
cd /Users/matt/Final_Paper_Git/Code/data


*for 2015
import delimited size_porflios_and_returns.csv, clear
drop if cal_year != 2015
gen emp = esg_minus_rf
drop esg_minus_rf
xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody_2)
outreg2 using Time_FF_pass_2.tex, replace ctitle(2015) tex(fragment)


*for 2016
import delimited size_porflios_and_returns.csv, clear
drop if cal_year != 2016
gen emp = esg_minus_rf
drop esg_minus_rf
xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody_2)
outreg2 using Time_FF_pass_2.tex, append ctitle(2016) tex(fragment)


*for 2017
import delimited size_porflios_and_returns.csv, clear
drop if cal_year != 2017
gen emp = esg_minus_rf
drop esg_minus_rf
xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody_2)
outreg2 using Time_FF_pass_2.tex, append ctitle(2017) tex(fragment)


*for 2018
import delimited size_porflios_and_returns.csv, clear
drop if cal_year != 2018
gen emp = esg_minus_rf
drop esg_minus_rf
xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody_2)
outreg2 using Time_FF_pass_2.tex, append ctitle(2018) tex(fragment)


*for 2019
import delimited size_porflios_and_returns.csv, clear
drop if cal_year != 2019
gen emp = esg_minus_rf
drop esg_minus_rf
xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody_2)
outreg2 using Time_FF_pass_2.tex, append ctitle(2019) tex(fragment)


*for 2020
import delimited size_porflios_and_returns.csv, clear
drop if cal_year != 2020
gen emp = esg_minus_rf
drop esg_minus_rf
xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody_2)
outreg2 using Time_FF_pass_2.tex, append ctitle(2020) tex(fragment)


