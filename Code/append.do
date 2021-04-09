clear
cd /Users/matt/Final_Paper_Git/Code/data/CRSP_stock_files/daily_files/primary
use sfz_dp_1971_1980.dta, clear

summarize kypermno cal_year 
append using sfz_dp_1981_1990
append using sfz_dp_1991_2000
append using sfz_dp_2001_2010
append using sfz_dp_2011_2020
summarize kypermno cal_year 
save full_data_set.dta, replace

