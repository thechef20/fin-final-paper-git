clear 
cls
*Matthew Chistolini
*Last Edited: 4/26/21
* Setting up workspace
cd /Users/matt/Final_Paper_Git/Code/data

use StockNameData,clear
drop if missing(ticker)
collapse (lastnm)ticker , by(kypermno)
sort ticker
save ticker_index.dta, replace 

use sfz_dp_2011_2020,clear
gen date3=date(caldt,"YMD###")
drop caldt
format date3 %td
merge m:1 kypermno using  ticker_index.dta
drop _merge
*only adding the ESG index to get the mmonth yr in the dataset

merge m:1  date3 using ESG_returns.dta
drop _merge
drop if missing(mmonth)
drop if missing(ret)
drop prc ret tcap vol date price returns
egen collapse_id = group(mmonth cal_year kypermno)
collapse(lastnm) kypermno  ticker cal_year mmonth (sum)  retx , by(collapse_id)
save kyper_ticker_returns.dta,replace




*****processing ESG porflios****
import excel using ESG_score_pull_1.xlsx, sheet("raw_esg_final") firstrow clear
* fixing the data to be numberic and not text
drop SICCode ID ESGScore Exchange Holder
gen holder = real(SICfirstNumber)
drop SICfirstNumber
gen SICfirstNumber = holder
drop holder
drop if missing(SICfirstNumber)
drop if Country != "US"
*gen holder = real(NumericESG)
*drop NumericESG
*gen NumericESG = holder
*drop holder

sort SICfirstNumber NumericESG

*I really don't like the decileing here!!
*********** Possability it to make it 1 and 10 for certian scores 
*  fasterxtile but slower!
egen  decile_screen = xtile(NumericESG), by(SICfirstNumber) nq(10)

drop if decile_screen>1 & decile_screen<10
gen ticker = Ticker 
drop Ticker 
sort ticker
merge 1:m ticker using  kyper_ticker_returns.dta
drop if missing(NumericESG)
drop if missing(collapse_id)
drop collapse_id 
sort SICfirstNumber decile_screen  mmonth cal_year 
*drops 5 low!!
egen collapse_id = group(SICfirstNumber decile_screen mmonth cal_year )
collapse (mean) retx (lastnm) kypermno cal_year mmonth decile_screen SICfirstNumber, by(collapse_id)
drop collapse_id
gen low_ESG = retx if decile_screen==10
gen high_ESG = retx if decile_screen==1
egen collapse_id = group(SICfirstNumber cal_year mmonth  )
collapse (mean) high_ESG low_ESG (lastnm) kypermno cal_year mmonth SICfirstNumber, by(collapse_id)
sort SICfirstNumber  cal_year mmonth
gen industry_ESG_factor = high_ESG-low_ESG
drop low_ESG high_ESG collapse_id kypermno
egen indexy_time_var = group(cal_year mmonth)
save industry_ESG_factor.dta, replace 



*******Merging onto data using SIC code!*********
*making SIC kypermno index
use StockNameData,clear
tostring siccd, replace
generate sic_onedigit = substr(siccd,1,1)
gen SICfirstNumber = real(sic_onedigit)
drop siccd namedt nameenddt ncusip ticker comnam shrcls ncusip9 shrcd exchcd tsymbol snaics primexch trdstat secstat sic_onedigit
save kypermno_sic_codes.dta, replace
** this came from "dealing with preranking directly"
use returns_factors_with_potfolios, clear
*merge SIC
merge m:m kypermno using kypermno_sic_codes
drop _merge
drop if missing(mmonth)
drop if SICfirstNumber  == 5
drop if SICfirstNumber  == 9
drop if SICfirstNumber  == 0
sort cal_year mmonth
egen indexy_time_var = group(cal_year mmonth)
* what this
merge m:m indexy_time_var using industry_ESG_factor.dta
drop _merge
drop esg_minus_rf
sort cal_year mmonth SICfirstNumber size_ports
egen unique_tmie_SIC_size = group(cal_year mmonth SICfirstNumber size_ports)

collapse (mean) expected_return_stock hml smb rmw cma industry_ESG_factor market_minus_rf (lastnm)indexy_time_var mmonth cal_year SICfirstNumber size_ports, by(unique_tmie_SIC_size)
save SIC_size_porfolios.dta , replace



**** Actually running the FMB now
cls

****** size based porfolios 1
use SIC_size_porfolios, clear



drop if SICfirstNumber !=1

gen emp = industry_ESG_factor
drop  industry_ESG_factor
xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody)
outreg2 using Industry_FF_pass_2.tex, replace ctitle(SIC 1) tex(fragment)
****** size based porfolios 2
use SIC_size_porfolios, clear



drop if SICfirstNumber !=2

gen emp = industry_ESG_factor
drop  industry_ESG_factor
xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody)
outreg2 using Industry_FF_pass_2.tex, append ctitle(SIC 2) tex(fragment)

****** size based porfolios 3
use SIC_size_porfolios, clear



drop if SICfirstNumber !=3

gen emp = industry_ESG_factor
drop  industry_ESG_factor
xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody)
outreg2 using Industry_FF_pass_2.tex, append ctitle(SIC 3) tex(fragment)

****** size based porfolios 4
use SIC_size_porfolios, clear



drop if SICfirstNumber !=4

gen emp = industry_ESG_factor
drop  industry_ESG_factor
xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody)
outreg2 using Industry_FF_pass_2.tex, append ctitle(SIC 4) tex(fragment)

****** size based porfolios 6
use SIC_size_porfolios, clear



drop if SICfirstNumber !=6

gen emp = industry_ESG_factor
drop  industry_ESG_factor
xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody)
outreg2 using Industry_FF_pass_2.tex, append ctitle(SIC 6) tex(fragment)


****** size based porfolios 7
use SIC_size_porfolios, clear



drop if SICfirstNumber !=7

gen emp = industry_ESG_factor
drop  industry_ESG_factor
xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody)
outreg2 using Industry_FF_pass_2.tex, append ctitle(SIC 7) tex(fragment)

****** size based porfolios 8
use SIC_size_porfolios, clear



drop if SICfirstNumber !=8

gen emp = industry_ESG_factor
drop  industry_ESG_factor
xtset indexy_time_var size_ports 
asreg expected_return_stock market_minus_rf  hml smb rmw cma emp, fmb newey(1) first save(parody)
outreg2 using Industry_FF_pass_2.tex, append ctitle(SIC 8) tex(fragment)

