clear 
cls
*Matthew Chistolini
*Last Edited: 4/9/21

* Setting up workspace
*ssc install astile
*help astile

cd /Users/matt/Final_Paper_Git/Code/data

import delimited using pre_rank_table.csv,clear
*removing data where the years don't have data data b/c it is less than 2 yr
drop if missing(pre_ranked_esg)
save pre_rank_table.dta, replace


*import data on the portoflios
use sfz_portm,clear 
gen cal_year = annual
drop  annual
*get rid of the profolios which do not add value
drop if mpindno>1000091 
drop if mpindno<1000082
save porflio_weights_data_clean.dta, replace

*this file came from MATLAB
use pre_rank_table , clear
*meging the market weight prolfios onto to data
merge m:1 kypermno cal_year using porflio_weights_data_clean.dta 
keep if _merge == 3
drop _merge
drop mppflg
drop keyset
drop mpstat
drop mpindno
sort kypermno cal_year mmonth
egen firm_time_id = group(mpportnum cal_year mmonth)

save pre_cleaned_preranking_decile.dta, replace

*** NOTE: We are NOTE using the ESG as the beta decile ***
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
sum
*I removed the by(firm_time_id) 
astile beta_decile=pre_ranked_beta_market, nq(10) by(firm_time_id)
*astile beta_decile=pre_ranked_beta_market, nq(10)

sort  beta_decile mpportnum
egen unique_beta_and_mpportnum = group(beta_decile mpportnum)

sort kypermno cal_year mmonth pre_ranked_beta_market mpportnum

save merged_portfolio_and_preranked_beta_data.dta, replace









*new sort that will be used to merge the post rank beta my market weight and beta weight


*save input_for_crosssectional.dta, replace

