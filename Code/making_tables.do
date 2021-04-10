clear 
cls
*Matthew Chistolini
*Last Edited: 4/9/21

* Setting up workspace
cd /Users/matt/Final_Paper_Git/Code/data

use merged_portfolio_and_preranked_beta_data

* Building the table

*Table 1A
collapse (mean) expected_return_stock, by(mpportnum beta_decile)
sort mpportnum beta_decile

reshape wide expected_return_stock, i(mpportnum) j(beta_decile)

export delimited using "excel_table/table_1_A", replace 

* Table 2=1B
use merged_portfolio_and_preranked_beta_data, clear

collapse (mean) pre_ranked_beta, by(mpportnum beta_decile)
sort mpportnum beta_decile

reshape wide pre_ranked_beta, i(mpportnum) j(beta_decile)

export delimited using "excel_table/table_1_B_postranked", replace

* Table 2=1C
use merged_portfolio_and_preranked_beta_data, clear
gen mcap1000 = tcap*1000
gen mcap_log = log10(mcap1000)

collapse (mean) mcap_log, by(mpportnum beta_decile)
sort mpportnum beta_decile

reshape wide mcap_log, i(mpportnum) j(beta_decile)

export delimited using "excel_table/table_1_C_Size", replace
