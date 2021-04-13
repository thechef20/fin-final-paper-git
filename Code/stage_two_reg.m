function f = stage_two_reg(A,out_for_reg_1)
time_index = A{:,11};
expected_return_stock = A{:,4};
time_length = max(time_index);
out_for_reg_2 =[];
counter = 0;
for t = 1:1:time_length
    counter=counter+1;
    index_values = find(time_index ==t);
    
    reg_2 = regress(expected_return_stock(index_values),out_for_reg_1'); 
    out_for_reg_2 = [out_for_reg_2 reg_2];
end   
f = out_for_reg_2;
end