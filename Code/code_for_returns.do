clear 
cls
*Matthew Chistolini
*Last Edited: 4/6/21

* Setting up workspace
cd /Users/matt/Final_Paper_Git/Code/data

* importing ESG Returns (daily)
import excel using file_ESG_connolly.xlsx, sheet("Sheet2") firstrow
drop if price ==0
drop returns
gen returns = (price[_n]-price[_n+1])/price[_n]
gen date3 = mdy(mmonth, day, cal_year)
format date3 %td
save ESG_returns.dta,replace


* importings all stocks returns 
use sfz_dp_2011_2020,clear
gen date3=date(caldt,"YMD###")
drop caldt
format date3 %td
merge m:1  date3 using ESG_returns.dta
drop _merge
drop if missing(returns)
save daily_data_with_ESG_returns.dta,replace



*cleaning the risk free and other factors
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


* market returns
use sfz_mind, clear
drop if kyindno != 1000080
egen collapse_id = group(myear mmonth)
collapse(mean)  maret myear mmonth , by(collapse_id)
drop  collapse_id

gen cal_year = myear
drop myear
save market_1000080.dta,replace





*there is issue where returns from ESG and stock returns are like signficantly off 

*use daily_data_with_ESG_returns 
use daily_data_with_ESG_returns, clear
merge m:1  date3 using ff_sata_file.dta
drop _merge
drop if missing(returns)
drop if missing(rf)
drop if missing(kypermno)
egen collapse_id = group(mmonth cal_year kypermno)
* do we actually want sum for HML???
collapse(mean)  kypermno  (sum) ret returns  rf hml smb rmw (mean) tcap cal_year mmonth , by(collapse_id)
sort kypermno cal_year mmonth
drop collapse_id

**Merge market data 
merge m:1  cal_year mmonth using market_1000080.dta
drop _merge

** Getting ready to put into matlab 
egen time_match = group(mmonth cal_year)
export delimited using "ESG_and_five_factors.csv", replace
 
