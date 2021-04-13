%Matt Chistolini
%Last edited 4/12/21
clear; clc;
A = readtable("data/size_porflios_and_returns.csv");
porflio_number = A{:,3};
expected_return_stock = A{:,4};
hml = A{:,5};
smb = A{:,6};
rmw = A{:,7};
cma = A{:,8};
esg_factor = A{:,9};
market_factor = A{:,10};
time_index = A{:,11};

%% the show!!
out_for_reg_1 = [];
counter = 0;
for i = 1:length(porflio_number)-1
    
    current_stock = porflio_number(i);
    next_stock =porflio_number(i+1);
    
    if current_stock == 10
        returns_i = expected_return_stock(i-counter:end); 
        hml_i = hml(i-counter:end);
        smb_i = smb(i-counter:end);
        rmw_i= rmw(i-counter:end);
        cma_i = cma(i-counter:end);
        esg_factor_i = esg_factor(i-counter:end);
        market_factor_i =market_factor(i-counter:end);
        %factors = [hml_i smb_i rmw_i cma_i  esg_factor_i];
        factors_w_market = [market_factor_i hml_i smb_i rmw_i cma_i  esg_factor_i];
        %reg_1 = regress(returns_i, factors);
        reg_1 = fitlm(returns_i, factors_w_market)
        out_for_reg_1 = [out_for_reg_1 reg_1];
        break
    end
    
    if current_stock == next_stock
        
        counter = counter+1;
    else
        if counter >2
        returns_i = expected_return_stock(i-counter:i);
         
        hml_i = hml(i-counter:i);
        smb_i = smb(i-counter:i);
        rmw_i= rmw(i-counter:i);
        cma_i = cma(i-counter:i);
        esg_factor_i = esg_factor(i-counter:i);
        market_factor_i =market_factor(i-counter:i);
        %factors = [hml_i smb_i rmw_i cma_i esg_factor_i];
        factors_w_market = [market_factor_i hml_i smb_i rmw_i cma_i  esg_factor_i];
        tabl = table(market_factor_i, hml_i, smb_i, rmw_i, cma_i,  esg_factor_i,returns_i)
        %reg_1 = regress(returns_i, factors);
        %reg_1 = regress(returns_i, factors_w_market);
        %reg_1 = regress(returns_i, factors_w_market);
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
    index_values = find(time_index ==t)
    
    reg_2 = regress(expected_return_stock(index_values),out_for_reg_1'); 
    out_for_reg_2 = [out_for_reg_2 reg_2];
end   
%% finding averages and STD

beta_avg = mean(out_for_reg_2')*100 % in percent 
beta_std = std(out_for_reg_2')./sqrt(time_length)


%% New analysis 
% idk if this is the right shape
hml_reg_points = out_for_reg_1(1,:);
B = reshape(hml_reg_points,[5,2])



