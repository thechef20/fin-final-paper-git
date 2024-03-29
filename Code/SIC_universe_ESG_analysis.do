clear 
cls
*Matthew Chistolini
*Last Edited: 4/28/21
*ssc install asreg
*ssc install outreg2
*ssc outfile
* Setting up workspace
*please run  Industry_ESG_analysis first as there are dependcies
cd /Users/matt/Final_Paper_Git/Code/data

use export_for_testing_entire_SIC_universe,clear

egen  decile_screen = xtile(NumericESG), nq(10)


* from here down copy past from Industry_ESG_analysis-->
drop if decile_screen>1 & decile_screen<10
gen ticker = Ticker 
drop Ticker 
sort ticker
merge 1:m ticker using  kyper_ticker_returns.dta
drop if missing(NumericESG)
drop if missing(collapse_id)
drop collapse_id 
sort SICfirstNumber decile_screen  mmonth cal_year 
egen collapse_id = group(SICfirstNumber decile_screen mmonth cal_year )
collapse (mean) retx (lastnm) kypermno cal_year mmonth decile_screen SICfirstNumber, by(collapse_id)
drop collapse_id
gen low_ESG = retx if decile_screen==10
gen high_ESG = retx if decile_screen==1
egen collapse_id = group(SICfirstNumber cal_year mmonth  )
collapse (mean) high_ESG low_ESG (lastnm) kypermno cal_year mmonth SICfirstNumber, by(collapse_id)
sort SICfirstNumber  cal_year mmonth
gen industry_ESG_factor = low_ESG-high_ESG
drop low_ESG high_ESG collapse_id kypermno
egen indexy_time_var = group(cal_year mmonth)
* <-- from here down copy past 
save all_industry_ESG_factor.dta, replace 

*** Creating size porlfio all data 


use return_data_for_testing_entire_SIC_universe,clear
merge m:m indexy_time_var using all_industry_ESG_factor.dta
drop _merge
drop esg_minus_rf
sort cal_year mmonth SICfirstNumber size_ports
egen unique_tmie_SIC_size = group(cal_year mmonth size_ports)

collapse (mean) expected_return_stock hml smb rmw cma industry_ESG_factor market_minus_rf (lastnm)indexy_time_var mmonth cal_year SICfirstNumber size_ports, by(unique_tmie_SIC_size)


gen emp = industry_ESG_factor
drop  industry_ESG_factor

label variable hml "HML"
label variable emp "ESG"
label variable smb "SMB"
label variable cma "CMA"
label variable market_minus_rf "Market"
label variable rmw "RMW"
save all_industry_SIC_size_porfolios.dta , replace

**** Creating beta porflio all data


use return_data_for_testing_entire_SIC_universe,clear
merge m:m indexy_time_var using all_industry_ESG_factor.dta
drop _merge
drop esg_minus_rf
sort cal_year mmonth SICfirstNumber beta_ports
egen unique_tmie_SIC_size = group(cal_year mmonth beta_ports)

collapse (mean) expected_return_stock hml smb rmw cma industry_ESG_factor market_minus_rf (lastnm)indexy_time_var mmonth cal_year SICfirstNumber beta_ports, by(unique_tmie_SIC_size)

gen emp = industry_ESG_factor
drop  industry_ESG_factor

label variable hml "HML"
label variable emp "ESG"
label variable smb "SMB"
label variable cma "CMA"
label variable market_minus_rf "Market"
label variable rmw "RMW"
save all_industry_SIC_beta_porfolios.dta , replace


****** size based porfolios 2 pass regression 
use all_industry_SIC_size_porfolios, clear

xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody_3)
outreg2 using All_Industry_FF_pass_2.tex, replace ctitle(Size portfolio) tex(fragment) label

****** beta based porfolios 2 pass regression 
use all_industry_SIC_beta_porfolios, clear


xtset indexy_time_var beta_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody_3)
outreg2 using All_Industry_FF_pass_2.tex, append ctitle(Beta Portfolio) tex(fragment)label


****** size based porfolios 2 pass regression 2019 and beyond
use all_industry_SIC_size_porfolios, clear
drop if cal_year<2018
drop if cal_year>2020

xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody_3)
outreg2 using All_Industry_FF_pass_2_past_2018.tex, replace ctitle(Size portfolio) tex(fragment) label

****** beta based porfolios 2 pass regression  2019 and beyond 
use all_industry_SIC_beta_porfolios, clear
drop if cal_year<2018
drop if cal_year>2020


xtset indexy_time_var beta_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody_3)
outreg2 using All_Industry_FF_pass_2_past_2018.tex, append ctitle(Beta Portfolio) tex(fragment) label
