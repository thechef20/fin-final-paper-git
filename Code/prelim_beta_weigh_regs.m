%Matt Chistolini
%Last edited 4/12/21
clear; clc;
%importing data
A = readtable("data/size_porflios_and_returns.csv");
%

out_for_reg_1 = stage_one_reg(A,1)
out_for_reg_total_coff = stage_one_reg(A,2)
out_for_reg_SE = stage_one_reg(A,3)
%%

f = stage_two_reg(A,out_for_reg_1,"SE")
%% Mean STD

time_index = A{:,11};
time_length = max(time_index);

beta_avg = mean(f')*100 % in percent 
beta_std = std(f')./sqrt(time_length)

