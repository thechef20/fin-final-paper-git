clear 
cls
*Matthew Chistolini
*Last Edited: 4/9/21

* Setting up workspace
cd /Users/matt/Final_Paper_Git/Code/data




*Table 1A RETURNS
use merged_portfolio_and_preranked_beta_data, clear

collapse (mean) expected_return_stock, by(mpportnum beta_decile)
sort mpportnum beta_decile

gen expected_stock_with_beta_mkcap = expected_return_stock
drop expected_return_stock

sort beta_decile mpportnum
egen unique_beta_and_mpportnum = group(beta_decile mpportnum)

save returns_part_1.dta, replace
use input_for_crosssectional, clear 


merge m:1 unique_beta_and_mpportnum using returns_part_1.dta
drop _merge
save output_for_crosssectional.dta, replace


* Table 2=1B POST BETA
use merged_portfolio_and_preranked_beta_data, clear

collapse (mean) pre_ranked_beta, by(mpportnum beta_decile)
sort mpportnum beta_decile


gen average_pre_rank_beta = pre_ranked_beta
drop pre_ranked_beta

sort beta_decile mpportnum
egen unique_beta_and_mpportnum = group(beta_decile mpportnum)

save returns_part_2.dta, replace
use output_for_crosssectional, clear
merge m:1 unique_beta_and_mpportnum using returns_part_2.dta
drop _merge
save output_for_crosssectional.dta, replace



* Table 2=1C LOG SIZE
use merged_portfolio_and_preranked_beta_data, clear
gen mcap_log = log10(mtcap*1000)

collapse (mean) mcap_log, by(mpportnum beta_decile)
sort mpportnum beta_decile
****
*insert setp 5 code*
****

gen average_mcap_log = mcap_log
drop mcap_log

sort beta_decile mpportnum
egen unique_beta_and_mpportnum = group(beta_decile mpportnum)

save returns_part_3.dta, replace
use output_for_crosssectional, clear
merge m:1 unique_beta_and_mpportnum using returns_part_3.dta
drop _merge

*adding year and month singular variable (easier in matlab)
sort annual mmonth
egen indexy_time_var = group(annual mmonth)
sort kypermno annual mmonth
*save output_for_crosssectional_final.dta, replace
*export delimited using "matlab_returning_for_crosssectional.csv", replace




