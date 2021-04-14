function f = stage_two_reg(A,out_for_reg_1,options)
time_index = A{:,11};
expected_return_stock = A{:,4};
time_length = max(time_index);
out_for_reg_2 =[];
out_for_reg_2_w_a=[];
all_SE=[];
counter = 0;
for t = 1:1:time_length
    counter=counter+1;
    index_values = find(time_index ==t);
    LLL=out_for_reg_1';
    tbl = table (LLL(:,1),LLL(:,2),LLL(:,3),LLL(:,4),LLL(:,5), LLL(:,6), expected_return_stock(index_values));
    reg_2 = fitlm(tbl);
    cofficents_include_a= table2array(reg_2.Coefficients(:,1));
    SE_individual = table2array(reg_2.Coefficients(:,2));
    cofficents_no_a = cofficents_include_a(2:end);
    out_for_reg_2 = [out_for_reg_2 cofficents_no_a];
    out_for_reg_2_w_a= [out_for_reg_2_w_a cofficents_include_a];
    all_SE = [all_SE  SE_individual];
end   
if options == "a_plz"
    f = out_for_reg_2_w_a;
elseif options == "no_a"
    f = out_for_reg_2;
elseif  options == "SE"
    f =all_SE;
end

end

