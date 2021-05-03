clear 
cls
*Matthew Chistolini
*Last Edited: 4/28/21
*ssc install asreg
*ssc install outreg2
*ssc outfile
* Setting up workspace
cd /Users/matt/Final_Paper_Git/Code/data
import delimited size_porflios_and_returns.csv, clear
gen emp = esg_minus_rf
label variable hml "HML"
label variable emp "EMP"
label variable smb "SMB"
label variable cma "CMA"
label variable market_minus_rf "Market"
label variable rmw "RMW"
save time_data_with_labels.dta,replace

*for 2015
use time_data_with_labels, clear
drop if cal_year != 2015

xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody_2)
outreg2 using Time_FF_pass_2.tex, replace ctitle(2015) tex(fragment) label


*for 2016
use time_data_with_labels, clear
drop if cal_year != 2016

xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody_2)
outreg2 using Time_FF_pass_2.tex, append ctitle(2016) tex(fragment) label


*for 2017
use time_data_with_labels, clear
drop if cal_year != 2017

xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody_2)
outreg2 using Time_FF_pass_2.tex, append ctitle(2017) tex(fragment) label


*for 2018
use time_data_with_labels, clear
drop if cal_year != 2018

xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody_2)
outreg2 using Time_FF_pass_2.tex, append ctitle(2018) tex(fragment) label


*for 2019
use time_data_with_labels, clear
drop if cal_year != 2019

xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody_2)
outreg2 using Time_FF_pass_2.tex, append ctitle(2019) tex(fragment) label


*for 2020
use time_data_with_labels, clear
drop if cal_year != 2020

xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody_2)
outreg2 using Time_FF_pass_2.tex, append ctitle(2020) tex(fragment) label


