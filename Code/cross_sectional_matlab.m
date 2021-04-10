%Matt Chistolini
%Last edited 3/5/21
clear; clc;
A = readtable("out_of_stata_five_factor.csv");
porflio_number = A{:,3};
mtrex = A{:,4};
hml = A{:,5};
smb = A{:,6};
rmw = A{:,7}
cma = A{:,8};
modate = A{:,9};
time_index = A{:,10};

%% the show!!
out_for_reg_1 = [];
counter = 0;
for i = 1:length(porflio_number)-1
    
    current_stock = porflio_number(i);
    next_stock =porflio_number(i+1);
    
    if current_stock == 100;
        returns_i = mtrex(i-counter:end); 
        hml_i = hml(i-counter:end);
        smb_i = smb(i-counter:end);
        rmw_i= rmw(i-counter:end);
        cma_i = cma(i-counter:end);
        factors = [hml_i smb_i rmw_i cma_i ];
        reg_1 = regress(returns_i, factors);
        out_for_reg_1 = [out_for_reg_1 reg_1];
        break
    end
    
    if current_stock == next_stock
        
        counter = counter+1;
    else
        if counter >2
        returns_i = mtrex(i-counter:i); 
        hml_i = hml(i-counter:i);
        smb_i = smb(i-counter:i);
        rmw_i= rmw(i-counter:i);
        cma_i = cma(i-counter:i);
        factors = [hml_i smb_i rmw_i cma_i ];
        reg_1 = regress(returns_i, factors);
        out_for_reg_1 = [out_for_reg_1 reg_1];
        counter = 0;
        end 
    end
end

%% Part 2: Second Regression

time_length = max(time_index);
out_for_reg_2 =[];
counter = 0;
for t = 1:1:time_length
    counter=counter+1;
    index_values = find(time_index ==t);
    reg_2 = regress(mtrex(index_values),out_for_reg_1'); 
    out_for_reg_2 = [out_for_reg_2 reg_2];
end   
%% finding averages and STD

beta_avg = mean(out_for_reg_2')*100 % in percent 
beta_std = std(out_for_reg_2')./sqrt(time_length)






