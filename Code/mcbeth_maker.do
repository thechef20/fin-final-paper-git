clear 
cls
*Matthew Chistolini
*Last Edited: 4/10/21

* Setting up workspace
cd /Users/matt/Final_Paper_Git/Code/data

* the point of this is to replace the worl "mmonths" with annual for merging purposes
use merged_portfolio_and_preranked_beta_data, clear

sort unique_beta_and_mpportnum 
collapse (mean) expected_return_stock hml smb rmw cma pre_ranked_esg, by(unique_beta_and_mpportnum cal_year mmonth)
sort cal_year mmonth
egen indexy_time_var = group(cal_year mmonth)
sort unique_beta_and_mpportnum cal_year mmonth
export delimited "out_of_stata_six_factor.csv",replace


