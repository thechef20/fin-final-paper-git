clear 
cls
*Matthew Chistolini
*Last Edited: 4/9/21

* Setting up workspace
cd /Users/matt/Final_Paper_Git/Code/data

*** importing and cleaning ESG Returns (daily) ***
import excel using file_ESG_connolly.xlsx, sheet("Sheet2") firstrow
drop if price ==0
drop returns
gen returns = (price[_n+1]-price[_n])/price[_n]
gen date3 = mdy(mmonth, day, cal_year)
format date3 %td
save ESG_returns.dta,replace


*** importings all stocks returns ***
use sfz_dp_2011_2020,clear
gen date3=date(caldt,"YMD###")
drop caldt
format date3 %td
merge m:1  date3 using ESG_returns.dta
drop _merge
drop if missing(returns)
save daily_data_with_ESG_returns.dta,replace

*** cleaning the risk free and other FF factors ***
import delimited using Famma_factors.csv,clear

gen date3 = mdy(mmonth ,day, cal_year) 
format %tm date3

gen holder_var = rf/100
drop rf
gen rf = holder_var
drop holder_var

gen holder_var = hml/100
drop hml
gen hml = holder_var
drop holder_var

gen holder_var = smb/100
drop smb
gen smb = holder_var
drop holder_var

gen holder_var = rmw/100
drop rmw
gen rmw =  holder_var
drop  holder_var


gen holder_var = cma/100
drop cma
gen cma =  holder_var
drop  holder_var
save ff_sata_file.dta,replace


*** importing and cleaning market returns ***
use sfz_mind, clear
drop if kyindno != 1000080
egen collapse_id = group(myear mmonth)
collapse(mean)  maret myear mmonth , by(collapse_id)
drop  collapse_id

gen cal_year = myear
drop myear
save market_1000080.dta,replace



* merge ESG and with daily_data_with_ESG_returns 
use daily_data_with_ESG_returns, clear
merge m:1  date3 using ff_sata_file.dta
drop _merge
drop if missing(returns)
drop if missing(rf)
drop if missing(kypermno)
egen collapse_id = group(mmonth cal_year kypermno)
* do we actually want sum for HML???
collapse(mean)  kypermno  (sum) ret returns  rf hml smb rmw cma (mean) tcap cal_year mmonth , by(collapse_id)
sort kypermno cal_year mmonth
drop collapse_id

*** merge market data with daily retuns&ESG ***
merge m:1  cal_year mmonth using market_1000080.dta
drop if missing(rf)
drop _merge

*** creating rf adjusted colums ***
gen market_minus_rf = maret - rf
gen ESG_minus_rf = returns - rf
gen expected_return_stock = ret - rf

drop maret
drop returns
drop ret
drop rf
order kypermno expected_return_stock ESG_minus_rf market_minus_rf hml smb rmw cma tcap cal_year mmonth
sort kypermno cal_year mmonth
*** Getting ready to put into matlab ***
export delimited using "ESG_and_five_factors.csv", replace

*shrinking dataset for testing 
drop if kypermno>10026
export delimited using "ESG_and_five_factors_testing.csv", replace


*** Summerization of the data!! ***
egen kyper_gen = group(kypermno)
sum  kyper_gen
sort kyper_gen
