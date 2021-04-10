clear 
cls
*Matthew Chistolini
*Last Edited: 4/9/21

* Setting up workspace
*ssc install gtools
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

* xtile but faster!
fasterxtile beta_decile = (pre_ranked_beta), by(firm_time_id) nq(10)
*this sort gives me fear
sort kypermno annual mmonth beta_decile mpportnum
export delimited using end_of_step_3_stata.csv, replace

save merged_portfolio_and_preranked_beta_data.dta, replace

*new sort that will be used to merge the post rank beta my market weight and beta weight
sort beta_decile mpportnum
egen unique_beta_and_mpportnum = group(beta_decile mpportnum)
save input_for_crosssectional.dta, replace

