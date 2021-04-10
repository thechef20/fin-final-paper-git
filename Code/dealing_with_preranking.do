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


*** NOTE: We are using the ESG as the beta decile ***
* xtile but fastest!
*we are cleaning some of the extremes from either end of the beta range
astile beta_decile_toss=pre_ranked_esg, nq(25) by(firm_time_id)
drop if beta_decile_toss == 1
drop if beta_decile_toss == 25 
drop if tcap < 10000
drop beta_decile_toss
sum pre_ranked_esg

astile beta_decile=pre_ranked_esg, nq(10) by(firm_time_id)
sort kypermno cal_year mmonth pre_ranked_esg mpportnum
export delimited using end_of_step_3_stata.csv, replace

save merged_portfolio_and_preranked_beta_data.dta, replace

*new sort that will be used to merge the post rank beta my market weight and beta weight
sort beta_decile mpportnum
egen unique_beta_and_mpportnum = group(beta_decile mpportnum)

save input_for_crosssectional.dta, replace

