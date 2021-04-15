%Matt Chistolini
%Last edited 4/12/21
clear; clc;
%importing data
A = readtable("data/size_porflios_and_returns.csv");
%Step 1

out_for_reg_1 = stage_one_reg(A,1);

out_for_reg_total_coff = stage_one_reg(A,2);
out_for_reg_SE = stage_one_reg(A,3);
% SE is actually p-valus ATM (4/14/21)
f = stage_two_reg(A,out_for_reg_1,"SE")
%Step 2
time_index = A{:,11};
time_length = max(time_index);
%averages and shit
beta_avg = mean(f')' %not precent basedintercept
market-rf
hml
smb
rmw
cma
EMP
beta_std = std(f')./sqrt(time_length)

%% Same thing with beta
A = readtable("data/beta_porflios_and_returns.csv");
%Step 1

out_for_reg_1 = stage_one_reg(A,1)

out_for_reg_total_coff = stage_one_reg(A,2)
out_for_reg_SE = stage_one_reg(A,3)

f = stage_two_reg(A,out_for_reg_1,"SE")
%Step 2
time_index = A{:,11};
time_length = max(time_index);
%averages and shit
beta_avg = mean(f')' % not in percent 
beta_std = std(f')./sqrt(time_length)



