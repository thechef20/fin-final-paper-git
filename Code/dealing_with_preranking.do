clear 
cls
*Matthew Chistolini
*Last Edited: 4/28/21

* Setting up workspace
*ssc install astile
*help astile
*ssc install estout, replace

cd /Users/matt/Final_Paper_Git/Code/data

import delimited using ESG_and_five_factors.csv,clear
save pre_rank_table.dta, replace

*creating summary table

drop kypermno
drop cal_year
gen EMP = esg_minus_rf
drop  esg_minus_rf
gen excess_returns  = expected_return_stock
drop expected_return_stock
drop mmonth
*eststo: quietly
eststo clear
eststo: estpost summarize excess_returns market_minus_rf hml smb rmw cma EMP tcap
*est store a 

esttab using desc1.tex, cells("mean sd min max") replace  nodepvar


*import data on the equle weight portoflios
use sfz_portm,clear 
gen cal_year = annual
drop  annual
*get rid of the profolios which do not add value
drop if mpindno>1000091 
drop if mpindno<1000082
save equal_market_cap_proflios.dta, replace

*import data on the beta decile portoflios
use sfz_portd,clear 
gen cal_year = annual
drop  annual
*get rid of the portfolios which do not add value
drop if pindno>1000111 
drop if pindno<1000102
save equal_beta_weights_data_clean.dta, replace



use pre_rank_table , clear
*meging the market weight prolfios onto to data
merge m:1 kypermno cal_year using equal_market_cap_proflios.dta 
keep if _merge == 3
drop _merge
drop mppflg
drop keyset
drop mpstat
drop mpindno
gen size_ports = mpportnum
drop mpportnum
sort kypermno cal_year mmonth
egen firm_time_id_weight = group(size_ports cal_year mmonth)

*merging the beta portfolios onto to data
merge m:1 kypermno cal_year using equal_beta_weights_data_clean.dta 


keep if _merge == 3
drop _merge
drop ppflg
drop keyset
drop pstat
drop pindno
gen beta_ports = pportnum
drop pportnum
sort kypermno cal_year mmonth

save returns_factors_with_potfolios.dta, replace












******** This should probs be its own doc********


*size porlfios first
use returns_factors_with_potfolios.dta, clear

sort size_ports 
collapse (mean) expected_return_stock hml smb rmw cma esg_minus_rf market_minus_rf, by(size_ports cal_year mmonth)
sort cal_year mmonth
egen indexy_time_var = group(cal_year mmonth)
sort size_ports cal_year mmonth
export delimited "size_porflios_and_returns.csv",replace


*building summary tables 
eststo clear
gen excess_returns  = expected_return_stock
gen EMP = esg_minus_rf
drop  esg_minus_rf
drop expected_return_stock
estpost tabstat excess_returns market_minus_rf hml smb rmw cma EMP, by(size_ports) statistics(mean) columns(statistics) listwise
*est store size

esttab using size_summary_stat_size.tex, cells("mean(fmt(4))") replace label nonote nomtitle nonumber nostar unstack 




*beta porlfios first
use returns_factors_with_potfolios.dta, clear

sort beta_ports 
collapse (mean) expected_return_stock hml smb rmw cma esg_minus_rf market_minus_rf, by(beta_ports cal_year mmonth)
sort cal_year mmonth
egen indexy_time_var = group(cal_year mmonth)
sort beta_ports cal_year mmonth
export delimited "beta_porflios_and_returns.csv",replace



/* we are killing this 
* xtile but fastest!
*we are cleaning some of the extremes from either end of the beta range
sum
sort pre_ranked_beta_market
astile beta_decile_toss=pre_ranked_beta_market, nq(25) 
gen beta_decile_toss_min = beta_decile_toss
gen min_market = 1 if  tcap < 10000
collapse (max)  beta_decile_toss (min) min_market beta_decile_toss_min, by(kypermno)
drop if  (min_market == 1) |(beta_decile_toss_min<2 | beta_decile_toss>24)
sort beta_decile_toss
gen beta_to_keep = 1
drop min_market beta_decile_toss
save cleaned_preranking_decile.dta, replace



use pre_cleaned_preranking_decile.dta,clear
merge m:1  kypermno using cleaned_preranking_decile.dta
drop if missing(beta_to_keep)
drop beta_to_keep

drop _merge
*** shrink to big and small
gen holder = 1 if mpportnum>5
replace holder = 2 if mpportnum<6
drop mpportnum
gen mpportnum = holder
sum
*I removed the by(firm_time_id) 
astile beta_decile=pre_ranked_beta_market, nq(5) by(firm_time_id)
*astile beta_decile=pre_ranked_beta_market, nq(10)

sort  beta_decile mpportnum
egen unique_beta_and_mpportnum = group(beta_decile mpportnum)

sort kypermno cal_year mmonth pre_ranked_beta_market mpportnum

save merged_portfolio_and_preranked_beta_data.dta, replace
*/









*new sort that will be used to merge the post rank beta my market weight and beta weight


*save input_for_crosssectional.dta, replace

